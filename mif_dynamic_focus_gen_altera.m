%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%%%%%author by  wong%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%%%email:takeshineshiro@126.com%%%%%%%%%%%%%%%%%%%%%%
     %%%%%%this module  for gen  altera mif file  DynamicFocus %%%%%%
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

     clc ;
  
     clear ;
     
     clear all ;
     
     
     
R        =  60;             % mm

Pitch    =  0.5;            % mm;

beta     =  Pitch/R;        % angle_step

Num      =  32;             % array  Num;

C        =  1.540e-3;       % mm/ns  speed

T        =  0.0003;         % 300us  obeserver period

Ts       =  20e-9;          % 50MHz  fpga_rev_clk


t        =  [-T/2:Ts:T/2];  % samples


focus_width  =  8;          %% width 
    
focus_depth  =  32768;      %% depth


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for j=1:1:16384                        % 252.3136 mm              
    
    F = Ts*j*1e9*C/2;                  % F_step 
    
    for i=1:1:16                       % delay fpga_clk  num 
        
        Delay_Interlace(j,i)= round((sqrt(R*R+(R+F)*(R+F)-2*R*(R+F)*cos(beta*abs(i-(Num+1)/2)))-F)/C/Ts/1e9);
        
                                
    end
end




PACE =zeros(16384,16);

for j=2:1:16384
    
    for i=1:1:16
        
        if(Delay_Interlace(j,i) == Delay_Interlace(j-1,i))  %%   record the changed value position
            
            PACE(j,i) = 1;                                  %%   flag 
            
        else                                                
            
             PACE(j,i)= 0;           
        end
    end
end


for i=1:1:16
    
    PACE(1,i)= 1;   
end


    fid = fopen('dynamic_focus_9272.mif','wt');  
    
    fprintf(fid , 'WIDTH= %d;\n',focus_width); 
    
    fprintf(fid, 'DEPTH= %d;\n',focus_depth);
    
    fprintf(fid, 'ADDRESS_RADIX= UNS;\n');  
    
    fprintf(fid, 'DATA_RADIX=BIN;\n');  
    
    fprintf(fid,'CONTENT BEGIN\n');  
        
    for  i = 1 :focus_depth/2                                     %%% inner 16 channel 
        
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

