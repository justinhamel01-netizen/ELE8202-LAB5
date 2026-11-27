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
%set_param(simConfig, StopTime = '0.37'); %test en BF
set_param(simConfig,'SolverType', 'Fixed-step');
set_param(simConfig, 'FixedStep', Tech_string);
set_param(simConfig,'SolverName', 'FixedStepDiscrete');
%controle de la switch
blk    = [model '/Manual Switch'];
set_param(blk, 'sw', '1'); % 1 en boucle ouverte
%set_param(blk, 'sw', '0'); % 0 en boucle fermee
% Simulation
out = sim(model,simConfig);

% plot de comparaison
load("p1_obs_2.mat")

t_bo= data(1,:);
u_bo= data(2,:);
x_bo= data(3,:);
v_bo= data(4,:);
theta_bo= data(5,:);
thetadot_bo= data(6,:);

%plot des graphiques expérimentales
figure
subplot(3,2,1)    
plot(t_bo, u_bo); grid on
ylabel('u (V)')

subplot(3,2,2)          
plot(t_bo, x_bo); grid on
ylabel('x (m)')

subplot(3,2,3)          
plot(t_bo, v_bo); grid on
ylabel('v (m/s)')

subplot(3,2,4)          
plot(t_bo, theta_bo); grid on
ylabel('theta (rad)')

subplot(3,2,5)          
plot(t_bo, thetadot_bo); grid on
ylabel('theta_dot (rad)')

%% Filtre de Kalman
%constantes
c1 =0.1;
c2=10;
%Matrices 
Ck = [1 0 0 0; 0 0 1 0];
Lk = eye(4);
Qf = diag([0 2 0 2]); %matrice Qf de l'enonce
Rf = diag([xres^2*c1 theta_res^2*c2]);

Kf = dlqe(F,Lk,Ck,Qf,Rf);
disp(Kf)

% calculer la variance avec les erreurs
%on calcule apres 1 s car = 0 avant
variance_x = var(out.err_x(out.err_x(:,1)>1.0, 2));
disp(variance_x)

variance_v = var(out.err_x(out.err_v(:,1)>1.0, 2));
disp(variance_v)


variance_theta = var(out.err_theta(out.err_theta(:,1)>1.0, 2));
disp(variance_theta)


variance_thetadot = var(out.err_x(out.err_thetadot(:,1)>1.0, 2));
disp(variance_thetadot)

