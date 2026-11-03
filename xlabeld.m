function xlabeld(commentaire,label_x)
% XLABELD ajoute un commentaire à la légende de l'axe horizontal d'un
%  graphique.
%
%  xlabel(commentaire, label_x) 
%
%  Cette fonction affiche le commentaire à gauche
%   et le label_x à l'extrémité droite de l'axe horizontal.
%
% F.GERMAIN (04-92) rév.(07-92)F.G.

L1=length(commentaire);
L2=length(label_x);
% Afficher le nouveau label
xlabel([ commentaire  setstr(ones(1,67-(L1+L2))*' ')  label_x ]);		

%end % XLABELD
