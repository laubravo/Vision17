%% Lab 5
clear all;close all;clc
addpath(fullfile('datos1','vision','PerezBravo','lib'));
addpath(fullfile('datos1','vision','labtextons','train'));
addpath(fullfile('datos1','vision','labtextons','test'));
%% Create the filter bank to be used
ori     = 8;
scales  = 2;
numfilters = 2*ori*scales;
[fb] = fbCreate(ori,1,scales,sqrt(2),2); 
% to match pattern sizes, use only larger filters from 4 to 7? 
% no more than 8 orientations needed, they start repeating themselves
%% Show im w/ all the filters that are being used
numFilFilt = size(fb,1);
numColFilt = size(fb,2);
filtros = fb(:);
figure()
for  idx = 1:numFilFilt*numColFilt;
    subplot(numColFilt, numFilFilt,idx);
    imagesc(filtros{idx},[-0.1 0.1]); axis off;
end

%% Take a portion of the train ims
% Subsample train data set;
nameofdir = 'ourtrain';
mkdir(nameofdir)
addpath(fullfile(nameofdir));
% ctrl si ya hay ims en ourtrain
for textures = 1:25
    pics = randperm(30);
    sampling = 5;
    pics = pics(1:sampling);
    for idx = 1:sampling
        name = sprintf('T%2d_%2d.jpg\n',textures,pics(idx)); 
        name(name == ' ') = '0'; name = strtrim(name);
        copyfile(fullfile('.','textures','train',name),fullfile('.','ourtrain'))
    end
end
%%
dir_train = dir(fullfile('ourtrain','*.jpg'));
num_train = length(dir_train);

%% Asuming the same size and orientation bc its true here [480 640]
% for imcrop create box
tam = size(imread(dir_train(1).name));
box(1) = tam(1)/4; box(2) = tam(2)/4; % coord top left corner
box(3) = box(1)*2; box(4) = box(1)*2; % croped im size col, row

tam = [box(4)+1 box(3)+1]; % refresh tam croped ims

test_megaarreglo = cell(numfilters,1); % array of filter response for each im
%% Preallocate memory
for ind_filt = 1:numfilters
    test_megaarreglo{ind_filt} = zeros(tam(1),tam(2)*num_train); %acordarnos de cambiar num_train si hay submuestreo
end

%% Pass filters
for idx = 1:num_train
    % Crop train ims
    current_im = imcrop(imread(dir_train(idx).name),box);
    % Apply filters to train ims
    filt_resp = fbRun(fb,current_im);
    for ind_filt = 1:numfilters
        test_megaarreglo{ind_filt}(:,((idx-1)*tam(2)+1):idx*tam(2))= filt_resp{ind_filt}; % cat im responses in a same cell of array
    end
end
%% Train Model: Create texton dictionary
% Compute textons from train ims pixel response to filters
% Number of clusters (textons)
k = 16*8;
tic
[map,textons] = computeTextons(test_megaarreglo,k);
timetocomputetextons = toc;
save('testingsave1');
disp('Computation of textons has finished!')
%% Prepare for training (order data)
megaMatrix = zeros(size(test_megaarreglo{1},1),...
    size(test_megaarreglo{1},2),numel(test_megaarreglo));
for idx = 1:numel(array)
    megaMatrix(:,:,idx) = test_megaarreglo{idx};
end
megaMatrix = squeeze(reshape(megaMatrix,numel(megaMatrix(:,:,1)),1,[]));
disp('Ready to train things')
%% Train tree bagger
% Number of trees
numoftrees = 10;
% Train
trees   = TreeBagger(numoftrees,megaMatrix,map(:),'Method',...
    'classification');
save('thetrees','trees');
disp('Training of tree bagger has finished')
%% Train KNN
Y = mat2cell(map(:),ones(length(map(:)),1),ones(1,1));
numofneighbors = 10;
Mdl = fitcknn(megaMatrix,Y,'NumNeighbors',numofneighbors);
save('knnmodel','Mdl');
disp('Training of KNN has finished')
%% Classify 
% Apply filters to test ims

% Classify each pixel response into a texton group

% Compute texton distribution (normalized hist) 

% Chose texture based on distance between normalized hist of train and test

%% Evaluate 
% Create confussion matrix (category names are in names.txt file)
% Calculate ACA
