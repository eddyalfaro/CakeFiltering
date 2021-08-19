function Swi_m1 = SaturacionDeAgua(Swim, Cwsi, Twri, Twzi, Pcowi, ...
    Z, SGwim, Cwpi, Poim, Poim1, nr, nz)

Swi_m1(nz*nr,1) = 0;

for k = 1:nz
    for i = 1:nr
        i_P = (k-1)*nr + i;
      
  %%Mediante la ecuacion del agua
        if i>1 && i<nr
            sumr = Twri(i_P,1)*((Poim1(i_P-1)-Poim1(i_P))-(Pcowi(i_P-1)-Pcowi(i_P))) ...
                + Twri(i_P,2)*((Poim1(i_P+1)-Poim1(i_P))-(Pcowi(i_P+1)-Pcowi(i_P)));
            if k == 1
                sumk = Twzi(i_P,2)*((Poim1(i_P+nr)-Poim1(i_P))-(Pcowi(i_P+nr)-Pcowi(i_P)) ...
                -SGwim(i_P)*(Z(k+1)-Z(k)));
            elseif k == nz
                sumk = Twzi(i_P,1)*(Poim1(i_P-nr)-Poim1(i_P)-(Pcowi(i_P-nr)-Pcowi(i_P)) ...
                -SGwim(i_P)*(Z(k-1)-Z(k)));
            else
                sumk = Twzi(i_P,2)*((Poim1(i_P+nr)-Poim1(i_P))-(Pcowi(i_P+nr)-Pcowi(i_P)) ...
                -SGwim(i_P)*(Z(k+1)-Z(k)))+ Twzi(i_P,1)*((Poim1(i_P-nr)-Poim1(i_P))-(Pcowi(i_P-nr)-Pcowi(i_P)) ...
                -SGwim(i_P)*(Z(k-1)-Z(k)));
            end
            Swi_m1(i_P) = Swim(i_P) ...
            + 1/Cwsi(i_P)*(-Cwpi(i_P)*(Poim1(i_P)- Poim(i_P))+ sumr + sumk);
        elseif i == 1
            sumr = Twri(i_P,2)*((Poim1(i_P+1)-Poim1(i_P))-(Pcowi(i_P+1)-Pcowi(i_P)));
            if k == 1
                sumk = Twzi(i_P,2)*((Poim1(i_P+nr)-Poim1(i_P))-(Pcowi(i_P+nr)-Pcowi(i_P)) ...
                -SGwim(i_P)*(Z(k+1)-Z(k)));
            elseif k == nz
                sumk = Twzi(i_P,1)*(Poim1(i_P-nr)-Poim1(i_P)-(Pcowi(i_P-nr)-Pcowi(i_P)) ...
                -SGwim(i_P)*(Z(k-1)-Z(k)));
            else
                sumk = Twzi(i_P,2)*((Poim1(i_P+nr)-Poim1(i_P))-(Pcowi(i_P+nr)-Pcowi(i_P)) ...
                -SGwim(i_P)*(Z(k+1)-Z(k)))+ Twzi(i_P,1)*((Poim1(i_P-nr)-Poim1(i_P))-(Pcowi(i_P-nr)-Pcowi(i_P)) ...
                -SGwim(i_P)*(Z(k-1)-Z(k)));
            end
            Swi_m1(i_P) = Swim(i_P) ...
            + 1/Cwsi(i_P)*(-Cwpi(i_P)*(Poim1(i_P)- Poim(i_P))+ sumr + sumk);
       %{
        elseif i==1
            sumr = Twri(i_P,2)*((Poim1(i_P+1)-Poim1(i_P))-(Pcowi(i_P+1)-Pcowi(i_P)));
            if k == 1
                sumk = Twzi(i_P,2)*((Poim1(i_P+nr)-Poim1(i_P))-(Pcowi(i_P+nr)-Pcowi(i_P)) ...
                -SGwim(i_P)*(Z(k+1)-Z(k)));
            elseif k == nz
                sumk = Twzi(i_P,1)*(Poim1(i_P-nr)-Poim1(i_P)-(Pcowi(i_P-nr)-Pcowi(i_P)) ...
                -SGwim(i_P)*(Z(k-1)-Z(k)));
            else
                sumk = Twzi(i_P,2)*((Poim1(i_P+nr)-Poim1(i_P))-(Pcowi(i_P+nr)-Pcowi(i_P)) ...
                -SGwim(i_P)*(Z(k+1)-Z(k)))+ Twzi(i_P,1)*((Poim1(i_P-nr)-Poim1(i_P))-(Pcowi(i_P-nr)-Pcowi(i_P)) ...
                -SGwim(i_P)*(Z(k-1)-Z(k)));
            end
            Swi_m1(i_P) = Swim(i_P) ...
            + 1/Cwsi(i_P)*(-Cwpi(i_P)*(Poim1(i_P)- Poim(i_P))+ sumr + sumk);
            %}
        else
            Swi_m1(i_P) = Swim(i_P);
        end
        
        %{
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
        
        Swi_m1(i_P) = Swim(i_P)+(1/Cosi(i_P))*(sumr + sumz ...
            -Copi(i_P)*(Poim1(i_P)-Poim(i_P)));
        %}
        
    end
end

end