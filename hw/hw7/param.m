%==========================================================================
%This is the quadrotor parameters file given to ECE 6320 Students
%You need to Run this before running QuadCOntrol_Waypoint.slx
%
%09/25/2014: Last modified by Rajikant Sharma
%==========================================================================
close all;
clear all;
clc;
%% Sampling time
P.Ts=1/100;  
%% Quadrotr Inertial Parameters (What are they for A R Drone ?)
P.Jx = 0.114700;
P.Jy = 0.057600;
P.Jz = 0.171200;
% gravity (m/s^2)
P.g = 9.806650;
% mass (kg)
P.m = 1.56;
P.l    = 0.3;       % wingspan (m)
P.rho  = 1.268200;  % air density




%% PID  Controller constants
%% Attitude Controller
P.Att.kp=0.5; %% 0.5 0.4 0.2
P.Att.kd=0.4;
P.Att.ki=0.2;
%% Waypoint Controller
P.Waypoint.kp=0.08;
P.Waypoint.kd=0.6;
P.Waypoint.ki=0.05;
%% rol lgains
zeta_roll = 0.707;
a_phi3=1/P.Jx;
phi_max=30*pi/180;
tau_phi_max=2;

 wn_roll = sqrt(a_phi3*tau_phi_max*sqrt(1-zeta_roll^2)/phi_max);
    
    % set control gains based on zeta and wn
    P.roll_kp = wn_roll^2/a_phi3;
    P.roll_kd = 1.1*(2*zeta_roll*wn_roll )/a_phi3;
    P.roll_ki = 0.1;
%% Pitch

zeta_pitch = 0.707;
a_phi3=1/P.Jy;
theta_max=30*pi/180;
tau_theta_max=2;

 wn_pitch = sqrt(a_phi3*tau_theta_max*sqrt(1-zeta_pitch^2)/theta_max);
    
    % set control gains based on zeta and wn
    P.theta_kp = wn_pitch^2/a_phi3;
    P.theta_kd = 1.1*(2*zeta_pitch*wn_pitch )/a_phi3;
    P.theta_ki = 0.1;

%% drawing parameters
% distances are in feet.
%------------------------------------------------------
% course dimentions


% quadrotor dimentions
%2 inches from the center
P2.boxlength = 1/6;
P2.boxwidth = P2.boxlength;
%4.5 inches from the bottom to the top
P2.boxheight = 0.375;
%6 inches from box to motor
P2.armlength = 0.5;
%1/8 inch from center to the side of a rod
P2.armwidth = 1/96;
%1/4 inch from the top of the box
P2.armposition = 1/48;
%25*(2)^(1/2)/2 inches from center to perimeter along x and y axis
P2.perimeter = 1.47;
%perimeter has 3/16 inch width
P2.periwidth = 1/64;

% pillar dimentions
%% State-Space
A=[zeros(3)   eye(3)     zeros(3,1);
   zeros(3)   zeros(3)   zeros(3,1);
   zeros(1,3) zeros(1,3) 0];
B=[zeros(3,4);
   eye(3,4);
   0 0 0 1];
b=[0 0 0 0 0 1 0]';
%% Trajectory Parameters % change these parameters based on the
%% assignment 
P.a=1.5;
P.b=0.75;
P.c=0.5;

P.T=10;%T=6; %T=10;T=20; good
P.w1=2*pi/P.T;
P.w2=P.w1/2;
P.w3=P.w1;
P.n=-0.75;

%% Setup LQR
Q=ones(7);
R=ones(7);
P.K=lqr(A,B,Q,R); % Use LQR to compute Optimal gain matrix. This
                  % matrix will be used to compute u in the
                  % controller 