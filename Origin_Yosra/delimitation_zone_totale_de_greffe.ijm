origid=getImageID();
count=roiManager("count");
for (i=0; i<count;i++){
	roiManager("select",i);
	run("Fill","slice");
}
