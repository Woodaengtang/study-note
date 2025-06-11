close all; clear all; clc;
load("BcOutputOCP.mat");
load("BcSolutionOCP.mat");
load("OutputDirectCollocation.mat");


time = sol.phase.time;
beta = sol.phase.control;
x = sol.phase.state(:, 1);
y = sol.phase.state(:, 2);
u = sol.phase.state(:, 3);
v = sol.phase.state(:, 4);

dcol_t = linspace(soln.grid.time(1), soln.grid.time(end), 100000);
dcol_x = soln.interp.state(dcol_t);
dcol_u = soln.interp.control(dcol_t);

h = 10;
U = 2;

output_linewidth = 2;

PlotU = figure();
hold on; grid on;
uStateGPOPS = plot(time, u, "LineWidth", output_linewidth);
uStateDcol = plot(dcol_t, dcol_x(3,:), "LineWidth", output_linewidth);
title("$u$ of GPOPS and Direct Collocation Solution", "Interpreter", "latex"); 
xlabel("time (s)", "Interpreter", "latex"); 
ylabel("velocity (m/s)", "Interpreter", "latex");
legend([uStateGPOPS, uStateDcol], {"GPOPS", "Direct Collocation"}, "Location", "northeast", "Interpreter", "latex");
print("ProjectLatex/figures/GpopsDcolU", "-dpng", "-r500");

PlotV = figure();
hold on; grid on;
vStateGPOPS = plot(time, v, "LineWidth", output_linewidth);
vStateDcol = plot(dcol_t, dcol_x(4,:), "LineWidth", output_linewidth);
vTarget = plot(time, zeros([length(time), 1]), "r--");
title("$v$ of GPOPS and Direct Collocation Solution", "Interpreter", "latex"); 
xlabel("time (s)", "Interpreter", "latex"); 
ylabel("velocity (m/s)", "Interpreter", "latex");
legend([vStateGPOPS, vStateDcol], {"GPOPS", "Direct Collocation"}, "Location", "northeast", "Interpreter", "latex");
print("ProjectLatex/figures/GpopsDcolV", "-dpng", "-r500");

PlotX = figure();
hold on; grid on;
xStateGPOPS = plot(time, x, "LineWidth", output_linewidth);
xStateDcol = plot(dcol_t, dcol_x(1,:), "LineWidth", output_linewidth);
title("$x$ of GPOPS and Direct Collocation Solution", "Interpreter", "latex"); 
xlabel("time (s)", "Interpreter", "latex"); 
ylabel("position (m)", "Interpreter", "latex");
legend([xStateGPOPS, xStateDcol], {"GPOPS", "Direct Collocation"}, "Location", "southwest", "Interpreter", "latex");
print("ProjectLatex/figures/GpopsDcolX", "-dpng", "-r500");

PlotY = figure();
hold on; grid on;
yStateGPOPS = plot(time, y, "LineWidth", output_linewidth);
yStateDcol = plot(dcol_t, dcol_x(2,:), "LineWidth", output_linewidth);
yTarget = plot(time, h*ones([length(time), 1]), "r--");
title("$y$ of GPOPS and Direct Collocation Solution", "Interpreter", "latex"); 
xlabel("time (s)", "Interpreter", "latex"); 
ylabel("position (m)", "Interpreter", "latex");
legend([yStateGPOPS, yStateDcol], {"GPOPS", "Direct Collocation"}, "Location", "southeast", "Interpreter", "latex");
print("ProjectLatex/figures/GpopsDcolY", "-dpng", "-r500");

PlotXY = figure();
hold on; grid on; axis equal;
xyGPOPS = plot(x, y, "LineWidth", output_linewidth);
xyDcol = plot(dcol_x(1,:), dcol_x(2,:), "LineWidth", output_linewidth);
xline(0, "k"); yline(0, "k");
legend([xyGPOPS, xyDcol], {"GPOPS", "Direct Collocation"}, "Location", "northeast", "Interpreter", "latex");
title("Position trajectory of GPOPS and Direct Collocation Solution", "Interpreter", "latex"); 
xlabel("x (m)", "Interpreter", "latex"); 
ylabel("y (m)", "Interpreter", "latex");
print("ProjectLatex/figures/GpopsDcolTraj", "-dpng", "-r500");

%% costFcn
intIdx = 1;
GpopsInteg = u(1);
GpopsObjJ = NaN([length(beta), 1]);
GpopsObjJ(1) = u(1);
for i = 1:(length(time)-1)
    dt = time(i + 1) - time(i);
    trap = U*(cos(beta(i)) + cos(beta(i+1)))*dt/2;
    GpopsInteg = GpopsInteg + trap;
    GpopsObjJ(i+1) = GpopsInteg;
end

DcolInteg = dcol_x(3,1);
DcolObjJ = NaN([length(dcol_t), 1]);
DcolObjJ(1) = dcol_x(3,1);
for i = 1:(length(dcol_t)-1)
    dt = dcol_t(i + 1) - dcol_t(i);
    trap = U*(cos(dcol_u(i)) + cos(dcol_u(i+1)))*dt/2;
    DcolInteg = DcolInteg + trap;
    DcolObjJ(i + 1) = DcolInteg;
end

PlotJ = figure();
hold on; grid on;
GpopsJ = plot(time, GpopsObjJ, "LineWidth", output_linewidth);
DcolJ = plot(dcol_t, DcolObjJ, "LineWidth", output_linewidth);
title("Objective function $J$", "Interpreter", "latex"); xlabel("time (s)", "Interpreter", "latex");  ylabel("$J$", "Interpreter", "latex");
legend([GpopsJ, DcolJ], {"GPOPS", "Direct Collocation"}, "Location", "northeast", "Interpreter", "latex");
print("ProjectLatex/figures/GpopsDcolObj", "-dpng", "-r500");
