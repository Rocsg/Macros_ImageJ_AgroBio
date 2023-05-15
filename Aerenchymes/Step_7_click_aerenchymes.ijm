// Pieces of macros for RootCell treatments. This part 
run("Close All");
cleanRois();
showMessage("Click on the aerenchymes. If you want to remove an aerenchyme, click again on it (then -T- command).\nTime estimated : 1 mn per image.");

//Handle data and datapath
setTool("point");
maindir = getDirMacro();
dir1=maindir+"/1_Source";
dirRoi=maindir+"/3_CellRoi";
dirLac=maindir+"/4_LacunesIndices";




list = getFileList(dir1);
N=list.length;

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
    squaresize=110;
	//Prepare results table
	prepareImage(dir1+"/"+imgToTry);
	id2 = getImageID();

	setTool("rectangle");
	Table.create("Lacune_indices_"+imgToTry);
	Table.setLocationAndSize(0, 0, 100,100);
	Table.update();
	makeRectangle(0,0, squaresize, squaresize);
	setForegroundColor(255, 255, 255);
	run("Draw", "slice");
	setTool("text");
	setFont("SansSerif", 13, " antialiased");
	setColor("white");
	drawString("Click here and T\nto finish", 1, 18);
	prepareImage(dir1+"/"+imgToTry);
	id1 = getImageID();
	
	makeRectangle(0, 0, squaresize, squaresize);
	setForegroundColor(255, 255, 255);
	run("Draw", "slice");
	setTool("text");
	setFont("SansSerif", 13, " antialiased");
	setColor("white");
	drawString("Click here and T\nto finish", 1, 18);
	run("Synchronize Windows");
	
	setTool("point");

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
		if(tab[0]<squaresize && tab[1]<squaresize)finished=true;
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
/*				roiManager("Select", i);
				run("Invert");
				cleanRois();		
*/
			
				id3 = getImageID();
				selectImage(id1);
				roiManager("Select", i);
				run("Invert");
				selectImage(id2);
				roiManager("Select", i);
				run("Invert");
				selectImage(id3);
				cleanRois();					
			}	
			else{
				//Save the index of lacune in the table
				incr++;
				Table.set("ImgName", incr,imgToTry);
				Table.set("Displayed index (1-inf)", incr,i+1);
				Table.update();

				//Paint in green
				id3 = getImageID();
				selectImage(id1);
				roiManager("Select", i);
				run("Invert");
				selectImage(id2);
				roiManager("Select", i);
				run("Invert");
				selectImage(id3);
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
	run("Enhance Local Contrast (CLAHE)", "blocksize=127 histogram=256 maximum=3 mask=*None* fast_(less_accurate)");
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
