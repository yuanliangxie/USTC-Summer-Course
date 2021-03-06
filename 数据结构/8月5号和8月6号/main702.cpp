#include<stdio.h>
int main(){
	int a[13][13],b[13],flag=0,i,j,k=0,n=13;
	for(i=1;i<n;i++){                 //采用邻接矩阵存储各个课程的关系 
		for(j=1;j<n;j++){
			scanf("%d",&a[i][j]);
		}
	}
	for(i=1;i<n;i++){                //a[i][0]的数值代表其有多少个前驱，为0则没有前驱，开始初始化为0 
		a[i][0]=0;
		b[i]=0;
	}
	for(i=1;i<n;i++){               //对矩阵进行遍历，确定每个课程的前驱数量 
		for(j=1;j<n;j++){
			if(a[i][j]==1){
				a[j][0]+=1;
			}
		}
	}
	while(k<n-1){                      //k记录输出课程的数目到12则退出循环    
		for(i=1;i<n;i++){
			if(i==1){
					flag++;
					printf("第%d学期应学习的课程为： ",flag);
				}
				
			if(a[i][0]==0){               //依次访问每个课程的前驱数值，若为0，则将该课程名输出 
			    printf("C%d ",i);
			    k++;                      //每输出一次，计数器加一，直到输出第十二个来使while循环结束 
			    for(j=1;j<n;j++){         //每输出一次，将该节点对应的后继节点的前驱减一，此处通过数组b[]来存储每个节点在每次循环后应减少的数目 
			    	if(a[i][j]==1){
			    		b[j]+=1;
					}
				}
				a[i][0]=-1;              //将已输出的课程的前驱置-1，以免再度输出 
			}
			if(i==n-1){                  //每一轮课程输出完毕换行 
				printf("\n");
			}
		}
		for(i=1;i<n;i++){                //每轮输出结束后，才能将各个课程的前驱数目减少 
			a[i][0]=a[i][0]-b[i];
			b[i]=0;
		}
	}  
	return 0;
}
