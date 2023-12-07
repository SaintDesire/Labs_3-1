const fs = require('fs');
const WebSocket = require('ws');

const wss = new WebSocket.Server({ port: 4000 });

wss.on('connection', ws => {
    const duplex = WebSocket.createWebSocketStream(ws);
    const wfile = fs.createWriteStream(`./upload/NewFile.txt`);
    duplex.pipe(wfile);

    wfile.on('finish', () => {
        console.log('File saved');
    });
});