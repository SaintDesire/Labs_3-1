const dgram = require('dgram');

const PORT = 4000;

const server = dgram.createSocket('udp4');

server.on('message', (msg, rinfo) => {
    const response = `ECHO: ${msg}`;
    server.send(response, rinfo.port, rinfo.address, (error) => {
        if (error) {
            console.error(`Error sending response: ${error}`);
        } else {
            console.log(`Sent response to ${rinfo.address}:${rinfo.port}`);
        }
    });
});

server.on('error', (error) => {
    console.error(`Server error: ${error}`);
});

server.on('listening', () => {
    console.log(`Server listening on port ${PORT}`);
});

server.bind(PORT);