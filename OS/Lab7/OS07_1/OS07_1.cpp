#define _CRT_SECURE_NO_WARNINGS 1
#include <iostream>
#include <ctime>
#include <iomanip>

int main() {
    // Получаем текущее время
    std::time_t t = std::time(nullptr);
    std::tm time_info;

    // Используем безопасную версию localtime
    localtime_s(&time_info, &t);

    // Форматируем вывод
    std::cout << std::setfill('0') << std::setw(2) << time_info.tm_mday << "."
        << std::setfill('0') << std::setw(2) << 1 + time_info.tm_mon << "."
        << 1900 + time_info.tm_year << " "
        << std::setfill('0') << std::setw(2) << time_info.tm_hour << ":"
        << std::setfill('0') << std::setw(2) << time_info.tm_min << ":"
        << std::setfill('0') << std::setw(2) << time_info.tm_sec << std::endl;

    return 0;
}
