% 3.	Find_path.m: find the shortest path between two points. 
% Recursively find the location of adjacent points, and record the shortest path to store a point and the previous point. Then judge whether each point has found the shortest path, and compare with each other to get the shortest path. If the current point cannot find the path to the lowest point, the shortest path from the set of found points to the set of not reached points is directly assigned. This is the key step. In the demo, we only calculate the Data term for improving our speed.
% Input: load in stempoints_no_dup.txt or stempoints.txt.
% Output: store all the path information and save them in path.txt.

clear
clc
data=load("stempoints_no_dup.txt");

k=50;%��������
[m,n]=size(data);
Tree=zeros(m,k);
dis=zeros(m,k);
%�����ٽ���λ��
for i=1:m
    ref=data(i,:);
    minus=data-repmat(ref,m,1);
    minus=sqrt(sum(minus.^2,2));
    [value,index]=sort(minus);
    Tree(i,:)=index(1:k)';
    dis(i,:)=value(1:k)';
end

temp=1;%�Ѿ����������
pb=zeros(1,m);%������·���ĵ���Ϊ1����δ�����Ϊ0
d=zeros(1,m);%��Ÿ������̾���
path=zeros(1,m);%��Ÿ������·������һ���ţ���������·��

%��ʼ������
pb(temp)=1;%��ʼ�����Ѿ��ҵ�
k0=3;%��ǰ��������,������ֵԽ��Խ�����ҵ�·��������Ǳ�ڷ����ҵ����������
curr_k=k0;

while sum(pb)<m %�ж�ÿһ���Ƿ����ҵ����·����������е㶼�ҵ��Ļ����ܺ�Ϊm
    
    currsum=m-sum(pb)%������ʾ������ȣ���ʾ��ʣ�¶��ٸ���Ҫ����·��
    
    tb=find(pb==0);%�ҵ���δ�ҵ����·���ĵ�
    fb=find(pb);%�ҳ����ҵ����·���ĵ�
    min=999999;
    
    for i=1:length(fb)%�Ѿ��ҵ����·���ĵ�
        p=fb(i);%��ǰ����������Ϊǰ�õĵ�
        for j=1:length(tb)         
            q=tb(j);%��ǰѰ�����·���ĵ�            
            neighbor_index=Tree(p,1:curr_k);%���������
            index=find(neighbor_index==q);
            if length(index)==0
                %û���ҵ�
                dispoints=999999;
            else
                dispoints=dis(p,index);
            end
            
            plus=d(fb(i))+dispoints;  %�Ƚ���ȷ���ĵ���������δȷ����ľ���      
            if min>plus%ͨ��Ѱ�Ҵ������Ѿ��ҵ�����̵㵽��ǰδ�ҵ�������̵�����·��
                min=plus;
                lastpoint=fb(i);
                newpoint=tb(j);
            end
        end
    end
    
    %����ӵ�ǰ���޷��ҵ�·������͵����
    if min==999999 %û�ҵ�·��      
        %Ѱ���㷨���ҵ���ļ��ϵ�δ�ҵ���ļ��ϵ���̾��룬ֱ�Ӹ�ֵ
        Done_index=find(pb);
        NotDone_index=find(pb==0);
        Done_points=data(Done_index,:);
        NotDone_points=data(NotDone_index,:);     
        for i=1:length(Done_points)
            size(NotDone_points,1)
            tempoints=repmat(Done_points(i,:),size(NotDone_points,1),1);
            minus=(tempoints-NotDone_points);
            minus=sqrt(sum(minus.^2,2));
            [value,index]=sort(minus);              
            if min>value(1)           
                min=value(1);
                lastpoint=Done_index(i);%����Done�ڵĵ�
                newpoint= NotDone_index(index(1));%����NotDone�ڵĵ� 
            end           
        end     
    end
    
    %��ɼ��ϵ��������
    d(newpoint)=min;%�޸ľ����С
    pb(newpoint)=1;%�޸��Ѿ��ҵ��ļ���
    path(newpoint)=lastpoint; %·��������֮ǰ�ĵ�λ��

end


%save results
name=[ 'path.txt'];
eval(['save ' name ' -ascii path']);


%test a path
plot3(data(:,1),data(:,2),data(:,3),'.','MarkerEdgeColor','k','MarkerSize',30);
endpoints=m;
hold on
while endpoints~=0
    curr=data(endpoints,:);
    plot3(curr(:,1),curr(:,2),curr(:,3),'.','MarkerEdgeColor','r','MarkerSize',50);
    endpoints=path(endpoints);
    pause(0.1)
end
hold off

