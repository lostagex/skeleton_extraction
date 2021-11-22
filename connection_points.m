% 8.	Connection_points.m: analyze the path of the interpolated data again to generate skeleton.
% Input: load in final_data.txt
% Output: final_path.txt

clear
clc
data=load("final_data.txt");

k=50;%邻域点个数
[m,n]=size(data);
Tree=zeros(m,k);
dis=zeros(m,k);
%计算临近点位置
for i=1:m
    ref=data(i,:);
    minus=data-repmat(ref,m,1);
    minus=sqrt(sum(minus.^2,2));
    [value,index]=sort(minus);
    Tree(i,:)=index(1:k)';
    dis(i,:)=value(1:k)';
end

%%%%进行路径寻找
temp=1;%已经升序排序过
pb=zeros(1,m);%求出最短路径的点标记为1，尚未求出的为0
d=zeros(1,m);%存放各点的最短距离
path=zeros(1,m);%存放各点最短路径的上一点标号，用来回溯路径

%初始化参数
pb(temp)=1;%初始化点已经找到
k0=3;%当前邻域点个数,设置数值越大，越容易找到路径，但是潜在风险找到其他树杈上
curr_k=k0;

while sum(pb)<m %判断每一点是否都已找到最短路径，如果所有点都找到的话，总和为m
    
    currsum=m-sum(pb)%用来显示计算进度；显示还剩下多少个点要计算路径
    
    tb=find(pb==0);%找到还未找到最短路径的点
    fb=find(pb);%找出已找到最短路径的点
    min=999999;
    
    for i=1:length(fb)%已经找到最短路径的点
        p=fb(i);%当前将被考虑作为前置的点
        for j=1:length(tb)         
            q=tb(j);%当前寻找最短路径的点            
            neighbor_index=Tree(p,1:curr_k);%查找邻域点
            index=find(neighbor_index==q);
            if length(index)==0
                %没有找到
                dispoints=999999;
            else
                dispoints=dis(p,index);
            end
            
            plus=d(fb(i))+dispoints;  %比较已确定的点与其相邻未确定点的距离      
            if min>plus%通过寻找从所有已经找到的最短点到当前未找到过的最短点的最短路径
                min=plus;
                lastpoint=fb(i);
                newpoint=tb(j);
            end
        end
    end
    
    %处理从当前点无法找到路径至最低点情况
    if min==999999 %没找到路径      
        %寻找算法从找到点的集合到未找到点的集合的最短距离，直接赋值
        Done_index=find(pb);
        NotDone_index=find(pb==0);
        Done_points=data(Done_index,:);
        NotDone_points=data(NotDone_index,:);     
        for i=1:length(Done_points)
            tempoints=repmat(Done_points(i,:),size(NotDone_points,1),1);
            minus=(tempoints-NotDone_points);
            minus=sqrt(sum(minus.^2,2));
            [value,index]=sort(minus);              
            if min>value(1)           
                min=value(1);
                lastpoint=Done_index(i);%保存Done内的点
                newpoint= NotDone_index(index(1));%保存NotDone内的点 
            end           
        end     
    end
    
    %完成集合的扩充操作
    d(newpoint)=min;%修改距离大小
    pb(newpoint)=1;%修改已经找到的集合
    path(newpoint)=lastpoint; %路径保存了之前的点位置

end

% save
name=[ 'final_path.txt'];%对应最终数据的路径
eval(['save ' name ' -ascii path']);

%test
plot3(data(:,1),data(:,2),data(:,3),'.','MarkerEdgeColor','k','MarkerSize',30);
endpoints=m;%输入当前需要回溯的点，测试使用的是最高点
hold on
while endpoints~=0
    curr=data(endpoints,:);
    plot3(curr(:,1),curr(:,2),curr(:,3),'.','MarkerEdgeColor','r','MarkerSize',50);
    endpoints=path(endpoints);%回溯到上一个点
    pause(0.1)
end
hold off



