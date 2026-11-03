% ETAT_PAL contient les matrices du modèle d'états du palan mobile.
%
%  X1 = position du palan
%  X2 = vitesse du palan
%  X3 = déviation angulaire de la charge
%  X4 = vitesse de déviation de la charge
%  Y = position de la charge
%
%  Le programme défini une chaine de caractères (par_syst) contenant les
%  paramètres du système (Kx, TauX, L, m1, m2).
%
% F.GERMAIN (05-92) rév.(07-92)F.G.

clear par_syst
% variation du modèle si L=0 ou L non nul dans les paramètres...
if L<=0
    Tau = (m1+m2)*TauX/m1;
    par_syst = [    sprintf('Kx=%.3f(m/s)/V Tau12=%.2fs L=0m ',Kx,Tau,L) ...
                    sprintf('m1=%.2fkg m2=%.2fkg',m1,m2) ];
    m1=m1+m2;
    m2=0;
    L = 0.1;      % Distance quelconque pour éviter une division par 0
else
    Tau = TauX;
    par_syst = [    sprintf('Kx=%.3f(m/s)/V TauX=%.2fs L=%.2fm ',Kx,TauX,L) ...
                    sprintf('m1=%.2fkg m2=%.2fkg',m1,m2) ];
end

% Modèle d'états du palan mobile
A22 = (-1)/(Tau);
A23 = (m2*g)/(m1);
A42 = (1)/(Tau*L);
A43 = (-g*(m1+m2))/(m1*L);
A = [   0   1    0   0;
        0  A22  A23  0;
        0   0    0   1;
        0  A42  A43  0];
B = [   0;
    (Kx)/(Tau);
        0;
    -(Kx)/(Tau*L)];
C = [ 1 0 L 0];
D = [0];

%end. % ETAT_PAL