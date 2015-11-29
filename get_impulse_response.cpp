#include <iostream>
#include <stdlib.h>
#include <list>
#include <cstdlib>
#include "get_impulse_response.h"

using namespace std;

list<double> get_impulse_response(list<double> _u, list<double> _y)
{
	int s = _u.size();				// size for creating dynamic tables

	list<double> _g;				// list to return g table
	double * u = new double[s];		// control data
	double * y = new double[s];		// output data
	double * g = new double[s];		// impulse response to compute
	
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
	for(int k=2; k<501; k++)
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