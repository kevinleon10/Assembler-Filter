;Universidad de Costa Rica
;Ensambladores y Microprocesadores
;Kevin Leon    B53845
;Daniel Varela B57474

extern SDL_GetWindowSurface
extern SDL_GetRGB
extern SDL_UpdateWindowSurface
extern getpixel
extern putpixel

section .bss
window	                resq         1                              ;ventana que entra como puntero
resultado               resd        3000000			    ;Matriz
screen                  resq         1                              ;superficie
r                       resb         1
g                       resb         1
b                       resb         1
cero         resq               0
mayor        resq               255

section     .text
section     .data

switch:
	     dq                 asm_filter.Switchfiltro0
	     dq                 asm_filter.Switchfiltro1
	     dq                 asm_filter.Switchfiltro2
	     dq                 asm_filter.Switchfiltro3
	     dq                 asm_filter.Switchfiltro4	
filtro1           dd              -0.1667
filtro2           dd              -0.6667
filtro3           dd               4.3333
i            dd	                1   ;columnas
j            dd	                1   ;filas
aux          dd               0.0
pixel        dq               0.0


global      asm_filter                          

asm_filter:                           
    push 	rbp
    mov 	rsp, rbp
    call	SDL_GetWindowSurface							
    mov		[screen], rax	           ;r9 = Superficie.
    mov 	[window],rdi		   ;ventana en R8
    movss	xmm4, [cero]		   ;xmm4: resultadoR.
    movss	xmm5, [cero]		   ;xmm5: resultadoG.
    movss	xmm6, [cero]		   ;xmm6: resultadoB.
    mov 	rax, [screen+4]
    mov 	r13, rax 		   ;r13: x.
    mov 	rcx, rsi		   ;rcx: ventana	 
    
    jmp		[switch+rsi*8]
    
    .Switchfiltro0:
    jmp		Switchfiltro0                    ;salta a filtro0
    .Switchfiltro1:
    jmp		Switchfiltro1                    ;salta a filtro1
    .Switchfiltro2:
    jmp		Switchfiltro2                    ;salta a filtro2
    .Switchfiltro3:
    jmp		Switchfiltro3                    ;salta a filtro3
    .Switchfiltro4:
    jmp		Switchfiltro4                    ;salta a filtro4
    
    
;--------------------------------------------Switch Filtro 0--------------------------------------

    Switchfiltro0:
    mov		esi, 1                     ;esi = 1
    mov 	[i], esi   		   ;i = 1.
    	
    for2:				   ;entra a for2		
    mov		esi, 1
    mov 	[j], esi   				
    
    for1:           ;es el for encargado de la convolucion											
    
    
;------------------------------------------ Multiplicacion sobre primer pixel------------------------------------------------------

;                                                        |*|_|_|
;                                                        |_|_|_|
;                                                        |_|_|_|  


    mov         rdi, [screen]               ;rdi= screen
    mov         esi, [i]                    ;esi = j
    mov	        edx, [j]                    ;edx = i
    dec	        esi                         ;i-- = param2
    dec	        edx                         ;j-- = param3
    call        getpixel                    ;call get pixel              
    mov         r15, rax                    ;r15 = pixel
    
    mov		rdx, r15		    ;red
    shr		rdx, 16                     ;consiguiendo pixel rojo
    mov		rcx, r15          	    ;green
    shr		rcx, 8                      ;consigiendo pixel green
    and		rcx, 0xff                   ;consiguiendo pixel green
    mov		r8, r15			    ;blue
    and		r8, 0xff                    ;consiguiendo pixel blue
      
    cvtsi2ss	xmm0, edx  
    mulss	xmm0, [filtro1]
    movss       [aux], xmm0                 ;aux = Red
    addss       xmm4,[aux]                  ;ResultadoR
    cvtsi2ss	xmm1, ecx  
    mulss	xmm1, [filtro1]
    movss       [aux], xmm1                 ;aux = Green
    addss       xmm5,[aux]                  ;ResultadoG  
    cvtsi2ss	xmm2, r8d  
    mulss	xmm2, [filtro1]
    movss       [aux], xmm2                 ;aux = Blue
    addss       xmm6,[aux]                  ;ResultadoB
                                    
;------------------------------------------ Multiplicacion sobre segundo pixel------------------------------------------------------

;                                                        |_|*|_|
;                                                        |_|_|_|
;                                                        |_|_|_|


    mov         rdi, [screen]               ;rdi = window
    mov         edx, [j]                    ;param3 = j
    mov         esi, [i]                    ;param2 = 1
    dec         edx								
    call        getpixel                    ;call getpixel
    mov         r15, rax                    ;r15 = getpixel
    
    mov		rdx, r15		    ;red
    shr		rdx, 16                     ;consiguiendo pixel rojo
    mov		rcx, r15          	    ;green
    shr		rcx, 8                      ;consigiendo pixel green
    and		rcx, 0xff                   ;consiguiendo pixel green
    mov		r8, r15			    ;blue
    and		r8, 0xff                    ;consiguiendo pixel blue
      
    cvtsi2ss	xmm0, edx  
    mulss	xmm0, [filtro2]
    movss       [aux], xmm0                 ;aux = Red
    addss       xmm4,[aux]                  ;ResultadoR
    cvtsi2ss	xmm1, ecx  
    mulss	xmm1, [filtro2]
    movss       [aux], xmm1                 ;aux = Green
    addss       xmm5,[aux]                  ;ResultadoG  
    cvtsi2ss	xmm2, r8d  
    mulss	xmm2, [filtro2]
    movss       [aux], xmm2                 ;aux = Blue
    addss       xmm6,[aux]                  ;ResultadoB

    
;------------------------------------------ Multiplicacion sobre tercer pixel------------------------------------------------------

;                                                        |_|_|*|
;                                                        |_|_|_|
;                                                        |_|_|_|


    mov         rdi, [screen]               ;rdi = window
    mov         edx, [j]                    ;param3 = j
    mov         esi, [i]                    ;param2 = 1
    dec		edx
    inc		esi
    call        getpixel                     
    mov         r15, rax                    ;r15 = getpixel
    
    mov		rdx, r15		    ;red
    shr		rdx, 16                     ;consiguiendo pixel rojo
    mov		rcx, r15          	    ;green
    shr		rcx, 8                      ;consigiendo pixel green
    and		rcx, 0xff                   ;consiguiendo pixel green
    mov		r8, r15			    ;blue
    and		r8, 0xff                    ;consiguiendo pixel blue
      
    cvtsi2ss	xmm0, edx  
    mulss	xmm0, [filtro1]
    movss       [aux], xmm0                 ;aux = Red
    addss       xmm4,[aux]                  ;ResultadoR
    cvtsi2ss	xmm1, ecx  
    mulss	xmm1, [filtro1]
    movss       [aux], xmm1                 ;aux = Green
    addss       xmm5,[aux]                  ;ResultadoG  
    cvtsi2ss	xmm2, r8d  
    mulss	xmm2, [filtro1]
    movss       [aux], xmm2                 ;aux = Blue
    addss       xmm6,[aux]                  ;ResultadoB      
    
;------------------------------------------ Multiplicacion sobre cuarto pixel------------------------------------------------------

;                                                        |_|_|_|
;                                                        |*|_|_|
;                                                        |_|_|_|
    
    
    mov         rdi, [screen]               ;rdi = window
    mov         edx, [j]                    ;j como tercer parametro
    mov         esi, [i]                    ;param2 = 1
    dec		esi
    call        getpixel                    ;
    mov         r15, rax                    ;r15 = getpixel
    
    mov		rdx, r15		    ;red
    shr		rdx, 16                     ;consiguiendo pixel rojo
    mov		rcx, r15          	    ;green
    shr		rcx, 8                      ;consigiendo pixel green
    and		rcx, 0xff                   ;consiguiendo pixel green
    mov		r8, r15			    ;blue
    and		r8, 0xff                    ;consiguiendo pixel blue
      
    cvtsi2ss	xmm0, edx  
    mulss	xmm0, [filtro2]
    movss       [aux], xmm0                 ;aux = Red
    addss       xmm4,[aux]                  ;ResultadoR
    cvtsi2ss	xmm1, ecx  
    mulss	xmm1, [filtro2]
    movss       [aux], xmm1                 ;aux = Green
    addss       xmm5,[aux]                  ;ResultadoG  
    cvtsi2ss	xmm2, r8d  
    mulss	xmm2, [filtro2]
    movss       [aux], xmm2                 ;aux = Blue
    addss       xmm6,[aux]                  ;ResultadoB       
   
   
     
;------------------------------------------ Multiplicacion sobre quinto pixel------------------------------------------------------
;                                                        |_|_|_|
;                                                        |_|*|_|
;                                                        |_|_|_|
    
    
    mov         rdi, [screen]               ;rdi = window
    mov         edx, [j]                    ;j como tercer parametro
    mov         esi, [i]                    ;param2 = 1
    call        getpixel                    ;
    mov         r15, rax                    ;r15 = getpixel
    
    mov		rdx, r15		    ;red
    shr		rdx, 16                     ;consiguiendo pixel rojo
    mov		rcx, r15          	    ;green
    shr		rcx, 8                      ;consigiendo pixel green
    and		rcx, 0xff                   ;consiguiendo pixel green
    mov		r8, r15			    ;blue
    and		r8, 0xff                    ;consiguiendo pixel blue
      
    cvtsi2ss	xmm0, edx  
    mulss	xmm0, [filtro3]
    movss       [aux], xmm0                 ;aux = Red
    addss       xmm4,[aux]                  ;ResultadoR
    cvtsi2ss	xmm1, ecx  
    mulss	xmm1, [filtro3]
    movss       [aux], xmm1                 ;aux = Green
    addss       xmm5,[aux]                  ;ResultadoG  
    cvtsi2ss	xmm2, r8d  
    mulss	xmm2, [filtro3]
    movss       [aux], xmm2                 ;aux = Blue
    addss       xmm6,[aux]                  ;ResultadoB          
  
      
;------------------------------------------ Multiplicacion sobre sexto pixel------------------------------------------------------
;                                                        |_|_|_|
;                                                        |_|_|*|
;                                                        |_|_|_|


    mov         rdi, [screen]               ;rdi = window
    mov         edx, [j]                    ;j como tercer parametro
    mov         esi, [i]                    ;i+1 como segundo parametro
    inc 	esi
    call        getpixel                    ;
    mov         r15, rax                    ;r15 = getpixel
    
    mov		rdx, r15		    ;red
    shr		rdx, 16                     ;consiguiendo pixel rojo
    mov		rcx, r15          	    ;green
    shr		rcx, 8                      ;consigiendo pixel green
    and		rcx, 0xff                   ;consiguiendo pixel green
    mov		r8, r15			    ;blue
    and		r8, 0xff                    ;consiguiendo pixel blue
      
    cvtsi2ss	xmm0, edx  
    mulss	xmm0, [filtro2]
    movss       [aux], xmm0                 ;aux = Red
    addss       xmm4,[aux]                  ;ResultadoR
    cvtsi2ss	xmm1, ecx  
    mulss	xmm1, [filtro2]
    movss       [aux], xmm1                 ;aux = Green
    addss       xmm5,[aux]                  ;ResultadoG  
    cvtsi2ss	xmm2, r8d  
    mulss	xmm2, [filtro2]
    movss       [aux], xmm2                 ;aux = Blue
    addss       xmm6,[aux]                  ;ResultadoB          
     
  
;------------------------------------------ Multiplicacion sobre septimo pixel------------------------------------------------------
;                                                        |_|_|_|
;                                                        |_|_|_|
;                                                        |*|_|_|
    
   
    mov         rdi, [screen]               ;rdi = window
    mov         edx, [j]                    ;param3 = j
    mov         esi, [i]                    ;param2 = 1
    inc 	edx
    dec		esi
    call        getpixel                    ;call getpixel
    mov         r15, rax                    ;r15 = getpixel
    
    mov		rdx, r15		    ;red
    shr		rdx, 16                     ;consiguiendo pixel rojo
    mov		rcx, r15          	    ;green
    shr		rcx, 8                      ;consigiendo pixel green
    and		rcx, 0xff                   ;consiguiendo pixel green
    mov		r8, r15			    ;blue
    and		r8, 0xff                    ;consiguiendo pixel blue
      
    cvtsi2ss	xmm0, edx  
    mulss	xmm0, [filtro1]
    movss       [aux], xmm0                 ;aux = Red
    addss       xmm4,[aux]                  ;ResultadoR
    cvtsi2ss	xmm1, ecx  
    mulss	xmm1, [filtro1]
    movss       [aux], xmm1                 ;aux = Green
    addss       xmm5,[aux]                  ;ResultadoG  
    cvtsi2ss	xmm2, r8d  
    mulss	xmm2, [filtro1]
    movss       [aux], xmm2                 ;aux = Blue
    addss       xmm6,[aux]                  ;ResultadoB          
    
    
;------------------------------------------ Multiplicacion sobre octavo pixel------------------------------------------------------

;                                                        |_|_|_|
;                                                        |_|_|_|
;                                                        |_|*|_|   


    mov         rdi, [screen]               ;rdi = window
    mov         edx, [j]                    ;param3 = j
    mov         esi, [i]                    ;param2 = 1
    inc		edx
    call        getpixel                    ;
    mov         r15, rax                    ;r15 = getpixel
    
    mov		rdx, r15		    ;red
    shr		rdx, 16                     ;consiguiendo pixel rojo
    mov		rcx, r15          	    ;green
    shr		rcx, 8                      ;consigiendo pixel green
    and		rcx, 0xff                   ;consiguiendo pixel green
    mov		r8, r15			    ;blue
    and		r8, 0xff                    ;consiguiendo pixel blue
      
    cvtsi2ss	xmm0, edx  
    mulss	xmm0, [filtro2]
    movss       [aux], xmm0                 ;aux = Red
    addss       xmm4,[aux]                  ;ResultadoR
    cvtsi2ss	xmm1, ecx  
    mulss	xmm1, [filtro2]
    movss       [aux], xmm1                 ;aux = Green
    addss       xmm5,[aux]                  ;ResultadoG  
    cvtsi2ss	xmm2, r8d  
    mulss	xmm2, [filtro2]
    movss       [aux], xmm2                 ;aux = Blue
    addss       xmm6,[aux]                  ;ResultadoB         
    
    

;------------------------------------------ Multiplicacion sobre noveno pixel------------------------------------------------------

;                                                        |_|_|_|
;                                                        |_|_|_|
;                                                        |_|_|*|


    mov         rdi, [screen]               ;rdi = window
    mov         edx, [j]                    ;param3 = j
    mov         esi, [i]                    ;param2 = 1
    inc		edx
    inc 	esi
    call        getpixel                    ;
    mov         r15, rax                    ;r15 = getpixel
    
    mov		rdx, r15		    ;red
    shr		rdx, 16                     ;consiguiendo pixel rojo
    mov		rcx, r15          	    ;green
    shr		rcx, 8                      ;consigiendo pixel green
    and		rcx, 0xff                   ;consiguiendo pixel green
    mov		r8, r15			    ;blue
    and		r8, 0xff                    ;consiguiendo pixel blue
      
    cvtsi2ss	xmm0, edx  
    mulss	xmm0, [filtro1]
    movss       [aux], xmm0                 ;aux = Red
    addss       xmm4,[aux]                  ;ResultadoR
    cvtsi2ss	xmm1, ecx  
    mulss	xmm1, [filtro1]
    movss       [aux], xmm1                 ;aux = Green
    addss       xmm5,[aux]                  ;ResultadoG  
    cvtsi2ss	xmm2, r8d  
    mulss	xmm2, [filtro1]
    movss       [aux], xmm2                 ;aux = Blue
    addss       xmm6,[aux]                  ;ResultadoB
    
    
    
;---------------------------------------------------Revision de intervalo de pixeles[0,255]--------------------------------
   
    cvtss2si	r14, xmm4                          ;r14 = resultadR
    cmp         r14,0                              ;r14-0
    jns         if02                               ;
    movss	xmm4, [cero]                       ;xmm4 = 0.
if02:
    cvtss2si	r14, xmm5                          ;r14 = resultadG
    cmp         r14,0                              ;r14-0
    jns         if03
    movss	xmm5, [cero]                       ;xmm5 = 0.            
if03:
    cvtss2si	r14, xmm6                          ;r14 = resultadB
    cmp         r14,0                              ;r14-0
    jns         if04
    movss	xmm6, [cero]                       ;xmm6 = 0.    
if04:
    cvtss2si    r14, xmm4                          ;r14 = xmm4
    cmp         [mayor], r14                       ;r14- mayor
    jb          if05                                ;
    movss       xmm4, [mayor]                      ;xmm4 = 255
if05:
    cvtss2si    r14, xmm5                          ;r14 = xmm5
    cmp         [mayor], r14                       ;r14 - mayor
    jb          if06                                ;
    movss       xmm5, [mayor]                      ;xmm5 = 255   
if06:
    cvtss2si    r14, xmm6                          ;r14 = xmm6
    cmp         [mayor], r14                       ;r14 - mayor
    jb          end_if06                                ;
    movss       xmm6, [mayor]                      ;xmm6 = 255 
end_if06:        
    
;---------------------------------------------end_if06 va a Guardar los datos en la matriz auxiliar----------------------------------
    
    
    cvtss2si	rsi, xmm4		;rsi = resultadoR
    cvtss2si	rdx, xmm5		;rdx = resultadoG
    cvtss2si	rcx, xmm6	        ;rcx = resultadoB
                   
    shl		rsi, 16                 ;estas instrucciones lo que hacen es lo mismo 
    shl		rdx, 8                  ;que SDL_MapRGB
    mov		rax, rcx                ;     
    or		rax, rdx                ;
    or		rax, rsi                ;Hasta aca.
                         
    mov     esi, [i]                    ;rcx = i
    mov     edx, [j]                    ;rdx = j
    imul    esi, 479                    ;rcx * width
    add     esi, edx                    ;rcx = i*w +j
    imul    esi, 4                      ;rcx = 4*(w*i + j) 
    mov     [resultado+esi], rax        ;resultado[i][j] = rax = SDL_MapRGB
 
 
;--------------------------------------------Preparar variables para proximo ciclo--------------------------------------


    movss       xmm4, [cero]            ;Resultados en 0 para reiniciar el ciclo.
    movss	xmm5, [cero]
    movss	xmm6, [cero]
 
    mov 	esi, [j]                ;incremeta j
    inc	        esi	
    mov 	[j], esi								
    cmp	        esi, 479                ;compara j con 479, si es menor va a for1.   
    jl 	for1                            ;Repite for1.
        
    mov	esi, [i]                        ;si no, incrementa i
    inc	esi
    mov	[i], esi
    cmp 	esi, 639		;compara i con 639, si es menor va a for2.
    jl 	for2
    
    mov		esi, 1                  ;si no, inicializa i en 1.
    mov 	[i], esi   		;i = 1
    
    		
for4:				        
    mov		esi, 1
    mov 	[j], esi   		;Columnas = j = 0	
      
for3:    				        
    mov         rdx, [j]                        ;param3 = j
    mov         rsi, [i]                        ;param2 = i	    
    mov         esi,[i]                         
    mov         edx,[j]                         
    imul 	esi, 479
    add 	esi, edx
    imul        esi, 4
    mov         ecx,[resultado+esi],            ;Es la direccion [i][j] de la matriz       
    mov         esi,[i]                         ;Pone i en rdi
    mov         edx,[j]                         ;Pone j en rsi   
    mov 	rdi, [screen]	                ;param1 = screen
    call	putpixel                        ;call putpixel
   
    mov 	esi, [j]
    inc	        esi	
    mov 	[j], esi			;Incrementa j
    cmp	        esi, 479
    jl 	        for3
    
    mov	        esi, [i]
    inc	        esi
    mov	        [i], esi                        ;incrementa i
    cmp 	esi, 639								
    jl 	        for4
    
    mov	        rdi, [window]                  ;rdi = window
    call 	SDL_UpdateWindowSurface        ;Actualiza la ventana para ver el resultado.
    mov         rsp, rbp
    pop 	rbp
    ret	                                       ;Termina filtro1
    
    
;--------------------------------------------Switch Filtro 1 - 4--------------------------------------
 
    
    	
    Switchfiltro1:
    mov 	rsp, rbp
    pop 	rbp
    ret
    Switchfiltro2:
    mov 	rsp, rbp
    pop 	rbp
    ret    
    Switchfiltro3:
    mov 	rsp, rbp
    pop 	rbp
    ret    
    Switchfiltro4:
    mov 	rsp, rbp
    pop 	rbp
    ret
	
    
;Universidad de Costa Rica
;Ensambladores y Microprocesadores
;Kevin Leon    B53845 
;Daniel Varela B57474
