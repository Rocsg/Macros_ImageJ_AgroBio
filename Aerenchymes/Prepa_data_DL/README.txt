Steps expected : 

1-Make inventory by hand in a csv. Copy the corresponding data in a single Unpacked directory.
Make by hand an All_dir_descriptor.csv with all described directories
---------------------------------------------------------------------------------
EXP_CODENAME  | Nb images | Original source | Author | Date | Dirname_in_unpacked
----0--------------1--------------2------------3-------4-------------5-----------

2-Make a tree to verify the dir names

3-Make a script verify 1 that :
    - opens all_dir.csv and for each line
        - List the N1 images in 1_Source.
        - List the N2 roi in 2_CellArea
        - List the N3 roi in 3_CellRoi
        - List the N4 csv in 4_LacunesIndices
        - Verify that the numbers are ok.

3-Make a script verify 2 that :
    - opens all_dir.csv and for each line
        - if the csv already exists, break
        - Create a csv with the EXP_CODENAME.csv
        - List the N1 images in 1_Source.
        - For each image
            - Check availability of rois
            - If available
                - Open the image, draw the aerenchyme, then add the four roi
                - Open a "getyesno" and collect if this image is ok
            - create a csv line : EXP_CODENAME | Image name | TissueRoi | CellRoi | ClickAR | Tissue Roi AI ready | AR AI ready | 
        - write the csv in CSV_descriptors
    
4-Make a script generate database