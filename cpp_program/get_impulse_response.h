/* Authors: Maciej Kazana, Anna Ryszka
 * 
 * Function: get_impulse_response
 * 
 * Input parameters:
 *		list<double> _u - list of doubles containing control data
 *		list<double> _y - list of doubles containing output data
 *
 * Output parameters:
 *		list<double> _g - list of doubles containing computed impulse response
 *
 * Description:
 *		Function calculates impulse response from given control and output data
 *		on time window [0,T] with constant sample time
 */

#ifndef GET_IMPULSE_RESPONSE_H
#define GET_IMPULSE_RESPONSE_H

#include <list>
#include <cstdlib>

using namespace std;

list<double> get_impulse_response(list<double> _u, list<double> _y);

#endif