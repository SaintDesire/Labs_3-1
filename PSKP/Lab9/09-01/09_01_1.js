const WebSocket = require('ws');

const ws = new WebSocket('ws://localhost:4000');

ws.on('open', () => {
    const fileData = 'Testing file transfer';
    ws.send(fileData);
});

ws.on('message', message => {
    console.log(`Received message from server: ${message}`);
});