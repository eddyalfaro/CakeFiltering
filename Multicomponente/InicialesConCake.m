function [Pom, PoMAT, Sw, SwMAT, So, SoMAT] = InicialesConCake(nz, ...
    nr, nrc, Pi, Pwf, Swir)
%{
Establecimiento de las presiones y condiciones iniciales en el yacimiento
%}

    Pom(nr*nz,1) = 0;
    PoMAT(nz,nr) = 0;
    
    Sw(nr*nz,1) = 0;
    SwMAT(nz,nr)= 0;

    for i = 1:nz
        for j = 1:nr
            i_P = (i-1)*nr+j; 
            
            SwMAT(i,j) = Swir;
            Sw(i_P) = Swir;
            
            if j <= nrc
                PoMAT(i,j) = Pwf(i);
                Pom(i_P) = Pwf(i);
                
                %%SwMAT(i,j) = 1;
                %%Sw(i_P) = 1;
            
            elseif j>(nrc)
                PoMAT(i,j) = Pi;
                Pom(i_P) = Pi;
                
                %%SwMAT(i,j) = Swir;
                %%Sw(i_P) = Swir;
            end
        end
    end   
    
    So = 1 - Sw;
    SoMAT = 1 - SwMAT;

end