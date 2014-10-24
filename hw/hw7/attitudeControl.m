function in=attitudeControl(uu,P)
%==========================================================================
%This is the attitude control code given to ECE 6320 Students
%Currently same pid gains are used for all the angles (need to change this)
%
%09/25/2014: Last modified by Rajikant Sharma
%==========================================================================
Xtrue=uu(1:12);
pn=Xtrue(1);
pe=Xtrue(2);
pd=Xtrue(3);
u = Xtrue(4);
v = Xtrue(5);
w = Xtrue(6);
phi = Xtrue(7);
theta = Xtrue(8);
psi = Xtrue(9);
gyroOp=uu(10:12); % p q r or phi dot theta dot psi dot

%% desired position and heading
Fc=uu(13);
phi_c=uu(14);
theta_c=uu(15);
r_d=uu(16);



%% Torques
%% Attitude Control 
in(1,1)=Fc;
 in(2,1)=pidControl(P.roll_kp,P.roll_kd,P.roll_ki,Xtrue(7),phi_c,P,gyroOp(1));% roll angle control
 in(3,1)=pidControl(P.theta_kp,P.theta_kd,P.theta_ki,Xtrue(8),theta_c,P,gyroOp(2));% pitch angle control
 in(4,1)=P.Att.kp*(r_d-gyroOp(3));% yaw angle control



