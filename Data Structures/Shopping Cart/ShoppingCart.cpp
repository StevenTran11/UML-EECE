#include <iostream>
#include "ShoppingCart.h"
using namespace std;

ShoppingCart::ShoppingCart()
{
	customerName = "none";
	currentDate = "January 1, 2016";
}
ShoppingCart::ShoppingCart(string Name, string Date)
{
	customerName = Name;
	currentDate = Date;
}
string ShoppingCart::GetCustomerName()
{
	return customerName;
}
string ShoppingCart::GetDate()
{
	return currentDate;
}
void ShoppingCart::AddItem(ItemToPurchase item)
{
	cartItems.push_back(item);
}
void ShoppingCart::RemoveItem(string item)
{
	unsigned int arraysize = cartItems.size();
	for (unsigned int i = 0; i < cartItems.size(); i++) {
		if (cartItems.at(i).GetName() == item)
		{
			cartItems.erase(cartItems.begin() + i);
			cout << endl;
		}
	}
	if (arraysize == cartItems.size())
		cout << endl << "Item not found in cart. Nothing removed." << endl; //array size never changed
}
void ShoppingCart::ModifyItem(ItemToPurchase itemToModify)
{
	int newQuantity;
	string itemtomodify;

	cout << "CHANGE ITEM QUANTITY" << endl;
	cout << "Enter the item name:" << endl;
	cin.ignore();
	getline(cin, itemtomodify);
	itemToModify.SetName(itemtomodify);

	int founditem = 0;
	cout << "Enter the new quantity:" << endl;
	cin >> newQuantity;
	for (unsigned int i = 0; i < cartItems.size(); i++)
	{
		if (cartItems.at(i).GetName() == itemToModify.GetName())
		{
			itemToModify.SetQuantity(newQuantity);
			cartItems.at(i).SetQuantity(itemToModify.GetQuantity());
			cout << itemToModify.GetQuantity();
			founditem = 1;
		}
	}
	if (founditem == 0)
		cout << "Item not found in cart. Nothing modified." << endl << endl; //if statement never ran item not found
}
int ShoppingCart::GetNumItemsInCart()
{
	int numItems = cartItems.size();
	return numItems;
}
int ShoppingCart::GetCostOfCart() //why do i need this if im just going to implement it in print total's for loop
{
	int cost = 0;
	for (unsigned int i = 0; i < cartItems.size(); i++)
	{
		cost = cost + cartItems.at(i).GetPrice()*cartItems.at(i).GetQuantity();
	}
	return cost;
}
void ShoppingCart::PrintTotal()
{
	int total = 0;
	cout << customerName << "'s Shopping Cart - " << currentDate << endl;
	if (cartItems.size() == 0)
	{
		cout << "Number of Items: 0" << endl << endl;
		cout << "SHOPPING CART IS EMPTY" << endl << endl;
		cout << "Total: $0" << endl << endl;
	}
	else {
		int quan = 0;
		for (unsigned int i = 0; i < cartItems.size(); i++)
		{
			quan += cartItems[i].GetQuantity();
		}
		cout << "Number of Items: " << quan << endl << endl;
		for (unsigned int i = 0; i < cartItems.size(); i++)
		{
			cartItems.at(i).PrintItemCost();
		}
		total = GetCostOfCart();

		cout << endl << "Total: $" << total << endl << endl;
	}
}
void ShoppingCart::PrintDescriptions()
{
	cout << customerName << "'s Shopping Cart - " << currentDate << endl << endl;
	cout << "Item Descriptions" << endl;
	for (unsigned int i = 0; i < cartItems.size(); ++i)
	{
		cartItems.at(i).PrintItemDescription();
	}
}