%% prob7
alpha = logspace(-2, 2, 4);
[p1, z1, k1, L1, system1] = LeadFeedback(alpha(4));
step(system1)
xlim([0 100])
ylim([0 1.4])
legend('step response with alpha = 1e1')
grid on
% as system changes with alpha
%% prob7 gain tuning
[p1, z1, k1, L1, system1] = LeadFeedback(0.013);
step(system1)
xlim([0 200])
ylim([0 1.4])
legend('step response with alpha = 0.013')
grid on
%% prob7 sinusoidal input
s = tf('s');
[p1, z1, k1, L1, system1] = LeadFeedback(0.011);
k_pd = 0.2;
alpha = 0.125;
Gpd = k_pd * (s + alpha);
G = 1 / (2 * s^2);
L = Gpd * G;
sys_pd = feedback(L,1);
t = linspace(0,60,1000);
u1 = sin(0.1*t);
u2 = sin(0.8*t);
u3 = sin(3*t);
y1_1 = lsim(sys_pd, u1, t);
y1_2 = lsim(system1, u1, t);
y2_1 = lsim(sys_pd, u2, t);
y2_2 = lsim(system1, u2, t);
y3_1 = lsim(sys_pd, u3, t);
y3_2 = lsim(system1, u3, t);
%%
figure(1)
subplot(2,1,1)
plot(t, y1_1)
hold on
plot(t, u1, '--r')
legend('PD controller frequency response', 'sinusoidal input with 0.1(rad/s)')
grid on
hold off
subplot(2,1,2)
plot(t, y1_2)
hold on
plot(t, u1, '--r')
legend('Lead compensator frequency response','sinusoidal input with 0.1(rad/s)')
grid on
hold off
%%
figure(2)
subplot(2,1,1)
plot(t, y2_1)
hold on
plot(t, u2, '--r')
legend('PD controller frequency response', 'sinusoidal input with 0.8(rad/s)')
grid on
hold off
subplot(2,1,2)
plot(t, y2_2)
hold on
plot(t, u2, '--r')
legend('Lead compensator frequency response','sinusoidal input with 0.8(rad/s)')
grid on
hold off
%%
figure(3)
subplot(2,1,1)
plot(t, y3_1)
hold on
plot(t, u3, '--r')
legend('PD controller frequency response', ...
    'sinusoidal input with 3(rad/s)')
grid on
hold off
subplot(2,1,2)
plot(t, y3_2)
hold on
plot(t, u3, '--r')
legend('Lead compensator frequency response','sinusoidal input with 3(rad/s)')
grid on
hold off
function [p, z, k, L, system] = LeadFeedback(alpha)
    s = tf('s');
    p = 0.1 + alpha;
    z = 0.025 * alpha / (0.025 + 0.2 * alpha);
    k = 0.025 + 0.2 * alpha;
    G_lead = k * (s + z) / (s + p);
    G = 1 / (2 * s^2);
    L = G_lead * G;
    system = feedback(L,1);
end