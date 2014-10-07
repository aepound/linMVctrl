clear all
close all
P.r0=1500+6378;% distance of sattelite from earth center (km)
P.G=6.674*10^(-11); % Earth's Gravitational Constant)
P.k=398600.4418; % G*M (M is the mass of the earth)
%P.w0=sqrt(P.k/P.r0^3);% 
P.w0=1;
P.phi0=0;
P.theta0=0.001;
P.rdot0=0;
P.phidot0=0;
P.thetadot0=P.w0;
%P.k=P.r0^3*P.w0^2;
P.m=1000;% mass of the satellite in Kg

P.x0=[P.r0;P.rdot0;P.theta0;P.thetadot0;P.phi0;P.phidot0]; % Initial conditions