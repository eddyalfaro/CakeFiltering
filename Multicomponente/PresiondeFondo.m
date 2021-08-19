function Pwf = PresiondeFondo(Z, DE, B_PVT, P_PVT)

[nz,~] = size(Z);
Pwf(nz,1) = 0;
Pwf(1,1) = Z(1)*DE;

for i =2:nz    
    [B] = Interpolacion(P_PVT,B_PVT,Pwf(i-1));
    Pwf(i) = (Z(i)-Z(i-1))*DE/B + Pwf(i-1);    
end

end