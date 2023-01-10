// Pieces of macros for RootCell treatments

// Trouve les centroids des steles et sauvegarde un ROI contenant tous les centres des images d'un dossier
run("Close All");
//cleanRois();

chezRomain=true;
chezMathieu=!chezRomain;
if(chezRomain){
	maindir="/home/rfernandez/Bureau/A_Test/Aerenchyme/Tests/PipeIJM/";
	maindir="/home/rfernandez/Bureau/A_Test/Aerenchyme/Dataset_6_Justin/";
}

else maindir = "E:/DONNEES/Matthieu/Projet_PHIV-RootCell/Test/";


dir1=maindir+"Source";
dirRoi=maindir+"CellRoi";
//dirMeas=maindir+"CellMeasurements";
dirLac=maindir+"LacunesIndices";

open();
fileName = File.nameWithoutExtension;
print(fileName);
setTool("point");
img=getImageID();
imgToTry=getInfo("image.filename");
incr=-1;
i=-1;
finished=false;

Table.create("Lacune_indices_"+imgToTry);
Table.update();
prepareImage(dir1+"/"+imgToTry);
prepareImage(dir1+"/"+imgToTry);
roiManager("open",  dirRoi +"/"+ imgToTry+".zip");
roiManager("draw");
cleanRois();
//run("Duplicate...", " ");
//run("Images to Stack", "name=Stack title=[] use");

while(!finished){
	n=0;
	while(n<1){
		wait(500);
		n=roiManager("count");
	}
	
	tab=getCoordsOfPointInRoi();
	print(tab[0]+","+tab[1]);
	if(tab[0]<50 && tab[1]<50)finished=true;
	else{
		cleanRois();
		//Find the Roi containing the point clicked by the user
		roiManager("open",  dirRoi +"/"+ imgToTry+".zip");
		n=roiManager("count");
		i=-1;
		for(j=0;j<n;j++){
			roiManager("Select", j);
			if(Roi.contains(tab[0], tab[1]))i=j;
		}
		if(i==-1)continue;

		//Is it a removal ?
		found=false;
		kk=-1;


		if(incr>=0){
			a=Table.getColumn("Displayed index (1-inf)");
			for (k = 0; k <= incr; k++) {
				if(a[k]==(i+1)){
					print("found");
					found=true;
					kk=k;
				}
			}
		}
		else found=false;
		
		if(found){
			//Save the index of lacune in the table
			incr--;
			Table.deleteRows(kk, kk);
			Table.update();
	
			//Paint in green
			roiManager("Select", i);
			run("Invert");
			cleanRois();		
		}
	
		else{
		
			
	
	
	
	
			
				//Save the index of lacune in the table
			incr++;
			Table.set("ImgName", incr,imgToTry);
			Table.set("Displayed index (1-inf)", incr,i+1);
			Table.update();
			//Paint in green
			roiManager("Select", i);
			run("Invert");
			cleanRois();		
		}
	}
	
}

Table.save(dirLac +"/"+ imgToTry+".csv");
close("Lacune_indices_"+imgToTry);		
run("Close All");
cleanRois();


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
