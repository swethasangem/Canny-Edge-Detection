clc;
clear all;
close all;
f = imread('cameraman.tif');
figure;
imagesc(f);colormap(gray);title('Cameraman Image')
image = double(f);
%Step 1: Gaussian Smoothing
%Edge Detection Parameter 1 - Standard Deviation for Gaussian Filter
sigma = 1; 
fSize = 3;
%Generating the gaussian filter
gauss_filter = fspecial('gaussian', fSize, sigma);
%Gaussian Filtering for smoothing
[U,S,V] = svd(gauss_filter);
gauss_v = U(:,1) * sqrt(S(1,1));
gauss_h = V(:,1)' * sqrt(S(1,1));
%Vertical Convolution
image_gv = conv2(image, gauss_v, 'same');
%Horizontal Convolution
image_smoothed = conv2(image_gv, gauss_h, 'same');
figure;
imagesc(image_smoothed);colormap(gray);title('Gaussian Smoothed image sigma=3')
%Step 2: Find Gradients in Vertical and Horizontal direction using Sobel Filter
sobel_v = [-1, 0, 1; -2, 0, 2; -1, 0, 1];
sobel_h = sobel_v';
%Vertical Convolution using Sobel V
image_grad_v = conv2(image_smoothed, sobel_v, 'same');
%Horizontal Convolution using Sobel H
image_grad_h = conv2(image_smoothed, sobel_h, 'same');
%Step 3: Find magnitude and orientation of gradient 
grad_mag = hypot(image_grad_h, image_grad_v);
grad_dir = atan2(image_grad_h, image_grad_v);
%Converting to degrees
grad_dir = rad2deg(grad_dir);
disp(grad_dir(grad_dir > 180))
%Shifting negative angles to positive
grad_dir(grad_dir < 0) = grad_dir(grad_dir < 0) + 180;

[M, N] = size(grad_dir);
grad_dir_adj = zeros(M, N);
%Adjusting gradients angles to nearest 0, 45, 90, or 135 degrees that is
%only 4 directions
for i = 1 : M    
    for j = 1 : N        
        if (((grad_dir(i, j) >= 0 ) && (grad_dir(i, j) < 22.5)) || (grad_dir(i, j) >= 157.5))  %horizontal direction          
            grad_dir_adj(i, j) = 0;        
        elseif ((grad_dir(i, j) >= 22.5) && (grad_dir(i, j) < 67.5) ) %positive diagonal           
            grad_dir_adj(i, j) = 45;        
        elseif ((grad_dir(i, j) >= 67.5 && grad_dir(i, j) < 112.5)) %vertical direction           
            grad_dir_adj(i, j) = 90;        
        elseif ((grad_dir(i, j) >= 112.5 && grad_dir(i, j) < 157.5)) %negative diagonal           
            grad_dir_adj(i, j) = 135;        
        end    
    end
end
%Step 4: Non-maximum suppression
%If current pixel is greater than both of its neighbors then we keep it. 
% Thus we get thinner edges.
image_suppressed = zeros(M,N);
for i = 2:M-1        
    for j = 2:N-1                
        if (grad_dir_adj(i,j)==0) %In the angle of zero degrees                       
            value = max(grad_mag(i,j+1) , grad_mag(i,j-1));                
        elseif (grad_dir_adj(i,j)==45) %In the angle of 45 degrees                        
            value = max(grad_mag(i+1,j+1), grad_mag(i-1,j-1));                
        elseif (grad_dir_adj(i,j)==90) %In the angle of 90 degrees                        
            value = max(grad_mag(i+1,j), grad_mag(i-1,j));                
        elseif (grad_dir_adj(i,j)==135) %In the angle of 135 degrees                        
            value = max(grad_mag(i+1,j-1), grad_mag(i-1,j+1));                
        end
        if grad_mag(i,j) >=value
            image_suppressed(i,j) = grad_mag(i,j);
        end
    end
end
figure, imshow(image_suppressed); title('Image before Thresolding');
%Step 5: Hysteresis
%Value for Thresholding
Low_Thres = 0.004; High_Thres = 0.0685;
max_value = max(max(image_suppressed));
%Calculating Thresholds from max value of suppressed image 
Low_Thres = Low_Thres * max_value ;
High_Thres = High_Thres * max_value ;
edges = zeros (M,N);
for i = 2  : M-1
    for j = 2 : N-1
        if (image_suppressed(i, j) < Low_Thres)
            edges(i, j) = 0;
        elseif (image_suppressed(i, j) > High_Thres)
            edges(i, j) = 1;
        elseif ( image_suppressed(i+1,j)>High_Thres || image_suppressed(i-1,j)>High_Thres || image_suppressed(i,j+1)>High_Thres || image_suppressed(i,j-1)>High_Thres || image_suppressed(i-1, j-1)>High_Thres || image_suppressed(i-1, j+1)>High_Thres || image_suppressed(i+1, j+1)>High_Thres || image_suppressed(i+1, j-1)>High_Thres)
            edges(i,j) = 1;
        end
    end
end
edge_final = uint8(edges);
%Show final edge detection result
figure, imshow(edges); title('MyCanny Image');

%Comparing to Matlab 'Canny' function
edge_matlab = edge(image, 'Canny');
figure, imshow(edge_matlab); title('MATLAB Canny Image');

