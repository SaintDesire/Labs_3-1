#define _CRT_SECURE_NO_WARNINGS
#include <iostream>
#include "../OS11_HTAPI/HT.h"
#include <string>
#pragma comment(lib, "OS11_HTAPI")

using namespace std;

void PrintError(char* str);

int main(int argc, char* argv[])
{
	setlocale(LC_ALL, "Rus");
	srand(time(nullptr));

	try
	{
		if (argc != 2)
		{
			throw "Введите количество аргументов: 2";
		}

		const size_t cSize = strlen(argv[1]) + 1;
		wchar_t* wc = new wchar_t[cSize];
		mbstowcs(wc, argv[1], cSize);

		HT::HTHANDLE* HT = HT::OpenExist(wc);
		if (HT == NULL)
		{
			throw "Хранилище не создано";
		}

		string key, payload = "0";

		while (true)
		{
			Sleep(1000);

			key = "key " + to_string(rand() % 50);

			HT::Element* element = new HT::Element(key.c_str(), (int)key.length() + 1, payload.c_str(), (int)payload.length() + 1);
			Print(element);
			cout << "Elements amount: " << HT->ElementCount << endl;
			if (!Insert(HT, element))
			{
				PrintError(HT->LastErrorMessage);
			}
		}

		HT::Close(HT);
	}
	catch (const char* err)
	{
		cout << err << endl;
		exit(-1);
	}

	exit(0);
}

void PrintError(char* str) {
	std::cout << "error: \t" << str << std::endl;
}