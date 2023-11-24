const fs = require('fs');
const WebSocket = require('ws');

const wss = new WebSocket.Server({ port: 4000 });

wss.on('connection', ws => {
    ws.on('message', fileData => {
        const fileName = `file-${Date.now()}.txt`;
        fs.writeFile(fileName, fileData, err => {
            if (err) {
                console.error(err);
                return;
            }
            console.log(`File ${fileName} saved successfully.`);
        });
    });
});