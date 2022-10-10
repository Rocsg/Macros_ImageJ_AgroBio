// Pieces of macros for RootCell treatments. This part 
run("Close All");
cleanRois();
setTool("oval");

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
dirRoi=maindir+"/2_CortexRoi";
run("Close All");

list = getFileList(dir1);
N=list.length;
setTool("polygon");

print("Entering loop ");
for (i=0; i<N; i++) {
	//Open and prepare image
	print("Starting loop with "+list[i]);
	if(File.exists(dirRoi+"/"+list[i]+"cortex_in.zip")){
		print("Skipping file "+list[i]+"cortex_in.zip");
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
	roiManager("Save", maindir+"/2_CortexRoi/"+list[i]+"stele_out.zip");			
		
	cleanRois();

	numberOfRoi=0;
	while(numberOfRoi<1){
		wait(100);
		numberOfRoi=roiManager("count");
	}
	roiManager("Save", maindir+"/2_CortexRoi/"+list[i]+"cortex_in.zip");			
	run("Close All");
	cleanRois();
}
	



function cleanRois(){
	if (roiManager("count")>0){
		roiManager("Deselect");
		roiManager("Delete");
	}
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



/*		
*/
