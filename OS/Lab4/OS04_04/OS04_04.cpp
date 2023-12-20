#include <iostream>
#include <windows.h>

DWORD WINAPI OS04_04_T1(LPVOID lpParam) {
    for (int i = 0; i < 50; ++i) {
        DWORD processId = GetCurrentProcessId();
        DWORD threadId = GetCurrentThreadId();

        std::cout << "Thread: OS04_04_T1, ";
        std::cout << "Process ID: " << processId << ", ";
        std::cout << "Thread ID: " << threadId << std::endl;
        Sleep(1000);

        if (i == 24) {
            std::cout << "OS04_04_T1 is sleeping for 10 seconds at iteration 25" << std::endl;
            Sleep(10000);
            std::cout << "OS04_04_T1 has awakened at iteration 26" << std::endl;
        }
    }
    return 0;
}

DWORD WINAPI OS04_04_T2(LPVOID lpParam) {
    for (int i = 0; i < 125; ++i) {
        DWORD processId = GetCurrentProcessId();
        DWORD threadId = GetCurrentThreadId();

        std::cout << "Thread: OS04_04_T2, ";
        std::cout << "Process ID: " << processId << ", ";
        std::cout << "Thread ID: " << threadId << std::endl;
        Sleep(1000);

        if (i == 79) {
            std::cout << "OS04_04_T2 is sleeping for 15 seconds at iteration 80" << std::endl;
            Sleep(15000);
            std::cout << "OS04_04_T2 has awakened at iteration 81" << std::endl;
        }
    }
    return 0;
}

int main() {
    HANDLE thread1 = CreateThread(NULL, 0, OS04_04_T1, NULL, 0, NULL);
    HANDLE thread2 = CreateThread(NULL, 0, OS04_04_T2, NULL, 0, NULL);

    DWORD processId = GetCurrentProcessId();
    DWORD threadId = GetCurrentThreadId();

    for (int i = 0; i < 100; ++i) {
        DWORD processId = GetCurrentProcessId();
        DWORD threadId = GetCurrentThreadId();

        std::cout << "Thread: OS04_04, ";
        std::cout << "Process ID: " << processId << ", ";
        std::cout << "Thread ID: " << threadId << std::endl;
        Sleep(1000);

        if (i == 29) {
            std::cout << "Main thread is sleeping for 10 seconds at iteration 30" << std::endl;
            Sleep(10000);
            std::cout << "Main thread has awakened at iteration 31" << std::endl;
        }
    }

    WaitForSingleObject(thread1, INFINITE);
    WaitForSingleObject(thread2, INFINITE);

    CloseHandle(thread1);
    CloseHandle(thread2);

    return 0;
}
