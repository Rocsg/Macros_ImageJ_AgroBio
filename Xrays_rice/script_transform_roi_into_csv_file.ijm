// Specify the path to the ROI file
baseRoiPath = "/home/rfernandez/Bureau/A_Test/Aerenchyme/Xrays/Exp_02_2023_sixteen/Specimen_08/Rois/RoiRoots_";  // Replace with the path to your ROI file
imgPath = "/home/rfernandez/Bureau/A_Test/Aerenchyme/Xrays/Exp_02_2023_sixteen/Specimen_08/Img_raw_crop_8b.tif"
baseCsvPath = "/home/rfernandez/Bureau/A_Test/Aerenchyme/Xrays/Exp_02_2023_sixteen/Specimen_08/Coords/coordinates_";
// Iterate over ROI files
for (roiNum = 1; roiNum <= 2; roiNum++) { // Adjust the range as needed
	// Load the ROI
	open(imgPath);
    roiPath = baseRoiPath + roiNum + ".roi";
	roiManager("Open", roiPath);
	roi = roiManager("select", 0);
	
	// Get the coordinates
	Roi.getContainedPoints(xpoints, ypoints);
	pointCounter=lengthOf(xpoints);
	coordinates = newArray();
	str="";	
	for (i = 0; i < pointCounter; i++) {
	    x = xpoints[i];
	    y = ypoints[i];
	    z = Roi.getPointPosition(i);
		str=str+x + "," + y + "," + z + "\n";
	}
	for (i = 0; i < pointCounter; i++) {
	    x = xpoints[i];
	    y = ypoints[i];
	    z = Roi.getPointPosition(i);
	}
	
	// Save as csv
    csvPath = baseCsvPath + roiNum + ".csv";
	File.saveString(str, csvPath);
	roiManager("deselect");
	roiManager("reset");
}