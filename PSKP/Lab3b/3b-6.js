function square(number) {
    return new Promise((resolve, reject) => {
        if (typeof number !== 'number') {
            reject("Ввод недействителен");
        } else {
            setTimeout(() => {
                resolve(number * number);
            }, 1000); // Задержка 1 секунда
        }
    });
}

function cube(number) {
    return new Promise((resolve, reject) => {
        if (typeof number !== 'number') {
            reject("Ввод недействителен");
        } else {
            setTimeout(() => {
                resolve(number * number * number);
            }, 2000); // Задержка 2 секунды
        }
    });
}

function fourthPower(number) {
    return new Promise((resolve, reject) => {
        if (typeof number !== 'number') {
            reject("Ввод недействителен");
        } else {
            setTimeout(() => {
                resolve(number * number * number * number);
            }, 3000); // Задержка 3 секунды
        }
    });
}

const input = 2;
const invalidInput = "invalid";

// Promise.race([square(invalidInput), cube(input), fourthPower(input)])
//     .then((result) => {
//         console.log("Первый разрешенный результат:", result);
//     })
//     .catch((error) => {
//         console.error("Произошла ошибка:", error);
//     });
//
Promise.any([square(invalidInput), cube(input), fourthPower(input)])
    .then((result) => {
        console.log("Первый успешно разрешенный результат:", result);
    })
    .catch((error) => {
        console.error("Все Promise отклонены:", error);
    });
