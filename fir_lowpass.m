%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%%%%%%%%%%%%author:wong%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%%%%email:takeshineshiro"126.com%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %%%%%%this module for generate quartus coef through matlab%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   load 'lowpass50.txt'

coe  = lowpass50 ;

coe  =  round(coe*65536);


fid         = fopen('low_pass_50.txt','w');

for  i  = 1:length(coe)
    
    fprintf(fid,'%d',coe(i)); 
    
    fprintf(fid,'\r\n');


end

sq = [];