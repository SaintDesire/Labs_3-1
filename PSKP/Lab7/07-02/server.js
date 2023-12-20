const express = require('express');
const url = require('url');
const app = express();
const port = 5000;

app.get('/', (req, res) => {
    // Получаем параметры из URL
    const queryParams = url.parse(req.url, true).query;

    // Отправляем ответ с данными
    res.status(200).json(queryParams);
});

app.listen(port, () => {
    console.log(`Сервер запущен на порту ${port}`);
});
