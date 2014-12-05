
clear all
close all

P.x0 = [5;0;-10;0] * pi/180;% theta thetadot phi phidot
P.w = 50;
P.z = 0.7;

P.A = [-2*P.w*P.z -P.w^2 0 0; 1 0 0 0; 0 0 -2*P.w*P.z -P.w^2; 0 0 1 0];
P.B = [1 0; 0 0; 0 1; 0 0];
P.C = [0 P.w^2 0 0; 0 0 0 P.w^2];

P.thetad = 0;
P.phid = -pi/6;
P.desired = [P.thetad; 0; P.phid; 0];