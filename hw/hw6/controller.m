function out=controller(in,P)
A=[...
    0 0 1 0;...
    0 0 0 1;...
    0 -P.m*P.g/P.M 0 0;...
    0 (P.M+P.m)*P.g/(P.M*P.l) 0 0];
B=[0;0;1/P.M;-1/(P.M*P.l)];
C=[1 0 0 0;0 1 0 0];
D=[0;0];
sys=ss(A,B,C,D);
Q=zeros(4,4);
Q(1,1)=1;

c=10;
R=1/c^2;
[K,S,E]=lqr(sys,Q,R);
out=-K*in;