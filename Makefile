improve: funciones.o filtros.o principal.o
	gcc -g -o improve funciones.o filtros.o principal.o `sdl2-config --cflags --libs`

funciones.o: funciones.c
	gcc -g `sdl2-config --cflags` -c funciones.c

filtros.o: filtros.asm
	nasm -g -f elf64 filtros.asm

principal.o:  principal.c
	gcc -g `sdl2-config --cflags` -c principal.c

rebuild: clean improve

clean:
	rm *.o improve

