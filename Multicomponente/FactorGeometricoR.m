function [Gr, Vb] = FactorGeometricoR(ri, rL, r2, Kr, DTheta, DZ, Bc, nr, nz)

%{
La funcion calcula los factores geometricos radiales de cada frontera 
de cada bloque asi como sus volumenes. Los factores geometricos se calculan
de la manera propuesta por Pedroza y Azis (1986).

Los valores a ingresar son las matrices r2, ri y rL obtenidas de la 
discretizacion radial;el vector que contien la permeabilidad de cada 
bloque, y los diferenciales utilizados para los angulos y el espesor 
(Dtheta y DZ respectivamente)

Bc es una constante de conversion y depende de las unidades utilizadas

Radios en ft, permeabilidades en md, angulo en radianes el Bc es 0.001127
Radios en m, permeabilidades en m^2, angulo en redianes el Bc es 0.0864
Radios en cm, permeabilidades en darcy angulo en redianes el Bc es 1
%}

nt = nr*nz;

Gr(nt,2)=0;
Vb(nt,1)=0;

for k = 1:nz
    for i = 1:nr
        
        i_P = (k-1)*nr + i;
        
        if i == 1
            Gr(i_P,1) = 0;
            Gr(i_P,2) = Bc*DTheta*DZ/(log(rL(i,2)/ri(i))/(Kr(i_P)*ri(i))+ ...
            log(ri(i+1)/rL(i,2))/(Kr(i_P+1)*ri(i+1)));

            Vb(i_P) = (r2(i,2)-r2(i,1))*0.5*DTheta*DZ;
        elseif (i>1 && i<nr)
            Gr(i_P,1) = Bc*DTheta*DZ/(log(ri(i)/rL(i,1))/(Kr(i_P)*ri(i))+ ...
            log(rL(i,1)/ri(i-1))/(Kr(i_P-1)*ri(i-1)));
            Gr(i_P,2) = Bc*DTheta*DZ/(log(rL(i,2)/ri(i))/(Kr(i_P)*ri(i))+ ...
            log(ri(i+1)/rL(i,2))/(Kr(i_P+1)*ri(i+1)));

            Vb(i_P) = (r2(i,2)-r2(i,1))*0.5*DTheta*DZ;
        elseif i==nr
            Gr(i_P,1) = Bc*DTheta*DZ/(log(ri(i)/rL(i,1))/(Kr(i_P)*ri(i))+ ...
            log(rL(i,1)/ri(i-1))/(Kr(i_P-1)*ri(i-1)));
            Gr(i,2) = 0;

            Vb(i_P) = (r2(i,2)-r2(i,1))*0.5*DTheta*DZ;
        end
    end
end

end