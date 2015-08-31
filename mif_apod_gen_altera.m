%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              %%%%%%author by  wong%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              %%%%%%email:takeshineshiro@126.com%%%%%%%%%%%%%%%%%%%%
              %%%%%%this module  for gen  altera mif file apod%%%%%%
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     clc ;
  
     clear ;
     
     clear all ;
     
     
     
     
 R          =   60;         %  mm
Pitch       =   0.5;        %  mm;
beta        =   Pitch/R;
Num         =   32;         %  array Num;
Ts          =   25e-9;      %  40MHz 
C           =   1.540e-3;   %  mm/ns
    
apod_width  =  64;          %% width 
    
apod_depth  =  2048;        %% depth
   
    
     
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




    
    
    fid = fopen('apod_9272.mif','wt');  
    
    fprintf(fid , 'WIDTH= %d;\n',apod_width); 
    
    fprintf(fid, 'DEPTH= %d;\n',apod_depth);
    
    fprintf(fid, 'ADDRESS_RADIX= UNS;\n');  
    
    fprintf(fid, 'DATA_RADIX=HEX;\n');  
    
    fprintf(fid,'CONTENT BEGIN\n');  
        
    for  i = 1 : apod_depth
        
          w_buffer  = [];
          
          sum     =  '';
        
        for j  =  9:1:16
            
                
            
              s_buf  =  num2str(dec2hex(W_coff(i,j),2));
                         
              sum    = [sum,s_buf ];             
        %    w_buffer =  [w_buffer,W_coff(i,j)];
            
        end  
        
             
        
            fprintf(fid,'%d:%s;\n',i-1,sum);
            
       
        
        
  
    
    end  
    
    
    
    fprintf(fid, 'END;');  
    
    fclose(fid);  
    
    ss  =[];