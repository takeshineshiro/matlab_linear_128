%%计算延迟量

R=60; %mm
Pitch=0.5; %mm;
beta=Pitch/R;
Num=32;  %  array Num;
Ts=20e-9;  %50MHz
C=1.540e-3;  %mm/ns

fid=fopen('Dynamic_Apodization.txt','w+');


% 奇数行切趾


W_coff =zeros(16384,32);
for(j=1:1:16384)
    for(n=1:1:Num)
        F=Ts*j*1e9*C/2;
        alpha1= Pitch*(n-(Num)/2)/R;
        beta1 =atan(R*sin(alpha1)/(F+R*(1.0-cos(alpha1))));
        theta1=alpha1+beta1;
        if(abs(theta1)<(3.14/4)) % 45°
            W_coff(j,n)=round((0.5+0.5*cos(3.14*tan(theta1)))*255);
        else
             W_coff(j,n)= 0;
        end
    end
end

for j=1:1:2048
    %fprintf(fid,'%d  \r\n', j);
    for i=9:1:16
       fprintf(fid,'%02X',W_coff(j,i));      
    end
    fprintf(fid,'\r\n');
end

fclose(fid);
fid=fopen('Dynamic_Apodization_OUT.txt','w+');
% 输出外周16通道的切趾系数
for i=1:1:8
       fprintf(fid,'%02X',W_coff(j,i));      
end
fclose(fid);




