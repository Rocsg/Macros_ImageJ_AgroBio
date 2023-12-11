// Specify the path to the ROI file
baseRoiPath = "/home/rfernandez/Bureau/A_Test/Aerenchyme/Xrays/Test-02_curve-resampling/High_res/ROIS/pointroi_";  // Replace with the path to your ROI file
imgPath = "/home/rfernandez/Bureau/A_Test/Aerenchyme/Xrays/Test-02_curve-resampling/High_res/SlicesY-2023_12_07_specimen_15_zoom-1.tif"
baseCsvPath = "/home/rfernandez/Bureau/A_Test/Aerenchyme/Xrays/Test-02_curve-resampling/High_res/COORDS/coordinates_";
// Iterate over ROI files
for (roiNum = 1; roiNum <= 14; roiNum++) { // Adjust the range as needed
    roiPath = baseRoiPath + roiNum + ".roi";
    csvPath = baseCsvPath + roiNum + ".csv";
	// Load the ROI
	open(imgPath);
	roiManager("Open", roiPath);
	
	// Get the ROI
	roi = roiManager("select", 0);
	
	// Get the coordinates
	//Roi.getPointPosition(0);
	Roi.getContainedPoints(xpoints, ypoints);
	
	pointCounter=lengthOf(xpoints);
	coordinates = newArray();
	str="";	
	print("gedit coordinates_"+roiNum+".csv");
	for (i = 0; i < pointCounter; i++) {
	    x = xpoints[i];
	    y = ypoints[i];
	    z = Roi.getPointPosition(i);
	    // Adjust for ROI offset
	//    bounds = roi.getBounds();
	//    x += bounds.x;
	//    y += bounds.y;
	
	    // Add coordinates to the array
	    coordinates = Array.concat(coordinates, "" + x + "," + y + "," + z + "");
		str=str+x + "," + y + "," + z + "\n";
	//	str=str+"\n";
	}
	// Output the coordinates
	//print("[");
	for (i = 0; i < pointCounter; i++) {
	    print("" + coordinates[i] + "");
	}
	//print("]");
	
	// Prepare to write to CSV
	//file = File.open(csvPath);
	//File.append("x,y,z", file); // Header for CSV columns
	
	for (i = 0; i < pointCounter; i++) {
	    x = xpoints[i];
	    y = ypoints[i];
	    z = Roi.getPointPosition(i);
	
	    // Write coordinates to CSV
	  //  File.append(x + "," + y + "," + z, file);
	}
	
	//File.append("x,y,z", file); // Header for CSV columns
	File.saveString(str, csvPath);
	//File.close(file);
	close("*");
	roiManager("deselect");
	roiManager("reset");
}