// Specify the path to the ROI file
roiPath = "/home/rfernandez/Bureau/A_Test/Aerenchyme/Xrays/Test-02_curve-resampling/pointroi_04.roi";  // Replace with the path to your ROI file
imgPath = "/home/rfernandez/Bureau/A_Test/Aerenchyme/Xrays/Test-02_curve-resampling/test_line_02.tif"
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

for (i = 0; i < pointCounter; i++) {
    x = xpoints[i];
    y = ypoints[i];
    z = Roi.getPointPosition(i);

    // Adjust for ROI offset
//    bounds = roi.getBounds();
//    x += bounds.x;
//    y += bounds.y;

    // Add coordinates to the array
    coordinates = Array.concat(coordinates, "[" + x + ", " + y + ", " + z + "]");
}

// Output the coordinates
print("[");
for (i = 0; i < pointCounter; i++) {
    print("  " + coordinates[i] + ",");
}
print("]");

