#include <iostream>
#include <fstream>
#include <string>
#include <stdlib.h>
#include <list>
#include <cstdlib>
#include <time.h>

#include "get_impulse_response.h"

using namespace std;



int main(int argc, char* argv[])
{
	list<double> impulse;
	list<double> u;
	list<double> y;
	std::fstream plik_u;
	std::fstream plik_y;
	char line[256];

	/* Otwieranie pliku ze sterowaniem u */
	plik_u.open( "u.txt", std::ios::in | std::ios::out );
	if( plik_u.good() == true )
	{
		std::cout << "Uzyskano dostep do pliku!" << endl;
		  while(!plik_u.eof())
		  {
			plik_u.getline(line,256);
			u.push_back(atof(line));
		  }
		  cout<<"Wczytano wektor sterowan"<<endl;
	} 
	else std::cout << "Dostep do pliku zostal zabroniony!" << endl;
	plik_u.close();

	/* Otwieranie pliku z wyjsciem y */
	plik_y.open( "y.txt", std::ios::in | std::ios::out );
	if( plik_y.good() == true )
	{
		std::cout << "Uzyskano dostep do pliku!" << endl;
		  while(!plik_y.eof())
		  {
			plik_y.getline(line,256);
			y.push_back(atof(line));
		  }
		  cout<<"Wczytano wektor wyjscia"<<endl;
	} 
	else std::cout << "Dostep do pliku zostal zabroniony!" << endl;
	plik_y.close();
	
	/* obliczenie chatakterystyki impulsowej*/
	impulse = get_impulse_response(u,y);

	/*zapisywanie do pliku*/
	double * g = new double[impulse.size()];
	int gj=0;
	for(list<double>::iterator it=impulse.begin(); it!=impulse.end(); ++it)
	{
		g[gj]=*it; 
		gj++;
	}


	ofstream plik_g ("g.txt", ios_base::in | ios_base::app);
 
	 if(!plik_g)
		cout << "Nie mo¿na otworzyæ pliku!" << endl;
	 else
	 {
		for (int i=0; i<impulse.size(); i++)
		{
			plik_g << g[i] << endl;
		}
		cout << "Dane zapisano pomyslnie!" << endl;
	 }
		plik_g.close();

		delete [] g;
	
	
	getchar();
	getchar();
	
	return 0;
}

/* Program functions */


/* ---------------- */