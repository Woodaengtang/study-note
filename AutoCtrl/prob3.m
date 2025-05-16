%% prob3 rlocus
s = tf('s');
k1 = 1;
Gc = k1 * (s + 0.1) / (s + 0.4);
G = 1 / (2*s^2);
L = Gc * G;
rlocus(L)
grid on
%% prob3 Bode Plot
s = tf('s');
k1 = 1;
Gc = k1 * (s + 0.1) / (s + 0.4);
G = 1 / (2*s^2);
L = Gc * G;
sys = feedback(L,1);
bode(L)
hold on
bode(sys)
legend('open loop bode plot','closed loop bode plot')
hold off
grid on
%% prob3 Nyquist Plot
s = tf('s');
k1 = 1;
Gc = k1 * (s + 0.1) / (s + 0.4);
G = 1 / (2*(s+0.00000001)^2);
L = Gc * G;
nyquist(L);
grid on
%% prob2 & prob3 step response comparison at kp = 3
close all
s = tf('s');
kp2 = 0.167;
L2 = kp2 /(2*(s)^2);
sys2 = feedback(L2,1);
% subplot(2, 1, 1)
% step(sys2)
% xlim([0 100])
legend('prob2 step response at kp = 0.268')
kp3 = 0.167;
Gc3 = kp3 * (s + 0.1) / (s + 0.4);
G3 = 1 / (2*s^2);
L3 = Gc3 * G3;
sys3 = feedback(L3,1);
% subplot(2, 1, 2)
step(sys3)
legend('prob3 step response at kp = 0.167')
grid on
hold off