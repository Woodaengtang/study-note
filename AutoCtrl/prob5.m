%% prob5 rlocus
close all
s = tf('s');
k_pd = 1;
k_pi = 1;
G_pd = k_pd * (s + 1/10);
G_pi = k_pi * ((s + 1/10) / s);
G = 1 / (2*s^2);
L_pd = G_pd * G;
L_pi = G_pi * G;
subplot(1,2,1)
rlocus(L_pd)
legend('PD control')
grid on

subplot(1,2,2)
rlocus(L_pi)
legend('PI control')
grid on
%% prob5 Bode Plot
s = tf('s');
k_pd = 1;
k_pi = 1;
G_pd = k_pd * (s + 1/10);
G_pi = k_pi * ((s + 1/10) / s);
G = 1 / (2*s^2);
L_pd = G_pd * G;
L_pi = G_pi * G;
sys_pd = feedback(L_pd,1);
sys_pi = feedback(L_pi,1);

subplot(1,2,1)
bode(L_pd)
grid on
hold on
bode(sys_pd)
legend('PD control open loop', 'PD control closed loop')
grid on
hold off

subplot(1,2,2)
bode(L_pi)
grid on
hold on
bode(sys_pi)
legend('PI control open loop', 'PI control closed loop')
grid on
hold off
%% prob5 nyquist
close all
s = tf('s');
k_pd = 1;
k_pi = 1;
G_pd = k_pd * (s + 1/10);
G_pi = k_pi * ((s + 1/10) / s);
G = 1 / (2*s^2);
L_pd = G_pd * G;
L_pi = G_pi * G;
subplot(1,2,1)
nyquist(L_pd)
legend('PD control')
grid on

subplot(1,2,2)
nyquist(L_pi)
legend('PI control')
grid on