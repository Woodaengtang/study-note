% output = gpops2(input)

% input : User-defined structure that contains all of the information about
% the optimal control problem to be solved.

% output : Structure that contains the information obtained by solving the
% optimal control problem.

clear all; close all; clc;

t0 = 0;
tf = 1000; 
x0 = 1.5; 
xf = 1; 
xMin = -50;
xMax = +50;
uMin = -50;
uMax = +50;


%% Syntax for input structure setup

% name : a string with no blank spaces that contains the name of the problem
% functions : a structure that contains the name of the continuous function and the endpoint function
%% bounds
% : an structure that contains the information about the lower and upper 
% bounds on the different variables and constraints in the problem
bounds.phase.initialtime.lower = t0; 
bounds.phase.initialtime.upper = t0; 
bounds.phase.initialstate.lower = x0; 
bounds.phase.initialstate.upper = x0; 
% bounds.phase.state.lower = xMin; 
% bounds.phase.state.upper = xMax; 
bounds.phase.finalstate.lower = xf; 
bounds.phase.finalstate.upper = xf; 
bounds.phase.control.lower = uMin; 
bounds.phase.control.upper = uMax; 
bounds.phase.integral.lower = 0; 
bounds.phase.integral.upper = 100000;

%% guess
% : an structure that contains a guess of the time, state, control, 
% integrals, and static parameters in the problem
guess.phase.time = [t0; tf]; 
guess.phase.state = [x0; xf];
guess.phase.control = [0; 0];
guess.phase.integral = 0;

%% mesh 
% : a structure that specifies the information as to the type of 
% mesh refinement method to be used and the mesh refinement accuracy 
% tolerance, as well as the initial mesh

% Setting all mesh fields as default
mesh.method = "hp-PattersonRao";
mesh.tolerance = 1e-3;
mesh.maxiterations = 10;
mesh.colpointsmin = 3;
mesh.colpointsmax = 10;
mesh.splitmult = 1.2;
mesh.curveratio = 2;
mesh.R = 1.2;
mesh.sigma = 0.5;

% auxdata : a structure containing auxiliary data that may be used by different functions in the problem
%% derivatives : a structure that specifies the derivative approximation to be used by the NLP solver and the derivative order (’first’ or ’second’) to be used by the NLP solver.
derivatives.supplier = 'adigator'; 
derivatives.derivativelevel = 'second';

% scales : a structure that specifies how the problem to be solved is scaled
% method : a string that defines the version of the collocation to be used when solving the problem

nlp.solver = 'ipopt'; 
nlp.snoptoptions.tolerance = 1e-10; 
nlp.snoptoptions.maxiterations = 20000; 
nlp.ipoptoptions.linear_solver = 'ma57'; 
nlp.ipoptoptions.tolerance = 1e-10;

setup.name = "ProjectGPOPS";
setup.functions
setup.bounds
setup.guess
setup.auxdata
setup.derivatives