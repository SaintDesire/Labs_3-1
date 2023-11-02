#include <iostream>
#include <windows.h>
#include <chrono>
#include <thread>
#include <string>

bool isPrime(int number) {
    if (number <= 1) {
        return false;
    }

    for (int i = 2; i <= std::sqrt(number); ++i) {
        if (number % i == 0) {
            return false;
        }
    }

    return true;
}

void generatePrimes(int duration, int processNumber) {
    SetConsoleOutputCP(1251);

    int count = 1;
    auto startTime = std::chrono::high_resolution_clock::now();

    while (true) {
        auto currentTime = std::chrono::high_resolution_clock::now();
        auto elapsedSeconds = std::chrono::duration_cast<std::chrono::seconds>(currentTime - startTime).count();

        // Проверяем условие завершения по времени
        if (elapsedSeconds >= duration) {
            break;
        }

        if (isPrime(count))
            std::cout << "Время: " << elapsedSeconds + 1 << "\tДочерний процесс " << processNumber << ": " << count << std::endl;
        else
            std::cout << "Время: " << elapsedSeconds + 1 << std::endl;


        // Приостанавливаем выполнение на короткое время
        std::this_thread::sleep_for(std::chrono::milliseconds(500));

        count++;
    }

    // Закрываем консоль дочернего процесса
    FreeConsole();
}

int main(int argc, char* argv[]) {
    generatePrimes(120, 2);

    return 0;
}
