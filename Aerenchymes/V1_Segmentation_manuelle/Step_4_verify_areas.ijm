// Pieces of macros for RootCell treatments

// Trouve les centroids des steles et sauvegarde un ROI contenant tous les centres des images d'un dossier
run("Close All");
cleanRois();

showMessage("Verify all the contours. Just check every image, then click ok.\nIf you notice something bad, note the title (image name), and the bad contour,\nthen remove the corresponding roi file in 2_AreaRoi, and run again the corresponding script\n");


maindir = getDirMacro();
print(maindir);
dir1=maindir+"/1_Source";
dirRoi=maindir+"/2_AreaRoi";
dirCell=maindir+"/3_CellRoi";
dirLac=maindir+"/4_LacunesIndices";
list = getFileList(dir1);
N=list.length;
print(N);

radiusSteleStandard=5;//Measured on a bunch of images
run("Colors...", "foreground=white background=black selection=magenta");



nScle=0;
nEndo=0;
nSeg=0;
nLac=0;
nMes=0;
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
	remScle=0;
	remCortStel=0;
	if(getBoolean("Is this Ok ?")==0){
		if(getBoolean("Is the sclerenchyme ok ? (click no for deleting this contour)")==0){
			remScle=1;			
			File.delete(dirRoi +"/"+ list[i]+"cortex_out.zip");
			nScle=nScle+1;
			if(File.exists(dirRoi +"/"+ list[i]+"cortex_convexhull.zip")){			
				File.delete(dirRoi +"/"+ list[i]+"cortex_convexhull.zip");
			}
		}
		setOption("Changes", false);
		if(getBoolean("Are the stele and the cortex ok ?  (click no for deleting these contours)")==0){
			remCortStel=1;			
			File.delete(dirRoi +"/"+ list[i]+"cortex_in.zip");
			File.delete(dirRoi +"/"+ list[i]+"stele_out.zip");
			File.delete(dirRoi +"/"+ list[i]+"endoderm.zip");
			nEndo=nEndo+1;
		}
		if((remCortStel+remScle)>0){
			if(File.exists(dirLac +"/"+ list[i]+".csv")){			
				File.delete(dirLac +"/"+ list[i]+".csv");
				nLac=nLac+1;
			}
			if(File.exists(dirCell +"/"+ list[i]+".zip")){			
				File.delete(dirCell +"/"+ list[i]+".zip");
				nSeg=nSeg+1;
			}
			if(File.exists(maindir +"/Results_aerenchyme_measurements.csv")){			
				File.delete(maindir +"/Results_aerenchyme_measurements.csv");
				nMes=nMes+1;
			}
		}
	}
}

if((nScle+nEndo+nSeg+nLac+nMes)>0){
	messag="Some files have been removed to be computed again. Please run : \n";
	if(nEndo>0)messag=messag+"Script_1 ("+nEndo+" images to do).\n";
	if(nScle>0)messag=messag+"Script_2 ("+nScle+" images to do).\n";
	if(nEndo>0)messag=messag+"Script_3 ("+nEndo+" images to do).\n";
	if((nEndo+nScle)>0)messag=messag+"Script_4 (if you want to verify again).\n";
	if(nSeg>0)messag=messag+"Script_5 ("+nSeg+" segmentations have to be updated).\n";
	if(nSeg>0)messag=messag+"Script_6 ("+nSeg+" to verify the updated segmentations).\n";
	if(nLac>0)messag=messag+"Script_7 ("+nLac+" images to do).\n";
	if(nLac>0)messag=messag+"Script_8 (to verify the updated lacunes).\n";
	if(nMes>0)messag=messag+"Script_9 (to compute the updated statistics).\n";

	if(File.exists(maindir+"/To-do-list.txt")){
		File.delete(maindir+"/To-do-list.txt");
	}
	file=File.open(maindir+"/To-do-list.txt");
	print(file, messag);
	File.close(file);
	messag=messag+"\n\nThis to-do list has been written in your processing path, in : \n"+maindir+"/To-do-list.txt";
	showMessage(messag);
}


run("Close All");
cleanRois();
showMessage("Finished.");

function getYesNo(message) {
	return ;
}


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
	setOption("Changes", false);
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

