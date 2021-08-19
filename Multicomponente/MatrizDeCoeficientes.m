function A = MatrizDeCoeficientes(Ei, Wi, Ci, Ui, Li, nr, nz)

A(nr*nz,nr*nz) = 0;

for k = 1:nz
    for i = 1:nr        
         i_P = (k-1)*nr + i;
         
         if i>1 && i<nr
             A(i_P,i_P) = Ci(i_P);
             A(i_P,i_P-1) = Wi(i_P);
             A(i_P,i_P+1) = Ei(i_P);
             
             if k == 1
                 A(i_P,i_P+nr) = Li(i_P);
             elseif k>1 && k<nz
                 A(i_P,i_P+nr) = Li(i_P);
                 A(i_P,i_P-nr) = Ui(i_P);
             elseif k == nz
                 A(i_P,i_P-nr) = Ui(i_P);
             end
         %{    
         elseif i == 1
             A(i_P,i_P) = Ci(i_P);
             A(i_P,i_P+1) = Ei(i_P);
             
             if k == 1
                 A(i_P,i_P+nr) = Li(i_P);
             elseif k>1 && k<nz
                 A(i_P,i_P+nr) = Li(i_P);
                 A(i_P,i_P-nr) = Ui(i_P);
             elseif k == nz
                 A(i_P,i_P-nr) = Ui(i_P);
             end 
             
         elseif i == nr
             A(i_P,i_P) = Ci(i_P);
             A(i_P,i_P-1) = Wi(i_P);
             
             if k == 1
                 A(i_P,i_P+nr) = Li(i_P);
             elseif k>1 && k<nz
                 A(i_P,i_P+nr) = Li(i_P);
                 A(i_P,i_P-nr) = Ui(i_P);
             elseif k == nz
                 A(i_P,i_P-nr) = Ui(i_P);
             end 
             %}
         end
    end
end

end