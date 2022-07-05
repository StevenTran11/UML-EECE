#include <iostream>
#include <string>
#include <cctype>
#include "Node.h"
#include "Stack.h"

using namespace std;

//do math
int operate(int val1, int val2, char operation)
{
	if (operation == '+') return val1 + val2;
	if (operation == '-') return val1 - val2;
	if (operation == '*') return val1 * val2;
	if (operation == '/') return val1 / val2;
}

//check if character is operator
bool isOp(char c)
{
	return (c == '+' || c == '-' || c == '*' || c == '/' || c == '(' || c == ')');
}

//determine PEMDAS
int priority(char c)
{
	if (c == '*' || c == '/')
		return 2;
	else  if (c == '+' || c == '-')
		return 1;
}

//infix to postfix
string postFix(string infix)
{
	string equation;
	Stack<char> operators;

	//check all characters in equation
	for (unsigned int i = 0; i < infix.length(); i++)
	{
		//if number, copy to string
		if ((infix[i] >= '0' && infix[i] <= '9'))
		{
			equation.push_back(infix[i]);
			equation.push_back(' ');
		}
		//if operation
		else if (isOp(infix[i]))
		{
			if (infix[i] == '(')
			{
				operators.push(infix[i]); //add to end of equation string
			}
			else if (infix[i] == ')')
			{
				//copy and pop all operations up to (, then pop (
				do
				{
					equation.push_back(operators.getTop());
					equation.push_back(' ');
					operators.pop();
				} while (operators.getTop() != '(');
				operators.pop();
			}
			//order of operation, left to right is fine
			else if (operators.empty() || (priority(operators.getTop()) <= priority(infix[i])) || operators.getTop() == '(')
			{
				operators.push(infix[i]);
			}
			//order of operation, left to right is not fine. copy and pop operations up to (
			else if (priority(operators.getTop()) > priority(infix[i]))
			{
				while (!operators.empty() && operators.getTop() != '(')
				{
					equation.push_back(operators.getTop());
					equation.push_back(' ');
					operators.pop();
				}
				equation.push_back(infix[i]);
				equation.push_back(' ');
			}
		}
	}
	//pop rest of operations
	while (!operators.empty())
	{
		equation.push_back(operators.getTop());
		equation.push_back(' ');
		operators.pop();
	}
	return equation;
}

//do math
int calculate(string postfix)
{
	char prev, current;
	int result;
	Stack<char> numbers;

	//index through string
	for (unsigned int i = 0; i < postfix.length(); i++)
	{
		//since single digits, check if equal and between 0 and 9 and add to stack
		if (postfix[i] >= '0' && postfix[i] <= '9')
		{
			numbers.push(postfix[i]);
		}
		//when get to operations, pop 2 values and do math.
		else if (isOp(postfix[i]))
		{
			current = numbers.getTop() - '0'; //change to int
			numbers.pop();
			prev = numbers.getTop() - '0';
			numbers.pop();
			result = operate(prev, current, postfix[i]) + 48; //change back to char since stack numbers are in ascii
			numbers.push(result);
		}
	}
	result = numbers.getTop() - 48; //account for ascii values and subtract 48
	return result;
}

int main()
{
	string infix;
	Stack<char> operators;

	do
	{
		cout << "Enter expression (or exit to end):" << endl;
		getline(cin, infix);
		if (infix == "exit")
		{
			cout << "Exiting program ..." << endl;
		}
		else if (infix[0] != '(' && infix[0] != 'e' && (infix[0] < '0' || infix[0] > '9'))
		{
			cout << "Invalid expression" << endl;
		}

		else
		{
			cout << "Expression: " << infix << endl;
			cout << "Postfix Form: " << postFix(infix) << endl;
			cout << "Result: " << calculate(postFix(infix)) << endl;
		}
	} while (infix != "exit");
	return 0;

}