function [A, b] = MatrizCoeficientes(Trt1, Tzt1, Z, Vb, P_t0, Bt1, Bt0, ...
    Dt, Porosidad, gs, Dz)
%%
%{
Funcion que organiza la matriz de coeficientes A y la matriz de 
con las constantes b, a partir de los datos de Tranmisibilidad radial
y vertical (Trt1 y Tzt1 respectivamente), los factores volumetricos, 
y constantes como alpha que es el factor de conversion volumetrico.

si se utilizan pies en la ecuacion alpha sera 5.614
%}

%%
[n, ~] = size(P_t0);
A(n,n) = 0;
b(n,1) = 0;
[nr,~] = size(Vb);
[nz,~] = size(Z);

Alpha = 5.614;
Cte = (Porosidad/(Alpha*Dt))*Vb;


for i = 1:(nz)
    for j = 1:nr        
       
        pi = (i-1)*nr+j;
        
        %% bloques adyacentes en la direccion y
        if (i>1 && i<nz)
            A(pi,pi+nr)=Tzt1(pi);            
            A(pi,pi-nr)=Tzt1(pi);
            %diagonal
            A(pi,pi) = -(Trt1(pi,1)+Trt1(pi,2)+2*Tzt1(pi)+ ...
                Cte(j)*(1/Bt1(pi)-1/Bt0(pi)));
        elseif (i == nz)
            A(pi,pi-nr)=Tzt1(pi);
            %diagonal
            A(pi,pi) = -(Trt1(pi,1)+Trt1(pi,2)+Tzt1(pi)+ ...
                Cte(j)*(1/Bt1(pi)-1/Bt0(pi)));
        elseif (i == 1)
            A(pi,pi+nr)=Tzt1(pi);
            %diagonal
            A(pi,pi) = -(Trt1(j,1)+Trt1(j,2)+Tzt1(pi)+ ...
                Cte(j)*(1/Bt1(pi)-1/Bt0(pi)));
        end
        
        %% bloques adyacentes en la direccion r
        if (j > 1 && j<nr)
            A(pi,pi+1) = Trt1(pi,2);            
            A(pi,pi-1) = Trt1(pi,1);
        elseif (j == nr)            
            %%A(pi,pi-1) = Trt1(pi,1);
            A(pi,pi) = A(pi,pi) + Trt1(pi,1);
        elseif (j == 1)
            %Presion constante de limite en esta seccion.
            A(pi,pi)=A(pi,pi)+ Trt1(pi,2);
            %%A(pi,pi+1) = Trt1(j,2); 
        end
         
        %% calculo del vector b
        if (i>1 && i<nz)
            b(pi,1) = -(Cte(j)*P_t0(pi)*(1/Bt1(pi)-1/Bt0(pi))+ ...
                2*Tzt1(pi)*gs*Dz);
        elseif (i == nz)
            b(pi,1) = -(Cte(j)*P_t0(pi)*(1/Bt1(pi)-1/Bt0(pi))+ ...
                Tzt1(pi)*gs*Dz);
        elseif (i == 1)
            b(pi,1) = -(Cte(j)*P_t0(pi)*(1/Bt1(pi)-1/Bt0(pi))+ ...
                Tzt1(pi)*gs*Dz); 
        end
        
    end
    
end

end
