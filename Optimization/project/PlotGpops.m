close all; clear all; clc;
load("OutputOCP.mat");
load("SolutionOCP.mat");

time = sol.phase.time;
beta = sol.phase.control;
x = sol.phase.state(:, 1);
y = sol.phase.state(:, 2);
u = sol.phase.state(:, 3);
v = sol.phase.state(:, 4);

U = 3;

CtrlVariable = figure();
hold on; grid on;
plot(time, rad2deg(beta)); 
title("\beta of GPOPS Solution"); xlabel("time (s)"); ylabel("\beta (degree)");
legend("Ctrl variable \beta", "Location", "southwest");

PlotDotUV = figure();
hold on; grid on;
udot = plot(time, U.*cos(beta));
vdot = plot(time, U.*sin(beta));
title("of GPOPS Solution"); xlabel("time"); 
legend([udot, vdot]);

PlotU = figure();
hold on; grid on;
uState = plot(time, u);

PlotV = figure();
hold on; grid on;
vState = plot(time, v);

PlotX = figure();
hold on; grid on;
xState = plot(time, x);

PlotY = figure();
hold on; grid on;
yState = plot(time, y);

PlotXY = figure();
hold on; grid on;
plot(x, y)