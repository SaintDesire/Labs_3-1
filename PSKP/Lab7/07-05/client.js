const axios = require('axios');
const convert = require('xml-js');

// URL сервера для тестирования
const serverUrl = 'http://localhost:5000';

// Структура данных для запроса
const requestData = {
    x: 10,
    y: 20,
    s: 'Hello, Server!'
};

// Преобразуем данные в XML-формат
const xmlData = convert.js2xml({ request: requestData }, { compact: true });

// Отправляем POST-запрос с данными в XML-формате
axios.post(serverUrl, xmlData, {
    headers: {
        'Content-Type': 'application/xml'
    }
})
    .then(response => {
        console.log('Статус ответа:', response.status);
        console.log('Данные, пересылаемые в теле ответа:', response.data);
    })
    .catch(error => {
        console.error('Ошибка при выполнении POST-запроса:', error.message);
    });
