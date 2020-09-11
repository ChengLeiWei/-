%����Ϣ������С���˲������ƣ�mils��
clear all; close all;

a=[1 -1.5 0.7]'; b=[1 0.5]'; d=1; %�������
na=length(a)-1; nb=length(b)-1; %na��nbΪA��B�״�

L=400; %���泤��
uk=zeros(d+nb,1); %�����ֵ��uk(i)��ʾu(k-i)
yk=zeros(na,1); %�����ֵ
u=3*randn(L,1); %������ð���������
xi=sqrt(0.1)*randn(L,1); %����������

theta=[a(2:na+1);b]; %���������ֵ

p=10;                           %������Ϣά��
thetae_mils1=zeros(na+nb+1,1); %mils�㷨thetae��ֵ
P=10^6*eye(na+nb+1);           %mils�㷨Э�������P��ֵ
phi=0.0*ones(na+nb+1,p);       %mils�㷨�������Ϣ��ϵͳ���������Ϣ��phi
Y=0.0*ones(p,1);               %mils�㷨�������Ϣϵͳ�������
Ip=eye(p);
s=0.0*ones(p,p);
se=0.0*ones(p,p);
for k=1:L
    h=[-yk;uk(1:nb+1)];
    
    for i=p:-1:2
        phi(:,i)=phi(:,i-1);    %�������Ϣ�۲���󣬵�k��ʱ��phi(p,t)��i��Ϊ��һ��ǰһ��ֵ
    end
    phi(:,1)=h;                 %phi(p,t)��1��Ϊϵͳ��Ϣ����h��ֵ

    
    y(k)=h'*theta+xi(k);        %�ɼ�ϵͳ�����ֵ����
    
    for i=p:-1:2
        Y(i,1)=Y(i-1,1);        %�������Ϣϵͳ�������Y��p,t),��k��ʱ��Y(p,t)��i��Ϊ��һ��        
    end                         %��һ�е�ֵ
    Y(1,:)=y(k);                %Y(p,t)��һ��Ϊ��ʱ�̹۲⵽�����y��ֵ
   
    %����Ϣ������С���˷�
    s=(Ip+phi'*P*phi);
    se=inv(s);
    K=P*phi*se;
    thetae(:,k)=thetae_mils1+K*(Y-phi'*thetae_mils1);
    P=P-P*phi*se*phi'*P;
    
    %��������
    thetae_mils1=thetae(:,k);
    
    for i=d+nb:-1:2
        uk(i)=uk(i-1);
    end
    uk(1)=u(k);
    
    for i=na:-1:2
        yk(i)=yk(i-1);
    end
    yk(1)=y(k);
end
plot([1:L],thetae); %line([1,L],[theta,theta]);
xlabel('k'); ylabel('MILS��������a��b');
legend('a_1','a_2','b_0','b_1'); axis([0 L -2 2]);