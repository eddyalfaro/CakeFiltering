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
API_Petroleo = 12;
DensidadSalmuera_PPG = 9.18;
Swir = 0.203;
Soir = 1 - 0.726;


%% PVT Lodo
Pl_FVF = (2800:400:5600)';
Ul_FVF = [1.18; 1.1564; 1.121; 1.1092; 1.0856; 1.0738; 1.062; 1.0502];
Bl_FVF = [1; 1.013339921; 1.0256917; 1.038537549; 1.050395257; ...
    1.062252964; 1.074110672; 1.085474308];

%% PVT Agua y Petroleo
P_FVF = [1200.10;(1500:500:4500)'];
Bo_FVF = [1.17757; 1.17256; 1.16495; 1.15813; 1.15196; 1.14636; ...
    1.14122; 1.13650];
Bw_FVF = [1.03760; 1.03657; 1.03487; 1.03318; 1.03148; 1.02980; ...
    1.02812; 1.02644];
Uo_FVF = [0.93086; 0.97237; 1.04213; 1.11237; 1.18283; 1.25331; ...
    1.32364; 1.39369];
Uw_FVF = [0.28915; 0.28944; 0.28991; 0.29039; 0.29087; 0.29136; ...
    0.29184; 0.29233];

%% Permeabilidad relativa del Agua
Sww = [0; 0.203; 0.229; 0.255; 0.281; 0.308; 0.334; 0.386; 0.412; ...
    0.438; 0.464; 0.491; 0.517; 0.543; 0.569; 0.595; 0.647; 0.673; ...
    0.700; 0.726];
Krw = [0.00000; 0.00000; 0.002085; 0.002743; 0.003608; 0.004798; ...
    0.006312; 0.010925; 0.014374; 0.018910; 0.024878; 0.033077; ...
    0.043517; 0.057251; 0.075320; 0.099092; 0.171509; 0.225639; ...
    0.300000; 0.360700];

%% Permeabilidad relativa del Petroleo y Presion Capilar
Swo = [0.203; 0.229; 0.255; 0.281; 0.308; 0.334; 0.386; 0.412; ...
    0.438; 0.464; 0.491; 0.517; 0.543; 0.569; 0.595; 0.647; 0.673; ...
    0.700; 0.726; 1];
Kro = [0.800000; 0.740700; 0.682900; 0.626700; 0.572200; 0.519400; ...
    0.419000; 0.371500; 0.326100; 0.282600; 0.241300; 0.202200; ...
    0.165600; 0.131400; 0.100000; 0.046590; 0.025430; 0.009065; ...
    0.000000; 0.000000];
Pcow = [196.8458; 96.20918; 60.00183; 38.27109; 21.89194; 18.85122; ...
    14.66375; 12.57002; 10.47628; 8.382548; 6.208286; 4.417908; ...
    2.883554; 1.282146; 0; 0; 0; 0; 0; 0];

%% Constantes
USGAL_A_FT3 = (1/0.133681);
GravedadC = 32.174;
FactorConvGravedad = 0.21584e-3;
FactorConvTransmisibilidad = 0.001127;
Alpha = 5.614;

%% conversiones y calculos
DensidadLodo_PPCF = DensidadLodo_PPG*USGAL_A_FT3;
DensidadEspecificaLodo = GravedadC*DensidadLodo_PPCF*FactorConvGravedad;

GravedadEspecificaPetroleo = 141.5/(API_Petroleo + 131.5);
DensidadPetroleo_PPG = (459/55)*GravedadEspecificaPetroleo;
DensidadPetroleo_PPCF = DensidadPetroleo_PPG*USGAL_A_FT3;
DensidadEspecificaPetroleo = GravedadC*DensidadPetroleo_PPCF*FactorConvGravedad;

DensidadSalmuera_PPCF = DensidadSalmuera_PPG*USGAL_A_FT3;
DensidadEspecificaSalmuera = GravedadC*DensidadSalmuera_PPCF*FactorConvGravedad;

%% Suposiciones
EspesorCake_FT = 0.0052;
PermeabilidadVertical_mD = 0.2*PermebilidadHorizontal_mD;
RadioExternoYacimiento_FT =3000;
MatrizTiempo_Caudal = [0,0];
MatrizTiempo_Filtrado = [0,0];

%% Discretizacion del yacimiento
nrr = 45;
nrc = 1;
nz = 20;

[DZ, Z] = DiscretizacionEspesor(EspesorFormacion_FT, nz, ...
    ProfundidadYacimiento_FT);

[ri_r,rL_r,r2_r] = DiscretizacionRadial(RadioPozo_FT, ...
    RadioExternoYacimiento_FT, nrr);

[ri_c, ri, rL, r2] = DiscretizacionRadiosConCake(EspesorCake_FT, ...
    nrc, RadioPozo_FT, ri_r);

nTheta = 1;
DTheta = 2*pi/nTheta;

[nr,~] = size(ri);
nt = nr*nz;

PresionDeFondo(nz,1) = 0;
t = 0;
Dt_Horas = 5.5/60;
Dt_Dias = Dt_Horas/24;

Tiempo_DIAS_MAX = 5;

%calculo presion de fondo
Pwfi = PresiondeFondo(Z, DensidadEspecificaLodo, Bl_FVF, Pl_FVF);

[Poi_m, PoMAT_0, Swi_m, SwMAT_0, So_m, SoMAT_0] = InicialesConCake(nz,...
    nr,nrc,PresionYacimiento_PSI,Pwfi,Swir);

MatrizTiempo_Presion = [0, Poi_m'];

Krw_Soir = Interpolacion(Sww, Krw, Soir);
m=0;
while t < Tiempo_DIAS_MAX
%%while m < 5
%% Condiciones iniciales t = 0, m = 0

    %calculo de permeabilidad
    Krc = PermeabilidadCake(PermebilidadHorizontal_mD,t);
    Kzc = PermeabilidadCake(PermeabilidadVertical_mD,t);

    [Kri, Kzi] = VectorPermeabilidades(nr, nrc, nz, Krc, ...
        PermebilidadHorizontal_mD, Kzc, PermeabilidadVertical_mD);

    %calculo factores geometricos
    [Gri_m, Vbi] = FactorGeometricoR(ri, rL, r2, Kri, ...
        DTheta, DZ, FactorConvTransmisibilidad, nr, nz);

    [Gzi_m] = FactorGeometricoZ(DZ, DTheta, r2, Kzi, ...
        FactorConvTransmisibilidad);
     
    m = m + 1;
    
    if m == 2
        Dt_Horas = 13.5/60;
        Dt_Dias = Dt_Horas/24;
    elseif m == 3
        Dt_Horas = 27.5/60;
        Dt_Dias = Dt_Horas/24;
    elseif m == 4
        Dt_Horas = 44/60;
        Dt_Dias = Dt_Horas/24;
    elseif m == 5
        Dt_Horas = 50/60;
        Dt_Dias = Dt_Horas/24;
    elseif m == 8
        Dt_Horas = 55/60;
        Dt_Dias = Dt_Horas/24;
    elseif m == 10
        Dt_Horas = 60/60;
        Dt_Dias = Dt_Horas/24;
    elseif m == 12
        Dt_Horas = 80/60;
        Dt_Dias = Dt_Horas/24;
    elseif m == 14
        Dt_Horas = 90/60;
        Dt_Dias = Dt_Horas/24;
    elseif t > 0.5 && t < 2
        Dt_Dias = 0.5;
    else
        Dt_Dias = 1;
    end
    
    t = t + Dt_Dias;

    %calculo propiedades pvt del petroleo
    [Boi_m, Uoi_m, Kroi_m, SGoi_m, Pcowi_m] = PropiedadesCeldas (P_FVF, ...
        Bo_FVF, Uo_FVF, Poi_m, Kro, Pcow, Swo, Swi_m, ...
        DensidadEspecificaPetroleo);

    [BoL_m, UoL_m, KroL_m] = PropiedadesFronteras(Boi_m, Uoi_m, Kroi_m, ...
        0, Poi_m, nr, nz, false);

    %calculo transmisibilidades de petroleo
    [Tro_m] = TransmisibilidadR(Gri_m, BoL_m, UoL_m, KroL_m);
    [Tzo_m] = TransmisibilidadZ(Gzi_m, BoL_m, UoL_m, KroL_m);

    Pwi_m = Poi_m - Pcowi_m;

    %calculo propiedades pvt del agua
    [Bwi_m, Uwi_m, Krwi_m, SGwi_m, ~] = PropiedadesCeldas (P_FVF, ...
        Bw_FVF, Uw_FVF, Pwi_m, Krw, Pcow, Sww, Swi_m, ...
        DensidadEspecificaSalmuera);
    [BwL_m, UwL_m, KrwL_m] = PropiedadesFronteras(Bwi_m, Uwi_m, Krwi_m, ...
        Krw_Soir, Pwi_m, nr, nz, true);

    %calculo transmisibilidades del agua
    [Trw_m] = TransmisibilidadR(Gri_m, BwL_m, UwL_m, KrwL_m);
    [Tzw_m] = TransmisibilidadZ(Gzi_m, BwL_m, UwL_m, KrwL_m);

%% Suposiciones para m1 = m+1
    iteraciones_SOR = 0;
    Tol_SOR = 0.2;
    DPT = 10;
    
    Poi_m1 = PresionSupuesta(nz, nr, Pwfi, ...
        PresionYacimiento_PSI, PresionYacimiento_PSI);

    [Boi_m1, Uoi_m1, ~, ~, ~] = PropiedadesCeldas (P_FVF, ...
        Bo_FVF, Uo_FVF, Poi_m1, Kro, Pcow, Swo, Swi_m, ...
        DensidadEspecificaPetroleo);

    Pwi_m1 = Poi_m1 - Pcowi_m;

    [Bwi_m1, Uwi_m1, ~, ~, ~] = PropiedadesCeldas (P_FVF, ...
        Bw_FVF, Uw_FVF, Pwi_m1, Krw, Pcow, Sww, Swi_m, ...
        DensidadEspecificaSalmuera);
    
%% Calculos de equaciones

    [Cwpi, Cwsi, Copi, Cosi] = ConstantesRHS(Vbi, Alpha, ...
        Porosidad, Dt_Dias, Swi_m, Bwi_m, Bwi_m1, Boi_m, ...
        Boi_m1, Poi_m, Poi_m1,nr,nz);

    [Tzti, Trti, SGtzi, SGtri, qtsc, Cpsi] = ValoresReducidos (...
        Tzo_m, Tro_m, Tzw_m, Trw_m, 0, 0, Cwpi, Cwsi,...
        Copi, Cosi, SGoi_m, SGwi_m);


    F = CalculoRHS(Poi_m, Cpsi, SGtzi, Z, Cwsi, Trw_m, Tzw_m, Pcowi_m, nr, nz);
    [Ei, Wi, Ui, Li, Ci] = TerminosStencil(Trti, Tzti, Cpsi);

        while (iteraciones_SOR < 200 && max(DPT) > Tol_SOR)       

            iteraciones_SOR = iteraciones_SOR +1;
            A = MatrizDeCoeficientes(Ei, Wi, Ci, Ui, Li, nr, nz);    

            temp = Poi_m1;
            Poi_m1 = SOR(A, temp, F, 1.2, nr, nz);

            for i = 1:nt
                if Poi_m1(i) < Poi_m(i)
                    Poi_m1(i) = Poi_m(i);
                end
            end  

            Swi_m1 = SaturacionDeAgua(Swi_m, Cwsi, Trw_m, Tzw_m, Pcowi_m, ...
            Z, SGwi_m, Cwpi, Poi_m, Poi_m1, nr, nz);
            Swi_CHECK = SaturacionDeAgua(Swi_m, Cwsi, Trw_m, Tzw_m, Pcowi_m, ...
            Z, SGwi_m, Cwpi, Poi_m, Poi_m1, nr, nz);
    
            for k = 1:nz
                for i = 1:nr
                    i_P = (k-1)*nr + i;    
                    if Swi_m1(i_P) > 1 - Soir
                        Swi_m1(i_P) = 1 - Soir;
                    elseif (Swi_m1(i_P) < Swir && Swi_m1(i_P) > 0)
                        Swi_m1(i_P) = Swir;
                    elseif Swi_m1(i_P) < 0
                        Swi_m1(i_P) = 1 - Soir;
                    end            
                end
            end

            [~, ~, ~, ~, Pcowi_m1] = PropiedadesCeldas (P_FVF, ...
                Bo_FVF, Uo_FVF, Poi_m, Kro, Pcow, Swo, Swi_m1, ...
                DensidadEspecificaPetroleo);

            [Boi_m1, ~, ~, ~, ~] = PropiedadesCeldas (P_FVF, ...
                Bo_FVF, Uo_FVF, Poi_m, Kro, Pcow, Swo, Swi_m1, ...
                DensidadEspecificaPetroleo);        

            Pwi_m1 = Poi_m1 - Pcowi_m1;

            [Bwi_m1, ~, ~, ~, ~] = PropiedadesCeldas (P_FVF, ...
                Bw_FVF, Uw_FVF, Pwi_m1, Krw, Pcow, Sww, Swi_m, ...
                DensidadEspecificaSalmuera);

            [Cwpi, Cwsi, Copi, Cosi] = ConstantesRHS(Vbi, Alpha, ...
            Porosidad, Dt_Dias, Swi_m, Bwi_m, Bwi_m1, Boi_m, ...
            Boi_m1, Poi_m, Poi_m1,nr,nz);

            [Tzti, Trti, SGtzi, SGtri, qtsc, Cpsi] = ValoresReducidos (...
                Tzo_m, Tro_m, Tzw_m, Trw_m, 0, 0, Cwpi, Cwsi,...
                Copi, Cosi, SGoi_m, SGwi_m);    

            F = CalculoRHS(Poi_m, Cpsi, SGtzi, Z, Cwsi, Trw_m, Tzw_m, Pcowi_m, nr, nz);
            [Ei, Wi, Ui, Li, Ci] = TerminosStencil(Trti, Tzti, Cpsi);

            DPT = abs(Poi_m1-temp);
        end
    
    Soi_m1 = 1 - Swi_m1;
    Soi_m = 1 - Swi_m;
    
    %% chequeo balance de materiales para el agua

    SumEBM1 = 0;
    SumEBM2_1 = 0;
    SumEBM2_nr = 0;
    for k = 1:nz
        for i = 1:nr
            i_P = (k-1)*nr + i;            
            SumEBM1 = SumEBM1 + Vbi(i_P)*(Swi_m1(i_P)/Bwi_m1(i_P) ...
               - Swi_m(i_P)/Bwi_m(i_P));
            if i == 1
                SumEBM2_1 = SumEBM2_1 ...
                    - Trw_m(i_P,2)*(Pwi_m1(i_P+1)-Pwi_m1(i_P));
            end
            if i == nr
                SumEBM2_nr = SumEBM2_nr ...
                    - Trw_m(i_P,1)*(Pwi_m1(i_P-1)-Pwi_m1(i_P));
            end
        end
    end
    
    SumEBM1 = Porosidad*SumEBM1/(Dt_Dias*Alpha);
    EBMw = SumEBM1/(SumEBM2_1+SumEBM2_nr);
    MatrizTiempo_Caudal = [MatrizTiempo_Caudal; t, SumEBM2_1];
    MatrizTiempo_Filtrado = [MatrizTiempo_Filtrado; t, SumEBM2_1*Dt_Dias];
    
    TolEBMw = 1.1;
    
    if abs(EBMw) > TolEBMw
        disp('fallo chequeo de Balance de materiales del agua');
        display(EBMw)
        %%break
    end
    
    %% chequeo balance de materiales para el petroleo
    SumEBM1 = 0;
    SumEBM2 = 0;   
   
    for k = 1:nz
        for i = 1:nr
            i_P = (k-1)*nr + i;            
            SumEBM1 = SumEBM1 + Vbi(i_P)*(Soi_m1(i_P)/Boi_m1(i_P) ...
               - Soi_m(i_P)/Boi_m(i_P));
            if i == 1 
                SumEBM2 = SumEBM2 ...
                    - Tro_m(i_P,2)*(Poi_m1(i_P+1)-Poi_m1(i_P));
            elseif i == nr
                SumEBM2 = SumEBM2 ...
                    - Tro_m(i_P,1)*(Poi_m1(i_P-1)-Poi_m1(i_P));
            end
              
        end
    end
    
    SumEBM1 = Porosidad*SumEBM1/(Dt_Dias*Alpha);
    EBMo = SumEBM1/(SumEBM2);
    
    TolEBMo = 1.1;
    
    if abs(EBMo) > TolEBMw
        disp('fallo chequeo de Balance de materiales del Petroleo');
        display(EBMo)
        %%break
    end
    
    Poi_m = Poi_m1;
    Swi_m = Swi_m1;
    Swi_m1 = 0;
    Poi_m1 = 0;
    
    MatrizTiempo_Presion = [MatrizTiempo_Presion; t, Poi_m'];
end


