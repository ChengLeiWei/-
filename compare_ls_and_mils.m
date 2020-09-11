%������С���ˣ�ls�������Ϣ������С���ˣ�mils���������ƱȽ�
clear all; close all;

a=[1 -1.5 0.7]'; b=[1 0.5]'; d=1; %�������
na=length(a)-1; nb=length(b)-1; %na��nbΪA��B�״�

L=400; %���泤��
uk=zeros(d+nb,1); %�����ֵ��uk(i)��ʾu(k-i)
yk=zeros(na,1); %�����ֵ
u=3*randn(L,1); %������ð���������
xi=sqrt(0.1)*randn(L,1); %����������

theta=[a(2:na+1);b]; %���������ֵ

p=10;
thetae_mils1=zeros(na+nb+1,1); %mils�㷨thetae��ֵ
P_mils=10^6*eye(na+nb+1);      %mils�㷨����Э�������P��ֵ
phi=0.0*ones(na+nb+1,p);       %mils�㷨�������Ϣ��ϵͳ��������۲���phi(p,t)
Y=0.0*ones(p,1);               %mils�㷨�������Ϣϵͳ�������y��y,t��
Ip=eye(p);
s=0.0*ones(p,p);
se=0.0*ones(p,p);
for k=1:L
    h=[-yk;uk(1:nb+1)];
    for i=p:-1:2
        phi(:,i)=phi(:,i-1);    %�������Ϣ�۲����
    end
    phi(:,1)=h;
    y(k)=h'*theta+xi(k);        %�ɼ��������
    for i=p:-1:2
        Y(i,1)=Y(i-1,1);
    end
    Y(1,:)=y(k);
   
    %����Ϣ������С���˷���������С���˷�
    s=(Ip+phi'*P_mils*phi);
    se=inv(s);
    K_mils=P_mils*phi*se;
    thetae_mils(:,k)=thetae_mils1+K_mils*(Y-phi'*thetae_mils1);
    P_mils=P_mils-P_mils*phi*se*phi'*P_mils;
    
    %����������
    e_mils1=theta-thetae_mils(:,k);
    e_mils=norm(e_mils1,2)/norm(theta,2);    %tʱ��mils�㷨������ֵ���
    e_m(k)=e_mils;
    
    %��������
    thetae_mils1=thetae_mils(:,k);
    
    for i=d+nb:-1:2
        uk(i)=uk(i-1);
    end
    uk(1)=u(k);
    
    for i=na:-1:2
        yk(i)=yk(i-1);
    end
    yk(1)=y(k);
end
figure;
plot(1:L,thetae_mils); %line([1,L],[theta,theta]);
xlabel('k');ylabel('MILS��������a��b');
legend('a_1','a_2','b_0','b_1'); axis([0 L -2 2]);


uk_ls=zeros(d+nb,1); %�����ֵ��uk(i)��ʾu(k-i)
yk_ls=zeros(na,1); %�����ֵ
u_ls=3*randn(L,1); %������ð���������
xi_ls=sqrt(0.1)*randn(L,1); %����������


thetae_1=zeros(na+nb+1,1); %thetae��ֵ
P=10^6*eye(na+nb+1); 
for k=1:L
    phi_ls=[-yk_ls;uk_ls(d:d+nb)]; %�˴�phiΪ������
    y_ls(k)=phi_ls'*theta+xi_ls(k); %�ɼ��������
   
    %������С���˷�
    K=P*phi_ls/(1+phi_ls'*P*phi_ls);
    thetae(:,k)=thetae_1+K*(y_ls(k)-phi_ls'*thetae_1);
    P=(eye(na+nb+1)-K*phi_ls')*P;
    
    %��������
    thetae_1=thetae(:,k);
    
    for i=d+nb:-1:2
        uk_ls(i)=uk_ls(i-1);
    end
    uk_ls(1)=u_ls(k);
    
    for i=na:-1:2
        yk_ls(i)=yk_ls(i-1);
    end
    yk_ls(1)=y_ls(k);
    
    e_ls1=theta-thetae(:,k);
    e_ls=norm(e_ls1,2)/norm(theta,2);     %tʱ��ls�㷨�����������
    e_l(k)=e_ls;
end

figure;
plot([1:L],thetae);
xlabel('k'); ylabel('LS��������a��b');
legend('a_1','a_2','b_0','b_1'); axis([0 L -2 2]);
figure;
plot([1:L],e_m,'--b',[1:L],e_l,'-r');
legend('e mils','e ls');
axis([0 L 0 0.1]);
