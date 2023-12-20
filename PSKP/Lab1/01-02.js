const http = require('http');

const server = http.createServer((req, res) => {
    // Получаем данные о запросе
    const method = req.method;
    const url = req.url;
    const version = req.httpVersion;
    const headers = req.headers;

    // Чтение данных из тела запроса (если они есть)
    let requestBody = '';
    req.on('data', (chunk) => {
        requestBody += chunk.toString();
    });

    req.on('end', () => {
        // Формируем HTML-страницу с данными о запросе
        const responseHTML = `
      <html>
        <head>
          <title>Информация о запросе</title>
          <meta charset="UTF-8">
        </head>
        <body>
          <h1>Данные о запросе:</h1>
          <p><strong>Метод:</strong> ${method}</p>
          <p><strong>URI:</strong> ${url}</p>
          <p><strong>Версия протокола:</strong> ${version}</p>
          <p><strong>Заголовки:</strong> ${JSON.stringify(headers)}</p>
          <p><strong>Тело запроса:</strong> ${requestBody}</p>
        </body>
      </html>
    `;

        // Отправляем HTML-страницу в качестве ответа
        res.writeHead(200, { 'Content-Type': 'text/html' });
        res.end(responseHTML);
    });
});

const PORT = process.env.PORT || 3000;

server.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
