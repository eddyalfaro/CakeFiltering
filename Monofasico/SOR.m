function [X_k1] =  SOR(A, X_k0, b, w)
%{
Metodo Numerico de solucion indirecta SOR (Successive over-
relaxation), es una variante del metodo de Gauss-Seidel, para
ecuaciones de la forma AX=b.

en este metodo utiliza la sustitucion directa y la eleccion de w
se debe encontrar entre los valores de 0 y 2, donde este es el coeficiente
de sobrerelajacion.
%}

[m,~] = size(A);
%%k = 0;
%%DX = 1;

%%while max(DX)>tol && k < 30
%NOTA: agregar contador de iteraciones
    %%k = k+1;
    %%temp = X_k0;
    for i = 1:m
        sum = 0;
        
    %calculo de X a partir de los valores supuestos en X_k0 la 
    %substitucion directa es utilizada para j < i,
   
        for j = 1:m 
            if (j < i)
                sum = sum + A(i,j)*X_k0(j);
            elseif (j > i)
                sum = sum + A(i,j)*X_k0(j);
            end
        end

        sum = b(i) - sum;
        X_k0(i) = (1-w)*X_k0(i) + w*sum/A(i,i);

    end
    
    X_k1 = X_k0;
%%end

end