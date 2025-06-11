close all; clear all; clc;
addpath("OptimTraj\");

param.t0          = 0;        % initial time [s]
param.U           = 2;        % acceleration magnitude [m/s²]
param.h           = 10;       % target position [m]
param.Tmax        = 7;        % loose upper bound on final time [s]
param.posBound    = 20;       % bound of position x, y
param.velBound    = 10;       % bound of velocity u, v   
param.betaMin     = -pi;      % control bounds
param.betaMax     =  pi;      % control bounds
param.infB        = 1e4;      % large bounds for free states
param.beta_       = 0;        % Initial control variable
param.dt          = 0.001;    % t_{i+1} - t_i

% states = [x y u v]
initState   = [0, 0, 0, 0]';
initBeta = 0;

x = initState;

problem.func.dynamics = @(t,x,u)( continuousOCP(x, u) );
problem.func.pathObj = [];
% problem.func.pathObj = @(t,x,u)( param.U * cos(u) );
problem.func.bndObj = @(t0, x0, tf, xf) ( xf(3) );
problem.func.bndCst = @(t0, x0, tf, xf) bndCstFcn(t0, x0, tf, xf);

problem.bounds.initialTime.low = param.t0;
problem.bounds.initialTime.upp = param.t0;
problem.bounds.finalTime.low = 0.01;
problem.bounds.finalTime.upp = param.Tmax;
problem.bounds.initialState.low = initState;
problem.bounds.initialState.upp = initState;
problem.bounds.finalState.low = [-param.posBound, 10, -param.velBound, 0]';
problem.bounds.finalState.upp = [ param.posBound, 10,  param.velBound, 0]';

problem.bounds.state.low = [-param.posBound, -param.posBound, -param.velBound, -param.velBound]'; 
problem.bounds.state.upp = [param.posBound, param.posBound, param.velBound, param.velBound]'; 

problem.bounds.control.low = param.betaMin;
problem.bounds.control.upp = param.betaMax;

problem.guess.time = [0, param.Tmax];
problem.guess.state = [[0;0;0;0], [-10; 10; -10; 0]];
problem.guess.control = [0,0];

problem.options(1).nlpOpt = optimset(...
    'Display','iter',...
    'TolCon', 1e-8,...
    'TolFun',1e-8,...
    'MaxFunEvals',1e6);
problem.options(1).method = 'hermiteSimpson';
problem.options(1).hermiteSimpson.nSegment = 30;

soln = optimTraj(problem);

save("OutputDirectCollocation.mat", "soln");

function dx = continuousOCP(x, u)
    U = 2;
    N = size(x, 2);
    dx = NaN([4, N]);
    dx(1,:) = x(3, :);
    dx(2,:) = x(4, :);
    dx(3,:) = U .* cos(u);
    dx(4,:) = U .* sin(u);
end

function [inceq, ceq] = bndCstFcn(t0, x0, tF, xF)
    inceq = [];
    h = 10;
    ceq = [xF(2) - h;    % y(tf) = h
           xF(4)];       % v(tf) = 0
end