function [ score ] = evaluateSegmentation( gt, seg, n)
% EVALUATESEGMENTATION for a ground truth matrix GT, in which each object 
%   has a different label number, compares the given segmentation SEG of
%   the largest N objects provided by the GT. 
%   The evaluation method is a Jaccard Index, understood as the area 
%   overlap between SEG and GT for an object divided by the total area.

% SEG is a cell or 3D cell array, whose third dimension corresponds to the
% segmentation of a same image by different methods. 

num_objs = cellfun(@(x) max(max(x)), gt);
% num_objs =  max(num_objs);

boolObj = cell(size(seg,3),1);

for i = 1:numel(boolObj)
boolObj{i} = cellfun(@(x) x==num_objs(i),seg,'UniformOutput',false); %boolean matrix of the same dims as seg.
end



end

