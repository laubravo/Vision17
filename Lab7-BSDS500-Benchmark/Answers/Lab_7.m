%% Lab 7 
% Code taken from bench_fast by Pablo Arbeláez

addpath(fullfile('bench_fast','benchmarks'))
clear all;close all;clc;

%% Define dirs
% remember that they are incomplete, they need the specific train, test and
% val folders
imgDir = fullfile('BSDS500','data_prueba','images_prueba','train'); %ims
gtDir = fullfile('BSDS500','data_prueba','groundTruth_prueba','train'); %GT
inDir = fullfile('BSDS500','segs_prueba','train'); % segs
outDir = fullfile('eval','test_prueba','train'); %out results
mkdir(outDir);
nthresh = 99;

%% Segment images
% Define parameters for segmentation:
feat_space = {'rgb','lab+xy'};
clust_method = {'k-means', 'gmm'};

for me = 1:length(clust_method)
    mkdir(fullfile(inDir,clust_method{me}));
    ims = dir(fullfile(imgDir,'*.jpg'));
    num_ims = numel(ims);
    
    for idx = 1:num_ims;
        current_file = ims(idx).name;
        current_im = imread(fullfile(imgDir,current_file));
        
        % Variar el num de clusters
        los_ks = [3 4 5 7 9]; % hacemos num relativo de esto?
%         los_ks = [3 4];
        segs = cell(1,length(los_ks)); % inicializar segs
        
        for k_actual = 1:length(los_ks)
            segs{1,k_actual} = segmentByClustering(current_im, feat_space{me}, clust_method{me}, los_ks(k_actual));
        end
        save([fullfile(inDir,clust_method{me},current_file(1:end-3)),'mat'],'segs'); 
    end
    %% Evaluate segmentation
tic;
allBench_fast(imgDir, gtDir, fullfile(inDir,clust_method{me}), outDir, nthresh);
toc;
end




