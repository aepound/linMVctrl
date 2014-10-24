function plotStates
close all
load quad_states.mat
load traj.mat
load control_com.mat

u_c=uc.data;
T=u_c(:,1);
phi_c=u_c(:,2);
theta_c=u_c(:,3);
r_d=u_c(:,4);
pnr=Xt.data(:,1);
per=Xt.data(:,2);
pdr=Xt.data(:,3);
vnr=Xt.data(:,4);
ver=Xt.data(:,5);
vdr=Xt.data(:,6);

T=Xt.time;

pn=X.data(:,1);
pe=X.data(:,2);
pd=X.data(:,3);

vn=X.data(:,4);
ve=X.data(:,5);
vd=X.data(:,6);

phi=X.data(:,7);
theta=X.data(:,8);
psi=X.data(:,9);

figure(2)
plot3(pnr,per,-pdr,pn,pe,-pd,'--r')
legend('ref','actual')
axis([-2 2 -2 2 0 2])
grid on
xlabel('pn(m)');
ylabel('pe(m)');
zlabel('pd(m)');
figure(3)
subplot(3,1,1)
plot(T,phi_c*180/pi,T,phi*180/pi,'r--')
xlabel('time(s)')
ylabel('\phi (degree)')
grid on
subplot(3,1,2)
plot(T,theta_c*180/pi,T,theta*180/pi,'r--')
xlabel('time(s)')
ylabel('\theta (degree)')
grid on
subplot(3,1,3)
plot(T,psi*180/pi)
xlabel('time(s)')
ylabel('\psi (degree)')
grid on
figure(4)
subplot(3,1,1)
plot(T,pnr-pn)
xlabel('time(s)')
ylabel('error in north (m)')
grid on
subplot(3,1,2)
plot(T,per-pe)
xlabel('time(s)')
ylabel('error in east (m)')
grid on
subplot(3,1,3)
plot(T,pdr-pd)
xlabel('time(s)')
ylabel('error in down (m)')
grid on

figure(5)

subplot(3,1,1)
plot(T,vnr,T,vn,'--r')
xlabel('time(s)')
ylabel('velocity north (m/s)')
grid on
subplot(3,1,2)
plot(T,ver,T,ve,'--r')
xlabel('time(s)')
ylabel('velocity east (m/s)')
grid on
subplot(3,1,3)
plot(T,vdr,T,vd,'--r')
xlabel('time(s)')
ylabel('velocity down (m)')
grid on

%% compute Root Mean Square Error
n=size(T,1);
posRmsError=sqrt(((pn-pnr)'*(pn-pnr)+(pe-per)'*(pe-per)+(pd-pdr)'*(pd-pdr))/n)
MaxPositionError=max(((pn-pnr).*(pn-pnr)+(pe-per).*(pe-per)+(pd-pdr).*(pd-pdr)).^(0.5))
