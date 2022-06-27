clear 
clc;
close all
nodeposition=[500,0];
dn=nodeposition;
noise_density=1e-12;

prompt="Enter your messeage";
x=input(prompt,'s');
y=input('What is the desired BER');
z=input('What are the SF and BW');
dx=input('What is x coordinate of node you take place');
dy=input('What is y coordinate of node you take place');



noise_power=z(2)*noise_density;
noise_power=10*log10(noise_power);
[BER,PER,SER,count] =DecodeOrNot(y,x,z(1),z(2),dx,dy,dn(1),dn(2),noise_power);
% if(BER~=1 && PER~=-1 && SER~=-1)
%     fprintf('You can send the signal %f BER,%f PER,%f SER',BER,PER,SER);
%     
% end
[m,n]=size(BER);
temp1=0;
plot (dn(1),dn(2), 'b.', 'MarkerSize', 20)
   hold on;
   
for x=1:m
    for y=1:n
 
if (BER(x,y)==-1)
    temp1=1;
    break;
end
  
    end
    if(temp1~=1)
     plot (dx(x+count),dy(x+count), 'b.', 'MarkerSize', 20);
    textString = sprintf('(%d, %d)',dx(x+count),dy(x+count));
   text(dx(x+count)-0.3, dy(x+count)+0.1, textString, 'FontSize', 7);
   temp1=0;
    end
    temp1=0;
end


grid on;
% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
