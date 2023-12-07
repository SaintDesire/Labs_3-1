#include "pch.h"
#include "COM.h"
#include"SEGLOG.h"
#include"Interface.h"
#include"ImplClass.h"
#include"ImplClassFactory.h"


STDAPI DllCanUnloadNow()                                                         //освобождение 
{
	if ((g_lLocks == 0) && (g_lObjs == 0))
		return S_OK;
	else
		return S_FALSE;
}
STDAPI DllGetClassObject(const CLSID& clsid, const IID& iid, void** ppv) {                                                    //1 когда CoCreateInstance
	HRESULT rc = E_UNEXPECTED;
	ImplClassFactory* pF;
	if (clsid != CLSID_SP) rc = CLASS_E_CLASSNOTAVAILABLE;
	else if ((pF = new ImplClassFactory()) == NULL) rc = E_OUTOFMEMORY;
	else {
		rc = pF->QueryInterface(iid, ppv);
		pF->Release();
	}
	return rc;
}
