Dialog.create("Les calibrations de l image");
Dialog.addMessage("Coordonnee de l image en X:");
Dialog.addNumber("X:" 0 );
Dialog.addMessage("Coordonnee de l image en Y:");
Dialog.addNumber("Y:" 0);
Dialog.addMessage("Coordonnee de l image en Z:");
Dialog.addNumber("Z:" 0);
Dialog.show();
X=Dialog.getNumber();
Y=Dialog.getNumber();
Z=Dialog.getNumber();

origid=getImageID();
setBatchMode(true);
roiManager("Interpolate ROIs");
superficie=0;
Omega=0;
vide=0;
count=roiManager("count");
for(i=0;i<count;i++){
    selectImage(origid);
    roiManager("Select", i);
    getStatistics(area, mean, min, max, std, histogram);// recuperation de la superficie
    superficie=superficie+area;// cumul des superficies
    run("Select None");
    run("Duplicate...", "use");
    tempid=getImageID();
    setAutoThreshold("Default");
    run("Restore Selection");
    run("Analyze Particles...", "size=300-Infinity show=Masks ");
    selectImage(tempid);
    close();
        }
run("Images to Stack", "name=Stack title=[] use");
setBatchMode(false);
print ("superficie de toutes les selections :"+superficie); // superficie a multiplier par l epaisseur pour avoir le volume
Omega=superficie*X*Y*Z;
print ("Volume Total Omega :"+Omega);

Stack.getStatistics(voxelCount, mean, min, max, stdDev);
w=(mean*voxelCount)/255;
print("Nombre de pixels correspondant au vide et necroses:" +w);
vide=w*X*Y*Z;
print("vide et necroses:" +vide);
