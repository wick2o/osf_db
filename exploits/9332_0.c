#include <Security/Security.h>
int main(int argc, const char *argv[])
{
    SecKeychainRef defaultKeychain;
    SecKeychainCopyDefault(&defaultKeychain);
    SecKeychainLock(defaultKeychain);
    SecKeychainUnlock(defaultKeychain, 0xFFFFFFFF, "password", true);
    return 0;
}

