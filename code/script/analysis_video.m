function [Droplets_sequence,setting,vi] = analysis_video(setting)

%% Read in the image:
disp('Select your Video file.... The file selected is:')
[filename, pathname] = uigetfile({'*.avi';'*.mp4'}, 'Select a Video file');
FileName = fullfile(pathname,filename);
vi = VideoReader(FileName) ; 
disp(filename)

setting.filename = filename ; 
setting.pathname = pathname ; 
clear filename pathname FileName

%% Define first and final frame to analyse

initial_frame = (setting.initial_min*60+setting.initial_seg)*vi.FrameRate + 1 ;
final_frame   = (setting.final_min*60+setting.final_seg)*vi.FrameRate ;

setting.initial_frame = initial_frame ; 
setting.final_frame = final_frame ; 

clear initial_frame final_frame

%% Selecting the area to analyse

disp(' ')
disp('Draw the area of interest, right click, and select "Crop Image":')

close all 
image = rgb2gray( read(vi,setting.initial_frame) ) ;
[~,CropSection] = imcrop(image) ;

setting.CropSection = CropSection ; 

clear CropSection

%% Selecting the x limit

imshow( imcrop(image,setting.CropSection) )
title("What is your x lower limit?")
axis on 

disp(' ')
prompt = "What is your x lower limit? ";
lim_c = input(prompt);

%% Show where I will search for droplets

close all 
I = imcrop(image,setting.CropSection) ; 
imshow( I )
title("You are looking for droplet's centroids between the blue lines.")
axis on 

hold on 

plot( lim_c*[1 1] , [1 size(I,1)] , 'b-' , 'LineWidth', 1.2 )
plot( (lim_c+8)*[1 1] , [1 size(I,1)] , 'b-' , 'LineWidth', 1.2 )


%% Find the droplet passing between the blue lines

Droplets_sequence = zeros(100,3) ; 

for k = setting.initial_frame:setting.frame_rate:setting.final_frame

    I = rgb2gray( imcrop( read(vi,k) , setting.CropSection ) ) ;
    BW = imfill( imextendedmax( I , setting.threshold_value ) , "holes" ) ;

    s = regionprops(BW,'Centroid','Circularity','Area') ; 
    centros = cat(1,s.Centroid) ; 
    cir = cat(1,s.Circularity) ; 
    area = cat(1,s.Area) ; 
    
    if ~isempty(s)

        indx = cir > 0.7 & area > 0.8*mean(area) ; 

        if any(indx)

            c2 = centros(indx,:) ; 

            count = abs( c2(:,1) - lim_c ) < 8 ; 

            if any(count)

                Droplets_sequence(k,:) = [k*ones(sum(count),1) c2(count,:)] ; 

            end

        end

    end

    %% Visualization 

    if strcmp(setting.show_video,'yes')

        analysis_visualization(BW,centros,indx,c2,count)

    end

end

%% Remove duplicates

Droplets_sequence( Droplets_sequence(:,1) == 0 , : ) = [ ] ; 
df = diff(Droplets_sequence(:,3)) ; 
Droplets_sequence([ false ; abs( df ) < 3 ], : ) = [] ; 
