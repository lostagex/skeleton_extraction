% 5.	Optimized_data.m: Optimize current path points based on the current path and modify the data. Optimize the paths one by one and check them one by one.
% Input: importing stempoints_no_dup.txt and path.txt
% Output: store the optimized data in optimal_data.txt.
clear
clc
data=load("stempoints_no_dup.txt");
path=load("path.txt");
step=0.05;
x=step;
y=step;
z=step;

printID=[];
[m,n]=size(data);
%测试结果
plot3(data(:,1),data(:,2),data(:,3),'.','MarkerEdgeColor','k','MarkerSize',30);

hold on
fullpoints=1;%逐一对路径进行优化,从任意一个非根节点出发

optimal_done=zeros(1,m);%标记当前点是否已经优化过
optimal_done(1)=1;%根节点不动
printID=[printID,1];%根节点添加入路径
optimal_data=data;%保存优化后的数据
while fullpoints<=m%判断是否所有点都优化完毕
    endpoints=fullpoints;%从根节点开始
    
    while endpoints~=0
        if length(find(endpoints==printID))~=0%已经绘制过
            
            break
        elseif optimal_done(endpoints)==1%已经优化过，即加入至完成的集合中
            printID=[printID,endpoints];
            break;
        end
        
        curr_data=data(endpoints,:);
        curr_endpoints=endpoints;
        %plot3(curr_data(:,1),curr_data(:,2),curr_data(:,3),'.','MarkerEdgeColor','r','MarkerSize',50);
        endpoints=path(endpoints);%回溯到上一个点
        
        %%%判断当前点是否需要修正
        if  optimal_done(endpoints)==1%当前点已经被优化时候，则可以基于当前位置开始优化其后一个点
            optimal_data(curr_endpoints,:)=calc_loc(x,y,z,optimal_data(endpoints,:),curr_data);
            optimal_done(curr_endpoints)=1;%前一个点优化完毕
            endpoints=fullpoints;%从输入点，重新开始
        end    
        %pause(0.01)
    end
    
    m-fullpoints%还剩下多少个点需要绘制
    fullpoints=fullpoints+1;
end
hold off

%save
name=[ 'optimal_data.txt'];
eval(['save ' name ' -ascii optimal_data']);

function curr_optimal=calc_loc(x,y,z,cur,pre)
direction=pre-cur;
R=direction./[x,y,z];
R0=round(R);
curr_optimal=cur+R0.*[x,y,z];
end






















