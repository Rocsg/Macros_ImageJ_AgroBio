// Pieces of macros for RootCell treatments. This part 
run("Close All");
cleanRois();
setTool("oval");
setTool("point");
showMessage("Use the Polygon Roi tool to connect all the cell centers of the endoderm.\nTime estimated : 1 mn per image");


maindir = getDirMacro();
dir1=maindir+"1_Source";
dirRoi=maindir+"2_AreaRoi";
run("Close All");
list = getFileList(dir1);
N=list.length;
setTool("polygon");

print("Entering loop ");
for (i=0; i<N; i++) {
	//Open and prepare image
	print("Starting loop with "+list[i]);
	if(File.exists(dirRoi+"/"+list[i]+"endoderm.zip")){
		print("Skipping file "+list[i]+"endoderm.zip");
		continue;
	}
	prepareImage(dir1+"/"+list[i]);
	cleanRois();



	//Action loop for adding or removing stele

	numberOfRoi=0;
	while(numberOfRoi<1){
		wait(100);
		numberOfRoi=roiManager("count");
	}
	roiManager("Save", maindir+"/2_AreaRoi/"+list[i]+"endoderm.zip");			
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
	//run("8-bit");
	//run("Enhance Contrast", "saturated=0.02");
	//run("Apply LUT");
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

function getDirMacro(){
	s1=File.openAsString(getDirectory("imagej")+"/macros/pathProcessing.txt") ;
	s2=split(s1,"\n");
	s3=s2[0];
	s4=split(s3,"\r\n");
	s5=s4[0];
	s6=split(s5,"\r\n");
	return s6[0];
}

/*		
*/
