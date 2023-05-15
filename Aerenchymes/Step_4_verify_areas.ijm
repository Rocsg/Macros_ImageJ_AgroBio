// Pieces of macros for RootCell treatments

// Trouve les centroids des steles et sauvegarde un ROI contenant tous les centres des images d'un dossier
run("Close All");
cleanRois();

showMessage("Verify all the contours. Just check every image, then click ok.\nIf you notice something bad, note the title (image name), and the bad contour,\nthen remove the corresponding roi file in 2_AreaRoi, and run again the corresponding script\n");


maindir = getDirMacro();
dir1=maindir+"/1_Source";
dirRoi=maindir+"/2_AreaRoi";
list = getFileList(dir1);
N=list.length;

radiusSteleStandard=5;//Measured on a bunch of images
run("Colors...", "foreground=white background=black selection=magenta");



for (i=0; i<N; i++) {
	print(i+" "+list[i]);
	run("Close All");
	cleanRois();
	run("Colors...", "foreground=white background=black selection=magenta");
	//Open and prepare image
	prepareImage(dir1+"/"+list[i]);
	roiManager("open", dirRoi +"/"+ list[i]+"cortex_in.zip");
	run("Colors...", "foreground=white background=black selection=green");
	roiManager("open", dirRoi +"/"+ list[i]+"cortex_out.zip");
	run("Colors...", "foreground=white background=black selection=blue");
	roiManager("open", dirRoi +"/"+ list[i]+"stele_out.zip");
	roiManager("show all");
	waitForUser;
}



run("Close All");
cleanRois();


function cleanRois(){
	if (roiManager("count")>0){
		roiManager("Deselect");
		roiManager("Delete");
	}
	run("Select None");
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

function getDirMacro(){
	s1=File.openAsString(getDirectory("imagej")+"/macros/pathProcessing.txt") ;
	s2=split(s1,"\n");
	s3=s2[0];
	s4=split(s3,"\r\n");
	s5=s4[0];
	s6=split(s5,"\r\n");
	return s6[0];
}

