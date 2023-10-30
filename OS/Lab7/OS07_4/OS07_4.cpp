#include <iostream>
#include <windows.h>
#include <tchar.h>

int main() {
    setlocale(LC_ALL, "ru");
    STARTUPINFO si;
    PROCESS_INFORMATION pi1, pi2;

    ZeroMemory(&si, sizeof(si));
    si.cb = sizeof(si);
    ZeroMemory(&pi1, sizeof(pi1));
    ZeroMemory(&pi2, sizeof(pi2));

    if (!CreateProcessW(_T("..\\x64\\Debug\\OS07_4_1.exe"), NULL, NULL, NULL, FALSE, CREATE_NEW_CONSOLE, NULL, NULL, &si, &pi1) ||
        !CreateProcessW(_T("..\\x64\\Debug\\OS07_4_2.exe"), NULL, NULL, NULL, FALSE, CREATE_NEW_CONSOLE, NULL, NULL, &si, &pi2)) {
        std::cerr << "Ошибка при создании одного из дочерних процессов." << std::endl;
        return 1;
    }

    WaitForSingleObject(pi1.hProcess, INFINITE);
    WaitForSingleObject(pi2.hProcess, INFINITE);

    CloseHandle(pi1.hProcess);
    CloseHandle(pi1.hThread);
    CloseHandle(pi2.hProcess);
    CloseHandle(pi2.hThread);

    return 0;
}
