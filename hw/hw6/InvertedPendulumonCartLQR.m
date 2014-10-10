function [T,X,K,E]=InvertedPendulumonCartLQR(c)
x0=[1;0.2;0;0];% y theta ydot thetadot
P.g=9.8;
P.M=1; % cart mass kg
P.m=1/P.g; % pendulum bob weight
P.l=0.5; % length of pendulum rod meters

A=[...
    0 0 1 0;...
    0 0 0 1;...
    0 -P.m*P.g/P.M 0 0;...
    0 (P.M+P.m)*P.g/(P.M*P.l) 0 0];
B=[0;0;1/P.M;-1/(P.M*P.l)];
C=[1 0 0 0;0 1 0 0];
D=[0;0];



Q=zeros(4,4);
Q(1,1)=1;

R=1/c^2;

[K,S,E]=lqr(A,B,Q,R);

options = odeset('RelTol',1e-4,'AbsTol',[1e-4 1e-4 1e-4 1e-4]);
%[T Y] = ode45(@(t,y) myode(t,y,ft,f,gt,g),Tspan,IC);
[T,X] = ode45(@(t,x) sys_dy(t,x,c,P),[0 5],x0',options);

% 
% figure (1)
% plot(E,'o')
% title('Poles vs c')
% xlabel('real')
% ylabel('Img')
% grid on
% hold on
% figure (2)
% plot(T,X(:,1))
% hold on


function dx=sys_dy(t,x,c,P)
A=[...
    0 0 1 0;...
    0 0 0 1;...
    0 -P.m*P.g/P.M 0 0;...
    0 (P.M+P.m)*P.g/(P.M*P.l) 0 0];
B=[0;0;1/P.M;-1/(P.M*P.l)];
C=[1 0 0 0;0 1 0 0];
D=[0;0];



Q=zeros(4,4);
Q(1,1)=1;

R=1/c^2;

[K,S,E]=lqr(A,B,Q,R);
u=-K*x;
dx=A*x+B*u;