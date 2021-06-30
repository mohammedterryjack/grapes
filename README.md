# grapes
image processing project with matlab
![](img/pipeline.jpg)

## More info
Image Processing: 

* Improving image quality (noise, lighting, etc)
	- to remove noise:
		- denoising neural network 
	- To improve contrast:
		- histogram equalisation
	- To improve lighting:
		- Various: (edge_detection, dilated, fill in holes, erode to smooth, binarise, invert, masking) 
* Finding individual grapes 
	- Segmenting grapes in the bunch
		- watershed
	- removing non-grape objects
		- filter objects by size 
* Counting the grapes:
	- connected components analysis
* Finding rotten grapes
	- unsupervised colour clustering


## Future Ideas
- 3D depth prediction from 2D images
- using a camera mounted on a rotatable platform
- by slightly rotating the camera's viewpoint, multiple images of the same object can be obtained to estimate depth (i.e. by noticing relative changes in objects from different perspectives)
