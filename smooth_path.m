% 9.	Smooth_path.m: smooth the path, the degree of smoothness is 0.1, the number of smoothness is 10, and the smoothing formula is L=1/2*(nextpoint-currentpoint)+1/2*(prepoint-currentpoint)
% Input: load in final_data.txt and final_path.txt
% Output: the data after smoothing is stored in smooth_data.txt

clear
clc
data=load("final_data.txt");
final_path=load("final_path.txt");

[m,n]=size(data);

lambda=0.1;%光滑程度
iter=10;%光滑次数
%点的光滑
smooth_data=data;
while iter>=0
    pathpoints=[];
    pathpoints=[pathpoints;smooth_data(1,:)];
    for i=2:length(smooth_data)  
        pre_index=final_path(i);%前一个点位置
        prepoint=smooth_data(pre_index,:);
        currentpoint=smooth_data(i,:);
        %查找后续点
        next_index=find(i==final_path); 
        if length(next_index)>1%当前点是分叉点，直接用后面点的均值来完成点定位
            temppoints=smooth_data(next_index,:);
            nextpoint=mean(temppoints);            
        elseif isempty(next_index)%当前点是终点
            nextpoint=currentpoint;            
        else%当前点是路径上的点
            nextpoint=smooth_data(next_index,:);            
        end
               
        %laplacian smoothing
        temppoint=currentpoint;
        L=1/2*(nextpoint-currentpoint)+1/2*(prepoint-currentpoint);
        temppoint=temppoint+lambda*L;
        pathpoints=[pathpoints;temppoint];
    end
    
    smooth_data=pathpoints;
    iter=iter-1;
end

% %保存找到的所有路径信息路径
name=[ 'smooth_data.txt'];
eval(['save ' name ' -ascii smooth_data']);


%测试结果
plot3(data(:,1),data(:,2),data(:,3),'.','MarkerEdgeColor','k','MarkerSize',30);
hold on
plot3(smooth_data(:,1),smooth_data(:,2),smooth_data(:,3),'.','MarkerEdgeColor','r','MarkerSize',30);
hold off

% Created by Xin Li