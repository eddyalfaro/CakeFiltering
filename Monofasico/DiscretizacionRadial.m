function [ri,rL,r2] = DiscretizacionRadial(rw, re, nr)

%{
La funcion discretiza de manera radial el reservorio, ingresando los
datos de rw (radio del pozo), re (radio externo del reservorio) y el numero
de bloques en que se desea dividir radialmente el reservorio.

los valores que se obtienen son los radios de cada bloque en el vector ri

Las matrices rL y r2 son matrices de dos columnas en donde la primera
columna corresponde a los valores con subindice i-1/2 y la segunda 
columna corresponde a los valores con subindice i+1/2. 

Estos valores se pueden utilizar para los calculos de factores geometricos
radiales.
%}

Alpha_lg = (re/rw)^(1/(nr-1));
%Constante con la cual se dividen los radios

ri(nr,1) = 0;
ri(1)= rw;

%loop generado para establecer los radios de cada bloque
for i = 2:nr
    ri(i)=Alpha_lg*ri(i-1);
end

rL(nr,2)=0;
r2(nr,2)=0;

for i = 1:nr
    if i == 1
        rL(i,1) = rw;
        r2(i,1) = rw^2;
        
        rL(i,2) = (ri(i+1)-ri(i))/(log(ri(i+1)/ri(i)));
        r2(i,2) = (ri(i+1)^2-ri(i)^2)/log(ri(i+1)^2/ri(i)^2);
    elseif (i > 1 && i < nr)
        rL(i,1) = (ri(i)-ri(i-1))/log(ri(i)/ri(i-1));
        r2(i,1) = (ri(i)^2-ri(i-1)^2)/log(ri(i)^2/ri(i-1)^2);
        
        rL(i,2) = (ri(i+1)-ri(i))/(log(ri(i+1)/ri(i)));
        r2(i,2) = (ri(i+1)^2-ri(i)^2)/log(ri(i+1)^2/ri(i)^2);
    elseif i == nr
        rL(i,1) = (ri(i)-ri(i-1))/log(ri(i)/ri(i-1));
        r2(i,1) = (ri(i)^2-ri(i-1)^2)/log(ri(i)^2/ri(i-1)^2);
        
        rL(i,2) = re;
        r2(i,2) = re^2;
    end
end

end