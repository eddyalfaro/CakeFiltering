function [Cwpi, Cwsi, Copi, Cosi] = ConstantesRHS(Vbi, Alpha, ...
    Phi, Dt, Swim, Bwim, Bwim1, Boim, Boim1, Poim, Poim1, nr, nz)

DPoi = Poim1 - Poim;
Dbwi = Bwim1.^-1 - Bwim.^-1;
Dboi = Boim1.^-1 - Boim.^-1;

mbwi = Dbwi./DPoi;
mboi = Dboi./DPoi;

for i = 1:nz
        for j = 1:nr
            i_P = (i-1)*nr+j;
            if (j == 1)
                mbwi(i_P) = 0;
                mboi(i_P) = 0;
            end
            if DPoi(i_P) == 0
                mboi(i_P) = 0;
                mbwi(i_P) = 0;
            end
        end
end

Cwpi = (Phi/(Alpha*Dt))*Vbi.*Swim.*mbwi;
Cwsi = (Phi/(Alpha*Dt))*Vbi.*Bwim1;

Copi = (Phi/(Alpha*Dt))*Vbi.*(1-Swim).*mboi;
Cosi = -(Phi/(Alpha*Dt))*Vbi.*Boim1;

end