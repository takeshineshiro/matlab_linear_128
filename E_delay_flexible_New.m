%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       %%%%%%%%%%%changed  by  wong %%%%%%%%%%%%%
       %%%%%%%email:takeshineshiro"126.com%%%%%%%
       %%%%% fixed focus  transmit %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    clear     ;
    
    clc       ;
    
    clear all ;
    
    Pitch        =  0.3;                % mm
    Focus       =  80;                 % mm
    R           =  60 ;                % mm
    
    num         = 16  ;		           % channel num				
    adjust      = 0   ;         
	F           = Focus + adjust;		
	step        = 10;			       % step_FPGA,100MHz  
    
    
    
   type        = 0;                    %  1:convex  0:linear
   
    if(type == 1)
        fid2=fopen('Emit_delay_convex_New.txt','w+');
    else
        fid2=fopen('Emit_delay_linear_New.txt','w+');
    end


    if(type == 1)
        [realtao_even,tao_even]=DBFdelay_convex_New(num,F,step,Pitch,R);
    else
        [realtao_even,tao_even]=DBFdelay_linear_New(num,F,step,Pitch);
    end
    

    if(type == 1)     
        [realtao_odd,tao_odd]=DBFdelay_convex_New(num-1,F,step,Pitch,R);
    else
	    [realtao_odd,tao_odd]=DBFdelay_linear_New(num-1,F,step,Pitch);
    end

    tao_0 = max(tao_even) - tao_even + min(tao_even);     %%??
    
    tao_1 = max(tao_odd) - tao_odd + min(tao_odd);        %% ??
    
    delay_value_2=[round(tao_0/step)];                   % even scanner line among 256 lines   fpga_clk  delay num 
    
    delay_value_1=[round(tao_1/step),0];                 % odd  scanner line among 256 lines   fpga_clk  delay num 
    



    
    for m=1:1:num
          fprintf(fid2,'%02X',delay_value_2(m));          % even  line  left 15 channels    for transmit           
    end
    
     fprintf(fid2,'\r\n%02X',128);                        %  odd line  right  15 channels   for transmit                    
     
     for m=1:1:num-1
          fprintf(fid2,'%02X',delay_value_1(m));
     end
    
      fprintf(fid2,'\r\n%');
      
 %%%%%%%%%below  are  not used%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%     
      
        for m=1:num*2-1
        if(m<=num)
          fprintf(fid2,'%d\t:\t%d;\r\n',m-1,delay_value_2(m));
        else
          fprintf(fid2,'%d\t:\t%d;\r\n',m-1,delay_value_1(m-num));
        end
        end 
    
    fclose(fid2);
%%%%%%%%%above are  not used%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    
    
    figure(3);
     
    plot(delay_value_1,'b');
    hold on;
    grid on;
    
    plot(delay_value_2,'r');		
    
    
    ss  = [];
