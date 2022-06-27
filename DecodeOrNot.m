function [BER,PER,SER,count] =DecodeOrNot(DesiredBer,messeage,SF,BW,dx,dy,a,b,noisepower)

d=sqrt(dx.^2+ dy.^2);
NodeDistance=d;
format longEng
MaxTx=16;
cable_length=0;
hm=5;
hb=100;
antenna_gain=5;
gatewayd=[0,0];
noded=[a,b];
Fs = 10e6 ;
Fc = 921.5 ;
fc = 915 ;
con=0;

distance=sqrt((noded(1)-gatewayd(1))^2+(noded(2)-gatewayd(2))^2);
 [~,control]=FindMinTx_Power(SF,BW,cable_length,fc,antenna_gain,hm,hb,distance);

   [RSSI]=CalculateRecievePower(MaxTx,cable_length,hm,hb,antenna_gain,fc,distance);
   [BER_nCOH_AWGN_Theory,~,~ ]= LoraErrorr(SF,BW,RSSI-noisepower);
    NodeRecPower=RSSI-noisepower;
    if (control==1 && BER_nCOH_AWGN_Theory<=DesiredBer)
     
        
        signalIQ = LoRa_Tx(messeage,BW,SF,MaxTx,Fs,Fc - fc) ;
        
       
     %   disp(['Transmit Power   = ' num2str(Sxx) ' dBm']);
        con=1;
    
    else
        
    %disp (['You cannot send signal from x coordinate ' num2str(noded(1)) 'y coordinate ' num2str(noded(2)) ' node with this transmit Power   = ' num2str(MaxTx) ' dBm' ])
    error(['You cannot send signal from node which has x coordinate ' num2str(noded(1)) ' y coordinate ' num2str(noded(2)) '  with this transmit Power   = ' num2str(MaxTx) ' dBm' ]);
    end

if(con==1)
RSSI_Node=CalculateRecievePower(MaxTx,cable_length,hm,hb,antenna_gain,fc,distance);

TotalRSSI=[];

for i=1:length(NodeDistance)
    [~,control]=FindMinTx_Power(SF,BW,cable_length,fc,antenna_gain,hm,hb,NodeDistance(i));
    if (control==1)
        
        [RSSI]=CalculateRecievePower(MaxTx,cable_length,hm,hb,antenna_gain,fc,NodeDistance(i));
        TotalRSSI(i)=RSSI;
        
        signalIQ = LoRa_Tx(messeage,BW,SF,MaxTx,Fs,Fc - fc) ;
        
       

        
    
    else
        disp (['You cannot send signal from ' num2str(i) ' node with this transmit Power   = ' num2str(MaxTx) ' dBm' ])
    end
end

TotalRSSI1=[TotalRSSI RSSI_Node ];
TotalRSSI1=TotalRSSI1-noisepower;
count=0;

m=length(TotalRSSI1);

for x=m-1:-1:1
    [BER_nCOH_AWGN_Theory,~,~ ]= LoraErrorr(SF,BW,TotalRSSI1(x));
if( BER_nCOH_AWGN_Theory>=DesiredBer)
    disp(['The desired BER: ' num2str(DesiredBer) ' is not obtained from this node which has x coordinate ' num2str(dx(x+count)) ' y coordinate ' num2str(dy(x+count))])
    TotalRSSI1(x)=[];
end
end
m=length(TotalRSSI1);
if(m~=1 ) 
        for x=1:length(TotalRSSI1)-1
           for y=1:length(TotalRSSI1)
            
            signalIQ = LoRa_Tx(messeage,BW,SF,MaxTx,Fs,Fc - fc) ;
        Sxx = 10*log10(rms(signalIQ).^2) ;
       
        

            SINR(x,y)=TotalRSSI1(x)-TotalRSSI1(y);
           end
       
        end
 [m,n]=size(SINR);   
        for x=1:m
            for y=1:n

            if ((SINR(x,y)>=-15 && SINR(x,y)<=-1 ) || (SINR(x,y)>=-15 && SINR(x,y)>2 ))
               BER(x,y)=1;
               SER(x,y)=1;
               PER(x,y)=1;
            
            else
                 BER(x,y)=-1;
               SER(x,y)=-1;
               PER(x,y)=-1;
            end
            end
             
        end
        [m,n]=size(BER);
       for i=1:m
            for y=1:n
                
               if(i==y)
                   BER(i,y)=0;
               end
            end
       end
        
        
  temp2=0;   
        for i=1:m
            for y=1:n
                
                if(BER(i,y)==-1)
                temp2=1;
                break;
                end
   
            end
            if(temp2==1)
                 disp(['Messeage is not decoded if you add the  node'  ' which is x coordinate =  '  num2str(dx(i+count)) ' y coordinate=  ' num2str(dy(i+count)) ]);
            
            temp2=0;
            else
                disp(['You can add   ' ' which has x coordinate =  '  num2str(dx(i+count)) ' y coordinate=  ' num2str(dy(i+count))  ]);
                message_out = LoRa_Rx(signalIQ,BW,SF,2,Fs,Fc - fc) ;
                disp(['Message Received = ' char(message_out)]) 
                
            end
        end
        
       
     
        
     else
         
    
         error('No node available for the desired BER');
end

end
end





