# Toolsets_PHIV_ImageJ

Update 2023 05 10 : 
* split the first step in two steps. 
* replace the "asROI paola trick" by explicit computation of magnification.
* Add a beanshell command to automatically generate the csv. It generates a CSV at the end, right into the main folder of your experiment. Warning, tt works only with some filename formats. Sylvie's is : 4_M_I_3_a.tif , and Paola's is 4_A2SB_10.tif . 
Interested in another file name formats ? Just write it down in the Step9 macro (ask to Romain).


# How to Install these macros :
* Clone this repo (with git clone for example, or click on the green button <Code>, and then "Download zip", then extract the contents in a folder). 

* Install Fiji https://imagej.net/software/fiji/

* Install the plugin MorpholibJ. To that end, click in Fiji : Help > Update > and look for IJPB-plugins. Click on it, then on close, then apply. Then reboot Fiji

* Install the plugin ImageJ-ITK. To that end, click in Fiji : Help > Update > and look for ImageJ-ITK. Click on it, then on close, then apply. Then reboot Fiji

* Install the plugin Fijiyama. To that end, click in Fiji : Help > Update > then click on the button Add update site, and fill the fields : URL = https://sites.imagej.net/Fijiyama , name= whatever, then check the associated checkbox.

  
# How to prepare your data :
Prepare a directory with the images in it, you can name it "EXP_BLABLA_SOURCE" for example. Prepare another directory "EXP_BLABLA_PROCESSING" 
Read the visual documentation to get insight into what is expected :
https://docs.google.com/presentation/d/1a5TaaGw8HTw9fF8RFuSiIiY4MgWnfN1NRYTF6sZfZyc/edit?usp=sharing

# How to Run these macros :
* Run the macros from Step_0 to Step_9. To run a macro, drag-slide it into Fiji, then click "Run". When asked, select a random image in the directory 1_Source

* Step 0 : Setup the directory (indicate the source directory, then the processing directory
* Step 1 : for each image appearing, use the polygon tool to draw a line joining the centers of the endoderm cells, then type "T" 
* Step 2 : for each image appearing, use the polygon tool to draw the cortex outside contour, then type T
* Step 3 : Automatic computation of the remaining needed contours. Just run it.
* Step 4 : verify all your contours. Whenever a contour is not good, note the image name (title), and suppress the corresponding roi in 2_Cortex_Roi. When you will run again the previous step, the macro will only ask you to do the contours you removed
* Step 5 : automatic segmentation. Just wait and see
* Step 6 : verify segmentation
* Step 7 : for each lacune, click on it, then type "T". When every lacune is clicked, click on the upper left corner of the image, then "T". If you mistake a lacune, click on it, then type "T", and it is not anymore a lacune.
* Step 8 : verify lacunes. Whenever lacunes are not good, note the image name (title), and suppress the corresponding roi in 3_CellRoi. When you will run again the previous step, the macro will only ask you to do the lacune you removed
* Step 9 : compute the summary. Just run the macro as the previous ones. It generates a CSV at the end, right into the main folder of your experiment. It works only with some filename formats. Sylvie's is : 4_M_I_3_a.tif , and Paola's is 4_A2SB_10.tif . 

Interested in another file name formats ? Just write it down in the Step9 macro (ask to Romain)



# How to update a dataset from V1 to V2 :

* Changes 2_CortexROI to 2_AreaROI
* Modify 5_LacunesIndices to 4_LacunesIndices
* Make a backup copy of the raw data: copy the 1_Source folder into a 0_Raw folder
* Edit pathProcessing in ImageJ/Macro : 
   -> for pathSource.txt, enter the path to the 0_Raw folder
   -> for pathProcessing.txt, specify the parent folder

* Script 1 does not need to be used, it is just used to build the contour_endoderm intermediate object. If the experiment went well, the two target objects have already been generated (cortex_in and stele_out).

* We run script 4 to check all the cortexes and stele. For each one that looks a bit odd, we note the name of the specimen, then we delete the file 2_AreaRoi/blabla_stele_out.zip, then we run Script_1 again to generate the corresponding endoderm, then Script_3 to calculate the cortex_in and stele_out, then we run Script 4 again to check.

* If any contours have been modified (particularly cortex_in), delete 3_CellRoi/blabla.zip, and run Script 5 again, which will recalculate the segmentation. In all cases, running Script 5 will allow you to calculate convex-hulls, which were not present in version 1 (operations carried out before June 2023). 

* cortex_hull must be generated




