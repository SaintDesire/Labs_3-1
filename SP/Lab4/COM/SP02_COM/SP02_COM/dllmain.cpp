// dllmain.cpp : Определяет точку входа для приложения DLL.
#include "pch.h"
#include<fstream>
#include"SEGLOG.h"

LONG Seq = 0;
std::fstream LogCom;
HMODULE hmodule;
//загрузка выгрузка библиотеки
BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
                     )
{
    switch (ul_reason_for_call)
    {
    case DLL_PROCESS_ATTACH:
        hmodule = hModule;
        LogCom.open("C:\\Users\\Nikita\\Desktop\\Labs_3-1\\SP\\Lab4\\COM\\SP02_COM\\locCom.txt", std::ios_base::out);
        break;
    case DLL_THREAD_ATTACH:                                                                                                              //новый поток создал экземпяр
    case DLL_THREAD_DETACH:               
    case DLL_PROCESS_DETACH:
        LogCom.close();
        break;
    }
    return TRUE;
}

