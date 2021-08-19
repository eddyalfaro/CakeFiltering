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
    ri_c = rw-ec;
    
    ri = [ri_c ; ri_r(2:end,1)];
else
    [ri_c, ~, ~] = DiscretizacionRadial(rw-ec, rw, nrc);
    
    ri = [ri_c(1:end-1,1); ri_r(2:end,1)];
end 

%% calculo de los nuevos limites para la union de la totalidad de radios
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

if nrc == 1
    rL(nrc, 2) = rw;
    r2(nrc, 2) = rw^2;
    
    rL(nrc+1, 1) = rw;
    r2(nrc+1, 1) = rw^2;
elseif nrc~=1
    rL(nrc-1, 2) = rw;
    r2(nrc-1, 2) = rw^2;
    
    rL(nrc, 1) = rw;
    r2(nrc, 1) = rw^2;
end

end