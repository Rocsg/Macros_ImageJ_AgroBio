//ChatGPT4 Prompt:
//Please, can you write me an ImageJ script that takes the open stack that have 12071 z-slices, that split it into non-contiguous blocks by forgetting 30 slices around the 6 given Z values (1450, 2790, 4090, 6690, 8020, and 9313), and then concatenate the resulting 7 blocks into a single stack ?

// Define the z-values around which slices will be omitted
originalImage=getTitle();
zValues = newArray(1450, 2790, 4090, 6690, 8020, 9313);
margin = 30; // Number of slices to omit around each z-value

// Calculate the start and end slices for each segment
starts = newArray(zValues.length + 1);
ends = newArray(zValues.length + 1);
starts[0] = 1;
for (i = 0; i < zValues.length; i++) {
	starts[i + 1] = zValues[i] + margin + 1;
	if (i < zValues.length) {
		ends[i] = zValues[i] - margin - 1;
    }
}
ends[zValues.length] = 12071; // End slice of the last segment


// Process each segment
for (i = 0; i < starts.length; i++) {
    // Duplicate the segment
	print("Processing stack "+i+ " from "+starts[i]+" to "+ends[i]);
	selectWindow(originalImage);
    run("Duplicate...", "title=temp" + i + " duplicate range=" + starts[i] + "-" + ends[i]);
}


// Concatenate the remaining segments
concatCommand = "  image1=temp0";
for (i = 1; i < starts.length; i++) {
    if (starts[i] <= ends[i]) {
        concatCommand += " image" + (i + 1) + "=temp" + i;
    }
}
print(concatCommand)
run("Concatenate...", concatCommand);


// Rename the final stack
selectWindow("Untitled");
rename("Final_Stack");

