#include <iostream>
#include <string>
#include "ItemToPurchase.h"

using namespace std;

ItemToPurchase::ItemToPurchase()
{
	itemName = "none";
	itemPrice = 0;
	itemQuantity = 0;
	itemDescription = "none";
}
ItemToPurchase::ItemToPurchase(string name, string description, int price, int quantity)
{
	itemName = name;
	itemPrice = price;;
	itemQuantity = quantity;
	itemDescription = description;
}
void ItemToPurchase::SetName(string Item)
{
	itemName = Item;
}
void ItemToPurchase::SetPrice(int Price)
{
	itemPrice = Price;
}
void ItemToPurchase::SetQuantity(int Quantity)
{
	itemQuantity = Quantity;
}
string ItemToPurchase::GetName()
{
	return itemName;
}
int ItemToPurchase::GetPrice()
{
	return itemPrice;
}
int ItemToPurchase::GetQuantity()
{
	return itemQuantity;
}
void ItemToPurchase::SetDescription(string itemdescription)
{
	itemDescription = itemdescription;
}
string ItemToPurchase::GetDescription()
{
	return itemDescription;
}
void ItemToPurchase::PrintItemDescription()
{
	cout << itemName << ": " << itemDescription << endl;
}
void ItemToPurchase::PrintItemCost()
{
	cout << itemName << " " << itemQuantity << " @ $" << itemPrice << " = $" << itemQuantity * itemPrice << endl;
}