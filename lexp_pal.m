% LEXP_PAL_ced lit un fichier contenant des résultats expérimentaux
%          du palan mobile.
%
%  Ce programme
%  lit un fichier de données (*.MAT)
%
% F.GERMAIN (05-92) rev.(02-93)F.G.
% Modifié par Cédric Demers-Roy (11-2002) pour nouveaux essais

%	Libérer la mémoire des anciennes données
disp(' ')
disp(' ')
disp('Fichiers disponibles dans ce répertoire:')
disp(' ')
dir('*.mat')
valide = 0;
while ~valide,
    %Liste des fichiers disponibles dans le répertoire actuel
    d=dir('*.mat');
    nd=length(d);
    %Afficher la liste avec les numéros correspondants
    for i=1:nd
        is=num2str(i);
        disp([is '     ' d(i).name]);
    end
    %Demander le numéro du fichier désiré
	no_fichier = input('Quelle est le numéro du fichier de données désiré? ');
    if no_fichier >= 1 & no_fichier <= nd
        valide=1;
    else
        valide=0;
    end
	if valide==0
		disp(' ')
		disp('ERREUR, le nom de fichier est invalide.')
        disp('(Faire CTRL-C pour quitter)')
    else
        %Récupérer le nom du fichier dans la liste
        nom_fichier=d(no_fichier).name;
	end
end	
%Récupérer les données dans le fichier demandé
eval(['load '  nom_fichier])			% Lire un fichier de données
%end % LIRE_EXP