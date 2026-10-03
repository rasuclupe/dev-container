// Lógica de negocio: cálculo de inventario. Testeable sin abrir puertos.
function valorTotal(items) {
  return items.reduce((acc, it) => acc + it.precio * it.cantidad, 0);
}

function bajoStock(items, umbral = 5) {
  return items.filter((it) => it.cantidad < umbral).map((it) => it.nombre);
}

module.exports = { valorTotal, bajoStock };
