%It checks whether the signal can be sent to the desired distance. If it is sent, it finds the minimum transmit power.
%hm:Mobile antenna height
%hb:Base antenna height
%freq: Carrier freq(in MHz)
function [Tx_power,control]=FindMinTx_Power(SF,BW,cable_length,freq,antenna_gain,hm,hb,d)
Max_EIRP=16;
switch SF
    case 7
        SNR_limit=-7.5;
    case 8
        SNR_limit=-10;
    case 9
        SNR_limit=-12.5;
    case 10
        SNR_limit=-15;
    case 11
        SNR_limit=-17.5;
    case 12
        SNR_limit=-20;
end

cable_loss=cable_length*18.2/30.48;
 d=d/1000;   

Sensivity=-174 +10*log10(BW)+6+SNR_limit;
ahm=(1.1*log10(freq)-0.7)*hm -(1.56*log10(freq)-0.8);
path_loss = 69.55 + 26.16*log10(freq) - 13.82*log10(hb)-ahm+ (44.9 - 6.55*log10(hb))*log10(d);
Tx=Sensivity +path_loss -2*antenna_gain+2*cable_loss;
EIRP=Tx-cable_loss+antenna_gain;
%EIRP=path_loss - antenna_gain+cable_loss+Sensivity

if(EIRP<=Max_EIRP)
       Tx_power=Tx;
     % fprintf('Signal can be send with %f Dbm\n',(Tx_power));
       control=1;
 %      Tx_powermw=(10^(Tx_power/10))*(1e-3);
else
  %  Tx_power=Tx;
 %fprintf('Signal cannot be send with %f Dbm\n',(Tx_power));
 control=0;
 Tx_power=-1;
% Tx_powermw=(10^(Tx_power/10))*(1e-3);
end


end