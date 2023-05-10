// Pieces of macros for RootCell treatments

// This script verifies the lacune selected before the last automated step of ratio computation
run("Close All");
cleanRois();
showMessage("Verify the lacunes. Just check every image, then click ok.\nIf you notice something bad (some missing cells), note the title (image name), and the bad contour,\nIf necessary, remove the lacune annotation (in 4_LacunesIndices), then run back lacunes annotations.");
showMessage("First, select an image in the 1_Source directory\nSelect any image, whatever, it is just used to find the parent folder.");
open();
fileName = File.nameWithoutExtension;
dirName = File.directory;
maindir=File.getParent(dirName);
dir1=maindir+"/1_Source";
dirRoi=maindir+"/3_CellRoi";
dirLac=maindir+"/4_LacunesIndices";
list = getFileList(dir1);
N=list.length;

function prepareImage(path){
	open(path);
	run("8-bit");
	run("Enhance Contrast", "saturated=0.35");
	run("Apply LUT");
}



for (i=0; i<N; i++) {
	print("Toto2");
	print(i+" "+list[i]);
	run("Close All");
	cleanRois();


	//Open and prepare image
	prepareImage(dir1+"/"+list[i]);
	prepareImage(dir1+"/"+list[i]);
	
	roiManager("open", dirRoi +"/"+ list[i]+".zip");
	roiManager("show all");
	//Open table	
	Table.open(dirLac +"/"+ list[i]+".csv");
	nLac=Table.size;
	selectWindow(replace(list[i],".tif","-1.tif"));
	if(nLac>0){
		ind=Table.getColumn("Displayed index (1-inf)");
		nLac=Table.size;
		for(k=0;k<nLac;k++){
			print("Selecting the roi "+k+" over "+nLac+" ,which is "+ind[k]);
			roiManager("select", ind[k]-1);
			fill();
		}
	}
	Table.setLocationAndSize(0,0,100,100);
	cleanRois();
	waitForUser;
}



run("Close All");
cleanRois();
showMessage("Finished");

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

