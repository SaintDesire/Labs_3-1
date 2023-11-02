const axios = require('axios');
const fs = require('fs');

// URL сервера для тестирования
const serverUrl = 'http://localhost:5000';

// Отправляем GET-запрос
axios.get(`${serverUrl}/getFile`, { responseType: 'arraybuffer' })
    .then(response => {
        // Сохраняем полученный файл
        fs.writeFileSync('result/HelloWorld.txt', Buffer.from(response.data));

        console.log('Статус ответа:', response.status);
        console.log('Файл успешно получен и сохранен в папке result');
    })
    .catch(error => {
        console.error('Ошибка при выполнении GET-запроса:', error.message);
    });
