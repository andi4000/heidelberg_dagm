% DAGM data serialization
% image filenames were changed and sorted
% simple serialization with reshape()
% to unserialize, reshape(class01_ndef(1,:), IMG_DIM)
% reference: CIFAR dataset
clear all;

DATA_DIR = '../../dataset_edited/training/';
IMG_DIM = [512 512];

system('mkdir dataset');

fprintf('getting file name lists . . .\n');
tmp = dir([DATA_DIR, 'class01_ndef*']);
files_class01_ndef = {tmp.name};
tmp = dir([DATA_DIR, 'class02_ndef*']);
files_class02_ndef = {tmp.name};
tmp = dir([DATA_DIR, 'class03_ndef*']);
files_class03_ndef = {tmp.name};
tmp = dir([DATA_DIR, 'class04_ndef*']);
files_class04_ndef = {tmp.name};
tmp = dir([DATA_DIR, 'class05_ndef*']);
files_class05_ndef = {tmp.name};
tmp = dir([DATA_DIR, 'class06_ndef*']);
files_class06_ndef = {tmp.name};
tmp = dir([DATA_DIR, 'class01_def*']);
files_class01_def = {tmp.name};
tmp = dir([DATA_DIR, 'class02_def*']);
files_class02_def = {tmp.name};
tmp = dir([DATA_DIR, 'class03_def*']);
files_class03_def = {tmp.name};
tmp = dir([DATA_DIR, 'class04_def*']);
files_class04_def = {tmp.name};
tmp = dir([DATA_DIR, 'class05_def*']);
files_class05_def = {tmp.name};
tmp = dir([DATA_DIR, 'class06_def*']);
files_class06_def = {tmp.name};


% sorry this is not the best way. quick and dirty
numImages = length(files_class01_ndef);
data = zeros(numImages, IMG_DIM(1)*IMG_DIM(2));
fprintf('processing class01_ndef images\n');
for i=1:numImages
    img = imread( [DATA_DIR files_class01_ndef{i}] );
    img_serialized = reshape(img, 1, IMG_DIM(1)*IMG_DIM(2));
    data(i,:) = img_serialized;
    if (mod(i, 100) == 0) fprintf('\tclass01_ndef: adding image %d of %d images\n', i, numImages); end
end
info = 'class01 non defect (label 1)';
label = zeros(1000,1);
label = uint8(label);
label(:) = 1;
save 'dataset/dagm2007_class01_ndef.mat' data label info;
clear data label info numImages;


numImages = length(files_class02_ndef);
data = zeros(numImages, IMG_DIM(1)*IMG_DIM(2));
fprintf('processing class02_ndef images\n');
for i=1:numImages
    img = imread( [DATA_DIR files_class02_ndef{i}] );
    img_serialized = reshape(img, 1, IMG_DIM(1)*IMG_DIM(2));
    data(i,:) = img_serialized;
    if (mod(i, 100) == 0) fprintf('\tclass02_ndef: adding image %d of %d images\n', i, numImages); end
end
info = 'class02 non defect (label 2)';
label = zeros(1000,1);
label = uint8(label);
label(:) = 2;
save 'dataset/dagm2007_class02_ndef.mat' data label info;
clear data label info numImages;

numImages = length(files_class03_ndef);
data = zeros(numImages, IMG_DIM(1)*IMG_DIM(2));
fprintf('processing class03_ndef images\n');
for i=1:numImages
    img = imread( [DATA_DIR files_class03_ndef{i}] );
    img_serialized = reshape(img, 1, IMG_DIM(1)*IMG_DIM(2));
    data(i,:) = img_serialized;
    if (mod(i, 100) == 0) fprintf('\tclass03_ndef: adding image %d of %d images\n', i, numImages); end
end
info = 'class03 non defect (label 3)';
label = zeros(1000,1);
label = uint8(label);
label(:) = 3;
save 'dataset/dagm2007_class03_ndef.mat' data label info;
clear data label info numImages;

numImages = length(files_class04_ndef);
data = zeros(numImages, IMG_DIM(1)*IMG_DIM(2));
fprintf('processing class04_ndef images\n');
for i=1:numImages
    img = imread( [DATA_DIR files_class04_ndef{i}] );
    img_serialized = reshape(img, 1, IMG_DIM(1)*IMG_DIM(2));
    data(i,:) = img_serialized;
    if (mod(i, 100) == 0) fprintf('\tclass04_ndef: adding image %d of %d images\n', i, numImages); end
end
info = 'class04 non defect (label 4)';
label = zeros(1000,1);
label = uint8(label);
label(:) = 4;
save 'dataset/dagm2007_class04_ndef.mat' data label info;
clear data label info numImages;

numImages = length(files_class05_ndef);
data = zeros(numImages, IMG_DIM(1)*IMG_DIM(2));
fprintf('processing class05_ndef images\n');
for i=1:numImages
    img = imread( [DATA_DIR files_class05_ndef{i}] );
    img_serialized = reshape(img, 1, IMG_DIM(1)*IMG_DIM(2));
    data(i,:) = img_serialized;
    if (mod(i, 100) == 0) fprintf('\tclass05_ndef: adding image %d of %d images\n', i, numImages); end
end
info = 'class05 non defect (label 5)';
label = zeros(1000,1);
label = uint8(label);
label(:) = 5;
save 'dataset/dagm2007_class05_ndef.mat' data label info;
clear data label info numImages;

numImages = length(files_class06_ndef);
data = zeros(numImages, IMG_DIM(1)*IMG_DIM(2));
fprintf('processing class06_ndef images\n');
for i=1:numImages
    img = imread( [DATA_DIR files_class06_ndef{i}] );
    img_serialized = reshape(img, 1, IMG_DIM(1)*IMG_DIM(2));
    data(i,:) = img_serialized;
    if (mod(i, 100) == 0) fprintf('\tclass06_ndef: adding image %d of %d images\n', i, numImages); end
end
info = 'class06 non defect (label 6)';
label = zeros(1000,1);
label = uint8(label);
label(:) = 6;
save 'dataset/dagm2007_class06_ndef.mat' data label info;
clear data label info numImages;

numImages = length(files_class01_def);
data = zeros(numImages, IMG_DIM(1)*IMG_DIM(2));
fprintf('processing class01_def images\n');
for i=1:numImages
    img = imread( [DATA_DIR files_class01_def{i}] );
    img_serialized = reshape(img, 1, IMG_DIM(1)*IMG_DIM(2));
    data(i,:) = img_serialized;
    if (mod(i, 10) == 0) fprintf('\tclass01_def: adding image %d of %d images\n', i, numImages); end
end
info = 'class01 defect (label 11), defect area are labeled by ellipsoid defined in defectPos';
label = zeros(150,1);
label = uint8(label);
label(:) = 11;
pos = load('labels_class01_def.txt');
defectPos.semiMajorAxis = pos(:,2);
defectPos.semiMinorAxis = pos(:,3);
defectPos.rotationAngle = pos(:,4);
defectPos.ellipsoidCenterX = pos(:,5);
defectPos.ellipsoidCenterY = pos(:,6);
save 'dataset/dagm2007_class01_def.mat' data label info defectPos;
clear data label info pos numImages defectPos;

numImages = length(files_class02_def);
data = zeros(numImages, IMG_DIM(1)*IMG_DIM(2));
fprintf('processing class02_def images\n');
for i=1:numImages
    img = imread( [DATA_DIR files_class02_def{i}] );
    img_serialized = reshape(img, 1, IMG_DIM(1)*IMG_DIM(2));
    data(i,:) = img_serialized;
    if (mod(i, 10) == 0) fprintf('\tclass02_def: adding image %d of %d images\n', i, numImages); end
end
info = 'class02 defect (label 12), defect area are labeled by ellipsoid defined in defectPos';
label = zeros(150,1);
label = uint8(label);
label(:) = 12;
pos = load('labels_class02_def.txt');
defectPos.semiMajorAxis = pos(:,2);
defectPos.semiMinorAxis = pos(:,3);
defectPos.rotationAngle = pos(:,4);
defectPos.ellipsoidCenterX = pos(:,5);
defectPos.ellipsoidCenterY = pos(:,6);
save 'dataset/dagm2007_class02_def.mat' data label info defectPos;
clear data label info pos numImages defectPos;

numImages = length(files_class03_def);
data = zeros(numImages, IMG_DIM(1)*IMG_DIM(2));
fprintf('processing class03_def images\n');
for i=1:numImages
    img = imread( [DATA_DIR files_class03_def{i}] );
    img_serialized = reshape(img, 1, IMG_DIM(1)*IMG_DIM(2));
    data(i,:) = img_serialized;
    if (mod(i, 10) == 0) fprintf('\tclass03_def: adding image %d of %d images\n', i, numImages); end
end
info = 'class03 defect (label 13), defect area are labeled by ellipsoid defined in defectPos';
label = zeros(150,1);
label = uint8(label);
label(:) = 13;
pos = load('labels_class03_def.txt');
defectPos.semiMajorAxis = pos(:,2);
defectPos.semiMinorAxis = pos(:,3);
defectPos.rotationAngle = pos(:,4);
defectPos.ellipsoidCenterX = pos(:,5);
defectPos.ellipsoidCenterY = pos(:,6);
save 'dataset/dagm2007_class03_def.mat' data label info defectPos;
clear data label info pos numImages defectPos;

numImages = length(files_class04_def);
data = zeros(numImages, IMG_DIM(1)*IMG_DIM(2));
fprintf('processing class04_def images\n');
for i=1:numImages
    img = imread( [DATA_DIR files_class04_def{i}] );
    img_serialized = reshape(img, 1, IMG_DIM(1)*IMG_DIM(2));
    data(i,:) = img_serialized;
    if (mod(i, 10) == 0) fprintf('\tclass04_def: adding image %d of %d images\n', i, numImages); end
end
info = 'class04 defect (label 14), defect area are labeled by ellipsoid defined in defectPos';
label = zeros(150,1);
label = uint8(label);
label(:) = 14;
pos = load('labels_class04_def.txt');
defectPos.semiMajorAxis = pos(:,2);
defectPos.semiMinorAxis = pos(:,3);
defectPos.rotationAngle = pos(:,4);
defectPos.ellipsoidCenterX = pos(:,5);
defectPos.ellipsoidCenterY = pos(:,6);
save 'dataset/dagm2007_class04_def.mat' data label info defectPos;
clear data label info pos numImages defectPos;


numImages = length(files_class05_def);
data = zeros(numImages, IMG_DIM(1)*IMG_DIM(2));
fprintf('processing class05_def images\n');
for i=1:numImages
    img = imread( [DATA_DIR files_class05_def{i}] );
    img_serialized = reshape(img, 1, IMG_DIM(1)*IMG_DIM(2));
    data(i,:) = img_serialized;
    if (mod(i, 10) == 0) fprintf('\tclass05_def: adding image %d of %d images\n', i, numImages); end
end
info = 'class05 defect (label 15), defect area are labeled by ellipsoid defined in defectPos';
label = zeros(150,1);
label = uint8(label);
label(:) = 15;
pos = load('labels_class05_def.txt');
defectPos.semiMajorAxis = pos(:,2);
defectPos.semiMinorAxis = pos(:,3);
defectPos.rotationAngle = pos(:,4);
defectPos.ellipsoidCenterX = pos(:,5);
defectPos.ellipsoidCenterY = pos(:,6);
save 'dataset/dagm2007_class05_def.mat' data label info defectPos;
clear data label info pos numImages defectPos;


numImages = length(files_class06_def);
data = zeros(numImages, IMG_DIM(1)*IMG_DIM(2));
fprintf('processing class06_def images\n');
for i=1:numImages
    img = imread( [DATA_DIR files_class06_def{i}] );
    img_serialized = reshape(img, 1, IMG_DIM(1)*IMG_DIM(2));
    data(i,:) = img_serialized;
    if (mod(i, 10) == 0) fprintf('\tclass06_def: adding image %d of %d images\n', i, numImages); end
end
info = 'class06 defect (label 16), defect area are labeled by ellipsoid defined in defectPos';
label = zeros(150,1);
label = uint8(label);
label(:) = 16;
pos = load('labels_class06_def.txt');
defectPos.semiMajorAxis = pos(:,2);
defectPos.semiMinorAxis = pos(:,3);
defectPos.rotationAngle = pos(:,4);
defectPos.ellipsoidCenterX = pos(:,5);
defectPos.ellipsoidCenterY = pos(:,6);
save 'dataset/dagm2007_class06_def.mat' data label info defectPos;
clear data label info pos numImages defectPos;
