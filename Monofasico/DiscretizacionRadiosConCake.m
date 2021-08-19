function [ri_c, ri, rL, r2] = DiscretizacionRadiosConCake(ec, nrc, rw, ri_r)
%%
%{
la funcion realiza la discretizacion del cake formado en la cara de la
formacion a partir de su espesor y el numero de bloques en los que se desea
dividir.

Luego, une los radios discretizados obtenidos para el cake y para el 
reservorio, cambiando el radio exterior del cake y el interior del
reservorio.
%}

%% discretizacion del cake
if nrc == 1
    
    ri_c = [rw-ec];
    [i_c, ~] = size(ri_c);
    
    ri_r(1) = (ri_r(1) + ri_r(2))/2;
else
    [ri_c, ~, ~] = DiscretizacionRadial(rw-ec, rw, nrc);
    
    [i_c, ~] = size(ri_c);

    ri_c(i_c) = (ri_c(i_c) + ri_c(i_c-1))/2;
    ri_r(1) = (ri_r(1) + ri_r(2))/2;
end 

%% calculo de los nuevos limites para la union de la totalidad de radios
ri = [ri_c ; ri_r];

[nr, ~] = size(ri);
rL(nr,2) = 0;
r2(nr,2) = 0;

%% recalculando las variables rL y r2
for i = 1:nr
    if i == 1
        rL(i,1) = ri(i);
        r2(i,1) = ri(i)^2;
        
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
        
        rL(i,2) = ri(i);
        r2(i,2) = ri(i)^2;
    end
end

rL(i_c,2) = rw;
rL(i_c + 1, 1) = rw;

r2(i_c,2) = rw^2;
r2(i_c + 1, 1) = rw^2;


end