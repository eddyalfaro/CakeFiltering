function [Trc] = TransmisibilidadR(Gr, BcL, UcL, KrcL)

%{
Calculo de la Transmisibilidad en cada bloque a su respectiva presion. 

Como datos de entrada se tiene la matriz de factores geometricos Gr, la
condiciones de presiones de los bloques Pk, y los datos correspondientes a
la relacion de factor volumetrico, y viscosidad con la presion.
%}


[nt,~] = size(Gr);
Trc(nt,2) = 0;

for j= 1:nt
    Trc(j,1) = Gr(j,1)*KrcL(j,1)/(UcL(j,1)*BcL(j,1));
    Trc(j,2) = Gr(j,2)*KrcL(j,3)/(UcL(j,3)*BcL(j,3));
end

end