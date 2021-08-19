function [Kr, Kz] = VectorPermeabilidades(nr, nrc, nz, Krc, Krr, Kzc, Kzr)

Kr(nz*nr,1) = 0;
Kz(nz*nr,1) = 0;

    for i = 1:nz
            for j = 1:nr
                i_P = (i-1)*nr+j;
                if j<=nrc
                    Kr(i_P) = Krc;
                    Kz(i_P) = Kzc;
                else
                    Kr(i_P) = Krr;
                    Kz(i_P) = Kzr;
                end
            end
    end

end