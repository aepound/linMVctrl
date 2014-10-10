function [T,X,K,E]=InvertedPendulumLQR(c)

x0=[0.1;0];
g=10;
l=1;
Omega=sqrt(10);

A=[...
    0 1;...
    Omega^2 0];
B=[...
    0;...
    1];
Q=[...
    1 0;...
    0 0];
R=1/c^2;

[K,S,E]=lqr(A,B,Q,R);

options = odeset('RelTol',1e-4,'AbsTol',[1e-4 1e-4]);
%[T Y] = ode45(@(t,y) myode(t,y,ft,f,gt,g),Tspan,IC);
[T,X] = ode45(@(t,x) sys_dy(t,x,c),[0 3],x0',options);

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


function dx=sys_dy(t,x,c)
Omega=sqrt(10);

A=[...
    0 1;...
    Omega^2 0];
B=[...
    0;...
    1];
Q=[...
    1 0;...
    0 0];
R=1/c^2;

[K,S,E]=lqr(A,B,Q,R);
u=-K*x;
dx=A*x+B*u;