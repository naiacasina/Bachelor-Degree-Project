function  [h_w] = wfilter(x,d,L)
% Naia Ormaza Zulueta 05/2019
% x: electrode de référence
% d: bruit + signal
% L: l'ordre du filtre


N = length (x);
rxx = xcorr (x, 'unbiased'); % auto-correlation
rdx = xcorr (d,x, 'unbiased'); % cross-correlation
Rxx = toeplitz (rxx(N:N+L-1));
rdx = rdx (N:N+L-1);
h_w = inv (Rxx)*rdx;

% figure()
%    for jj = 1:L
%     hold on
%     plot(h_w(jj,:)*ones(1,80000),'color',rand(1,3))
%     legendInfo{jj} = ['Filter Order = ' num2str(jj)]; 
%     title('h of Wiener Filter','FontSize',18)
%     xlabel('n','FontSize',22)
%     ylabel('h','FontSize',22)
%     grid on
%    end
%    legend(legendInfo)
end
