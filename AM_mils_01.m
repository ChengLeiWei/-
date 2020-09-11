%����ģ�͵�����С���˲������ƣ�AM-mils��
clear all; close all;

a=[1 -1.6 0.8]'; b=[0.4 -0.3]';c=[1 -0.2 0.6]'; d=1; %�������
na=length(a)-1; nb=length(b)-1;nc=length(c)-1; %na��nb��ndΪA��B��D�״�

L=1200; %���泤��
uk=zeros(d+nb,1);        %�����ֵ��uk(i)��ʾu(k-i)
xk=zeros(na,1);          %�м�Ԥ��ֵx��ֵ
wk=zeros(nc,1);          %�м�ֵvԤ���۲�����
ve=zeros(1,1);           %�������Ԥ����ֵ
u=3*randn(L,1);            %������ð���������
xi=sqrt(0.1)*randn(L,1); %����������
v=0.0*ones(nc,1);        %������ֵ    
xx=0.0*ones(na,1);

theta=[a(2:na+1);b;c(2:na+1)]; %���������ֵ
theta_x=[a(2:na+1);b];

p=10;
thetae_1=zeros(na+nb+nc+1,1); %thetae��ֵ
P=10^6*eye(na+nb+nc+1); 
phi=0.0*ones(na+nb+nc+1,p);
Y=0.0*ones(p,1);
thetae=0.0*ones(na+nb+nc+1,L);
Ip=eye(p);
s=0.0*ones(p,p);
se=0.0*ones(p,p);
for k=1:L
    
    h=[-xk;uk(1:nb+1);wk];
    hs=[-xk;uk(1:nb+1)];
    
    for i=p:-1:2
        phi(:,i)=phi(:,i-1);%�������Ϣ�۲����
    end
    phi(:,1)=h;
    
    w(k)=xi(k)+v'*c(2:nc+1);   %�����м�ֵw����(��ֵ)
    x(k)=hs'*theta_x;          %ϵͳ�м�ֵx���У���ֵ��
    y(k)=x(k)+w(k);            %ϵͳ���y(��ֵ)
 
    for i=p:-1:2
        Y(i,1)=Y(i-1,1);
    end
    Y(1,:)=y(k);
   
    %����Ϣ������С���˷�
    s=(Ip+phi'*P*phi);
    se=inv(s);
    K=P*phi*se;
    thetae(:,k)=thetae_1+K*(Y-phi'*thetae_1);
    P=P-P*phi*se*phi'*P;
    xa=hs'*thetae(1:na+nb+1,k);
    ve=y(k)-h'*thetae(:,k);
    
    %��������
    thetae_1=thetae(:,k);
    
    for i=na:-1:2
        xk(i)=xk(i-1);
    end
    xk(1)=xa;
    
    for i=na:-1:2
        xx(i)=xx(i-1);
    end
    xx(1)=x(k);
    
    for i=d+nb:-1:2
        uk(i)=uk(i-1);
    end
    uk(1)=u(k);
    
    for i=nc:-1:2
        wk(i)=wk(i-1);
    end
    wk(1)=ve;
    
    for i=nc:-1:2
        v(i)=v(i-1);
    end
    v(1)=xi(k);
    
end
plot([1:L],thetae); %line([1,L],[theta,theta]);
xlabel('k'); ylabel('AM-MILS��������a��b��d');
legend('a_1','a_2','b_0','b_1','c_1','c_2'); axis([0 L -2 2]);