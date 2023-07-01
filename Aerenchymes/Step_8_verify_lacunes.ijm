// Pieces of macros for RootCell treatments

// This script verifies the lacune selected before the last automated step of ratio computation
run("Close All");
cleanRois();
showMessage("Verify the lacunes. Just check every image, then click ok.\nIf you notice something bad (some missing cells), note the title (image name), and the bad contour,\nIf necessary, remove the lacune annotation (in 4_LacunesIndices), then run back lacunes annotations.");
maindir = getDirMacro();
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
	setOption("Changes", false);
}

nModLac=0;
nMes=0;

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
	roiManager("show none");
	run("Synchronize Windows");
	if(getBoolean("Is this Ok ?")==0){
		if(getBoolean("Are the lacunes ok ? (click No to delete the lacunes file")==0){
			File.delete(dirLac +"/"+ list[i]+".csv");
			nModLac=nModLac+1;
		}
		if(File.exists(maindir +"/Results_aerenchyme_measurements.csv")){			
			File.delete(maindir +"/Results_aerenchyme_measurements.csv");
			nMes=nMes+1;
		}
	}
}

if((nModLac+nMes)>0){
	messag="Some files have been removed to be computed again. Please run : \n";
	if(nModLac>0)messag=messag+"Script_7 ("+nModLac+" images to do).\n";
	if(nMes>0)messag=messag+"Script_9 (to compute the updated statistics).\n";
	showMessage(messag);
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

function getDirMacro(){
	s1=File.openAsString(getDirectory("imagej")+"/macros/pathProcessing.txt") ;
	s2=split(s1,"\n");
	s3=s2[0];
	s4=split(s3,"\r\n");
	s5=s4[0];
	s6=split(s5,"\r\n");
	return s6[0];
}

