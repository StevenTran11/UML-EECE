#pragma once
/*
 * EECE.3220: Data Structures
 * Instructor: M. Geiger
 * Simple Node class that can be used with
 *   any list-based data structure
 *   (stack, queue, linked list)
 * This version uses templates to make the Node
 *   type even more flexible
 * Node.h: class definition
 *
 **** YOU SHOULD NOT NEED TO MODIFY THIS FILE ****
 */

#ifndef NODE_H
#define NODE_H

template <class T>
class Node
{
public:
	// Constructor 
	Node(T v, Node<T> *p) : val(v), next(p) {}

	// Accessor for data 
	T getVal() { return val; }

	// Accessor for next pointer
	Node<T> *getNext() { return next; }
private:
	T val;			// Actual data stored in node
	Node<T> *next;			// Pointer to next node
};

#endif // NODE_H
