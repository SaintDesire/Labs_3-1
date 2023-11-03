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

app.listen(port, () => {
    console.log(`Сервер запущен на порту ${port}`);
});
