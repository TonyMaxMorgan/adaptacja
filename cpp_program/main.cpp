/* Authors: Maciej Kazana, Anna Ryszka
 * 
 * Function: main
 * 
 * Description:
 *		Program imports time, control and output samples from .txt file,
 *		computes impulse and step responses with recurrent method
 *		and exports time, impulse response and step response samples to .txt file.
 */

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
list<double> correct_time(list<double> _t, double time_offset);


int main(int argc, char* argv[])
{
	list<double> impulse;
	list<double> step;
	list<double> time;
	list<double> u;
	list<double> y;
	std::fstream input_data;

	/* If you want to run .exe with the same location of input and output data every time - uncomment this section no.1 */

	/* start of section no.1 */
	/*
	string input_location = "test1_data.txt";
	string output_location = "test1_response.txt";
	*/
	/* end of section no.1 */



	/* If you want to run .exe from terminal with arguments - uncomment this section no.2 */
	/* As first argument give input location e.g. C:\test_data.txt */
	
	/* start of section no.2 */
	
	string input_location;
	string output_location;
	if (argc > 1)
	{
	input_location = argv[1];
	output_location = input_location;
	output_location.erase(output_location.end()-9,output_location.end());
	output_location.append("_response.txt");
	}
	else
	{
		cout << "Tried to run program without input argument! Unable to continue!" << endl;
		exit(1);
	}
	
	/* end of section no.2 */

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
		std::cout << "File forbidden or don't exist! Unable to continue!" << endl;
		exit(1);
	}
	input_data.close();
	
	int number_of_samples_before_preprocessing = time.size();
	cout << "Number of samples loaded from file: " << number_of_samples_before_preprocessing << endl;

	/* data preprocessing */
		int max_loop;
		/* delete first samples until u_0 is non-zero */
		/* if u_0 is non-zero at start this part is skipped */
		max_loop=u.size();
		for (int i=0; i < max_loop; i++)
		{
			double u_0 = u.front();
			if (u_0 == 0)
			{
				time.pop_front();
				u.pop_front();
				y.pop_front();
			}
			else
			{
				break;
			}
		}
		
		/* Check if data vectors are not empty */
		int check_if_empty = u.size();
		if (check_if_empty == 0)
		{
			cout << "Constant zero control! All samples deleted! Unable to continue!" << endl;
			exit(1);
		}

		/* subtract constant value time_offset from all elements of time vector to reach zero value in first sample */
		/* if first time sample equals zero, this part is skipped */

		double time_offset = time.front();
		if (time_offset > 0)
		{
			time = correct_time(time, time_offset);
		}

		/* count how many samples was rejected */
		int number_of_samples_after_preprocessing = time.size();
		int difference_in_samples = number_of_samples_before_preprocessing - number_of_samples_after_preprocessing;
		if (difference_in_samples > 0)
		{
			cout << "Samples deleted in preprocessing: " << difference_in_samples << endl;
		}

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
	 cout << "Number of samples saved to file: " << time.size() << endl;

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

list<double> correct_time(list<double> _t, double time_offset)
{
	list<double> new_time;	// corrected time

	for(list<double>::iterator it=_t.begin(); it!=_t.end(); ++it)
	{
		new_time.push_back(*it - time_offset);
	}

	return new_time;
}

/* ---------------- */