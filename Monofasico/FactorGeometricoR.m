function [Gr, Vb] = FactorGeometricoR(ri, rL, r2, Krr, DTheta, DZ, Bc)

%{
La funcion calcula los factores geometricos radiales de cada frontera 
de cada bloque asi como sus volumenes. Los factores geometricos se calculan
de la manera propuesta por Pedroza y Azis (1986).

Los valores a ingresar son las matrices r2, ri y rL obtenidas de la 
discretizacion radial;n vector que contien la permeabilidad de cada 
bloque, y los diferenciales utilizados para los angulos y el espesor 
(Dtheta y DZ respectivamente)

Bc es una constante de conversion y depende de las unidades utilizadas

Radios en ft, permeabilidades en md, angulo en radianes el Bc es 0.001127
Radios en m, permeabilidades en m^2, angulo en redianes el Bc es 0.0864
Radios en cm, permeabilidades en darcy angulo en redianes el Bc es 1
%}

[n,~] = size(ri);

Gr(n,2)=0;
Vb(n,1)=0;

for i = 1:n
    if i == 1
        Gr(i,1) = 0;
        Gr(i,2) = Bc*DTheta*DZ/(log(rL(i,2)/ri(i))/Krr(i)+ ...
        log(ri(i+1)/rL(i,2))/Krr(i+1));
    
        Vb(i) = (r2(i,2)-r2(i,1))*0.5*DTheta*DZ;
    elseif (i>1 && i<n)
        Gr(i,1) = Bc*DTheta*DZ/(log(ri(i)/rL(i,1))/Krr(i)+ ...
        log(rL(i,1)/ri(i-1))/Krr(i-1));
        Gr(i,2) = Bc*DTheta*DZ/(log(rL(i,2)/ri(i))/Krr(i)+ ...
        log(ri(i+1)/rL(i,2))/Krr(i+1));
    
        Vb(i) = (r2(i,2)-r2(i,1))*0.5*DTheta*DZ;
    elseif i==n
        Gr(i,1) = Bc*DTheta*DZ/(log(ri(i)/rL(i,1))/Krr(i)+ ...
        log(rL(i,1)/ri(i-1))/Krr(i-1));
        Gr(i,2) = 0;
        
        Vb(i) = (r2(i,2)-r2(i,1))*0.5*DTheta*DZ;
    end
end

end