%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%% changed  by  wong%%%%%%%%%%%%%%%
    %%%%%%%%%%email:takeshineshiro"126.com%%%%%%%
    %%%%%%%this module  for  log %%%%%%%%%%%%%%%%
    %%%%%%% gen  altera mif  for log table%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear         ;
clc           ;
clear  all    ;


log_width  =  8;                 %% width 
    
log_depth  =  4096;              %% depth


fid = fopen('log_linear_128.mif','wt');  
    
fprintf(fid , 'WIDTH= %d;\n',log_width); 
    
fprintf(fid, 'DEPTH= %d;\n',log_depth);
    
fprintf(fid, 'ADDRESS_RADIX= UNS;\n');  
    
fprintf(fid, 'DATA_RADIX=HEX;\n');  
    
fprintf(fid,'CONTENT BEGIN\n');  


II =   [1:1:4096];

LL =    log10(II);

ss =    [];

% 4096      for 60dB 240count, 40count/db
% 409~4096  linear 96~255
% 409~30    log    30~96
% 0~30      linear 0 ~30

% Scale   = 255/LL(4096);
% LL      = round(LL * Scale);



for i=1:1:30                                     %%% for  0-30  linear%%%%
     ss(i) =round(i);
end


Scale_0= (96-30)/(LL(409)-LL(30));

for i =  31:408
ss(i) =round((LL(i)-LL(30)) * Scale_0)+30;        %%%%%for  31-408  log %%%%%
end



k  =  (4096-409)/(255-96);

for i=409:1:4096
    ss(i) =round((i-409)/k)+95;              %%%%for 409-4096  linear %%%  
                                                
end




for i=1:1:4096
   fprintf(fid,'%02X;\r\n',ss(i));
   
end


fprintf(fid, 'END;');  


fclose(fid);





% clear;
% II=[1:1:4096];
% 
% LL=log10(II);
% 
% 
% Scale= 255/(LL(4096)-LL(1));
% 
% LL =round((LL-LL(1)) * Scale);
% 
% semilogx(LL)
% grid
% 
% fid=fopen('log.txt','w+'); 
% 
% for i=1:1:4096
%    fprintf(fid,'%2X\r\n',LL(i));
% end
% 
% fclose(fid);


tt  =  [];