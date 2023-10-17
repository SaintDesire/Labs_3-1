#include <iostream>
#include <windows.h>

int main() {
    while (true) {
        // Получаем и выводим идентификатор текущего процесса
        DWORD processId = GetCurrentProcessId();
        std::cout << "Process ID: " << processId << std::endl;

        // Делаем задержку в миллисекундах (например, 1000 мс = 1 секунда)
        Sleep(1000);
    }

    return 0;
}
