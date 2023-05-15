run("Duplicate...", "title=temp duplicate");
run("8-bit");
run("Properties...");
run("Scale...", "x=0.5 y=0.5 z=0.5 interpolation=Bilinear average process");

nom=getTitle();
run("Orthogonal Views");

waitForUser("choix de la coupe de ref dans le greffon");
selectWindow(nom);
Stack.getPosition(channel, slice, frame) ;
sliceGreffon=slice;

waitForUser("choix de la coupe de ref dans le porte greffe");
selectWindow(nom);
Stack.getPosition(channel, slice, frame) ;
slicePorteGreffe=slice;


run("Duplicate...", "title=greffon duplicate range="+sliceGreffon+"-"+sliceGreffon+50);
selectWindow(nom);

run("Duplicate...", "title=porte-greffe duplicate range="+slicePorteGreffe-50+"-"+slicePorteGreffe);

selectWindow("temp");
close();
selectWindow("temp-1");
close();
