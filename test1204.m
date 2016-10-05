% 寻找卫星频段的中心频率
% 12.04

clc,clear all;
close all;
set(0,'defaultfigurecolor','w')
fs=2000;                                       %采样频率
Part_Fre=20*10^6;                              %频率分段的大小

load('data1130.mat');
start_point=1;                            %数据的起始点
long=400000;                                    %数据的长度
AA=A(start_point:start_point+long-1);            %截取得到的数据
LenA=length(AA);
AAA=[];       %均值滤波
AAA=mean5_3(AA,100);

%分段阈值
AAAA=[];                                         %阈值后的数据
Num=Part_Fre/fs;                                 %每一段的点数
Parts=LenA/Num;                                  %分段的个数 
MyThreshold=[];
MyWid=[];
for i=1:Parts
    A_Part=AAA(Num*(i-1)+1:Num*i);
    SUM_part=sum(A_Part);
    RMS_Part=rms(A_Part);                           %均方根
    Var_Part=var(A_Part,1);                         %方差
    Range_Part=max(A_Part)-min(A_Part);             %极差
    
    %确定阈值
    
    if RMS_Part>10
        %Threshold_Part=min(A_Part)+0.3*Range_Part;
        Threshold_Part=RMS_Part-0.15*Range_Part;
        Wid_Part=100;
    elseif Var_Part<1 || Range_Part<3 || RMS_Part<3
        Threshold_Part=50;
        Wid_Part=100;
    elseif Range_Part>6 && RMS_Part>5
        Threshold_Part=RMS_Part-0.1*Range_Part;
        Wid_Part=30;
    elseif Range_Part>3.5 && RMS_Part>5
        Threshold_Part=RMS_Part;
        Wid_Part=400;
    else
        Threshold_Part=RMS_Part;
        Wid_Part=100;
    end
    
%     二叉树阈值，效果不好    
%     if RMS_Part>10
%         Threshold_Part=10;
%         Wid_Part=100;
%     elseif Var_Part<1
%         Threshold_Part=10;
%         Wid_Part=100;
%     elseif RMS_Part>6
%         if Var_Part>10
%             Threshold_Part=5;
%             Wid_Part=10;
%         else
%             Threshold_Part=7;
%             Wid_Part=100;
%         end
%     elseif Var_Part>5
%         Threshold_Part=4.5;
%         Wid_Part=25;    
%     else
%         Threshold_Part=10;
%         Wid_Part=100;
%     end


    
    MyThreshold=[MyThreshold Threshold_Part];
    MyWid=[MyWid Wid_Part];
    
end    

for i=0:Parts-1
    for j=1:Num
        if AAA(i*Num+j)<MyThreshold(i+1)
            AAAA(i*Num+j)=0;
        else
            AAAA(i*Num+j)=25;
        end
    end
end

B=[];      %存放起始点i的值 
C=[];      %存放结束点i的值
L=[];
for i=2:LenA-1
    if AAAA(i-1)==0 && AAAA(i)==25 
        B=[B i];
        L=[L ceil(i/Num)];
    elseif AAAA(i-1)==25 && AAAA(i)==0 
        C=[C i];    
    end
end

M=[];      %中值点
for i=1:length(L)
    Len_Part(i)=MyWid(L(i));
    if C(i)-B(i)>Len_Part(i)
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

figure(2)
plot(AA)
%set(gca,'XTickLabel',{'950','1050','1150','1250','1350','1450','1550','1650','1750'})  
set(gca,'YLim',[0 40]);
hold on
stem(M,Y,'r','linewidth',1);
hold off



