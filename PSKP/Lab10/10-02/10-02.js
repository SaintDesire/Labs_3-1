const net = require('net');

const PORT1 = 40000;
const PORT2 = 50000;

let sum1 = 0;
let sum2 = 0;

const server1 = net.createServer(socket => {
    socket.on('data', data => {
        const number = data.readInt32BE();
        sum1 += number;
        console.log(`Sum 1: ${sum1}`);
    });

    socket.on('close', () => {
        console.log(`Client disconnected from port ${PORT1}`);
    });

    socket.on('error', error => {
        console.error(`Error occurred in port ${PORT1}: ${error}`);
    });
});

const server2 = net.createServer(socket => {
    socket.on('data', data => {
        const number = data.readInt32BE();
        sum2 += number;
        console.log(`Sum 2: ${sum2}`);
    });

    socket.on('close', () => {
        console.log(`Client disconnected from port ${PORT2}`);
    });

    socket.on('error', error => {
        console.error(`Error occurred in port ${PORT2}: ${error}`);
    });
});

const sockets1 = [];
const sockets2 = [];

server1.on('connection', socket => {
    sockets1.push(socket);
});

server2.on('connection', socket => {
    sockets2.push(socket);
});

server1.listen(PORT1, () => {
    console.log(`Server listening on port ${PORT1}`);
});

server2.listen(PORT2, () => {
    console.log(`Server listening on port ${PORT2}`);
});

setInterval(() => {
    sockets1.forEach(socket => {
        socket.write(sum1.toString());
    });

    sockets2.forEach(socket => {
        socket.write(sum2.toString());
    });
}, 5000);