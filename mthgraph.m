% PRESENTATION DU MODULE MTHGRAPH.M:
%**************************************************************************
%                    COMMANDE D'UN PALAN MOBILE
%          IDENTIFICATION DES PARAMETRES Kx ET TauX
%                     PAR LA METHODE GRAPHIQUE
%
% Francois GERMAIN  (05-92) rev.(02-93)F.G.,  rev. (03-2001) R.H.
% rev. (09-2002) C.D.R.
%**************************************************************************
%     Le système est de la forme G(s) = [GkKx Ref(s)] / [s(sTaux +1)]
%  ayant comme référence une entrée échelon: a_com*[U(t)-U(t-t1)]
%
%**************************************************************************
clc
clear;                  % Libérer la mémoire

%**************************************************************************
% Note: Le programme utilise les fonctions (modules) utilitaires:
%  - arreter : peut afficher un commentaire, fait une pause et attend "enter"
%  - lexp_pal: récupére les données obtenues par le contrôleur
%  - sortir  : demande si on veut sortir du programme
%**************************************************************************

%
%   DEBUT DU PROGRAMME
%

fin_prog = 0;
%while ~fin_prog,
   % clc;
for i=9:16
    disp('Identification des paramètres Kx et TauX par la méthode graphique.')
    disp('')

    % Afficher le nom des fichiers disponibles
    %dir ECH*.MAT
    %dir CRE*.MAT
    lexp_pal;          % Lire les résultats expérimentaux

    clear vit;              % Pas besoin de la vitesse du palan
    clear teta;             % Pas besoin de la déviation de la charge (nulle)
    clear d_teta;           % Pas besoin de la vitesse de déviation (nulle)

    % Tracer la position du palan Vs temps
    figure(1)
    plot(time,x);
    title(['Position du palan en fonction du temps pour: ' nom])
    ylabel('Position (m) ')
    xlabel('Temps (s)')
    grid
    %Tdeb = input('Quelle est le temps du début (pente constante) en s ? ');
    %Tfin = input('Quelle est le temps final (pente constante) en s ? ');
     a=msgbox('Veuillez spécifier le temps de début (1) et de fin (2) de la pente linéaire','Entrée de l''usager requise','warn','modal');
    [Tdeb, Ty]=ginput(1);
    [Tfin, Ty]=ginput(1);
    Ideb = floor(Tdeb/Tech)+1;                     % Premier indice du vecteur
    Ifin = floor(Tfin/Tech)+1;                     % Dernier indice du vecteur
    clear Droite;
    Droite(:,1) = time(Ideb:Ifin);
    Droite(:,2) = x(Ideb:Ifin);      % Vecteur de données
    % Calculer les coefficients de la droite tangente au vecteur de données
    Coef_droite = polyfit(Droite(:,1),Droite(:,2),1);

    %
    %    CALCULER  Kx ET Tau_12 A PARTIR DU GRAPHIQUE
    %
    % Sachant que la réponse à l'échelon du système est de la forme :
    %   y(t) = K [ Tau exp(-t/Tau) - Tau + t ]+ y(0)
    % pour "t" assez grand, avec le système (palan) l'équation devient
    % l'équation d'une droite:
    %   pos_x = Ref*Gk*Kx*(t - Tau_12) + pos_x0
    % avec
    %   pente = RefGkKx = Coef_droite(1)
    %   ordonnée à l'origine = -RefGkKxTau_12 + pos_x0 = Coef_droite(2)

    psc=12000;          % Valeur du prescaler du pwm
    volt=24;            % Tension au moteur
    G=volt/psc;         % Gain
    aref = u(2);                      % Amplitude de la référence
    Kx = Coef_droite(1)/(G*aref);      % Gain recherché
    Tau_12 = (x(1)-Coef_droite(2))/Coef_droite(1);

    Tau_x = m1*Tau_12/(m1+m2);          % Constante de temps recherchée
    resultats = sprintf('Kx=%.3f(m/s)/V Tau12=%.2fs TauX=%.2fs ',...
                            Kx, Tau_12, Tau_x);
    resultats = [ resultats sprintf('M1=%.1fkg M2=%.1fkg',m1,m2) ];
    
    gain_tau(i-9,:)=[Kx, Tau_x];
    % Calculer la droite tangente au vecteur de données
    Aff_droite = polyval(Coef_droite, [0 1.2*Tfin]);

    figure(1)
    plot(time,x,[0 1.2*Tfin],Aff_droite,'--')      % Ajouter la droite
    title(['Identif. de Kx et TauX par methode graphique pour ' nom])
    xlabel({resultats,' Temps (s)'})
    ylabel('Position du palan (m)')
    grid

%     figure(2)
%     % Afficher la commande appliquée
%     plot(time,ref)
%     title(['Commande en fonction du temps pour ' nom])
%     xlabel('Temps (s)')
%     ylabel('u (Volts)')
%     grid

    disp(resultats)
    disp(' ')
    %Afficher la figure 1 en priorité (plus importante...)
    figure(1);
    % Demander à l'utilisateur si il veut sortir du programme
    fin_prog = sortir('mthgrpah');

end % while ~fin_prog
%end % MTHGRAPH

