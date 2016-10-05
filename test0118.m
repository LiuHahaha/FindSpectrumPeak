clc,clear all;
close all;
set(0,'defaultfigurecolor','w')
fs=12500;                                       %����Ƶ��
Part_Fre=20*10^6;                              %Ƶ�ʷֶεĴ�С
 
load('data0119.mat');
start_point=1;                            %���ݵ���ʼ��
long=1601;                                    %���ݵĳ���
AA=data0119(start_point:start_point+long-1);            %��ȡ�õ�������

LenA=length(AA);
AAA=[];       %��ֵ�˲�
AAA=mean5_3(AA,100);

%�ֶ���ֵ
AAAA=[];                                         %��ֵ�������
Num=Part_Fre/fs;                                 %ÿһ�εĵ���
Parts=LenA/Num;                                  %�ֶεĸ��� 
MyThreshold=[];
MyWid=[];
for i=1:Parts
    A_Part=AAA(Num*(i-1)+1:Num*i);
    SUM_part=sum(A_Part);
    RMS_Part=rms(A_Part);                           %������
    Var_Part=var(A_Part,1);                         %����
    Range_Part=max(A_Part)-min(A_Part);             %����
    
    %ȷ����ֵ
    
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