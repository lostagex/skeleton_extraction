% 4.	Print_path.m: print out all current paths.
% Input: importing final_data.txt and final_path.txt.
% Output: draw results according to your input data.

clear
clc
data=load("final_data.txt");%载入输入数据
path=load("final_path.txt");%载入配套路径

printID=[];%已经打印的点

[m,n]=size(data);
%测试结果
plot3(data(:,1),data(:,2),data(:,3),'.','MarkerEdgeColor','k','MarkerSize',20);

hold on
fullpoints=1;%当前打印点的序号
while fullpoints<=m%判断是否所有点都打印完毕
    endpoints=fullpoints;%输入当前需要回溯的点，测试使用的是最高点，实际打印时候，从根节点开始
    while endpoints~=0
        if length(find(endpoints==printID))~=0%已经绘制过
            
            break
        else
            printID=[printID,endpoints];
        end
        curr=data(endpoints,:);
        plot3(curr(:,1),curr(:,2),curr(:,3),'.','MarkerEdgeColor','r','MarkerSize',30);
        endpoints=path(endpoints);%回溯到上一个点
        pause(0.01)
    end
 
    m-fullpoints%还剩下多少个点需要绘制   
    fullpoints=fullpoints+1;
end
hold off

% Created by Xin Li

