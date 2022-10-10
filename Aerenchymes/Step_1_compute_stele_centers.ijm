// Pieces of macros for RootCell treatments

// Trouve les centroids des steles et sauvegarde un ROI contenant tous les centres des images d'un dossier

run("Close All");
chezRomain=true;
chezMathieu=!chezRomain;
if(chezRomain){
	maindir="/home/rfernandez/Bureau/A_Test/Aerenchyme/Tests/PipeIJM/";
	maindir="/home/rfernandez/Bureau/A_Test/Aerenchyme/Dataset_6_Justin/";
}
else maindir = "E:/DONNEES/Matthieu/Projet_PHIV-RootCell/Test/";

dir1=maindir+"Source";
list = getFileList(dir1);
print(dir1);

N=list.length;
doCompute=false;
doVerif=true;
/*

APO CTRL 1 7
APO_CTRL_3_11
APO_CTRL 3 3
APO_CTRL 3 4
APO_CTRL 3 5
APO_CTRL 3 6
APO strs 1 1
APO_strs_1_8
CIR_ctrl_1_4
CIR_ctrl_1_5
CIR_ctrl_1_6
CIR_ctrl_1_7
IRAT_ctrl_3_9
IR_ctrl_1_5
KINA_ctrl_2_9


UPL_strs_3_1
IRAT_ctrl_3_9

IRAT CIR KINA UPL are big

APO CTRL 2 5
APO CTRL 3 7
APO CTRL 3 2
APO CTRL 3 7
CIR CTRL 1 4
CIR CTRL 1 5
CIR CTRL 1 6
SAHEL strs 2 3


*/
deb=false;

if(doCompute){
	for (i=0; i<N; i++) {
		//Open and prepare image
		print("Processing "+list[i]);
		//if(list[i]!="SAHEL_strs_2_3.tif")continue;
		prepareImage(dir1+"/"+list[i]);
		X=getWidth();
		Y=getHeight();
		mag=getMagnification();
		mag=10;
		//Alternated sequential filter at lower res to process faster
		run("Scale...", "x=0.125 y=0.125 z=1.0 width="+(X/8)+" height="+(Y/8)+" depth=1 interpolation=Bilinear average process create");
		run("Gaussian Blur...", "radius="+(2));	
//		for(j=0;j<mag*0.65;j++){
		for(j=0;j<11;j++){
			run("Morphological Filters", "operation=Closing element=Disk radius="+j);
			run("Morphological Filters", "operation=Opening element=Disk radius="+j);
		}

		//Exclude edge area of the computation
		makeOval(X*0.01*0.5, Y*0.01*0.5,X*0.23*0.5,Y*0.23*0.5);
		if(deb)waitForUser;
		roiManager("Add");
		run("Clear Outside");
		cleanRois();

		//Locate the maxima and its val-3% associated area
		getStatistics(area, mean, min, max, std, histogram);
		threshold = max*0.97;
		setThreshold(threshold, 255);
		run("Analyze Particles...", "size=0-Infinity circularity=0-1.00 clear include add");
		run("Set Measurements...", "centroid display redirect=None decimal=3");
		if(deb)waitForUser;
		//Find the centroid of the maxima area
		roiManager("Select", 0);
		List.setMeasurements;
		x = List.getValue("X");
		y = List.getValue("Y");
		run("Close All");
		x=x*2;
		y=y*2;
		
		//Find the minima around this maxima in a first neighbourhood
		prepareImage(dir1+"/"+list[i]);
		run("Scale...", "x=0.25 y=0.25 z=1.0 width="+(X/4)+" height="+(Y/4)+" depth=1 interpolation=Bilinear average process create");
		print(mag/2);
		if(deb)waitForUser;
//		run("Gaussian Blur...", "radius="+(mag/4));	
		run("Gaussian Blur...", "radius="+(6));	
		run("Invert");
		r=10;//mag;
		factor=2.0;
		cleanRois();
		makeOval(x-r*factor, y-r*factor,2*r*factor, 2*r*factor);
		if(deb)waitForUser;
//		run("Clear Outside");

		print("here");
		if(deb)waitForUser;
		run("Find Maxima...", "prominence=2 output=[Point Selection]");
		roiManager("Add");
//		roiManager("select", 0);
		Roi.getCoordinates(xpoints, ypoints);
		if(deb)waitForUser;
		roiManager("Delete");	
		x=0;
		y=0;
		for(ii=0;ii<xpoints.length ;ii++){
			print("ajout du point "+xpoints[ii]+" , "+ypoints[ii]);
			x+=xpoints[ii]*2;
			y+=ypoints[ii]*2;
		}
		x/=xpoints.length;
		y/=xpoints.length;		

	/*	
		//Find the minima around this minima in a second neighbourhood
		prepareImage(dir1+"/"+list[i]);
		run("Scale...", "x=0.5 y=0.5 z=1.0 width="+(X/2)+" height="+(Y/2)+" depth=1 interpolation=Bilinear average process create");
		run("Gaussian Blur...", "sigma="+(mag/2));
		run("Invert");
		rename("Med");
		r=(mag*3)/2;
		makeOval(x-r, y-r,r*2, r*2);
		run("Clear Outside");
		cleanRois();
		run("Find Maxima...", "prominence=30 output=[Point Selection]");
		roiManager("Add");
		Roi.getCoordinates(xpoints, ypoints);
		roiManager("Delete");	
		x=xpoints[0];
		y=ypoints[0];
		*/
		prepareImage(dir1+"/"+list[i]);
		makePoint(x*2, y*2, "large yellow hybrid");
		roiManager("Add");
		roiManager("Save", maindir+"SteleCenter/SteleCenter_highres_slice"+i+".zip");
		if(deb)wait(2000);
		run("Close All");
		cleanRois();
	}
}

if(doVerif){

	//18 et 19 APO ctrl 3 3 et APO ctr 3 5 c est les memes ?
	//87 et 88 IRAT ctrl 1 10 et 11 c'est les memes ?
	//IR strs 3 3 grosse racine latérale au milieu
	//IR ctrl 2 5 semble démontrer la question des tissus de support
	//CIR ctrl 1 3 ???? WTF
	//CIR ctrl 2 3 ??? WTF
	//CIR ctrl 2 4 ??? WTF
	//UP_CTR_3_13 ???? WTF
	//CIR strs 2 1 ??? WTF
	//CIR strs 2 4 ??? WTF
	//IRAT ctrl 1 8 ??? WTF
	//IRAT ctrl 2 8 ??? WTF
	//IRAT ctrl 2 9 ??? WTF
	//IRAT strs 1 3 ??? WTF
	//KINA strs 1 1 ??? WTF
	//KINA strs 1 2 ??? WTF
	//KINA strs 1 3 ??? WTF
	//KINA strs 1 4 ??? WTF
	//KINA strs 3 4 ??? WTF
	//KINA strs 3 6 ??? WTF 
	//PRIM ctrl 1 6 ??? WTF
	//PRIM ctrl 1 7 ??? WTF
	//PRIM ctrl 2 6 ??? WTF
	for (i=10; i<N; i++) {
		print(i+" "+list[i]);
		//if(list[i]!="2d.tif")continue;
		cleanRois();
		run("Close All");
		prepareImage(dir1+"/"+list[i]);
		roiManager("open", maindir+"SteleCenter/SteleCenter_highres_slice"+i+".zip");
		roiManager("Select", 0);
		waitForUser;
		nn=roiManager("count");
		if(nn==2){
			roiManager("Select", 0);
			roiManager("delete");
			roiManager("Save", maindir+"SteleCenter/SteleCenter_highres_slice"+i+".zip");			
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

function prepareImage(path){
	open(path);
	run("8-bit");
	run("Enhance Contrast", "saturated=0.35");
	run("Apply LUT");
}

