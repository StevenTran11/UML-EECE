#include "Time.h"  // Necessary for Time class definition; implicitly includes <iostream>
#include <iomanip> // Necessary for setw(), setfill()
using std::setfill;
using std::setw;

/*** OVERLOADED OPERATORS TO BE ADDED FOR PROGRAM 3 ***/
/*** PREVIOUSLY DEFINED FUNCTIONS START ON LINE 145 (BEFORE YOU START ADDING CODE) ***/
/*** UPDATED 10/11 TO FIX PARAMETERIZED CONSTRUCTOR, advance() ***/

// Output operator
ostream &operator<<(ostream &out, const Time &rhs)
{

	/*************************************************
	 * Print time using form:
	 *    h:mm _M  or hh:mm _M
	 * where:
	 *    h or hh	= # of hours (1 or 2 digits)
	 *    mm			= # of minutes (always 2 digits)
	 *    _M			= AM or PM
	 **************************************************/
	out << rhs.hours << ":" << setw(2) << setfill('0') << rhs.minutes << " " << rhs.AMorPM << "M" << std::endl;
	// Used setw and setfill to ensure the minutes are always displaying two digits.
	return out;
}

// Input operator
istream &operator>>(istream &in, Time &rhs)
{
	/*************************************************
	 * Read time assuming it is written in form:
	 *    h:mm _M  or hh:mm _M
	 * where:
	 *    h or hh	= # of hours (1 or 2 digits)
	 *    mm			= # of minutes (always 2 digits)
	 *    _M			= AM or PM
	 **************************************************/
	in >> rhs.hours;
	in.ignore(1);
	// Ignores the first character after the hours, which is ":"

	in >> rhs.minutes >> rhs.AMorPM;
	in.ignore(1);
	// Ignores the first character after AMorPM, which will be "M"

	if (rhs.AMorPM == 'P')
	{ // Changes time to morning or afternoon based on AMorPM value
		rhs.miltime = 100 * (rhs.hours + 12) + rhs.minutes;
	}
	else
	{
		rhs.miltime = 100 * rhs.hours + rhs.minutes;
	}
	return in;
}

// Comparison operators
bool Time::operator==(const Time &rhs)
{
	// Compare AM or PM
	if (AMorPM == rhs.AMorPM)
	{
		return true;
	}
	else
	{
		return false;
	}
	// Compare Hours
	if (hours == rhs.hours)
	{
		return true;
	}
	else
	{
		return false;
	}
	// Compare minutes
	if (minutes == rhs.minutes)
	{
		return true;
	}
	else
	{
		return false;
	}
}

bool Time::operator!=(const Time &rhs)
{
	/**************************************************
	 * Returns true if calling object doesn't match rhs,
	 *   false otherwise
	 ***************************************************/
	if (hours != rhs.hours)
	{
		return true;
	}
	// Compare minutes
	if (minutes != rhs.minutes)
	{
		return true;
	}
	// Compare AM or PM
	if (AMorPM != rhs.AMorPM)
	{
		return true;
	}
	else
	{
		return false;
	}
}

bool Time::operator<(const Time &rhs)
{
	/**********************************************
	 * Returns true if calling object is less
	 *   (earlier in day) than rhs, false otherwise
	 ***********************************************/
	if (AMorPM < rhs.AMorPM)
	{
		return true;
	}

	else if (AMorPM > rhs.AMorPM)
	{
		return false;
	}
	else
	{
		if (hours > rhs.hours)
		{
			return false;
		}
		else if (hours == rhs.hours)
		{
			return false;
		}
		else if (minutes > rhs.minutes)
		{
			return false;
		}
		else if (hours < rhs.hours)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	return false;
}

bool Time::operator>(const Time &rhs)
{
	/********************************************
	 * Returns true if calling object is greater
	 *   (later in day) than rhs, false otherwise
	 *********************************************/
	if (AMorPM > rhs.AMorPM)
	{
		return true;
	}

	else if (AMorPM < rhs.AMorPM)
	{
		return false;
	}
	else
	{
		if (hours < rhs.hours)
		{
			return false;
		}
		else if (hours == rhs.hours)
		{
			return false;
		}
		else if (minutes < rhs.minutes)
		{
			return false;
		}
		else if (hours > rhs.hours)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	return false;
}

//Arithmetic operators
//Time Addition
Time Time::operator+(const Time &rhs)
{
	Time sum;
	if (minutes + rhs.minutes >= 60)
	{
		sum.miltime = (rhs.miltime + miltime + 40) % 2400;
	}
	else
	{
		sum.miltime = (rhs.miltime + miltime) % 2400;
	}
	sum.hours = sum.miltime / 100;
	if (sum.hours > 12)
	{
		sum.hours = sum.hours - 12;
	}
	else if (sum.hours == 0)
	{
		sum.hours = 12;
	}
	sum.minutes = sum.miltime % 100;
	// AM or PM
	if ((sum.miltime >= 0000 && sum.miltime < 1200) || (sum.miltime >= 2400 && sum.miltime < 3600))
	{
		sum.AMorPM = 'A';
	}
	else if ((sum.miltime < 2400 && sum.miltime >= 1200) || ((sum.miltime >= 3600) && (sum.miltime < 4800)))
	{
		sum.AMorPM = 'P';
	}
	return sum;
}
//Time Subtraction
Time Time::operator-(const Time &rhs)
{
	Time diff;
	int hour, min, milDifference;
	char ap;
	milDifference = miltime - rhs.miltime;
	if (milDifference <= 0)
	{
		milDifference += 2400;
	}
	min = milDifference % 100;
	hour = (milDifference - min) / 100;
	if (min >= 60)
	{
		min -= 40;
	}
	if (hour > 12)
	{
		hour -= 12;
		ap = 'P';
	}
	else if (hour == 12)
	{
		ap = 'P';
	}
	else
	{
		if (hour == 0)
		{
			hour = 12;
		}
		ap = 'A';
	}
	diff = Time(hour, min, ap);
	return diff;
}

Time &Time::operator+=(const Time &rhs)
{
	/**************************************************
	 * Same as + operator, but modifies calling object
	 *   and returns reference to calling object
	 ***************************************************/
	*this = *this + rhs;
	return *this;
}

Time &Time::operator-=(const Time &rhs)
{
	/**************************************************
	 * Same as - operator, but modifies calling object
	 *   and returns reference to calling object
	 ***************************************************/
	*this = *this - rhs;
	return *this;
}

// Increment operators--adds 1 minute to current time
Time &Time::operator++()
{
	/*************************
	 * Pre-increment operator
	 **************************/
	++minutes; // Seems to change the ++T1: XX line in results
	if (minutes == 60)
	{
		hours += 1;

		if (AMorPM == 'P' && hours == 12)
		{
			AMorPM = 'A';
		}
		minutes = 0; // Need to reset minutes to 00 if they reach 60
	}
	// Add 1 to minutes
	return *this;
}

Time Time::operator++(int)
{
	/*************************
	 * Post-increment operator
	 **************************/
	Time time;
	time.miltime = miltime;
	time.minutes = minutes;
	time.hours = hours;
	time.AMorPM = AMorPM;
	minutes++;
	if (minutes + 1 >= 60)
		miltime = (1 + miltime + 40) % 2400;
	else
		miltime = (1 + miltime) % 2400; // If minutes exceed 60, changes the hours.
	hours = miltime / 100;
	// Checks if AM or PM needs to be changed if hours go past 12
	if (hours > 12)
	{
		hours = hours - 12;
	}
	else if (hours == 0)
		hours = 12;

	minutes = miltime % 100;

	if ((miltime >= 0000 && miltime < 1200) || (miltime >= 2400 && miltime < 3600))
	{
		AMorPM = 'A';
	}
	else if ((miltime < 2400 && miltime >= 1200) || ((miltime >= 3600) && (miltime < 4800)))
	{
		AMorPM = 'P';
	}

	return time;
}
/*** END OVERLOADED OPERATORS TO BE ADDED FOR PROGRAM 3 ***/
/*** DO NOT MODIFY CODE BELOW THIS LINE ***/
// Default constructor
Time::Time() : hours(0), minutes(0), miltime(0), AMorPM('A')
{
}

// Parameterized constructor
Time::Time(unsigned h, unsigned m, char AP) : hours(h), minutes(m), AMorPM(AP)
{
	miltime = 100 * h + m;

	/*** FIXED 10/11: ORIGINAL VERSION DID NOT CORRECTLY HANDLE 12 AM OR 12 PM ***/
	if (AP == 'P' && h != 12)
		miltime += 1200;
	else if (AP == 'A' && h == 12)
		miltime -= 1200;
}

// Set time data members
void Time::set(unsigned h, unsigned m, char AP)
{
	hours = h;
	minutes = m;
	AMorPM = AP;
	miltime = 100 * h + m;
	if (AP == 'P')
		miltime += 1200;
}

// Print time to desired output stream
void Time::display(ostream &out)
{
	out << hours << ':'
		<< setw(2) << setfill('0') << minutes // setw(2) forces minutes to be printed with 2 chars
		<< ' ' << AMorPM << 'M';			  // setfill('0') adds leading 0 to minutes if needed
}

// Advance time by h hours, m minutes
// Use modulo arithmetic to ensure
//   1 <= hours <= 12, 0 <= minutes <= 59
/*** FIXED 10/11: ORIGINAL VERSION DIDN'T WORK FOR ALL CASES AND WAS FAR TOO CONVOLUTED ***/
/***  NEW VERSION DOES ALL MATH ON MILTIME AND THEN CORRECTS HOURS, MINUTES ***/
void Time::advance(unsigned h, unsigned m)
{

	unsigned tempMT = h * 100 + m; // Temporary miltime representing amount
								   //   of time to advance by, since math
								   //   is much easier using miltime!

	// If sum of minutes >= 60, need to account for extra hour added
	if (minutes + m >= 60)
		miltime = (miltime + tempMT + 40) % 2400; // % 2400 ensures time between 0 & 2359
												  //   (since minutes adjustment guarantees
												  //    last two digits < 60)
	else
		miltime = (miltime + tempMT) % 2400;

	// Convert back from miltime to new hours/minutes
	hours = miltime / 100;

	// Special case 1: time in PM (other than 12 PM)
	if (hours > 12)
		hours -= 12;

	// Special case 2: 12:xx AM --> miltime / 100 = 0
	else if (hours == 0)
		hours = 12;

	minutes = miltime % 100;

	// Figure out if new time is in AM or PM
	AMorPM = (miltime < 1200 ? 'A' : 'P');
}

// Returns true if calling object is less than argument
bool Time::lessThan(const Time &rhs)
{
	if (miltime < rhs.miltime)
		return true;
	else
		return false;
}