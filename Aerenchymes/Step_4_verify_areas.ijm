// Pieces of macros for RootCell treatments

// Trouve les centroids des steles et sauvegarde un ROI contenant tous les centres des images d'un dossier
run("Close All");
cleanRois();

showMessage("Verify all the contours. Just check every image, then click ok.\nIf you notice something bad, note the title (image name), and the bad contour,\nthen remove the corresponding roi file in 2_AreaRoi, and run again the corresponding script\n");
showMessage("First, select an image in the 1_Source directory\nSelect any image, whatever, it is just used to find the parent folder.\nThe images which don't have one of the three expected roi will make the macro fail.");


open();
fileName = File.nameWithoutExtension;
dirName = File.directory;
maindir=File.getParent(dirName);
dir1=maindir+"/1_Source";
dirRoi=maindir+"/2_AreaRoi";
list = getFileList(dir1);
N=list.length;

radiusSteleStandard=5;//Measured on a bunch of images




for (i=0; i<N; i++) {
	print(i+" "+list[i]);
	run("Close All");
	cleanRois();
	//Open and prepare image
	prepareImage(dir1+"/"+list[i]);
	roiManager("open", dirRoi +"/"+ list[i]+"cortex_in.zip");
	roiManager("open", dirRoi +"/"+ list[i]+"cortex_out.zip");
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

