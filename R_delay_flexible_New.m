    clear;close all ;clc;
    Pitch=0.78;
    Focus=70;
    R=60;
    
    num = 16;						%通道数
    adjust = 0;         %增加的校正是为了校正探头声透镜部分的长度！
	F=Focus + adjust;		%焦点位置
	step=20;			%AD 采样,50MHz  
    
    

    type = 1;				%  0：线阵探头   1：凸阵探头
    if(type == 1)
        fid2=fopen('R_delay_convex_New.txt','w+');
    else
        fid2=fopen('R_delay_New.txt','w+');
    end

		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%;

    if(type == 1)
        [realtao,tao_even]=DBFdelay_convex_New(num,F,step,Pitch,R);
    else
        [realtao,tao_even]=DBFdelay_New(num,F,step,Pitch);
    end

    if(type == 1)     
        [realtao,tao_odd]=DBFdelay_convex_New(num-1,F,step,Pitch,R);
    else
	    [realtao,tao_odd]=DBFdelay_New(num-1,F,step,Pitch);
    end

    
    tao_0 =tao_even-min(tao_even); 
    tao_1 = tao_odd- min(tao_odd);
    
    %shouldn't x 2
   % delay_value_2=[round(tao_0*2/step)]; 
   % delay_value_1=[round(tao_1*2/step),0]; 

    delay_value_2=[round(tao_0/step)]; 
    delay_value_1=[round(tao_1/step),0]; 

    %%combine for 64bit words
    for m=1:1:num/2
          fprintf(fid2,'%02X',delay_value_2(m));
    end
    
     fprintf(fid2,'\r\n');
     for m=1:1:(num+1)/2
          fprintf(fid2,'%02X',delay_value_1(m));
     end
    
    fclose(fid2);
    