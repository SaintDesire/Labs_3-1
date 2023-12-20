const axios = require('axios');

// URL сервера для тестирования
const serverUrl = 'http://localhost:5000';

// Числовые параметры x и y
const params = {
    x: 10,
    y: 20
};

// Отправляем GET-запрос с параметрами
axios.get(serverUrl, { params })
    .then(response => {
        // Выводим информацию о запросе
        console.log('Статус ответа:', response.status);
        console.log('Данные, пересылаемые в теле ответа:', response.data);
    })
    .catch(error => {
        console.error('Ошибка при выполнении GET-запроса:', error.message);
    });
