% Ѱ������Ƶ�ε�����Ƶ��
% 12.04

clc,clear all;
close all;
set(0,'defaultfigurecolor','w')

load('data0119.mat');
start_point=1;                            %���ݵ���ʼ��
long=1601;                                    %���ݵĳ���
AA=data0119(start_point:start_point+long-1);            %��ȡ�õ�������

LenA=length(AA);
AAA=[];       %��ֵ�˲�
AAA=mean5_3(AA,100);

AAAA=[];                                         %��ֵ�������
MyThreshold=[];
MyWid=[];
SUM_part=sum(AAA);
RMS_Part=rms(AAA);                           %������
Var_Part=var(AAA,1);                         %����
Range_Part=max(AAA)-min(AAA);             %����
    
    %ȷ����ֵ
Threshold_Part=RMS_Part-0.15*Range_Part;
Wid_Part=30;
for i=1:LenA-1
        if AAA(i)<Threshold_Part
            AAAA(i)=0;
        else
            AAAA(i)=25;
        end
end

B=[];      %�����ʼ��i��ֵ 
C=[];      %��Ž�����i��ֵ
for i=2:LenA-1
    if AAAA(i-1)==0 && AAAA(i)==25 
        B=[B i];
    elseif AAAA(i-1)==25 && AAAA(i)==0 
        C=[C i];    
    end
end

M=[];      %��ֵ��
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




