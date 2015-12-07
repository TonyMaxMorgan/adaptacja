/* Authors: Maciej Kazana, Anna Ryszka
 * 
 * Function: check_input_data
 * 
 * Input parameters:
 *		list<double> _t - list of doubles containing time data
 *		list<double> _u - list of doubles containing control data
 *		list<double> _y - list of doubles containing output data
 *
 * Output parameters:
 *		int check - check result:
 *					0 - positive result - data is valid
 *					1 - negative result - data not consistent (different lengths of input vectors)
 *					2 - negative result - time not valid (sample time not constant)
 *
 * Description:
 *		Function checks if input data is valid:
 *			1. If data vectors _t, _u and _y have the same length (the same number of samples)
 *			2. If time vector _t have constant sample time between consecutive samples
 */

#include <iostream>

#include <list>
#include <cstdlib>
#include "check_input_data.h"

using namespace std;

int check_input_data(list<double> _t, list<double> _u, list<double> _y)
{
	int check = 0;		// result variable set to 0

	/* check if input data have the same number of samples */
	if( !( (_t.size()==_u.size()) & (_t.size()==_y.size()) ) )
	{
		check = 1;		// change result variable to 1
		return check;
	}

	/* check if time data have constant sample time between consecutive samples */
	double * t = new double[_t.size()];
	int tj=0;
	for(list<double>::iterator it=_t.begin(); it!=_t.end(); ++it)
	{
		t[tj]=*it; 
		tj++;
	}

	double Ts = t[1]-t[0];
	double eps = Ts*0.001;

	for (int i=1; i<(_t.size()); i++)
	{
		if ( !((Ts-(t[i]-t[i-1])-Ts)<eps) )
		{
			check = 2;		// change result variable to 2
			delete [] t;
			return check;
		}
	}
	delete [] t;	// free allocated memory 

	return check;
}
