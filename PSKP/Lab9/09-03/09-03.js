const WebSocket = require('ws');

const wss = new WebSocket.Server({ port: 4000 });

let messageCounter = 1;

// Функция для отправки сообщения клиентам
function sendServerMessage() {
    const message = `09-03-server: ${messageCounter}`;

    wss.clients.forEach(client => {
        if (client.readyState === WebSocket.OPEN) {
            client.send(message);
        }
    });

    messageCounter++;
}

// Отправка сообщения каждые 15 секунд
setInterval(sendServerMessage, 15000);

// Проверка работоспособности соединений каждые 5 секунд
setInterval(() => {
    let activeConnections = 0;

    wss.clients.forEach(client => {
        if (client.readyState === WebSocket.OPEN) {
            activeConnections++;
        }
    });

    console.log(`Active connections: ${activeConnections}`);
}, 5000);

console.log('WebSocket server started on port 4000');