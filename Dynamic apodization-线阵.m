

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%以下测试用，未实际使用


fid=fopen('Dynamic_Apodization.txt','w+');
Wf=zeros(8,1);
Wf(1)=255;
for j=1:1:2048
    %fprintf(fid,'%d  \r\n', j);
    if(Wf(1)<255) 
          Wf(1) = Wf(1) + 2;
    elseif(Wf(2)<255) 
         Wf(2) = Wf(2) + 2;
    elseif(Wf(3)<255) 
         Wf(3) = Wf(3) + 2;
    elseif(Wf(4)<255) 
         Wf(4) = Wf(4) + 2;
    elseif(Wf(5)<255) 
         Wf(5) = Wf(5) + 1;
    elseif(Wf(6)<255) 
         Wf(6) = Wf(6) + 1;
    elseif(Wf(7)<255) 
         Wf(7) = Wf(7) + 1;
    elseif(Wf(8)<255) 
         Wf(8) = Wf(8) + 1;         
    end
    
    
    for i=1:1:8
       tt=Wf(9-i,1);
       if(tt>255) 
           tt=255 ;
       end
       
       fprintf(fid,'%02X',tt);
    end
    fprintf(fid,'\r\n');
end

fclose(fid)
