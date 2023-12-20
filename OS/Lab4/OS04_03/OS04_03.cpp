#include <iostream>
#include <windows.h>

DWORD WINAPI OS04_03_T1(LPVOID lpParam) {
    DWORD processId = GetCurrentProcessId();
    DWORD threadId = GetCurrentThreadId();

    for (int i = 0; i < 50; ++i) {
        std::cout << "Thread: OS04_03_T1 ";
        std::cout << "Process ID: " << processId << ", ";
        std::cout << "Thread ID: " << threadId << std::endl;
        Sleep(990);

        if (i == 19) {
            std::cout << "--Main thread is pausing OS04_03_T1 at iteration 20" << std::endl;
            Sleep(20000);
            std::cout << "--Main thread is resuming OS04_03_T1 at iteration 21" << std::endl;
        }
    }
    return 0;
}

DWORD WINAPI OS04_03_T2(LPVOID lpParam) {
    DWORD processId = GetCurrentProcessId();
    DWORD threadId = GetCurrentThreadId();

    for (int i = 0; i < 125; ++i) {
        std::cout << "Thread: OS04_03_T1, ";
        std::cout << "Process ID: " << processId << ", ";
        std::cout << "Thread ID: " << threadId << std::endl;
        Sleep(1000);

        if (i == 39) {
            std::cout << "--Main thread is pausing OS04_03_T2 at iteration 40" << std::endl;
            Sleep(20000);
            std::cout << "--Main thread is resuming OS04_03_T2 after its completion" << std::endl;
        }
    }
    return 0;
}

int main() {
    HANDLE thread1 = CreateThread(NULL, 0, OS04_03_T1, NULL, 0, NULL);
    HANDLE thread2 = CreateThread(NULL, 0, OS04_03_T2, NULL, 0, NULL);

    DWORD processId = GetCurrentProcessId();
    DWORD threadId = GetCurrentThreadId();

    for (int i = 0; i < 100; ++i) {
        std::cout << "Thread: OS04_03, ";
        std::cout << "Process ID: " << processId << ", ";
        std::cout << "Thread ID: " << threadId << std::endl;
        Sleep(1010);

        if (i == 59) {
            std::cout << "Main thread is resuming OS04_03_T1 at iteration 60" << std::endl;
            WaitForSingleObject(thread1, INFINITE);
        }
    }

    WaitForSingleObject(thread2, INFINITE);

    CloseHandle(thread1);
    CloseHandle(thread2);

    return 0;
}
