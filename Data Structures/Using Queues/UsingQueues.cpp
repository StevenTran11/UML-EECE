#include "Queue.h" //Can use built in library #include <queue>
#include "QItem.h"
#include <fstream>
#include <iostream>
#include <string>

using namespace std;

int main()
{
	ifstream file; //file
	string fileName; //input
	string line; //line in file
	Queue<QItem> express;//express line
	Queue<QItem> normal;//normal line

	cout << "Enter input file name: ";
	cin >> fileName;
	cout << "Reading " << fileName << " ..." << endl;
	file.open(fileName);

	int i = 1;
	while (getline(file, line))//while can get file line
	{
		string a;
		string s;
		string lane;
		string letter;

		int k = 2;
		while (line.at(k) != ' ')//read first #
		{
			a.push_back(line.at(k));
			k++;
		}
		k++;
		s.push_back(line.at(k));//read second #
		QItem temp(i, a, s);//define temp with 3 parameters

		letter = line.at(0);//determine whether express or normal
		if (letter == "E")
		{
			lane = "express";
			express.enqueue(temp);
		}
		else if (letter == "N")
		{
			lane = "normal";
			normal.enqueue(temp);
		}
		cout << "Customer " << i << " to " << lane << " lane " << "(A = " << a << ", S = " << s << ")" << endl;
		//cout << line << endl;
		++i;
	}
	file.close();

	cout << "Done reading " << fileName << endl;

	unsigned int T = 0;

	int count1 = 0;//count of normal service time
	int count2 = 0;//count of express service time
	bool run1 = true;//run first if statement if false and 5th if true
	bool run2 = true;//run second if statement if false and 6th if true
	while (!express.empty() || !normal.empty()) //while queues not empty
	{
		if (count1 == 0 && normal.getFront().arrTime <= T && run1 == true) //Change run1 and run2 to true/false
		{
			cout << "T=" << T << ": Serving customer " << normal.getFront().cNum << " in normal lane" << endl;
			count1 = normal.getFront().svcTime;
			run1 = false;
		}
		if (count2 == 0 && express.getFront().arrTime <= T && run2 == true)
		{
			cout << "T=" << T << ": Serving customer " << express.getFront().cNum << " in express lane" << endl;
			count2 = express.getFront().svcTime;
			run2 = false;
		}
		if (count1 != 0) //decrement down for both express lane and normal lane
		{
			count1--;
		}
		if (count2 != 0)
		{
			count2--;
		}
		if (count1 == 0 && run1 == false) //Done serving dequeue and set serveNext to true
		{
			cout << "T=" << T << ": Done serving customer " << normal.getFront().cNum << " in normal lane" << endl;
			run1 = true;
			normal.dequeue();
		}
		if (count2 == 0 && run2 == false)
		{
			cout << "T=" << T << ": Done serving customer " << express.getFront().cNum << " in express lane" << endl;
			run2 = true;
			express.dequeue();
		}
		T++; //increment timer
	}
	cout << "Done serving all customers" << endl;
	return 0;
}
