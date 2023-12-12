const dgram = require('dgram');

const PORT = 4000;
const HOST = 'localhost';

const client = dgram.createSocket('udp4');

const message = 'Hello, server!';

client.send(message, PORT, HOST, (error) => {
    if (error) {
        console.error(`Error sending message: ${error}`);
    } else {
        console.log(`Sent message to server at ${HOST}:${PORT}`);
    }
});

client.on('message', (msg, rinfo) => {
    console.log(`Received response: ${msg.toString()} from ${rinfo.address}:${rinfo.port}`);
});

client.on('error', (error) => {
    console.error(`Client error: ${error}`);
});