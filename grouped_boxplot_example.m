%create random vector
x = rand(100,1) 

%specify number of bins
nbins = 10

%convert continous vector into vector of categories based on number of bins
[y, e] = discretize(x,nbins)

%compute bin width and subtract a significant digit because only left edge
%is included in each bin except for last
binwidth = e(2) - e(1) - 0.01

%compute right edge values
rightedges= e(1:nbins) + binwidth

%create edge labels
rightedgelabels = arrayfun(@num2str, rightedges, 'UniformOutput', 0)
leftedgelabels = arrayfun(@num2str, e(1:nbins), 'UniformOutput', 0)
%combine left and right edge labels into final edge label for box plot
labels = leftedgelabels + "-" + rightedgelabels

figure()
boxplot(x,y,'Labels',labels)