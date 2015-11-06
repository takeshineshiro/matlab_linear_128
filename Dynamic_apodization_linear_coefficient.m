%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%changed by  wong %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%email:takeshineshiro@126.com%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%this module for dynamic  linear apodization %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
 clc              ;
 clear          ;
 clear  all    ;
Pitch         =   0.3;             %  mm;
NUM        =   32;              %  array Num;
Ts             =   20e-9;         %  50MHz 
C              =   1.540e-3;    %  mm/ns

fid         = fopen('Dynamic_Apodization_linear_inner.txt','w+');


if(rem(NUM,2)==1)         %    odd 
    
    taonum  = (NUM-1)/2   ;
    odd        = 1;
    even      = 0;
else                                 %    even 
    taonum = NUM/2;
    odd       = 0;
    even     = 1;
end

R = ones(1,taonum+odd) ; 

if(odd==1)
    R(1)=F;
end

xdis=zeros(1,taonum+odd);

if(odd==1)
    xdis(1)=0;
end

for n=1+odd:taonum+odd                                    %% genenrate  the  linear  element  distance   x(n)  n  =  1...16%%%
    
    xdis(n)  =  (n-1+even*0.5)*Pitch;    
    
   
end

xx_dis    =   [];

for     i   =  1: NUM                                             %% genenrate   the  linear   overlap  element    distance  xx(n)   n  =  1...32%%%%%
    
       if  ( i <= 16)
           
             xx_dis(i)    =    xdis(17-i)   ;
             
       else
            xx_dis(i)    =    xdis(i-16)   ; 
    
       end 
    
end



W_coff     =  zeros(16384,32);


for(j=1:1:16384)                                   %  255.36mm
    
    for(n=1:1:NUM)
        
        F             =  Ts*j*1e9*C/2;            %   F_step 
        
        theta     =   atan(xx_dis(n)/F);
        
        
        
        if(abs(theta)<(pi/4))                   %   45    paper  define 
            
              W_coff(j,n) = round((0.5+0.5*cos(pi*tan(theta)))*255);            % 255   ??
        else
             W_coff(j,n) = 0;                %  
        end
    end
end


for j=1:1:2048
    
    
    for i=9:1:16                               % inner 16 channel
        
       fprintf(fid,'%02X',W_coff(j,i)); 
       
    end
    
    fprintf(fid,'\r\n');
    
end

fclose(fid);



fid=fopen('Dynamic_Apodization_linear_outside.txt','w+');

for i=1:1:8                                 % outside 16 channel
    
       fprintf(fid,'%02X',W_coff(j,i));    
       
end

fclose(fid);


ss  = [];




