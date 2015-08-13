%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%%%%%%%%%%%%author:wong%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%%%%email:takeshineshiro"126.com%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%%%%%this module for generate quartus coef through matlab%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load 'bandpass30.txt'

coe  = bandpass30 ;

coe  =  round(coe*65536);


fid         = fopen('band_pass_30.txt','w');

for  i  = 1:length(coe)
    
    fprintf(fid,'%d',coe(i)); 
    
    fprintf(fid,'\r\n');


end

sq = [];