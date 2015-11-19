
clear;
II=[1:1:4096];

LL=log10(II);

% 4096 for 60dB 240count, 40count/db
% 409~4096 linear 96~255
% 409~30   log  30~128
% 0~430     linear

%Scale = 255/LL(4096);
%LL =round(LL * Scale);


Scale= (96-30)/(LL(409)-LL(30));

LL =round((LL-LL(30)) * Scale)+30;

for i=1:1:30
    LL(i) =round(i);
end


for i=409:1:4096
    LL(i) =round((i-409)/23.04)+95;
end
semilogx(LL)
grid

fid=fopen('log.txt','w+');  


for i=1:1:4096
   fprintf(fid,'%2X\r\n',LL(i));
end

fclose(fid);







%´¿¶ÔÊýÑ¹Ëõ

clear;
II=[1:1:4096];

LL=log10(II);


Scale= 255/(LL(4096)-LL(1));

LL =round((LL-LL(1)) * Scale);

semilogx(LL)
grid

fid=fopen('log.txt','w+'); 

for i=1:1:4096
   fprintf(fid,'%2X\r\n',LL(i));
end

fclose(fid);



