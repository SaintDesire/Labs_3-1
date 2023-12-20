const net = require('net');

const serverPort = process.argv[2];
const numberToSend = process.argv[3];

const client = net.createConnection(serverPort, 'localhost', () => {
    console.log(`Connected to server on port ${serverPort}`);
});

client.on('connect', () => {
    setInterval(() => {
        const buffer = Buffer.alloc(4);
        buffer.writeInt32BE(numberToSend);
        client.write(buffer);
    }, 1000);
});

client.on('data', data => {
    console.log(`Received intermediate sum from server: ${data.toString()}`);
});

client.on('close', () => {
    console.log('Connection closed');
});

client.on('error', error => {
    console.error(`Error occurred: ${error}`);
});