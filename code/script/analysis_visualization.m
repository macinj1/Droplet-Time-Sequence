function analysis_visualization(BW,centros,indx,c2,count)

%% show frames 

imshow(BW)
hold on 

if any(indx)

    plot(centros(indx,1),centros(indx,2),'bo')

    if any(count)

        plot(c2(count,1),c2(count,2),'kx')

    end

end

pause(0.05)
