# Canny-Edge-Detection
This repository contains MATLAB code for performing Canny edge detection on an input image. Canny edge detection is a widely used technique in computer vision and image processing to identify edges in digital images.

## Technical Details

### Input Image
- The input image is loaded from the file 'cameraman.tif' using the `imread` function.

### Step 1: Gaussian Smoothing
- Gaussian smoothing is applied to the input image using a Gaussian filter with a specified standard deviation (sigma) and filter size (fSize).
- The Gaussian filter is generated using `fspecial('gaussian', fSize, sigma)`.
- The image is convolved with the Gaussian filter in both vertical and horizontal directions to perform smoothing.

### Step 2: Sobel Edge Detection
- The Sobel filter is used to compute gradients in both the vertical and horizontal directions.
- Vertical and horizontal convolutions are applied to the smoothed image using the Sobel filters.

### Step 3: Gradient Magnitude and Direction
- Gradient magnitude and direction are calculated using the computed vertical and horizontal gradients.
- Gradient directions are adjusted to one of four possible angles: 0, 45, 90, or 135 degrees.

### Step 4: Non-maximum Suppression
- Non-maximum suppression is performed to thin the detected edges.
- For each pixel, the gradient magnitude is compared with its neighbors along the gradient direction, and only the maximum values are retained.

### Step 5: Hysteresis Thresholding
- Hysteresis thresholding is applied to classify edges as strong or weak.
- Two threshold values, Low_Thres and High_Thres, are calculated based on the maximum value of the suppressed image.
- Pixels with gradient magnitudes above High_Thres are classified as strong edges.
- Weak edges are pixels with gradient magnitudes between Low_Thres and High_Thres, but they are retained if they are connected to strong edges.
- The final edge map is generated based on the thresholding results.

### Result Comparison
- The final edge detection result is displayed alongside the result obtained using MATLAB's built-in 'Canny' function for comparison.

## Usage
- To use this code, make sure you have MATLAB installed.
- Open the MATLAB environment and run the provided script.
- Ensure that the 'cameraman.tif' image is in the same directory or provide the correct path to your image.

