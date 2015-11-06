%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%%%%%%%%changed   by  wong %%%%%%%%%%%%%%%%%%%%%%%
     %%%%%%%email:takeshineshiro"126.com%%%%%%%%%%%%%%%%
     %%%%%%%this function for linear element transmit%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [realtao,tao]= DBFdelay_linear_New(NUM,F,delaystep,Pitch)
%  F        :   focus (mm)    
%  NUM      :   channel    
%  delaystep:   fpga_clk
%  Pitch    :   mm



close all;
  
tao  =  ones(1,NUM);      

c    =  0.00154;                       %   speed  (mm/ns)

  
if(rem(NUM,2)==1)                      %    odd 
    
    taonum  = (NUM-1)/2;
    
    odd     = 1;
    even    = 0;
else                                  %    even 
    taonum = NUM/2;
    odd    = 0;
    even   = 1;
end

R = ones(1,taonum+odd) ; 

if(odd==1)
    R(1)=F;
end

xdis=zeros(1,taonum+odd);

if(odd==1)
    xdis(1)=0;
end

for n=1+odd:taonum+odd
    
    xdis(n)  =  (n-1+even*0.5)*Pitch;
    
    R(n)     =  (F^2+(xdis(n))^2)^(1/2);
end

taohalf      =  ones(1,taonum+odd);

if(odd==1)
    
 taohalf(1)  =  0;
 
end


for k=1+odd:taonum+odd
    if(k==1)
        taohalf(k)  =  (R(k)-F)/c;
    else
        taohalf(k)  =  (R(k)-R(k-1))/c+taohalf(k-1);    %% time 
    end
end


Dis                  = zeros(1,NUM);

Dis(1:taonum+odd)    = fliplr(xdis);                    %%overlap

Dis(taonum+1+odd:NUM)= xdis(1+odd:taonum+odd);


Rn                   = zeros(1,NUM);

Rn(1:taonum+odd)     = fliplr(R);                       %%overlap

Rn(taonum+1+odd:NUM) = R(1+odd:taonum+odd);


tao(1:taonum+odd)    = fliplr(taohalf);                 %%overlap

tao(taonum+1+odd:NUM)= taohalf(1+odd:taonum+odd);

%tao=max(tao)-tao;
figure(1);
plot(tao);
grid on;
hold on;
title('理论延迟值(b)与FPGA延迟值(R)');
% figure;plot(Rn);grid on;


realtao  =  zeros(1,NUM);

error    =  zeros(1,NUM);

for i=1:NUM
    
    realtao(i)   =  delaystep*round(tao(i)/delaystep);
    
    error(i)     =  (tao(i)-realtao(i))*c;
    if(i<=NUM/2)
        
        xerror(i)= -error(i)/Rn(i)*Dis(i);
        
    else
        
        xerror(i)= error(i)/Rn(i)*Dis(i);
        
    end
        yerror(i)= error(i)/Rn(i)*F;
end
   
    plot(realtao,'r');grid on;
    
%   figure; plot(error);grid on;

  figure(2);
  plot(xerror,yerror,'o');
  grid on;
  hold on;
  plot(xerror,yerror,'r');
  
end