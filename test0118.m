clc,clear all;
close all;
set(0,'defaultfigurecolor','w')
fs=12500;                                       %采样频率
Part_Fre=20*10^6;                              %频率分段的大小
 
load('data0119.mat');
start_point=1;                            %数据的起始点
long=1601;                                    %数据的长度
AA=data0119(start_point:start_point+long-1);            %截取得到的数据

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
        Threshold_Part=min(A_Part)+0.3*Range_Part;
        Wid_Part=100;
    elseif Var_Part<1 || Range_Part<3 || RMS_Part<3
        Threshold_Part=50;
        Wid_Part=100;
    elseif Range_Part>6 && RMS_Part>5
        Threshold_Part=RMS_Part;
        Wid_Part=30;
    elseif Range_Part>3.5 && RMS_Part>5
        Threshold_Part=RMS_Part;
        Wid_Part=400;
    else
        Threshold_Part=RMS_Part;
        Wid_Part=100;
    end
    MyThreshold=[MyThreshold Threshold_Part];
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