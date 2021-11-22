% 6.	Insert_points.m: based on the current path and the optimized points, interpolate and update the path.
% Input: load in optimal_data.txt and path.txt
% Output: interpolated data and path are stored in insert_data.txt and optimal_path.txt

clear
clc
data=load("optimal_data.txt");
path=load("path.txt");
step=0.05;%���Ĳ�����ԽС������Խ��
x=step;
y=step;
z=step;


printID=[];%�Ѿ������˵ĵ����
[m,n]=size(data);
%���Խ��
plot3(data(:,1),data(:,2),data(:,3),'.','MarkerEdgeColor','k','MarkerSize',30);

hold on
fullpoints=1;%��һ��·�������Ż�,������һ���Ǹ��ڵ����
printID=[printID,1];%���ڵ������·��
optimal_data=data;%�����Ż��������,���ӵĵ����ֱ�ӷŵ�����
optimal_path=path;%�����Ż����·�����������ӵĵ�Ҳ��Ҫ��ֵ·��

while fullpoints<=m%�ж��Ƿ����е㶼�Ż����
    endpoints=fullpoints;%�Ӹ��ڵ㿪ʼ
    
    while endpoints~=0
        if length(find(endpoints==printID))~=0%�Ѿ����ƹ�
            break
        else
            printID=[printID,endpoints];
        end      
        curr_data=data(endpoints,:);
        curr_endpoints=endpoints;
        endpoints=path(endpoints);%���ݵ���һ����       
        [optimal_data,optimal_path]=insert(optimal_data,optimal_path,curr_endpoints,endpoints,x,y,z);
    end    
    %plot3(optimal_data(1208:end,1),optimal_data(1208:end,2),optimal_data(1208:end,3),'.','MarkerEdgeColor','r','MarkerSize',30);  
    m-fullpoints%��ʣ�¶��ٸ�����Ҫ����      
    fullpoints=fullpoints+1;
end
hold off

%��ʾ���
plot3(optimal_data(:,1),optimal_data(:,2),optimal_data(:,3),'.','MarkerEdgeColor','r','MarkerSize',20);
hold off

name=[ 'insert_data.txt'];
eval(['save ' name ' -ascii optimal_data']);%�洢�޸�λ�ú�ĵ�������
name=[ 'optimal_path.txt'];
eval(['save ' name ' -ascii optimal_path']);%�洢�޸�λ�ú�ĵ�������

%����Ż����λ����Ϣ
function  [optimal_data,optimal_path]=insert(data,path,pre_endpoints,cur_endpoints,x,y,z)
pre=data(pre_endpoints,:);
cur=data(cur_endpoints,:);

optimal_data=data;
optimal_path=path;

direction=pre-cur;
R=direction./[x,y,z];
R0=round(R);
[m,n]=size(optimal_data);
ID=m;%���������ӵ�����

while sum(abs(R0))~=0%�м�û�����ֿ��Բ�ֵ��
    
    R0_abs=abs(R0);%��ǰ�ƶ���ʽ�ľ���ֵ
    
    move=R0./(R0_abs);%����ƶ���Ԫ���磨1��1��-1��
    move(isnan(move))=0;
    %��ʼ��ֵ��ע������Ĭ�϶Խ��߷�ʽ�ƶ����
    ID=ID+1;
    optimal_path(pre_endpoints)=ID;%�滻��ǰ·��
    optimal_path(ID)=cur_endpoints;%�滻��ǰ·��
    temp=optimal_data(cur_endpoints,:)+move.*[x,y,z];%ǰ��
    cur_endpoints=ID;%���¸�ֵ��ǰ��λ��
    optimal_data=[optimal_data;temp];%�����µĵ�
    R0=R0-move;%Ϊ�˼򵥣�ÿ�ν����ƶ�һ��
    
end

end
