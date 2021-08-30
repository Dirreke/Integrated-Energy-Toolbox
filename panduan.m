function [As1,Hpipe,Hm] = panduan(mh,Hpipe,As1,Hm)
%根据Ts判断初始方向是否正确
a=0;
for i=1:mh
    if Hm(i)<0
        a=a+1;
        %把Hpipe的对应位置交换
        a=Hpipe(i,2);
        Hpipe(i,2)=Hpipe(i,1);
        Hpipe(i,1)=a;
        %把As1的对应位置交换
        b=As1(Hpipe(i,2),i);
        As1(Hpipe(i,2),i)=As1(Hpipe(i,1),i);
        As1(Hpipe(i,1),i)=b;
        %把Hm变正
        Hm(i)=-Hm(i);        
    end
end
if a>0
    disp('管道流量有变：');
    disp('变化后的Hpipe');
    disp(Hpipe);
    disp('变化后的As1');
    disp(As1);
    disp('变化后的Hm');
    disp(Hm);
end
   
        
end

