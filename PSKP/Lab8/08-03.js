const WebSocket = require('ws');

const wsServer = new WebSocket.Server({ port: 5000 });

wsServer.on('connection', (ws) => {
    ws.on('message', (message) => {
        console.log('08-03 server received message:', message.toString());

        // Отправляем сообщение всем клиентам
        wsServer.clients.forEach((client) => {
            if (client.readyState === WebSocket.OPEN) {
                client.send(message);
            }
        });
    });
    ws.on('close', function() {
        console.log('Server closed connection');
    });
});

console.log('08-03 server is listening on port 5000');