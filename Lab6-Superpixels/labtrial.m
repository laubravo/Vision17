%% Image names
imgnames = {'24063','25098','26031','27059','48055','54005','55067','55075'};
algorithms = {'k-means','hierarchical','watershed'};
k = 50;

%% Show results with given space and different methods
figure
for idx = 1:length(imgnames)
    for jdx = 1:length(algorithms)
        subplot(length(imgnames),length(algorithms),(length(imgnames)-1)*idx+jdx)
        seg = segmentByClustering(img,'rgb+xy',algorithms{jdx},k);
        image(seg), colormap colorcube
    end
end
