function [Bci, Uci, Krci, SGci, Pcowi] = PropiedadesCeldas (Pc_PVT, Bc_PVT, ...
    Uc_PVT, Pci, Kr, Pcow, Sw, Swi, SGc_sc)

%{ 
Calculo de las propiedades de los fluidos y permeabilidades relativas 
de estos a condiciones de cada celda.
%}

    [nt, ~] = size(Pci);
    Bci(nt, 1) = 0;
    Uci(nt, 1) = 0;
    Krci(nt, 1) = 0;
    SGci(nt, 1) = 0;
    Pcowi(nt, 1) = 0;
    
    for i = 1:nt
        Bci(i) = Interpolacion(Pc_PVT, Bc_PVT, Pci(i));
        Uci(i) = Interpolacion(Pc_PVT, Uc_PVT, Pci(i));
        Krci(i) = Interpolacion(Sw, Kr, Swi(i));
        Pcowi(i) = Interpolacion(Sw, Pcow, Swi(i));
    end
    
    SGci = (SGci + SGc_sc)./Bci;    

end