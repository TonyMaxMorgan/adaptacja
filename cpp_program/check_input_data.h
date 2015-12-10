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

#ifndef CHECK_INPUT_DATA_H
#define CHECK_INPUT_DATA_H

#include <list>
#include <cstdlib>

using namespace std;

int check_input_data(list<double> _t, list<double> _u, list<double> _y);

#endif