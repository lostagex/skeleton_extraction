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
%���Խ��
plot3(data(:,1),data(:,2),data(:,3),'.','MarkerEdgeColor','k','MarkerSize',30);

hold on
fullpoints=1;%��һ��·�������Ż�,������һ���Ǹ��ڵ����

optimal_done=zeros(1,m);%��ǵ�ǰ���Ƿ��Ѿ��Ż���
optimal_done(1)=1;%���ڵ㲻��
printID=[printID,1];%���ڵ������·��
optimal_data=data;%�����Ż��������
while fullpoints<=m%�ж��Ƿ����е㶼�Ż����
    endpoints=fullpoints;%�Ӹ��ڵ㿪ʼ
    
    while endpoints~=0
        if length(find(endpoints==printID))~=0%�Ѿ����ƹ�
            
            break
        elseif optimal_done(endpoints)==1%�Ѿ��Ż���������������ɵļ�����
            printID=[printID,endpoints];
            break;
        end
        
        curr_data=data(endpoints,:);
        curr_endpoints=endpoints;
        %plot3(curr_data(:,1),curr_data(:,2),curr_data(:,3),'.','MarkerEdgeColor','r','MarkerSize',50);
        endpoints=path(endpoints);%���ݵ���һ����
        
        %%%�жϵ�ǰ���Ƿ���Ҫ����
        if  optimal_done(endpoints)==1%��ǰ���Ѿ����Ż�ʱ������Ի��ڵ�ǰλ�ÿ�ʼ�Ż����һ����
            optimal_data(curr_endpoints,:)=calc_loc(x,y,z,optimal_data(endpoints,:),curr_data);
            optimal_done(curr_endpoints)=1;%ǰһ�����Ż����
            endpoints=fullpoints;%������㣬���¿�ʼ
        end    
        %pause(0.01)
    end
    
    m-fullpoints%��ʣ�¶��ٸ�����Ҫ����
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






















