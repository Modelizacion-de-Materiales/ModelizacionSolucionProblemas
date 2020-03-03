logical function match(string,substring)
implicit none

character(100) :: string
character(100) :: substring
integer::stringlong, substringlong
integer:: i

stringlong=len_trim(string)
substringlong=len_trim(substring)
print*, stringlong, substringlong
match=.false.

do i=1,stringlong
	if ( string(i:substringlong) == substring ) then
		match=.true.
		exit
	end if
end do

end function


!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Subrutina para asignar un número de unidad único
! para cada archivo
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

integer function unitunique(filename)
implicit none

character(20)::filename
integer::i
unitunique=0
do i=1,len_trim(filename)
	unitunique=unitunique+(10**i)*ichar(filename(i:i))
end do

end function
