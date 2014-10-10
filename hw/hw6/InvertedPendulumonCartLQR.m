function [T,X,K,E]=InvertedPendulumonCartLQR(r,P_)

persistent g m M l k R A_ B_ C D P Q
if nargin < 2 && isempty(P)
    % Error:
    error('parameter structure is empty.');
end
x0=[1;0.2;0;0];% y theta ydot thetadot
if nargin == 2
    P = P_;
    g = P.g;
    M = P.M; % cart mass kg
    m = P.m; % pendulum bob weight
    l = P.l; % length of pendulum rod meters
    k = P.k;
    R = P.R;


    A_=[...
        0 0 1 0;...
        0 0 0 1;...
        0 -k^2/(M*R) -m*g/M 0; ...
        0 k/(M*R*l) ((M+m)/(m*l))*g 0];

    B_=[0;0;k/(M*R);-k/(M*R*l)];
    C=[1 0 0 0;0 1 0 0];
    D=[0;0];
    
    
    Q=P.Qmat;
end
A_r = ones(size(A_));
A_r(3,2) = 1./r^2;
A_r(4,2) = 1./r^2;

A = A_.*A_r;

B_r = [1; 1; 1/r; 1/r];

B = B_.*B_r;

Rmat=1/r^2;

[K,S,E]=lqr(A,B,Q,Rmat);

options = odeset('RelTol',1e-4,'AbsTol',[1e-4 1e-4 1e-4 1e-4]);
[T,X] = ode45(@(t,x) sys_dy(t,x,A,B,Q,Rmat),[0 5],x0',options);

end

function dx=sys_dy(t,x,A,B,Q,R)

[K,S,E]=lqr(A,B,Q,R);
u=-K*x;
dx=A*x+B*u;

end