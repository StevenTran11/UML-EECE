#pragma once
#ifndef SHOPPING_CART_H
#define SHOPPING_CART_H

#include <vector> 
#include <string>
#include "ItemToPurchase.h"
using namespace std;

class ShoppingCart
{
public:
	ShoppingCart();
	ShoppingCart(string Name, string Date);

	void AddItem(ItemToPurchase item);
	void RemoveItem(string ItemToRemove);
	void ModifyItem(ItemToPurchase);
	int GetNumItemsInCart();
	int GetCostOfCart();
	void PrintTotal();
	void PrintDescriptions();

	string GetCustomerName();
	string GetDate();

private:
	string customerName;
	string currentDate;
	vector<ItemToPurchase> cartItems;
};
#endif