% 寻找卫星频段的中心频率
% 12.04

clc,clear all;
close all;
set(0,'defaultfigurecolor','w')

load('data0119.mat');
start_point=1;                            %数据的起始点
long=1601;                                    %数据的长度
AA=data0119(start_point:start_point+long-1);            %截取得到的数据

LenA=length(AA);
AAA=[];       %均值滤波
AAA=mean5_3(AA,100);

AAAA=[];                                         %阈值后的数据
MyThreshold=[];
MyWid=[];
SUM_part=sum(AAA);
RMS_Part=rms(AAA);                           %均方根
Var_Part=var(AAA,1);                         %方差
Range_Part=max(AAA)-min(AAA);             %极差
    
    %确定阈值
Threshold_Part=RMS_Part-0.15*Range_Part;
Wid_Part=30;
for i=1:LenA-1
        if AAA(i)<Threshold_Part
            AAAA(i)=0;
        else
            AAAA(i)=25;
        end
end

B=[];      %存放起始点i的值 
C=[];      %存放结束点i的值
for i=2:LenA-1
    if AAAA(i-1)==0 && AAAA(i)==25 
        B=[B i];
    elseif AAAA(i-1)==25 && AAAA(i)==0 
        C=[C i];    
    end
end

M=[];      %中值点
for i=1:length(B)
    if C(i)-B(i)>Wid_Part
        Mid=floor((C(i)+B(i))/2);
        M=[M Mid];
    end
end

Num_Mid=length(M);
Y=[];
for i=1:Num_Mid
    Y(i)=50;
end

% figure(1)
% subplot(211)
% plot(AA)
% set(gca,'Ygrid','on');
% subplot(212)
% stairs(AAAA);
% set(gca,'YLim',[0 30]);

% fid = fopen('data1.txt','wt');
% fprintf(fid,'%g\n',AA);
% fclose(fid);

figure(1)
subplot(211)
plot(AA)
%set(gca,'XTickLabel',{'950','1050','1150','1250','1350','1450','1550','1650','1750'})  
set(gca,'YLim',[0 40]);
hold on
stem(M,Y,'r','linewidth',1);
hold off
subplot(212)
stairs(AAAA)
set(gca,'YLim',[0 30]);
set(gca,'XLim',[0 1800]);




