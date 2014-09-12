function out=controller_pp(in,P)
A=[...
    0 0 1 0;...
    0 0 0 1;...
    0 -P.m*P.g/P.M 0 0;...
    0 (P.M+P.m)*P.g/(P.M*P.l) 0 0];

B=[0;0;1/P.M;-1/(P.M*P.l)];


C=[1 0 0 0;0 1 0 0];
D=[0;0];
sys=ss(A,B,C,D);

%% Controallbility Matrix
Con=[B A*B A^2*B A^3*B];
rCon=rank(Con);
syms s real;
charEqo=det(s*eye(4)-A);

a1=0; a2=-108/5; a3=0; a4=0; % coefficients of openloop char equation

ab1=5; ab2=10.5; ab3=11; ab4=5;
Kb=[ab1-a1 ab2-a2 ab3-a3 ab4-a4];
Pinv=Con*[...
          1 0 -108/5 0;...
          0 1 0 -108/5;...
          0 0 1 0;
          0 0 0 1];
      P=Pinv^(-1);
      K=Kb*P;
out=-K*in;