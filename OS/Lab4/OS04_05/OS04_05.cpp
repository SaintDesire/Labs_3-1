#include <iostream>
#include <windows.h>

DWORD WINAPI OS04_05_T1(LPVOID lpParam) {
    for (int i = 0; i < 50; ++i) {
        std::cout << i + 1 << ") ";
        DWORD processId = GetCurrentProcessId();
        DWORD threadId = GetCurrentThreadId();

        std::cout << "Thread: OS04_05_T1,\t";
        std::cout << "Process ID:\t" << processId << ", ";
        std::cout << "Thread ID:\t" << threadId << std::endl;
        Sleep(990);
    }
    return 0;
}

DWORD WINAPI OS04_05_T2(LPVOID lpParam) {
    for (int i = 0; i < 125; ++i) {
        std::cout << i + 1 << ") ";
        DWORD processId = GetCurrentProcessId();
        DWORD threadId = GetCurrentThreadId();

        std::cout << "Thread: OS04_05_T2,\t";
        std::cout << "Process ID:\t" << processId << ", ";
        std::cout << "Thread ID:\t" << threadId << std::endl;
        Sleep(1000);

        if (i == 39) {
            std::cout << "Main thread is terminating OS04_05_T2 at iteration 40" << std::endl;
            return 0;
        }
    }
    return 0;
}

int main() {
    HANDLE thread1 = CreateThread(NULL, 0, OS04_05_T1, NULL, 0, NULL);
    HANDLE thread2 = CreateThread(NULL, 0, OS04_05_T2, NULL, 0, NULL);

    DWORD processId = GetCurrentProcessId();
    DWORD threadId = GetCurrentThreadId();

    for (int i = 0; i < 100; ++i) {
        std::cout << i + 1 << ") ";
        DWORD processId = GetCurrentProcessId();
        DWORD threadId = GetCurrentThreadId();

        std::cout << "Thread: OS04_05,\t";
        std::cout << "Process ID:\t" << processId << ", ";
        std::cout << "Thread ID:\t" << threadId << std::endl;
        Sleep(1010);
    }

    WaitForSingleObject(thread1, INFINITE);
    WaitForSingleObject(thread2, INFINITE);

    CloseHandle(thread1);
    CloseHandle(thread2);

    return 0;
}
