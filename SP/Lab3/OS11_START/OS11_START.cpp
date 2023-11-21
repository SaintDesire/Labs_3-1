#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include "../OS11_HTAPI/HT.h"
#include <string>

using namespace std;
using namespace HT;

int main(int argc, char* argv[])	// ..//Files/newHT.ht
{
	setlocale(LC_ALL, "Rus");
	HMODULE libModule = NULL;
	typedef HTHANDLE* (*OpenFunc)(const wchar_t FileName[512]);
	typedef BOOL (*SnapFunc)(HTHANDLE* ht);
	typedef BOOL (*CloseFunc)(HTHANDLE* ht);
	try
	{
		HMODULE libModule = LoadLibrary(L"./OS11_HTAPI");
		if (!libModule)
		{
			throw "Невозможно загрузить библиотеку";
		}
		if (argc != 2)
		{
			throw "Введите количество аргументов: 2";
		}
		const size_t cSize = strlen(argv[1]) + 1;
		wchar_t* wc = new wchar_t[cSize];
		mbstowcs(wc, argv[1], cSize);

		OpenFunc openFunc = (OpenFunc)GetProcAddress(libModule, "Open");
		SnapFunc snapFunc = (SnapFunc)GetProcAddress(libModule, "Snap");
		CloseFunc closeFunc = (CloseFunc)GetProcAddress(libModule, "Close");

		if (!openFunc || !snapFunc || !closeFunc)
		{
			throw "Ошибка при получении адресов функций";
		}

		HTHANDLE* HT = openFunc(wc);
		if (HT == NULL)
		{
			throw "Хранилище не создано";
		}

		cout << "HT-Storage Start !" << endl;
		wcout << "filename = " << wc << endl;
		cout << "snapshotinterval = " << HT->SecSnapshotInterval << endl;
		cout << "capacity = " << HT->Capacity << endl;
		cout << "maxkeylength = " << HT->MaxKeyLength << endl;
		cout << "maxdatalength = " << HT->MaxPayloadLength << endl;

		while (true) {
			Sleep((HT->SecSnapshotInterval) * 1000);
			snapFunc(HT);
			cout << "----SNAPSHOT in Thread----" << endl;
		}
		snapFunc(HT);
		closeFunc(HT);
		FreeLibrary(libModule);
	}
	catch (const char* err)
	{
		cout << err << endl;
		FreeLibrary(libModule);
		exit(-1);
	}

	exit(0);
}