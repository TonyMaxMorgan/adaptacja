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

#include <list>
#include <cstdlib>
#include "get_step_response.h"

using namespace std;

list<double> get_step_response(list<double> _g)
{
	int s = _g.size();				// size for creating dynamic tables

	list<double> _h;				// list to return h table (computed step response)
	double * g = new double[s];		// table for impulse response
	double * h = new double[s];		// table for step response to compute

	/* transfer impulse response to table */
	int j=0;
	for(list<double>::iterator it=_g.begin(); it!=_g.end(); ++it)
	{
		g[j]=*it; 
		j++;
	}

	/* compute step response */
	h[0]=g[0];
	for(int k=1; k<s; k++)
	{
		h[k] = g[k] + h[k-1];
	}

	/* transfer impulse response to list */
	for(int i=0; i<s; i++)
	{
		_h.push_back(h[i]);
	}

	/* return list with impulse response */
	return _h;

}

