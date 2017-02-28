%% Lab 5
addpath(fullfile('lib'));
addpath(fullfile('test'));
addpath(fullfile('train'));

%% Take a portion of the train ims
dir_train = dir(fullfile('train','*.jpg'));
num_train = length(dir_train);

% Asuming the same size and orientation bc its true here [480 640]
% for imcrop create box
tam = size(imread(dir_train(1).name));
box(1) = tam(1)/4; box(2) = tam(2)/4; % coord top left corner
box(3) = box(1)*2; box(4) = box(1)*2; % croped im size col, row

test_ims = cell(num_train,1); %test im cell array
for idx = 1:num_train
   test_ims{idx} = imcrop(imread(dir_train(idx).name),box);   
end
%% Create the filter bank to be used
[fb] = fbCreate(8,1,2,sqrt(2),2); 
% to match pattern sizes, use only larger filters from 4 to 7? 
% no more than 8 orientations needed, they start repeating themselves

% Show im w/ all the filters that are being used
numFilFilt = size(fb,1);
numColFilt = size(fb,2);
filtros = fb(:);
figure()
for  idx = 1:numFilFilt*numColFilt;
    subplot(numFilFilt, numColFilt,idx);
    imshow(filtros{idx},[-0.1 0.1]); axis off;
end

%% Train Model: Create texton dictionary
% Apply filters to train ims
% Create normalized hists based on responses to filters
% Compute textons from norm hists

%% Classify 
% Apply filters to test ims
% Create normalized hists based on responses to filters
% Meassure distance between ims and textons

%% Evaluate 
% Create confussion matrix (category names are in names.txt file)
% Calculate ACA
