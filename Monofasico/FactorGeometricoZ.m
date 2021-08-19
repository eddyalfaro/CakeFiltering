function [Gz] = FactorGeometricoZ(Dz, DTheta, r2, krz, Bc)
%{
La ecuacion Calcula el factor geometrico en direccion z, Aqui se calcula un
factor por cada radio discretizado. Azumiendo que los diferenciales de 
angulo son iguales y que el espezor h ha sido dividido en partes iguales 
con Dz=cte.

Bc es una constante de conversion y depende de las unidades utilizadas

Radios en ft, permeabilidades en md, angulo en radianes el Bc es 0.001127
Radios en m, permeabilidades en m^2, angulo en redianes el Bc es 0.0864
Radios en cm, permeabilidades en darcy angulo en redianes el Bc es 1
%}

[n,~] = size(r2);
Gz(n,1) = 0;

    for i = 1:n

        Gz(i) = 2*Bc*0.5*DTheta*(r2(i,2)-r2(i,1))/(Dz/krz(i)+ ...
            Dz/krz(i));

    end

end