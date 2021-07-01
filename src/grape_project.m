network = denoisingNetwork('dncnn');

colour_image = imread('grapes/18.jpg');
%imshow(colour_image)

small_image = imresize(colour_image,.2);
%imshow(small_image)

grey_image = rgb2gray(small_image);
%imshow(grey_image)

contrasted_image = histeq(grey_image);
%imshow(contrasted_image)

clean_grey_image = denoiseImage(contrasted_image,network);
%imshow(clean_grey_image)

[~,threshold] = edge(clean_grey_image,'sobel');
fuzziness = 0.5;
black_white_image = edge(clean_grey_image,'sobel',threshold * fuzziness);
%imshow(black_white_image)

se90 = strel('line',3,90);
se0 = strel('line',3,0);
bold_image = imdilate(black_white_image,[se90 se0]);
%imshow(bold_image)

filled_image = imfill(bold_image,'holes');
%imshow(filled_image)

%image_mask = imclearborder(filled_image,4);
%imshow(image_mask)

seDiamond = strel('diamond',1);
smooth_filled_image = imerode(filled_image,seDiamond);
%imshow(smooth_filled_image)

binary_image = imbinarize(clean_grey_image);
%imshow(binary_image)

clean_binary_image = bwareaopen(binary_image,30);
%imshow(clean_binary_image)


inverted_image = ~bwareaopen(~clean_binary_image, 10);
%imshow(inverted_image)

network_image = -bwdist(~clean_binary_image);
%imshow(network_image,[])

mask = imextendedmin(network_image,.5);
%imshowpair(clean_binary_image,mask,'blend')

blended_network_image = imimposemin(network_image,mask);
%imshow(blended_network_image,[])

watershed_labels = watershed(blended_network_image);
watershed_image = label2rgb(watershed_labels);
%imshow(watershed_image)

segmented_binary_image = clean_binary_image;
segmented_binary_image(watershed_labels == 0) = 0;
%imshow(segmented_binary_image)

minimum_pixel_size = 500;
maximum_pixel_size = 1500;
grapes_only_image = xor(bwareaopen(segmented_binary_image,minimum_pixel_size),  bwareaopen(segmented_binary_image,maximum_pixel_size));
%imshow(grapes_only_image)

[B,L] = bwboundaries(grapes_only_image,'noholes');
%imshow(label2rgb(L,@jet,[.5 .5 .5]))
hold on
for k = 1:length(B)
  boundary = B{k};
  %plot(boundary(:,2),boundary(:,1),'w','LineWidth',2)
end

masked_image = bsxfun(@times, small_image, cast(grapes_only_image, 'like', small_image));
%imshow(masked_image)

%+++++++LETS COUNT THEM
grapes = bwconncomp(grapes_only_image,4);
grapes.NumObjects

grape_mask = false(size(grapes_only_image));
grape_mask(grapes.PixelIdxList{1}) = true;
% imshow(grape_mask)
healthy_grape_image = bsxfun(@times, small_image, cast(grape_mask, 'like', small_image));
%imshow(healthy_grape_image)

%+++++++ LETS COUNT THE ROTTEN ONES

red = masked_image(:,:,1);
green = masked_image(:,:,2);
blue = masked_image(:,:,3);
rMask = red > 250;
gMask = green < 180;
bMask = blue < 180;
red_object_filter = uint8(rMask & gMask & bMask); 
red_objects_image = zeros(size(red_object_filter),'uint8');
red_objects_image(:,:,1) = masked_image(:,:,1) .* red_object_filter;
red_objects_image(:,:,2) = masked_image(:,:,2) .* red_object_filter;
red_objects_image(:,:,3) = masked_image(:,:,3) .* red_object_filter;
imshow(red_objects_image)

red_image_mask = edge(rgb2gray(red_objects_image),'sobel',threshold * fuzziness);
red_image_mask = imdilate(red_image_mask,[se90 se0]);
red_image_mask = imfill(red_image_mask,'holes');
imshow(red_image_mask)
minimum_pixel_size = 100;
maximum_pixel_size = 600;
red_image_mask = xor(bwareaopen(red_image_mask,minimum_pixel_size),  bwareaopen(red_image_mask,maximum_pixel_size));
%imshow(red_image_mask)

rotten_grapes = bwconncomp(red_image_mask,4);
rotten_grapes.NumObjects

rotten_grapes_image = bsxfun(@times, small_image, cast(red_image_mask, 'like', small_image));
imshow(rotten_grapes_image)
