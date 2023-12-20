const { EventEmitter } = require('events');

class DB extends EventEmitter {
    constructor() {
        super();
        this.data = [];
        this.idCounter = 1;

        this.on('get', (res) => this.select(res));
        this.on('post', (res, newData) => this.insert(res, newData));
        this.on('put', (res, id, updatedData) => this.update(res, id, updatedData));
        this.on('delete', (res, id) => this.delete(res, id));
        this.on('getById', (res, id) => this.getById(res, id));
    }



    select(res) {
        res.writeHead(200, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(this.data));
    }

    insert(res, newData) {
        newData.id = this.idCounter++;
        this.data.push(newData);

        res.writeHead(201, { 'Content-Type': 'application/json' });
        res.end(JSON.stringify(newData));
    }

    update(res, id, updatedData) {
        if (!this.isValidDate(updatedData.bday)) {
            res.writeHead(400, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify({ error: 'Invalid date format or out of bounds' }));
            return;
        }

        const index = this.data.findIndex((item) => item.id === parseInt(id, 10));

        if (index !== -1) {
            this.data[index] = { ...this.data[index], ...updatedData };

            res.writeHead(200, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify(this.data[index]));
        } else {
            res.writeHead(404, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify({ error: 'Not Found' }));
        }
    }

    delete(res, id) {
        const index = this.data.findIndex((item) => item.id === parseInt(id, 10));

        if (index !== -1) {
            const deletedData = this.data.splice(index, 1)[0];
            res.writeHead(200, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify(deletedData));
        } else {
            res.writeHead(404, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify({ error: 'Not Found' }));
        }
    }

    getById(res, id) {
        const dataById = this.data.find(item => item.id === parseInt(id, 10));

        if (dataById) {
            res.writeHead(200, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify(dataById));
        } else {
            res.writeHead(404, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify({ error: 'Not Found' }));
        }
    }

    isValidDate(dateString) {
        const regex = /^\d{4}-\d{2}-\d{2}$/;
        if (!regex.test(dateString)) return false;

        const parts = dateString.split("-");
        const day = parseInt(parts[2], 10);
        const month = parseInt(parts[1], 10);
        const year = parseInt(parts[0], 10);

        if (year < 1900 || year > 2023) return false;
        if (month < 1 || month > 12) return false;
        if (day < 1 || day > 31) return false;

        return true;
    }
}

module.exports = { DB };
