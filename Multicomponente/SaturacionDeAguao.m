function Swi_m1 = SaturacionDeAguao(Swim, Cosi, Tori, Tozi, ...
  Z, SGoim, Copi, Poim, Poim1, nr, nz)

Swi_m1(nz*nr,1) = 0;

for k = 1:nz
    for i = 1:nr
        i_P = (k-1)*nr + i;
        
        
        if i == 1
           sumr = Tori(i_P,2)*(Poim1(i_P+1)-Poim1(i_P)); 
        elseif i == nr
           sumr = Tori(i_P,1)*(Poim1(i_P-1)-Poim1(i_P));
        else
           sumr = Tori(i_P,1)*(Poim1(i_P-1)-Poim1(i_P)) ...
               + Tori(i_P,2)*(Poim1(i_P+1)-Poim1(i_P));
        end
        
        if k == 1
           sumz = Tozi(i_P,2)*(Poim1(i_P+nr)...
               -Poim1(i_P)-SGoim(i_P)*(Z(k+1)-Z(k)));
        elseif k == nz
           sumz = Tozi(i_P,1)*(Poim1(i_P-nr)-Poim1(i_P)...
               -SGoim(i_P)*(Z(k-1)-Z(k)));
        else
           sumz = Tozi(i_P,1)*(Poim1(i_P-nr)-Poim1(i_P)...
               -SGoim(i_P)*(Z(k-1)-Z(k))) + Tozi(i_P,2)*(Poim1(i_P+nr)...
               -Poim1(i_P)-SGoim(i_P)*(Z(k+1)-Z(k)));
        end
        
        if i == 1 || i == nr
            Swi_m1(i_P) = Swim(i_P);
        else
        Swi_m1(i_P) = Swim(i_P)+(1/Cosi(i_P))*(sumr + sumz ...
            -Copi(i_P)*(Poim1(i_P)-Poim(i_P)));
        end
        
    end
end

end