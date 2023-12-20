#include<objbase.h>
#include"SP02.h"
#include"../SP02_COM/Interface.h"
//#include "ImplClass.cpp"

#include<string>

#define IERR(s)    std::cout<<"error "<<s<<std::endl
#define IRES(s,r)  std::cout<<s<<r<<std::endl

IAdder* pIAdder = nullptr;
IMultiplier* pMultiplier = nullptr;

int main()
{
	IUnknown* pIUnknown = NULL;
	CoInitialize(NULL);   
	HRESULT hr0 = CoCreateInstance(CLSID_SP, NULL, CLSCTX_INPROC_SERVER, IID_IUnknown, (void**)&pIUnknown);               //создание экземпл€ра и получение указател€ на IUnknown COM CLSCTX_INPROC_SERVER - это контекст выполнени€  внутри процесса 

	if (SUCCEEDED(hr0))
	{
		std::cout << "CoCreateInstance succeeded" << std::endl;
		if (SUCCEEDED(pIUnknown->QueryInterface(IID_Adder, (void**)&pIAdder)))
		{
			{
				double z = 0.0;
				if (!SUCCEEDED(pIAdder->Add(2.0, 3.0, z)))  IERR("IAdder::Add");
				else IRES("IAdder::Add = ", z);
			}
			{
				double z = 0.0;
				if (!SUCCEEDED(pIAdder->Sub(2.0, 3.0, z)))  IERR("IAdder::Sub");
				else IRES("IAdder::Sub = ", z);
			}
			if (SUCCEEDED(pIAdder->QueryInterface(IID_Multiplier, (void**)&pMultiplier)))
			{
				{
					double z = 0.0;
					if (!SUCCEEDED(pMultiplier->Mul(2.0, 3.0, z))) IERR("IMultiplier::Mul");
					else IRES("Multiplier::Mul = ", z);
				}
				{
					double z = 0.0;
					if (!SUCCEEDED(pMultiplier->Div(2.0, 3.0, z))) IERR("IMultiplier::Div");
					else IRES("IMultiplier::Div = ", z);
				}
				if (SUCCEEDED(pMultiplier->QueryInterface(IID_Adder, (void**)&pIAdder)))
				{
					double z = 0.0;
					if (!SUCCEEDED(pIAdder->Add(2.0, 3.0, z))) IERR("IAdder::Add");
					else IRES("IAdder::Add = ", z);
					pIAdder->Release();
				}
				else  IERR("IMultiplier->IAdder");
				pMultiplier->Release();
			}
			else IERR("IAdder->IMultiplier");
			pIAdder->Release();
		}
		else  IERR("IAdder");
	}
	else
		std::cerr << "CoCreateInstance error: " << hr0 << std::endl;
	pIUnknown->Release();
	CoFreeUnusedLibraries();                   // завершение работы с библиотекой      

	return 0;
}
//
//
//#include <iostream>
//#include <Unknwn.h>
//#include "../SP02_COM/Interface.h"
//
//
//using std::cout;
//
//#define IERR(s) std::cout << "error: " << s << std::endl;
//#define IRES(s,r) std::cout << s << r << std::endl;
//
//IAdder* pIAdder = nullptr;
//IMultiplier* pIMultiplier = nullptr;
//
//static const CLSID CLSID_CA =
//{ 0x02fe8a5e, 0x281b, 0x4e3a, { 0x8f, 0x87, 0x6c, 0x54, 0x4d, 0xed, 0xa9, 0x94 } };
//
//void main() {
//    IUnknown* pIUnknown = nullptr;
//
//    CoInitialize(NULL);
//
//    HRESULT hr0 = CoCreateInstance(CLSID_CA, NULL, CLSCTX_INPROC_SERVER, IID_IUnknown, (void**)&pIUnknown);
//
//    if (FAILED(hr0)) {
//        IERR("CoCreateInstance");
//        return;
//    }
//
//    if (SUCCEEDED(pIUnknown->QueryInterface(IID_Multiplier, (void**)&pIMultiplier))) {
//        double z = 0.0;
//
//        if (FAILED(pIMultiplier->Mul(2.0, 3.0, z))) {
//            IERR("IMultiplier->Mul")
//        }
//        else {
//            IRES("2 * 3 = ", z)
//        }
//
//        if (FAILED(pIMultiplier->Div(6.0, 3.0, z))) {
//            IERR("IMultiplier->Div")
//        }
//        else {
//            IRES("6 / 3 = ", z)
//        }
//    }
//    else {
//        IERR("IMultiplier->QueryInterface")
//    }
//
//    pIMultiplier->Release();
//
//    if (SUCCEEDED(pIUnknown->QueryInterface(IID_Adder, (void**)&pIAdder))) {
//        double z = 0.0;
//
//        if (FAILED(pIAdder->Add(2.0, 3.0, z))) {
//            IERR("IAdder->Add")
//        }
//        else {
//            IRES("2 + 3 = ", z)
//        }
//
//        if (FAILED(pIAdder->Sub(6.0, 3.0, z))) {
//            IERR("IAdder->Sub")
//        }
//        else {
//            IRES("6 - 3 = ", z)
//        }
//    }
//    else {
//        IERR("IAdder->QueryInterface")
//    }
//
//    pIAdder->Release();
//    pIUnknown->Release();
//
//    CoUninitialize();
//}
