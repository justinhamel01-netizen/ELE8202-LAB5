clear all;
L = 1;          % Distance entre la charge et le palan 1 (m)
Kx=0.32;              % Gain du systeme ((m/s)/V) déterminé au labo 5
TauX = 0.11;        % Constante de temps du systeme (s) déterminé au labo 5

PAR_PAL1_IDENT;
ETAT_PAL_IDENT;
%Transfert vers ssystème discret avec c2d
Tech = 0.0002; %s
sysc = ss(A,B,C,D);
sysd = c2d(sysc,Tech);
F = sysd.A;
G = sysd.B;
C = sysd.C;
D = sysd.D;
%% Setup de la simulation
xd = [0.5 0 0 0]';
Tech_string = '0.0002';
Kr = [9.0560    4.5832  -13.7344    0.1];
xd_ref = 0.5;
s = tf('s');
% Calcul des parametres du generateur
zeta=1;
wn=10;
k1 = 2*zeta/wn;
k2 = 1/wn^2;
% Fonctions de transfert continu
H_pos = 1/(k2*s^2 + k1*s + 1);
H_vit = s/(k2*s^2 + k1*s + 1);
% Transformation en discret
H_pos_d = c2d(H_pos, Tech);
H_vit_d = c2d(H_vit, Tech);
xres = 1/45000;
xdot_res = xres/Tech;
theta_res = 2*pi/(4000);
thetadot_res = theta_res/Tech;

model ='Simulateur_palan_generateur_trajectoire_version2024';
open_system(model);
modelConfig = getActiveConfigSet(model);
simConfig = copy(modelConfig);
set_param(simConfig, StopTime = '20');
set_param(simConfig,'SolverType', 'Fixed-step');
set_param(simConfig, 'FixedStep', Tech_string);
set_param(simConfig,'SolverName', 'FixedStepDiscrete');
% Simulation
out = sim(model_gen,simConfig);

% plot de comparaison
load("p1_obs_1.mat")
plot(data(1,:),data(2:6,:))