const express = require('express');
const bodyParser = require('body-parser');
const path = require('path');
const fs = require("fs");

const app = express();
const port = 5000;

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, 'public')));

// Задание 01 /connection?set=set
app.get('/connection', (req, res) => {
    if (req.query.set) {
        const set_value = req.query.set;
        // Здесь должен быть код, который устанавливает параметр KeepAliveTimeout
        res.send(`Установлено новое значение параметра KeepAliveTimeout=${set_value}`);
    } else {
        // Здесь должен быть код, который возвращает текущее значение параметра
        res.send('Текущее значение параметра KeepAliveTimeout');
    }
});

// Задание 02 /headers
app.get('/headers', (req, res) => {
    // Отображение заголовков запроса и ответа
    const headers = req.headers;
    res.json({ 'Заголовки запроса': headers });
});

// Задание 03 /parameter?x=x&y=y
app.get('/parameter', (req, res) => {
    const x = req.query.x;
    const y = req.query.y;
    if (!isNaN(x) && !isNaN(y)) {
        // Обработка числовых значений x и y
        const result = {
            'Сумма': parseFloat(x) + parseFloat(y),
            'Разность': parseFloat(x) - parseFloat(y),
            'Произведение': parseFloat(x) * parseFloat(y),
            'Частное': parseFloat(x) / parseFloat(y),
        };
        res.json(result);
    } else {
        res.status(400).send('Ошибка: x и y должны быть числовыми значениями');
    }
});

// Задание 04 /parameter/x/y
app.get('/parameter/:x/:y', (req, res) => {
    const x = req.params.x;
    const y = req.params.y;

    if (!isNaN(x) && !isNaN(y)) {
        const result = {
            'Сумма': parseFloat(x) + parseFloat(y),
            'Разность': parseFloat(x) - parseFloat(y),
            'Произведение': parseFloat(x) * parseFloat(y),
            'Частное': parseFloat(x) / parseFloat(y),
        };
        res.json(result);
    } else {
        res.send(`URI: /parameter/${x}/${y}`);
    }
});

// Задание 05 /socket
app.get('/socket', (req, res) => {
    const clientIP = req.ip;
    const clientPort = req.socket.remotePort;
    const serverIP = req.socket.localAddress;
    const serverPort = req.socket.localPort;

    res.send(`Client IP: ${clientIP}, Client Port: ${clientPort}, Server IP: ${serverIP}, Server Port: ${serverPort}`);
});

// Задание 06 resp-status?code=c&mess=m
app.get('/resp-status', (req, res) => {
    const code = req.query.code || 200;
    const message = req.query.mess || 'OK';

    res.status(code).send(message);
});

// Задание 07 /formparameter

// Отправляем HTML-страницу с формой
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});
app.post('/formparameter', (req, res) => {
    const formData = req.body;
    res.send(`
        <h1>Form Parameter Values:</h1>
        <p>Text Parameter: ${formData.textParam}</p>
        <p>Number Parameter: ${formData.numberParam}</p>
        <p>Date Parameter: ${formData.dateParam}</p>
        <p>Checkbox Parameter: ${formData.checkboxParam || 'Not checked'}</p>
        <p>Radio Parameter: ${formData.radioParam || 'Not selected'}</p>
        <p>Textarea Parameter: ${formData.textareaParam}</p>
        <p>Submit Button Value: ${formData.submitButton}</p>
        <br>
        <a href="/">Back to Form</a>
    `);
});

// Задание 08 /json
app.post('/json', (req, res) => {
    // Проверяем наличие данных в запросе
    if (!req.body || Object.keys(req.body).length === 0) {
        return res.status(400).json({ error: 'No data provided in the request.' });
    }

    // Извлекаем данные из запроса
    const { x, y, s, o, m } = req.body;

    // Вычисляем значения для ответа
    const xPlusY = parseFloat(x) + parseFloat(y);
    const concatinationSO = `${s}${o.property1}${o.property2}`;
    const lengthM = Array.isArray(m) ? m.length : 0;

    // Формируем ответ в JSON-формате
    const jsonResponse = {
        'x+y': xPlusY,
        'Concatination_s_o': concatinationSO,
        'Length_m': lengthM
    };

    // Отправляем ответ
    res.json(jsonResponse);
});

// Задание 09 /xml
app.post('/xml', (req, res) => {
    // Парсим XML из тела запроса
    xml2js.parseString(req.body, (err, result) => {
        if (err) {
            return res.status(400).send('Invalid XML format.');
        }

        // Вычисляем значения для ответа
        const xSum = result.message.x.reduce((sum, value) => sum + parseFloat(value), 0);
        const mConcat = result.message.m.join('');

        // Формируем XML-ответ
        const xmlResponse = `<response><sum result="${xSum}"/><concat result="${mConcat}"/></response>`;

        // Отправляем ответ в XML-формате
        res.type('application/xml');
        res.send(xmlResponse);
    });
});

// Задание 10 /files
app.get('/files', (req, res) => {
    const staticDir = path.join(__dirname, 'static');
    fs.readdir(staticDir, (err, files) => {
        if (err) {
            return res.status(500).send('Internal Server Error');
        }

        const filesCount = files.length;
        res.set('X-static-files-count', filesCount.toString());
        res.send(`Number of files in static directory: ${filesCount}`);
    });
});

// Задание 11 /files/filename
app.get('/files/:filename', (req, res) => {
    const filename = req.params.filename;
    const filePath = path.join(__dirname, 'static', filename);

    fs.exists(filePath, (exists) => {
        if (exists) {
            res.sendFile(filePath);
        } else {
            res.status(404).send('File not found');
        }
    });
});

// Задание 12 /upload
app.get('/upload', (req, res) => {
    res.sendFile(path.join(__dirname, 'upload.html'));
});

app.post('/upload', (req, res) => {
    const staticDir = path.join(__dirname, 'static');
    const uploadedFilePath = path.join(staticDir, 'uploadedFile.txt');

    // Сохраняем загруженный файл
    req.pipe(fs.createWriteStream(uploadedFilePath));

    req.on('end', () => {
        res.send('File uploaded successfully.');
    });
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
