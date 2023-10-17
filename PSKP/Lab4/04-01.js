const http = require('http');
const url = require('url');
const { EventEmitter } = require('events');
const { DB } = require('./db');
const db = new DB();

const server = http.createServer((req, res) => {
    const { pathname, query } = url.parse(req.url, true);

    if (pathname === '/api/db' && req.method === 'GET') {
        db.emit('get', res);
    } else if (pathname === '/api/db' && req.method === 'POST') {
        let data = '';

        req.on('data', (chunk) => {
            data += chunk;
        });

        req.on('end', () => {
            try {
                const jsonData = JSON.parse(data);
                db.emit('post', res, jsonData);
            } catch (error) {
                res.writeHead(400, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ error: 'Invalid JSON format' }));
            }
        });
    } // Обновленная функция для обработки PUT-запроса
    else if (pathname === '/api/db' && req.method === 'PUT') {
        let data = '';

        req.on('data', (chunk) => {
            data += chunk;
        });

        req.on('end', () => {
            try {
                const jsonData = JSON.parse(data);
                const id = url.parse(req.url, true).query.id; // Получение id из query параметра

                db.update(res, id, jsonData);
            } catch (error) {
                res.writeHead(400, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ error: 'Invalid JSON format' }));
            }
        });
    } else if (pathname === '/api/db' && req.method === 'DELETE') {
        db.emit('delete', res, query.id);
    } else {
        res.writeHead(404, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify({ error: 'Not Found' }));
    }
});

const PORT = 5000;

server.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
