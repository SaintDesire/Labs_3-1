const express = require('express');
const WebSocket = require('ws');

const app = express();
const httpPort = 3000;
const wsPort = 4000;

// Создаем HTTP-сервер
app.get('/start', (req, res) => {
    res.send(`
    <html>
      <head>
        <script>
          function startWS() {
            const ws = new WebSocket('ws://localhost:${wsPort}');

            ws.onmessage = function(event) {
              const message = event.data;
              document.getElementById('messages').innerHTML += message + '<br>';
            };

            setTimeout(() => {
                ws.close();
            }, 25000);
            
            let count = 1;
            const interval = setInterval(() => {
              const message = '08-01-client: ' + count;
              ws.send(message);
              count++;

              if (count > 25) {
                clearInterval(interval);
              }
            }, 3000);
          }
        </script>
      </head>
      <body>
        <h1>HTTP Server</h1>
        <button onclick="startWS()">Start WS</button>
        <div id="messages"></div>
      </body>
    </html>
  `);
});

app.use((req, res) => {
    res.status(400).send('Bad request');
});

app.listen(httpPort, () => {
    console.log(`HTTP server is listening on port http://localhost:${httpPort}`);
});

// Создаем WS-сервер
const wsServer = new WebSocket.Server({ port: wsPort });

wsServer.on('connection', (ws) => {
    ws.on('message', (message) => {
        console.log('WS server received message:', message.toString());
    });

    let count = 1;
    const interval = setInterval(() => {
        const message = `08-01-server: ${count - 1}->${count}`;
        ws.send(message);
        count++;
    }, 5000);

    ws.on('close', () => {
        clearInterval(interval);
    });
});

console.log(`WS server is listening on port ${wsPort}`);