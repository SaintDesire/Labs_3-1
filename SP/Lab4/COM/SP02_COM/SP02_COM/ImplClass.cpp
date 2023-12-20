#include"pch.h"
//#include"Interface.h"
#include"ImplClass.h"
#include "pch.h"

ImplClass::ImplClass() : counter(1) {}

ImplClass::~ImplClass() {}

HRESULT __stdcall ImplClass::QueryInterface(const IID& iid, void** ppv) {
    if (iid == IID_Adder) {
        *ppv = (IAdder*)this;
    }
    else if (iid == IID_Multiplier) {
        *ppv = (IMultiplier*)this;
    }
    else {
        *ppv = this;
    }

    this->AddRef();
    return S_OK;
}

ULONG __stdcall ImplClass::AddRef() {
    InterlockedIncrement(&counter);
    return counter;
}

ULONG __stdcall ImplClass::Release() {
    InterlockedDecrement(&counter);

    if (counter == 0) {
        delete this;
        return 0;
    }

    return counter;
}

HRESULT __stdcall ImplClass::Add(const double x, const double y, double& c) {
    c = x + y;
    return S_OK;
}

HRESULT __stdcall ImplClass::Sub(const double x, const double y, double& c) {
    c = x - y;
    return S_OK;
}

HRESULT __stdcall ImplClass::Mul(const double x, const double y, double& c) {
    c = x * y;
    return S_OK;
}

HRESULT __stdcall ImplClass::Div(const double x, const double y, double& c) {
    c = x / y;
    return S_OK;
}