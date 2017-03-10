function [ score ] = evaluateSegmentation( gt, seg)
% EVALUATESEGMENTATION for a ground truth matrix GT, in which each object 
%   has a different label number, compares the given segmentation SEG of
%   the largest n objects provided by the GT. 
%   The evaluation method is a Jaccard Index, understood as the area 
%   overlap between SEG and GT for an object divided by the total area.

% SEG is a cell or 3D cell array, whose third dimension corresponds to the
% segmentation of a same image in different color spaces. Columns are the 
% different methods and rows are the test images.

% GT is a (num_images, 1)cell array, where the rows are the images.

n = 3; %number of objs to be evaluated in GT

num_objs_gt = cellfun(@(x) max(max(x)), gt);
% num_objs =  max(num_objs);
num_colores = size(seg,3);
score = zeros(numel(gt),size(seg,2),num_colores);

boolObj_gt = cell(size(gt));
for i = 1:length(boolObj_gt)
    for j = 1:num_objs_gt(i)
        %         boolObj_gt{i} = cellfun(@(x) x==j,gt,'UniformOutput',false); %boolean matrix of the same dims as seg.
        boolObj_gt{i}{j} = gt{i} == j;
    end
    % Take the n largest objects
    boolObj_gt{i} = get_largest(boolObj_gt{i,1},n);
    
    for method = 1:size(seg,2)
        % Find the Jaccard index of the largest objects in the segmentation
        sco = cellfun(@(x) JIndex_seg(x,boolObj_gt(i)),seg(i,method,:));    
        score(i,method,:) = reshape(sco, 1, num_colores);
    end
end

    function bObj = get_largest(boolArray, n)
        % GET_LARGEST takes the n largest objects of a boolean cell array
        % boolArray: cell array with the boolean equivalents of each object
        % n: number of largest objects to consider
        num_pixs_obj = cellfun(@(x) sum(sum(x)),boolArray);
        [~,ind_mayores] = sort(num_pixs_obj,'descend'); % num_pixs_obj may be cell = cellfun
        bObj =  boolArray(ind_mayores(1:n));
    end

    function Jacc = JIndex_seg(im_seg, bObj)
        % JINDEX_SEG calculates the jaccard index of a segmentation
        % im_seg is a segmentation for an image whose groundtruth organized
        % as a boolean array of objects is found in bObj.
        s = zeros(length(bObj{1}),1);
        for idx = 1:length(bObj{1})
            % Find the main label in the segmentation
            seg_objects = im_seg(bObj{1}{idx});
            losObjs = unique(seg_objects);
            [~,el_que_importa] =  max(histc(seg_objects, losObjs));
            el_que_importa = losObjs(el_que_importa);
            s(idx) = sum(sum(and(bObj{1}{idx},im_seg == el_que_importa)))/sum(sum(or(bObj{1}{idx},im_seg == el_que_importa)));
        end
        Jacc = mean(s);
    end 

end
