#pragma once
#include <objbase.h>

class ImplClassFactory : public IClassFactory
{
protected:
	ULONG m_lRef;
public:
	ImplClassFactory();
	~ImplClassFactory();

	STDMETHOD(QueryInterface(REFIID riid, void** ppv));
	STDMETHOD_(ULONG, AddRef(void));
	STDMETHOD_(ULONG, Release(void));
	STDMETHOD(CreateInstance(IUnknown* pUO, const IID& id, void** ppv));
	STDMETHOD(LockServer(BOOL b));
};