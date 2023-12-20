#pragma once
//#include"Interface.h"
//#include<iostream>
//
//
extern long g_lObjs;
extern long g_lLocks;

#pragma once
#include <objbase.h>
#include <Unknwn.h>
#include "Interface.h"




class ImplClass : public IAdder, public IMultiplier {
private:
	ULONG counter;
public:
	ImplClass();
	~ImplClass();
	HRESULT __stdcall QueryInterface(const IID& iid, void** ppv);
	ULONG __stdcall AddRef();
	ULONG __stdcall Release();

	HRESULT __stdcall Add(const double, const double, double&);
	HRESULT __stdcall Sub(const double, const double, double&);
	HRESULT __stdcall Mul(const double, const double, double&);
	HRESULT __stdcall Div(const double, const double, double&);
};

