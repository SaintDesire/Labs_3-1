#include <iostream>
#include <chrono>
#include <unistd.h>

int main() {
    using namespace std::chrono;

    int iterations = 0;
    auto startTime = high_resolution_clock::now();
    auto startTimeSecondTimer = high_resolution_clock::now();

    while (true) {
        // Замеряем процессорное время каждые 2 секунды
        auto currentTime = high_resolution_clock::now();
        auto elapsedSeconds = duration_cast<seconds>(currentTime - startTime).count();
        auto elapsedSecondsFromStart = duration_cast<seconds>(currentTime - startTimeSecondTimer).count();

        if (elapsedSeconds >= 2) {
            std::cout << "Время: " << elapsedSecondsFromStart;
            std::cout << "\tЗначение счетчика итераций: " << iterations << std::endl;
            startTime = currentTime;
        }
        iterations++;

        // Ожидание небольшого времени для снижения нагрузки процессора
        usleep(100000);  // Пауза 100 миллисекунд (1 миллион микросекунд = 1 секунда)
    }

    return 0;
}