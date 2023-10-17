const http = require("http");
const url = require("url");
const fs = require("fs");

const port = 5000;

// Функция для вычисления факториала (рекурсивный алгоритм)
function factorial(k) {
    if (k <= 1) {
        return 1;
    } else {
        return k * factorial(k - 1);
    }
}

const server = http.createServer((req, res) => {
    const query = url.parse(req.url, true).query;
    const k = parseInt(query.k);

    if (req.url === "/") {
        // Отправляем HTML-страницу с JS-кодом
        const htmlContent = fs.readFileSync("index.html", "utf-8");
        res.setHeader("Content-Type", "text/html");
        res.write(htmlContent);
    } else if (req.url.startsWith("/fact")) {
        if (!isNaN(k)) {
            const fact = factorial(k);
            const responseJSON = JSON.stringify({ k, fact });

            res.setHeader("Content-Type", "application/json");
            res.write(responseJSON);
        } else {
            res.statusCode = 400; // Некорректный запрос
            res.write("Ошибка: Параметр 'k' должен быть целым числом.");
        }
    } else {
        res.statusCode = 404; // Страница не найдена
        res.write("Ошибка: Страница не найдена.");
    }

    res.end();
});

server.listen(port, () => {
    console.log(`Сервер запущен на порту ${port}`);
});
