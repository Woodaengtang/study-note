%% prob6
k_pd = 0.2;
alpha = 0.125;
Gpd = k_pd * (s + alpha);
G = 1 / (2 * s^2);
L = Gpd * G;
sys_pd = feedback(L,1);
step(sys_pd)
grid on