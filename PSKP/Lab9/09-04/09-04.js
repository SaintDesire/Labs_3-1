const WebSocket = require('ws');

const wss = new WebSocket.Server({ port: 4000 });

let messageCounter = 1;

wss.on('connection', ws => {
    ws.on('message', message => {
        const data = JSON.parse(message);
        const client = data.client;
        const timestamp = data.timestamp;

        const response = JSON.stringify({
            server: messageCounter,
            client: client,
            timestamp: timestamp
        });

        ws.send(response);
        messageCounter++;
    });
});

console.log('WebSocket server started on port 4000');