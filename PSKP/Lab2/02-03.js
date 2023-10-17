const http = require("http");

http.createServer(function(request, response){
    console.log(request.url);

    if (request.url === "/api/name") {
        response.writeHead("200", {"Content-type": "text/plain; charset=utf-8"});
        response.end("Коршун Никита Игоревич");
    } else {
        response.writeHead(404, { "Content-type": "text/plain; charset=utf-8" });
        response.end("Страница не найдена");
    }

}).listen(5000, "127.0.0.1", function(){
    console.log("Сервер начал прослушивание запросов на порту 5000");
});