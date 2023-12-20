const axios = require('axios');

// URL сервера для тестирования
const serverUrl = 'http://localhost:5000';

// Структура данных для запроса
const requestData = {
    x: 10,
    y: 20,
    s: 'Hello, Server!'
};

// Отправляем POST-запрос с данными в JSON-формате
axios.post(serverUrl, requestData, {
    headers: {
        'Content-Type': 'application/json'
    }
})
    .then(response => {
        // Выводим информацию о запросе
        console.log('Статус ответа:', response.status);
        console.log('Данные, пересылаемые в теле ответа:', response.data);
    })
    .catch(error => {
        console.error('Ошибка при выполнении POST-запроса:', error.message);
    });
