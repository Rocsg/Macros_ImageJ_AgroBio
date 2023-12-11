for(i=1;i<15;i++){
	print(""+i);
	File.openSequence("/home/rfernandez/Bureau/A_Test/Aerenchyme/Xrays/Test-02_curve-resampling/High_res/IMGS/"+i+"/");
	saveAs("Tiff", "/home/rfernandez/Bureau/A_Test/Aerenchyme/Xrays/Test-02_curve-resampling/High_res/IMGS/Stacks/"+i+".tif");
}

run("Combine...", "stack1=1.tif stack2=2.tif");
run("Combine...", "stack1=[Combined Stacks] stack2=3.tif");
run("Combine...", "stack1=[Combined Stacks] stack2=4.tif");
run("Combine...", "stack1=[Combined Stacks] stack2=5.tif");
rename("line1");

run("Combine...", "stack1=6.tif stack2=7.tif");
run("Combine...", "stack1=[Combined Stacks] stack2=8.tif");
run("Combine...", "stack1=[Combined Stacks] stack2=9.tif");
run("Combine...", "stack1=[Combined Stacks] stack2=10.tif");
rename("line2");

run("Combine...", "stack1=11.tif stack2=12.tif");
run("Combine...", "stack1=[Combined Stacks] stack2=13.tif");
run("Combine...", "stack1=[Combined Stacks] stack2=14.tif");
rename("line3");

run("Combine...", "stack1=line1 stack2=line2 combine");
run("Combine...", "stack1=[Combined Stacks] stack2=line3 combine");

makeRectangle(198, 0, 4, 600);
setForegroundColor(255, 255, 255);
run("Fill", "stack");

makeRectangle(398, 0, 4, 600);
setForegroundColor(255, 255, 255);
run("Fill", "stack");

makeRectangle(598, 0, 4, 600);
setForegroundColor(255, 255, 255);
run("Fill", "stack");

makeRectangle(798, 0, 4, 600);
setForegroundColor(255, 255, 255);
run("Fill", "stack");

makeRectangle(0, 198, 1000, 4);
setForegroundColor(255, 255, 255);
run("Fill", "stack");

makeRectangle(0, 398, 1000, 4);
setForegroundColor(255, 255, 255);
run("Fill", "stack");
