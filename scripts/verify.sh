#!/usr/bin/env bash
# =============================================================================
# verify.sh — comprueba que el entorno de desarrollo está completo
# =============================================================================
# Convierte "creo que está bien configurado" en un check objetivo.
# Verifica que las tres herramientas del proyecto poliglota estén presentes
# y con la versión MAYOR esperada.
#
# Uso:  ./scripts/verify.sh
# Salida: 0 si todo está correcto, 1 si falta algo (con mensaje claro).
# =============================================================================
set -uo pipefail

# Versiones mayores esperadas (deben coincidir con .devcontainer/devcontainer.json)
NODE_ESPERADO=20
PYTHON_ESPERADO="3.11"
TERRAFORM_ESPERADO="1.9"

FALLOS=0
VERDE=$'\033[0;32m'; ROJO=$'\033[0;31m'; AMARILLO=$'\033[0;33m'; RESET=$'\033[0m'

ok()    { echo "${VERDE}  OK${RESET}      $*"; }
fallo() { echo "${ROJO}  FALTA${RESET}   $*"; FALLOS=$((FALLOS+1)); }
aviso() { echo "${AMARILLO}  AVISO${RESET}   $*"; }

echo "============================================="
echo " Verificación del entorno de desarrollo"
echo "============================================="
echo ""
echo "-- Herramientas requeridas --"

# ---- Node ----
if command -v node >/dev/null 2>&1; then
  NODE_VER=$(node --version | sed 's/^v//')
  NODE_MAJOR=${NODE_VER%%.*}
  if [ "$NODE_MAJOR" = "$NODE_ESPERADO" ]; then
    ok "node $NODE_VER (esperado mayor $NODE_ESPERADO)"
  else
    fallo "node $NODE_VER, pero se esperaba la versión mayor $NODE_ESPERADO"
  fi
else
  fallo "node no está instalado"
fi

# ---- Python ----
if command -v python3 >/dev/null 2>&1; then
  PY_VER=$(python3 --version 2>&1 | awk '{print $2}')
  PY_MINOR=$(echo "$PY_VER" | cut -d. -f1,2)
  if [ "$PY_MINOR" = "$PYTHON_ESPERADO" ]; then
    ok "python $PY_VER (esperado $PYTHON_ESPERADO)"
  else
    fallo "python $PY_VER, pero se esperaba $PYTHON_ESPERADO"
  fi
else
  fallo "python3 no está instalado"
fi

# ---- Terraform ----
if command -v terraform >/dev/null 2>&1; then
  TF_VER=$(terraform version -json 2>/dev/null | grep -o '"terraform_version":"[^"]*"' | cut -d'"' -f4)
  [ -z "$TF_VER" ] && TF_VER=$(terraform version | head -1 | sed 's/Terraform v//')
  TF_MINOR=$(echo "$TF_VER" | cut -d. -f1,2)
  if [ "$TF_MINOR" = "$TERRAFORM_ESPERADO" ]; then
    ok "terraform $TF_VER (esperado $TERRAFORM_ESPERADO)"
  else
    aviso "terraform $TF_VER (se esperaba $TERRAFORM_ESPERADO; no bloquea)"
  fi
else
  fallo "terraform no está instalado"
fi

# ---- GitHub CLI (deseable, no bloqueante) ----
if command -v gh >/dev/null 2>&1; then
  ok "gh $(gh --version | head -1 | awk '{print $3}')"
else
  aviso "gh (GitHub CLI) no está instalado — deseable, no bloqueante"
fi

echo ""
echo "-- Dependencias del proyecto --"

# ---- node_modules (solo si el proyecto tuviera dependencias) ----
if [ -d api/node_modules ] || [ ! -s api/package-lock.json ]; then
  ok "dependencias de la API resueltas"
else
  aviso "api/node_modules no existe (este proyecto no tiene dependencias externas)"
fi

# ---- pytest ----
if python3 -c "import pytest" >/dev/null 2>&1; then
  ok "pytest disponible"
else
  fallo "pytest no está instalado (revisa el postCreateCommand)"
fi

echo ""
echo "============================================="
if [ "$FALLOS" -eq 0 ]; then
  echo "${VERDE} Entorno COMPLETO: puedes empezar a trabajar.${RESET}"
  echo "============================================="
  exit 0
else
  echo "${ROJO} Entorno INCOMPLETO: $FALLOS verificación(es) fallaron.${RESET}"
  echo " Revisa .devcontainer/devcontainer.json y reconstruye el contenedor"
  echo " (Command Palette → 'Dev Containers: Rebuild Container')."
  echo "============================================="
  exit 1
fi
