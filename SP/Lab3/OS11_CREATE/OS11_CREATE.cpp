#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include "../OS11_HTAPI/HT.h"
#include "../OS11_HTAPI/Element.h"
#include <string>
#include <Windows.h>


using namespace std;
using namespace HT;

bool checkInt(char* input);
//arguments: file (location + name), sizeFile, snapTime, maxKeyLenght, maxPayloadLenght

int main(int argc, char* argv[])	
{
	setlocale(LC_ALL, "Ru");
	typedef HTHANDLE* (*CreateFunc)(int	Capacity, int SecSnapshotInterval, int MaxKeyLength, int MaxPayloadLength, const wchar_t FileName[512]);
	typedef BOOL(*CloseFunc)(HTHANDLE* ht);
	try
	{
		HMODULE libModule = LoadLibrary(L"./OS11_HTAPI");
		if (!libModule) {
			throw "Невозможно загрузить библиотеку";
		}
		if (argc != 6)
		{
			throw "Введите количество аргументов: 6";
		}
		if (!checkInt(argv[2]) || !checkInt(argv[3]) || !checkInt(argv[4]) || !checkInt(argv[5]))
		{
			throw "Введите корректные значения";
		}
		const size_t cSize = strlen(argv[1]) + 1;
		wchar_t* wc = new wchar_t[cSize];
		mbstowcs(wc, argv[1], cSize);

		CreateFunc createFunc = (CreateFunc)GetProcAddress(libModule, "Create");
		CloseFunc closeFunc = (CloseFunc)GetProcAddress(libModule, "Close");

		if (GetFileAttributes(wc) != INVALID_FILE_ATTRIBUTES)
		{
			throw "Файл уже существует";
		}

		int capacity = stoi(argv[2]);
		int snapshotinterval = stoi(argv[3]);
		int maxKeyLength = stoi(argv[4]);
		int maxPayloadLength = stoi(argv[5]);

		HT::HTHANDLE* HT = createFunc(capacity, snapshotinterval, maxKeyLength, maxPayloadLength, wc);
		if (HT == NULL)
		{
			throw "Хранилище не создано";
		}

		cout << "HT-Storage Created!" << endl;
		wcout << "filename = " << wc << endl;
		cout << "snapshotinterval = " << snapshotinterval << endl;
		cout << "capacity = " << capacity << endl;
		cout << "maxkeylength = " << maxKeyLength << endl;
		cout << "maxdatalength = " << maxPayloadLength << endl;

		closeFunc(HT);
	}
	catch (const char* err)
	{
		cout << err << endl;
		exit(-1);
	}

	exit(0);
}

bool checkInt(char* input)
{
	int i = 0;
	while (input[i] != '\0')
	{
		if (input[i] < '0' || input[i] > '9')
			return false;
		i++;
	}
	return true;
}