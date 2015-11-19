%%计算延迟量


Pitch=0.3; %mm;

Num=32;  %  array Num;
C=1.540e-3;  %mm/ns

T=0.0003;   %300us
Ts=(1000/50)*1e-9;  %50MHz

DeltaF=0.0154 %mm ,50Mbps sampling rate

t=[-T/2:Ts:T/2];





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%奇偶线是一样的。
for j=1:1:16384
    F=Ts*j*1e9*C/2;
    for i=1:1:16
        %Delay_Interlace(j,i)= round((sqrt(R*R+(R+F)*(R+F)-2*R*(R+F)*cos(beta*abs(i-(Num+1)/2)))-F)/C/Ts/1e9);
        
        Delay_Interlace(j,i) = round((sqrt(F*F+ (i-(Num+1)/2)*Pitch*(i-(Num+1)/2)*Pitch)-F)/C/Ts/1e9);
                                
    end
end



%% 生成停拍表，为1则加1，为零则停拍



PACE =zeros(16384,16);
for j=2:1:16384
    for i=1:1:16
        if(Delay_Interlace(j,i) == Delay_Interlace(j-1,i))  %% 延迟无变化，续拍
            PACE(j,i)= 1;
        else                                                %% 延迟有变化，停拍
             PACE(j,i)= 0;           
        end
    end
end

for i=1:1:16
    PACE(1,i)= 1;   
end


%%%%%生成停拍文件

fid2=fopen('Dynamic_Start_Delay.txt','w+');
fid=fopen('Dynamic_Focus.txt','w+');

%%%%%生成中央16通道停拍文件
for j=1:1:16384
    for i=9:1:16
       fprintf(fid,'%X',PACE(j,i));      
    end
    fprintf(fid,'\r\n');
end

%%%%%生成外周16通道停拍文件
for j=1:1:16384
    for i=1:1:8
       fprintf(fid,'%X',PACE(j,i));      
    end
    fprintf(fid,'\r\n');
end


%%%%%生成奇线15通道起始延迟文件
for i=9:1:16
    fprintf(fid2,'%04X',Delay_Interlace(1,i));   
    
end
fprintf(fid2,'\r\n');

%%%%%生成外周16通道起始延迟文件
for i=1:1:8
    fprintf(fid2,'%04X',Delay_Interlace(1,i));   
    
end
fprintf(fid2,'\r\n');

fclose(fid);
fclose(fid2)


