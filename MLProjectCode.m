%% Average values for samples that belong to the same patient
% Sets of samples averaged here: 1 and 10; 2 and 68; 3 and 74

%In order to be able to combine two samples into a matrix (N), take them as columns
M = M';

%Replace column 1 by average of itself and column 10
N = [M(:,1) M(:,10)];
O = mean(N','omitnan');
M(:,1) = O';

%Replace column 2 by average of itself and column 68
N = [M(:,2) M(:,68)];
O = mean(N','omitnan');
M(:,2) = O';

%Replace column 3 by average of itself and column 74
N = [M(:,3) M(:,74)];
O = mean(N','omitnan');
M(:,3) = O';

%Return matrix to 77x12553 orientation for further use
M = M';

%Remove remaining columns to keep one per patient
M(74,:) = [];
M(68,:) = [];
M(10,:) = [];

%% Assess amount of missing data

%To count number of NaNs per protein (column) in M:
MVP = sum(isnan(M));

%To calculate for each protein the percentage of patients with no data:
MVP_percent = MVP/77*100;
  
%To count number of proteins for each patient that have NaN:
MVS = sum(isnan(M'))';

%To calculate for each patient the percentage of proteins with no data:
MVS_percent = MVS/12553*100;

%To calculate total number of empty (NaN) cells:
sum_MV = sum(MVP)
percent_MV = sum_MV/966581*100

%% Removing features with large amount of missing values
% Using 10% and 20% as threshold for maximum percentage missing per protein

nrows = size(M,1);

M10 = M(:,sum(isnan(M),1)/nrows*100<10);
M20 = M(:,sum(isnan(M),1)/nrows*100<20);
clear nrows;

%% Impute missing values using k-Nearest Neighbors
% Using k=5 and k=8
% Default distance measure: Euclidean

M10_knn5 = knnimpute(M10',5)';
M10_knn8 = knnimpute(M10',8)';
M20_knn5 = knnimpute(M20',5)';
M20_knn8 = knnimpute(M20',8)';

%% Principal Component Analysis

