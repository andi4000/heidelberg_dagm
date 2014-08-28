% to rotate defect images so that our system is rotation/angle invariant

% TODO:
% - coordinate label is left out
% - training label is also

DATA_DIR = '../../dataset_for_matlab/';
IMG_DIM = [512 512];

f1 = load([DATA_DIR 'dagm2007_class01_def.mat']);
numImages = size(f1.data,1);

data_rot90 = zeros(numImages, IMG_DIM(1)*IMG_DIM(2));
data_rot180 = zeros(numImages, IMG_DIM(1)*IMG_DIM(2));
data_rot270 = zeros(numImages, IMG_DIM(1)*IMG_DIM(2));

for i=1:numImages
    img = reshape(f1.data(i,:), IMG_DIM);
    
    img_rot90 = rot90(img,1);
    img_rot180 = rot90(img,2);
    img_rot270 = rot90(img,3);
    
    data_rot90(i,:) = reshape(img_rot90, 1, IMG_DIM(1)*IMG_DIM(2));
    data_rot180(i,:) = reshape(img_rot180, 1, IMG_DIM(1)*IMG_DIM(2));
    data_rot270(i,:) = reshape(img_rot270, 1, IMG_DIM(1)*IMG_DIM(2));
end

label = f1.label;

data = data_rot90;
info = 'class01 defect (label 11) rotated 90deg';
save([DATA_DIR 'dagm2007_class01_def_rot90_img_only.mat'], 'data', 'label', 'info');
clear data;

data = data_rot180;
info = 'class01 defect (label 11) rotated 180deg';
save([DATA_DIR 'dagm2007_class01_def_rot180_img_only.mat'], 'data', 'label', 'info');
clear data;

data = data_rot270;
info = 'class01 defect (label 11) rotated 270deg';
save([DATA_DIR 'dagm2007_class01_def_rot270_img_only.mat'], 'data', 'label', 'info');
clear data;
