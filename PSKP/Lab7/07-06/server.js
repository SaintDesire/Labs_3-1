const express = require('express');
const multer = require('multer');
const fs = require('fs');

const app = express();
const port = 5000;

// Настройка Multer для обработки файлов
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'result'); // Указываем папку назначения для сохранения файлов
    },
    filename: function (req, file, cb) {
        cb(null, file.originalname); // Используем оригинальное имя файла
    }
});

const upload = multer({ storage: storage });

// Обработка POST-запроса с вложенным файлом
app.post('/', upload.single('file'), (req, res) => {
    // В req.file содержится информация о файле
    if (req.file) {
        res.status(200).json({ success: true, message: 'Файл успешно получен и сохранен в папке result' });
    } else {
        res.status(400).json({ success: false, message: 'Не удалось получить файл' });
    }
});

// Пример отправки POST-запроса из сервера с использованием Axios
app.get('/sendPostRequest', async (req, res) => {
    try {
        const response = await axios.post('http://localhost:5000', { data: 'example' });
        console.log('Ответ от сервера:', response.data);
        res.status(200).send('POST-запрос успешно отправлен из сервера');
    } catch (error) {
        console.error('Ошибка при отправке POST-запроса из сервера:', error.message);
        res.status(500).send('Internal Server Error');
    }
});

app.listen(port, () => {
    console.log(`Сервер запущен на порту ${port}`);
});
