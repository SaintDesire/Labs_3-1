// Функция secondJob, возвращающая Promise, который отклоняется через 3 секунды
function secondJob() {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            reject("Произошла ошибка");
        }, 3000);
    });
}

// Обработка Promise с использованием обработчиков then/catch
secondJob()
    .then((result) => {
        console.log("Результат с использованием обработчиков then/catch:", result);
    })
    .catch((error) => {
        console.error("Произошла ошибка:", error);
    });

// Обработка Promise с использованием async/await и try/catch
async function handleSecondJob() {
    try {
        const result = await secondJob();
        console.log("Результат с использованием async/await и try/catch:", result);
    } catch (error) {
        console.error("Произошла ошибка:", error);
    }
}

console.log("Start");
handleSecondJob();
