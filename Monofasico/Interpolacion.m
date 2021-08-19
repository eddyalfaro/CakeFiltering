function [Bx] = Interpolacion (P,B,Px)
%{
Funcion para encontrar valores ya sea de factor volumetrico
o viscosidad no presentes en tablas proporcionadas en funcion
de la presion.

La variable P es un vector generado a partir de las presiones
proporcionas en la tabla

La variable B son los valores ya sea de factor volumetrico 
o viscosidad ingresados en un vector que correspondan con 
la presiones administradas

La variable Px es la presion a la cual se desean obtener los
valores del factor volumetrico o la viscosidad
%}

[n,~] = size(P);

for k = 1:n    
    if Px > P(k)        
        i = k;
        Bx = ((B(i+1)-B(i))/(P(i+1)-P(i)))*(Px-P(i))+B(i);
        break
    elseif Px == P(k)
        i = k;
        Bx = ((B(i+1)-B(i))/(P(i+1)-P(i)))*(Px-P(i))+B(i);
        break
    elseif Px < P(k) && k == 1
        i = k;
        Bx = ((B(i+1)-B(i))/(P(i+1)-P(i)))*(Px-P(i))+B(i);
        break 
    end
end

%{
El ciclo for se utiliza para encontrar entre cuales valores de
presion se encuentra la presion requerida.
%}

end