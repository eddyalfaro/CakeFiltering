function [x] = Interpolacion (P,X,Px)
%{
Funcion para encontrar valores ya sea de factor volumetrico
o viscosidad no presentes en tablas proporcionadas en funcion
de la presion.

La variable P es un vector generado a partir de las presiones
proporcionas en la tabla

La variable X son los valores ya sea de factor volumetrico 
o viscosidad ingresados en un vector que correspondan con 
la presiones administradas

La variable Px es la presion a la cual se desean obtener los
valores del factor volumetrico o la viscosidad
%}

[n,~] = size(P);

if (Px >= P(1) && Px <= P(n))
    
    %{
    El ciclo for se utiliza para encontrar entre cuales valores de
    presion se encuentra la presion requerida.
    %}
    for k = 1:n    
        if Px < P(k)        
            i = k;
            x = (X(i-1)/(P(i-1)-Px)+X(i)/(Px-P(i)))*...
                ((Px-P(i))^-1+(P(i-1)-Px)^-1)^-1;
            break
        elseif Px == P(k)
            i = k;
            x = X(i);
            break
        end
    end
elseif Px < P(1)
    x = ((X(1)-X(2))/(P(1)-P(2)))*(Px-P(1))+X(1);
elseif Px > P(n)
    x = X(n)-((X(n-1)-X(n))/(P(n-1)-P(n)))*(P(n)-Px);
end


end