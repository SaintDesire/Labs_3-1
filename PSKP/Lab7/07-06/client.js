const axios = require('axios');
const fs = require('fs');
const FormData = require('form-data');

// URL сервера для тестирования
const serverUrl = 'http://localhost:5000';

const filePath = 'MyFile.png';

// Создаем объект FormData для передачи файла
const form = new FormData();
form.append('file', fs.createReadStream(filePath));

// Отправляем POST-запрос с вложенным файлом
axios.post(serverUrl, form, {
    headers: {
        ...form.getHeaders(),
    }
})
    .then(response => {
        console.log('Статус ответа:', response.status);
        console.log('Данные, пересылаемые в теле ответа:', response.data);
    })
    .catch(error => {
        console.error('Ошибка при выполнении POST-запроса:', error.message);
    });
