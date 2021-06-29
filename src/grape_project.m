network = denoisingNetwork('dncnn');

colour_image = imread('grapes/18.jpg');
%imshow(colour_image)

small_image = imresize(colour_image,.2);
%imshow(small_image)

grey_image = rgb2gray(small_image);
%imshow(grey_image)

clean_grey_image = denoiseImage(grey_image,network);
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
imshow(clean_binary_image)



[B,L] = bwboundaries(clean_binary_image,'noholes');
imshow(label2rgb(L,@jet,[.5 .5 .5]))
hold on
for k = 1:length(B)
  boundary = B{k};
  plot(boundary(:,2),boundary(:,1),'w','LineWidth',2)
end

mask = clean_binary_image;
masked_image = bsxfun(@times, small_image, cast(mask, 'like', small_image));
%imshow(masked_image)
