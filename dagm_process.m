% processing DAGM matlab dataset
% reference: A. Coates' sc_vq_demo.m

clear all;
close all;

time_begin = tic;

DATA_DIR = '../../dataset_for_matlab/';
IMG_DIM = [512 512];

addpath minFunc;

fprintf('loading dataset . . .\n');
time_loading = tic;
f1 = load([DATA_DIR 'dagm2007_class01_ndef.mat']);
f2 = load([DATA_DIR 'dagm2007_class02_ndef.mat']);
f11 = load([DATA_DIR 'dagm2007_class01_def.mat']);
f12 = load([DATA_DIR 'dagm2007_class02_def.mat']);
fprintf('### Loading took %.2f s.\n', toc(time_loading));

%%% 150 defect and 150 non defect data for once.
trainX = [f1.data(1:150,:); f2.data(1:150,:); f11.data; f12.data];
trainY = double([f1.label(1:150,:); f2.label(1:150,:); f11.label; f12.label]);

clear f1 f2 f11 f12;
fprintf('data length = %d\n', size(trainX,1));

%%% Extracting test data from training data begin
fprintf('separating test data from training data . . .\n');
numTestData = 100;

testX = zeros(numTestData, size(trainX,2));
testY = zeros(numTestData, size(trainY,2));

randomIdxs = randperm(size(trainX,1), numTestData);

% copying the data
testX = trainX(randomIdxs,:);
testY = trainY(randomIdxs,:);

% remove original rows
trainX(randomIdxs,:) = [];
trainY(randomIdxs,:) = [];

%%% extracting end

%%% RESULTS
%%% 01
% train accuracy 97%
% test accuracy 51%
% numBases 1600
% numPatches 50000 (50k)
% rfSize 32

%%% 02
% train accuracy 100%
% test accuracy 53%
% numBases 1600
% *numPatches 800k
% rfSize 32

%%% 03 --> computation time was too long
% train acc.
% test acc. 
% *numBases 3200
% numPatches 800k
% rfSize 32

%%% 04
% train acc.
% test acc.
% *numBases 2400
% numPatches 800k
% rfSize 32

% Parameters
numBases = 2400          % number of features
numPatches = 800000        % with 50k, train accuracy 97% testing accuracy 51%
rfSize = 32            % receptive field size (window size)
%TODO: stride is currently 1 px

alpha = 0.25  %% CV-chosen value for soft-threshold function.
lambda = 1.0  %% CV-chosen sparse coding penalty.

encoder='thresh' 
encParam=alpha %% Use soft threshold encoder.

L = 0.01 % SVM param

time_patching = tic;
patches = zeros(numPatches, rfSize*rfSize);
for i=1:numPatches
    if (mod(i,1000) == 0) fprintf('extracting patch %d of %d\n', i, numPatches); end
    if (mod(i,50000) == 0) fprintf('### Time elapsed since beginning: %.2f m.\n', toc(time_begin)/60); end
    r = random('unid', IMG_DIM(1) - rfSize + 1);
    c = random('unid', IMG_DIM(2) - rfSize + 1);
    x = random('unid', size(trainX, 1));
    singlepatch = reshape(trainX(x,:), IMG_DIM);
    singlepatch = singlepatch(r:r+rfSize-1, c:c+rfSize-1);
    patches(i,:) = singlepatch(:)';
end
fprintf('### Patching took %.2f h.\n', toc(time_patching)/3600);

% normalize for contrast
patches = bsxfun(@rdivide, bsxfun(@minus, patches, mean(patches,2)), sqrt(var(patches,[],2)+10));

% ZCA whitening (with low-pass)
C = cov(patches);
M = mean(patches);
[V,D] = eig(C);
P = V * diag(sqrt(1./(diag(D) + 0.1))) * V';
patches = bsxfun(@minus, patches, M) * P;

save -v7.3 before_omp1.mat

% run training
time_omp1 = tic;
fprintf('### Time elapsed since beginning: %.2f h.\n', toc(time_begin)/3600);
fprintf('Running OMP1 . . .\n');
dictionary = run_omp1(patches, numBases, 50);
fprintf('### OMP1 took %.2f m.\n', toc(time_omp1)/60);

% show results of training
% fprintf('Showing centroids . . .\n');
% show_centroids(dictionary * 5, rfSize); drawnow;

% extract training features
time_feature = tic;
fprintf('### Time elapsed since beginning: %.2f h.\n', toc(time_begin)/3600);
fprintf('Extracting training features . . .\n');
trainXC = extract_features(trainX, dictionary, rfSize, ...
                           IMG_DIM, M,P, encoder, encParam);
%clear trainX;
fprintf('### Extracting training features took %.2f h.\n', toc(time_feature)/3600);

% standardize data
fprintf('\nStandardizing data . . .\n');
trainXC_mean = mean(trainXC);
trainXC_sd = sqrt(var(trainXC)+0.01);
trainXCs = bsxfun(@rdivide, bsxfun(@minus, trainXC, trainXC_mean), trainXC_sd);
%clear trainXC;
trainXCs = [trainXCs, ones(size(trainXCs,1),1)]; % intercept term

save -v7.3 before_train_svm.mat;

% train classifier using SVM
fprintf('### Time elapsed since beginning: %.2f h.\n', toc(time_begin)/3600);
fprintf('Training classifier using SVM . . .\n');
theta = train_svm(trainXCs, trainY, 1/L);

% test and print results
[val,labels] = max(trainXCs*theta, [], 2);
fprintf('Train Accuracy %f%%\n', 100* (1 - sum(labels ~= trainY) / length(trainY)));

%%%% TESTING
% compute testing features and standardize
time_features_testing = tic;
fprintf('### Time elapsed since beginning: %.2f h.\n', toc(time_begin)/3600);
testXC = extract_features(testX, dictionary, rfSize, ...
                          IMG_DIM, M,P, encoder, encParam);
%clear testX;
fprintf('### Extracting testing features took %.2f h.\n', toc(time_feature_testing)/3600);

testXCs = bsxfun(@rdivide, bsxfun(@minus, testXC, trainXC_mean), trainXC_sd);
%clear testXC;
testXCs = [testXCs, ones(size(testXCs,1),1)];

% test and print result
[val,labels] = max(testXCs*theta, [], 2);
fprintf('Test accuracy %f%%\n', 100 * (1 - sum(labels ~= testY) / length(testY)));


fprintf('### Whole process took %.2f hours.\n', toc(time_begin)/3600);
