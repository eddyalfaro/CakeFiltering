function [DZ, Z] = DiscretizacionEspesor(h, nz, hw)

if nz == 1
    
    DZ = h;
    Z(nz,1) = hw;
    
else
    
    DZ = h /(nz-1);
    Z(nz,1) = 0;

    for i = 1:nz
        Z(i) = (hw - (nz-i)*DZ);
    end
    
end

end