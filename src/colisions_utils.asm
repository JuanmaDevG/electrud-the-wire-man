;========IMPORTANTE=========;
; Para coger el tile que toca un sprite:
; (Al final, si queda en medio de un sprite, dará igual, 
; porque al hacer la división para obtener las coordenadas TX y TY,
; se obtiene el entero que corresponderá a un tile)
; Entonces, en el caso de quedar en medio de un tile cuando nos movemos a la derecha: 
; Si hacemos: (x-8)/8 -> obtenemos el tile de la izquierda, y si hacemos los pasos pequeños, este tile no tiene sentido comprobarlo porque venimos de él
; Si hacemos: (x)/8   -> obtenemos el tile de la derecha

; ¿Cuál es la clave entonces?
; Pues la clave es mirar los tiles dependiendo de la dirección a la que se vaya,
; así no hay que comprobar muchos tiles.
; 