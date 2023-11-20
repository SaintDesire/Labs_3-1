#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include "../OS11_HTAPI/HT.h"
#include "../OS11_HTAPI/Element.h"
#include <string>
#include <Windows.h>
#pragma comment(lib, "OS11_HTAPI")

using namespace std;

bool checkInt(char* input);
//arguments: file (location + name), sizeFile, snapTime, maxKeyLenght, maxPayloadLenght

int main(int argc, char* argv[])	// ../../Files/newHT.ht 2000 3 4 4
{
	//HINSTANCE load = LoadLibrary(L"../debug/OS11_HTAPI"); //явное подключение
	setlocale(LC_ALL, "Ru");

	try
	{
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
		//	Функция выполняет преобразование много-байтовой строки в строку широких символов.
		//  Строка с многобайтовыми символами передаётся в качестве аргумента, через указатель mbstring,
		//  посимвольно интерпретируется и переводится в эквивалентную строку типа wchar_t, который хранится в памяти, на которую указывает wcstring

		if (GetFileAttributes(wc) != INVALID_FILE_ATTRIBUTES)
		{
			throw "Файл уже существует";
		}

		int capacity = stoi(argv[2]);
		int snapshotinterval = stoi(argv[3]);
		int maxKeyLength = stoi(argv[4]);
		int maxPayloadLength = stoi(argv[5]);

		HT::HTHANDLE* HT = HT::Create(capacity, snapshotinterval, maxKeyLength, maxPayloadLength, wc);
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

		HT::Close(HT);
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