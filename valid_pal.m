
% PRESENTATION DU MODULE VALIDPAL.M:
%**************************************************************************
%                        COMMANDE D'UN PALAN MOBILE
%
%                      SIMULATION DES ETATS DU SYSTEME
%            ET COMPARAISON AVEC LES RESULTATS EXPERIMENTAUX
%
% Francois GERMAIN (05-92)  rev.(02-93)F.G.. rev (03-2001) R.H.
% rev. (09-2002) C.D.R.
%**************************************************************************
%  A partir du modèle d'état du palan mobile ce programme permet
%  - de simuler le comportement du système en fonction de la
%    commande appliquée à l'entrée;
%  - de comparer la simulation avec les résultats expérimentaux (*.MAT)
%
% Note:
%  Les fichiers de données (*.M) proviennent 
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
% Les graphiques tracés par le programme sont :
%   - position du palan
%   - vitesse du palan
%   - deviation angulaire de la charge
%   - position (horizontale) de la charge
%
%     Chaque graphique contient les informations sur les paramètres
%   paramètres du système: Kx, TauX, L, M1, M2
%

%**************************************************************************
% Note: Le programme utilise les fonctions (modules) utilitaires:
%  - arreter : peut afficher un commentaire, fait une pause et attend "enter"
%  - par_pal#: contient les paramètres du palan No ?
%  - lexp_pal: récupère les données obtenues par le controleur
%  - etat_pal: établit les matrices du modèle d'états du palan mobile
%  - sortir  : demande si on veut sortir du programme
%**************************************************************************

%
%   DEBUT DU PROGRAMME
%
disp('Attention, la masse M2 est redéfinie dans les fichiers de parametres!!!');
disp('La courbe bleu est la simulation et la rouge les résultats du modèle.');

ratio=24/12000;
fin_prog = 0;
while ~fin_prog,
    % Libérer la mémoire des anciennes valeurs
    clear X;
    clear Y;
    
    % Afficher le nom des fichiers disponibles
    lexp_pal;               % Lire les résultats expérimentaux
    
    %no contient le numéro du palan identifié dans cet essai
    no_s=num2str(no);
    eval(['PAR_PAL' no_s '_IDENT']);    % Lire les paramètres du palan No_Pal
    
    %if length(No)>4,
    %    No = No(1:4);
    %end

    disp('Valeurs à tester lors de cet essai :\n')
    Kx=input('Valeur de Kx calculée pour cet essai?');
    TauX=input('Valeur de Taux calculée pour cet essai?');

    ETAT_PAL_IDENT    % Etablir les matrices du modèle d'états du système

    %          --- SIMULATION DU PALAN MOBILE ---
    %
    % ref = commande appliquée
    %

    X0=[x(1);dx(1);t(1);dt(1)];     % Conditions initiales
    [Y,X]=lsim(A,B,C,D,u*ratio,time,X0);           % Simulation du système
    % Afficher les graphiques
    %
    figure(1)
    subplot(411)
    plot(time,x,time,X(:,1),':r');
    grid;
    title ('États du palan (bleu continu=expérimental; rouge points=simulé): ');
    ylabel('X1 (m)');
    xlabeld(par_syst, 'Temps (s)');
    %figure(2)
    subplot(412)
    plot(time,dx,time,X(:,2),':r');
    grid;
    %title ('Vitesse du palan pour(bleu continu=expérimental; rouge points=simulé): ' );
    ylabel('X2 (m/s)');
    xlabeld(par_syst, 'Temps (s)');
    %figure(3);
    subplot(413)
    plot(time,t,time,X(:,3),':r');
    grid;
    %title('Déviation de la charge pour(bleu continu=expérimental; rouge points=simulé):');
    ylabel('X3 (rad)');
    xlabeld(par_syst, 'Temps (s)');
    %figure(4)
    subplot(414)
    plot(time,(x+L*t),time,Y(:,1),':r');
    grid;
    %title('Position de la charge pour(bleu continu=expérimental; rouge points=simulé):');
    ylabel('y = X1 + L*X3 (m)');
    xlabeld(par_syst, 'Temps (s)');
    % Demander à l'utilisateur si il veut sortir du programme
    fin_prog = sortir('VALIDPAL');

end % while ~fin_prog

%end. % VALIDPAL
