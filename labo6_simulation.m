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

T_performance = array2table(Performance, ...
    'VariableNames', {'R', 'Temps_rep_y', 'Temps_rep_x1', ...
    'ymax', 'x1max', 'thetamax', 'umax', ...
    'Dep_y', 'Dep_x1'});

T_K_poles = array2table(Gain_pole, ...
    'VariableNames', {'R', 'K1', 'K2', ...
    'K3', 'K4', 'p_bf1', 'p_bf2', ...
    'p_bf3', 'p_bf4'});

% Exporter vers Excel
writetable(T_performance, 'Performance_placement_poles.xlsx');
writetable(T_K_poles, 'Gains_poles_placement_poles.xlsx');

% save("Gain_pole","Gain_pole")
% save("Performance","Performance")
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

T_performance_LQR = array2table(Performance_LQR, ...
    'VariableNames', {'R', 'Temps_rep_y', 'Temps_rep_x1', ...
    'ymax', 'x1max', 'thetamax', 'umax', ...
    'Dep_y', 'Dep_x1'});

T_K_poles_LQR = array2table(Gain_pole_LQR, ...
    'VariableNames', {'R', 'K1', 'K2', ...
    'K3', 'K4', 'p_bf1', 'p_bf2', ...
    'p_bf3', 'p_bf4'});

% Exporter vers Excel
writetable(T_performance_LQR, 'Performance_LQR.xlsx');
writetable(T_K_poles_LQR, 'Gains_poles_LQR.xlsx');

save("Gain_pole_LQR","Gain_pole_LQR")
save("Performance_LQR","Performance_LQR")

%% Robustesse

Kr = [9.9952    2.8361   -8.7562    1.2009]; %Gains choisi (LQR: R = 0.1 q1 =q2 = 10
M2_vec = [0.1*m2 15*m2 m2 m2 m2];
M1 = m1;
L_vec = [L L 0.1*L 10*L L];

for i = 1:5
    M2 = M2_vec(i);
    L = L_vec(i);

    % Recalcul du modèle avec les nouveaux paramètres
    if L<=0
        Tau = (M1+M2)*TauX/M1;
        par_syst = [    sprintf('Kx=%.3f(m/s)/V Tau12=%.2fs L=0m ',Kx,Tau,L) ...
            sprintf('M1=%.2fkg M2=%.2fkg',M1,M2) ];
        M1=M1+M2;
        M2=0;
        L = 0.1;      % Distance quelconque pour éviter une division par 0
    else
        Tau = TauX;
        par_syst = [    sprintf('Kx=%.3f(m/s)/V TauX=%.2fs L=%.2fm ',Kx,TauX,L) ...
            sprintf('M1=%.2fkg M2=%.2fkg',M1,M2) ];
    end

    % Modèle d'états du palan mobile
    A22 = (-1)/(Tau);
    A23 = (M2*g)/(M1);
    A42 = (1)/(Tau*L);
    A43 = (-g*(M1+M2))/(M1*L);
    A = [   0   1    0   0;
        0  A22  A23  0;
        0   0    0   1;
        0  A42  A43  0];
    B = [   0;
        (Kx)/(Tau);
        0;
        -(Kx)/(Tau*L)];
    C = [ 1 0 L 0];

    %Transfert vers ssystème discret avec c2d
    Tech = 0.0002; %s
    sysc = ss(A,B,C,D);
    sysd = c2d(sysc,Tech);
    F = sysd.A;
    G = sysd.B;
    C = sysd.C;
    D = sysd.D;

    % Lancer la simulation
    out = sim(model,simConfig);

    % Plots
    figure(i)
    plot_sim(out)

end
subtitle(par_syst)

%% Plot résultat de simulation

function plot_sim(out)
t = out.ScopeData(:,1);
subplot(3,2,1);
plot(t, out.ScopeData(:,2));
ylabel("Commande (V)");
xlabel("Temps (s)");
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
end
