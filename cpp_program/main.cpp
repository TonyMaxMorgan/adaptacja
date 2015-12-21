#define END_FLAG -1

#include <iostream>
#include <fstream>
#include <string>
#include <stdlib.h>
#include <list>
#include <cstdlib>
#include <time.h>

#include "get_impulse_response.h"
#include "get_step_response.h"

using namespace std;

double get_sample_time(list<double> _t);


int main(int argc, char* argv[])
{
	list<double> impulse;
	list<double> step;
	list<double> time;
	list<double> u;
	list<double> y;
	std::fstream input_data;

	/* If you want to run .exe with the same location of input and output data every time - uncomment this section */

	/* start of section */
	/*
	string input_location = "test1_data.txt";
	string output_location = "test1_response.txt";
	*/
	/* end of section */



	/* If you want to run .exe from terminal with arguments - uncomment this section */
	/* As first argument give input location e.g. C:\test_data.txt */
	
	/* start of section */
	string input_location;
	string output_location;
	if (argc > 1)
	{
	input_location = argv[1];
	cout<<input_location<<endl;
	output_location = input_location;
	output_location.erase(output_location.end()-9,output_location.end());
	output_location.append("_response.txt");
	cout<<output_location<<endl;
	}
	else
	{
		cout << "Tried to run program without input argument!" << endl;
		exit(1);
	}
	/* end of section */

	/* transfer t u y to corresponding lists*/
	input_data.open(input_location, std::ios::in | std::ios::out );
	if( input_data.good() == true )
	{
		std::cout << "Input data file opened successfully!" << endl;
		
		while(!input_data.eof())
		  {
			  double temp_t=END_FLAG, temp_u=END_FLAG, temp_y=END_FLAG;  

			  input_data >> temp_t >> temp_u >> temp_y;
			  if(temp_t!=END_FLAG)
			  {
				time.push_back(temp_t);
				u.push_back(temp_u);
				y.push_back(temp_y);
			  }
		  }
		  cout << "Data read from file: " << input_location << endl;
	} 
	else
	{
		std::cout << "File forbidden or don't exist!" << endl;
		exit(1);
	}
	input_data.close();

	/* compute impulse response */
	impulse = get_impulse_response(u,y);

	/* compute step response */
	step = get_step_response(impulse);

	/* transfer impulse response from list to table */
	double * g = new double[impulse.size()];
	int gj=0;
	for(list<double>::iterator it=impulse.begin(); it!=impulse.end(); ++it)
	{
		g[gj]=*it; 
		gj++;
	}

	/* transfer step response from list to table */
	double * h = new double[step.size()];
	int hj=0;
	for(list<double>::iterator it=step.begin(); it!=step.end(); ++it)
	{
		h[hj]=*it; 
		hj++;
	}

	/* transfer time from list to table */
	double * t = new double[time.size()];
	int tj=0;
	for(list<double>::iterator it=time.begin(); it!=time.end(); ++it)
	{
		t[tj]=*it; 
		tj++;
	}

	/* compute sample time */
	double sample_time;
	sample_time = get_sample_time(time);

	/* divide computed impulse response by sample time*/
	for(int i=0; i<impulse.size(); i++)
	{
		g[i] = g[i]/sample_time;
	}

	/* save time, impulse reponse and step response to file */
	ofstream output_data (output_location, ios_base::in | ios_base::trunc);
 
	 if(!output_data)
	 {
		cout << "Cannot open output file!" << endl;
	 }
	 else
	 {
		for (int i=0; i<time.size(); i++)
		{
			output_data << t[i] << ", " << g[i] << ", " << h[i] << endl;
		}
		cout << "Data write to file: "<< output_location << endl;
	 }
		output_data.close();
	 
	 /* free dynamic allocated memory */
	 delete [] g;
	 delete [] h;
	 delete [] t;	
	
	 cout << "Computation complete!" << endl;

	return 0;
}

/* Program functions */
double get_sample_time(list<double> _t)
{
	double Ts;				// sample time
	double temp1, temp2;	// temporary variables for computation

	list<double>::iterator it=_t.begin();
	temp1 = *it;
	it++;
	temp2 = *it;
	Ts = temp2 - temp1;

	return Ts;
}
/* ---------------- */