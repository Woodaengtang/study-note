close all; clear; clc;

t0   = 0;            % initial time [s]
U    = 3;            % acceleration magnitude [m/s²]
h    = 10;           % target position [m]
Tmax = 100;          % loose upper bound on final time [s]
posBound = 20;       % bound of position x, y
velBound = 10;       % bound of velocity u, v


betaMin = -pi;       % control bounds
betaMax =  pi;
infB    = 1e4;       % large bounds for free states

auxdata.U = U;

%% problem‑function handles
functions.continuous = @ContinuousOCP;
functions.endpoint   = @EndpointOCP;

%% bounds
% time
bounds.phase.initialtime.lower = t0;
bounds.phase.initialtime.upper = t0;
bounds.phase.finaltime.lower   = 0.01;
bounds.phase.finaltime.upper   = Tmax;

% states = [x y u v]
bounds.phase.initialstate.lower = [0 -posBound -velBound -velBound];
bounds.phase.initialstate.upper = [0  posBound  velBound  velBound];

bounds.phase.state.lower  = [-posBound -posBound -velBound -velBound];
bounds.phase.state.upper  = [ posBound  posBound  velBound  velBound];

bounds.phase.finalstate.lower = [-posBound  h -velBound 0];
bounds.phase.finalstate.upper = [ posBound  h  velBound 0];

bounds.phase.control.lower = betaMin;
bounds.phase.control.upper = betaMax;

bounds.phase.integral.lower = -infB;
bounds.phase.integral.upper = infB;

%% 4. initial guess
guess.phase.time    = [t0; Tmax/2];
guess.phase.state   = [0 0 0 0;    % start
                       0 h 0 0];   % crude target
guess.phase.control = [0; 0];
guess.phase.integral = 0;

%% 5. mesh settings
mesh.method          = 'hp-PattersonRao';
mesh.tolerance       = 1e-6;
mesh.maxiterations   = 10;
mesh.colpointsmin    = 4;
mesh.colpointsmax    = 10;
mesh.phase.colpoints = 4*ones(1,10);
mesh.phase.fraction  = 0.1*ones(1,10);

%% 6. derivatives & NLP options 
derivatives.supplier        = 'sparseFD';
derivatives.derivativelevel = 'second';

nlp.solver                      = 'ipopt';
nlp.ipoptoptions.linear_solver  = 'ma57';
nlp.ipoptoptions.tolerance      = 1e-10;

%% 7. assemble setup 
setup.name          = 'ProjectOCP';
setup.functions     = functions;
setup.bounds        = bounds;
setup.guess         = guess;
setup.mesh          = mesh;
setup.derivatives   = derivatives;
setup.nlp           = nlp;
setup.auxdata       = auxdata;
setup.scales.method = 'automatic-bounds';
setup.method        = 'RPM-Differentiation';

%% 8. solve 
output = gpops2(setup);
sol    = output.result.solution;
save("OutputOCP.mat", "output");
save("SolutionOCP.mat", "sol");

%%
% Continuous dynamics + integrand
function phaseout = ContinuousOCP(input)
U = input.auxdata.U;

x    = input.phase.state(:,1);
y    = input.phase.state(:,2);
u    = input.phase.state(:,3);
v    = input.phase.state(:,4);
beta = input.phase.control(:,1);

xdot = u;
ydot = v;
udot = U.*cos(beta);
vdot = U.*sin(beta);

phaseout.dynamics  = [xdot ydot udot vdot];
phaseout.integrand = udot;              % L(t) = u̇
end

% Endpoint function
function output = EndpointOCP(input)
u0 = input.phase.initialstate(3);   % currently fixed at 0
output.objective = input.phase.integral + u0;
end
