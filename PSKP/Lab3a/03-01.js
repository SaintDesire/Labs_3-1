const http = require("http");
const readline = require("readline");

const port = 5000;
let currentState = "norm";

const server = http.createServer((req, res) => {
    if (req.url === "/") {
        res.setHeader("Content-Type", "text/html");
        res.write(`
      <html>
        <head>
          <meta charset="UTF-8">
          <title>Состояние приложения</title>
        </head>
        <body>
          <h1>Состояние приложения: ${currentState}</h1>
        </body>
      </html>
    `);
        res.end();
    }
});

server.listen(port, () => {
    console.log(`Сервер запущен на порту ${port}`);
});

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
});

rl.setPrompt("Введите новое состояние (norm, stop, test, idle, exit): ");
rl.prompt();

rl.on("line", (input) => {
    input = input.trim().toLowerCase();

    switch (input) {
        case "norm":
        case "stop":
        case "test":
        case "idle":
            currentState = input;
            break;
        case "exit":
            process.exit();
            break;
        default:
            console.log("Ошибка: Недопустимое состояние.");
    }

    rl.prompt(true);
});
