int main(int argc, char *argv[])
{
    DWORD foo;
    char stuff[10];

    CloseHandle(GetStdHandle(STD_OUTPUT_HANDLE ));
    CloseHandle(GetStdHandle(STD_ERROR_HANDLE ));

    ReadConsole(GetStdHandle( STD_INPUT_HANDLE ), stuff, 5, &foo, NULL);
}

