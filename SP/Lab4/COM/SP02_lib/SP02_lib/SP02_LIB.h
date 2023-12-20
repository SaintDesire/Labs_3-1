#pragma once
#include"../../SP02_COM/SP02_COM/Interface.h"
#define SP2HANDLE void*



#define IERR(s)    std::cerr<<"ERROR:  "<<s<<std::endl
#define IRES(s,r)  std::cerr<<s<<r<<std::endl

namespace SP2
{
	SP2HANDLE Init();
	namespace Adder
	{
		double Add(SP2HANDLE, double, double);
		double Sub(SP2HANDLE, double, double);
	}

	namespace Multiplier
	{
		double Mul(SP2HANDLE, double, double);
		double Div(SP2HANDLE, double, double);
	}
	void Dispose(SP2HANDLE);
}