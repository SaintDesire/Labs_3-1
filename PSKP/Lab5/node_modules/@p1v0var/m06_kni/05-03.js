const express = require('express');
const bodyParser = require('body-parser');
const { send } = require('@p1v0var/m06_kni');

const app = express();
const port = 5000;

app.use(express.static('public'));
app.use(bodyParser.urlencoded({ extended: true }));

app.get('/', (req, res) => {
    res.sendFile(__dirname + '/index.html');
});

app.post('/sendmail', async (req, res) => {
    const { fromEmail, password, message } = req.body;

    try {
        const info = await send(fromEmail, '2023pass2023', message);

        res.send(`Sender: ${fromEmail} Message: ${message} Info: ${info.response}`);
    } catch (error) {
        console.error(error);
        res.status(500).send('Error sending email');
    }
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
