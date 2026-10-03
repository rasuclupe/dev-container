const http = require('http');
const fs = require('fs');
const path = require('path');
const { valorTotal, bajoStock } = require('./inventario');

const PORT = process.env.PORT || 3000;

function cargarItems() {
  // Lee el CSV que produce el componente de Python (integración entre componentes)
  const csvPath = path.join(__dirname, '..', '..', 'datos', 'salida', 'inventario.csv');
  if (!fs.existsSync(csvPath)) return [];
  const lineas = fs
    .readFileSync(csvPath, 'utf8')
    .split(/\r?\n/)        // tolera CRLF y LF
    .map((l) => l.trim())
    .filter(Boolean)
    .slice(1);             // descarta la cabecera
  return lineas.map((l) => {
    const [nombre, precio, cantidad] = l.split(',');
    return { nombre, precio: Number(precio), cantidad: Number(cantidad) };
  });
}

const server = http.createServer((req, res) => {
  const { pathname } = new URL(req.url, `http://${req.headers.host}`);

  if (pathname === '/health') {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    return res.end(JSON.stringify({ status: 'ok', runtime: process.version }));
  }

  if (pathname === '/inventario') {
    const items = cargarItems();
    res.writeHead(200, { 'Content-Type': 'application/json' });
    return res.end(JSON.stringify({
      items: items.length,
      valorTotal: valorTotal(items),
      bajoStock: bajoStock(items),
    }, null, 2));
  }

  res.writeHead(404, { 'Content-Type': 'text/plain' });
  res.end('Not Found');
});

server.listen(PORT, () => console.log(`API escuchando en puerto ${PORT}`));
