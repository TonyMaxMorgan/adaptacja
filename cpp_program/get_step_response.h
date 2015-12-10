/* Authors: Maciej Kazana, Anna Ryszka
 * 
 * Function: get_step_response
 * 
 * Input parameters:
 *		list<double> _g - list of doubles containing impulse response
 *
 * Output parameters:
 *		list<double> _h - list of doubles containing computed step response
 *
 * Description:
 *		Function calculates step response from given impulse response data
 *		on time window [0,T] with constant sample time
 */

#ifndef GET_STEP_RESPONSE_H
#define GET_STEP_RESPONSE_H

#include <list>
#include <cstdlib>

using namespace std;

list<double> get_step_response(list<double> _g);

#endif