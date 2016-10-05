#include <iostream>
#include <stdlib.h>
#include <fstream>
#include <math.h>

using namespace std;

#define size_data 10000

static int TH = 0;              //阈值
static int Wid = 0;             //最小波段宽度
double step = 2000;             //步进


double rightFre(double* aa,int b);               //向右搜索：参数为数组和数组维度
double leftFre(double* aa,int b);                //向左搜索：参数为数组和数组维度
double* calTH(double* a);                        //计算阈值：参数为数组

void main()
{
	double data1[size_data];           //原始数据 
	ifstream in("data4.txt"); 
	if(!in)
	{
		cout<<"读数据错误\n"<<endl; 
	} 
	for(int i=0;i<size_data-1;i++)
	in>>data1[i]; 
	in.close();

	double nextFre = rightFre(data1,size_data);
	cout<<"下一个谱峰为："<<nextFre<<endl;

	double lastFre = leftFre(data1,size_data);
	cout<<"上一个谱峰为："<<lastFre<<endl;

	system("pause");
}


double rightFre(double* aa,int b)               //向右搜索：参数为数组和数组维度
{
	double* a;     //处理后的数组
	a = calTH(aa);

	int start_point = 0;
	int end_point = 0;
	if (a[b/2] < TH)
	{
		for (int i=b/2;i<b;i++)
		{
			if(a[i-1] < a[i])
			{
				start_point = i;
				for (int j=start_point;j<b;j++)
				{
					if(a[j-1] > a[j])
							{
								end_point = j;
								break;
							}
					if(j == b-2)
					{
						return b/2;
					}
				}
			}

			if(start_point != 0 && end_point != 0)
			{
				if(end_point - start_point > Wid)
					return (start_point+end_point)/2;
			}
			if(i == b-1)
			{
				return b/2;
			}
		}
	}
	else
	{
		for(int i=1;i<b;i++)
		{
			if(a[i-1] < a[i])
			{
				start_point = i;
				for (int j=start_point;j<b;j++)
				{
					if(a[j-1] > a[j])
							{
								end_point = j;
								break;
							}
					if(j == b-2)
					{
						return b/2;
					}
				}

			}
			if(start_point != 0 && end_point != 0)
			{
				if(end_point - start_point > Wid && (start_point+end_point)/2 > b/2)
					return (start_point+end_point)/2;
			}
			if(i == b-1)
			{
				return b/2;
			}
		}
	}
	
}

double leftFre(double* aa,int b)                //向左搜索：参数为数组和数组维度
{
	double* a;     //处理后的数组
	a = calTH(aa);

	int start_point = 0;
	int end_point = 0;
	if (a[b/2] < TH)
	{
		for (int i=b/2;i>0;i--)
		{
			if(a[i-1] > a[i])
			{
				end_point = i;
				for (int j=end_point;j>0;j--)
				{
					if(a[j-1] < a[j])
							{
								start_point = j;
								break;
							}
					if(j == 2)
					{
						return b/2;
					}
				}
			}
			if(start_point != 0 && end_point != 0)
			{
				if(end_point - start_point > Wid)
					return (start_point+end_point)/2;
			}
			if(i == 2)
			{
				return b/2;
			}
		}
	}
	else 
	{
		for(int i=b;i>0;i--)
		{
			if(a[i-1] > a[i])
			{
				end_point = i;
				for (int j=end_point;j>0;j--)
				{
					if(a[j-1] < a[j])
							{
								start_point = j;
								break;
							}
					if(j == 2)
					{
						return b/2;
					}
				}

			}
			if(start_point != 0 && end_point != 0)
			{
				if(end_point - start_point > Wid && (start_point+end_point)/2 < b/2)
					return (start_point+end_point)/2;
			}
			if(i == 1)
			{
				return b/2;
			}
		}
	}
}


double* calTH(double* a)             //计算阈值
{
	double aa[size_data];
	//1、计算均方根值
	double sum2 = 0;
	double ave = 0;
	double rms = 0; 
	for(int i=0;i<size_data-1;i++ )
	{
		sum2+=pow(a[i],2);
	}
	rms = sqrt(sum2/size_data);

	//2、计算方差
	double sum = 0;
	double var = 0;
	for(int i=0;i<size_data-1;i++ )
	{
		sum+=a[i];
	}
	ave = sum/size_data;
	double sum3 = 0;
	for(int i=0;i<size_data-1;i++ )
	{
		sum3+=pow((a[i]-ave),2);
	}
	var = sum3/size_data;

	//3、计算极差
	double max = a[0];
	double min = a[0];
	double range = 0;
	for (int i=1;i<size_data-1;i++) 
	{
		if(max < a[i]) 
			{
				max = a[i];
			}
		if(min > a[i]) 
			{
				min = a[i];
			}
	}
	range = max-min;

	//4、计算阈值
	if(rms > 10)
	{
		TH = min+0.3*range;
		Wid = 1000000 / step;     //设定信号的最小带宽为1M，除以采样频率，得到最少的点数
	}
	else if(var < 1 || range < 3 || rms < 3)
	{
		TH = 50;                //这一段是确定没信号的，所以把阈值设的很大
		Wid = 1000000 / step;
	}
	else if(range > 6 && rms > 5)
	{
		TH = rms;
		Wid = 60000 / step;
	}
	else if(range > 3.5 && rms > 5)
	{
		TH = rms;
		Wid = 800000 / step;
	}
	else 
	{
		TH = rms;
		Wid = 200000 / step;
	}

	for(int i=0;i<size_data-1;i++)
	{
		if(a[i] < TH)
		{
			aa[i] = 0;
		}
		else
		{
			aa[i] = max;
		}
	}
	
	return aa;

}