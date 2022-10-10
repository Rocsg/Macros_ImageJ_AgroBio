// Pieces of macros for RootCell treatments. This part 
run("Close All");
cleanRois();

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
dir1=maindir+"/Source";
dirRoi=maindir+"/CellRoi";
dirLac=maindir+"/LacunesIndices";




list = getFileList(dir1);
N=list.length;
N=11;

print("Entering loop ");
for (ii=0; ii<N; ii++) {
	imgToTry=list[ii];
	print("Starting loop with "+list[ii]);
	if(File.exists(dirLac +"/"+ imgToTry+".csv")){
		print("Skipping file "+dirLac +"/"+ imgToTry+".csv");
		continue;
	}

	
	run("Close All");
	cleanRois();

	//Prepare results table
	Table.create("Lacune_indices_"+imgToTry);
	Table.update();
	prepareImage(dir1+"/"+imgToTry);
	prepareImage(dir1+"/"+imgToTry);
	roiManager("open",  dirRoi +"/"+ imgToTry+".zip");
	roiManager("draw");
	cleanRois();
	//Action loop for adding or removing cells
	incr=-1;
	i=-1;
	finished=false;
	print("Je suis ici 2");

	
	while(!finished){
		n=0;
		while(n<1){
			wait(100);
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
			print("Je suis ici 2");

	}
	Table.save(dirLac +"/"+ imgToTry+".csv");
	close("Lacune_indices_"+imgToTry);		
	run("Close All");
	cleanRois();
	Table.reset("Lacune_indices_"+imgToTry);
	Table.update();
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
