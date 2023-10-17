function square(number) {
    return new Promise((resolve, reject) => {
        if (typeof number !== 'number') {
            reject("Ввод недействителен");
        } else {
            resolve(Math.pow(number,2));
        }
    });
}

function cube(number) {
    return new Promise((resolve, reject) => {
        if (typeof number !== 'number') {
            reject("Ввод недействителен");
        } else {
            resolve(Math.pow(number,3));
        }
    });
}

function fourthPower(number) {
    return new Promise((resolve, reject) => {
        if (typeof number !== 'number') {
            reject("Ввод недействителен");
        } else {
            resolve(Math.pow(number,4));
        }
    });
}

const validInput = 2;
const invalidInput = "invalid";

Promise.all([square(validInput), cube(validInput), fourthPower(validInput)])
    .then((results) => {
        console.log("Квадрат:", results[0]);
        console.log("Куб:", results[1]);
        console.log("Четвертая степень:", results[2]);
    })
    .catch((error) => {
        console.error("Произошла ошибка:", error);
    });

// Тестируем с недействительным вводом
square(invalidInput)
    .then((result) => {
        console.log("Квадрат:", result);
    })
    .catch((error) => {
        console.error("Произошла ошибка:", error);
    });
