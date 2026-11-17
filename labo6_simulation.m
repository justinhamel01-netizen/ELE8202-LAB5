clear all; 
L = 1;          % Distance entre la charge et le palan 1 (m)
Kx=0.32;              % Gain du systeme ((m/s)/V) déterminé au labo 5
TauX = 0.11;        % Constante de temps du systeme (s) déterminé au labo 5

PAR_PAL1_IDENT;
ETAT_PAL_IDENT;
%Transfert vers ssystème discret avec c2d
Tech = 0.002;
sysc = ss(A,B,C,D);
sysd = c2d(sysc,Tech);
F = sysd.A;
G = sysd.B;
C = sysd.C;
D = sysd.D;
%% Plot


%gain Kr
k= 5;
Kr = [k 0 0 0];

%etat desirée

xd = [0.1 0 0 0]';
Tech_string = '0.0002';

model ='Simulateur_palan';
open_system(model);
modelConfig = getActiveConfigSet(model);
simConfig = copy(modelConfig);
set_param(simConfig, StopTime = '20');
set_param(simConfig,'SolverType', 'Fixed-step');
set_param(simConfig, 'FixedStep', Tech_string);
set_param(simConfig,'SolverName', 'FixedStepDiscrete');
out = sim(model,simConfig);

t = out.ScopeData(:,1);
subplot(3,2,1);
plot(t, out.ScopeData(:,2));
ylabel("Commande (V)");
xlabel("Temps (s)");
title ("Commande ")
grid on;


subplot(3,2,2);
plot(t, out.ScopeData1(:,2));
ylabel("Position (m)");
xlabel("Temps (s)");
grid on;

subplot(3,2,3);
plot(t, out.ScopeData1(:,3));
ylabel("Vitesse (m/s)");
xlabel("Temps (s)");
grid on;

subplot(3,2,4);
plot(t, out.ScopeData1(:,4));
ylabel(" \theta (rad)");
xlabel("Temps (s)");
grid on;

subplot(3,2,5);
plot(t, out.ScopeData1(:,5));
ylabel("d\theta/dt(rad/s)");
xlabel("Temps (s)");
grid on;

subplot(3,2,6);
plot(t, out.ScopeData1(:,6));
ylabel("y (m)");
xlabel("Temps (s)");
grid on;
