#include <iostream>
#include <windows.h>

void DisplayProcessAndThreadInfo() {
    DWORD processId = GetCurrentProcessId();
    DWORD threadId = GetCurrentThreadId();

    std::cout << "Process ID: " << processId << std::endl;
    std::cout << "Thread ID: " << threadId << std::endl;
    std::cout << "------------------------" << std::endl;
}

int main() {
    while (true) {
        DisplayProcessAndThreadInfo();
        Sleep(1000);
    }

    return 0;
}
