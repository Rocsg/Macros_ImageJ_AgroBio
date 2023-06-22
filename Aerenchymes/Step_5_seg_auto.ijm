// Pieces of macros for RootCell treatments

// Trouve les centroids des steles et sauvegarde un ROI contenant tous les centres des images d'un dossier
run("Close All");
cleanRois();
showMessage("Don t do anything, just wait for it, and appreciate the segmentation being done automatically\nIf you suffer from epillepsy, you should not stay in front of the computer meanwhile\nEstimated time : 3 seconds per image");

maindir = getDirMacro();
dir1=maindir+"/1_Source";
dirRoi=maindir+"/3_CellRoi";
list = getFileList(dir1);
N=list.length;
run("Close All");

//radiusSteleStandard=5;//Measured on a bunch of images
run("Colors...", "foreground=white background=black selection=yellow");

//answer=getBoolean("Are you Paula ?");//1 if it is Paula, 0 else


for (i=0; i<N; i++) {
	watershedIsNew=false;
	if(File.exists(dirRoi+"/"+list[i]+".zip")){
		print("Watershed : skipping file "+list[i]);
	}
	else {								
	//Open and prepare image
		print("Toto");
		prepareImage(dir1+"/"+list[i]);
		sig=2;
		/*
		mag=10;
		mag=getMagnification();
		if(mag==20)sig=2;
		if(mag==10)sig=2;	
		//radiusStele=radiusSteleStandard*mag;
		*/
		run("Enhance Local Contrast (CLAHE)", "blocksize=127 histogram=256 maximum=3 mask=*None* fast_(less_accurate)");
		//Get cortex area
		roiManager("open", maindir+"/2_AreaRoi/"+list[i]+"endoderm.zip");
		roiManager("Select", 0);
		run("Clear", "slice");
		cleanRois();
		roiManager("open", maindir+"/2_AreaRoi/"+list[i]+"cortex_out.zip");
		roiManager("Select", 0);
		run("Clear Outside");
	//	run("Enhance Contrast", "saturated=1");
	//	run("Apply LUT");
		run("Gaussian Blur...", "sigma="+sig);//(mag/6));
		cleanRois();
		rename("gauss");
		run("Find Maxima...", "prominence=1 light output=[Single Points]");//3
		rename("marks");
		run("Marker-controlled Watershed", "input=gauss marker=marks mask=None compactness=0 binary calculate use");
		rename(list[i]);
		setMinAndMax("0.50", "0.50");
		setOption("ScaleConversions", true);
		run("8-bit");
		setThreshold(1, 255);
	
		run("Analyze Particles...", "size=0-Infinity circularity=0-1.00 display clear exclude add");
	
		n=roiManager('count');
		roiManager("open", maindir+"/2_AreaRoi/"+list[i]+"cortex_in.zip");
	    ret=0;
		for (j=n-1; j >=0 ; j--) {		
		    roiManager('select', j);
		    Roi.getBounds(x0,y0,X,Y);
			x_center_n = x0 + X / 2.0; // Calcule la coordonnée X du centre de la ROI numéro n+1
			y_center_n = y0 + Y / 2.0; // Calcule la coordonnée Y du centre de la ROI numéro n+1
		    roiManager('select', n-ret);
		    if(Roi.contains(x_center_n, y_center_n)){
				roiManager("select", j);
				roiManager("delete");	 
				ret=ret+1;   	
		    }
		}
		n=roiManager('count');
		roiManager("select", n-1);
		roiManager("delete");	 
	
		roiManager("Save", dirRoi +"/"+ list[i]+".zip");		
		watershedIsNew=true;
	}//End of watershed for generation of lacune (cells and aerenchymes)			

	if(File.exists(maindir+"/2_AreaRoi/"+list[i]+"cortex_convexhull.zip") && (!watershedIsNew)){
		print("Watershed : skipping file "+list[i]);
	}
	else {								
		cleanRois();
		run("Close All");
		prepareImage(dir1+"/"+list[i]);
		roiManager("open",  dirRoi +"/"+ list[i]+".zip");
		n=roiManager('count');
		run("Select All");
		roiManager("Combine");
		roiManager("delete");
		roiManager("Add");
		roiManager("Select", 0);
		run("Convex Hull");
		roiManager("delete");
		roiManager("Add");
		roiManager("Select", 0);
		roiManager("Save", maindir+"/2_AreaRoi/"+list[i]+"cortex_convexhull.zip");
		cleanRois();
		run("Close All");
	}
}


run("Close All");
cleanRois();
showMessage("Finished");

function cleanRois(){
	if (roiManager("count")>0){
		roiManager("Deselect");
		roiManager("Delete");
	}
	run("Select None");
}

function getMagnificationPaula(){
	print("Paola mode, magnification=10.");
	return 10;
}

function getMagnification(){
	s0="";
	s0=getImageInfo();
	if((lengthOf(s0))==0)return getMagnificationPaula();
	index1=indexOf(s0, "Objective Correction=");
	if(index1==(-1))return getMagnificationPaula();
	s1=substring(s0, index1+20);
	index2=indexOf(s1, "NominalMagnification=\"");
	if(index2==(-1))return getMagnificationPaula();
	s3=substring(s1, index2+22);
	index3=indexOf(s3, "\"");
	if(index3==(-1))return getMagnificationPaula();
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

function getDirMacro(){
	s1=File.openAsString(getDirectory("imagej")+"/macros/pathProcessing.txt") ;
	s2=split(s1,"\n");
	s3=s2[0];
	s4=split(s3,"\r\n");
	s5=s4[0];
	s6=split(s5,"\r\n");
	return s6[0];
}
