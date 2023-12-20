#include <iostream>

#pragma comment(lib, "../../SP02_lib/x64/Debug/SP02_lib")
#include "../../SP02_lib/SP02_lib/SP02_LIB.h"
int main()
{
	try
	{
		SP2HANDLE h1 = SP2::Init();
		SP2HANDLE h2 = SP2::Init();

		std::cout << "SP2::Adder::Add(h1, 2, 3) = " << SP2::Adder::Add(h1, 2, 3) << "\n";
		std::cout << "SP2::Adder::Add(h2, 2, 3) = " << SP2::Adder::Add(h2, 2, 3) << "\n";

		std::cout << "SP2::Adder::Sub(h1, 2, 3) = " << SP2::Adder::Sub(h1, 2, 3) << "\n";
		std::cout << "SP2::Adder::Sub(h2, 2, 3) = " << SP2::Adder::Sub(h2, 2, 3) << "\n";

		std::cout << "SP2::Multiplier::Mul(h1, 2, 3) = " << SP2::Multiplier::Mul(h1, 2, 3) << "\n";
		std::cout << "SP2::Multiplier::Mul(h2, 2, 3) = " << SP2::Multiplier::Mul(h2, 2, 3) << "\n";

		std::cout << "SP2::Multiplier::Div(h1, 2, 3) = " << SP2::Multiplier::Div(h1, 2, 3) << "\n";
		std::cout << "SP2::Multiplier::Div(h2, 2, 3) = " << SP2::Multiplier::Div(h2, 2, 3) << "\n";

		SP2::Dispose(h1);
		SP2::Dispose(h2);
		return 0;

	}
	catch (int e) { std::cout << "SP02_04: error = " << e << "\n"; }

}


