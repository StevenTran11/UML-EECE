#include <iostream>
#include <string>
#include "QItem.h"

using namespace std;

QItem::QItem()
{
	cNum = 0;
	arrTime = 0;
	svcTime = 0;
}

QItem::QItem(int i, string a, string s)
{
	cNum = i;
	arrTime = stoi(a);
	svcTime = stoi(s);
}