%% Lab 6 - Superpixels
%clear all; 
close all;clc
addpath(fullfile('Lab5Images'));
%% Evaluate methods
% Methodology, take the best seg for all ims (identified by us), and
% compare each method with every color option.
% Load info
im_names = dir(fullfile('Lab5Images','*.jpg'));
gt_names = dir(fullfile('Lab5Images','*.mat'));
the_best = [1,1,1,4,1,5,4,4];
% initialize gt
num_gt = numel(gt_names);
info = cell(num_gt,2);
% for ind = 1:num_gt;
%     actual = load(fullfile('Lab5Images',gt_names(the_best(ind)).name));
%     info{ind,1} = actual.groundTruth{1}.Segmentation;
%     actual = imread(im_names(ind).name);
%     info{ind,2} = actual(:,:,1);
% end
%% Initialize vars
methods = {'k-means', 'gmm', 'hierarchical', 'watershed'};
color_options = {'rgb', 'lab', 'hsv', 'rgb+xy', 'lab+xy', 'hsv+xy'};
num_ims = numel(im_names);
% gt = cell(num_ims,1);
gt = cell(2,1);
%% Fill array of segmentations
% segs = cell(num_ims,length(methods), length(color_options));
segs = cell(2,1,1);
for im = 1:2
    % for im = 1:num_ims
    gt_actual = load(fullfile('Lab5Images',gt_names(im).name));
    gt_actual = gt_actual.groundTruth;
    gt{im} = gt_actual{the_best(im)}.Segmentation;
    num_clusts = max(max(gt{im}));
    %     for method = 1:length(methods)
    for method = 1:1
        %         for co = 1: length(color_options)
        for co = 1:1
            actual_im = imread(im_names(co).name);
            segs{im, method, co} = segmentByClustering(actual_im, color_options{co}, methods{method}, num_clusts);
        end
    end
end
%% Evaluate Segmentation
score = evaluateSegmentation(gt,segs);

