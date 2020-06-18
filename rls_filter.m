function [filtered_GSM_data]=rls_filter(x,d,param)

%   Naia Ormaza Zulueta 24/05/2019
%   Pour l'appel:
%   [ei,h]=rls(lambda,L,x,d,delta);
%
%   Input:
%    lambda = facteur d'oublie, dim 1x1
%    L = taille du filtre, dim 1x1
%    x = signal d'entr?e (artefact), dim Nx1
%    d = signal observ? (d?sir?, mesur?), dim Nx1
%
%   Output:
%    ei = erreur d'estimation ? priori, dim Nx1
%    h_n = coefficients finals du filtre, dim Mx1

L=param.L;
lambda=param.lambda;


% Initialisation
h_n=zeros(L,1);               % h(n)
h2 = zeros(L,1);              % h(n-1)

% x et d vecteurs colonne
x = x(:); N = length(x);
d = d(:);

y=x;
% Tab_h=zeros(L,N-L+1);

n = L;                      % Temps

% Premiere iteration 
h_n = 10*ones(L,1);
Q = 1e-2*eye(L);



% RLS (RECURSIVE LEAST SQUARES)

for n=L:N,
    x_vec = x(n:-1:(n-L+1));
    k = lambda^(-1)*Q*x_vec/(1+lambda^(-1)*x_vec'*Q*x_vec);
    ei (n) = d(n) - h_n'*x_vec;
    h_n = h_n + k*ei(n);
    Tab_h(:,n-L+1)=h_n;
    Q = (lambda^(-1)*eye(L) - lambda^(-1)*k*x_vec')*Q;
    
    y(n)=h_n'*x_vec;
end

filtered_GSM_data = d-y;