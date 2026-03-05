// Get the ROI
roi = roiManager("select", 0);

// Get the coordinates
//Roi.getPointPosition(0);
Roi.getContainedPoints(xpoints, ypoints);
	
pointCounter=lengthOf(xpoints);
coordinates = newArray();
str="";	
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
File.saveString(str, "/home/rfernandez/Bureau/test.csv");
