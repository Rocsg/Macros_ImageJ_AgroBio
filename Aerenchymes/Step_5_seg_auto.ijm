// Pieces of macros for RootCell treatments

// Trouve les centroids des steles et sauvegarde un ROI contenant tous les centres des images d'un dossier
run("Close All");
cleanRois();
showMessage("Don t do anything, just wait for it, and appreciate the segmentation being done automatically\nIf you suffer from epillepsy, you should not stay in front of the computer meanwhile\nEstimated time : 3 seconds per image");
showMessage("First, select an image in the 1_Source directory\nSelect any image, whatever, it is just used to find the parent folder.\nThe images which don't have one of the three expected roi will make the macro fail.");

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
run("Colors...", "foreground=white background=black selection=yellow");

//answer=getBoolean("Are you Paula ?");//1 if it is Paula, 0 else


for (i=0; i<N; i++) {
	//Open and prepare image
	print("Toto");
	prepareImage(dir1+"/"+list[i]);
	sig=2;
	/*
	mag=10;
	mag=getMagnification();
	if(mag==20)sig=2;
	if(mag==10)sig=2;	
	//radiusStele=radiusSteleStandard*mag;
	*/
	run("Enhance Local Contrast (CLAHE)", "blocksize=127 histogram=256 maximum=3 mask=*None* fast_(less_accurate)");
	showMessage("message");
	//Get cortex area
	roiManager("open", maindir+"/2_AreaRoi/"+list[i]+"cortex_in.zip");
	roiManager("Select", 0);
	run("Clear", "slice");
	cleanRois();
	roiManager("open", maindir+"/2_AreaRoi/"+list[i]+"cortex_out.zip");
	roiManager("Select", 0);
	run("Clear Outside");
	showMessage("message");
//	run("Enhance Contrast", "saturated=1");
//	run("Apply LUT");
	showMessage("message");
	run("Gaussian Blur...", "sigma="+sig);//(mag/6));
	showMessage("message");
	cleanRois();
	rename("gauss");
	run("Find Maxima...", "prominence=1 light output=[Single Points]");//3
	showMessage("message");
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
showMessage("Finished");

function cleanRois(){
	if (roiManager("count")>0){
		roiManager("Deselect");
		roiManager("Delete");
	}
	run("Select None");
}

function getMagnificationPaula(){
	print("Paola mode, magnification=10.");
	return 10;
}

function getMagnification(){
	s0="";
	s0=getImageInfo();
	if((lengthOf(s0))==0)return getMagnificationPaula();
	index1=indexOf(s0, "Objective Correction=");
	if(index1==(-1))return getMagnificationPaula();
	s1=substring(s0, index1+20);
	index2=indexOf(s1, "NominalMagnification=\"");
	if(index2==(-1))return getMagnificationPaula();
	s3=substring(s1, index2+22);
	index3=indexOf(s3, "\"");
	if(index3==(-1))return getMagnificationPaula();
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

