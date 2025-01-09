%% Run analysis

[Droplets_sequence,setting,vi] = analysis_video(setting) ;

%% Convert histogram to plot 

[power_law] = hist2plot(Droplets_sequence) ; 

%% Save the data 

disp(' ')
prompt = "Do you want to save the data? y/n: ";
txt = input(prompt,"s");

if strcmp(txt,'y')

    uisave()

end

clear prompt txt
