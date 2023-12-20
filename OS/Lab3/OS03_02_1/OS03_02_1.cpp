#include <iostream>
#include <windows.h>

int wmain() { // использование wmain вместо main
    for (int i = 0; i < 50; ++i) {
        // Выводим идентификатор процесса (OS03_02_1)
        wprintf(L"Process ID (OS03_02_1): %u\n", GetCurrentProcessId());
        Sleep(1000); // Задержка 1 секунда
    }

    return 0;
}
