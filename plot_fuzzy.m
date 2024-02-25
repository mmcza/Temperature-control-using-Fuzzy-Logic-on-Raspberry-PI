clc; close all; clear variables;

%load("fuzzy_first_try.mat");
load("fuzzy_przebieg.mat");

temp_ref=simout(:,1);
temp_meas=simout(:,2);
e=simout(:,3);
d_e=simout(:,4);
u_h=simout(:,5);
u_c=simout(:,6);
t=simout(:,7);

figure(1)
subplot(3,1,1)
plot(t,temp_ref,'r',t,temp_meas,'b');
xlabel('t [s]');
ylabel('temp [°C]');
legend('temp_{ref}','temp_{meas}');
subplot(3,1,2)
plot(t,e,'r',t,d_e,'b');
xlabel('t [s]');
ylabel('e [°C]');
legend('e','\Delta e')
subplot(3,1,3)
plot(t,u_h,'r',t,u_c,'b');
xlabel('t [s]');
ylabel('PWM val');
legend('u_{h}','u_{c}');