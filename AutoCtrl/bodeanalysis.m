% gain tuned problem7 system
[p1, z1, k1, L1, system1] = LeadFeedback(0.011);
Noise = system1;
Disturbance = feedback(1, L1);
hold on
bode(L1)
bode(Noise)
bode(Disturbance)
title('Bode Plot')
legend('open loop bode plot', ...
    'Noise transfer func bode plot', ...
    'Disturbance transfer func bode plot')
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