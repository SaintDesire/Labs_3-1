#include <iostream>
#include <ctime>

int main() {
    // Получаем текущую локальную дату и время
    time_t currentTime = time(nullptr);
    struct tm localTimeInfo;
    localtime_r(&currentTime, &localTimeInfo);

    // Форматируем и выводим дату и время
    char buffer[80];
    strftime(buffer, sizeof(buffer), "%d.%m.%Y %H:%M:%S", &localTimeInfo);
    std::cout << "Текущая локальная дата и время: " << buffer << std::endl;

    return 0;
}
