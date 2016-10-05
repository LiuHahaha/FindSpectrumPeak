clc,clear all;
close all;
set(0,'defaultfigurecolor','w')
fs=2000;                                       %����Ƶ��
Part_Fre=20*10^6;                              %Ƶ�ʷֶεĴ�С

load('data1130.mat');
start_point=270000;                            %���ݵ���ʼ��
long=10000;                                    %���ݵĳ���
AA=A(start_point:start_point+long-1);            %��ȡ�õ�������
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