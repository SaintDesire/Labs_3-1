const WebSocket = require('ws');

const ws = new WebSocket('ws://localhost:4000');

ws.on('open', () => {
    console.log('Connected to WebSocket server');
});

ws.on('message', message => {
    console.log(`Received notification: ${message}`);
});

ws.on('close', () => {
    console.log('Disconnected from WebSocket server');
});

process.stdin.on('data', data => {
    const input = data.toString().trim();

    if (input === 'A' || input === 'B' || input === 'C') {
        ws.send(input);
    }
});