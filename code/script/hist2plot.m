function [power_law] = hist2plot(Droplets_sequence)

%% Convert histogram to plot

[N,edges] = histcounts( diff( Droplets_sequence(:,1) ) , 'Normalization','probability' ) ; 

power_law = [ ( edges(1:end-1) + ( edges(2:end) - edges(1:end-1) ) / 2 )'  N' ] ;