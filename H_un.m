function [Cs,bs,Cr,br,hk,hT0source] = H_un(mh,lh,sh,hkk,HTs,hT0,HTrload,Cp1,mpc)
%UNTITLED �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
%����hk
Hpipe = mpc.branch(:,1:4);
Hpipe(:,4) = Hpipe(:,4)*1e3;% ����Ϊmm
Hm = mpc.branch(:,5)';

for i=1:mh
    hk(i)=exp(-hkk*Hpipe(i,3)/(Hm(i)*Cp1));
end
% disp('�ܵ����¶�ϵ����')
% disp(hk);
%%%%%%%%%%%%%%%%%
%%����Cs,bs�Ĵ�ѭ��
Cs=zeros(lh,lh);
for x=1:lh %���ɽڵ��ѭ��
    sss=zeros(1,mh);
    rrr=zeros(1,mh); 
    a=0;
    b=1;
    t=1;
    for i=1:mh
        if Hpipe(i,2)==x
            a=a+1; 
            sss(b)=Hpipe(i,1);%����i������j����sss
            rrr(b)=i;%����i������֧·��Ŵ���rrr
            t=b;
            b=b+1;
        end        
    end
    %����ڵ�x�ǵ�һ������
    if a==1
        bs(x,1)=hk(rrr(1))*HTs(sss(1)); %%bs��������
        Cs(x,x)=1;
    end
    %����ڵ�x�ǵڶ�������
    if a>1
        for z=1:t
            m=rrr(z);
            bs(x,1)=hk(rrr(t))*Hm(rrr(t))*HTs(sss(t)); %%�ƶ��������Ĺܵ��ŵ��ұ�
            Cs(x,x)=Cs(x,x)+Hm(m); %%�Խ���Ԫ��
        end
        for z=1:t-1
            Cs(x,z)=-hk(rrr(z))*Hm(rrr(z));%�ǶԽ���Ԫ��
        end
    end
end
% disp('Cs:');
% disp(Cs);
% disp('bs:');
% disp(bs);

%%���㸺�ɽڵ�Cr,br�Ĵ�ѭ��    
Cr=zeros(lh,lh);
for x=1:lh
%     disp('�ڵ��');
%     disp(x);
    a=0;
    b=1;
    t=1;
    sss=zeros(1,mh);
    rrr=zeros(1,mh);
    for i=1:mh
        if Hpipe(i,1)==x
            a=a+1;
            rrr(b)=i;%������i��֧·��Ŵ���rrr
            ppp(b)=Hpipe(i,2);
%             disp('a');
%             disp(a);
%             disp(rrr);
            t=b;
            b=b+1;
        end
    end
    c=1;
    w=1;
    for i=1:mh
        if Hpipe(i,2)==x
            sss(c)=i;%������i��֧·��Ŵ���sss
%             disp(sss);
            w=c;
            c=c+1;
        end
    end
        
    %%����һ��ֻ��һ���������ؽڵ�x
    if a==0
        br(x,1)=hT0(x);
        Cr(x,x)=1;
    end
    %%���Ͷ�������+�����ܵ����ظýڵ�x
    if a>0
        bt=0;
        cr=0;
        for i=1:t
            bt=bt-Hm(rrr(i));
            Cr(x,ppp(i))=-Hm(rrr(i))*hk(rrr(i));
        end
        for i=1:w
            cr=cr+Hm(sss(i));
        end
        br(x,1)=(cr+bt)*hT0(x);
        Cr(x,x)= cr;
    end        
end
% disp('Cr:');
% disp(Cr);
% disp('br:');
% disp(br);

%%����Դ�������¶�
for x=1:sh
    a=0;
    b=1;
    t=1;
    for i=1:mh
        if Hpipe(i,1)==(lh+x)
            a=a+1;
            mmm(b)=i;%����Դ������֧·�Ŵ���mmm
            nnn(b)=Hpipe(i,2);%����Դ�����Ľڵ�Ŵ���mmm
            t=b;
            b=b+1;
        end
    end
    if a==1
        hT0source(x)=hk(mmm(1))*HTrload(nnn(1));
    end
    if a>1
        fenzi=0;
        fenmu=0;
        for i=1:t
            fenzi=fenzi+hk(mmm(i))*Hm(mmm(i))*HTrload(nnn(i));
            fenmu=fenmu+Hm(mmm(i));
        end
        hT0source(x)=fenzi/fenmu;
    end
end
% disp('Դ�������¶ȣ�')
% disp(hT0source);
HT0=[hT0,hT0source];




    
    
    
    
    
end

