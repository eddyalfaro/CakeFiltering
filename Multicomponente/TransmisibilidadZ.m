function [Tzc] = TransmisibilidadZ(Gz, BcL, UcL, KrcL)

%{
Calculo de la Transmisibilidad en cada bloque a su respectiva presion.

Como datos de entrada se tiene la matriz de factores geometricos Gz, la
condiciones de presiones de los bloques Pk, y los datos correspondientes a
la relacion de factor volumetrico, y viscosidad con la presion.
%}
        
[nt,~] = size(Gz);

Tzc(nt, 2) = 0;

    for j= 1:nt
        Tzc(j,1) = Gz(j,1)*KrcL(j,4)/(UcL(j,4)*BcL(j,4));
        Tzc(j,2) = Gz(j,2)*KrcL(j,2)/(UcL(j,2)*BcL(j,2));
    end
       

end