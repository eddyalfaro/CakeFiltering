function MAT = OrganizarVector(nr,nz,X)

MAT(nz,nr) = 0;

for i = 1:nz
        for j = 1:nr
            i_P = (i-1)*nr+j; 
            MAT(i,j) = X(i_P);
        end
end

end