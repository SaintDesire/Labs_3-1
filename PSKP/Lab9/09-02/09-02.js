const WebSocket=require('ws');
const fs=require('fs');

const wsserver=new WebSocket.Server({port: 4000, host: 'localhost'});
wsserver.on('connection', (ws)=>{
    const duplex=WebSocket.createWebSocketStream(ws);
    let rfile=fs.createReadStream(`./download/download.txt`);
    rfile.pipe(duplex);
});