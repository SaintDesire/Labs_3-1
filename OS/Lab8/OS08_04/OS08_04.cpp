#include <iostream>
#include <windows.h>

void sh(HANDLE heap) {
    PROCESS_HEAP_ENTRY entry = { 0 };
    SIZE_T committedSize = 0;
    SIZE_T uncommittedSize = 0;

    while (HeapWalk(heap, &entry)) {
        if (entry.wFlags & PROCESS_HEAP_ENTRY_BUSY) {
            committedSize += entry.cbData;
        }
        else {
            uncommittedSize += entry.cbData;
        }
    }

    std::cout << "Committed size: " << committedSize << std::endl;
    std::cout << "Uncommitted size: " << uncommittedSize << std::endl;
}

int main() {
    HANDLE heap = GetProcessHeap();

    // Вывод информации до размещения массива
    std::cout << "Before commit" << std::endl;
    sh(heap);

    // Размещение массива размерности 300000 в heap
    int* arr = (int*)HeapAlloc(heap, 0, 300000 * sizeof(int));

    // Вывод информации после размещения массива
    std::cout << "\nAfter commit" << std::endl;
    sh(heap);

    // Освобождение памяти
    HeapFree(heap, 0, arr);

    return 0;
}