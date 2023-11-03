const express = require('express');
const fs = require('fs');

const app = express();
const port = 5000;

// Обработка GET-запроса для получения файла
app.get('/getFile', (req, res) => {
    const filePath = 'HelloWorld.txt'; // Путь к файлу, который вы хотите отправить

    try {
        // Чтение файла в бинарном режиме
        const fileData = fs.readFileSync(filePath);

        // Отправка файла как ответа на GET-запрос
        res.status(200)
            .header('Content-Type', 'text/plain')
            .header('Content-Disposition', 'attachment; filename=downloadedFile.png')
            .send(fileData);
    } catch (error) {
        console.error('Ошибка при чтении файла:', error.message);
        res.status(500).send('Internal Server Error');
    }
});

app.listen(port, () => {
    console.log(`Сервер запущен на порту ${port}`);
});
