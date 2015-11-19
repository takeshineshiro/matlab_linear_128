    clear;close all ;clc;
    Pitch=0.3;
    Focus=30;
    
    num = 16;						%通道数
    adjust = 0;         %增加的校正是为了校正探头声透镜部分的长度！
	F=Focus + adjust;		%焦点位置
	step=10;			%step受限于FPGA内部的发射计数时钟,100MHz  
    
    
    
    type = 0;						%1:凸阵  0：线阵
    if(type == 1)
        fid2=fopen('Emit_delay_convex_New.txt','w+');
    else
        fid2=fopen('Emit_delay_New.txt','w+');
    end


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

    tao_0 = max(tao_even) - tao_even + min(tao_even);
    tao_1 = max(tao_odd) - tao_odd + min(tao_odd);
    delay_value_2=[round(tao_0/step)]; 
    delay_value_1=[round(tao_1/step),0]; 
    



    %%combine for 128bit words
    for m=1:1:num
          fprintf(fid2,'%02X',delay_value_2(m));
    end
    
     fprintf(fid2,'\r\n%02X',128);
     for m=1:1:num-1
          fprintf(fid2,'%02X',delay_value_1(m));
     end
    
      fprintf(fid2,'\r\n%');
        for m=1:num*2-1
        if(m<=num)
          fprintf(fid2,'%d\t:\t%d;\r\n',m-1,delay_value_2(m));
        else
          fprintf(fid2,'%d\t:\t%d;\r\n',m-1,delay_value_1(m-num));
        end
    end 
    fclose(fid2);
    
    
    
    
    
    plot(delay_value_1);hold on;
    plot(delay_value_2,'r');		
