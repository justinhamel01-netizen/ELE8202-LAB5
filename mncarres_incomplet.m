% PRESENTATION DU MODULE MNCARRES.M:
%**************************************************************************
%                        COMMANDE D'UN PALAN MOBILE
%                 IDENTIFICATION DES PARAMETRES Kx ET TauX
%                     PAR LA METHODE DES MONDRES CARRES
%
% Francois GERMAIN  (05-92) rev.(03-93)F.G. rev. (03-2001) R.H.
%**************************************************************************
%     Pour déterminer les estimations (teta) des paramètres recherchés,
% le programme utilise l'algorithme des moindres carrés sous forme
% récursive et utilisant la vitesse du palan comme sortie (y).
%
%     Lorsque la charge est reliée au palan, la constante de temps TauX
% devient Tau12. Le programme détermine les valeurs de Kx et Tau12, la valeur
% de TauX est ensuite calculée en fonction de la masse de la charge (M2).
%
%     Les données utilisées pour déterminer les paramètres proviennent
% des résultats expérimentaux (*.M) obtenus à l'aide du programme IDENTIF.EXE
% Les fichiers de données doivent être convertis (*.MAT) par le programme
% M2MAT.M avant d'être récupérés par ce programme.
%**************************************************************************
clc
clear
%  Le fichier de données (*.MAT) contient:
%    la masse du palan "M1" et la masse de la charge "M2";
%    la distance entre la charge et le palan "L";
%    la période d'échantillionnage "Tech";
%    le signal d'entrée "ref";
%    la position du palan mobile "x";
%    la déviation de la charge "t".
%    le vecteur temporel "time";
%    la vitesse du palan "dx";
%    la vitesse angulaire du palan "dt";
%    le numero du palan "no"
%    le type de commande "type_com_n"
%    l'amplitude de la commande "a_com_s","a_com_n"
%    la direction de la commande "d_com_s","d_com_n"
%    Le programme trace les graphiques:
%    - Position du palan
%    - Vitesse du palan
%    - Estimée de Kx
%    - Estimée de Tau12
%
%     Les graphiques contiennent les informations sur les paramètres
%   paramètres obtenus: Kx, TauX, Tau12
%   et les paramètres du système: L, M1, M2.
%

%**************************************************************************
% Note: Le programme utilise les fonctions (modules) utilitaires:
%  - arreter : peut afficher un commentaire, fait une pause et attend "enter"
%  - lexp_pal: récupère les données obtenues par le contrôleur
%  - save_gra: demande si on veut sauvegarder les graphiques *.MET
%  - sortir  : demande si on veut sortir du programme
%**************************************************************************

%
%   DEBUT DU PROGRAMME
%

fin_prog = 0;
while ~fin_prog,
    clc;
    disp('Identification des paramètres Kx et Taux')
    disp('  par la méthode des moindres carrés')
    disp('')
    lexp_pal;               % Lire les résultats expérimentaux
    %Initialisation des variables en fonction des données lues
    T=Tech;
    npt=length(x);
%     Gk = -9.9;          % Gain du Kepco
%     % Affiche les résultats expérimentaux
%     figure(1);
%     subplot(211)    % Afficher la position du palan
%     figure(1)
%     plot(time,x);
%     title(['Position du palan en fonction du temps pour: ' nom])
%     ylabel('Position (m) ')
%     xlabel('Temps (s)')
%     grid
%     
%     subplot(212)    % Afficher la vitesse du palan
%     plot(time,dx);
%     title(['Vitesse du palan en fonction du temps pour: ' nom])
%     ylabel('Vitesse (m/s)')
%     xlabel('Temps (s)')
%     grid 
    clear x;                % Pas besoin de la position du palan
    clear t;                % Pas besoin de la déviation de la charge (nulle)
    clear dt;               % Pas besoin de la vitesse de déviation (nulle)

    %
    %   PARAMETRES POUR L''ALGORITHME DES MOINDRES CARRES'
    % Initialisation des paramètres%
    clc
    disp(' ')
    disp('Covariance des estimations initiales des paramètres')
    disp(' ')
    P=[ 1 0;
         0      1];
    disp(' ')
    disp('Facteur d''oubli')
    disp(' ')
    lambda=1;
    
    psc=12000;          % Valeur du prescaler du pwm
    volt=24;            % Tension au moteur
    G=volt/psc;         % Gain tension/PWM
    teta=[0;0];    % estimés actuels
    tetam=zeros(npt,2); % estimés au fil des itérations
    h=zeros(2,1);       % mesures initiales
    taue=zeros(npt,1);  % estimé de Tau au fil du temps
    Ke=zeros(npt,1);    % estimé de K au fil du temps
    

    %
    %       ALGORITHME DES MOINDRES CARRES SOUS FORME RECURSIVE
    %
    u=u*G;                     % Valeur en Volt
    u0=u(1);                   % Valeur initiale de la commande
    y=dx(1);                   % Valeur initiale de la vitesse
    h=[dx(1);u(1)];            % Valeur initiale des mesures
    
    disp('Calcul des estimations de Kx et Tau12,')
    disp('par la méthode des moindres carrés.')

% départ de la boucle à n=2 pour avoir la mesure n-1 valide...
% attention: y = mesure actuelle et h = mesures précédentes... 
%(selon ce que vous avez vu en classe)
% RÉACTIVEZ LA BOUCLE AVANT DE POURSUIVRE!!!

    for i=2:npt
        % Établir le vecteur des mesures / le vecteur des sorties
        y=dx(i);            %Valeurs de la sortie (y(i)))
        h=[dx(i-1);u(i-1)]; %Valeurs des mesures (x(i-1))
        
        % Calculs des matrices de la méthode (Commentaire Alex : NDC p.407)
        % Commentaire Alex :  matrice transposée sur Matlab ajouté un apostrophe : '
        gamma = 1/(1+h'*P*h);
        K = gamma*P*h;
    
        % Calcul des estimés
        teta = teta + K*(y-(h'*teta)) ;
        P = (P-(K*h'*P))/lambda; %lambda = facteur d'oubli il peut être négligé car =1
        
        
        % Conserver toutes les valeurs de P(1,1) et P(1,2)
        P11(i) = P(1,1);
        P12(i) = P(1,2);
        tetam(i,:) = teta';

    % Conserver les estimés de Tau et K
        if teta(1) > 0 && teta(1) < 1       % éviter log d'un nombre invalide
            taue(i,1) = -T/log(teta(1));
            Ke(i,1)   = teta(2)/(1-teta(1));
        else
            taue(i,1) = taue(i-1,1);        % garder la dernière valeur valide
            Ke(i,1)   = Ke(i-1,1);
        end
    end
% ***************************

    Kef = Ke(end);             % Valeur finale de Kx estimé

    figure(2);
    subplot(211);
    plot(time,Ke);
    title(['Estimation du gain Kx par les moindres carres pour ' nom ]);
    xlabel({sprintf('Kx=%.3f(m/s)/V',Kef), 'Temps (s)'});
    ylabel('Kx((m/s)/V)')
    grid
    axis;                       % Remise des axes en mode automatique
    tauef = taue(end);         % Valeur finale de Tau estimé
    tauX = tauef*m1/(m1+m2);    % Ajustement en fonction des masses
    subplot(212)
    plot(time,taue);
    title(['Estimation de TauX par les moindres carres pour ' nom ]);
    xlabel({ [ sprintf('Tau12=%.2fs  TauX=%.4fs  ', tauef, tauX) ...
                sprintf('M1=%.2fkg  M2=%.2fkg', m1, m2) ],...
                'Temps (s)'});
    ylabel('TauX (s)')
    grid
    % Demander à l'utilisateur si il veut sortir du programme
    fin_prog = sortir;

end % while ~fin_prog