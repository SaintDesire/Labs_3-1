#include <iostream>
#include <cstring>
//
//int main() {
//    const int pageSize = 4096; // Размер страницы в байтах
//    const int numPages = 256;   // Количество страниц
//
//    // Выделение памяти для 256 страниц
//    char* memory = new char[pageSize * numPages];
//
//    // Размещение массива int, занимающего все 256 страниц
//    int* intArray = reinterpret_cast<int*>(memory);
//
//    // Заполнение массива нарастающей последовательностью
//    for (int i = 0; i < pageSize * numPages / sizeof(int); ++i) {
//        intArray[i] = i + 1;
//    }
//
//    // Запись 3 первых букв фамилии в 16-ричном представлении
//    const char lastName[] = { 0x4B, 0x6F, 0x72 };
//    // Копирование букв в память (выберите страницу и смещение внутри страницы)
//    memcpy(memory, lastName, sizeof(lastName));
//
//    // Отображение успешного завершения
//    std::cout << "OS06_03: Completed successfully." << std::endl;
//
//    // Освобождение памяти
//    delete[] memory;
//
//    return 0;
//}


#include <Windows.h>
using namespace std;
#define KB (1024)
#define MB (1024 * KB)
#define PG (4 * KB)


void saymem()
{   
    MEMORYSTATUS ms;
    GlobalMemoryStatus(&ms);
    cout << "Объём физической памяти:      " << ms.dwTotalPhys / KB << " KB\n";
    cout << "Доступно физической памяти:   " << ms.dwAvailPhys / KB << " KB\n";
    cout << "Объем виртуальной памяти:     " << ms.dwTotalVirtual / KB << " KB\n";
    cout << "Доступно виртуальной памяти:  " << ms.dwAvailVirtual / KB << " KB\n\n";
}


/*
    K - 75(10) - 0x4B(16)
    o - 111(10) - 0x6F(16)
    r - 114(10) - 0x72(16)
    Страница 4B = 75
    75 * 4096 = 827392(10) = 0x4И000 - добавить для перехода на страницу
    Смещение F0E = 1783(10) = 0x000006F7
    Искомое значение: начало массива + 0x4B000 + 0x000006F7
*/
int main()
{
    setlocale(LC_ALL, "ru");
    int pages = 256;
    int countItems = pages * PG / sizeof(int);
    SYSTEM_INFO system_info;
    GetSystemInfo(&system_info);

    cout << "\t    Изначально в системе\n";
    saymem();

    LPVOID xmemaddr = VirtualAlloc(NULL, pages * PG, MEM_COMMIT, PAGE_READWRITE);   // выделено 1024 KB виртуальной памяти
    cout << "\tВыделено " << pages * PG / 1024 << " KB вирт. памяти\n";
    saymem();

    int* arr = (int*)xmemaddr;
    for (int i = 0; i < countItems; i++)
        arr[i] = i;

    int* byte = arr + 75 * 1024 + 1783;
    cout << "------  Значение памяти в байте: " << *byte << "  ------\n";

    VirtualFree(xmemaddr, NULL, MEM_RELEASE) ? cout << "\tВиртуальная память освобождена\n" : cout << "\tВиртуальная память не освобождена\n";
    saymem();
}