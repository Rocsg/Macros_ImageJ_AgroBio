// Pieces of macros for RootCell treatments. This part 
run("Close All");
cleanRois();

//Handle data and datapath
setTool("point");
maindir = getDirMacro();
dir1=maindir+"/1_Source";
dirArea=maindir+"/2_AreaRoi";
dirLac=maindir+"/4_LacunesIndices";




list = getFileList(dir1);
N=3;//list.length;
run("Close All");
values=newArray(1,1,1);
Table.create("Perimeters");
Table.setColumn("Image",values);
Table.setColumn("Perimeters",values);
Table.setLocationAndSize(0, 0, 500,500);
Table.update();

print("Entering loop ");
for (ii=0; ii<N; ii++) {
	Table.reset("Results");
	imgToTry=list[ii];
	print("Starting loop with "+list[ii]);
	prepareImage(dir1+"/"+imgToTry);
	roiManager("open", dirArea +"/"+ list[ii]+"cortex_out.zip");
	roiManager("show all");
	roiManager("select", 0);
	run("Measure");
	selectWindow("Results");
	val=0;
	val=getResult("Perim.", 0);
	run("Show All");
	cleanRois();
	print(val);
	selectWindow("Perimeters");
	Table.set("Image", ii,imgToTry);
	Table.set("Perimeters", ii,val);
	Table.update();
	selectImage(getImageID());
	close();
}
Table.save(maindir +"/perimeters.csv");

showMessage("finished");
Table.reset("Perimeters");
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
	run("Enhance Local Contrast (CLAHE)", "blocksize=127 histogram=256 maximum=3 mask=*None* fast_(less_accurate)");
	//run("Apply LUT");
	setOption("Changes", false);
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
