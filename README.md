# grapes
image processing project with matlab
![](counting_grapes.jpg)

## More info
Image Processing: 

1) Improving image quality (noise, lighting, etc)
	to remove noise:
		denoising neural network 
	To improve contrast:
		- histogram equalisation
	To improve lighting:
		- Various: (edge_detection, dilated, fill in holes, erode to smooth, binarise, invert, masking) 
2) Finding individual grapes 
	Segmenting grapes in the bunch
		- watershed
	removing non-grape objects
		- filter objects by size 
3) Counting the grapes:
	- connected components analysis
4) Finding rotten grapes
	- unsupervised colour clustering
	
![](masking_grapes.jpg)
