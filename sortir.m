function fin_prog = sortir(nom_prog)
% SORTIR demande à l'utilisateur si il désire sortir du programme.
%
% fin_prog = sortir(nom_prog)
%  Le nom du programme est optionnel.
%  La fonction retourne la réponse:
%     fin_prog = 0 : pour NON ou si l'utilisateur appuie sur "enter";
%     fin_prog = 1 : autrement.
%
% F.GERMAIN (07-92)

if ~nargin,         % Aucun paramètres d'entrée de la fonction
    nom_prog = '';
end
rep = input(['Voulez-vous sortir du programme ',nom_prog ' (o/n:enter)? '],...
                 's');
if ~length(rep),
    rep = 'n';
end
if rep=='n' | rep=='N',
    fin_prog = 0;   % NON
else
    fin_prog = 1;   % OUI
end

%end. % SORTIR
