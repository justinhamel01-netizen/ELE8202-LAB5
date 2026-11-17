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

model ='Simulateur_palan';
open_system(model);
modelConfig = getActiveConfigSet(model);
simConfig = copy(modelConfig);
set_param(simConfig, StopTime = '20');
set_param(simConfig,'SolverType', 'Fixed-step');
set_param(simConfig, 'FixedStep', Tech_string);
set_param(simConfig,'SolverName', 'FixedStepDiscrete');

%% Placement des poles
Gain_pole = [];
Performance = [];
for R = 1:0.5:10
    poles_des = [-R, -1.01*R, -R*(cos(pi/4)+1i*sin(pi/4)), -R*(cos(pi/4)-1i*sin(pi/4))];
    z_des = exp(poles_des*Tech);
    K = place(F,G, z_des);
    poles_bf = eig(F-G*K);
    Gain_pole = [Gain_pole; R K poles_bf'];
    % writematrix(Resultat,"Tableau_1_gain&pole.xlsx")

    %gain Kr
    Kr = K;


    out = sim(model,simConfig);

    t = out.ScopeData(:,1);
    info_x = stepinfo(out.ScopeData1(:,2),t);
    info_y =stepinfo(out.ScopeData1(:,6),t);
    info_u =stepinfo(out.ScopeData(:,2),t);
    info_theta =stepinfo(out.ScopeData1(:,4),t);
    temps_rep_2_x = info_x.SettlingTime;
    temps_rep_2_y = info_y.SettlingTime;
    depassement_x = info_x.Overshoot;
    depassement_y = info_y.Overshoot;
    peak_x = info_x.Peak;
    peak_y = info_y.Peak;
    peak_u = info_u.Peak;
    peak_theta = info_theta.Peak;

    Performance = [Performance; R temps_rep_2_y temps_rep_2_x peak_y peak_x peak_theta peak_u depassement_y depassement_x];
end
save("Gain_pole","Gain_pole")
save("Performance","Performance")
%% LQR

q1=10;
q2=0;
q3=10;
q4=0;
Gain_pole_LQR = [];
Performance_LQR = [];
for r1= [0.1,0.5,1,4,10]

    Q = [q1 0 0 0; 0 q2 0 0; 0 0 q3 0; 0 0 0 q4];
    R = r1;
    [K,P,poles_lqr] = dlqr(F,G,Q,R);

    %K = (1/(G'*G+R))*(G'*P*F);

    poles_bf = eig(F-G*K);
    Gain_pole_LQR = [Gain_pole_LQR; R K poles_bf'];
    %gain Kr
    Kr = K;
    out = sim(model,simConfig);

    t = out.ScopeData(:,1);
    info_x = stepinfo(out.ScopeData1(:,2),t);
    info_y =stepinfo(out.ScopeData1(:,6),t);
    info_u =stepinfo(out.ScopeData(:,2),t);
    info_theta =stepinfo(out.ScopeData1(:,4),t);
    temps_rep_2_x = info_x.SettlingTime;
    temps_rep_2_y = info_y.SettlingTime;
    depassement_x = info_x.Overshoot;
    depassement_y = info_y.Overshoot;
    peak_x = info_x.Peak;
    peak_y = info_y.Peak;
    peak_u = info_u.Peak;
    peak_theta = info_theta.Peak;

    Performance_LQR = [Performance_LQR; R temps_rep_2_y temps_rep_2_x peak_y peak_x peak_theta peak_u depassement_y depassement_x];
end
save("Gain_pole_LQR","Gain_pole_LQR")
save("Performance_LQR","Performance_LQR")
%% Plot
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
