const axios = require('axios');

// URL сервера для тестирования
const serverUrl = 'http://localhost:5000';

// Отправляем GET-запрос
axios.get(serverUrl)
    .then(response => {
        // Выводим информацию о запросе
        console.log('Статус ответа:', response.status);
        console.log('Сообщение к статусу ответа:', response.statusText);
        console.log('IP-адрес удаленного сервера:', response.data.ip);
        console.log('Порт удаленного сервера:', response.data.port);
    })
    .catch(error => {
        console.error('Ошибка при выполнении GET-запроса:', error.message);
    });
