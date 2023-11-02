const express = require('express');
const { parseString } = require('xml2js');
const app = express();
const port = 5000;

app.use(express.text({ type: 'application/xml' })); // Позволяет парсить XML-тело запроса

app.post('/', (req, res) => {
    // Преобразуем данные из XML-формата
    parseString(req.body, (err, result) => {
        if (err) {
            console.error('Ошибка при парсинге XML:', err.message);
            res.status(500).send('Internal Server Error');
        } else {
            // Отправляем ответ в XML-формате
            res.status(200).type('application/xml').send(`<response>${JSON.stringify(result)}</response>`);
        }
    });
});

app.use((req, res) => {
    res.status(404).send('Not Found');
});

app.listen(port, () => {
    console.log(`Сервер запущен на порту ${port}`);
});
