% 4.	Print_path.m: print out all current paths.
% Input: importing final_data.txt and final_path.txt.
% Output: draw results according to your input data.

clear
clc
data=load("final_data.txt");%������������
path=load("final_path.txt");%��������·��

printID=[];%�Ѿ���ӡ�ĵ�

[m,n]=size(data);
%���Խ��
plot3(data(:,1),data(:,2),data(:,3),'.','MarkerEdgeColor','k','MarkerSize',20);

hold on
fullpoints=1;%��ǰ��ӡ������
while fullpoints<=m%�ж��Ƿ����е㶼��ӡ���
    endpoints=fullpoints;%���뵱ǰ��Ҫ���ݵĵ㣬����ʹ�õ�����ߵ㣬ʵ�ʴ�ӡʱ�򣬴Ӹ��ڵ㿪ʼ
    while endpoints~=0
        if length(find(endpoints==printID))~=0%�Ѿ����ƹ�
            
            break
        else
            printID=[printID,endpoints];
        end
        curr=data(endpoints,:);
        plot3(curr(:,1),curr(:,2),curr(:,3),'.','MarkerEdgeColor','r','MarkerSize',30);
        endpoints=path(endpoints);%���ݵ���һ����
        pause(0.01)
    end
 
    m-fullpoints%��ʣ�¶��ٸ�����Ҫ����   
    fullpoints=fullpoints+1;
end
hold off

% Created by Xin Li

