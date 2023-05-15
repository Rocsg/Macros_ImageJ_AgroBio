run("Duplicate...", "title=temp duplicate");
run("8-bit");
run("Properties...");
run("Scale...", "x=0.5 y=0.5 z=0.5 interpolation=Bilinear average process");

nom=getTitle();
run("Orthogonal Views");
waitForUser("choix de la coupe de ref");
selectWindow(nom);
Stack.getPosition(channel, slice, frame) ;

run("Duplicate...", "title=greffon duplicate range="+slice+200+"-"+slice+200+50);
selectWindow(nom);

run("Duplicate...", "title=porte-greffe duplicate range="+slice-200+"-"+slice-150);

selectWindow("temp");
close();
selectWindow("temp-1");
close();
