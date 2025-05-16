%% prob2 rlocus
s = tf('s');
kp = 1;
L = kp /(2*s^2);
rlocus(L)
grid on
%% prob2 Bode plot
s = tf('s');
kp = 1;
L = kp /(2*s^2);
Dsys = L / (1 + L);

bode(L) % plot bode plot for open loop G_c*G
hold on
bode(Dsys) % plot bode plot for closed loop transfer function
legend('open loop bode plot','closed loop bode plot')
hold off
grid on
%% prob2 Nyquist plot
s = tf('s');
kp = 1;
L = kp /(2*s^2);
nyquist(L);
grid on