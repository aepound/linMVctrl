function u=pidControl(kp,kd,ki,phi,phi_c,P,p)
%==========================================================================
%This is the pid control code given to ECE 6320 Students
%This is used attitide control and position control (6 times)
%
%09/25/2014: Last modified by Rajikant Sharma
%==========================================================================
err=phi_c-phi;
u=kp*err-kd*p+ki*err*P.Ts;

