function [DZ, Z] = DiscretizacionEspesor(h, nz, hw)
   
    DZ = h /(nz-1);
    Z(nz,1) = 0;

    for i =1:nz
        Z(nz+1-i) = (hw - (i-1)*DZ);
    end
end