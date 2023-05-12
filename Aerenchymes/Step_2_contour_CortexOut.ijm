// Pieces of macros for RootCell treatments. This part 
run("Close All");
cleanRois();
setTool("oval");
showMessage("Use the Polygon Roi tool to draw the outside contour of the Cortex.\nThe best way is to stick to following the centers of the bright little cells of the sclerenchyme\nTime estimated : 1 mn per image");
showMessage("First, select an image in the 1_Source directory\nSelect any image, whatever, it is just used to find the parent folder.\nThe images which already have a cortex_out contour in 2_AreaRoi won t be displayed");

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
dirRoi=maindir+"/2_AreaRoi";
run("Close All");

list = getFileList(dir1);
N=list.length;
setTool("polygon");

print("Entering loop ");
for (i=0; i<N; i++) {
	//Open and prepare image
	print("Starting loop with "+list[i]);
	if(File.exists(dirRoi+"/"+list[i]+"cortex_out.zip")){
		print("Skipping file "+list[i]+"cortex_out.zip");
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
	roiManager("Save", maindir+"/2_AreaRoi/"+list[i]+"cortex_out.zip");			
	
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



/*		
*/
