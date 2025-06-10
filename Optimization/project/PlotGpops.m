close all; clear all; clc;
load("OutputOCP.mat");
load("SolutionOCP.mat");

time = sol.phase.time;
beta = sol.phase.control;
x = sol.phase.state(:, 1);
y = sol.phase.state(:, 2);
u = sol.phase.state(:, 3);
v = sol.phase.state(:, 4);

h = 10;
U = 3;

fig_name_solU = "SolU";
fig_name_solV = "SolV";
fig_name_solX = "SolX";
fig_name_solY = "SolY";

output_linewidth = 1;

PlotU = figure();
hold on; grid on;
uState = plot(time, u, "LineWidth", output_linewidth);
title("$u$ of GPOPS Solution", "Interpreter", "latex"); 
xlabel("time (s)", "Interpreter", "latex"); 
ylabel("velocity (m/s)", "Interpreter", "latex");
legend("$u$", "Location", "southwest", "Interpreter", "latex");
print("ProjectLatex/figures/SolU", "-dpng", "-r500");

PlotV = figure();
hold on; grid on;
vState = plot(time, v, "LineWidth", output_linewidth);
vTarget = plot(time, zeros([length(time), 1]), "r--");
title("$v$ of GPOPS Solution", "Interpreter", "latex"); 
xlabel("time (s)", "Interpreter", "latex"); 
ylabel("velocity (m/s)", "Interpreter", "latex");
legend([vState, vTarget], {"$v$", "$0$"}, "Location", "northwest", "Interpreter", "latex");
print("ProjectLatex/figures/SolV", "-dpng", "-r500");

PlotX = figure();
hold on; grid on;
xState = plot(time, x, "LineWidth", output_linewidth);
title("$x$ of GPOPS Solution", "Interpreter", "latex"); 
xlabel("time (s)", "Interpreter", "latex"); 
ylabel("position (m)", "Interpreter", "latex");
legend("$x$", "Location", "southwest", "Interpreter", "latex");
print("ProjectLatex/figures/SolX", "-dpng", "-r500");

PlotY = figure();
hold on; grid on;
yState = plot(time, y, "LineWidth", output_linewidth);
yTarget = plot(time, h*ones([length(time), 1]), "r--");
title("$y$ of GPOPS Solution", "Interpreter", "latex"); 
xlabel("time (s)", "Interpreter", "latex"); 
ylabel("position (m)", "Interpreter", "latex");
legend([yState, yTarget], {"$y$", "$h$"}, "Location", "northwest", "Interpreter", "latex");
print("ProjectLatex/figures/SolY", "-dpng", "-r500");

PlotXY = figure();
hold on; grid on; axis equal;
plot(x, y, "LineWidth", output_linewidth);
xline(0, "k");
yline(0, "k");
title("Position trajectory of GPOPS Solution", "Interpreter", "latex"); 
xlabel("x (m)", "Interpreter", "latex"); 
ylabel("y (m)", "Interpreter", "latex");
print("ProjectLatex/figures/TrajXY", "-dpng", "-r500");

%% costFcn
intIdx = 1;
Integ = u(1);
objJ = NaN([length(beta), 1]);
objJ(1) = u(1);
for i = 1:(length(time)-1)
    dt = time(i + 1) - time(i);
    trap = U*cos(beta(i))*dt;
    Integ = Integ + trap;
    objJ(i+1) = Integ;
end

PlotJ = figure();
hold on; grid on;
plot(time, objJ, "LineWidth", output_linewidth);
title("Objective function $J$", "Interpreter", "latex");
xlabel("time (s)", "Interpreter", "latex"); 
ylabel("$J$", "Interpreter", "latex");
print("ProjectLatex/figures/ObjFcn", "-dpng", "-r500");
