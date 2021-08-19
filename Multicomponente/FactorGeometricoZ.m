function [Gz] = FactorGeometricoZ(Dz, DTheta, r2, Kz, Bc)
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

[nr,~] = size(r2);
[nt,~] = size(Kz);

nz = nt/nr;

Gz(nt,2)=0;

gzr = Bc*DTheta*(r2(1:end,2)-r2(1:end,1))/(2*Dz);

for k = 1:nz
    for i = 1:nr
        
        i_P = (k-1)*nr + i;
        
        if k ==1
            Gz(i_P,1) = 0;
            Gz(i_P,2) = gzr(i)*Kz(i_P);
        elseif k>1 && k<nz
            Gz(i_P,1) = gzr(i)*Kz(i_P);
            Gz(i_P,2) = gzr(i)*Kz(i_P);
        elseif k == nz
            Gz(i_P,1) = gzr(i)*Kz(i_P);
            Gz(i_P,2) = 0;
        end
    end
end

end