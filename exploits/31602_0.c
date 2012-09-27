#include <dbus/dbus.h>

int main ()
{
   return !dbus_signature_validate("a{(ii)i}", NULL);
}
