% 6.	Insert_points.m: based on the current path and the optimized points, interpolate and update the path.
% Input: load in optimal_data.txt and path.txt
% Output: interpolated data and path are stored in insert_data.txt and optimal_path.txt

clear
clc
data=load("optimal_data.txt");
path=load("path.txt");
step=0.05;%基的步长，越小，精度越高
x=step;
y=step;
z=step;


printID=[];%已经修正了的点序号
[m,n]=size(data);
%测试结果
plot3(data(:,1),data(:,2),data(:,3),'.','MarkerEdgeColor','k','MarkerSize',30);

hold on
fullpoints=1;%逐一对路径进行优化,从任意一个非根节点出发
printID=[printID,1];%根节点添加入路径
optimal_data=data;%保存优化后的数据,增加的点可以直接放到后面
optimal_path=path;%保存优化后的路径，对于增加的点也需要赋值路径

while fullpoints<=m%判断是否所有点都优化完毕
    endpoints=fullpoints;%从根节点开始
    
    while endpoints~=0
        if length(find(endpoints==printID))~=0%已经绘制过
            break
        else
            printID=[printID,endpoints];
        end      
        curr_data=data(endpoints,:);
        curr_endpoints=endpoints;
        endpoints=path(endpoints);%回溯到上一个点       
        [optimal_data,optimal_path]=insert(optimal_data,optimal_path,curr_endpoints,endpoints,x,y,z);
    end    
    %plot3(optimal_data(1208:end,1),optimal_data(1208:end,2),optimal_data(1208:end,3),'.','MarkerEdgeColor','r','MarkerSize',30);  
    m-fullpoints%还剩下多少个点需要绘制      
    fullpoints=fullpoints+1;
end
hold off

%显示结果
plot3(optimal_data(:,1),optimal_data(:,2),optimal_data(:,3),'.','MarkerEdgeColor','r','MarkerSize',20);
hold off

name=[ 'insert_data.txt'];
eval(['save ' name ' -ascii optimal_data']);%存储修改位置后的点云数据
name=[ 'optimal_path.txt'];
eval(['save ' name ' -ascii optimal_path']);%存储修改位置后的点云数据

%获得优化后的位置信息
function  [optimal_data,optimal_path]=insert(data,path,pre_endpoints,cur_endpoints,x,y,z)
pre=data(pre_endpoints,:);
cur=data(cur_endpoints,:);

optimal_data=data;
optimal_path=path;

direction=pre-cur;
R=direction./[x,y,z];
R0=round(R);
[m,n]=size(optimal_data);
ID=m;%用来标记添加点的序号

while sum(abs(R0))~=0%中间没有数字可以插值了
    
    R0_abs=abs(R0);%当前移动方式的绝对值
    
    move=R0./(R0_abs);%获得移动基元，如（1，1，-1）
    move(isnan(move))=0;
    %开始插值，注意这里默认对角线方式移动最快
    ID=ID+1;
    optimal_path(pre_endpoints)=ID;%替换当前路径
    optimal_path(ID)=cur_endpoints;%替换当前路径
    temp=optimal_data(cur_endpoints,:)+move.*[x,y,z];%前进
    cur_endpoints=ID;%重新赋值当前点位置
    optimal_data=[optimal_data;temp];%插入新的点
    R0=R0-move;%为了简单，每次仅仅移动一步
    
end

end
