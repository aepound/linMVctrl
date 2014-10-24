function out=trajectory(in,P)
t=in;
a=P.a;
b=P.b;
c=P.c;

w1=P.w1;
w2=P.w2;
w3=P.w3;
n=P.n;
%out=[psi_r dot_psi_r ddot_psi_r];
ytraj=[a*cos(w2*t);b*sin(w1*t);n+c*sin(w3*t);0];
ydottraj=[-a*w2*sin(w2*t);b*w1*cos(w1*t);c*w3*cos(w3*t);0];
yddottraj=[-a*w2*w2*cos(w2*t);-b*w1*w1*cos(w1*t);-c*w3*w3*sin(w3*t);0];

out=[...
    ytraj;...
    ydottraj;...
    yddottraj];