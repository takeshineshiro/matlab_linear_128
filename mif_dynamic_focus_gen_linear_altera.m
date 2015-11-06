%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%%%%%author by  wong%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%%%email:takeshineshiro@126.com%%%%%%%%%%%%%%%%%%%%%%
     %%%%%%this module  for gen  altera mif file  DynamicFocus %%%%%%
     %%%!attention    this  is  for   linear  element _128%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     clc ;
  
     clear ;
     
     clear all ;
     
    
Pitch      =  0.3;                 % mm;

NUM     =  32;                  % array  Num;

C           =  1.540e-3;        % mm/ns  speed

T        =  0.0003;               % 300us  obeserver period

Ts       =  20e-9;                % 50MHz  fpga_rev_clk


t        =  [-T/2:Ts:T/2];       % samples


focus_width  =  8;              %% width 
    
focus_depth  =  32768;      %% depth


if(rem(NUM,2)==1)            % odd 
    
    taonum  = (NUM-1)/2;
    
    odd       = 1;
    even     = 0;
else                                      % even 
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:1:16384                          % 252.3136 mm              
    
    F = Ts*j*1e9*C/2;                  % F_step 
    
    for i=1:1:16                           % delay fpga_clk  num 
        
        Delay_Interlace(j,i)    =   round(((F^2+(xdis(17-i))^2)^(1/2))/C/Ts/1e9);                                                              %%%  this  is  for  linear   element %%%%
        
        
  %      Delay_Interlace(j,i)= round((sqrt(R*R+(R+F)*(R+F)-2*R*(R+F)*cos(beta*abs(i-(Num+1)/2)))-F)/C/Ts/1e9);      %%this  is  for  convex element
        
                                
    end
end


PACE =zeros(16384,16);

for j=2:1:16384
    
    for i=1:1:16
        
        if(Delay_Interlace(j,i) == Delay_Interlace(j-1,i))  %%   record the changed value position
            
            PACE(j,i) = 1;                                                   %%   flag 
            
        else                                                
            
             PACE(j,i)= 0;           
        end
    end
end


for i=1:1:16
    
    PACE(1,i)= 1;   
end


    fid = fopen('dynamic_focus_linear_128.mif','wt');  
    
    fprintf(fid , 'WIDTH= %d;\n',focus_width); 
    
    fprintf(fid, 'DEPTH= %d;\n',focus_depth);
    
    fprintf(fid, 'ADDRESS_RADIX= UNS;\n');  
    
    fprintf(fid, 'DATA_RADIX=BIN;\n');  
    
    fprintf(fid,'CONTENT BEGIN\n');  
        
    for  i = 1 :focus_depth/2                                                  %%% inner 16 channel 
        
          w_buffer  = [];
          
          sum     =  '';
        
        for j  =  9:1:16
            
                
            
              s_buf  =  num2str(PACE(i,j));
                         
              sum    = [sum,s_buf ];             
       
            
        end  
        
             
        
            fprintf(fid,'%d:%s;\n',i-1,sum);
            
       
    
    end  
    
    
    
      for  i = focus_depth/2+1 :focus_depth                         %%% outside  16 channel 
        
          w_buffer  = [];
          
          sum     =  '';
        
        for j  =  1:1:8
            
                
            
              s_buf  =  num2str(PACE(i-16384,j));
                         
              sum    = [sum,s_buf ];             
       
            
        end  
        
             
        
            fprintf(fid,'%d:%s;\n',i-1,sum);
            
       
    
    end  
    
    
    
    
    
    
    
    fprintf(fid, 'END;');  
    
    fclose(fid);  
    
    
    
    ss = [];

