const WebSocket = require('ws');

const ws = new WebSocket('ws://localhost:4000');

ws.onopen = function() {
    let count = 1;
    const interval = setInterval(() => {
        const message = '08-02_1-client: ' + count;
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
    console.log('08-02_1-client received message:', message.toString());
};

ws.onclose = function() {
    console.log('08-02_1-client closed');
};