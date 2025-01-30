function analysis_visualization(BW,centros,indx,c2,count)

%% show frames 

imshow(BW)
hold on 

plot(centros(indx,1),centros(indx,2),'bo')

plot(c2(count,1),c2(count,2),'kx')

pause(0.05)