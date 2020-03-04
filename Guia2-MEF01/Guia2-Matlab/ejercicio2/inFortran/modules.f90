module globals

! Primero defino los vectores con los vinculos
double precision, allocatable:: Uvin(:) , Fvin(:)

!Ahora defono los vectores que guardan las posiciones de los vínculos
integer, allocatable::vvin(:), vunk(:)

! Ahora guardo la informacion de los nodos
integer, allocatable::elementos(:,:)    ! Acá voy a poner los nodos que 
                                        ! conforman cada elemento.
double precision, allocatable::seccion(:),modelast(:),L(:)
                                        ! En estos vectores voy a guardar
                                        ! La información física de cada elemen
double precision, allocatable::X(:),Y(:) ! Y la posición de cada nodo

! La ultima global va a ser las dimensiones del problema.
integer:: nelem,nvin,nunk,nnodo,gl

! Matrices
double precision, allocatable::localK(:,:,:),K(:,:)
end module
