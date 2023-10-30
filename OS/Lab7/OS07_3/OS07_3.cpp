#include <iostream>
#include <chrono>
#include <thread>

int main() {
    setlocale(LC_ALL, "ru");
    int counter = 0;
    // Функция для выполнения в каждой итерации
    auto iterationFunction = [&counter]() {
        counter++;
        std::cout << "Значение счетчика: " << counter << std::endl;
        };

    // Создание периодического ожидающего таймера на 3 секунды
    std::chrono::milliseconds interval(3000);
    std::chrono::steady_clock::time_point nextTriggerTime = std::chrono::steady_clock::now() + interval;

    // Бесконечный цикл
    while (true) {
        // Выполнение функции в каждой итерации
        iterationFunction();

        // Проверка, прошло ли уже 3 секунды
        std::chrono::steady_clock::time_point currentTime = std::chrono::steady_clock::now();
        if (currentTime >= nextTriggerTime) {
            // Вывод значения счетчика итераций каждые 3 секунды
            std::cout << "Значение счетчика через 3 секунды: " << counter << std::endl;
            nextTriggerTime += interval;
        }

        // Завершение работы цикла и приложения через 15 секунд
        if (counter >= 15) {
            break;
        }

        std::this_thread::sleep_for(std::chrono::milliseconds(500)); // Небольшая пауза для снижения нагрузки на процессор
    }

    // Вывод итогового значения счетчика итераций
    std::cout << "Итоговое значение счетчика: " << counter << std::endl;

    return 0;
}