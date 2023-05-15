// Pieces of macros for RootCell treatments.
run("Close All");
cleanRois();
setTool("oval");
showMessage("Click ok and wait. If you are epilleptic, beware of the screen\nTime estimated : 3 s per image");
showMessage("First, select an image in the 1_Source directory\nSelect any image, whatever, it is just used to find the parent folder.\nThe images which already have a stele_out contour in 2_AreaRoi won t be displayed");

//Handle data and datapath
open();
fileName = File.nameWithoutExtension;
dirName = File.directory;
print("Processing "+fileName);
print("In dir "+dirName);
setTool("point");
img=getImageID();
imgToTry=getInfo("image.filename");
maindir=File.getParent(dirName);
print(maindir);
dir1=maindir+"/1_Source";
dirRoi=maindir+"/2_AreaRoi";
run("Close All");

list = getFileList(dir1);
N=list.length;
setTool("polygon");

print("Entering loop ");
for (i=0; i<N; i++) {
	//Open and prepare image
	print("Starting loop with "+list[i]);
	if(File.exists(dirRoi+"/"+list[i]+"stele_out.zip")){
		print("Skipping file "+list[i]+"stele_out.zip");
		continue;
	}
	prepareImage(dir1+"/"+list[i]);
	cleanRois();


	//Remove the out of cortex in
	roiManager("open", maindir+"/2_AreaRoi/"+list[i]+"cortex_in.zip");
	roiManager("Select", 0);
	run("Clear Outside", "slice");
	run("Gaussian Blur...", "sigma="+0.7);//(mag/6));
	cleanRois();
	cleanRois();
	rename("gauss");
	
	run("Find Maxima...", "prominence=1 light output=[Single Points]");//3
	rename("marks");
	run("Marker-controlled Watershed", "input=gauss marker=marks mask=None compactness=0 binary calculate use");
	setMinAndMax("0.50", "0.50");
	setOption("ScaleConversions", true);
	run("8-bit");
	setThreshold(1, 255);

	cleanRois();
	run("Analyze Particles...", "size=0-Infinity circularity=0-1.00 display clear add");
	roiManager("Select", 0);
	roiManager("delete");
	roiManager("combine");
	roiManager("delete");
	roiManager("add");
	roiManager("Select", 0);
	run("Fill", "slice");
	roiManager("delete");
	cleanRois();
	run("Invert");
	for (k = 1; k < 8; k++) {
		print(i);
		//Opening
		for (j = 0; j < k; j++) {
			run("Erode");
		}
		for (j = 0; j < k; j++) {
			run("Dilate");
		}
		//Closure
		for (j = 0; j < k; j++) {
			run("Dilate");
		}
		for (j = 0; j < k; j++) {
			run("Erode");
		}
	}
	// get active image
// get image height
	height = getHeight();
	width = getWidth();
	makeRectangle(50, 50, width, height);
	run("Clear Outside", "slice");

	run("Create Selection");
	roiManager("Add");
	roiManager("Select", 0);
	
	roiManager("save selected", maindir+"/2_AreaRoi/"+list[i]+"stele_out.zip");			
		
	cleanRois();
	run("Close All");
}
showMessage("finished");



function cleanRois(){
	if (roiManager("count")>0){
		roiManager("Deselect");
		roiManager("Delete");
	}
	run("Select None");

}


function prepareImage(path){
	open(path);
	run("8-bit");
	run("Enhance Local Contrast (CLAHE)", "blocksize=40 histogram=256 maximum=3 mask=*None* fast_(less_accurate)");
//	run("8-bit");
//	run("Enhance Contrast", "saturated=0.35");
//	run("Apply LUT");
}

function getCoordsOfPointInRoi(){
	tab=newArray(2);
	roiManager("Select", 0);
	Roi.getCoordinates(xpoints, ypoints);
	roiManager("Delete");
	tab[0]=xpoints[0];
	tab[1]=ypoints[0];
	return tab;
}



/*		
*/
