function in=TrajControlI_diffFlatness(uu,P)
%==========================================================================
%This is the position control code given to ECE 6320 Students
%Currently same pid gains are used for all the angles (need to change this)
%
%10/09/2014: Last modified by Rajikant Sharma
%==========================================================================
Xtrue=uu(1:12);
pn=Xtrue(1);% position north in inerital frame
pe=Xtrue(2);% position east in inerital frame
pd=Xtrue(3);% position down in inerital frame
vn = Xtrue(4);% velocity in north
ve = Xtrue(5);% velocity in east
vd = Xtrue(6);% velocity in down
phi = Xtrue(7); % roll angle 
theta = Xtrue(8);% pitch angle
psi = Xtrue(9);% yaw angle
gyroOp=uu(10:12); % gyro output
p=gyroOp(1);% roll rate
q=gyroOp(2);% pitch rate
r=gyroOp(3);% yaw rate     p q r or phi dot theta dot psi dot
%% Control state
x=[pn pe pd vn ve vd psi]';
%% reference trajectory
xr=uu(12+1:12+7);
%% reference input
ur=uu(19+1:19+4);
%% Rotation matrix R(psi) needded to compute z vector is

R_psi=[...
    cos(psi) sin(psi) 0;...
    -sin(psi) cos(psi) 0;...
    0 0 1];
%% Linear state-space system

%% Just a reminder the mass of quadrotor is P.m
%% ALso the Gain Matrix P.K is computed in the param file using LQR so use it
xtilde = x - xr;
utilde = -P.K*xtilde;

u = ur+utilde;
up = u(1:3);
upsi = u(4);

T=P.m*sqrt(up'*up); % thrust
z = R_psi*up*P.m/(-T);
%% define a vector
thetadot = q;
phi_c=asin(-z(2));
theta_c=atan2(z(1),z(3));
r_d=upsi*cos(theta)*cos(phi) - thetadot*sin(phi);



%% Input % 
in=zeros(4,1);
in(1,1)=T; 
in(2,1)=phi_c;% roll angle control
in(3,1)=theta_c;% pitch angle control
in(4,1)=r_d;% yaw angle control



