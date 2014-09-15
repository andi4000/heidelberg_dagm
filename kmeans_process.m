% Adam Coates' code, modified for DAGM
%

clear all;
close all;

note = ['trying UFL with Kmeans'];

system('mkdir -p profiler');
PROFILER_DIR = [pwd '/profiler/'];
TIMESTAMP_BEGINNING = datestr(now, 'yyyy.mm.dd-HH.MM');

system('mkdir -p results');
recapFilename = ['result_recap_' TIMESTAMP_BEGINNING '.txt'];
recapFile = [pwd '/results/' recapFilename];
recapFileID = fopen(recapFile, 'w');

%for recapFile
[tmp,gitCommitID] = system('git rev-parse HEAD');
clear tmp;

fprintf('############## Unsupervised Feature Learning Trial WITH KMEANS\n');
fprintf('############## Beginning time: %s\n', TIMESTAMP_BEGINNING);

% profile on
time_begin = tic;

DATA_DIR = '../../dataset_for_matlab/';
IMG_DIM = [512 512];

separateTestFromTrain = true;
numTestData = 100; %TODO: should be percentage of the total data available?




%% Configuration
rfSize = 16;
patchStride = [8 8];
numCentroids=1600;
whitening=true;
numPatches = 400000;

% adding external functions
addpath minFunc;
addpath im2colstep;

%for recapFile
fprintf(recapFileID, '##### KMEANS Trial at %s\n', TIMESTAMP_BEGINNING);
fprintf(recapFileID, 'File name: %s.m\n', mfilename);
fprintf(recapFileID, 'Git commit ID: %s\n', gitCommitID);
fprintf(recapFileID, 'Note = \n%s\n\n', note);
fprintf(recapFileID, 'separateTestFromTrain = %d\n', separateTestFromTrain);
fprintf(recapFileID, 'numTestData = %d\n', numTestData);
fprintf(recapFileID, 'numCentroids = %d\n', numCentroids);
fprintf(recapFileID, 'numPatches = %d\n', numPatches);
fprintf(recapFileID, 'numDefPatches = %d\n', numDefPatches);
fprintf(recapFileID, 'numNDefPatches = %d\n\n', numNDefPatches);
fprintf(recapFileID, 'rfSize = %d\n', rfSize);
fprintf(recapFileID, 'patchStride = [%d %d]\n\n', patchStride(1), patchStride(2));
fprintf(recapFileID, 'whitening = %d\n', whitening);


fprintf('loading dataset . . .\n');
time_loading = tic;

%%% loading class 01
f1 = load([DATA_DIR 'dagm2007_class01_ndef.mat']);
f11 = load([DATA_DIR 'dagm2007_class01_def.mat']);
f11b = load([DATA_DIR 'dagm2007_class01_def_rot90.mat']);
f11c = load([DATA_DIR 'dagm2007_class01_def_rot180.mat']);
f11d = load([DATA_DIR 'dagm2007_class01_def_rot270.mat']);

fprintf('### Loading took %.2f s.\n', toc(time_loading));

trainX = [f1.data; f11.data; f11b.data; f11c.data; f11d.data];
trainY = double([f1.label; f11.label; f11b.label; f11c.label; f11d.label]);

% dirty hack --> this is struct of array. should be array of structs
defectPos.a = [ zeros(size(f1.data,1),1); ...
    f11.defectPos.semiMajorAxis; ...
    f11b.defectPos.semiMajorAxis; ...
    f11c.defectPos.semiMajorAxis; ...
    f11d.defectPos.semiMajorAxis ];
defectPos.b = [ zeros(size(f1.data,1),1); ...
    f11.defectPos.semiMinorAxis; ... 
    f11b.defectPos.semiMinorAxis; ... 
    f11c.defectPos.semiMinorAxis; ... 
    f11d.defectPos.semiMinorAxis ];
defectPos.phi = [ zeros(size(f1.data,1),1); ...
    f11.defectPos.rotationAngle; ...
    f11b.defectPos.rotationAngle; ...
    f11c.defectPos.rotationAngle; ...
    f11d.defectPos.rotationAngle ];
defectPos.x = [ zeros(size(f1.data,1),1); ...
    f11.defectPos.ellipsoidCenterX; ...
    f11b.defectPos.ellipsoidCenterX; ...
    f11c.defectPos.ellipsoidCenterX; ...
    f11d.defectPos.ellipsoidCenterX ];
defectPos.y = [ zeros(size(f1.data,1),1); ...
    f11.defectPos.ellipsoidCenterY; ...
    f11b.defectPos.ellipsoidCenterY; ...
    f11c.defectPos.ellipsoidCenterY; ...
    f11d.defectPos.ellipsoidCenterY ];

clear f1 f2 f11 f12;
fprintf('data length = %d\n', size(trainX,1));

fprintf(recapFileID, 'data length = %d\n\n', size(trainX,1));

%%% Extracting test data from training data begin
if separateTestFromTrain
    fprintf('separating %d test data from training data . . .\n', numTestData);

    testX = zeros(numTestData, size(trainX,2));
    testY = zeros(numTestData, size(trainY,2));

    randomIdxs = randperm(size(trainX,1), numTestData);

    % copying the data
    testX = trainX(randomIdxs,:);
    testY = trainY(randomIdxs,:);

    % remove original rows
    trainX(randomIdxs,:) = [];
    trainY(randomIdxs,:) = [];
    
    % dirty hack
    defectPos.a(randomIdxs) = [];
    defectPos.b(randomIdxs) = [];
    defectPos.phi(randomIdxs) = [];
    defectPos.x(randomIdxs) = [];
    defectPos.y(randomIdxs) = [];
end
%%% extracting end

time_patching = tic;
patches = zeros(numPatches, rfSize*rfSize);

% to reduce computation cost --> TODO: is this correct? if yes why OP
% didn't do this
% rr = random('unid', IMG_DIM(1) - rfSize + 1, numPatches);
% cc = random('unid', IMG_DIM(2) - rfSize + 1, numPatches);
% xx = random('unid', size(trainX, 1), numPatches);

%%% Extracting random patches from random images to obtain dictionary
countD = 0;
countND = 0;
for i=1:numPatches
    if (mod(i,1000) == 0) fprintf('extracting patch %d of %d\n', i, numPatches); end
    if (mod(i,50000) == 0) fprintf('### Time elapsed since beginning: %.2f m.\n', toc(time_begin)/60); end
    
    c = 0;
    r = 0;
    while (c == 0 && r == 0)
        idx = random('unid', size(trainX, 1));
%         trainY(idx)
        if (trainY(idx) == 1 && countND < numNDefPatches)
            countND = countND + 1;
            r = random('unid', IMG_DIM(1) - rfSize + 1);
            c = random('unid', IMG_DIM(2) - rfSize + 1);
            break;
        elseif (trainY(idx) ~= 1 && countD < numDefPatches)
            countD = countD + 1;
            %%% FIXME: get random number within defect area defined by
            %%% ellipse
            % calculating limit areas where defect is
            % px = a*cos(phi) + x% py = a*sin(phi) + y% pkx = a * cos(phi+pi) + x% pky = a * sin(phi+pi) + y% % qx = b*cos(phi+.5*pi) + x% qy = b*sin(phi+.5*pi) + y% qkx = b*cos(phi+1.5*pi) + x% qky = b*sin(phi+1.5*pi) + y
            
            a = defectPos.a(idx);
            b = defectPos.b(idx);
            phi = defectPos.phi(idx);
            x = defectPos.x(idx);
            y = defectPos.y(idx);
            
            xs = [a*cos(phi) + x;
                a * cos(phi+pi) + x;
                b*cos(phi+.5*pi) + x;
                b*cos(phi+1.5*pi) + x];
            ys = [a*sin(phi) + y;
                a * sin(phi+pi) + y;
                b*sin(phi+.5*pi) + y;
                b*sin(phi+1.5*pi) + y];
            
            minxs = floor(min(xs));
            maxxs = ceil(max(xs));
            minys = floor(min(ys));
            maxys = ceil(max(ys));
            
            % limits
            if (minys < 1) minys = 1; end
            if (minxs < 1) minxs = 1; end
            if (maxxs > IMG_DIM(1)) maxxs = IMG_DIM(1); end
            if (maxys > IMG_DIM(2)) maxys = IMG_DIM(2); end
            
            if (maxys - minys > rfSize)
                r = randi([minys maxys-rfSize+1]);
            else
                r = randi([minys maxys]);   % if defect area is smaller than rfSize/window
            end
            
            if (maxxs - minxs > rfSize)
                c = randi([minxs maxxs-rfSize+1]);
            else
                c = randi([minxs maxxs]);
            end
            break;
        end
    end
    
%     r = rr(i);
%     c = cc(i);
%     x = xx(i);
    singlepatch = reshape(trainX(idx,:), IMG_DIM);
    singlepatch = singlepatch(r:r+rfSize-1, c:c+rfSize-1);
    patches(i,:) = singlepatch(:)';
    
    %DEBUG
%     imshow(uint8(reshape(trainX(idx,:),IMG_DIM)));hold on;plot([c c+32-1 c+32-1 c c], [r r r+32-1 r+32-1 r], 'r-');
%     figure;imshow(uint8(reshape(patches(i,:), rfSize, rfSize)));
end
fprintf('### Patching took %.2f s.\n', toc(time_patching));

% clear f1 f2 f11 f12;

% profsave(profile('info'), [PROFILER_DIR 'profile_' TIMESTAMP_BEGINNING]);
% profile off;
% return; %DEBUG: stop execution here

fprintf('saving workspace ws01 before patch normalization..\n');
save([TIMESTAMP_BEGINNING '_ws01_before_patch_normalization.mat'], '-v7.3')


% normalize for contrast
patches = bsxfun(@rdivide, bsxfun(@minus, patches, mean(patches,2)), sqrt(var(patches,[],2)+10));

% whiten
if (whitening)
  C = cov(patches);
  M = mean(patches);
  [V,D] = eig(C);
  P = V * diag(sqrt(1./(diag(D) + 0.1))) * V';
  patches = bsxfun(@minus, patches, M) * P;
end

% run K-means

fprintf('### Time elapsed since beginning: %.2f h.\n', toc(time_begin)/3600);
fprintf('Running Kmeans . . .\n');
time_kmeans = tic;
centroids = run_kmeans(patches, numCentroids, 50);
%show_centroids(centroids, rfSize); drawnow;
fprintf('### Kmeans took %.2f minutes\n', toc(time_kmeans)/60);

fprintf('saving variable ws03 centroids _only_\n');
save([TIMESTAMP_BEGINNING '_ws03_centroids.mat'], 'centroids', '-v7.3');


fprintf('Extracting features . . .\n');
time_feature = tic;
% extract training features
if (whitening)
  trainXC = extract_features_kmeans(trainX, centroids, rfSize, patchStride, IMG_DIM, M,P);
else
  trainXC = extract_features_kmeans(trainX, centroids, rfSize, IMG_DIM);
end
fprintf('### feature extraction took %.2f minutes\n', toc(time_feature)/60);

% standardize data
trainXC_mean = mean(trainXC);
trainXC_sd = sqrt(var(trainXC)+0.01);
trainXCs = bsxfun(@rdivide, bsxfun(@minus, trainXC, trainXC_mean), trainXC_sd);
trainXCs = [trainXCs, ones(size(trainXCs,1),1)];

fprintf('saving workspace ws04 before training svm..\n');
save([TIMESTAMP_BEGINNING '_ws04_before_train_svm.mat'], '-v7.3')

% train classifier using SVM
C = 100;
theta = train_svm(trainXCs, trainY, C);

[val,labels] = max(trainXCs*theta, [], 2);
fprintf('Train accuracy %f%%\n', 100 * (1 - sum(labels ~= trainY) / length(trainY)));
fprintf(recapFileID, 'Train Accuracy %.3f%%\n', 100* (1 - sum(labels ~= trainY) / length(trainY)));

%%%%% TESTING %%%%%
% compute testing features and standardize
if (whitening)
  testXC = extract_features_kmeans(testX, centroids, rfSize, IMG_DIM, M,P);
else
  testXC = extract_features_kmeans(testX, centroids, rfSize, IMG_DIM);
end
testXCs = bsxfun(@rdivide, bsxfun(@minus, testXC, trainXC_mean), trainXC_sd);
testXCs = [testXCs, ones(size(testXCs,1),1)];

% test and print result
[val,labels] = max(testXCs*theta, [], 2);
fprintf('Test accuracy %f%%\n', 100 * (1 - sum(labels ~= testY) / length(testY)));
fprintf(recapFileID, 'Test Accuracy = %.3f%%\n\n', 100 * (1 - sum(labels ~= testY) / length(testY)));

fprintf('### Whole process took %.2f hours.\n', toc(time_begin)/3600);
fprintf(recapFileID, 'Whole process took %.2f hours.\n', toc(time_begin)/3600);
fclose(recapFileID);