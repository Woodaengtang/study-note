close all; clear all; clc;
addpath("OptimTraj\");

param.t0          = 0;        % initial time [s]
param.U           = 3;        % acceleration magnitude [m/s²]
param.h           = 10;       % target position [m]
param.Tmax        = 6;        % loose upper bound on final time [s]
param.posBound    = 20;       % bound of position x, y
param.velBound    = 10;       % bound of velocity u, v   
param.betaMin     = -pi;      % control bounds
param.betaMax     =  pi;      % control bounds
param.infB        = 1e4;      % large bounds for free states
param.beta_       = 0;        % Initial control variable
param.dt          = 0.001;    % t_{i+1} - t_i

posBound = 20;
velBound = 10;

% states = [x y u v]
initState   = [0, 0, 5, 0]';
finalState  = [-posBound/2, param.h, -velBound, 0]';
initBeta = 0;

x       = initState;
dot_x   = [5, 0, param.U*cos(initBeta), param.U*sin(initBeta)]';

problem.func.dynamics = @(t,x,u)( continuousOCP(x, u) );
problem.func.pathObj = @(t,x,u)( param.U * cos(u) );  %Force-squared cost function

problem.bounds.initialTime.low = 0;
problem.bounds.initialTime.upp = 0;
problem.bounds.finalTime.low = param.Tmax;
problem.bounds.finalTime.upp = param.Tmax;
problem.bounds.initialState.low = initState;
problem.bounds.initialState.upp = initState;
problem.bounds.finalState.low = finalState;
problem.bounds.finalState.upp = finalState;

problem.bounds.state.low = [-posBound, -posBound, -velBound, -velBound]'; 
problem.bounds.state.upp = [posBound, posBound, velBound, velBound]'; 

problem.bounds.control.low = -pi;
problem.bounds.control.upp = pi;

problem.guess.time = [0, param.Tmax];
problem.guess.state = [problem.bounds.initialState.low, problem.bounds.finalState.upp];
problem.guess.control = [0,pi];

problem.options.nlpOpt = optimset(...
    'Display','iter',...
    'MaxFunEvals',1e6);
problem.options.method = 'hermiteSimpson';
soln = optimTraj(problem);

save("OutputDirectCollocation.mat", "soln");

function dx = continuousOCP(x, u)
    U = 3;
    dx = [x(3, :);...
          x(4, :);...
          U .* cos(u);...
          U .* sin(u)];
end