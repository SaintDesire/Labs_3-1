const express = require('express');
const bodyParser = require('body-parser');
const nodemailer = require('nodemailer');

const app = express();
const port = 5000;

app.use(express.static('public'));
app.use(bodyParser.urlencoded({ extended: true }));

app.get('/', (req, res) => {
    res.sendFile(__dirname + '/index.html');
});

app.post('/sendmail', async (req, res) => {
    const { fromEmail, toEmail, message } = req.body;

    const transporter = nodemailer.createTransport({
        host: 'smtp.ethereal.email',
        port: 587,
        auth: {
            user: 'beverly.jakubowski@ethereal.email',
            pass: 'kQf8vT5jXhrXrZMgfD'
        }
    });

    // Настройка отправляемого письма
    const mailOptions = {
        from: fromEmail,
        to: toEmail,
        subject: 'Тема вашего письма',
        html: message
    };

    try {
        res.send(`Sender: ${fromEmail}\n Reciever: ${fromEmail}\n Message: ${message}`);
    } catch (error) {
        console.error(error);
        res.status(500).send('Error sending email');
    }
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
