const WebSocket = require('ws');

const ws = new WebSocket('ws://localhost:5000');

ws.onopen = function() {
    let count = 1;
    const interval = setInterval(() => {
        const message = '08-03_3-client: ' + count;
        ws.send(message);
        count++;

        if (count > 25) {
            clearInterval(interval);
            ws.close();
        }
    }, 3000);
};

ws.onmessage = function(event) {
    const message = event.data;
    console.log('08-03_3-client received message:', message.toString());
};

ws.onclose = function() {
    console.log('08-03_3-client closed');
};