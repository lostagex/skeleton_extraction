% 1.	Stempoint.m: slice processing and Euclidean distance clustering to obtain candidate points
% Input: original data 1.ply files.
% Output: the current tree stem points and we save it in 1_stempoints.txt.

clc
clear
ptCloud = pcread("1.ply");
%pcshow(ptCloud);


data=double(ptCloud.Location);
split=0.1;
distThreshold = 0.1;
threshold=10;
center=[];
cur_center=stempointsExtr(data,3,split,distThreshold,threshold);
center=[center;cur_center];

%rotation
num=6;% number of splits
angle=2*pi/num;

for i=angle:angle:2*pi-0.0001%
    trans=[cos(i),-sin(i),0; sin(i),cos(i),0; 0,0,1];
    rotdata=data(:,1:3)*trans;
    
    %     temp=pointCloud(rotdata(:,1:3));
    %     pcshow(temp,'MarkerSize',40);
    
    cur_center=stempointsExtr(rotdata,1,split,distThreshold,threshold);
    cur_center=cur_center*trans^(-1);
    center=[center;cur_center];
end


%print results
temp=pointCloud(center(:,1:3));
[m,n]=size(center);
color=uint8(ones(m,3).*rand(1,3)*255);
temp.Color=color;
pcshow(temp);

%save
name=[ '1_stempoints.txt'];
eval(['save ' name ' -ascii center']);


function center=stempointsExtr(data,col,split,distThreshold,threshold)
center=[];
data_h=sortrows(data,col);
%plot3(data_h(:,1),data_h(:,2),data_h(:,3),'.','MarkerEdgeColor',rand(1,3),'MarkerSize',5);
location=data_h(:,col);
min=location(1);
max=location(end);


elevation=min;

hold on
while(elevation<max)
    bottom=elevation;
    up=elevation+split;
    
    index=find((location>=bottom) .* (location<up)==1);
    current=data_h(index,:);
    
    %temp=pointCloud(current);
    %[m,n]=size(current);
    %color=uint8(ones(m,3).*rand(1,3)*255);
    %temp.Color=color;
    %pcshow(temp);
    
    [labels,numClusters] = pcsegdist(pointCloud(current(:,1:3)),distThreshold);
    
    groupmask=unique(labels);
    for j=1:size(groupmask)
        indexNN=find(labels==groupmask(j));
        Result=current(indexNN,:);
        if size(Result)<threshold
            continue;
        end
        center=[center;mean(Result,1)];
    end
    
    %temp=pointCloud(center(:,1:3));
    %[m,n]=size(center);
    %color=uint8(ones(m,3).*rand(1,3)*255);
    %temp.Color=color;
    %pcshow(temp,'MarkerSize',40);
    %pause(0.05);
    
    elevation=up;
end
hold off


end


