
clear all
close all

P.x0=[1;0.2;0;0];% y theta ydot thetadot

P.g=9.8;    % acceleration of gravity
P.M=1;      % cart mass kg
P.m=0.1;    % pendulum bob weight
P.l=0.5;    % length of pendulum rod meters
P.k = 1;    % Motor torque constant
P.R = 100;  % Motor Resistance
P.r = 0.02; % ratio of the motor torque to linear force

ang_err = 1*pi/180;     % Allowable angular error
pos_err = 0.1;          % Allowable position error
q3_2 = 1./(ang_err)^2;
q1_2 = 1./(pos_err)^2;

P.Qmat = diag([q1_2; 0; q3_2; 0]);
