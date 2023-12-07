const WebSocket = require('ws');

const clientName = process.argv[2]; // Получаем имя клиента из аргумента командной строки

const ws = new WebSocket('ws://localhost:4000');

ws.on('open', () => {
    console.log('Connected to WebSocket server');
});

ws.on('message', message => {
    const data = JSON.parse(message);
    const server = data.server;
    const client = data.client;
    const timestamp = data.timestamp;

    console.log(`Received message from server: server=${server}, client=${client}, timestamp=${timestamp}`);
});

ws.on('close', () => {
    console.log('Disconnected from WebSocket server');
});

ws.on('error', error => {
    console.error('WebSocket error:', error);
});

// Функция для отправки сообщения на сервер
function sendMessage() {
    const timestamp = new Date().getTime();

    const message = JSON.stringify({
        client: clientName,
        timestamp: timestamp
    });

    ws.send(message);
}

// Отправка сообщения каждые 5 секунд
setInterval(sendMessage, 5000);