function [BcL, UcL, KrcL] = PropiedadesFronteras(Bci, Uci, Krci,...
    Kr_Soir, Pci, nr, nz, Agua)
%{
Las propiedades tienen 4 columnas, cada una se refiere a un limite de un
bloque, la columna uno es el limite oeste del bloque, la columna 2 el
limite inferior, la columna 3 el limite este, y la columna 4 el limite
superior
%}

BcL(nr*nz,4)=0;
UcL(nr*nz,4)=0;
KrcL(nr*nz,4)=0;

if Agua == true

    for k= 1:nz
   for i =1:nr
        i_P = (k-1)*nr + i;
        
        if i == 1
            BcL (i_P, 1) = Bci(i_P);            
            BcL (i_P, 3) = (Bci(i_P) + Bci(i_P+1))/2;
            
            UcL (i_P, 1) = Uci(i_P);            
            UcL (i_P, 3) = (Uci(i_P) + Uci(i_P+1))/2;
            
            KrcL(i_P, 1) = Kr_Soir;
            KrcL(i_P, 3) = Kr_Soir;
            KrcL(i_P, 4) = Kr_Soir;
            KrcL(i_P, 2) = Kr_Soir;
            %% chequeo de fronteras superior e inferior
             if k == 1           
                BcL (i_P, 2) = (Bci(i_P) + Bci(i_P + nr))/2;
                BcL (i_P, 4) = Bci(i_P);
                
                UcL (i_P, 2) = (Uci(i_P) + Uci(i_P + nr))/2;
                UcL (i_P, 4) = Uci(i_P);
            elseif k == nz
                BcL (i_P, 2) = Bci(i_P);
                BcL (i_P, 4) = (Bci(i_P) + Bci(i_P - nr))/2;
                
                UcL (i_P, 2) = Uci(i_P);
                UcL (i_P, 4) = (Uci(i_P) + Uci(i_P - nr))/2;
            else
                BcL (i_P, 2) = (Bci(i_P) + Bci(i_P + nr))/2;
                BcL (i_P, 4) = (Bci(i_P) + Bci(i_P - nr))/2;
                
                UcL (i_P, 2) = (Uci(i_P) + Uci(i_P + nr))/2;
                UcL (i_P, 4) = (Uci(i_P) + Uci(i_P - nr))/2;
             end
            
        elseif i == 2
            BcL (i_P, 1) = Bci(i_P);            
            BcL (i_P, 3) = (Bci(i_P) + Bci(i_P+1))/2;
            
            UcL (i_P, 1) = Uci(i_P);            
            UcL (i_P, 3) = (Uci(i_P) + Uci(i_P+1))/2;
            
            KrcL(i_P, 1) = Kr_Soir;
            
            if Pci(i_P) >= Pci(i_P +1)
                KrcL(i_P, 3) = Krci(i_P);
            else
                KrcL(i_P, 3) = Krci(i_P + 1);
            end
            %% chequeo de fronteras superior e inferior
            if k == 1           
                BcL (i_P, 2) = (Bci(i_P) + Bci(i_P + nr))/2;
                BcL (i_P, 4) = Bci(i_P);
                
                UcL (i_P, 2) = (Uci(i_P) + Uci(i_P + nr))/2;
                UcL (i_P, 4) = Uci(i_P);
                
                KrcL(i_P, 4) = Krci(i_P);
                if Pci(i_P) >= Pci(i_P + nr)
                    KrcL(i_P, 2) = Krci(i_P);
                else
                    KrcL(i_P, 2) = Krci(i_P + nr);
                end
            elseif k == nz
                BcL (i_P, 2) = Bci(i_P);
                BcL (i_P, 4) = (Bci(i_P) + Bci(i_P - nr))/2;
                
                UcL (i_P, 2) = Uci(i_P);
                UcL (i_P, 4) = (Uci(i_P) + Uci(i_P - nr))/2;
                
                KrcL(i_P, 2) = Krci(i_P);
                if Pci(i_P) >= Pci(i_P - nr)
                    KrcL(i_P, 4) = Krci(i_P);
                else
                    KrcL(i_P, 4) = Krci(i_P - nr);
                end
            else
                BcL (i_P, 2) = (Bci(i_P) + Bci(i_P + nr))/2;
                BcL (i_P, 4) = (Bci(i_P) + Bci(i_P - nr))/2;
                
                UcL (i_P, 2) = (Uci(i_P) + Uci(i_P + nr))/2;
                UcL (i_P, 4) = (Uci(i_P) + Uci(i_P - nr))/2;
                
                if Pci(i_P) >= Pci(i_P - nr)
                    KrcL(i_P, 4) = Krci(i_P);
                else
                    KrcL(i_P, 4) = Krci(i_P - nr);
                end
                
                if Pci(i_P) >= Pci(i_P + nr)
                    KrcL(i_P, 2) = Krci(i_P);
                else
                    KrcL(i_P, 2) = Krci(i_P + nr);
                end
            end           
            
        elseif i>2 && i<nr            
            BcL (i_P, 1) = (Bci(i_P) + Bci(i_P-1))/2;            
            BcL (i_P, 3) = (Bci(i_P) + Bci(i_P+1))/2;
            
            UcL (i_P, 1) = (Uci(i_P) + Uci(i_P-1))/2;            
            UcL (i_P, 3) = (Uci(i_P) + Uci(i_P+1))/2;
            
            if Pci(i_P) >= Pci(i_P +1)
                KrcL(i_P, 3) = Krci(i_P);
            else
                KrcL(i_P, 3) = Krci(i_P + 1);
            end
            
            if Pci(i_P) >= Pci(i_P -1)
                KrcL(i_P, 1) = Krci(i_P);
            else
                KrcL(i_P, 1) = Krci(i_P - 1);
            end
            %% chequeo de fronteras superior e inferior
            if k == 1           
                BcL (i_P, 2) = (Bci(i_P) + Bci(i_P + nr))/2;
                BcL (i_P, 4) = Bci(i_P);
                
                UcL (i_P, 2) = (Uci(i_P) + Uci(i_P + nr))/2;
                UcL (i_P, 4) = Uci(i_P);
                
                KrcL(i_P, 4) = Krci(i_P);
                if Pci(i_P) >= Pci(i_P + nr)
                    KrcL(i_P, 2) = Krci(i_P);
                else
                    KrcL(i_P, 2) = Krci(i_P + nr);
                end
            elseif k == nz
                BcL (i_P, 2) = Bci(i_P);
                BcL (i_P, 4) = (Bci(i_P) + Bci(i_P - nr))/2;
                
                UcL (i_P, 2) = Uci(i_P);
                UcL (i_P, 4) = (Uci(i_P) + Uci(i_P - nr))/2;
                
                KrcL(i_P, 2) = Krci(i_P);
                if Pci(i_P) >= Pci(i_P - nr)
                    KrcL(i_P, 4) = Krci(i_P);
                else
                    KrcL(i_P, 4) = Krci(i_P - nr);
                end
            else
                BcL (i_P, 2) = (Bci(i_P) + Bci(i_P + nr))/2;
                BcL (i_P, 4) = (Bci(i_P) + Bci(i_P - nr))/2;
                
                UcL (i_P, 2) = (Uci(i_P) + Uci(i_P + nr))/2;
                UcL (i_P, 4) = (Uci(i_P) + Uci(i_P - nr))/2;
                
                if Pci(i_P) >= Pci(i_P - nr)
                    KrcL(i_P, 4) = Krci(i_P);
                else
                    KrcL(i_P, 4) = Krci(i_P - nr);
                end
                
                if Pci(i_P) >= Pci(i_P + nr)
                    KrcL(i_P, 2) = Krci(i_P);
                else
                    KrcL(i_P, 2) = Krci(i_P + nr);
                end
            end
            
        elseif i == nr            
            BcL (i_P, 1) = (Bci(i_P) + Bci(i_P-1))/2;            
            BcL (i_P, 3) = Bci(i_P);
            
            UcL (i_P, 1) = (Uci(i_P) + Uci(i_P-1))/2;            
            UcL (i_P, 3) = Uci(i_P);
            
            KrcL(i_P, 3) = Krci(i_P);
            if Pci(i_P) >= Pci(i_P - 1)
                KrcL(i_P, 1) = Krci(i_P);
            else
                KrcL(i_P, 1) = Krci(i_P - 1);
            end
            
            %% chequeo de fronteras superior e inferior
            if k == 1           
                BcL (i_P, 2) = (Bci(i_P) + Bci(i_P + nr))/2;
                BcL (i_P, 4) = Bci(i_P);
                
                UcL (i_P, 2) = (Uci(i_P) + Uci(i_P + nr))/2;
                UcL (i_P, 4) = Uci(i_P);
                
                KrcL(i_P, 4) = Krci(i_P);
                if Pci(i_P) >= Pci(i_P + nr)
                    KrcL(i_P, 2) = Krci(i_P);
                else
                    KrcL(i_P, 2) = Krci(i_P + nr);
                end
            elseif k == nz
                BcL (i_P, 2) = Bci(i_P);
                BcL (i_P, 4) = (Bci(i_P) + Bci(i_P - nr))/2;
                
                UcL (i_P, 2) = Uci(i_P);
                UcL (i_P, 4) = (Uci(i_P) + Uci(i_P - nr))/2;
                
                KrcL(i_P, 2) = Krci(i_P);
                if Pci(i_P) >= Pci(i_P - nr)
                    KrcL(i_P, 4) = Krci(i_P);
                else
                    KrcL(i_P, 4) = Krci(i_P - nr);
                end
            else
                BcL (i_P, 2) = (Bci(i_P) + Bci(i_P + nr))/2;
                BcL (i_P, 4) = (Bci(i_P) + Bci(i_P - nr))/2;
                
                UcL (i_P, 2) = (Uci(i_P) + Uci(i_P + nr))/2;
                UcL (i_P, 4) = (Uci(i_P) + Uci(i_P - nr))/2;
                
                if Pci(i_P) >= Pci(i_P - nr)
                    KrcL(i_P, 4) = Krci(i_P);
                else
                    KrcL(i_P, 4) = Krci(i_P - nr);
                end
                
                if Pci(i_P) >= Pci(i_P + nr)
                    KrcL(i_P, 2) = Krci(i_P);
                else
                    KrcL(i_P, 2) = Krci(i_P + nr);
                end
            end
            
        end
        
   end
    end
else
    for k= 1:nz
        for i =1:nr
            i_P = (k-1)*nr + i;
                    
            if i == 1
                BcL (i_P, 1) = Bci(i_P);            
                BcL (i_P, 3) = (Bci(i_P) + Bci(i_P+1))/2;
            
                UcL (i_P, 1) = Uci(i_P);            
                UcL (i_P, 3) = (Uci(i_P) + Uci(i_P+1))/2;
            
                KrcL(i_P, 1) = Kr_Soir;
            
                if Pci(i_P) >= Pci(i_P +1)
                    KrcL(i_P, 3) = Krci(i_P);
                else
                    KrcL(i_P, 3) = Krci(i_P + 1);
                end
                %% chequeo de fronteras superior e inferior
                if k == 1           
                    BcL (i_P, 2) = (Bci(i_P) + Bci(i_P + nr))/2;
                    BcL (i_P, 4) = Bci(i_P);

                    UcL (i_P, 2) = (Uci(i_P) + Uci(i_P + nr))/2;
                    UcL (i_P, 4) = Uci(i_P);

                    KrcL(i_P, 4) = Krci(i_P);
                    if Pci(i_P) >= Pci(i_P + nr)
                        KrcL(i_P, 2) = Krci(i_P);
                    else
                        KrcL(i_P, 2) = Krci(i_P + nr);
                    end
                elseif k == nz
                    BcL (i_P, 2) = Bci(i_P);
                    BcL (i_P, 4) = (Bci(i_P) + Bci(i_P - nr))/2;

                    UcL (i_P, 2) = Uci(i_P);
                    UcL (i_P, 4) = (Uci(i_P) + Uci(i_P - nr))/2;

                    KrcL(i_P, 2) = Krci(i_P);
                    if Pci(i_P) >= Pci(i_P - nr)
                        KrcL(i_P, 4) = Krci(i_P);
                    else
                        KrcL(i_P, 4) = Krci(i_P - nr);
                    end
                else
                    BcL (i_P, 2) = (Bci(i_P) + Bci(i_P + nr))/2;
                    BcL (i_P, 4) = (Bci(i_P) + Bci(i_P - nr))/2;

                    UcL (i_P, 2) = (Uci(i_P) + Uci(i_P + nr))/2;
                    UcL (i_P, 4) = (Uci(i_P) + Uci(i_P - nr))/2;

                    if Pci(i_P) >= Pci(i_P - nr)
                        KrcL(i_P, 4) = Krci(i_P);
                    else
                        KrcL(i_P, 4) = Krci(i_P - nr);
                    end

                    if Pci(i_P) >= Pci(i_P + nr)
                        KrcL(i_P, 2) = Krci(i_P);
                    else
                        KrcL(i_P, 2) = Krci(i_P + nr);
                    end
                end           

            elseif i>1 && i<nr            
                BcL (i_P, 1) = (Bci(i_P) + Bci(i_P-1))/2;            
                BcL (i_P, 3) = (Bci(i_P) + Bci(i_P+1))/2;

                UcL (i_P, 1) = (Uci(i_P) + Uci(i_P-1))/2;            
                UcL (i_P, 3) = (Uci(i_P) + Uci(i_P+1))/2;

                if Pci(i_P) >= Pci(i_P +1)
                    KrcL(i_P, 3) = Krci(i_P);
                else
                    KrcL(i_P, 3) = Krci(i_P + 1);
                end

                if Pci(i_P) >= Pci(i_P -1)
                    KrcL(i_P, 1) = Krci(i_P);
                else
                    KrcL(i_P, 1) = Krci(i_P - 1);
                end
                %% chequeo de fronteras superior e inferior
                if k == 1           
                    BcL (i_P, 2) = (Bci(i_P) + Bci(i_P + nr))/2;
                    BcL (i_P, 4) = Bci(i_P);

                    UcL (i_P, 2) = (Uci(i_P) + Uci(i_P + nr))/2;
                    UcL (i_P, 4) = Uci(i_P);

                    KrcL(i_P, 4) = Krci(i_P);
                    if Pci(i_P) >= Pci(i_P + nr)
                        KrcL(i_P, 2) = Krci(i_P);
                    else
                        KrcL(i_P, 2) = Krci(i_P + nr);
                    end
                elseif k == nz
                    BcL (i_P, 2) = Bci(i_P);
                    BcL (i_P, 4) = (Bci(i_P) + Bci(i_P - nr))/2;

                    UcL (i_P, 2) = Uci(i_P);
                    UcL (i_P, 4) = (Uci(i_P) + Uci(i_P - nr))/2;

                    KrcL(i_P, 2) = Krci(i_P);
                    if Pci(i_P) >= Pci(i_P - nr)
                        KrcL(i_P, 4) = Krci(i_P);
                    else
                        KrcL(i_P, 4) = Krci(i_P - nr);
                    end
                else
                    BcL (i_P, 2) = (Bci(i_P) + Bci(i_P + nr))/2;
                    BcL (i_P, 4) = (Bci(i_P) + Bci(i_P - nr))/2;

                    UcL (i_P, 2) = (Uci(i_P) + Uci(i_P + nr))/2;
                    UcL (i_P, 4) = (Uci(i_P) + Uci(i_P - nr))/2;

                    if Pci(i_P) >= Pci(i_P - nr)
                        KrcL(i_P, 4) = Krci(i_P);
                    else
                        KrcL(i_P, 4) = Krci(i_P - nr);
                    end

                    if Pci(i_P) >= Pci(i_P + nr)
                        KrcL(i_P, 2) = Krci(i_P);
                    else
                        KrcL(i_P, 2) = Krci(i_P + nr);
                    end
                end

            elseif i == nr            
                BcL (i_P, 1) = (Bci(i_P) + Bci(i_P-1))/2;            
                BcL (i_P, 3) = Bci(i_P);

                UcL (i_P, 1) = (Uci(i_P) + Uci(i_P-1))/2;            
                UcL (i_P, 3) = Uci(i_P);

                KrcL(i_P, 3) = Krci(i_P);
                if Pci(i_P) >= Pci(i_P - 1)
                    KrcL(i_P, 1) = Krci(i_P);
                else
                    KrcL(i_P, 1) = Krci(i_P - 1);
                end

                %% chequeo de fronteras superior e inferior
                if k == 1           
                    BcL (i_P, 2) = (Bci(i_P) + Bci(i_P + nr))/2;
                    BcL (i_P, 4) = Bci(i_P);

                    UcL (i_P, 2) = (Uci(i_P) + Uci(i_P + nr))/2;
                    UcL (i_P, 4) = Uci(i_P);

                    KrcL(i_P, 4) = Krci(i_P);
                    if Pci(i_P) >= Pci(i_P + nr)
                        KrcL(i_P, 2) = Krci(i_P);
                    else
                        KrcL(i_P, 2) = Krci(i_P + nr);
                    end
                elseif k == nz
                    BcL (i_P, 2) = Bci(i_P);
                    BcL (i_P, 4) = (Bci(i_P) + Bci(i_P - nr))/2;

                    UcL (i_P, 2) = Uci(i_P);
                    UcL (i_P, 4) = (Uci(i_P) + Uci(i_P - nr))/2;

                    KrcL(i_P, 2) = Krci(i_P);
                    if Pci(i_P) >= Pci(i_P - nr)
                        KrcL(i_P, 4) = Krci(i_P);
                    else
                        KrcL(i_P, 4) = Krci(i_P - nr);
                    end
                else
                    BcL (i_P, 2) = (Bci(i_P) + Bci(i_P + nr))/2;
                    BcL (i_P, 4) = (Bci(i_P) + Bci(i_P - nr))/2;

                    UcL (i_P, 2) = (Uci(i_P) + Uci(i_P + nr))/2;
                    UcL (i_P, 4) = (Uci(i_P) + Uci(i_P - nr))/2;

                    if Pci(i_P) >= Pci(i_P - nr)
                        KrcL(i_P, 4) = Krci(i_P);
                    else
                        KrcL(i_P, 4) = Krci(i_P - nr);
                    end

                    if Pci(i_P) >= Pci(i_P + nr)
                        KrcL(i_P, 2) = Krci(i_P);
                    else
                        KrcL(i_P, 2) = Krci(i_P + nr);
                    end
                end

            end
        end        
    end
end
end
