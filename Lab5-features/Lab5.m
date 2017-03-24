%% Lab 5
clear all;close all;clc
disp('Beginning')
addpath(fullfile('/datos1','vision','PerezBravo','lib'));
addpath(fullfile('/datos1','vision','labtextons','train'));
addpath(fullfile('/datos1','vision','labtextons','test'));
%% TRAIN
%% Create the filter bank to be used
ori     = 8;
scales  = 2;
numfilters = 2*ori*scales;
[fb] = fbCreate(ori,1,scales,sqrt(2),2); 
% to match pattern sizes, use only larger filters from 4 to 7? 
% no more than 8 orientations needed, they start repeating themselves
disp('Finished creating filters')
%% Show im w/ all the filters that are being used
numFilFilt = size(fb,1);
numColFilt = size(fb,2);
filtros = fb(:);
% figure()
% for  idx = 1:numFilFilt*numColFilt;
%     subplot(numColFilt, numFilFilt,idx);
%     imagesc(filtros{idx},[-0.1 0.1]); axis off;
% end

%% Take a portion of the train ims
% Subsample train data set;
nameofdir = 'ourtrain';
mkdir(nameofdir)
addpath(fullfile(nameofdir));
% ctrl si ya hay ims en ourtrain
for textures = 1:25
    pics = randperm(30);
    sampling = 1;
    pics = pics(1:sampling);
    for idx = 1:sampling
        name = sprintf('T%2d_%2d.jpg\n',textures,pics(idx)); 
        name(name == ' ') = '0'; name = strtrim(name);
        copyfile(fullfile('/datos1','vision','labtextons','train',name),fullfile('.','ourtrain'))
    end
end
disp('Finished sampling')
%%
dir_train = dir(fullfile('ourtrain','*.jpg'));
num_train = length(dir_train);

%% Asuming the same size and orientation bc its true here [480 640]
% for imcrop create box
tam_test = size(imread(dir_train(1).name));
box(1) = tam_test(1)/4; box(2) = tam_test(2)/4; % coord top left corner
box(3) = box(1)*2; box(4) = box(1)*2; % croped im size col, row

tam_test = [box(4)+1 box(3)+1]; % refresh tam croped ims

test_megaarreglo = cell(numfilters,1); % array of filter response for each im
%% Preallocate memory
for ind_filt = 1:numfilters
    test_megaarreglo{ind_filt} = zeros(tam_test(1),tam_test(2)*num_train); %acordarnos de cambiar num_train si hay submuestreo
end
disp('Finished preallocating memory')
%% Pass filters
for idx = 1:num_train
    % Crop train ims
    current_im = imcrop(imread(dir_train(idx).name),box);
    % Apply filters to train ims
    filt_resp = fbRun(fb,current_im);
    for ind_filt = 1:numfilters
        test_megaarreglo{ind_filt}(:,((idx-1)*tam_test(2)+1):idx*tam_test(2))= filt_resp{ind_filt}; % cat im responses in a same cell of array
    end
end
disp('Finished filtering')
%% Train Model: Create texton dictionary
% Compute textons from train ims pixel response to filters
% Number of clusters (textons)
k = 64;
tic
[map,textons] = computeTextons(test_megaarreglo,k);
timetocomputetextons = toc;
save('testingsave1');
disp('Computation of textons has finished!')

%% Break big image into original images
histograms = zeros(num_train,k);% Preallocating memory
for idx = 1:num_train
    % Extract image
    current = map(:,((idx-1)*tam(2)+1):idx*tam(2));
    histograms(idx,:) = histcounts(current,k,'Normalization','probability');
end
GT_labels = repmat(1:25,sampling,1);
GT_labels = GT_labels(:);

%% Train knn
disp('Beginning training of KNN')
numofneighbors = 10;
Mdl = fitcknn(histograms,GT_labels,'NumNeighbors',numofneighbors);
disp('Training of KNN has finished')

%% Train tree bagger
% Number of trees
tic
numoftrees = 10;
% Train
disp('Beggining training of trees')
trees   = TreeBagger(numoftrees,histograms,GT_labels,'Method',...
    'classification');
toc
% save('thetrees.mat','trees');
disp('Training of tree bagger has finished')

%% TEST
%% Prepare new images (to be classified)

% Cut ims
dir_test = dir(fullfile('test','*.jpg'));
num_test = length(dir_test);

tam_test = size(imread(dir_test(1).name));
box(1) = tam_test(1)/4; box(2) = tam_test(2)/4; % coord top left corner
box(3) = box(1)*2; box(4) = box(1)*2; % croped im size col, row

tam_test = [box(4)+1 box(3)+1]; % refresh tam croped ims

test_test_megaarreglo = cell(numfilters,1); % array of filter response for each im
%% Preallocate memory
for ind_filt = 1:numfilters
    test_test_megaarreglo{ind_filt} = zeros(tam_test(1),tam_test(2)*num_train); %acordarnos de cambiar num_train si hay submuestreo
end
disp('Finished preallocating memory')
%% Pass filters
for idx = 1:num_train
    % Crop train ims
    current_im = imcrop(imread(dir_train(idx).name),box);
    % Apply filters to train ims
    filt_resp = fbRun(fb,current_im);
    for ind_filt = 1:numfilters
        test_test_megaarreglo{ind_filt}(:,((idx-1)*tam_test(2)+1):idx*tam_test(2))= filt_resp{ind_filt}; % cat im responses in a same cell of array
    end
end
disp('Finished filtering')
%% Create normalized hists for testing
map_test = assignTextons(test_test_megaarreglo, textons');
k = 64;
% Break big image into original images
histograms_test = zeros(num_test,k);% Preallocating memory
for idx = 1:num_train
    % Extract image
    current = map_test(:,((idx-1)*tam_test(2)+1):idx*tam_test(2));
    histograms_test(idx,:) = histcounts(current,k,'Normalization','probability');
end
GT_labels_test = repmat(cell1:25,10,1);
GT_labels_test = GT_labels_test(:);
%% Evaluate KNN
[lbl_predicted_knn,score_knn] = predict(Mdl,histograms_test);
C_knn = confusionmat(GT_labels_test,lbl_predicted_knn);
%% Evaluate tree bagger
[lbl_predicted_trees,score_trees] = predict(trees,histograms_test);
C_trees = confusionmat(GT_labels_test,lbl_predicted_trees); %error es que no coinciden tipos de arreglos de param de 
