// Pieces of macros for RootCell treatments. This part 
run("Close All");
cleanRois();
showMessage("Click on the Apple trees.");

//Handle data and datapath
setTool("point");
dirSourceRGB="/home/rfernandez/Bureau/A_Test/FruitFlowDrone/Expe_segment_mano/NielsSource_Split4/rgb";
dirSourceMS="/home/rfernandez/Bureau/A_Test/FruitFlowDrone/Expe_segment_mano/NielsSource_Split4/ndvi";
dirTarget="/home/rfernandez/Bureau/A_Test/FruitFlowDrone/Expe_segment_mano/NielsTarget_Split4";

list = getFileList(dirSourceRGB);
N=list.length;
print("Entering loop ");
for (ii=0; ii<N; ii++) {
	imgToTry=list[ii];
	print("Loop "+ii+" / "+N+" with "+list[ii]);
	if(File.exists(dirTarget +"/"+ imgToTry+".csv")){
		print("Skipping file "+imgToTry);
		continue;
	}
	run("Close All");
	cleanRois();
	prepareImage(dirSourceRGB+"/"+imgToTry);
	setLocation(650, 100);

	values=newArray(1);
	Table.create("CurrentImage");
	Table.setColumn("M0_surf",values);
	Table.setColumn("M1_surf",values);
	Table.setColumn("M2_surf",values);
	Table.setColumn("M3_surf",values);
	Table.setColumn("M0_NDVI",values);
	Table.setColumn("M1_NDVI",values);
	Table.setColumn("M2_NDVI",values);
	Table.setColumn("M3_NDVI",values);
	Table.setLocationAndSize(0, 0, 600,200);
	Table.update();


	dialog=Dialog.create("Title");
	Dialog.addNumber("Surface 0", 100);
	Dialog.show();
	val0=Dialog.getNumber();
	print(val0);
	Table.set("M0_surf", 0,val0);
	Table.update();	

	dialog=Dialog.create("Title");
	Dialog.addNumber("Surface 1", 100);
	Dialog.show();
	val1=Dialog.getNumber();
	print(val1);
	Table.set("M1_surf", 0,val1);
	Table.update();	
	
	dialog=Dialog.create("Title");
	Dialog.addNumber("Surface 2", 100);
	Dialog.show();
	val2=Dialog.getNumber();
	print(val2);
	Table.set("M2_surf", 0,val2);
	Table.update();	

	dialog=Dialog.create("Title");
	Dialog.addNumber("Surface 3", 100);
	Dialog.show();
	val3=Dialog.getNumber();
	print(val3);
	Table.set("M3_surf", 0,val3);
	Table.update();	


	prepareImage(dirSourceMS+"/"+imgToTry);
	run("Fire");
	setMinAndMax(-1, 1);
	setLocation(1000, 100);

	dialog=Dialog.create("Title");
	Dialog.addNumber("NDVI 0", 100);
	Dialog.show();
	val0=Dialog.getNumber();
	print(val0);
	Table.set("M0_NDVI", 0,val0);
	Table.update();	

	dialog=Dialog.create("Title");
	Dialog.addNumber("NDVI 1", 100);
	Dialog.show();
	val1=Dialog.getNumber();
	print(val1);
	Table.set("M1_NDVI", 0,val1);
	Table.update();	
	
	dialog=Dialog.create("Title");
	Dialog.addNumber("NDVI 2", 100);
	Dialog.show();
	val2=Dialog.getNumber();
	print(val2);
	Table.set("M2_NDVI", 0,val2);
	Table.update();	

	dialog=Dialog.create("Title");
	Dialog.addNumber("NDVI 3", 100);
	Dialog.show();
	val3=Dialog.getNumber();
	print(val3);
	Table.set("M3_NDVI", 0,val3);
	Table.update();	



	Table.save(dirTarget +"/"+imgToTry+".csv");
	Table.reset("CurrentImage");
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
	run("Enhance Local Contrast (CLAHE)", "blocksize=127 histogram=256 maximum=3 mask=*None* fast_(less_accurate)");
	//run("Apply LUT");
	setOption("Changes", false);
}

