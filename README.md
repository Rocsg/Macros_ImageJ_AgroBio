# Toolsets_PHIV_ImageJ

Use these macros :
* Install Fiji https://imagej.net/software/fiji/

* Generate an arborescence with the corresponding directories :
1_Source
2_CortexRoi
3_CellRoi
5_LacunesIndices

* Install your images in directory 1_Source

* Run the macros from Step_1 to Step_7
To run a macro, drag it into Fiji, then click "Run". When asked, select a random image in the directory 1_Source

Step 1 : for each image appearing, use the polygon tool to draw the stele contour, then type "T", then draw the cortex inside contour, then type T
Step 2 : for each image appearing, use the polygon tool to draw the cortex outside contour, then type T
Step 3 : verify all your contours. Whenever a contour is not good, note the image name (title), and suppress the corresponding roi in 2_Cortex_Roi. When you will run again the previous step, the macro will only ask you to do the contours you removed
Step 4 : automatic segmentation
Step 5 : verify segmentation
Step 6 : for each lacune, click on it, then type "T". When every lacune is clicked, click on the upper left corner of the image, then "T"
Step 7 : verify lacunes. Whenever lacunes are not good, note the image name (title), and suppress the corresponding roi in 3_CellRoi. When you will run again the previous step, the macro will only ask you to do the lacune you removed

