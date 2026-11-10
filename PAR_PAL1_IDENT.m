% PAR_PAL1 contient les paramètres du système pour le palan # 1
%
% F.GERMAIN (05-92) rév.(02-93)F.G. rév.(03-94) R.H.
% rév (03-95) R.H. , rév (03-96) R.H., rév (11-2002) C.D.R.

g = 9.81;            % Accélération gravitationnelle (m/s^2)
%Kb = 0.30;          % Constante de la fcem (V-s/rad)
%Kphi = 0.32;        % Constante du couple (N-m/Amp)
%r = 0.02458;        % Rayon de la poulie du moteur en x (m)
%Rm = 10;            % Resistance de l'induit (ê)

psc=12000;          % Valeur du prescaler du pwm
volt=24;            % Tension au moteur
G=volt/psc;         % Gain

%Kx = 0.3360;         % Gain du systeme ((m/s)/V)
Kx=0.35;              % Gain du systeme ((m/s)/V)
%TauX = 0.10;        % Constante de temps du systeme (s) Méthode graphique
TauX = 0.10;        % Constante de temps du systeme (s) Moindre carrés

        
m1=7.8;             %Masse M1 du palan 1
m2=1.2;             %Masse M2 du palan 1

pos_x_drt = 3;      % Position limite droite du palan (m)
pos_x_gau = 0;   % Position limite gauche du palan (m)


%L = 1;          % Distance entre la charge et le palan 1 (m)
L_min = 0.100;      % Distance minimum entre la charge et le palan (m)
L_max = 1.400;      % Distance maximum entre la charge et le palan (m)


%end. % PAR_PAL1