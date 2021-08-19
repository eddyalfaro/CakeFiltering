function Poi_m1 = PresionSupuesta(nz, nr, Pwfi, Pi, Ps)

Poi_m1(nz*nr,1)=0;

    for i = 1:nz
        for j = 1:nr
            i_P = (i-1)*nr+j;        
            if j == 1
                Poi_m1(i_P) = Pwfi(i);
            elseif j>1 && j<nr
                Poi_m1(i_P) = Ps;
            elseif j == nr
                Poi_m1(i_P) = Pi;
            end
        end
    end

end