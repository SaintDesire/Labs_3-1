#pragma once
#include"COM.h"

#define FNAME L"Smw.KN.COM"
#define VINDX L"Smw.KN.1"
#define PRGID L"Smw.KN"

// {DFF6D70A-C4D9-414F-B7C2-0D5C3FC0CDF0}
static const GUID CLSID_SP =
{ 0xdff6d70a, 0xc4d9, 0x414f, { 0xb7, 0xc2, 0xd, 0x5c, 0x3f, 0xc0, 0xcd, 0xf0 } };

// {A7308BF0-5770-46F8-86CB-BADEF0BA16A3}
static const GUID IID_Adder =
{ 0xa7308bf0, 0x5770, 0x46f8, { 0x86, 0xcb, 0xba, 0xde, 0xf0, 0xba, 0x16, 0xa3 } };


struct IAdder : IUnknown
{
    virtual HRESULT STDMETHODCALLTYPE Add(const double x, const double y, double& z) = 0;
    virtual HRESULT STDMETHODCALLTYPE Sub(const double x, const double y, double& z) = 0;
};


// {31CDAE97-DD77-4701-991D-EA6963CB16BD}
static const GUID IID_Multiplier =
{ 0x31cdae97, 0xdd77, 0x4701, { 0x99, 0x1d, 0xea, 0x69, 0x63, 0xcb, 0x16, 0xbd } };


struct IMultiplier : IUnknown
{
    virtual HRESULT STDMETHODCALLTYPE Mul(const double x, const double y, double& z) = 0;
    virtual HRESULT STDMETHODCALLTYPE Div(const double x, const double y, double& z) = 0;
};
