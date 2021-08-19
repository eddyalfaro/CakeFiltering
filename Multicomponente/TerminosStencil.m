function [Ei, Wi, Ui, Li, Ci] = TerminosStencil(Trti, Tzti, Cpsi)

Ei = Trti(1:end,2);
Wi = Trti(1:end,1);
Ui = Tzti(1:end,1);
Li = Tzti(1:end,2);

Ci = -(Ei+Wi+Ui+Li+Cpsi);

end