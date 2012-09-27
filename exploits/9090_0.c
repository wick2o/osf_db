/*
        simple buffer overflow generator by MegaHz megahz@megahz.org
*/
#include <iostream>
using namespace std;

int main()
{
int i;
for (i=0;i<=9999999;i++)
        {
        cout << "A";
        }
        return 0;
}

