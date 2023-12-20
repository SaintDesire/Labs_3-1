const express = require('express');
const sql = require('mssql');

const app = express();
const port = 3000;

// Конфигурация подключения к базе данных
const config = {
    user: 'student',
    password: 'fitfit',
    server: 'NIKITA_PV',
    database: 'KNI',
    trustServerCertificate: true,
    pool: {
        max: 10,
        min: 4
    }
};

// Подключение к базе данных
sql.connect(config).then(pool => {
    // Установка соединения с пулом соединений
    app.set('db', pool);
}).catch(err => {
    console.error('Ошибка подключения к базе данных:', err.message);
});

// Получить список всех факультетов в json-формате
app.get('/api/faculties', (req, res) => {
    const db = req.app.get('db');
    db.request().query('SELECT * FROM FACULTY').then(result => {
        res.json(result.recordset);
    }).catch(err => {
        console.error('Ошибка выполнения запроса:', err.message);
        res.status(500).json({ error: 'Ошибка выполнения запроса' });
    });
});

// Получить список всех кафедр в json-формате
app.get('/api/pulpits', (req, res) => {
    const db = req.app.get('db');
    db.request().query('SELECT * FROM PULPIT').then(result => {
        res.json(result.recordset);
    }).catch(err => {
        console.error('Ошибка выполнения запроса:', err.message);
        res.status(500).json({ error: 'Ошибка выполнения запроса' });
    });
});

// Получить список всех учебных дисциплин в json-формате
app.get('/api/subjects', (req, res) => {
    const db = req.app.get('db');
    db.request().query('SELECT * FROM SUBJECT').then(result => {
        res.json(result.recordset);
    }).catch(err => {
        console.error('Ошибка выполнения запроса:', err.message);
        res.status(500).json({ error: 'Ошибка выполнения запроса' });
    });
});

// Получить список всех типов учебных аудиторий в json-формате
app.get('/api/auditoriumstypes', (req, res) => {
    const db = req.app.get('db');
    db.request().query('SELECT * FROM AUDITORIUM_TYPE').then(result => {
        res.json(result.recordset);
    }).catch(err => {
        console.error('Ошибка выполнения запроса:', err.message);
        res.status(500).json({ error: 'Ошибка выполнения запроса' });
    });
});

// Получить список всех учебных аудиторий в json-формате
app.get('/api/auditoriums', (req, res) => {
    const db = req.app.get('db');
    db.request().query('SELECT * FROM AUDITORIUM').then(result => {
        res.json(result.recordset);
    }).catch(err => {
        console.error('Ошибка выполнения запроса:', err.message);
        res.status(500).json({ error: 'Ошибка выполнения запроса' });
    });
});

// Вернуть список кафедр, относящихся к факультету с указанным кодом
app.get('/api/faculty/:faculty/pulpits', (req, res) => {
    const db = req.app.get('db');
    const faculty = req.params.faculty;
    db.request().input('faculty', sql.NChar, faculty).query('SELECT * FROM PULPIT WHERE FACULTY = @faculty').then(result => {
        res.json(result.recordset);
    }).catch(err => {
        console.error('Ошибка выполнения запроса:', err.message);
        res.status(500).json({ error: 'Ошибка выполнения запроса' });
    });
});

// Вернуть список аудиторий указанного типа с указанным кодом
app.get('/api/auditoriumtypes/:type/auditoriums', (req, res) => {
    const db = req.app.get('db');
    const type = req.params.type;
    db.request().input('type', sql.NChar, type).query('SELECT * FROM AUDITORIUM WHERE AUDITORIUM_TYPE = @type').then(result => {
        res.json(result.recordset);
    }).catch(err => {
        console.error('Ошибка выполнения запроса:', err.message);
        res.status(500).json({ error: 'Ошибка выполнения запроса' });
    });
});

// Вернуть список учебных дисциплин, преподаваемых на указанной кафедре с указанным кодом
app.get('/api/pulpit/:pulpit/subjects', (req, res) => {
    const db = req.app.get('db');
    const pulpit = req.params.pulpit;
    db.request().input('pulpit', sql.NChar, pulpit).query('SELECT * FROM SUBJECT WHERE PULPIT = @pulpit').then(result => {
        res.json(result.recordset);
    }).catch(err => {
        console.error('Ошибка выполнения запроса:', err.message);
        res.status(500).json({ error: 'Ошибка выполнения запроса' });
    });
});

// Запустк сервера
app.listen(port, () => {
    console.log(`Сервер запущен на порту ${port}`);
});