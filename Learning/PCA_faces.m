close all;
clear;
% clc;

% dir_path      = 'C:/Users/User/Desktop/gal/Technion/project/data_base';
dir_path      = 'C:\Users\Oryair\OneDrive\Technion\PHD\Projects\GalProject\data_base\';
images_number = 5000; %5749 images at most
image_size    = 50;
Files         = rdir([dir_path, '*\*.jpg']);
matrix        = zeros(image_size * image_size, images_number);

for ii = 1 : images_number
    mImage       = double( imread(Files(ii).name) ) / 255;
    mImage       = rgb2gray(mImage);
    small_image  = imresize(mImage,[image_size,image_size]); %-- original size 250x250, 3D to 2D
    matrix(:,ii) = small_image(:);
end

%% PCA:
mMean   = mean(matrix, 2);
new_mat = matrix - mMean;
[U,S,V] = svd(new_mat); 

for k=1:10
    figure(k)
    Uk =reshape(U(:,k), image_size, image_size);
    imshow(Uk, []);
end

%%
D  = 5;
mB = U(:,1:D);
mP = mB' * matrix;

mR = mB * mP;
figure;
for ii = 1 : 6
    subplot(2,3,ii); imshow(reshape(mR(:,ii), 50 ,[]), [])
end