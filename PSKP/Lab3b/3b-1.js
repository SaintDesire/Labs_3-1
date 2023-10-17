// Функция firstJob, возвращающая Promise
function firstJob() {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            resolve("Hello World");
        }, 2000);
    });
}
// Обработка Promise с использованием обработчиков then/catch
firstJob()
    .then((result) => {
        console.log("Результат с использованием обработчиков then/catch:", result);
    })
    .catch((error) => {
        console.error("Произошла ошибка:", error);
    });

// Обработка Promise с использованием async/await и try/catch
async function handleFirstJob() {
    try {
        const result = await firstJob();
        console.log("Результат с использованием async/await и try/catch:", result);
    } catch (error) {
        console.error("Произошла ошибка:", error);
    }
}

console.log("Start");
handleFirstJob();
