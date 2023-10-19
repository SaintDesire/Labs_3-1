
#include <iostream>
#include <Windows.h>
#include <bitset>

int main()
{
    setlocale(LC_ALL, "RUS");

    auto process = GetCurrentProcess();
    auto thread = GetCurrentThread();

    // Получаем маску доступных процессу процессоров
    DWORD_PTR processAffinityMask;
    DWORD_PTR systemAffinityMask;


    std::cout << "-	идентификатор текущего процесса: " << GetCurrentProcessId()
        << "\n-	идентификатор текущего (main) потока: " << GetCurrentThreadId()
        << "\n-	приоритет (приоритетный класс) текущего процесса: " << GetPriorityClass(process)
        << "\n-	приоритет текущего потока: " << GetThreadPriority(thread);


    if (GetProcessAffinityMask(process, &processAffinityMask, &systemAffinityMask)) {
        // Преобразуем маску в строку в двоичном виде
        std::string binaryString = std::bitset<sizeof(DWORD_PTR) * 8>(processAffinityMask).to_string();

        // Удаляем ведущие нули
        size_t firstNonZero = binaryString.find_first_not_of('0');
        if (firstNonZero != std::string::npos) {
            binaryString = binaryString.substr(firstNonZero);
        }

        std::cout << "\n- Маска доступных процессу процессоров (в двоичном виде): " << binaryString << "\n";
    }
    else {
        DWORD error = GetLastError();
        std::cerr << "\nОшибка при получении маски доступных процессу процессоров. Код ошибки: " << error << "\n";
    }

    if (GetProcessAffinityMask(process, &processAffinityMask, &systemAffinityMask)) {
        // Считаем количество установленных битов в маске
        int processorCount = 0;
        DWORD_PTR mask = 1;
        while (mask != 0) {
            if ((processAffinityMask & mask) != 0) {
                processorCount++;
            }
            mask <<= 1;
        }
        std::cout << "\n- Количество процессоров, доступных процессу: " << processorCount << "\n";
    }
    else {
        DWORD error = GetLastError();
        std::cerr << "\n Ошибка при получении маски доступных процессу процессоров. Код ошибки: " << error << "\n";
    }

    std::cout << "\n- процессор, назначенный текущему потоку: " << GetCurrentProcessorNumber() << "\n";

    system("pause");
}

