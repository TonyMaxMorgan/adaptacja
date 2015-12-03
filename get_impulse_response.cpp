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

#include <cstdlib>
#include <iostream>
#include <list>
#include "get_impulse_response.h"

using namespace std;

list<double> get_impulse_response(list<double> _u, list<double> _y)
{
	int s = _u.size();				// size for creating dynamic tables

	list<double> _g;				// list to return g table (computed impulse response)
	double * u = new double[s];		// table for control data
	double * y = new double[s];		// table for output data
	double * g = new double[s];		// table for impulse response to compute
	
	/* transfer control data to table */
	int j=0;
	for(list<double>::iterator it=_u.begin(); it!=_u.end(); ++it)
	{
		u[j]=*it; 
		j++;
	}

	/* transfer output data to table */
	j=0;
	for(list<double>::iterator it=_y.begin(); it!=_y.end(); ++it)
	{
		y[j]=*it;
		j++;
	}

	/* compute impulse response */
	double u_0 = u[0];
	
	g[0]=y[0];
	g[1]=y[1]/u_0;
	for(int k=2; k<s; k++)
	{
		double sum = 0;
		for(int i=1; i<=(k-1); i++)
		{
			sum += u[i]*g[k-i];
		}
			g[k]=(y[k]-sum)/u_0;
	}

	/* transfer impulse response to list */
	for(int i=0; i<s; i++)
	{
		_g.push_back(g[i]);
	}

	/* return list with impulse response */
	return _g;
}