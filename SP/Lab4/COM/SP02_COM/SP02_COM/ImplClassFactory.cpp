#include"pch.h"
#include "ImplClassFactory.h"
#include"Interface.h"
#include"ImplClass.h"

long g_lObjs = 0;
long g_lLocks = 0;

ImplClassFactory::ImplClassFactory() {
    m_lRef = 1;
}

ImplClassFactory::~ImplClassFactory() {};


STDMETHODIMP_(HRESULT __stdcall) ImplClassFactory::QueryInterface(REFIID riid, void** ppv)
{
    if (riid == IID_IUnknown)
        *ppv = (IUnknown*)this;
    else if (riid == IID_IClassFactory)
        *ppv = (IClassFactory*)this;
    else
        return E_NOINTERFACE;

    if (*ppv) {
        AddRef();
        return (S_OK);
    }
    else
        return (E_NOINTERFACE);
}

STDMETHODIMP_(ULONG) ImplClassFactory::AddRef() {
    InterlockedIncrement(&m_lRef);
    return m_lRef;
}

STDMETHODIMP_(ULONG) ImplClassFactory::Release() {
    InterlockedDecrement(&m_lRef);
    if (m_lRef == 0)
    {
        delete this;
        return 0;
    }
    else
        return m_lRef;
}


STDMETHODIMP ImplClassFactory::CreateInstance(LPUNKNOWN pUnkOuter, REFIID riid, void** ppvObj) {                                      //2

    HRESULT hr = E_UNEXPECTED;

    ImplClass* pImplClass = nullptr;

    if (pUnkOuter != NULL)
        hr = CLASS_E_NOAGGREGATION;
    else if ((pImplClass = new ImplClass()) == NULL)
        hr = E_OUTOFMEMORY;
    else {
        hr = pImplClass->QueryInterface(riid, ppvObj);
        pImplClass->Release();
    }

    if (FAILED(hr))
        delete pImplClass;

    return hr;
}

STDMETHODIMP  ImplClassFactory::LockServer(BOOL fLock) {
    if (fLock)
        InterlockedIncrement(&g_lLocks);
    else
        InterlockedDecrement(&g_lLocks);

    return S_OK;
}