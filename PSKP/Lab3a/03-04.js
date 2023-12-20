const http = require("http");
const url = require("url");
const fs = require("fs");

const port = 5000;

// Асинхронная функция для вычисления факториала
function calculateFactorialAsync(k, callback) {
    process.nextTick(() => {
        if (k <= 1) {
            callback(null, 1);
        } else {
            calculateFactorialAsync(k - 1, (err, fact) => {
                if (err) {
                    callback(err);
                } else {
                    callback(null, k * fact);
                }
            });
        }
    });
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
            calculateFactorialAsync(k, (err, fact) => {
                if (err) {
                    res.statusCode = 500; // Внутренняя ошибка сервера
                    res.write("Ошибка: Не удалось вычислить факториал.");
                } else {
                    const responseJSON = JSON.stringify({ k, fact });

                    res.setHeader("Content-Type", "application/json");
                    res.write(responseJSON);
                }
                res.end();
            });
        } else {
            res.statusCode = 400; // Некорректный запрос
            res.write("Ошибка: Параметр 'k' должен быть целым числом.");
            res.end();
        }
    } else {
        res.statusCode = 404; // Страница не найдена
        res.write("Ошибка: Страница не найдена.");
        res.end();
    }
});

server.listen(port, () => {
    console.log(`Сервер запущен на порту ${port}`);
});
