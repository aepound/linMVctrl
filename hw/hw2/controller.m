function out=controller(in,P)
m=P.m;
g=P.g;
l=P.l;
b=P.b;

theta=in(1);
thetadot=in(2);


out=m*l^2*(-g/l*sin(theta) + b/(m*l^2)*thetadot);
