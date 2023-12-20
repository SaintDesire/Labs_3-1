const WebSocket = require('ws');

const wss = new WebSocket.Server({ port: 4000 });

wss.on('connection', ws => {
    console.log('Connected to WebSocket client');

    ws.on('message', message => {
        const notification = message.toString().trim();

        if (notification === 'A' || notification === 'B' || notification === 'C') {
            console.log(`Received notification: ${notification}`);
        } else {
            console.log('Invalid notification');
        }
    });
});

console.log('WebSocket server started on port 4000');