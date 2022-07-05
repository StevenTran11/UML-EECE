#pragma once
/*
 * EECE.3220: Data Structures
 * Instructor: M. Geiger
 * Linked stack definition
 *
 * Stack.h: class definition
 *  Stack class template contains
 *    all function definitions in
 *    header file
 **** YOU SHOULD NOT NEED TO MODIFY THIS FILE ****
 */


#ifndef STACK_H
#define STACK_H

#include <iostream>
using namespace std;

#include "Node.h"

template <class T>
class Stack {
public:
	Stack();						// Constructor
	~Stack();						// Destructor
	bool empty() const;				// Checks if stack is empty
	void push(const T &val);		// Pushes data on top of stack
	void pop();						// Removes top item from stack
	T getTop();						// Accessor for data in top node

	/*** OVERLOADED OPERATORS ***/
	Stack<T> &operator =(const Stack<T> &rhs);
	bool operator ==(const Stack<T> &rhs);

	// Template declaration necessary here because operator
	//    is technically outside class
	template <class U>
	friend ostream &operator <<(ostream &out, Stack<U> &aStack);

private:
	Node<T> *top;		// Node at top of stack
};

/*** FUNCTION DEFINITIONS ***/

// Constructor
template <class T>
Stack<T>::Stack() : top(NULL)
{}

// Destructor
// Deletes nodes from stack until it's empty
template <class T>
Stack<T>::~Stack()
{
	while (!empty()) {
		pop();
	}
}

// Checks if stack is empty
template <class T>
bool Stack<T>::empty() const {
	return (top == NULL);
}

// Pushes data on top of stack
template <class T>
void Stack<T>::push(const T &val) {
	top = new Node<T>(val, top);
}

// Removes top item from stack
template <class T>
void Stack<T>::pop() {
	Node<T> *temp;
	if (top == NULL)
		cout << "Just kidding--stack is empty\n";
	else {
		temp = top;
		top = top->getNext();
		delete temp;
	}
}

template <class T>
T Stack<T>::getTop() {
	return top->getVal();
}

// Overloaded assignment--performs deep copy
template <class T>
Stack<T> &Stack<T>::operator =(const Stack<T> &rhs) {
	Stack<T> temp;
	Node<T> *p;

	if (!(*this == rhs)) {
		// Step 0. If there's data in the calling object, empty it
		while (!empty())
			pop();

		// Step 1. Copy data from rhs to temp, in reverse order
		p = rhs.top;
		while (p != NULL) {
			temp.push(p->getVal());
			p = p->getNext();
		}

		// Step 2. Empty temp stack and copy data to calling object
		while (!temp.empty()) {
			this->push(temp.getTop());
			temp.pop();
		}
	}
	return *this;
}

// Overloaded comparison
template <class T>
bool Stack<T>::operator ==(const Stack<T> &rhs) {
	Node<T> *tmp1, *tmp2;	// Node pointer for each stack

	tmp1 = top;		// Top of calling object
	tmp2 = rhs.top;	// Top of RHS

	// Traverse stacks while:
	//  (1) Haven't hit end of either one (tested in loop condition), and
	//  (2) Data in all nodes so far match (if statement will exit if false)
	while (tmp1 != NULL && tmp2 != NULL) {

		// If mismatch found, exit function
		if (tmp1->getVal() != tmp2->getVal())
			return false;

		// Move both Node pointers ahead to next node
		tmp1 = tmp1->getNext();
		tmp2 = tmp2->getNext();
	}

	// Stacks are same length & contain same data
	//   (if they were same length and contained different data,
	//    if statement in loop would have forced function to 
	//    return false before reaching this point)
	if (tmp1 == NULL && tmp2 == NULL)
		return true;

	// Else case: one stack is shorter than the other
	else
		return false;
}

// Overloaded output (friend function)
template <class T>
ostream &operator <<(ostream &out, Stack<T> &aStack) {
	Node<T> *temp = aStack.top;
	while (temp != NULL) {
		cout << temp->getVal() << '\n';
		temp = temp->getNext();
	}
	return out;
}
/*** END FUNCTION DEFINITIONS ***/


#endif //STACK_H