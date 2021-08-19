function [Pm, PMAT] = InicialesConCake(nz, nrt, nc, Pi, ...
    Pwf)

Pm(nrt*nz,1) = 0;
PMAT(nz,nrt) = 0;

for i = 1:nz
    for j = 1:nrt
        i_P = (i-1)*nrt+j;        
        if j <= nc
            PMAT(i,j) = Pwf(i);
            Pm(i_P) = Pwf(i);
        else
            PMAT(i,j) = Pi;
            Pm(i_P) = Pi;
        end
    end
end

end