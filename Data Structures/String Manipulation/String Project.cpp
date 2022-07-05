#include <iostream>
#include <string>
#include <cmath>
using namespace std;

char PrintMenu(string input);
int GetNumOfNonWSCharacters(const string& input);
int GetNumOfWords(const string& input);
int FindText(string x, string y);
void ReplaceExclamation(string& input);
void ShortenSpace(string& input);

int main() {

	string line;
	int i = 0;

	cout << "Enter a sample text:" << endl;
	getline(cin, line);
	cout << endl;
	cout << "You entered: " << line << endl;
	cout << endl;
	while (i == 0) {
		string phrase;
		switch (PrintMenu(line)) {
		case 'q':
			i = 1;
			break;
		case 'c':
			cout << "Number of non-whitespaces: " << GetNumOfNonWSCharacters(line) << endl;
			cout << endl;
			break;
		case 'w':
			GetNumOfWords(line);
			break;
		case 'f':
			cout << "Enter a word or phrase to be found:" << endl;
			cin.ignore();
			getline(cin, phrase);
			cout << phrase << " instances: " << FindText(line, phrase) << endl;
			break;
		case 'r':
			ReplaceExclamation(line);
			cout << "Edited text: " << line << endl;
			break;
		case 's':
			ShortenSpace(line);
			cout << "Edited text: " << line << endl;
			break;
		default:
			break;
		}
	}
	return 0;
}

char PrintMenu(string input) {
	char command;
	cout << "MENU" << endl;
	cout << "c - Number of non-whitespace characters" << endl;
	cout << "w - Number of words" << endl;
	cout << "f - Find text" << endl;
	cout << "r - Replace all !'s" << endl;
	cout << "s - Shorten spaces" << endl;
	cout << "q - Quit" << endl;
	cout << endl;
	cout << "Choose an option:" << endl;
	cin >> command;
	return command;
}

int GetNumOfNonWSCharacters(const string& input) {
	int nonwhitespaces = 0;
	unsigned int i;
	for (i = 0; i < input.size(); ++i) {
		if (input.at(i) != ' ') {
			nonwhitespaces++;
		}
	}
	return nonwhitespaces;
}

int GetNumOfWords(const string& input) {
	int words = 0;
	unsigned int i;
	for (i = 0; i < input.size(); ++i) {
		if (input.at(i) == ' ') {
			words++;
		}
	}
	return words;
}
int FindText(string x, string y) {
	unsigned count = 0;
	int i;
	while (true) {
		count = x.find(y, ++count);
		if (count != string::npos) {
			i++;
		}
		else break;
	}
	return count;
}
void ReplaceExclamation(string& input) {
	unsigned int i;

	for (i = 0; i < input.size(); ++i) {
		if (input.at(i) == '!') {
			input.at(i) = '.';
		}
	}
}
void ShortenSpace(string& input) {
	unsigned int i;

	for (i = 0; i < input.size(); ++i) {
		if (input.at(i) == ' ' && input.at(i + 1) == ' ') {
			input.erase(i);
			--i;
		}
	}
}