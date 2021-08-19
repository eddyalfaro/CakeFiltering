function [X_k1] =  SOR(A, X_k0, b, w, nr, nz)
%{
Metodo Numerico de solucion indirecta SOR (Successive over-
relaxation), es una variante del metodo de Gauss-Seidel, para
ecuaciones de la forma AX=b.

en este metodo utiliza la sustitucion directa y la eleccion de w
se debe encontrar entre los valores de 0 y 2, donde este es el coeficiente
de sobrerelajacion.
%}

for k = 1:nz
    for i = 2:(nr-1)
        i_P = (k-1)*nr + i;
        sum = 0;
        for j = 1:(nr*nz)
            if j ~= i_P
            sum = sum + A(i_P,j)*X_k0(j);
            end
        end
        sum = b(i_P) - sum;
        X_k0(i_P) = (1-w)*X_k0(i_P) + w*sum/A(i_P,i_P);
        %%X_k0(i_P) = sum/A(i_P,i_P);
    end    
    X_k1 = X_k0;
end