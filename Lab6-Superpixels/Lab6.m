%% Lab 6 - Superpixels
% clear all; 
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

%%
% Evaluate all the methods
methods = {'k-means', 'gmm', 'hierarchical', 'watershed'};
color_options = {'rgb', 'lab', 'hsv', 'rgb+xy', 'lab+xy', 'hsv+xy'};
num_ims = numel(im_names);
score = zeros(num_ims,numel(color_options),length(methods));


for im = 1:num_gt;
    actual_gt = load(fullfile('Lab5Images',gt_names(the_best(im)).name));
    actual_gt = actual_gt.groundTruth{1}.Segmentation;
    actual_im = imread(im_names(im).name);
    num_clusts = max(max(actual_gt));
    for method = 1:length(methods)
        for co = 1: length(color_options)    
        seg = segmentByClustering(actual_im, color_options{co}, methods{method}, num_clusts);
        score(im, co, method) = sum(and(seg,actual_gt))/sum(or(seg,actual_gt));
        end
    end
end







