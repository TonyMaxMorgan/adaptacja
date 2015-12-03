#define END_FLAG -1

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
	list<double> t;
	list<double> u;
	list<double> y;
	std::fstream plik_data;
	std::fstream plik_u;
	std::fstream plik_y;
	char line[256];

	/* Otwieranie pliku z danymi t u y */
	plik_data.open( "data.txt", std::ios::in | std::ios::out );
	if( plik_data.good() == true )
	{
		std::cout << "Uzyskano dostep do pliku!" << endl;
		
		while(!plik_data.eof())
		  {
			  double temp_t=END_FLAG, temp_u=END_FLAG, temp_y=END_FLAG;  

			  plik_data >> temp_t >> temp_u >> temp_y;
			  if(temp_t!=END_FLAG)
			  {
				t.push_back(temp_t);
				u.push_back(temp_u);
				y.push_back(temp_y);
			  }
		  }
		  cout<<"Wczytano wektory z pliku data"<<endl;
		  cout<< t.size() << endl << u.size() << endl << y.size() <<endl;
	} 
	else std::cout << "Dostep do pliku zostal zabroniony!" << endl;
	plik_data.close();


	/***** dwa pliki *****/
	if (false)
	{
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
	}
	/***** dwa pliki KONIEC *****/
	
	/* obliczenie chatakterystyki impulsowej*/
	impulse = get_impulse_response(t,u,y);

	cout<<"impulse size: "<<impulse.size()<<endl;

	/*zapisywanie do pliku*/
	double * g = new double[impulse.size()];
	int gj=0;
	for(list<double>::iterator it=impulse.begin(); it!=impulse.end(); ++it)
	{
		g[gj]=*it; 
		gj++;
	}


	ofstream plik_g ("g.txt", ios_base::in | ios_base::trunc);
 
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