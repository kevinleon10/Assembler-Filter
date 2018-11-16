#include <stdio.h>
#include <stdlib.h>
#include "filtros.h"
#include "funciones.h"

void asm_filter (SDL_Window *ventana, int filtro){

	SDL_Surface *super;
	super = SDL_GetWindowSurface(ventana);

	Uint32 pixel; //auxiliar para tomar cada pixel de la imagen y tratarlo.

	unsigned int i,j; //iterradores.

	float resultadoR = 0; //auxiliar para c.r.
	float resultadoG = 0; //auxiliar para c.g.
	float resultadoB = 0; //auxiliar para c.b.

	//resultado es una matriz con 640 filas y 480 columnas.
	Uint32 resultado[640][480];

	SDL_PixelFormat *x = super->format;

	switch (filtro){

	SDL_Color c;
	
	case 0:

		//Inicia proceso de convolucion, al pixel y a los 8 pixeles continuos se les aplica el filtro y en las variables auxiliares se guarda la sumatoria del resultado de cada operacion.

		i=1; //Inicia filas en 1 para evitar que se caiga en la primer fila.
		j=1; //Inicia columnas en 1 para evitar que se caiga en primer columna.

		while(i<639){ //filas hasta 639 para evitar que se caiga en fila 640.
			while(j<479){//columnas hasta 479 para evitar que se caiga en 480.


				/* |*|_|_|
				   |_|_|_|
				   |_|_|_|
				*/
				pixel= getpixel(super,i-1,j-1);             
				SDL_GetRGB(pixel,x,&c.r,&c.g,&c.b);
				resultadoR+=((float)c.r) * (-0.1667);
				resultadoG+=((float)c.g) * (-0.1667);
				resultadoB+=((float)c.b) * (-0.1667);
                

				/* |_|*|_|
				   |_|_|_|
				   |_|_|_|
				*/
				pixel= getpixel(super,i-1,j);
				SDL_GetRGB(pixel,x,&c.r,&c.g,&c.b);
				resultadoR+=((float)c.r) * (-0.6667);
				resultadoG+=((float)c.g) * (-0.6667);
				resultadoB+=((float)c.b) * (-0.6667);


				/* |_|_|*|
				   |_|_|_|
				   |_|_|_|
				*/
				pixel= getpixel(super,i-1,j+1);
				SDL_GetRGB(pixel,x,&c.r,&c.g,&c.b);
				resultadoR+=((float)c.r) * (-0.1667);
				resultadoG+=((float)c.g) * (-0.1667);
				resultadoB+=((float)c.b) * (-0.1667);


				/* |_|_|_|
				   |*|_|_|
				   |_|_|_|
				*/
				pixel= getpixel(super,i,j-1);
				SDL_GetRGB(pixel,x,&c.r,&c.g,&c.b);
				resultadoR+=((float)c.r) * (-0.6667);
				resultadoG+=((float)c.g) * (-0.6667);
				resultadoB+=((float)c.b) * (-0.6667);


				/* |_|_|_|
				   |_|*|_|
				   |_|_|_|
				*/
				pixel= getpixel(super,i,j);
				SDL_GetRGB(pixel,x,&c.r,&c.g,&c.b);
				resultadoR+=((float)c.r) * (4.333);
				resultadoG+=((float)c.g) * (4.333);
				resultadoB+=((float)c.b) * (4.333);


				/* |_|_|_|
				   |_|_|*|
				   |_|_|_|
				*/
				pixel= getpixel(super,i,j+1);
				SDL_GetRGB(pixel,x,&c.r,&c.g,&c.b);
				resultadoR+=((float)c.r) * (-0.6667);
				resultadoG+=((float)c.g) * (-0.6667);
				resultadoB+=((float)c.b) * (-0.6667);


				/* |_|_|_|
				   |_|_|_|
				   |*|_|_|
				*/
				pixel= getpixel(super,i+1,j-1);
				SDL_GetRGB(pixel,x,&c.r,&c.g,&c.b);
				resultadoR+=((float)c.r) * (-0.1667);
				resultadoG+=((float)c.g) * (-0.1667);
				resultadoB+=((float)c.b) * (-0.1667);


				/* |_|_|_|
				   |_|_|_|
				   |_|*|_|
				*/
				pixel= getpixel(super,i+1,j);
				SDL_GetRGB(pixel,x,&c.r,&c.g,&c.b);
				resultadoR+=((float)c.r) * (-0.6667);
				resultadoG+=((float)c.g) * (-0.6667);
				resultadoB+=((float)c.b) * (-0.6667);


				/* |_|_|_|
				   |_|_|_|
				   |_|_|*|
				*/
				pixel= getpixel(super,i+1,j+1);
				SDL_GetRGB(pixel,x,&c.r,&c.g,&c.b);
				resultadoR+=((float)c.r) * (-0.1667);
				resultadoG+=((float)c.g) * (-0.1667);
				resultadoB+=((float)c.b) * (-0.1667);
                

				//Si hay algun resultado menor que 0 se setea en 0 ya que los valores solo estan entre 0 y 255.
				if(resultadoR < 0){
					resultadoR = 0;
				}
				if(resultadoG< 0){
					resultadoG = 0;
				}
				if(resultadoB < 0){
					resultadoB = 0;
				}
				
				//Si hay algun resultado mayor que 255 se setea en 255 ya que los valores solo estan entre 0 y 255.
				if(resultadoR > 255){
					resultadoR = 255;
				}
				if(resultadoG>255){
					resultadoG = 255;
				}
				if(resultadoB > 255){
					resultadoB = 255;
				}
				
				//Asignar las varibales auxiliares a campo respectivo al pixel en la matriz auxiliar.
				resultado[i][j] = SDL_MapRGB(x,resultadoR,resultadoG,resultadoB);
				j++;

				//poner las variables auxiliares en 0.				
				resultadoR = 0;
				resultadoG = 0;
				resultadoB = 0;
			}
			j=1;
			i++;
		}
		i=1;
		j=1;	
			
		//Se escribe la imagen a partir de la matriz auxiliar que se creo en el proceso de convolucion.		
		for (i = 1; i < 639; ++i){
			for(j = 1; j < 479; ++j){
				putpixel(super,i,j,resultado[i][j]);
			}
		}

		SDL_UpdateWindowSurface( ventana ); //Actualiza la ventana. 

	break;

	case 1:
		//vacio
	break;

	case 2:
		//vacio
	break;

	case 3:
		//vacio
	break;

	case 4:
		//vacio
	break;

	case 5:
		//vacio
	break;
	}               
}
