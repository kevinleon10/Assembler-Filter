#include "funciones.h"

/** \brief Carga y despliega un archivo BMP.
 *
 * La siguiente función carga y despliega un archivo BMP dado como parámetro, una
 * vez que SDL ha sido inicializado y el modo de vídeo se ha asignado.
 *
 * \param window SDL_Window* Ventana en la que desplegamos el BMP
 * \param file_name char* Nombre del archivo BMP
 * \return void
 *
 */
void display_bmp(SDL_Window *window, char *file_name)
{
    SDL_Surface *screen = SDL_GetWindowSurface( window );
    SDL_Surface *image;

    /* Carga el archivo BMP en una superficie. */
    image = SDL_LoadBMP(file_name);
    if (image == NULL)
    {
        fprintf(stderr, "No es posible cargar %s: %s\n", file_name, SDL_GetError());
        return;
    }

    /*
     * Los modos de pantalla con paleta tienen una paleta por omisión (un cubo
     * de 8*8*4 colores), pero si la imagen tiene paleta también podemos utilizar
     * usar esa paleta para un mejor emparejamiento de colores.
     */
    if (image->format->palette && screen->format->palette)
    {
        SDL_SetPaletteColors(screen->format->palette, image->format->palette->colors, 0,
                             image->format->palette->ncolors);
    }

    /* Blit en la superficie de pantalla.  Blit es acrónimo de bit block transfer.
     * Es una operación de datos comúnmente utilizada en gráficos de computadora
     * en la cual varios mapas de bits se combinan en uno solo usando funciones
     * booleanas.
     */
    if(SDL_BlitSurface(image, NULL, screen, NULL) < 0)
    {
        fprintf(stderr, "Error en BlitSurface: %s\n", SDL_GetError());
    }

    /* Se actualiza la superficie. */
    SDL_UpdateWindowSurface( window );

    /* Se libera la superficie con el BMP a la cual se le asignó memoria. */
    SDL_FreeSurface(image);
}

/*
 * Dibujando directamente en superficies
 *
 * Las siguientes dos funciones pueden ser usadas para obtener y asignar elementos
 * de una superficie. Están cuidadosamente escritas para trabajar con cualquier
 * profundidad de color manejada por SDL. Recuerde bloquear la superficie antes de
 * llamarlas y desbloquear la superficie antes de llamar cualquier otra
 * función de SDL.
 *
 * Para convertir entre valores de elementos y sus componentes rojo, verde y azul,
 * use SDL_GetRGB() y SDL_MapRGB().
 *
 * Ejemplo de uso de la función putpixel() que viene más adelante:
 *
 * Código para asignar un elemento amarillo en el centro de la superficie.
 *
 * int x, y;
 * Uint32 yellow;
 *
 * // Map the color yellow to this display (R=0xff, G=0xFF, B=0x00)
 * // Note:  If the display is palettized, you must set the palette first.
 *
 * yellow = SDL_MapRGB(screen->format, 0xff, 0xff, 0x00);
 *
 * x = screen->w / 2;
 * y = screen->h / 2;
 *
 * // Bloquea la superficie para el acceso directo a los elementos.
 *
 * if ( SDL_MUSTLOCK(screen) ) {
 *     if ( SDL_LockSurface(screen) < 0 ) {
 *         fprintf(stderr, "Can't lock screen: %s\n", SDL_GetError());
 *         return;
 *     }
 * }
 *
 * putpixel(screen, x, y, yellow);
 *
 * if ( SDL_MUSTLOCK(screen) ) {
 *     SDL_UnlockSurface(screen);
 * }
 *
 */

/** \brief Regresa el valor del elemento en (x, y)
 *
 * Regresa el valor del elemento en (x, y).  La superficie debe estar bloqueada antes
 * de hacer este llamado.
 *
 * \param surface SDL_Surface*
 * \param x int
 * \param y int
 * \return Uint32
 *
 */
Uint32 getpixel(SDL_Surface *surface, int x, int y)
{

 int bpp = surface->format->BytesPerPixel;
    /* Acá p es la dirección al elemento que queremos obtener. */
    Uint8 *p = (Uint8 *)surface->pixels + y * surface->pitch + x * bpp;


    switch(bpp)
    {
    case 1:
        return *p;

    case 2:
        return *(Uint16 *)p;

    case 3:
        if(SDL_BYTEORDER == SDL_BIG_ENDIAN)
            return p[0] << 16 | p[1] << 8 | p[2];
        else
            return p[0] | p[1] << 8 | p[2] << 16;

    case 4:
        return *(Uint32 *)p;

    default:
        return 0;       /* No debería suceder pero evita avisos del compilador. */
    }
}

/** \brief Asigna el elemento en (x, y) al valor dado.
 *
 * Asigna el elemento en (x, y) al valor dado. La superficie debe estar bloqueada
 * antes de hacer este llamado.
 *
 * \param surface SDL_Surface*
 * \param x int
 * \param y int
 * \param pixel Uint32
 * \return void
 *
 */
void putpixel(SDL_Surface *surface, int x, int y, Uint32 pixel)
{
    int bpp = surface->format->BytesPerPixel;
    /* Acá p es la dirección al elemento que queremos asignar. */
    Uint8 *p = (Uint8 *)surface->pixels + y * surface->pitch + x * bpp;

    switch(bpp)
    {
    case 1:
        *p = pixel;
        break;

    case 2:
        *(Uint16 *)p = pixel;
        break;

    case 3:
        if(SDL_BYTEORDER == SDL_BIG_ENDIAN)
        {
            p[0] = (pixel >> 16) & 0xff;
            p[1] = (pixel >> 8) & 0xff;
            p[2] = pixel & 0xff;
        }
        else
        {
            p[0] = pixel & 0xff;
            p[1] = (pixel >> 8) & 0xff;
            p[2] = (pixel >> 16) & 0xff;
        }
        break;

    case 4:
        *(Uint32 *)p = pixel;
        break;
    }
}
