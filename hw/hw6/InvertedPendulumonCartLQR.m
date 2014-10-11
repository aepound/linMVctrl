function [T,X,K,E]=InvertedPendulumonCartLQR(r,P_)

persistent g m M l k R A B C D P Q
if nargin < 2 && isempty(P)
    % Error:
    error('parameter structure is empty.');
end
x0=[1;0.2;0;0];% y theta ydot thetadot
if nargin == 2
    if ~isstruct(P_)
        error('The P_ variable passed in is not a struct.')
    end
    % All the variables in here are calculated only when the P_ variable is
    % passed in.  They are then kept to use in each subsequent call.
    P = P_;
    g = P.g;
    M = P.M; % cart mass kg
    m = P.m; % pendulum bob weight
    l = P.l; % length of pendulum rod meters
    k = P.k;
    R = P.R;
    r_ = P.r;


    A_=[...
        0         0         1           0;...
        0         0         0           1;...
        0      -m*g/M     -k^2/(M*R*r_^2)    0; ...
        0 ((M+m)/(m*l))*g  k^2/(M*R*r_^2*l)  0];

    B_=[0;0;k/(M*R);-k/(M*R*l)];
    C=[1 0 0 0;0 1 0 0];
    D=[0;0];
    
    A = A_;%.*A_r;

    B_r = [1; 1; 1/r_; 1/r_];

    B = B_.*B_r;
    
    Q=P.Qmat;
end

Rmat=1/r^2;

try 
[K,S,E]=lqr(A,B,Q,Rmat);
catch ME
keyboard
end
options = odeset('RelTol',1e-4,'AbsTol',[1e-4 1e-4 1e-4 1e-4]);
[T,X] = ode45(@(t,x) sys_dy(t,x,A,B,K),[0 5],x0',options);

end

function dx=sys_dy(t,x,A,B,K)

u=-K*x;
dx=A*x+B*u;

end