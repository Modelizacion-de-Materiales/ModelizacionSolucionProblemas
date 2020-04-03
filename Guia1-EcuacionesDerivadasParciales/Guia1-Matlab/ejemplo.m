

LT = [] ;

for i = 1:10
  LT = [ LT ;  ones(10,1)' ]
end

save('LT.dat', 'LT', '-ascii')
