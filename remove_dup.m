% 2.	Remove_dup.m: remove redundant points or spatial close points. (this step is not necessary)
% Input: candidate points in stempoints.txt.
% Output: the three-dimensional coordinates of point XYZ and save them in stempoints_no_dup.txt.
clc
clear

data=load("stempoints.txt");
k=30;
[m,n]=size(data);
Tree=zeros(m,k);
dis=zeros(m,k);

for i=1:m
    ref=data(i,:);
    minus=data-repmat(ref,m,1);
    minus=sqrt(sum(minus.^2,2));
    [value,index]=sort(minus);
    Tree(i,:)=index(1:k)';
    dis(i,:)=value(1:k)';
end

% temp=pointCloud(data);
% pcshow(temp,'MarkerSize',40);

dis_dup=0.01;
index_data=[];
for i=1:m
    index_dup=find(dis(i,2:end)<dis_dup);   
    if length(index_dup)~=0%
        index_data=[index_data;Tree(i,index_dup+1)'];    
    end
end
data(index_data,:)=[];%
data=sortrows(data,3);%
plot3(data(:,1),data(:,2),data(:,3),'.','MarkerEdgeColor',rand(1,3),'MarkerSize',30);

name=[ 'stempoints_no_dup.txt'];
eval(['save ' name ' -ascii data']);


