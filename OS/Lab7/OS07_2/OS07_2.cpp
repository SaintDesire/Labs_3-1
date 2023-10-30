#include <iostream>
#include <chrono>
#include <thread>

int main() {
    setlocale(LC_ALL, "ru");
    int counter = 0;

    // Бесконечный цикл
    while (true) {
        counter++;

        // Вывод значения счетчика итераций через 5 секунд
        if (counter == 5) {
            std::cout << "Значение счетчика через 5 секунд: " << counter << std::endl;
        }

        // Вывод значения счетчика итераций через 10 секунд
        if (counter == 10) {
            std::cout << "Значение счетчика через 10 секунд: " << counter << std::endl;
        }

        // Завершение работы цикла и приложения через 15 секунд
        if (counter >= 15) {
            break;
        }

        std::this_thread::sleep_for(std::chrono::seconds(1)); // Приостановка выполнения на 1 секунду
    }

    // Вывод итогового значения счетчика итераций
    std::cout << "Итоговое значение счетчика: " << counter << std::endl;

    return 0;
}