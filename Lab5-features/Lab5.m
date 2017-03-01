%% Lab 5
clear all;close all;clc
addpath(fullfile('lib'));
addpath(fullfile('test'));
addpath(fullfile('train'));
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
    subplot(numFilFilt, numColFilt,idx);
    imshow(filtros{idx},[-0.1 0.1]); axis off;
end

%% Take a portion of the train ims
% Subsample train data set;
mkdir ourtrain
addpath(fullfile('ourtrain'));
% ctrl si ya hay ims en ourtrain
for textures = 1:25
    pics = randperm(30);
    sampling = 5;
    pics = pics(1:sampling);
    for idx = 1:sampling
        name = sprintf('T%2d_%2d.jpg\n',textures,pics(idx)); 
        name(name == ' ') = '0'; name = strtrim(name);
        copyfile(fullfile('.','train',name),fullfile('.','ourtrain'))
    end
end
%%
dir_train = dir(fullfile('ourtrain','*.jpg'));
num_train = length(dir_train);

% Asuming the same size and orientation bc its true here [480 640]
% for imcrop create box
tam = size(imread(dir_train(1).name));
box(1) = tam(1)/4; box(2) = tam(2)/4; % coord top left corner
box(3) = box(1)*2; box(4) = box(1)*2; % croped im size col, row

tam = [box(4)+1 box(3)+1]; % refresh tam croped ims

test_megaarreglo = cell(numfilters,1); %array of filter response for each im
%Preallocate memory
for ind_filt = 1:numfilters
    test_megaarreglo{ind_filt} = zeros(tam(1),tam(2)*num_train); %acordarnos de cambiar num_train si hay submuestreo
end

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

%% Classify 
% Apply filters to test ims

% Classify each pixel response into a texton group

% Compute texton distribution (normalized hist) 

% Chose texture based on distance between normalized hist of train and test

%% Evaluate 
% Create confussion matrix (category names are in names.txt file)
% Calculate ACA

