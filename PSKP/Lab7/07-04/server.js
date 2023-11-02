const express = require('express');
const app = express();
const port = 5000;

app.use(express.json()); // Позволяет парсить JSON-тело запроса

app.post('/', (req, res) => {
    // Получаем данные из JSON-тела запроса
    const requestData = req.body;

    // Отправляем ответ с данными в JSON-формате
    res.status(200).json(requestData);
});

app.use((req, res) => {
    res.status(404).send('Not Found');
});

app.listen(port, () => {
    console.log(`Сервер запущен на порту ${port}`);
});
