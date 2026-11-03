% PRESENTATION DU MODULE VOIR_PAL.M:
%**************************************************************************
%                        COMMANDE D'UN PALAN MOBILE
%
%             VISUALISATION DES DES RESULTATS EXPERIMENTAUX
%
% Francois GERMAIN (05-92)  rev.(07-92)F.G., (03-2001) R.H.
%**************************************************************************
%  Le programme affiche tous les états (X) du système (palan mobile),
%  la commande (u_x) et la sortie (y:position de la charge),
%  à partir des résultats expérimentaux (*.MAT).
%
%  Les fichiers de données (*.M) proviennent des programmes d'identification
%  rédigés par Cédric Demers-Roy (septembre 2002).  Les programmes d'essai
%  portent le m^eme nom que les fichiers de résultats a l'exception de
%  l'extension .mat pour les fichiers de données utilisés ici.
%
%**************************************************************************
clc
clear                       % Libérer la mémoire
help voir_pal
arreter         % Faire une pause et attendre "enter"

clc
echo on;
%  Le fichier de données (*.MAT) contient:
%    la masse du palan "M1" et la masse de la charge "M2";
%    la distance entre la charge et le palan "L";
%    la période d'échantillionnage "Tech";
%    le signal d'entrée "u";
%    la position du palan mobile "x";
%    la déviation de la charge "t".
%    le vecteur temporel "time";
%    la vitesse du palan "dx";
%    la vitesse angulaire du palan "dt";
%    le numero du palan "no"
%    le type de commande "type_com_n"
%    l'amplitude de la commande "a_com_s","a_com_n"
%    la direction de la commande "d_com_s","d_com_n"

echo off
arreter         % Faire une pause et attendre "enter"


%**************************************************************************
% Note: Le programme utilise les fonctions (modules) utilitaires:
%  - arreter : peut afficher un commentaire, fait une pause et attend "enter"
%  - lexp_pal: récupère les données obtenues par le contrôleur
%  - sortir  : demande si on veut sortir du programme
%**************************************************************************

clc

fin_prog = 0;
while ~fin_prog,
    dir *.mat                          % Afficher le nom des fichiers disponibles
    lexp_pal;                     % Lire les résultats expérimentaux (*.MAT)
    
    figure(1);
    plot(time,u)
    title('Commande au palan')
    xlabel('Temps(s)')
    ylabel('Commande PWM')
    
    figure(2);
    plot(time,x)
    title('Position du palan')
    xlabel('Temps(s)')
    ylabel('Position (m)')
    
    
    figure(3);
    plot(time,dx)
    title('Vitesse du palan')
    xlabel('Temps(s)')
    ylabel('Vitesse (m/s)')
    
    figure(4);
    plot(time,t)
    title('Angle du palan')
    xlabel('Temps(s)')
    ylabel('Angle \theta (rad)')
   
    
    figure(5);
    plot(time,dt)
    title('Vitesse angulaire du palan')
    title('Angle du palan')
    xlabel('Temps(s)')
    ylabel('Vitesse angulaire (rad/s)')
    
    figure(5);
    subplot(2,2,1),plot(time,x);
    title('X');
    subplot(2,2,2),plot(time,dx);
    title('dX');
    subplot(2,2,3),plot(time,t);
    title('T');
    subplot(2,2,4),plot(time,dt);
    title('dT');
    
    % Demander à l'utilisateur si il veut sortir du programme
    fin_prog = sortir;

end % while ~fin_prog
%end. % VOIR_PAL
