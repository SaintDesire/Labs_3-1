const express = require('express');
const app = express();
const port = 5000;

app.use(express.json()); // Позволяет парсить JSON-тело запроса

app.post('/', (req, res) => {
    // Получаем параметры из тела запроса
    const params = req.body;

    // Отправляем ответ с данными
    res.status(200).send(params);
});

app.use((req, res) => {
    res.status(404).send('Not Found');
});

app.listen(port, () => {
    console.log(`Сервер запущен на порту ${port}`);
});
