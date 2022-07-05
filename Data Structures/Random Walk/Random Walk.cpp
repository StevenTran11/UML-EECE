#include <iostream>
using namespace std;

int main()
{
    unsigned dir;
    int totalSteps = 0;
    int m = 5;
    int n = 6;
    int x = 2;
    int y = 2;
    int numTrials = 1;

    srand(1);

    int p, q;
    p = x;
    q = y;
    for (int i = 0; i < numTrials; i++)
    {
        cout << "Trial Start : " << p << " " << q << endl;
        while ((p > 0) && (q > 0) && (p < m) && (q < n))
        {
            dir = rand() % 4;

            if (dir == 0)
            {
                p--;
                cout << "West: " << p << " " << q << endl;
            }
            else if (dir == 1)
            {
                p++;
                cout << "East: " << p << " " << q << endl;
            }
            else if (dir == 2)
            {
                q--;
                cout << "North: " << p << " " << q << endl;
            }
            else
            {
                q++;
                cout << "South: " << p << " " << q << endl;
            }
            totalSteps++;
        }
        cout << "Trial total steps = " << totalSteps << endl;
    }
    return 0;
}