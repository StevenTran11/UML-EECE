#pragma once
#include <iostream>
#include <string>
#include "QItem.h"
using std::cout;

template <class T>
class Queue {
public:
	Queue(unsigned maxSize = 1024);
	~Queue();
	bool empty() const;
	void enqueue(const T &val);
	void dequeue();
	T getFront();
private:
	T* list;
	int front, back;
	unsigned cap;
};

// Constructor
template <class T>
Queue<T>::Queue(unsigned maxSize) : front(0), back(0), cap(maxSize)
{
	list = new T[maxSize];
}

// Destructor
template <class T>
Queue<T>::~Queue()
{
	delete[] list;
}

// True if list is empty
template <class T>
bool Queue<T>::empty() const {
	return (front == back);		// Returns true if front == back
								//   false otherwise
}

// Add new value to back of queue
template <class T>
void Queue<T>::enqueue(const T &val) {
	if ((back + 1) % cap == front)		// Queue is full
		cout << "error\n";

	else {				// At least one empty spot in queue
		list[back] = val;
		back = (back + 1) % cap;
	}
}

// Remove element at front of Queue
template <class T>
void Queue<T>::dequeue() {
	if (!empty())			// Can't remove from empty queue
		front = (front + 1) % cap;
}

// Retrieve value of element at top of Queue
template <class T>
T Queue<T>::getFront() {
	if (!empty())
		return list[front];

	// Empty queue--return garbage data
	else {
		//cout << "error: empty queue\n";
		return list[cap - 1];
	}
}