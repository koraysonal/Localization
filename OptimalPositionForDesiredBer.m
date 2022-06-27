clc,clear


GatewayPos=[10,10];
noise_density=0.5e-14;
MaxTx=16;
freq=868;
hm=5;
hb=10;
cable_length=0;
antenna_gain=5;

a=input('What is the desired BER');
z=input('What are the   BW');

c=1;
DesiredBer=a;

noise_power=z(2)*noise_density;
noise_power=10*log10(noise_power);
i=1;
j=1;
for SF=7:12

for d=sqrt(GatewayPos(1)^2+GatewayPos(2)^2):1:sqrt(GatewayPos(1)^2+GatewayPos(2)^2)+4000
[~,control]=FindMinTx_Power(SF,z(2),cable_length,freq,antenna_gain,hm,hb,d);
if (control==1)
   Distance(i)=d;
   [RSSI]=CalculateRecievePower(MaxTx,cable_length,hm,hb,antenna_gain,freq,d);
   SNR(i)=RSSI-noise_power;
   
 
  
   if(SNR(i)<=0)
    [BER_COH_AWGN_Theory ,PER_COH_AWGN_Theory , SER_COH_AWGN_Theory]=LoraErrorr(SF,z(2),SNR(i));
    BER(j)=BER_COH_AWGN_Theory;
    RSSI1(j)=RSSI;
    j=j+1;
   end
   i=i+1;
end

end
diff=i-j;
i=1;
j=1;
temp1=0;

for i=1:length(BER)
if(BER(i)>=DesiredBer)
    OptimalDistance=Distance(i+diff);

    temp1=1;
    break;
 
end
end

i=1;
j=1;
diff=0;
if(temp1==1)
   disp(['Maximum distance is  ' num2str(OptimalDistance) '  for this desired BER :' num2str(DesiredBer) '']) 
    
end

temp1=0;


plot(GatewayPos(1),GatewayPos(2));
hold on;
for i=1:360
    Dis(i)=OptimalDistance*exp(1j*deg2rad(i));
plot (real(Dis(i)),imag(Dis(i)), 'b.','MarkerSize',15);
grid on;


end
c=c+1;
end

title(sprintf('END NODE LOCATİON WHEN BER:%f'),DesiredBer);