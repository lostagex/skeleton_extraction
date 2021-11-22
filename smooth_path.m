% 9.	Smooth_path.m: smooth the path, the degree of smoothness is 0.1, the number of smoothness is 10, and the smoothing formula is L=1/2*(nextpoint-currentpoint)+1/2*(prepoint-currentpoint)
% Input: load in final_data.txt and final_path.txt
% Output: the data after smoothing is stored in smooth_data.txt

clear
clc
data=load("final_data.txt");
final_path=load("final_path.txt");

[m,n]=size(data);

lambda=0.1;%�⻬�̶�
iter=10;%�⻬����
%��Ĺ⻬
smooth_data=data;
while iter>=0
    pathpoints=[];
    pathpoints=[pathpoints;smooth_data(1,:)];
    for i=2:length(smooth_data)  
        pre_index=final_path(i);%ǰһ����λ��
        prepoint=smooth_data(pre_index,:);
        currentpoint=smooth_data(i,:);
        %���Һ�����
        next_index=find(i==final_path); 
        if length(next_index)>1%��ǰ���Ƿֲ�㣬ֱ���ú����ľ�ֵ����ɵ㶨λ
            temppoints=smooth_data(next_index,:);
            nextpoint=mean(temppoints);            
        elseif isempty(next_index)%��ǰ�����յ�
            nextpoint=currentpoint;            
        else%��ǰ����·���ϵĵ�
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

% %�����ҵ�������·����Ϣ·��
name=[ 'smooth_data.txt'];
eval(['save ' name ' -ascii smooth_data']);


%���Խ��
plot3(data(:,1),data(:,2),data(:,3),'.','MarkerEdgeColor','k','MarkerSize',30);
hold on
plot3(smooth_data(:,1),smooth_data(:,2),smooth_data(:,3),'.','MarkerEdgeColor','r','MarkerSize',30);
hold off

% Created by Xin Li