% 7.	Remove_path.m: delete unnecessary points based on the optimized path (mainly based on the path length, and the judgment method is to calculate the distance from the endpoint to the fork point)
% Input: load in insert_data.txt and optimal_path.txt
% Output: remove short paths and stored data in final_data.txt

clear
clc
data=load("insert_data.txt");
path=load("optimal_path.txt");
step=0.05;%���Ĳ�����ԽС������Խ��
x=step;
y=step;
z=step;

[m,n]=size(data);
%���ڸ��ڵ㣬��������
tempdata=repmat(data(1,:),m,1);
dis=data-tempdata;
loc=int16(dis./[x,y,z]);
plot3(loc(:,1),loc(:,2),loc(:,3),'.','MarkerEdgeColor',rand(1,3),'MarkerSize',30);
%�����õ�������Ϣ
loc=double(loc);
name=[ 'loc.txt'];
eval(['save ' name ' -ascii loc']);%�洢�޸�λ�ú�ĵ�������

%Ѱ�Ҷ˵㣬�ǳ��򵥣��ҵ�ĳ���㣬����㲻��Ϊ��������ݵ���λ��
[p,q]=size(path);
Epoints=[];%�յ�
Bpoints=[];%�ֲ��
for i=1:q
    idx=find(path==i);%�Ե�i����Ϊǰ������
    if length(idx)==0
        %��ǰ��Ϊ�˵�,��Ϊû�е㾭���õ�
        Epoints=[Epoints;i];
    end
    if length(idx)>1
        %��ǰ��Ϊ��辵㣬��Ϊ�ж���㾭���õ�
        Bpoints=[Bpoints;i];
    end
end

%����ÿ���˵㵽�ֲ��ĳ��ȣ��������
for i=1:length(Epoints)
    count=1;%���泤��
    temp=Epoints(i);%�˵�����
    
    while length(find(path(temp)==Bpoints))==0
        count=count+1;%���ȼ�1
        temp=path(temp);%���ݵ�һ����
    end
    Epoints(i,2)=count;
end

% 
% %��ʾ��ǰ�������ݣ���ǰ�Ķ˵㣬��ǰ����辵�
plot3(loc(:,1),loc(:,2),loc(:,3),'.','MarkerEdgeColor',[0,0,0],'MarkerSize',30);
hold on
plot3(loc(Bpoints(:,1),1),loc(Bpoints(:,1),2),loc(Bpoints(:,1),3),'.','MarkerEdgeColor',[0,0,1],'MarkerSize',40);
plot3(loc(Epoints(:,1),1),loc(Epoints(:,1),2),loc(Epoints(:,1),3),'.','MarkerEdgeColor',[1,0,0],'MarkerSize',40);
hold off
% 
% name=[ 'final_data.txt'];
% eval(['save ' name ' -ascii final_data']);%�洢�Ż������������

%ȥ���̵�·�������ȼ��̵�·���Ķ˵�
min_length=10;
index_remove=find(Epoints(:,2)<min_length);
Epoints_refine=Epoints;%��ʵ�Ķ˵�
Epoints_refine(index_remove,:)=[];%����϶�·���Ķ˵�

%��ʾ�϶�·���Ķ˵�
plot3(loc(:,1),loc(:,2),loc(:,3),'.','MarkerEdgeColor',[0,0,0],'MarkerSize',30);
hold on
plot3(loc(Epoints_refine(:,1),1),loc(Epoints_refine(:,1),2),loc(Epoints_refine(:,1),3),'.','MarkerEdgeColor',[0,1,0],'MarkerSize',50);
hold off


final_data=loc;%��������
final_path=path;%����·��
points_index=[];%����������Ҫ�Ƴ���·���ϵĵ�
index_remove=Epoints(index_remove,1);%��Ҫ�Ƴ��Ķ˵�����
%ɾ���̵�·��
for i=1:length(index_remove)   
    temp=index_remove(i);    
    while length(find(temp==Bpoints))==0%��ǰ���Ƿ񵽴�����辵�
        points_index=[points_index;temp];           
%         final_data(temp,:)=final_data(path(temp),:);%���ĵ�ǰ��λ�ã�������ɾ����
%         final_path(temp)=final_path(path(temp));%������ǰ���·������������ϵ��ɾ��
        temp=path(temp);     
    end    
end

points_no_smallbraches=loc;
points_no_smallbraches(points_index,:)=[];
%����ȥ��·��������
plot3(loc(:,1),loc(:,2),loc(:,3),'.','MarkerEdgeColor',[0,0,0],'MarkerSize',20);
hold on
plot3(points_no_smallbraches(:,1),points_no_smallbraches(:,2),points_no_smallbraches(:,3),'.','MarkerEdgeColor',[0,1,0],'MarkerSize',30);
hold off



final_data=points_no_smallbraches.*[x,y,z]+data(1,:);%�һ�ԭʼ����



%��ֹ�����ظ��ĵ㣬�����ɾ��
k=50;%��������
[m,n]=size(final_data);
Tree=zeros(m,k);
dis=zeros(m,k);
%�����ٽ���λ��
for i=1:m
    ref=final_data(i,:);
    minus=final_data-repmat(ref,m,1);
    minus=sqrt(sum(minus.^2,2));
    [value,index]=sort(minus);
    Tree(i,:)=index(1:k)';
    dis(i,:)=value(1:k)';
end
dis_dup=0.01;
%ȥ��������㣨�ظ��㣩
index_data=[];
for i=1:m
    index_dup=find(dis(i,2:end)<dis_dup);  
    if length(index_dup)~=0%�����ظ���
        index_data=[index_data;Tree(i,index_dup+1)'];    
    end
end
final_data(index_data,:)=[];%ȥ��ѡ�еĵ�
final_data=sortrows(final_data,3);%���ո̣߳���������

name=[ 'final_data.txt'];
eval(['save ' name ' -ascii final_data']);%�洢�Ż������������

plot3(final_data(:,1),final_data(:,2),final_data(:,3),'.','MarkerEdgeColor',[0,1,0],'MarkerSize',30);


