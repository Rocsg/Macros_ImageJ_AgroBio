//This script ask for an image, then convert all the other images into a couple (source,mask)

open();
fileName = File.nameWithoutExtension;
dirName = File.directory;
maindir=File.getParent(dirName);
dir1=maindir+"/1_Source";
dirRoi=maindir+"/2_CortexRoi";
dirOut=maindir+"/6_Deepstuff";
list = getFileList(dir1);
N=list.length;
run("Close All");


for (i=0; i<N; i++) {
	//Open and prepare image
	print(list[i]);

	//Save source image
	run("Close All");
	prepareImage(dir1+"/"+list[i]);
	run("8-bit");
	saveAs("Tiff", dirOut+"/"+list[i]+"_SOURCE.tiff");

	//Save mask image
	run("Close All");
	prepareImage(dir1+"/"+list[i]);
	roiManager("open", maindir+"/2_CortexRoi/"+list[i]+"cortex_in.zip");
	roiManager("Select", 0);
	setBackgroundColor(0, 0, 0);
	run("Clear Outside");
	setForegroundColor(255, 255, 255);
	run("Fill", "slice");
	cleanRois();

	roiManager("open", maindir+"/2_CortexRoi/"+list[i]+"cortex_out.zip");
	roiManager("Select", 0);
	run("Invert");
	run("8-bit");
	cleanRois();
	saveAs("Tiff", dirOut+"/"+list[i]+"_MASK.tiff");
}


function cleanRois(){
	run("Select None");
	if (roiManager("count")>0){
		roiManager("Deselect");
		roiManager("Delete");
		roiManager("reset");
	}
}


function prepareImage(path){
	open(path);
	run("8-bit");
	run("Enhance Contrast", "saturated=0.35");
	run("Apply LUT");
}
