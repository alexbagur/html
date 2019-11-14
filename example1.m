% Create dataset and html page summary
clear; clc; close all

peppers = imread('peppers.png');
outDir = 'peppers-dataset';

stepx = size(peppers,1)/4;
stepy = size(peppers,2)/4;
tilesx = 1:stepx:size(peppers,1);
tilesy = 1:stepy:size(peppers,2);

% tile image
ct=1;
for ii=1:numel(tilesx)
    for jj=1:numel(tilesy)
        
        dir_ii = [outDir filesep sprintf('%02d',ct)];
        mkdir(dir_ii)
        
        im1=peppers(tilesx(ii):tilesx(ii)+stepx-1,tilesy(jj):tilesy(jj)+stepy-1,:);
        imwrite(im1,[dir_ii filesep 'imgA.png'])
        
        im1_edge = edge(rgb2gray(im1));
        imwrite(im1_edge,[dir_ii filesep 'imgB.png'])
        
        ct = ct+1;
    end
end

HtmlPage(outDir)
