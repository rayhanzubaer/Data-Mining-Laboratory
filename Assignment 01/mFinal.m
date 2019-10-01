clc;
clear all;

rootDirectory = 'D:\Education\DataMining\Train and test ETH 80 dataset\TrainETH80data2952\';
src = dir(strcat(rootDirectory, '*.png'));
data = cell(length(src), 3);

for i = 1 : length(src)
    img = imread(strcat(rootDirectory, src(i).name));
    img = rgb2gray(img);
    img = double(img(:));
    
    label = src(i).name;
    label = regexprep(label, '.png', '');
    label = regexprep(label, '-', '');
    label = regexprep(label, '\d', '');
    
    data(i, 1) = cellstr(label);
    data(i, 2) = num2cell(mean(img));
    data(i, 3) = num2cell(std(img));
end

xlswrite('mDataset.xlsx', data);
