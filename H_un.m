function [Cs,bs,Cr,br,hk,hT0source] = H_un(mh,lh,sh,hkk,HTs,hT0,HTrload,Cp1,mpc)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
%计算hk
Hpipe = mpc.branch(:,1:4);
Hpipe(:,4) = Hpipe(:,4)*1e3;% 换算为mm
Hm = mpc.branch(:,5)';

for i=1:mh
    hk(i)=exp(-hkk*Hpipe(i,3)/(Hm(i)*Cp1));
end
% disp('管道的温度系数：')
% disp(hk);
%%%%%%%%%%%%%%%%%
%%计算Cs,bs的大循环
Cs=zeros(lh,lh);
for x=1:lh %负荷节点大循环
    sss=zeros(1,mh);
    rrr=zeros(1,mh); 
    a=0;
    b=1;
    t=1;
    for i=1:mh
        if Hpipe(i,2)==x
            a=a+1; 
            sss(b)=Hpipe(i,1);%把与i相连的j存入sss
            rrr(b)=i;%把与i相连的支路序号存入rrr
            t=b;
            b=b+1;
        end        
    end
    %如果节点x是第一种类型
    if a==1
        bs(x,1)=hk(rrr(1))*HTs(sss(1)); %%bs是列向量
        Cs(x,x)=1;
    end
    %如果节点x是第二种类型
    if a>1
        for z=1:t
            m=rrr(z);
            bs(x,1)=hk(rrr(t))*Hm(rrr(t))*HTs(sss(t)); %%制定规则，最大的管道放到右边
            Cs(x,x)=Cs(x,x)+Hm(m); %%对角线元素
        end
        for z=1:t-1
            Cs(x,z)=-hk(rrr(z))*Hm(rrr(z));%非对角线元素
        end
    end
end
% disp('Cs:');
% disp(Cs);
% disp('bs:');
% disp(bs);

%%计算负荷节点Cr,br的大循环    
Cr=zeros(lh,lh);
for x=1:lh
%     disp('节点号');
%     disp(x);
    a=0;
    b=1;
    t=1;
    sss=zeros(1,mh);
    rrr=zeros(1,mh);
    for i=1:mh
        if Hpipe(i,1)==x
            a=a+1;
            rrr(b)=i;%把流入i的支路序号存入rrr
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
            sss(c)=i;%把流出i的支路序号存入sss
%             disp(sss);
            w=c;
            c=c+1;
        end
    end
        
    %%类型一：只有一个负荷流回节点x
    if a==0
        br(x,1)=hT0(x);
        Cr(x,x)=1;
    end
    %%类型二：负荷+多条管道流回该节点x
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

%%计算源处回热温度
for x=1:sh
    a=0;
    b=1;
    t=1;
    for i=1:mh
        if Hpipe(i,1)==(lh+x)
            a=a+1;
            mmm(b)=i;%把与源相连的支路号存入mmm
            nnn(b)=Hpipe(i,2);%把与源相连的节点号存入mmm
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
% disp('源处回热温度：')
% disp(hT0source);
HT0=[hT0,hT0source];




    
    
    
    
    
end

