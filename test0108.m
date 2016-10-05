clc,clear all;
close all;
set(0,'defaultfigurecolor','w')
fs=2000;                                       %采样频率
Part_Fre=20*10^6;                              %频率分段的大小

load('data1130.mat');
start_point=270000;                            %数据的起始点
long=10000;                                    %数据的长度
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
    [THR,SORH,KEEPAPP,CRIT]=ddencmp('den','wp',A_Part);
 
    MyThreshold=[MyThreshold THR];
    %MyWid=[MyWid Wid_Part];
    
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

% fid = fopen('data1.txt','wt');
% fprintf(fid,'%g\n',AA);
% fclose(fid);

figure(1)
subplot(211)
plot(AAA)
subplot(212)
stairs(AAAA)