function [Tzti, Trti, SGtzi, SGtri, qtsc, Cpsi] = ValoresReducidos (...
    Tozi, Tori, Twzi, Twri, qwsci, qosci, Cwpi, Cwsi, Copi, Cosi, SGoi, SGwi)

Cpsi = (Copi./Cosi) - (Cwpi./Cwsi);
qtsc = (qosci./Cosi) - (qwsci./Cwsi);

Cwsi = [Cwsi , Cwsi];
Cosi = [Cosi , Cosi];

Tzti = (Tozi./Cosi)-(Twzi./Cwsi);
Trti = (Tori./Cosi)-(Twri./Cwsi);

SGoi = [SGoi, SGoi];
SGwi = [SGwi, SGwi];

SGtzi = SGoi.*(Tozi./Cosi)-SGwi.*(Twzi./Cwsi);
SGtri = SGwi.*(Tori./Cosi)-SGwi.*(Twri./Cwsi);

end