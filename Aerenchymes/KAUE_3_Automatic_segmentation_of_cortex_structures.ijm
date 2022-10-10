// Pieces of macros for RootCell treatments

// Trouve les centroids des steles et sauvegarde un ROI contenant tous les centres des images d'un dossier
run("Close All");
cleanRois();
open();
fileName = File.nameWithoutExtension;
dirName = File.directory;
maindir=File.getParent(dirName);
dir1=maindir+"/1_Source";
dirRoi=maindir+"/3_CellRoi";
list = getFileList(dir1);
N=list.length;
run("Close All");

//radiusSteleStandard=5;//Measured on a bunch of images


for (i=0; i<N; i++) {
	//Open and prepare image
	print("Toto");
	prepareImage(dir1+"/"+list[i]);
	mag=getMagnification();
	//radiusStele=radiusSteleStandard*mag;

	//Get cortex area
	roiManager("open", maindir+"/2_CortexRoi/"+list[i]+"cortex_in.zip");
	roiManager("Select", 0);
	run("Clear", "slice");
	cleanRois();
	roiManager("open", maindir+"/2_CortexRoi/"+list[i]+"cortex_out.zip");
	roiManager("Select", 0);
	run("Clear Outside");
	cleanRois();
	run("Enhance Contrast", "saturated=1");
	run("Apply LUT");

	run("Gaussian Blur...", "sigma="+(mag/6));
	rename("gauss");
	run("Find Maxima...", "prominence=3 light output=[Single Points]");
	rename("marks");
	run("Marker-controlled Watershed", "input=gauss marker=marks mask=None compactness=0 binary calculate use");
	rename(list[i]);
	setMinAndMax("0.50", "0.50");
	setOption("ScaleConversions", true);
	run("8-bit");
	setThreshold(1, 255);
	run("Analyze Particles...", "size=0-Infinity circularity=0-1.00 display clear exclude add");
	roiManager("Save", dirRoi +"/"+ list[i]+".zip");		

	cleanRois();
	run("Close All");
}


run("Close All");
cleanRois();


function cleanRois(){
	if (roiManager("count")>0){
		roiManager("Deselect");
		roiManager("Delete");
	}
}

function getMagnification(){
	s0=getImageInfo();
	index1=indexOf(s0, "Objective Correction=");
	s1=substring(s0, index1+20);
	index2=indexOf(s1, "NominalMagnification=\"");
	s3=substring(s1, index2+22);
	index3=indexOf(s3, "\"");
	s4=substring(s1, index2+22,index3+index2+22);
	return parseInt(s4);
}

function getCoordsOfPointInRoi(path){
	tab=newArray(2);
	roiManager("open", path);
	roiManager("Select", 0);
	Roi.getCoordinates(xpoints, ypoints);
	roiManager("Delete");
	tab[0]=xpoints[0];
	tab[1]=ypoints[0];
	return tab;
}

function prepareImage(path){
	open(path);
	run("8-bit");
	run("Enhance Contrast", "saturated=0.35");
	run("Apply LUT");
}

