% 7.	Remove_path.m: delete unnecessary points based on the optimized path (mainly based on the path length, and the judgment method is to calculate the distance from the endpoint to the fork point)
% Input: load in insert_data.txt and optimal_path.txt
% Output: remove short paths and stored data in final_data.txt

clear
clc
data=load("insert_data.txt");
path=load("optimal_path.txt");
step=0.05;%基的步长，越小，精度越高
x=step;
y=step;
z=step;

[m,n]=size(data);
%基于根节点，计算坐标
tempdata=repmat(data(1,:),m,1);
dis=data-tempdata;
loc=int16(dis./[x,y,z]);
plot3(loc(:,1),loc(:,2),loc(:,3),'.','MarkerEdgeColor',rand(1,3),'MarkerSize',30);
%保存获得的坐标信息
loc=double(loc);
name=[ 'loc.txt'];
eval(['save ' name ' -ascii loc']);%存储修改位置后的点云数据

%寻找端点，非常简单，找到某个点，这个点不作为其他点回溯到的位置
[p,q]=size(path);
Epoints=[];%终点
Bpoints=[];%分叉点
for i=1:q
    idx=find(path==i);%以第i个点为前点的序号
    if length(idx)==0
        %当前点为端点,因为没有点经过该点
        Epoints=[Epoints;i];
    end
    if length(idx)>1
        %当前点为树杈点，因为有多个点经过该点
        Bpoints=[Bpoints;i];
    end
end

%计算每个端点到分叉点的长度（点个数）
for i=1:length(Epoints)
    count=1;%保存长度
    temp=Epoints(i);%端点的序号
    
    while length(find(path(temp)==Bpoints))==0
        count=count+1;%长度加1
        temp=path(temp);%回溯到一个点
    end
    Epoints(i,2)=count;
end

% 
% %显示当前输入数据，当前的端点，当前的树杈点
plot3(loc(:,1),loc(:,2),loc(:,3),'.','MarkerEdgeColor',[0,0,0],'MarkerSize',30);
hold on
plot3(loc(Bpoints(:,1),1),loc(Bpoints(:,1),2),loc(Bpoints(:,1),3),'.','MarkerEdgeColor',[0,0,1],'MarkerSize',40);
plot3(loc(Epoints(:,1),1),loc(Epoints(:,1),2),loc(Epoints(:,1),3),'.','MarkerEdgeColor',[1,0,0],'MarkerSize',40);
hold off
% 
% name=[ 'final_data.txt'];
% eval(['save ' name ' -ascii final_data']);%存储优化后的最终数据

%去除短的路径，首先检测短的路径的端点
min_length=10;
index_remove=find(Epoints(:,2)<min_length);
Epoints_refine=Epoints;%真实的端点
Epoints_refine(index_remove,:)=[];%保存较短路径的端点

%显示较短路径的端点
plot3(loc(:,1),loc(:,2),loc(:,3),'.','MarkerEdgeColor',[0,0,0],'MarkerSize',30);
hold on
plot3(loc(Epoints_refine(:,1),1),loc(Epoints_refine(:,1),2),loc(Epoints_refine(:,1),3),'.','MarkerEdgeColor',[0,1,0],'MarkerSize',50);
hold off


final_data=loc;%最终数据
final_path=path;%最终路径
points_index=[];%用来保存需要移除的路径上的点
index_remove=Epoints(index_remove,1);%需要移除的端点索引
%删除短的路径
for i=1:length(index_remove)   
    temp=index_remove(i);    
    while length(find(temp==Bpoints))==0%当前点是否到达了树杈点
        points_index=[points_index;temp];           
%         final_data(temp,:)=final_data(path(temp),:);%更改当前点位置，本质是删除掉
%         final_path(temp)=final_path(path(temp));%更爱当前点的路径，本质是配合点的删除
        temp=path(temp);     
    end    
end

points_no_smallbraches=loc;
points_no_smallbraches(points_index,:)=[];
%绘制去除路径后的情况
plot3(loc(:,1),loc(:,2),loc(:,3),'.','MarkerEdgeColor',[0,0,0],'MarkerSize',20);
hold on
plot3(points_no_smallbraches(:,1),points_no_smallbraches(:,2),points_no_smallbraches(:,3),'.','MarkerEdgeColor',[0,1,0],'MarkerSize',30);
hold off



final_data=points_no_smallbraches.*[x,y,z]+data(1,:);%找回原始数据



%防止出现重复的点，因此需删除
k=50;%邻域点个数
[m,n]=size(final_data);
Tree=zeros(m,k);
dis=zeros(m,k);
%计算临近点位置
for i=1:m
    ref=final_data(i,:);
    minus=final_data-repmat(ref,m,1);
    minus=sqrt(sum(minus.^2,2));
    [value,index]=sort(minus);
    Tree(i,:)=index(1:k)';
    dis(i,:)=value(1:k)';
end
dis_dup=0.01;
%去除近距离点（重复点）
index_data=[];
for i=1:m
    index_dup=find(dis(i,2:end)<dis_dup);  
    if length(index_dup)~=0%出现重复点
        index_data=[index_data;Tree(i,index_dup+1)'];    
    end
end
final_data(index_data,:)=[];%去除选中的点
final_data=sortrows(final_data,3);%按照高程，升序排列

name=[ 'final_data.txt'];
eval(['save ' name ' -ascii final_data']);%存储优化后的最终数据

plot3(final_data(:,1),final_data(:,2),final_data(:,3),'.','MarkerEdgeColor',[0,1,0],'MarkerSize',30);


