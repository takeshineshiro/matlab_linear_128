%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%changed by  wong %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%email:takeshineshiro"126.com%%%%%%%%%%%%%%%%%%%%
        %%%%%%%this module for dynamic  convex apodization%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


R           =   60;         %  mm
Pitch       =   0.5;        %  mm;
beta        =   Pitch/R;
Num         =   32;         %  array Num;
Ts          =   20e-9;      %  40MHz 
C           =   1.540e-3;   %  mm/ns

fid         = fopen('Dynamic_Apodization_inner.txt','w+');




W_coff     =  zeros(16384,32);


for(j=1:1:16384)                              %  255.36mm
    
    for(n=1:1:Num)
        
        F        =  Ts*j*1e9*C/2;            %   F_step 
        
        alpha1   =  Pitch*(n-(Num)/2)/R;     
        
        beta1    =  atan(R*sin(alpha1)/(F+R*(1.0-cos(alpha1))));
        
        theta1   =   alpha1+beta1;
        
        if(abs(theta1)<(pi/4))               %   45      paper
            
             W_coff(j,n) = round((0.5+0.5*cos(pi*tan(theta1)))*255);
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








fid=fopen('Dynamic_Apodization_outside.txt','w+');

for i=1:1:8                                 % outside 16 channel
    
       fprintf(fid,'%02X',W_coff(j,i));    
       
end

fclose(fid);


ss  = [];




