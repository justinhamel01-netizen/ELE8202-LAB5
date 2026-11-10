clear all; 
L = 1;          % Distance entre la charge et le palan 1 (m)
PAR_PAL1_IDENT;
ETAT_PAL_IDENT;

%gain Kr
k= 0.1;
Kr = [k 0 0 0];

%etat desirée

xd = [0.5 0 0 0]';
Tech = '0.0002';

model ='Simulateur_palan';
open_system(model);
modelConfig = getActiveConfigSet(model);
simConfig = copy(modelConfig);
set_param(simConfig, StopTime = '20');
set_param(simConfig,'SolverType', 'Fixed-step');
set_param(simConfig, 'FixedStep', Tech);
set_param(simConfig,'SolverName', 'ode4');
out = sim(model,simConfig);

t = out.ScopeData(:,1);
subplot(3,2,1);
plot(t, out.ScopeData(:,2));
ylabel("Commande (V)");
xlabel("Temps (s)");


subplot(3,2,2);
plot(t, out.ScopeData1(:,2));
ylabel("Position (m)");
xlabel("Temps (s)");

subplot(3,2,3);
plot(t, out.ScopeData1(:,3));
ylabel("Vitesse (m/s)");
xlabel("Temps (s)");

subplot(3,2,4);
plot(t, out.ScopeData1(:,4));
ylabel(" \theta (rad)");
xlabel("Temps (s)");

subplot(3,2,5);
plot(t, out.ScopeData1(:,5));
ylabel("d\theta/dt(rad/s)");
xlabel("Temps (s)");

subplot(3,2,6);
plot(t, out.ScopeData1(:,6));
ylabel("y (m)");
xlabel("Temps (s)");