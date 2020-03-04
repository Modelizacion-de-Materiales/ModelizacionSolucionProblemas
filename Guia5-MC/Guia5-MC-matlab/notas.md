# Estado actual

- obtengo un resultado razonable para la varianza y la magnetización, a campo cero. 

- guardo figuras con el resultado

- los parámetros de tamaño del sistema y de rango de temperaturas los saco del mismo programa. 


# cambios propuestos :

- en lugar de usar cshift para sacar los vecinos, tratar de ver con cálculo explícito de 
los vecinos  para cada posición

# observaciones.

~~~
    dEdot = -factor*(sdot)*(J)*sumOfThisNeigbours;
~~~

si ~~~factor == 1 ~~~ todas las transiciones se me corren a T0 ! 

si ~~~ factor == 2 ~~~ las transiciones dan donde deberían. pero, luego, al 
actualizar la temperatura, debo hacer E = E + dE / 2 ! de lo contrario tengo
un comportamiento anómalo de Cv: max(Cv) depende del numero de pasos montecarlo!
