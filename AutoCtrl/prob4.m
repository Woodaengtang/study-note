%% prob4 rlocus
close all
s = tf('s');
k2 = 1;
Gc = k2 * (s + 0.1) / (s + 0.05);
G = 1 / (2*s^2);
L = Gc * G;
rlocus(L)
grid on
%% prob4 Bode Plot
s = tf('s');
k2 = 1;
Gc = k2 * (s + 0.1) / (s + 0.05);
G = 1 / (2*s^2);
L = Gc * G;
sys = feedback(L,1);
bode(L)
hold on
bode(sys)
legend('open loop bode plot','closed loop bode plot')
hold off
grid on
%% prob4 Nyquist Plot
s = tf('s');
k2 = 5;
Gc = k2 * (s + 0.1) / (s + 0.05);
G = 1 / (2*s^2);
L = Gc * G;
nyquist(L);
grid on
%% Comparing performance between prob4 prob3
s = tf('s');
k1 = 1;
Gc = k1 * (s + 0.1) / (s + 0.4);
G = 1 / (2*s^2);
L = Gc * G;
sys3 = feedback(L,1);
% define prob3 sys 
k2 = 1;
Gc = k2 * (s + 0.1) / (s + 0.05);
G = 1 / (2*s^2);
L = Gc * G;
sys4 = feedback(L,1);
% define prob4 sys
t = linspace(0,60,1000);
u1 = sin(0.1*t);
u2 = sin(0.7*t);
u3 = sin(3*t);
y3_1 = lsim(sys3, u1, t);
y3_2 = lsim(sys3, u2, t);
y3_3 = lsim(sys3, u3, t);
y4_1 = lsim(sys4, u1, t);
y4_2 = lsim(sys4, u2, t);
y4_3 = lsim(sys4, u3, t);
% define inputs and outputs
%% plot 1
subplot(2,1,1)
plot(t,y3_1)
hold on
plot(t, u1, '--r')
legend('system 3 output', 'sinusoidal input with 0.1(rad/s)')
hold off
grid on
subplot(2,1,2)
plot(t, y4_1)
hold on
plot(t, u1, '--r')
hold off
legend('system 4 output', 'sinusoidal input with 0.1(rad/s)')
grid on
%% plot 2
subplot(2,1,1)
plot(t,y3_2)
hold on
plot(t, u2, '--r')
legend('system 3 output', 'sinusoidal input with 0.7(rad/s)')
hold off
grid on
subplot(2,1,2)
plot(t, y4_2)
hold on
plot(t, u2, '--r')
hold off
legend('system 4 output', 'sinusoidal input with 0.7(rad/s)')
grid on
%% plot 3
subplot(2,1,1)
plot(t,y3_3)
hold on
plot(t, u3, '--r')
legend('system 3 output', ...
    'sinusoidal input with 3(rad/s)')
hold off
grid on
subplot(2,1,2)
plot(t, y4_3)
hold on
plot(t, u3, '--r')
hold off
legend('system 4 output', ...
    'sinusoidal input with 3(rad/s)')
grid on
%% prob3 prob4 step response comparison
s = tf('s');
k1 = 0.005;
Gc = k1 * (s + 0.1) / (s + 0.4);
G = 1 / (2*s^2);
L = Gc * G;
sys3 = feedback(L,1);
k2 = 0.005;
Gc = k2 * (s + 0.1) / (s + 0.05);
G = 1 / (2*s^2);
L = Gc * G;
sys4 = feedback(L,1);
subplot(2,1,1)
step(sys3)
subplot(2,1,2)
step(sys4)
xlim([3000 3500])