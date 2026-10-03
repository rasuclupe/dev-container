#!/usr/bin/env bash
# Instalación de dependencias del proyecto poliglota.
# Se invoca desde 'onCreateCommand' para que SÍ entre en el prebuild (Lab 2).
set -euo pipefail
 
echo "==> Dependencias de la API (Node)"
cd api
npm ci 2>/dev/null || npm install
cd ..
 
echo "==> Dependencias del componente de datos (Python)"
pip install --no-cache-dir -r datos/requirements.txt
 
echo "==> Inicializando Terraform"
cd infra
terraform init -input=false -backend=false
cd ..
 
echo "==> Permisos de los scripts"
chmod +x scripts/*.sh
 
echo "Setup completado."