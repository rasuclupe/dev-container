const test = require('node:test');
const assert = require('node:assert');
const { valorTotal, bajoStock } = require('../src/inventario');

const items = [
  { nombre: 'teclado', precio: 50, cantidad: 10 },
  { nombre: 'mouse', precio: 25, cantidad: 3 },
  { nombre: 'monitor', precio: 200, cantidad: 2 },
];

test('valorTotal suma precio por cantidad', () => {
  assert.strictEqual(valorTotal(items), 50 * 10 + 25 * 3 + 200 * 2);
});

test('bajoStock detecta items bajo el umbral', () => {
  assert.deepStrictEqual(bajoStock(items, 5), ['mouse', 'monitor']);
});

test('valorTotal con lista vacía es 0', () => {
  assert.strictEqual(valorTotal([]), 0);
});
