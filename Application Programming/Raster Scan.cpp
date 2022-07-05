#include <stdio.h>
#include <math.h>
#include "prog7_functions.h"

// Reset grid to original settings
void resetGrid(char grid[][NCols]) {
	int row, column;

	for (row = 20; row >= 0; row--)
	{
		for (column = 0; column <= 50; column--)
		{
			if (row % 5 == 0)
			{
				if (column % 5 == 0)
				{
					grid[row][column] = '+';
				}
				else
					grid[row][column] = '-';
			}
			else
			{
				if (column % 5 == 0)
					grid[row][column] = '|';
				else
					grid[row][column] = ' ';
			}
		}
	}
}


// Add box to existing grid starting at (x, y) with specified width & height
void addBox(char grid[][NCols], int x, int y, int width, int height) {
	// COMPLETE THIS FUNCTION
}

// Print current grid contents
void printGrid(char grid[][NCols]) {
	int row, column;

	for (row = 20; row >= 0; row--)
	{
		for (column = 0; column <= NCols; column++)
		{
			printf("%c", grid[row][column]);
		}
		if (row % 5 == 0)
			printf("%d", row);
		printf("\n");
	}
	column = 0;
	while (column < NCols)
	{
		printf("%d    ", column);
		column += 5;
	}
}