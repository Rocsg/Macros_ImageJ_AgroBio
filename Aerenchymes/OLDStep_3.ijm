// Pieces of macros for RootCell treatments

// Trouve les centroids des steles et sauvegarde un ROI contenant tous les centres des images d'un dossier
run("Close All");
cleanRois();

chezRomain=true;
chezMathieu=!chezRomain;
if(chezRomain){
	maindir="/home/rfernandez/Bureau/A_Test/Aerenchyme/Tests/PipeIJM/";
	maindir="/home/rfernandez/Bureau/A_Test/Aerenchyme/Dataset_Production_Justin_Juin_01/";
}
else maindir = "E:/DONNEES/Matthieu/Projet_PHIV-RootCell/Test/";
dir1=maindir+"Source";
dirRoi=maindir+"CellRoi";
dirMeas=maindir+"CellMeasurements";
list = getFileList(dir1);
N=list.length;

radiusSteleStandard=5;//Measured on a bunch of images


compute=true;
verif=false;
testAnImage=false;

function excludeThisOne(imgName){
	if(!testAnImage)return false;
	if(imgName!="IR_ctrl_3_4.tif")return true;
	return false;
}


if(compute){
	print("Ici");
	for (i=0; i<N; i++) {
		if(excludeThisOne(list[i]))continue;
		//Open and prepare image
		print("Toto");
		prepareImage(dir1+"/"+list[i]);
		mag=getMagnification();
		radiusStele=radiusSteleStandard*mag;
		//roiManager("open", maindir+"SteleCenter/SteleCenter_highres_slice"+i+".zip");
		//roiManager("Select", 0);
		//Roi.getCoordinates(xpoints, ypoints);
		//roiManager("Delete");	
		//xcenter=xpoints[0];
		//ycenter=ypoints[0];
		//cleanRois();

		//Get cortex area
		roiManager("open", maindir+"CortexRoi/"+list[i]+"cortex_in.zip");
		roiManager("Select", 0);
		run("Clear", "slice");
		cleanRois();
		roiManager("open", maindir+"CortexRoi/"+list[i]+"cortex_out.zip");
		roiManager("Select", 0);
		run("Clear Outside");
		cleanRois();
		run("Enhance Contrast", "saturated=1");
		run("Apply LUT");

		run("Gaussian Blur...", "sigma="+(mag/6));
		rename("gauss");
		run("Find Maxima...", "prominence=3 light output=[Single Points]");
		rename("marks");
		run("Marker-controlled Watershed", "input=gauss marker=marks mask=None compactness=0 binary calculate use");
		rename(list[i]);
		setMinAndMax("0.50", "0.50");
		setOption("ScaleConversions", true);
		run("8-bit");
		setThreshold(1, 255);
		//run("Set Measurements...", "centroid area perimeter fit shape feret's display redirect=None decimal=3");
		run("Analyze Particles...", "size=0-Infinity circularity=0-1.00 display clear exclude add");
		//Compute R teta
		//Table.applyMacro("DX=(X-"+xcenter+"); DY=("+ycenter+"-Y)");
		//R=roiManager("count");
		//thresh=radiusSteleStandard*mag/2.0;
		//for (r = 0; r < R; r++) {
		//	dx=Table.get("DX", r);
		//	dy=Table.get("DY", r);
		//	if(sqrt(dx*dx+dy*dy)<thresh){
		//		Table.deleteRows(r, r);				
		//		roiManager("select", r);
		//		roiManager("delete");
		//		R--;
		//	}
		//}
		roiManager("Save", dirRoi +"/"+ list[i]+".zip");		
		//selectWindow("Results");
		//saveAs("Results", dirMeas +"/"+ list[i]+".csv");
		//close("Results");
		cleanRois();
		run("Close All");
	}
}


if(verif){
	for (i=0; i<N; i++) {
		print(i+" "+list[i]);
		if(excludeThisOne(list[i]))continue;
		run("Close All");
		cleanRois();
		if(excludeThisOne(list[i]))continue;
		//Open and prepare image
		prepareImage(dir1+"/"+list[i]);
		prepareImage(dir1+"/"+list[i]);
		roiManager("open", dirRoi +"/"+ list[i]+".zip");
		roiManager("show all");
		waitForUser;
	}
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

