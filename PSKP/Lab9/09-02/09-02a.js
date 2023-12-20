const WebSocket = require('ws');
const fs = require('fs');

const ws = new WebSocket('ws://localhost:4000');

ws.on('open', () => {
    const duplex = WebSocket.createWebSocketStream(ws);
    const wfile = fs.createWriteStream(`./download/NewFile.txt`);
    duplex.pipe(wfile);

    wfile.on('finish', () => {
        console.log('File saved');
    });
});
