#include <iostream>
#include <string>
#include <math.h>

using namespace std;

int main() {
    signed char c;
    while (true) {
        cout << "Enter a number 0 to 255, increment by 1\n";
        cin >> c;
        cout << "Signed value in [-1,1] is " << (((c+128.f)/255.f)-0.5f)*2.f << endl;
        cout << "------" << endl;
    }
    return 0;
}
