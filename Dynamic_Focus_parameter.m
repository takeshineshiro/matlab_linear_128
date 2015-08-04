%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %%%%%%%changed  by  wong %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %%%%%email:takeshineshiro"126.com%%%%%%%%%%%%%%%%%%%%%%%%%%%%
         %%%%%this module for receiver channel delay initial value%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


R        =  60;             % mm

Pitch    =  0.5;            % mm;

beta     =  Pitch/R;        % angle_step

Num      =  32;             % array  Num;

C        =  1.540e-3;       % mm/ns  speed

T        =  0.0003;         % 300us  obeserver period

Ts       =  20e-9;          %  50MHz  fpga_rev_clk


t        =  [-T/2:Ts:T/2];  % samples





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


%%%%%%%%%%%%%%%%%%%%%%%%

fid2  =  fopen('Dynamic_Start_Delay.txt','w+');      %  delay initial value         

fid   =  fopen('Dynamic_Focus.txt','w+');            %  value changed flag

%%%%%%%%%%%%%%%%%%%%%%%%%%

for j=1:1:16384
    
    for i=9:1:16                                     %  inner  16 channel
        
       fprintf(fid,'%X',PACE(j,i));                  %  flag          
       
    end
    
    fprintf(fid,'\r\n');
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%
for j=1:1:16384
    
    for i=1:1:8                                     %  outside 16 channel           
        
       fprintf(fid,'%X',PACE(j,i));                 %  flag   
    end
    fprintf(fid,'\r\n');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=9:1:16                                       %  inner  16 channel 
    
    fprintf(fid2,'%04X',Delay_Interlace(1,i));     %  initial  delay value
    
end

fprintf(fid2,'\r\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:1:8                                       %  outside  16 channel 
    
    fprintf(fid2,'%04X',Delay_Interlace(1,i));    %  initial  delay value 
    
end

fprintf(fid2,'\r\n');


fclose(fid);

fclose(fid2)

ss  = [];
