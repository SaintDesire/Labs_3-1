const http = require("http");
const fs = require("fs");
const path = require("path");

const server = http.createServer(function (request, response) {
    console.log(request.url);

    if (request.url === "/api/name") {
        response.writeHead("200", {"Content-type": "text/plain; charset=utf-8"});
        response.end("Коршун Никита Игоревич");
    } else if (request.url === "/fetch") {
        const filePath = path.join(__dirname, "fetch.html");

        fs.readFile(filePath, function (err, data) {
            if (err) {
                response.writeHead(500, { "Content-type": "text/plain; charset=utf-8" });
                response.end("Внутренняя ошибка сервера");
            } else {
                response.writeHead(200, { "Content-type": "text/html; charset=utf-8" });
                response.end(data);
            }
        });
    } else {
        response.writeHead(404, { "Content-type": "text/plain; charset=utf-8" });
        response.end("Страница не найдена");
    }
});

server.listen(5000, "127.0.0.1", function () {
    console.log("Сервер начал прослушивание запросов на порту 5000");
});
