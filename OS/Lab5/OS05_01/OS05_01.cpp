#include <iostream>
#include <Windows.h>
#include <bitset>

int main()
{
    setlocale(LC_ALL, "RUS");

    auto process = GetCurrentProcess();
    auto thread = GetCurrentThread();

    DWORD_PTR processAffinityMask;
    DWORD_PTR systemAffinityMask;

    std::cout << "- Current process ID: " << GetCurrentProcessId()
        << "\n- Current (main) thread ID: " << GetCurrentThreadId()
        << "\n- Priority (priority class) of the current process: " << GetPriorityClass(process)
        << "\n- Priority of the current thread: " << GetThreadPriority(thread);

    if (GetProcessAffinityMask(process, &processAffinityMask, &systemAffinityMask)) {
        // Convert the mask to a binary string
        std::string binaryString = std::bitset<sizeof(DWORD_PTR) * 8>(processAffinityMask).to_string();

        // Remove leading zeros
        size_t firstNonZero = binaryString.find_first_not_of('0');
        if (firstNonZero != std::string::npos) {
            binaryString = binaryString.substr(firstNonZero);
        }

        std::cout << "\n- Mask of processors available to the process (in binary): " << binaryString << "\n";
    }
    else {
        DWORD error = GetLastError();
        std::cerr << "\nError getting the processor affinity mask for the process. Error code: " << error << "\n";
    }

    if (GetProcessAffinityMask(process, &processAffinityMask, &systemAffinityMask)) {
        // Count the number of set bits in the mask
        int processorCount = 0;
        DWORD_PTR mask = 1;
        while (mask != 0) {
            if ((processAffinityMask & mask) != 0) {
                processorCount++;
            }
            mask <<= 1;
        }
        std::cout << "\n- Number of processors available to the process: " << processorCount << "\n";
    }
    else {
        DWORD error = GetLastError();
        std::cerr << "\nError getting the processor affinity mask for the process. Error code: " << error << "\n";
    }

    std::cout << "\n- Processor assigned to the current thread: " << GetCurrentProcessorNumber() << "\n";

    system("pause");
}
