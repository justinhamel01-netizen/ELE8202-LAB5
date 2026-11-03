function arreter(commentaire)
% ARRETER affiche un commentaire (optionnel), fait une "pause" et attend 
%  que l'utilisateur appuie sur "enter" pour continuer le déroulement
%  du programme.
%
% arreter(commentaire)
%
% F.GERMAIN (07-92)

if nargin,
	disp(commentaire)
end
fprintf('Appuyez sur "enter" pour continuer.')
pause
fprintf('\n')	% Retourner au début de la ligne suivante

%end % ARRETER
