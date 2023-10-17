#include <iostream>
#include <windows.h>
#include <thread>


DWORD WINAPI OS04_02_T1(LPVOID lpParam) {
    for (int i = 0; i < 50; ++i) {
        DWORD processId = GetCurrentProcessId();
        DWORD threadId = GetCurrentThreadId();

        std::cout << "Thread: OS04_02_T1,\t";
        std::cout << "Process ID:\t" << processId << ", ";
        std::cout << "Thread ID:\t" << threadId << std::endl;
        Sleep(900);
    }
    return 0;
}

DWORD WINAPI OS04_02_T2(LPVOID lpParam) {
    for (int i = 0; i < 125; ++i) {
        DWORD processId = GetCurrentProcessId();
        DWORD threadId = GetCurrentThreadId();

        std::cout << "Thread: OS04_02_T2,\t";
        std::cout << "Process ID:\t" << processId << ", ";
        std::cout << "Thread ID:\t" << threadId << std::endl;
        Sleep(1100);
    }
    return 0;
}

int main() {
    HANDLE thread1 = CreateThread(NULL, 0, OS04_02_T1, NULL, 0, NULL);
    HANDLE thread2 = CreateThread(NULL, 0, OS04_02_T2, NULL, 0, NULL);

    for (int i = 0; i < 100; ++i) {
        DWORD processId = GetCurrentProcessId();
        DWORD threadId = GetCurrentThreadId();

        std::cout << "Thread: OS04_02,\t";
        std::cout << "Process ID:\t" << processId << ", ";
        std::cout << "Thread ID:\t" << threadId << std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(1));
    }

    // Ожидание завершения потоков
    WaitForSingleObject(thread1, INFINITE);
    WaitForSingleObject(thread2, INFINITE);

    // Закрытие хендлов потоков
    CloseHandle(thread1);
    CloseHandle(thread2);

    return 0;
}
