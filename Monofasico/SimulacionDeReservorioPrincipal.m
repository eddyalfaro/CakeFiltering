%%
%% Simulacion de Reservorio Principal.

%% Datos proveidos
RadioPozo_FT = 0.3;
EspesorFormacion_FT = 93;
Porosidad = 0.165;
PermebilidadHorizontal_mD = 34;
ProfundidadYacimiento_FT = 5800;
PresionYacimiento_PSI = 3502;
DensidadLodo_PPG = 15;
TiempoLimite_Dias = 5;

P_FVF = (2800:400:5600)';
u_FVF = [1.18; 1.1564; 1.121; 1.1092; 1.0856; 1.0738; 1.062; 1.0502];
B_FVF = [1; 1.013339921; 1.0256917; 1.038537549; 1.050395257; ...
    1.062252964; 1.074110672; 1.085474308];

%% Constantes
USGAL_A_FT3 = (1/0.133681);
GravedadC = 32.174;
FactorConvGravedad = 0.21584e-3;
FactorConvTransmisibilidad = 0.001127;

%% conversiones y calculos
DesidadLodo_PPCF = DensidadLodo_PPG*USGAL_A_FT3;
GravedadEspecificaLodo = GravedadC*DesidadLodo_PPCF*FactorConvGravedad;

%% Suposiciones
EspesorCake_FT = 0.0052;
PermeabilidadVertical_mD = 0.8*PermebilidadHorizontal_mD;
RadioExternoYacimiento_FT = 10;
VolumenDeFiltrado_1D = 0;
VolumenDeFiltrado_2D = 0;
VolumenDeFiltrado_3D = 0;
MatrizTiempo_Caudal = [0,0];

%% Discretizacion del yacimiento
BloquesEnReservorio = 60;
BloquesEnCake = 5;
BloqueEspesor = 30;
BloquesTotalesRadio = BloquesEnReservorio + BloquesEnCake;
BloquesTotales = BloqueEspesor*BloquesTotalesRadio;

[DZ, Z] = DiscretizacionEspesor(EspesorFormacion_FT, BloqueEspesor, ...
    ProfundidadYacimiento_FT);

[ri_r,rL_r,r2_r] = DiscretizacionRadial(RadioPozo_FT, ...
    RadioExternoYacimiento_FT, BloquesEnReservorio);

[ri_c, ri, rL, r2] = DiscretizacionRadiosConCake(EspesorCake_FT, ...
    BloquesEnCake, RadioPozo_FT, ri_r);

nTheta = 12;
DTheta = pi/nTheta;
%% Condiciones iniciales t = 0, m = 0
PresionDeFondo(BloqueEspesor,1) = 0;
Dt_Horas = 0.5;
Dt_Dias = Dt_Horas/24;
m_MAX = TiempoLimite_Dias/Dt_Dias;

m = 0;

for i = 1:BloqueEspesor
    PresionDeFondo(i) = Pwf(Z(i),GravedadEspecificaLodo);
end

[Pm, MatrizPresiones] = InicialesConCake(BloqueEspesor, BloquesTotalesRadio, ...
    BloquesEnCake, PresionYacimiento_PSI, PresionDeFondo);

DiscretizacionReservorioi = pcolor(rL(1:end,2),Z,MatrizPresiones);

Bm(BloquesTotales,1) = 0;
for i = 1:BloquesTotales
     Bm(i) = Interpolacion(P_FVF, B_FVF, Pm(i));
end

%% suposiciones para m1 = m + 1
Tol_SOR = 2;
Tol_EBM = 1.2;
t = Dt_Dias;

Krc = PermeabilidadHorizontalCake(PermebilidadHorizontal_mD,t);
Kzc = PermeabilidadVerticalCake(PermeabilidadVertical_mD,t);

[Kr, Kz] = Permeabilidades(BloquesTotalesRadio, BloquesEnCake, Krc, Kzc,...
    PermebilidadHorizontal_mD,PermeabilidadVertical_mD);

[Gr, Vb] = FactorGeometricoR(ri, rL, r2, Kr, DTheta, DZ, ...
    FactorConvTransmisibilidad);

[Gz] = FactorGeometricoZ(DZ, DTheta, r2, Kz, FactorConvTransmisibilidad);

Pm1 = PresionSupuesta(BloqueEspesor, BloquesTotalesRadio, ...
    PresionDeFondo, PresionYacimiento_PSI, Pm);

[Tzm1, um1 , Bm1] = TransmisibilidadZ(Gz, Pm1, B_FVF, ...
    u_FVF, P_FVF, true);

[Trm1] = TransmisibilidadR(Gr, Pm1, Bm1, um1, true);

[Am1, b] = MatrizCoeficientes(Trm1, Tzm1, Z, Vb, Pm, Bm1, Bm, ...
    Dt_Dias, Porosidad, GravedadEspecificaLodo, DZ);

%% metodo Numerico

Pk = Pm1;
k = 0;
w = 0.5;
DPK = 15;
%%Pym (BloqueEspesor, BloquesTotalesRadio, m_MAX) = 0;

while t <= TiempoLimite_Dias
    
    DPK = 15;
    if m>1 && m<5
        Tol_SOR = 1;
        Dt_Horas = 0.75;
        Dt_Dias = Dt_Horas/24;
    elseif m>=5 && m<60
        Tol_SOR = 0.8;
        Dt_Horas = 1;
        Dt_Dias = Dt_Horas/24;
    elseif m>=60 && m < 80
        Tol_SOR = 0.4;
        Dt_Horas = 3;
        Dt_Dias = Dt_Horas/24;    
    elseif m>= 80
        Tol_SOR = 0.2;
        Dt_Horas = 5;
        Dt_Dias = Dt_Horas/24;
    end
    
    while Tol_SOR < max(DPK)

        k=k+1;

        Pk1 = SOR(Am1,Pk,b,w);

        for i = 1:BloqueEspesor
            for j =1:BloquesTotalesRadio
                i_P = (i-1)*BloquesTotalesRadio + j;
                if j == 1
                    Pk1(i_P) = PresionDeFondo(i);
                elseif j == BloquesTotalesRadio
                    Pk1(i_P) = PresionYacimiento_PSI;
                elseif Pk1(i_P) < PresionYacimiento_PSI
                    Pk1(i_P) = PresionYacimiento_PSI;
                end
             end
        end
        
        Temp = Pk;
        Pk = Pk1;
        DPK = abs(Pk - Temp);
        max(DPK)

        [Tzm1, um1 , Bm1] = TransmisibilidadZ(Gz, Pk, B_FVF, ...
        u_FVF, P_FVF, true);

        [Trm1] = TransmisibilidadR(Gr, Pk, Bm1, um1, true);

        [Am1, b] = MatrizCoeficientes(Trm1, Tzm1, Z, Vb, Pm, Bm1, Bm, ...
            Dt_Dias, Porosidad, GravedadEspecificaLodo, DZ);
    end
    
    for i = 1:BloqueEspesor
        for j =1:BloquesTotalesRadio
            i_P = (i-1)*BloquesTotalesRadio + j;
            if j == 1
                Pk(i_P) = PresionDeFondo(i);
            elseif j == BloquesTotalesRadio
                Pk(i_P) = PresionYacimiento_PSI;
            elseif Pk(i_P) < PresionYacimiento_PSI
                Pk(i_P) = PresionYacimiento_PSI;
            end
         end
    end
    
    PMat = GenMatrizPresiones(Pk, BloquesTotalesRadio,BloqueEspesor);
    DiscretizacionReservorio = pcolor(rL(1:25,2),-Z,PMat(1:end,1:25));
    
    sum1 = 0;
    sum2 = 0;

    for i = 1:BloqueEspesor
        for j = 1:BloquesTotalesRadio
            i_P = (i-1)*BloquesTotalesRadio+j;
            sum1 = sum1 + Vb(j)*Porosidad/(5.614*Dt_Dias)*(1/Bm1(i_P) - ...
                1/Bm(i_P));
            if j == 1
                sum2 = sum2 + Trm1(i_P,2)*(Pk(i_P)-Pk(i_P+1));
            elseif j == BloquesTotalesRadio
                sum2 = sum2 + Trm1(i_P,1)*(Pk(i_P)-Pk(i_P-1));
            end
        end
    end

    EBM = abs(sum1/sum2-1);

    if EBM > Tol_EBM
        disp('Error EBM');
        disp(EBM);
        disp('Tiempo');
        disp(t);
        break
    end
    
    qfil = sum2/BloqueEspesor;
    
    VolumenDeFiltrado_1D = VolumenDeFiltrado_1D + qfil*Dt_Dias;
    VolumenDeFiltrado_2D = VolumenDeFiltrado_2D + sum2*Dt_Dias;
    VolumenDeFiltrado_3D = VolumenDeFiltrado_3D + sum2*nTheta*Dt_Dias;
    
    Pm = Pk;
    %%Pym(1:end,1:end,m+1) = [Pm];
    t = t + Dt_Dias    
    MatrizTiempo_Caudal = [ MatrizTiempo_Caudal ; t , sum2];
    m = m + 1;

    Krc = PermeabilidadHorizontalCake(PermebilidadHorizontal_mD,t);
    Kzc = PermeabilidadVerticalCake(PermeabilidadVertical_mD,t);

    [Kr, Kz] = Permeabilidades(BloquesTotalesRadio, BloquesEnCake, Krc, Kzc,...
        PermebilidadHorizontal_mD,PermeabilidadVertical_mD);

    [Gr, Vb] = FactorGeometricoR(ri, rL, r2, Kr, DTheta, DZ, ...
        FactorConvTransmisibilidad);

    [Gz] = FactorGeometricoZ(DZ, DTheta, r2, Kz, FactorConvTransmisibilidad);

    Pm1 = PresionSupuesta(BloqueEspesor, BloquesTotalesRadio, ...
        PresionDeFondo, PresionYacimiento_PSI, Pm);
    
    Pk = Pm1;
    
end 
%% funciones
function Khc = PermeabilidadHorizontalCake(Kb,t)

Khc = Kb*exp(-t);

end

function Kzc = PermeabilidadVerticalCake(Kb,t)

Kzc = Kb*exp(-t);

end

function PresionDeFondo = Pwf(h,gc)

PresionDeFondo = gc*h;

end

function Pm1 = PresionSupuesta(nz, nr, Pwf, Pi, Pm)

Pm1(nz*nr,1) = 0;

for i = 1:nz
    for j = 1:nr
        i_P = (i-1)*nr + j;
        if j == 1
            Pm1(i_P) = Pwf(i);
        elseif j == nr
            Pm1(i_P) = Pi;
        else
            Pm1(i_P) = Pm(i_P)-1;
        end
    end
end

end

function [Kh, Kv] = Permeabilidades(nrt, nc, khc,kvc,kh,kv)

Kh(nrt,1) = 0;
Kv(nrt,1) = 0;

for i=1:nrt
   if i <= nc
       Kh(i) = khc;
       Kv(i) = kvc;
   else
       Kh(i) = kh;
       Kv(i) = kv;
   end
end

end

function PMat = GenMatrizPresiones(Pm, nr, nz)

PMat(nz,nr)=0;

for i = 1:nz
    for j = 1:nr
        PMat(i,j)=Pm((i-1)*nr+j,1);
    end
end

end