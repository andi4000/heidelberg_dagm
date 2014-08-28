% to rotate defect images so that our system is rotation/angle invariant

% TODO:
% - coordinate label is left out
% - training label is also
clear all;
close all;

DATA_DIR = '../../dataset_for_matlab/';
IMG_DIM = [512 512];

class = 6;
f1 = load([DATA_DIR 'dagm2007_class0' num2str(class) '_def.mat']);
numImages = size(f1.data,1);

data_rot90 = zeros(numImages, IMG_DIM(1)*IMG_DIM(2));
data_rot180 = zeros(numImages, IMG_DIM(1)*IMG_DIM(2));
data_rot270 = zeros(numImages, IMG_DIM(1)*IMG_DIM(2));

k = -0.5*pi;
R90 = [cos(k) -sin(k); sin(k) cos(k)];
k = pi;
R180 = [cos(k) -sin(k); sin(k) cos(k)];
k = 0.5*pi;
R270 = [cos(k) -sin(k); sin(k) cos(k)];

for i=1:numImages
    fprintf('rotating %d of %d\n', i, numImages);
    img = reshape(f1.data(i,:), IMG_DIM);
    
    img_rot90 = rot90(img,1);
    img_rot180 = rot90(img,2);
    img_rot270 = rot90(img,3);

    data_rot90(i,:) = reshape(img_rot90, 1, IMG_DIM(1)*IMG_DIM(2));
    data_rot180(i,:) = reshape(img_rot180, 1, IMG_DIM(1)*IMG_DIM(2));
    data_rot270(i,:) = reshape(img_rot270, 1, IMG_DIM(1)*IMG_DIM(2));
end

label = f1.label;

%debug
img0 = uint8(reshape(f1.data(1,:), IMG_DIM));
img90 = uint8(reshape(data_rot90(1,:), IMG_DIM));
img180 = uint8(reshape(data_rot180(1,:), IMG_DIM));
img270 = uint8(reshape(data_rot270(1,:), IMG_DIM));

%%% transforming ellipse definition
x = f1.defectPos.ellipsoidCenterX'; % for rotation matrix multiplication
y = f1.defectPos.ellipsoidCenterY';

a = f1.defectPos.semiMajorAxis; % this need no transforming
b = f1.defectPos.semiMinorAxis;

phi = f1.defectPos.rotationAngle; % in radian

%%% transforming
fprintf('rotating ellipse definition...\n');
center = [x;y];

center90 = R90 * (center-256) + 256;
center180 = R180 * (center-256) + 256;
center270 = R270 * (center-256) + 256;

x90 = center90(1,:);
y90 = center90(2,:);
x180 = center180(1,:);
y180 = center180(2,:);
x270 = center270(1,:);
y270 = center270(2,:);

phi90 = phi - 0.5*pi;
phi180 = phi - pi;
phi270 = phi - 1.5*pi;

%debug
figure;imshow(img0);hold on;
plotellipse(center(1,1),center(2,1), a(1), b(1), phi(1), 'r');
figure;imshow(img90);hold on;
plotellipse(center90(1,1),center90(2,1), a(1), b(1), phi90(1), 'r');
figure;imshow(img180);hold on;
plotellipse(center180(1,1),center180(2,1), a(1), b(1), phi180(1), 'r');
figure;imshow(img270);hold on;
plotellipse(center270(1,1),center270(2,1), a(1), b(1), phi270(1), 'r');

%%% gathering variables and file writing
fprintf('gathering variables and file writing..\n');
data = data_rot90;
defectPos.ellipsoidCenterX = x90';
defectPos.ellipsoidCenterY = y90';
defectPos.semiMajorAxis = a;
defectPos.semiMinorAxis = b;
defectPos.rotationAngle = phi90;
info = 'class01 defect (label 11) rotated 90deg';
save([DATA_DIR 'dagm2007_class0' num2str(class) '_def_rot90.mat'], 'data', 'label', 'info', 'defectPos');
clear data;

data = data_rot180;
defectPos.ellipsoidCenterX = x180';
defectPos.ellipsoidCenterY = y180';
defectPos.semiMajorAxis = a;
defectPos.semiMinorAxis = b;
defectPos.rotationAngle = phi180;
info = 'class01 defect (label 11) rotated 180deg';
save([DATA_DIR 'dagm2007_class0' num2str(class) '_def_rot180.mat'], 'data', 'label', 'info', 'defectPos');
clear data;

data = data_rot270;
defectPos.ellipsoidCenterX = x270';
defectPos.ellipsoidCenterY = y270';
defectPos.semiMajorAxis = a;
defectPos.semiMinorAxis = b;
defectPos.rotationAngle = phi270;
info = 'class01 defect (label 11) rotated 270deg';
save([DATA_DIR 'dagm2007_class0' num2str(class) '_def_rot270.mat'], 'data', 'label', 'info', 'defectPos');
clear data;
