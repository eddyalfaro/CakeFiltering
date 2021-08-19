function [Tzt1, ut1, Bt1] = TransmisibilidadZ(Gz, P_t1, B_Tabla, ...
    u_Tabla, P_Tabla, Matriz)

%{
Calculo de la Transmisibilidad en cada bloque a su respectiva presion. El
calculo discrimina mediante la variable Matriz, si se desea calcular a 
partir de datos contenidos en una matriz o datos individuales, esto se
realiza con la variable Matriz tipo Boolean en donde su valor es FALSE para
el ultimo y TRUE para el primero.

Como datos de entrada se tiene la matriz de factores geometricos Gz, la
condiciones de presiones de los bloques Pk, y los datos correspondientes a
la relacion de factor volumetrico, y viscosidad con la presion.
%}

    if Matriz == true
        
        [nr,~] = size(Gz);
        [nt,~] = size(P_t1);
        nz = nt/nr;
        
        Tzt1(nt, 1) = 0;
        ut1(nt,1) = 0;
        Bt1(nt,1) = 0;

        for i= 1:nz
            for j = 1:nr
                i_P = (i-1)*nr + j;
                
                Bt1(i_P) = Interpolacion(P_Tabla, B_Tabla, P_t1(i_P));
                ut1(i_P) = Interpolacion(P_Tabla, u_Tabla, P_t1(i_P));
                
                Tzt1(i_P) = Gz(j)/(ut1(i_P)*Bt1(i_P));
            end
        end
        
    elseif Matriz == false

        Bt1 = Interpolacion(P_Tabla, B_Tabla, P_t1);
        ut1 = Interpolacion(P_Tabla, u_Tabla, P_t1);
        Tzt1 = Gz/(ut1*Bt1);

    end

end