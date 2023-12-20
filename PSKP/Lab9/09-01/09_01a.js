const WebSocket = require('ws');
const fs = require("fs");

const ws = new WebSocket('ws://localhost:4000');

ws.on('open', () => {
    const duplex=WebSocket.createWebSocketStream(ws);
    let rfile=fs.createReadStream(`./upload/file.txt`);
    rfile.pipe(duplex);
});
