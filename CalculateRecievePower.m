function [RSSI]=CalculateRecievePower(Tx,cable_length,hm,hb,antenna_gain,freq,distance)
%hb : Base station antenna length
%hm : Mobile antenna length(end device)
d=distance/1000;
cable_loss=cable_length*18.2/30.48;
ahm=(1.1*log10(freq)-0.7)*hm -(1.56*log10(freq)-0.8);
path_loss = 69.55 + 26.16*log10(freq) - 13.82*log10(hb)-ahm+ (44.9 - 6.55*log10(hb))*log10(d);

RSSI=Tx-2*cable_loss+2*antenna_gain-path_loss;


end