const express = require('express');
const app = express();
const port = 5000;

app.get('/', (req, res) => {
    // Отправляем ответ с информацией о сервере
    res.status(200).json({
        ip: req.socket.remoteAddress,
        port: req.socket.remotePort
    });
});

app.listen(port, () => {
    console.log(`Сервер запущен на порту ${port}`);
});
