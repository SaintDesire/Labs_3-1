// Функция thirdJob, принимающая параметр data и возвращающая Promise
function thirdJob(data) {
    return new Promise((resolve, reject) => {
        if (typeof data !== 'number') {
            reject('error');
        } else if (data % 2 === 1) {
            setTimeout(() => {
                resolve('odd');
            }, 1000);
        } else if (data % 2 === 0) {
            setTimeout(() => {
                reject('even');
            }, 2000);
        }
    });
}

// Обработка Promise с использованием обработчиков then/catch
thirdJob(3)
    .then((result) => {
        console.log("Результат с использованием обработчиков then/catch:", result);
    })
    .catch((error) => {
        console.error("Произошла ошибка:", error);
    });

// Обработка Promise с использованием async/await и try/catch
async function handleThirdJob(data) {
    try {
        const result = await thirdJob(data);
        console.log("Результат с использованием async/await и try/catch:", result);
    } catch (error) {
        console.error("Произошла ошибка:", error);
    }
}

console.log("Start");

// Вызов функции thirdJob с разными значениями data
handleThirdJob('abc');  // Пример с ошибкой
handleThirdJob(3);     // Пример с нечетным числом
handleThirdJob(4);     // Пример с четным числом
