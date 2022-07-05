#include <string>
#include <iostream>
using namespace std;

#include "ItemToPurchase.h"
#include "ShoppingCart.h"

void PrintMenu(ShoppingCart itemCart) {
	char command = ' ';
	int loop_count = 0;

	while (command != 'q')
	{
		if (command == 'a' || command == 'd' || command == 'c' || command == 'i' || command == 'o' || loop_count == 0) {
			cout << "MENU" << endl;
			cout << "a - Add item to cart" << endl;
			cout << "d - Remove item from cart" << endl;
			cout << "c - Change item quantity" << endl;
			cout << "i - Output items' descriptions" << endl;
			cout << "o - Output shopping cart" << endl;
			cout << "q - Quit" << endl << endl;
			cout << "Choose an option:" << endl;
			cin >> command;
		}
		else 
		{
			cout << "Choose an option:" << endl;
			cin >> command;
		}
		loop_count++; 

		if (command == 'a')
		{
			string itemName = "";
			string itemDescription;
			int itemQuantity;
			int itemPrice;
			cout << "ADD ITEM TO CART" << endl;
			cout << "Enter the item name:" << endl;
			cin.ignore();
			getline(cin, itemName);
			cout << "Enter the item description:" << endl;
			getline(cin, itemDescription);
			cout << "Enter the item price:" << endl;
			cin >> itemPrice;
			cout << "Enter the item quantity:" << endl << endl;
			cin >> itemQuantity;

			ItemToPurchase temp(itemName, itemDescription, itemPrice, itemQuantity); //insert values into temp
			
			itemCart.AddItem(temp); //add temp to vector
		}
		else if (command == 'd')
		{
			string itemtoremove;
			cout << "REMOVE ITEM FROM CART" << endl;
			cout << "Enter name of item to remove:";
			cin.ignore();
			getline(cin, itemtoremove);
			itemCart.RemoveItem(itemtoremove);
			cout << endl;
		}
		else if (command == 'c')
		{
			ItemToPurchase itemtomodify;
			itemCart.ModifyItem(itemtomodify);
		}
		else if (command == 'i')
		{
			cout << "OUTPUT ITEMS' DESCRIPTIONS" << endl;
			itemCart.PrintDescriptions();
			cout << endl;
		}
		else if (command == 'o')
		{
			cout << "OUTPUT SHOPPING CART" << endl;
			itemCart.PrintTotal();
		}
		else if (command == 'q')
			exit(0);
		else
			command = ' ';
	}
}

int main() {
	string customerName;
	string currentDate;

	cout << "Enter customer's name:" << endl;
	getline(cin, customerName);
	cout << "Enter today's date:" << endl;
	getline(cin, currentDate);
	cout << endl;
	cout << "Customer name: " << customerName << endl;
	cout << "Today's date: " << currentDate << endl << endl;

	ShoppingCart itemCart(customerName, currentDate);

	PrintMenu(itemCart);
	return 0;
}