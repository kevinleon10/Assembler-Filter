/* Se incluyen la E/S estándar, la biblioteca estándar, SDL y las funciones utilitarias. */
#include <stdio.h>
#include <stdlib.h>
#include <SDL.h>
#include "funciones.h"
//#include "filtros.h"

enum filter_t {FILTER1, FILTER2, FILTER3, FILTER4, FILTER5};

extern void asm_filter(SDL_Window*, unsigned);
/* Constantes de la dimensión de pantalla. */
const int SCREEN_WIDTH = 640;
const int SCREEN_HEIGHT = 480;

int main( int argc, char* args[] )
{
    /* Nota:  es parte del trabajo de la tarea tomar de los argumentos de línea
     * de comandos el nombre del archivo BMP que se va a cargar.  Acá sólo tenemos
     * una hilera vacía.  Resuélvalo.
     */
    char* bmp_file = args[1];

    /* La ventana en la que vamos a "pintar". */
    SDL_Window* window = NULL;

    /* La superficie contenida por la ventana. */
    /* SDL_Surface *screen = NULL; */

    /* Se limpia al salir. */
    atexit(SDL_Quit);

    /* Se inicializa SDL. */
    if( SDL_Init( SDL_INIT_VIDEO ) < 0 )
    {
        fprintf( stderr, "No se puede inicializar SDL: %s\n", SDL_GetError() );
        exit(10);
    }
    else
    {
        /* Se crea la ventana */
        window = SDL_CreateWindow( "improve", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, SCREEN_WIDTH, SCREEN_HEIGHT, SDL_WINDOW_SHOWN );
        if( window == NULL )
        {
            fprintf( stderr, "No se puede crear la ventana: %s\n", SDL_GetError() );
            exit(20);
        }
        else
        {
            /* Se obtiene la superficie de la ventana. */
            /* screen = SDL_GetWindowSurface( window ); */

            /* Se despliega el archivo BMP. */
            display_bmp(window, bmp_file);

            /* Ciclo de eventos del programa. */
            SDL_Event event;
            char quit = 0;

            while (!quit)
            {
                /* Se obtiene un evento. */
                if (SDL_PollEvent(&event))
                {
                    /* Se revisa el tipo de evento. */
                    switch (event.type)
                    {
                    /* Se pulsó el botón de salir de la ventana. */
                    case SDL_QUIT:
                        quit = 1;
                        break;

                    /* Maneja las teclas. */
                    case SDL_KEYDOWN:
                        switch (event.key.keysym.sym)
                        {
                        case SDLK_F1:
                            /* asm_filter() es la función que usted debe programar
                             * en ensamblador utilizando SSE.  Note que recibe
                             * dos parámetros, la ventana que es de tipo SDL_Window
                             * y un filtro que es de tipo filter_t (puede encontrar
                             * el enum que define el tipo al inicio de este archivo).
                             * Usted sólo deberá programar el filtro uno.  Sin embargo,
                             * su código ensamblador deberá implementar un "switch" y
                             * dejar la prevista para tener hasta 5 filtros.
                             */
                             asm_filter(window, FILTER1);
                            break;
                        case SDLK_F2:
                            /* asm_filter(window, FILTER2); */
                            break;
                        case SDLK_F3:
                            /* asm_filter(window, FILTER3); */
                            break;
                        case SDLK_F4:
                            /* asm_filter(window, FILTER4); */
                            break;
                        case SDLK_F5:
                            /* asm_filter(window, FILTER5); */
                            break;
                        case SDLK_ESCAPE:
                        case SDLK_F10:
                            quit = 1;
                            break;
                        }
                        break;
                    }
                }
            }
        }
    }

    /* Destruye la ventana */
    SDL_DestroyWindow( window );

    /* Sale del subsistema SDL. */
    SDL_Quit();

    return 0;
}
