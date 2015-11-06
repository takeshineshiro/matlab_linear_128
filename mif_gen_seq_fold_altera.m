  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%%%%%%%%changed  by wong%%%%%%%%%%%%%%%%%%%%%%%%
     %%%%%%email:takeshineshiro@126.com%%%%%%%%%%%%%%%
     %%%%%%% receive channel overlap%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%%%%%%this module  for gen altera  mif of linear 128 element%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   clc        ;
   
   clear      ;
   
   clear  all ;
   
   fold_width  =  128;              %% width 
    
   fold_depth  =  256;              %% depth

TX=[1,17,33,49,65,81,97,113,
    2,18,34,50,66,82,98,114,
    3,19,35,51,67,83,99,115,
    4,20,36,52,68,84,100,116,
    5,21,37,53,69,85,101,117,
    6,22,38,54,70,86,102,118,
    7,23,39,55,71,87,103,119,
    8,24,40,56,72,88,104,120,
    9,25,41,57,73,89,105,121,
    10,26,42,58,74,90,106,122,
    11,27,43,59,75,91,107,123,
    12,28,44,60,76,92,108,124,
    13,29,45,61,77,93,109,125,
    14,30,46,62,78,94,110,126,
    15,31,47,63,79,95,111,127,
    16,32,48,64,80,96,112,128];


    fid = fopen('seq_fold_linear_128.mif','wt');  
    
    fprintf(fid , 'WIDTH= %d;\n',fold_width); 
    
    fprintf(fid, 'DEPTH= %d;\n',fold_depth);
    
    fprintf(fid, 'ADDRESS_RADIX= UNS;\n');  
    
    fprintf(fid, 'DATA_RADIX=BIN;\n');  
    
    fprintf(fid,'CONTENT BEGIN\n');  

    
% 16 receive channel ;128 scanner lines 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          %%%%%%% inner  16 channels %%%%%%%%%%%%%%%%%%%%%
          %%%%%%%%%%%%%%% 128 scanner lines %%%%%%%%%%%%%%
          %%%%%%among 256 lines even,odd line use the same channel%%%%
          %%%%%%% for  receive %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:1:128                            % 128 scannner lines 
    
    SW_PHY_EVEN = [i:1:i+15]-8;          %  inner  16 channels :begin_end
    
    SEQ        = zeros(16,8);
    
    for j=1:1:16                         %  received  16 channels 
        
       for m=1:1:16                       
           
         for n=1:1:8
             
            if(SW_PHY_EVEN(j)== TX(m,n))  % m for AX;  j for AY  of MT8816
                
                if(j<=8)
                    
                    SEQ(m,j)   =1;        % channel overlap 
                    
                else
                    
                    SEQ(m,17-j)=1;
                    
                end
            end   
        end
       end
    end
    
    
    
    for m=1:1:16
         for n=1:1:8
             fprintf(fid,'%d',SEQ(m,n));      % one scanner  stored 
         end
         
    end
    
    
     fprintf(fid,';\r\n');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          %%%%%%%outside 16 channels%%%%%%%%%%%%%%%%%%%%%%
          %%%%%%%%%%%%%%% 128 scanner lines %%%%%%%%%%%%%%
          %%%%%%among 256 lines even,odd line use the same channel%%%%
          %%%%%%% for  receive %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:1:128                                  % 128  scanner lines
    
    SW_PHY_EVEN=[i-8:1:i-1,i+16:1:i+23]-8;     % outside 16 channels 
    
    SEQ=zeros(16,8);
    
    for j=1:1:16                               % 16 channels  :begin_end
       for m=1:1:16                            
         for n=1:1:8
            if(SW_PHY_EVEN(j)== TX(m,n))       % m for AX;j for AY  of MT8816
                if(j<=8)
                    SEQ(m,j)=1;          
                else
                    SEQ(m,17-j)=1;
                end
            end   
        end
       end
    end
    
    
    for m=1:1:16
        
         for n=1:1:8
             
             fprintf(fid,'%d',SEQ(m,n));
         end
          
    end
    
    
     fprintf(fid,';\r\n');
     
end

fprintf(fid, 'END;');  

  
  fclose(fid);





ss  = [];