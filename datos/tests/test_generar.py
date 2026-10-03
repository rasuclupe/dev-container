"""Tests del componente Python. Se ejecutan con pytest o con unittest."""
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent.parent))

from generar_inventario import generar, escribir_csv  # noqa: E402


class TestGenerar(unittest.TestCase):
    def test_genera_cinco_productos(self):
        self.assertEqual(len(generar()), 5)

    def test_es_reproducible_con_la_misma_semilla(self):
        self.assertEqual(generar(42), generar(42))

    def test_cantidades_en_rango(self):
        for item in generar():
            self.assertGreaterEqual(item["cantidad"], 1)
            self.assertLessEqual(item["cantidad"], 15)

    def test_escribe_csv_con_cabecera(self):
        import tempfile

        with tempfile.TemporaryDirectory() as tmp:
            destino = Path(tmp) / "out" / "inv.csv"
            escribir_csv(generar(), destino)
            contenido = destino.read_text(encoding="utf-8")
            self.assertIn("nombre,precio,cantidad", contenido)


if __name__ == "__main__":
    unittest.main()
