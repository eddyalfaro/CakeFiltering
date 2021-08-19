function [Trt1] = TransmisibilidadR(Gr, P_t1, B, u, Matriz)

%{
Calculo de la Transmisibilidad en cada bloque a su respectiva presion. El
calculo discrimina mediante la variable Matriz, si se desea calcular a 
partir de datos contenidos en una matriz o datos individuales, esto se
realiza con la variable Matriz tipo Boolean en donde su valor es FALSE para
el ultimo y TRUE para el primero.

Como datos de entrada se tiene la matriz de factores geometricos Gr, la
condiciones de presiones de los bloques Pk, y los datos correspondientes a
la relacion de factor volumetrico, y viscosidad con la presion.
%}

    if Matriz == true

        [nr,~] = size(Gr);
        [nt,~] = size(P_t1);
        nz = nt/nr;
        
        Trt1(nt,2) = 0;
        
        for i= 1:nz
            for j =1:nr
                i_P = (i-1)*nr + j;
                 
                Trt1(i_P,1) = Gr(j,1)/(u(i_P)*B(i_P));
                Trt1(i_P,2) = Gr(j,2)/(u(i_P)*B(i_P));
            end
        end
        
    elseif Matriz == false

        Trt1 = Gr/(u*B);

    end
end