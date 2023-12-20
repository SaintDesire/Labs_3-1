const net = require('net');

const server = net.createServer((socket) => {
    socket.on('data', (data) => {
        const message = data.toString().trim();
        socket.write(`ECHO: ${message}`);
    });
});

server.listen(3000, '127.0.0.1', () => {
    console.log('Server listening on port 3000');
});