function [As1,Hpipe,Hm] = panduan(mh,Hpipe,As1,Hm)
%����Ts�жϳ�ʼ�����Ƿ���ȷ
a=0;
for i=1:mh
    if Hm(i)<0
        a=a+1;
        %��Hpipe�Ķ�Ӧλ�ý���
        a=Hpipe(i,2);
        Hpipe(i,2)=Hpipe(i,1);
        Hpipe(i,1)=a;
        %��As1�Ķ�Ӧλ�ý���
        b=As1(Hpipe(i,2),i);
        As1(Hpipe(i,2),i)=As1(Hpipe(i,1),i);
        As1(Hpipe(i,1),i)=b;
        %��Hm����
        Hm(i)=-Hm(i);        
    end
end
if a>0
    disp('�ܵ������б䣺');
    disp('�仯���Hpipe');
    disp(Hpipe);
    disp('�仯���As1');
    disp(As1);
    disp('�仯���Hm');
    disp(Hm);
end
   
        
end

