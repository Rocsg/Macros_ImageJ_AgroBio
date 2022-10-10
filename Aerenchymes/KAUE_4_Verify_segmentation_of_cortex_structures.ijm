// Pieces of macros for RootCell treatments

// Trouve les centroids des steles et sauvegarde un ROI contenant tous les centres des images d'un dossier
run("Close All");
cleanRois();
open();
fileName = File.nameWithoutExtension;
dirName = File.directory;
maindir=File.getParent(dirName);
dir1=maindir+"/Source";
dirRoi=maindir+"/CellRoi";
dirMeas=maindir+"/CellMeasurements";
list = getFileList(dir1);
N=list.length;
run("Close All");

radiusSteleStandard=5;//Measured on a bunch of images




for (i=0; i<N; i++) {
	print(i+" "+list[i]);
	run("Close All");
	cleanRois();
	//Open and prepare image
	prepareImage(dir1+"/"+list[i]);
	roiManager("open", dirRoi +"/"+ list[i]+".zip");
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

