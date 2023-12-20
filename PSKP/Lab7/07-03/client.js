const axios = require('axios');

// URL сервера для тестирования
const serverUrl = 'http://localhost:5000';

// Параметры x, y, s
const params = {
    x: 10,
    y: 20,
    s: 'Hello, Server!'
};

// Отправляем POST-запрос с параметрами в теле
axios.post(serverUrl, params)
    .then(response => {
        // Выводим информацию о запросе
        console.log('Статус ответа:', response.status);
        console.log('Данные, пересылаемые в теле ответа:', response.data);
    })
    .catch(error => {
        console.error('Ошибка при выполнении POST-запроса:', error.message);
    });
