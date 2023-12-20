const WebSocket = require('ws');

const ws = new WebSocket('ws://localhost:4000');

ws.on('open', () => {
    console.log('Connected to WebSocket server');
});

ws.on('message', message => {
    console.log('Received message:', message.toString());
});

ws.on('close', () => {
    console.log('Disconnected from WebSocket server');
});