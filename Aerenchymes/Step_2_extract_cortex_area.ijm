// Pieces of macros for RootCell treatments

// Trouve les centroids des steles et sauvegarde un ROI contenant tous les centres des images d'un dossier
run("Close All");
if (roiManager("count")>0){
	roiManager("Deselect");
	roiManager("Delete");
}

chezRomain=true;
chezMathieu=!chezRomain;
if(chezRomain){
	maindir="/home/rfernandez/Bureau/A_Test/Aerenchyme/Tests/PipeIJM/";
	maindir="/home/rfernandez/Bureau/A_Test/Aerenchyme/Dataset_6_Justin/";
}
else maindir = "E:/DONNEES/Matthieu/Projet_PHIV-RootCell/Test/";
dir1=maindir+"Source";
list = getFileList(dir1);
radiusSteleStandard=5;//Measured on a bunch of images

//APO_CTRL_3_2  ext a retoquer
//CIR_CTRL_1_6  interieur a retoquer
//PRIM_strs_2_5 out un truc a voir

function isLittle(imgName){
	if(imgName=="APO_ctrl_2_4.tif")return true;
	if(imgName=="APO_ctrl_2_5.tif")return true;
	if(imgName=="APO_ctrl_2_7.tif")return true;
	if(imgName=="APO_ctrl_2_9.tif")return true;
//	if(imgName=="PRIM_strs_2_5.tif")return true;


	return false;
}

compute=true;
verifIn=false;
verifOut=true;
testAnImage=true;
deb=true;
N=list.length;
//N=1; refaire le 6

function excludeThisOne(imgName){
	if(!testAnImage)return false;
	if(imgName!="IR_ctrl_3_4.tif")return true;
//	if(imgName!="IRAT_CTRL_3_9.tif")return true;
	return false;
}

if(compute){
	for (i=5; i<N; i++) {
		if(excludeThisOne(list[i]))continue;
		//Open and prepare image
		cleanRois();
		prepareImage(dir1+"/"+list[i]);
		mag=getMagnification();
		mag=20;
		radiusStele=radiusSteleStandard*mag;
		if(isLittle(list[i]))radiusStele*=0.5;
	
		//Get stele center coordinates
		coords=getCoordsOfPointInRoi(maindir+"SteleCenter/SteleCenter_highres_slice"+i+".zip");
		x=coords[0];
		y=coords[1];
	
		//////COMPUTE STELE CONTOUR
		// Remove stele center
		ray1=radiusStele*0.65;
		makeOval(x-ray1, y-ray1, ray1*2, ray1*2);
		if(deb)waitForUser;
		run("Clear", "slice");
		run("Select None");
	
		 // Remove all the tissue outside the stele
		ray2=radiusStele*2; 
		makeOval(x-ray2, y-ray2, ray2*2, ray2*2);
		if(deb)waitForUser;
		run("Clear Outside");
		run("Select None");
	
		 // Get contour
		run("Gaussian Blur...", "sigma=10");
		rename("gauss");
		run("Find Maxima...", "prominence=30 light output=[Single Points]");
		if(deb)waitForUser;
		rename("marks");
		run("Marker-controlled Watershed", "input=gauss marker=marks mask=None compactness=0 binary calculate use");
		if(deb)waitForUser;
		doWand(x,y);
		run("Enlarge...", "enlarge="+((5*mag)/4)+"");
		roiManager("Add");
		roiManager("Save", maindir+"CortexRoi/"+list[i]+"cortex_in.zip");
		if(deb)waitForUser;
		cleanRois();
		run("Close All");
		
	
	
		//////COMPUTE SCLERENCHYME CONTOUR
		//Open and prepare image
		prepareImage(dir1+"/"+list[i]);
	
		// Remove all the stele
		ray1=radiusStele*2.2;
		makeOval(x-ray1, y-ray1, ray1*2, ray1*2);
		run("Clear", "slice");
		run("Select None");
		X=getWidth();
		Y=getHeight();
		makeOval(X*0.01, Y*0.01,X*0.98,Y*0.98);
		roiManager("Add");
		run("Clear Outside");
		roiManager("deselect");
		cleanRois();
		run("Select None");
	
		 // Get contour
		run("Median...", "sigma="+mag);
		run("Gaussian Blur...", "sigma="+mag);
		rename("gauss");
		cleanRois();
		if(deb)waitForUser;
		run("Find Maxima...", "prominence=30 light output=[Single Points]");
		rename("marks");
		if(deb)waitForUser;
		run("Marker-controlled Watershed", "input=gauss marker=marks mask=None compactness=0 binary calculate use");
		doWand(x,y);
		run("Enlarge...", "enlarge="+(mag/6));
		roiManager("Add");
		if(deb)waitForUser;
		roiManager("Save", maindir+"CortexRoi/"+list[i]+"cortex_out.zip");
		cleanRois();
		run("Close All");
	}
}

if(verifIn){
	for (i=0; i<N; i++) {
		print(i);
		if(excludeThisOne(list[i]))continue;
		run("Close All");
		cleanRois();
		//////ADAPT THE CONTOURS A BIT INCLUDING A SAFETY ZONE
		prepareImage(dir1+"/"+list[i]);
		roiManager("open", maindir+"CortexRoi/"+list[i]+"cortex_in.zip");
		//	run("Clear", "slice");
		//	run("Clear Outside");
		run("Select All");
		roiManager("Show All");
		waitForUser;
		nn=roiManager("count");
		if(nn==2){
			roiManager("Select", 0);
			roiManager("delete");
			roiManager("Save", maindir+"CortexRoi/"+list[i]+"cortex_in.zip");			
		}
	}
}
if(verifOut){
	for (i=0; i<N; i++) {
		print(i);
		if(excludeThisOne(list[i]))continue;
		run("Close All");
		cleanRois();
		//////ADAPT THE CONTOURS A BIT INCLUDING A SAFETY ZONE
		prepareImage(dir1+"/"+list[i]);
		roiManager("open", maindir+"CortexRoi/"+list[i]+"cortex_out.zip");
		//	run("Clear", "slice");
		//	run("Clear Outside");
		run("Select All");
		roiManager("Show All");
		waitForUser;
		nn=roiManager("count");
		if(nn==2){
			roiManager("Select", 0);
			roiManager("delete");
			roiManager("Save", maindir+"CortexRoi/"+list[i]+"cortex_out.zip");			
		}
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

