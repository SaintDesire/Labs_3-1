const nodemailer = require('nodemailer');

function send(emailAddress, password, message) {
    return new Promise(async (resolve, reject) => {
        try {
            const transporter = nodemailer.createTransport({
                host: 'smtp.office365.com',
                port: 587,
                secure: false,
                auth: {
                    user: 'nikitakorshun@mail.ru',
                    pass: '9{le3fnoMAWR'
                },
                tls: {
                    ciphers: 'SSLv3',
                    rejectUnauthorized: false
                }
            });

            const mailOptions = {
                from: emailAddress,
                to: emailAddress,
                subject: 'Subject of the email',
                text: message
            };

            const info = await transporter.sendMail(mailOptions);
            resolve(info);
        } catch (error) {
            reject(error);
        }
    });
}

module.exports = { send };