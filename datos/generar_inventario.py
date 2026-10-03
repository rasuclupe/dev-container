"""
Componente Python del proyecto poliglota (Módulo 6).

Genera el CSV de inventario que luego consume la API de Node.
Sin dependencias externas: usa solo la librería estándar, para que el
Codespace arranque rápido y el laboratorio no dependa de la red.
"""
import csv
import os
import random
from pathlib import Path

SALIDA = Path(__file__).parent / "salida" / "inventario.csv"

PRODUCTOS = [
    ("teclado", 50.0),
    ("mouse", 25.0),
    ("monitor", 200.0),
    ("webcam", 80.0),
    ("auriculares", 60.0),
]


def generar(semilla: int = 42) -> list[dict]:
    """Genera la lista de items con cantidades pseudoaleatorias reproducibles."""
    rng = random.Random(semilla)
    return [
        {"nombre": nombre, "precio": precio, "cantidad": rng.randint(1, 15)}
        for nombre, precio in PRODUCTOS
    ]


def escribir_csv(items: list[dict], destino: Path = SALIDA) -> Path:
    destino.parent.mkdir(parents=True, exist_ok=True)
    with open(destino, "w", newline="", encoding="utf-8") as fh:
        # lineterminator="\n": csv usa \r\n por defecto (RFC 4180). Forzamos \n
        # para que el CSV sea identico en cualquier SO y facil de parsear.
        writer = csv.DictWriter(
            fh,
            fieldnames=["nombre", "precio", "cantidad"],
            lineterminator="\n",
        )
        writer.writeheader()
        writer.writerows(items)
    return destino


def main() -> None:
    items = generar()
    ruta = escribir_csv(items)
    total = sum(i["precio"] * i["cantidad"] for i in items)
    print(f"Generados {len(items)} items en {ruta}")
    print(f"Valor total del inventario: {total:.2f}")


if __name__ == "__main__":
    main()
