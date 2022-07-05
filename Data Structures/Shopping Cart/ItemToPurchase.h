#pragma once
#ifndef ITEM_TO_PURCHASE_H
#define ITEM_TO_PURCHASE_H

#include <string>
using namespace std;

class ItemToPurchase
{
public:
	ItemToPurchase();
	ItemToPurchase(string itemName, string itemDescription, int itemPrice, int itemQuantity);

	void SetName(string Name);
	void SetPrice(int itemPrice);
	void SetQuantity(int itemQuantity);
	void SetDescription(string itemDescription);
	void PrintItemCost();
	void PrintItemDescription();

	string GetName();
	int GetPrice();
	int GetQuantity();
	string GetDescription();

private:
	string itemName;
	int itemPrice;
	int itemQuantity;
	string itemDescription;
};
#endif