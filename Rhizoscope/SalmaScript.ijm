/* Written 2013 by Volker Baecker (INSERM) at Montpellier RIO Imaging (www.mri.cnrs.fr)
 revu en 2015 par Marc Lartaud Cirad
 

//Pour installer cet outil, Dans Fiji, cliquer sur Plugins > Macros > Install ... , et ensuite selectionner ce fichier .ijm. Vous devriez voir apparaitre 8 nouveaux boutons dans l'interface de Fiji
 
 Outils:
 - Parametres
	Nombre de plantes a analyser
	Largeur de la plaque (cm) utile a la calibration
	Parois de la plaque (cm) pour retirer les bords de la plaque 
	Nombre de profondeurs ou les diametres seront mesures
	Rayon du filtre zone racine: etalement des bords des racines avant seuillage par l utilisation du filtre Maximum 
	Surface mini zone racine: la zone apres filtrage doit faire au moins cette surface pour etre selectionnee
	Surface mini racine : les objets plus petits ne sont pris en compte
	Couleurs : des differentes selections
	Profils en profondeur : calcul du gradient de zone racinaire et de racine en profondeur 
							une valeur tout les 2 cm
	
 - Echelle : calibration spatiale par detection de la largeur de la plaque et validation
 - Selections : permet de selectionner les differents objets	
		dans le cas de 2 plantes il faut commencer par celle de gauche
 - Diametres : nouvelle fenetre qui permet de tracer les diametres des racines a une certaine profondeur
				avec la touche 1 du pave numerique pour ajouter un diametre
				ou 0 pour enlever une selection
 - Segmentation : permet apres filtrage de seuiller une zone racinaire et de la valider
				ainsi qu une segmentation des racines par un seuillage local
 - Resultats : tableau de resultats avec le nombre de racines et leur diametre moyen pour chaque profondeur
				profils de surface de zone racinaire et racine en fonction de la profondeur
				clic droit mesures sur tout un repertoire
 - Suivante : Sauvegarde de l image et du ROI Manager associe
				Remise a zero
				Ouverture de l image suivante du meme repertoir
 
 
 
 

 
 
 
 
*/
// Variables globales
showMessage("Hello world");

var NUMBER_OF_PLANTS=1;		// the number of plants

var BOX_WIDTH = 21.5;		// the width of the rhizo-box (in reality 20)
var DELTA = 10;		// half of the height of the selection used to auto-set the scale
var THRESHOLD_METHODS = newArray("Default", "Huang", "Intermodes", "IsoData", "IJ_IsoData", "Li", "MaxEntropy", "Mean", "MinError",  "Minimum", "Moments",  "Otsu", "Percentile", "RenyiEntropy", "Shanbhag", "Triangle", "Yen");
var THRESHOLD_METHOD = "Huang";

var NUMBER_OF_DEPTHS=2;		// the number of possible depths at which the diameter of the roots can be measured
var IM_DIAM_HIGTH = 20;		// radius of the region around the click that is copied and zoomed
var ROOT_DEPTHS = newArray(40,0,0);
var DRAW_DIAM=0;
var SCALE_COLOR="green";	// color of the line that indicates the distance used to set the spacial scale of the image
var COLOR_DEPTH = "cyan";		// color of the line drawn at count root depth
var ANGLE_COLOR = "red";		// the color for marking the measured angle
var MEASURE_DEPTH_COLOR = "blue";	// the color of the line indicating the max. depth to which the root goes down

var DIAMETER_COLOR = "red ";	// color of the line indicating the measured root diameters

var BOX_PAROI=0.8;

var COLORS = newArray("red", "green", "blue", "yellow", "magenta", "cyan");

var ROOT_RADIUS=10;
var ZONE_AREA=50000;
var ROOT_AREA=1000;

var PROFIL=false; //true

macro "AutoRun" {
	
}

macro "Parametres Action Tool - C333D18D28D34D37D38D39D3cD44D45D46D47D48D49D4aD4bD4cD54D55D56D5aD5bD64D65D6bD6cD72D73D74D75D7bD7cD7dD7eD82D83D84D85D8bD8cD8dD8eD94D95D9bD9cDa4Da5Da6DaaDabDb4Db5Db6Db7Db8Db9DbaDbbDbcDc3Dc4Dc7Dc8DccDd8De8CaaaD07D2dD32D76D86DdbDf7C333D27D33D43D59D5cD6aD9aDa9DacDc9DcbDd7CdddD00D01D02D03D04D05D0aD0bD0cD0dD0eD0fD10D11D12D1eD1fD20D21D2fD30D31D3fD40D41D4fD88Da0Da1DafDb0Db1DbfDc0Dc1DcfDd0Dd1DdfDe0De1DeeDefDf0Df1Df2Df3Df4Df5DfbDfcDfdDfeDffCdddD06D13D14D15D1aD1bD1cD1dD22D2eD50D51D52D5eD5fD60D77D78D79D87D89D90Da2DaeDdeDe2De3De4De5DeaDebDecDedDf6DfaC555D3aD66D96DcaCbbbD16D25D3eD67D6fD70D80D97D9fDe6C444D35D3dD58Da8Dc6C777D6dCbbbD09D5dDadDb2DddDf9C444D17D3bD57D71D81Da7Db3De7C666D19D2cD4dD7aD8aD9dDdcDe9CcccD2aDceDd5DdaC555D29D36D63D93Dc5DcdDd9C999D08D6eD9eDc2Df8CaaaD26D2bD42D61D91Dd6C666D7fD8fDbdC888Da3CcccD4eD68D98DbeDd2C999D69D99C777D24D53Dd3Dd4C888D23D62D92"{
	Dialog.create("Parametres");
	Dialog.addMessage("PLANTES");
	Dialog.addSlider("Nombre de plantes:", 1, 2, NUMBER_OF_PLANTS);
	//Dialog.addNumber("Nombre de plantes:", NUMBER_OF_PLANTS);
	Dialog.addMessage("PLAQUE");
	Dialog.addNumber("Largeur de la plaque (cm):", BOX_WIDTH);
	Dialog.addNumber("Parois de la plaque (cm):", BOX_PAROI);
	//Dialog.addChoice("Methode de seuillage:", THRESHOLD_METHODS,THRESHOLD_METHOD);
	//Dialog.addNumber("Largeur de la selection:", DELTA);
	Dialog.addMessage("DIAMETRES");
	Dialog.addSlider("Nombre de profondeurs:", 1, 3, NUMBER_OF_DEPTHS);
	//Dialog.addNumber("Nombre de profondeurs:", NUMBER_OF_DEPTHS);
	//Dialog.addNumber("Largeur de la bande pour mesurer les diametres:", IM_DIAM_HIGTH);
	Dialog.addMessage("RACINE");
	Dialog.addNumber("Rayon du filtre zone racine:", ROOT_RADIUS);
	Dialog.addNumber("Surface mini zone racine:", ZONE_AREA);
	Dialog.addNumber("Surface mini racine:", ROOT_AREA);	
	Dialog.addMessage("COULEURS");
	Dialog.addChoice("Calibration:", COLORS,SCALE_COLOR);
	Dialog.addChoice("Profondeur:", COLORS,COLOR_DEPTH);
	Dialog.addChoice("Angle:", COLORS,ANGLE_COLOR);
	Dialog.addChoice("Fenetres:", COLORS,MEASURE_DEPTH_COLOR);
	Dialog.addChoice("Diametre:", COLORS,DIAMETER_COLOR);
	Dialog.addMessage("CALCULS");
	Dialog.addCheckbox("Profils en profondeur", PROFIL) 
	Dialog.show();
	NUMBER_OF_PLANTS=Dialog.getNumber();
	BOX_WIDTH=Dialog.getNumber();
	BOX_PAROI=Dialog.getNumber();
	//THRESHOLD_METHOD= Dialog.getChoice();
	//DELTA=Dialog.getNumber();
	NUMBER_OF_DEPTHS=Dialog.getNumber();
	//IM_DIAM_HIGTH=Dialog.getNumber();
	ROOT_RADIUS=Dialog.getNumber();
	ZONE_AREA=Dialog.getNumber();
	ROOT_AREA=Dialog.getNumber();
	SCALE_COLOR= Dialog.getChoice();
	COLOR_DEPTH= Dialog.getChoice();
	ANGLE_COLOR= Dialog.getChoice();
	MEASURE_DEPTH_COLOR= Dialog.getChoice();
	DIAMETER_COLOR= Dialog.getChoice();
	PROFIL=Dialog.getCheckbox();

	Dialog.create("Profondeurs");
	for (i=0; i<NUMBER_OF_DEPTHS; i++) {
		Dialog.addNumber("Profondeur "+i+1+":", ROOT_DEPTHS[i]);	
	}
	Dialog.show();
	for (i=0; i<NUMBER_OF_DEPTHS; i++) {
	ROOT_DEPTHS[i]=Dialog.getNumber();
			
	}
	

}


/////////////////////////////////////////////////Echelle///////////////////////////////////////////////////////////
macro "Echelle Action Tool - C222D4aD4bD8aD8bDaaDabCfffD00D08D09D0aD0bD0cD0dD0eD0fD10D18D19D1aD1bD1cD1dD1eD1fD20D21D22D23D25D26D27D28D29D2aD2bD2cD2dD2eD2fD30D31D32D33D35D36D37D38D39D3aD3bD3cD3dD3eD3fD40D41D42D43D45D46D47D48D4dD4eD4fD50D51D52D53D55D56D57D58D5aD5bD5dD5eD5fD60D61D62D63D65D66D67D68D69D6aD6bD6cD6dD6eD6fD70D71D72D73D75D76D77D78D79D7aD7bD7cD7dD7eD7fD80D81D82D83D85D86D87D88D8dD8eD8fD90D91D92D93D95D96D97D98D9aD9bD9cD9dD9eD9fDa0Da1Da2Da3Da5Da6Da7Da8DadDaeDafDb0Db1Db2Db3Db5Db6Db7Db8DbaDbbDbcDbdDbeDbfDc0Dc1Dc2Dc3Dc5Dc6Dc7Dc8DcdDceDcfDd0Dd1Dd2Dd3Dd5Dd6Dd7Dd8Dd9DdaDdbDdcDddDdeDdfDe0De8De9DeaDebDecDedDeeDefDf0Df8Df9DfaDfbDfcDfdDfeDffC89fD01D07D11D17De2De3De5De6Df1Df7C03fD02D03D04D05D06D12D13D14D15D16D24D34D44D54D64D74D84D94Da4Db4Dc4Dd4De4Df2Df3Df4Df5Df6CbcfDe1De7C444Da9C333D49D89DcaDcbC666Dc9C555D59D5cD99Db9C999D4cD8cDacDcc"{

	saveSettings();
	setBatchMode(true);
	height = getHeight();
	width = getWidth();
	if (width>height) {
		run("Rotate 90 Degrees Left");
		height = getHeight();
		width = getWidth();
		}
	run("Duplicate...", "title=scale_tmp");
	run("8-bit");
	setAutoThreshold(THRESHOLD_METHOD +" dark");
	doWand(width/2, height/2);
	setKeyDown("alt");
	makeRectangle(0, 0, width, (height /2)-DELTA);
	setKeyDown("alt");
	makeRectangle(0, (height /2)+DELTA, width, height);
	setKeyDown("none");
	getSelectionBounds(x, y, selectionWidth, selectionHeight);
	selectWindow("scale_tmp");
	close();
	setBatchMode(false);
	makeLine(x, y, x+selectionWidth, y+selectionHeight);
	title = "Largeur de la plaque";
	msg = "Corrigez le trait, puis cliquez sur Ok.\nIl doit correspondre aux bords exterieurs de la plaque";
	waitForUser(title, msg);
	run("Set Scale...", "distance=0");
//TODO : it should be safer to select only delta x, because there is a huge risk that the estimated length being too long due to deltaY
	List.setMeasurements;
	lg=List.getValue("Length");
	run("Set Scale...", "distance="+lg+" known="+BOX_WIDTH+" pixel=1 unit=cm");
	RoiAdd("Largeur_plaque",SCALE_COLOR);
	restoreSettings;
	
}

/////////////////////////////////////////////////Selections///////////////////////////////////////////////////////////
macro "Selections Action Tool - C666D64CfffD00D01D03D04D06D0cD0fD10D12D13D15D16D1eD1fD21D22D24D25D2fD4bD57D5aD5cD5dD69D6bD6cD6eD70D72D78D7aD7bD7dD7eD81D89D8aD8cD8dD90D93D98D99D9bD9cD9eDa2Da8DaaDabDadDb1Db4Db9DbaDc0Dc3DcfDd2Dd4Dd5DddDdeDdfDe0De1De2De3De4De6De7De9DeaDecDedDefCeeeD07D60D76CbbbD51D61D62D65D94D95CfffD02D05D0bD0dD0eD11D14D1cD1dD20D23D26D2eD3bD4aD4cD4dD58D59D5bD5eD67D68D6aD6dD71D77D79D7cD80D82D83D87D88D8bD8eD91D92D96D97D9aD9dDa0Da1Da3Da9DacDaeDb0Db2Db3Db7Db8Dc1Dc2Dc4Dd0Dd1Dd3DdcDe5De8DebDeeDf0Df1Df2Df3Df4Df5Df6Df7Df8Df9DfaDfbDfcDfdDfeDffC999DbfCfeeD0aCdddD29D2dD3cD42D45D48D49DbcDc5C888D74CeeeD3aD3fD73DbbDceDdbCcccD1bD43D44D46D47D56Da7Dd7Dd8Dd9CaaaD17D63D86DbdCdddD27D2aD30Da4Dd6DdaC777D38D4fD5fD6fD7fD85D8fD9fDa5CcccD09D4eD52D53D54D55D66DcdCaaaD08D19D31D3eDb5Dc7Dc8Dc9C988DcbCeddD75C777D39DafCbbbD41Db6C999D18D2bD32D33D34D35D36D37DcaC888D1aD28D40D50Da6DbeDc6C999D2cD3dD84Dcc"{
	///
	if (NUMBER_OF_PLANTS>1) showMessage("Selections", "Commencer les selections\npar la plante de gauche");
	for (k=1; k<=NUMBER_OF_PLANTS; k++) {	
		Selection_Type("Plante "+k+" Haut","Plante "+k+"\nHaut\nPointer sur le haut de la racine\nPuis cliquer sur \"OK\"",10);
		RoiAdd("Pl"+k+"_Haut","yellow");
		run("Original Scale");
		Selection_Type("Plante "+k+" Premiere_ramification","Plante "+k+"\nPremiere_ramification\nPointer sur la première ramification (en partant du haut)\nPuis cliquer sur \"OK\"",10);
		RoiAdd("Pl"+k+"_Premiere_ramification","yellow");
		run("Original Scale");
		Selection_Type("Plante "+k+" Bas", "Plante "+k+"\nBas\nPointer sur le bas de la racine\nPuis cliquer sur \"OK\"",10);
		RoiAdd("Pl"+k+"_Bas","yellow");
		run("Original Scale");
		Selection_Type("Plante "+k+" Angle","Plante "+k+"\nAngle\nTracer la premiere ligne a droite\nPuis cliquer sur \"OK\"",5);
		RoiAdd("Pl"+k+"_AngleA",ANGLE_COLOR);
		run("Original Scale");
		Selection_Type("Plante "+k+" Angle","Plante "+k+"\nAngle\nTracer la deuxieme ligne a gauche\nPuis cliquer sur \"OK\"",5);
		RoiAdd("Pl"+k+"_AngleB",ANGLE_COLOR);
		run("Original Scale");
		///
		}
		if (NUMBER_OF_PLANTS>1){
			Selection_Type("Intersection","Pointer sur la premiere intersection des racines\nPuis cliquer sur \"OK\"",10);
			RoiAdd("Intersection","yellow");
			run("Original Scale");
		}
	}
	
	
	
/////////////////////////////////////////////////Diametres///////////////////////////////////////////////////////////

macro "Diametres Action Tool - C08fD00D01D02D03D04D0bD0cD10D11D12D20D21D2fD30D36D37D38D39D3fD40D44D45D46D47D48D4fD54D55D56D57D63D64D65D66D6bD6cD73D74D75D7aD7bD7cD83D84D8aD8bD8cD93D99D9aD9bD9cDa8Da9DaaDabDb0Db7Db8Db9DbaDbbDbfDc0Dc6Dc7Dc8Dc9DcaDcfDd0Dd7Dd8Dd9DdeDdfDedDeeDefDf3DfcDfdDfeDffC39fDd5C08fD35D3eD50D5fD85D89D94D98Da3DacDd6CbdfD23DadDdbC6bfDa4C29fD22D58D5cDa0De0CeefDd2De5C4afDddDecC19fD05D0fD13D1fD27D67Dc5DcbDfbCcefD18D4aD5dDe1C9cfDb1C29fDf0Df4CeffD2bD42D71D78D7eD81D87D8eD91D96Da5C4afD06D80C18fD76CcdfD1aC7cfD62D97DbeC29fD2eD6fDceCeffD16D1dD24D33D3bD4dD61D69D9eDb2Db4DbdC6bfD07D08D0dD41D79D7dCdefD19D5aD6eDa1Dc2DdcDeaCacfDe6De9C39fD29DdaCfffD2cC4afD09D3aD5bD70DbcCbdfD51D59DccDd4Df6C7bfD14D95Df5C5afD1bD1cCcefDcdC9cfD3dD77Da2Df1C29fD49D60D9fDc1C4afD4eD82C19fD0aD28D31D53DafDb6CcefD2dD52DaeDe2DebC8cfDb3CadfD32D5eD68Df9CfffD3cDc3Dd3C3afD26D8fD90Dd1CbdfD1eDc4C7bfD88D9dDe7De8C5afD34D6aD72CdefDe4Df7C9cfD25D2aC09fDa7CcdfDf8C9dfDb5C5bfD8dD92DfaCdefD15D17D4bC8cfD6dD86C3afD7fDf2C7bfDe3C8cfDa6CadfD0eD4cC6bfD43"{
	origid=getImageID();
	getPixelSize(unit, pixelWidth, pixelHeight);	
	setTool("line");
	for (k=1; k<=NUMBER_OF_PLANTS; k++) {		
		RoiSelect("Pl"+k+"_Haut");
		Roi.getCoordinates(xpoints, ypoints);
		y_haut=ypoints[0];
		RoiSelect("Largeur_plaque");
		Roi.getCoordinates(xpoints, ypoints);
		bord=BOX_PAROI/pixelWidth;
		x_gauche=xpoints[0]+bord;
		x_droite=xpoints[1]-bord;
		for (j=0; j<NUMBER_OF_DEPTHS; j++) {		
				makeRectangle(x_gauche, y_haut+(ROOT_DEPTHS[j]/pixelWidth), x_droite-x_gauche, IM_DIAM_HIGTH);
				RoiAdd("Pl"+k+"_Profondeur"+ROOT_DEPTHS[j],MEASURE_DEPTH_COLOR);
				n_ini = roiManager("count");
				RoiSelect("Pl"+k+"_Profondeur"+ROOT_DEPTHS[j]);
				run("Duplicate...", "title=diam"+ROOT_DEPTHS[j]);
				run("Enhance Contrast...", "saturated=0.4");
				run("In [+]");
				run("In [+]");
				run("In [+]");
				DRAW_DIAM=1;
				title = "Diametres Plante"+k+" Profondeur "+ROOT_DEPTHS[j];
				msg = "Tracer chaque diametre et appuyer \nsur la touche 1 du pave numerique\npour le mettre la selection en memoire\nNavigation dans la fenetre a l aide de la roulette de la souris (haut bas) et le bouton espace-drag (de gauche à droite)";						
				waitForUser(title, msg);
				close();
				selectImage(origid);
				n_fin = roiManager("count");
				for(i=n_ini;i<n_fin;i++){
				roiManager("Select", i);
				roiManager("Rename", "Pl"+k+"_diam"+ROOT_DEPTHS[j]);
				Roi_Translate(n_ini-1,i);		
			}	
		}
	}
	DRAW_DIAM=0;
}


/////////////////////////////////////////////////Segmentation///////////////////////////////////////////////////////////

macro "Segmentation Action Tool - C020D46D68CbbbD05D5eD9dDeaC575D14D96CefeD8eDb2Dc2Dd2Df9DfcC354D31De1CcecDa7C898D98CfffDafDcfDdfC242D67CcccDfbC687Dc4CfffD0cD1aD1dD29D4cD8dD8fDacDddDedDf5C464D71D91CeeeDadDbfC9a9D03Db8CfffD0dD0eD0fD19D1bD1cD1eD1fD28D2aD2fD3eD3fD4dD4eD4fD7bD7cD7dD7eD7fDdeDf8DfdDfeDffC030D84CbcbDe3De4C676D77D79CffeDbbC454De0Df1CeedDdcC8a8D34C454D10CcdcD58C797Db5C474D81CefeD4aCaaaDf6C030D63D75D93CacbD38C575D43CefeD57D88Da8DabDbaDbcC364D90CdddDceC8a8Db3C353D01D11D21D41D70Da1Db1Dc0Dc1CcdcD86C787D8bC565D5aCeeeD02D12D22D2eD32D3dD42D9fDe2Df2C9b9D56C131D76CcdcD04D37DaaDd5Dd7C686D23D78Dc9CfffD5fDaeDe7DeeDefC454D30D69CeeeD0bD2bD4bDbdDecDf7C9a9D3bD5dCcddDf3C797D72D82Dc6C565Df0CefeD87CabaD18D7aC030D64D94C565D17C454D00D36D40D50CdedD89D9aC898D06DcbC353D24CcdcD3cD6bDfaC787D62C464D20Dd0Dd8C9a9D09DccC040D74CbdbD52C586Db4CeedD8cC9a9D27D9cDd6CcddD2dC797D92C474D61CabaD35Dc5C131Da5Db6CbcbD07D16D6aDd9C676D5bC464D51D60D80Da0Db0Dd1CdedDa9C8a8D13D48D66CddcD9eDebC787D15D39DcaC9b9D99C141D55C696D65CdddD0aD6eDdbC898D59De6C475Da3CbbaD9bCcecD49Db9C898D5cC242Da6CcdcDf4C787D08C030D73D83CdedDe5C8a9Dd4C797D8aD97CabaDcdCdedD6cD6dDdaCcdcDa2C9c9D44C232Dc8C575D26D47C353D45D53C787De9CcccD2cDe8C686D33CeeeD6fCdddDbeC474D54C676D3aC9baDc3C242D95C475D85CacaDd3C242Da4C343Db7Dc7CdeeD25"{
	saveSettings();
	origid=getImageID();
	getPixelSize(unit, pixelWidth, pixelHeight);
	RoiSelect("Pl1_Haut");
	Roi.getCoordinates(xpoints, ypoints);
	y_haut=ypoints[0];
	RoiSelect("Pl1_Bas");
	Roi.getCoordinates(xpoints, ypoints);
	y_bas=ypoints[0];
	if(NUMBER_OF_PLANTS==2){
		RoiSelect("Pl2_Haut");
		Roi.getCoordinates(xpoints, ypoints);
		y_haut=minOf(y_haut, ypoints[0]);
		RoiSelect("Pl2_Bas");
		Roi.getCoordinates(xpoints, ypoints);
		y_bas==maxOf(y_bas, ypoints[0]);
	}
	RoiSelect("Largeur_plaque");
	Roi.getCoordinates(xpoints, ypoints);
	bord=BOX_PAROI/pixelWidth;
	x_gauche=xpoints[0]+bord;
	x_droite=xpoints[1]-bord;
	makeRectangle(x_gauche, y_haut, x_droite-x_gauche, y_bas-y_haut);
	RoiAdd("Plaque","yellow");
	RoiSelect("Plaque");
	roiManager("Show None");
	run("Duplicate...", "title=nb");
	run("Split Channels");
	selectWindow("nb (blue)");
	close();
	selectWindow("nb (green)");
	close();
	selectWindow("nb (red)");
	rename("nb");
	run("Duplicate...", "title=densite");
	run("Subtract Background...", "rolling=50");	
//	run("Maximum...", "radius="+ROOT_RADIUS);
 // Why ?
	run("Threshold...");
	setAutoThreshold("Huang dark");
	getThreshold(lower, upper);
	setThreshold(lower, upper);
	waitForUser("Seuil","Reglage du Seuil");
	run("Analyze Particles...", "size="+ZONE_AREA+"-Infinity pixel show=Masks");
	rename("mask");
	run("Create Selection");
	RoiAdd("Zone_Racine","yellow");
	roiManager("Show None");
	close();
	selectWindow("densite");
	close();
	selectWindow("nb");
	resetThreshold();
	n=roiManager("count");
	roiManager("Select", n-1);
	setTool("brush");
	call("ij.gui.Toolbar.setBrushSize", 40); 
	waitForUser("Racine","Correction de la selection");
	//run("Interpolate", "interval=1");//voir feret!
	roiManager("Update");	
	roiManager("Deselect");
	run("Select None");
	run("Auto Local Threshold", "method=Niblack radius=50 parameter_1=0 parameter_2=0 white");
	roiManager("Select", n-1);
	setBackgroundColor(255, 255, 255);
	run("Clear Outside");
	run("Invert");
	run("Analyze Particles...", "size="+ROOT_AREA+" -Infinity pixel show=Masks");
	run("Create Selection");
	RoiAdd("Racine","magenta");
	roiManager("Show None");
	close();
	selectWindow("nb");
	run("Duplicate...", "title=Copie_de_nb");

	selectWindow("nb");
	close();

	Roi_Translate(n-2,n-1);
	Roi_Translate(n-2,n);
	
	selectImage(origid);
	//roiManager("Show All");	
	setTool("rectangle");
	restoreSettings;
}

/////////////////////////////////////////////////////Resultats /////////////////////////////////////////////////////////////////////////////////////

macro "Resultats Action Tool - C052DbfDcfDdfDebDecDedDeeDefCbebD5dDc6C364D84D85D93D94D95Da3CffeDa9C282D5bCdecD7aC798D83CfffD05D06D07D08D09D0aD0bD0cD0dD0eD1eD2eD3eD41D4eD51D5eD61D6eD71D73D7eD81D8eD91D97D9eDa1Da7Da8DaeDb1Db9DbaDbeDc1DcbDccDceDd1Dd2Dd3Dd4Dd5Dd6Dd7Dd8Dd9DdaDdbDddDdeC063D59CbceDf3Df4Df5Df6C7b4D65D9aCfffDa6Db4Db5Dc3Dc4DdcC592D4cCefeD12D14D32D63CacbD01C052DafCdedD16D17D18D19D1aD1bD1cD1dD23D24D25D26D27D28D35D36D52D62D72D82D92Da2Db2Dc2C385D7cCfffD13D22Db6DcaC382D4bD5cCdeeD00C9daDbdC163D5fDe5De6CbceDf0Df1Df2C8c5D56C6a1D3cCffeD04D31D8cCbceDf7Df8Df9CdddD74C484D75C364D86CdedD15D42Dc5C8c8D57C163D6fC8c4D67D89C493D33CacdDfaDfbDfcDfdDfeDffC172D5aC7a4D87C483D90Da0CeeeDa5CadaD3aC164D58C9c5D99C5a4D53CcecD2aD2bD2dD38D39D46D47Db8C273D1fDe1C798Db3C163D7fDe7De8C8b4D76C493D70CbebDb7C053D69C6a5D30C383Dd0CadaD9dC273D3fD4fDe3De4C9d4D78C5a3D44CcedD29D37C576Da4C373D0fDe0Cac8DaaC173D6aC9c4D77D88C593D50C272D6cC8b7D02D11C483D80CaeaD8dDc9C9c7D2cC7b4D55D9bCcdcD03D21C273D2fDe2C8b8D20C063D8fDe9C592D3bCaebD7dDc8C062D9fDeaC496D7bCadaDadDcdC593D68C9c7D64C493D43C172D4aD6bC6b5DbcCbdaD34C8c6D9cC5a4DacC8a9D96C8c4D66D8aC493D60CbebD6dDc7C5a6D49C383Db0Dc0C9c4D79C6a3D54DabCad9D8bC593D40C9c7D45CcebD98CacbD10CcecD4dCcdbDbbCcecD3dD48"{
	
	
	dir=getInfo("image.directory");
	nom=getTitle();
	nom=replace(nom,".tif","");
	Mesures();
		
		
}

macro 'Resultats Action Tool Options'  {

		dir = getDirectory("Choisir un repertoire source");
		list = getFileList(dir);
		setBatchMode(true);
		for (i=0; i<list.length; i++) {												
			 if (endsWith(list[i], ".zip")){	
			 				roiManager("Open", dir+list[i]);										//condition sur l extension tif
			 			 nom=substring(list[i],0,indexOf(list[i],"-"));		//nom sans l extension
			 			open(dir + nom+".tif");	
			 				Mesures();
			 				close();
			 				roiManager("Reset");
			}

	}
}

///////////////////////////////////////////////////Suivante//////////////////////////////////////////////////////////////////

macro "Suivante Action Tool - C16aD9dDaeCec7D18D40D50Cca4D6bD6cD6dD6eCffbD71Da2C09eDbdCfeaD27D28D36D37D46D55Da4Ccb7D76D86CfffD00D01D02D03D04D05D06D07D08D09D0aD0bD0cD0dD0eD0fD9fDd0Dd1Dd2Dd3Dd4Dd5DdfDe0De1De2De3De4De5De6De7De8De9DeaDeeDefDf0Df1Df2Df3Df4Df5Df6Df7Df8Df9DfaDfdDfeDffC368D8cCed9D10D20Ccb6D78CfedD2fC4beDadCffaD25D44D53Cdc8D74D84C28bDa6Db6Dc6Dd7Dd8Dd9DdaDdbDebDfbCed8D31Cdb5D66Dc4CffcD81D91Da1C1afDaaDb9DbaCfeaD42D45D94Db3Cec7D4dD5cCb93D7eD8eCfe9Da5Db5Cdb6D1eDa0CffeD8fC8ceDbeDcdDdcCffbD22D23D24D32D33D34D43D93Da3Db1Db2Cdc8D73C27bDceDddDecCed8D11D12D13D41Cca4D6aCffbD92C0afDacDbbCedbD3fDc0Cec7D1bD1cD70D80C368D7bCee9D2aD39D48D58Cdb6D2eD3eD4eD5eD62D63C5cfDc7Dc8Dc9DcaCed8D2dD3cD4bD5aCed8D2bD3aD3bD4aD59Cdb5D64Dc2C2afDa8CffaD26D35D54Cec7D19Cca5D79D89Cfe9D47D56D95Db4Cec6D1dD90CffeD1fC9bdDafDcfDedDfcCdc9D72C17bD97D98D99D9aD9bCec8D14D15D16D17D30Cca4D6fC09eDccCcc7D75C886D7cD8dCed9D49D52Ccb6D77D87C4bfD9cCed7D3dD4cD5bCdb5D65Dc3Cec7D1aD60Db0Cba4D7dCfe9D21D29D38Cdc8D83Cda5D67D68Dc5C0afDb8Cdc7D5dC69aD96Cfd9D51C3beDa7CfebD82C8aaDdeCdd9D61C17bDbfC787D9eCcb6D88Cee9D57Cda4D69C478D8bC2bfDa9Cec9D4fC09fDbcCdc7Dc1Cdb6D5fC5bfDcbCca5D7aD8aCed8D2cC1afDabC59bDd6C3bfDb7CddcD7fCdc7D85"{
	
	dir=getInfo("image.directory");
		nom=getTitle();
		nom=replace(nom,".tif","");
		roiManager("Save", dir+nom+"-RoiSet.zip");//sauvegarde de roi manager
		run("Remove Overlay");
		run("Save");	
	
	
	
	run("Open Next");
	if (isOpen("ROI Manager")){
		roiManager("Deselect");
		n = roiManager("count");
		if (n>0) roiManager("Delete");
	}
	dir=getInfo("image.directory");
	nom=getTitle();
	nom=replace(nom,".tif","");
		
	if (File.exists(dir+nom+"-RoiSet.zip") ) 	roiManager("Open",dir+nom+"-RoiSet.zip");
	getDimensions(width, height, channels, slices, frames);
	if (width>height) run("Rotate 90 Degrees Left");
}









///////////////////////////////????????????????//////////////////////////////////

macro "About These Macros Action Tool - C000C111C222C333C444C555D54D55D63D73D7cD7dD83D88D89D8aD8cD8dD93D97Da3Da4Da5Da6C555D7aDb5C555D72D82C555D45Da7C555D98C555D53C555D79C555C666Db4C666Db6C666C777D92C777D87C777D64C777D62C777C888D44C888D96C888D78C999D94C999CaaaCbbbD99Db3CbbbDa2CbbbDa8CbbbCcccDb7CcccD52CcccD43CcccD65CcccCdddD74CdddD77CdddD86CdddD84D95CdddD00D01D02D03D04D05D06D07D08D09D0aD0bD0cD0dD0eD0fD10D11D12D13D14D15D16D17D18D19D1aD1bD1cD1dD1eD1fD20D21D22D23D24D25D26D27D28D29D2aD2bD2cD2dD2eD2fD30D31D32D33D34D35D36D37D38D39D3aD3bD3cD3dD3eD3fD40D41D42D46D47D48D49D4aD4bD4cD4dD4eD4fD50D51D56D57D58D59D5aD5bD5cD5dD5eD5fD60D61D66D67D68D69D6aD6bD6cD6dD6eD6fD70D71D75D76D7bD7eD7fD80D81D85D8bD8eD8fD90D91D9aD9bD9cD9dD9eD9fDa0Da1Da9DaaDabDacDadDaeDafDb0Db1Db2Db8Db9DbaDbbDbcDbdDbeDbfDc0Dc1Dc2Dc3Dc4Dc5Dc6Dc7Dc8Dc9DcaDcbDccDcdDceDcfDd0Dd1Dd2Dd3Dd4Dd5Dd6Dd7Dd8Dd9DdaDdbDdcDddDdeDdfDe0De1De2De3De4De5De6De7De8De9DeaDebDecDedDeeDefDf0Df1Df2Df3Df4Df5Df6Df7Df8Df9DfaDfbDfcDfdDfeDff"{
open(getDirectory("macros")+"toolsets\\MRI_root_toolsV2.txt");
}



//////////////////////////Shortcut Key/////////////////

//supression de selection 
macro "ROI Delete [n0]"{
		if (DRAW_DIAM==1){
		if(selectionType()==5){
		roiManager("Delete");
		run("Select None");		
		}
		roiManager("Show All with labels");
	}
	
macro "ROI Ajoute [n1]"{
		if (DRAW_DIAM==1){
		if(selectionType()==5) RoiAdd("diam",DIAMETER_COLOR);
		run("Select None");
		roiManager("Deselect");
		roiManager("Show All with labels");
		}
	}

//Zoom to selection

macro "Zoom [n3]"{
run("To Selection");
}


//////////////////Functions////////////////////




function Selection_Type(titre,message,type){
	if (type==0 ) setTool("rectangle");
	if (type==1 ) setTool("oval");
	if (type==2 ) setTool("polygon");
	if (type==3 ) setTool("freehand");
	if (type==5 ) setTool("line");
	if (type==8 ) setTool("angle");
	if (type==10 ) setTool("point");
	if (type==4 ) setTool("wand");
	waitForUser(titre, message);
//	if (selectionType() !=type)	Selection(titre,message,type);	
	}
	

function RoiAdd(nom,couleur) {
	roiManager("Add");
	n = roiManager("count");
	roiManager("Select", n-1);	
	roiManager("Rename", nom);
	roiManager("Set Color", couleur);
	run("Select None");
	roiManager("Deselect");
	roiManager("Show All");
}

function RoiSelect(nom){
index=-1;
	n=roiManager("count");
	for(i=0;i<n;i++){
		roiManager("Select", i);
			if (Roi.getName==nom) index=i;
		}	
	if(index==-1)	exit("Pas de selection "+nom);
	roiManager("Select", index);
	
}

function RoiSuppr(nom){
	n=roiManager("count");
	if (n>0){
	for(i=n-1;i>=0;i--){
		roiManager("Select", i);
		if (Roi.getName==nom)	roiManager("Delete");
		}	
	}		
}

function RoiGetIndex(nom){
index=-1;
	n=roiManager("count");
	for(i=0;i<n;i++){
		roiManager("Select", i);
			if (Roi.getName==nom) index=i;
		}	
	
	roiManager("Deselect");
	run("Select None");
	return index;	
}



function Roi_Translate(index_duplic,index_roi){
	roiManager("Select", index_duplic);
	getSelectionBounds(x, y, width, height);
	dx=x;
	dy=y;
	roiManager("Select", index_roi);
	getSelectionBounds(x, y, width, height);
	setSelectionLocation(x+dx, y+dy);
	roiManager("Update");
	roiManager("Deselect");
}

function Mesure_Angle(){
	run("Clear Results");
	roiManager("Measure");
	angle=getResult("Angle", 0);
	if(angle<0) angle=180+angle;
	run("Clear Results");
	return angle;
	}
	
function Mesure_Longueur(){
	run("Clear Results");
	roiManager("Measure");
	longueur=getResult("Length", 0);
	run("Clear Results");
	return longueur;
	}
	
function Tablentete(titre,tab){
	title1 = titre;
	title2 = "["+title1+"]";
	fe = title2;
	result="\\Headings:"+tab[0];
	for (i=1; i<tab.length; i++){
		result=result+" \t"+tab[i];
	}
	if( !isOpen("Resultats")){
			run("Table...", "name="+title2+" width=1400 height=600");
		print (fe,result);
	}
}
//
function Tableresult(titre,tab){
	title1 = titre;
	title2 = "["+title1+"]";
	fe = title2;
	result=""+tab[0];
	for (i=1; i<tab.length; i++){
		result=result+" \t"+tab[i];
	}
	print(fe,result);
}



function Mesures(){
	getDimensions(width, height, channels, slices, frames);
	if (width>height) run("Rotate 90 Degrees Left");
	getPixelSize(unit, pixelWidth, pixelHeight);
	if (pixelWidth==1){
		RoiSelect("Largeur_plaque");
		List.setMeasurements;
		lg=List.getValue("Length");
		run("Set Scale...", "distance="+lg+" known="+BOX_WIDTH+" pixel=1 unit=cm");
		roiManager("Deselect");
		run("Select None");	
		getPixelSize(unit, pixelWidth, pixelHeight);
	}
	//Plante 1
	nb_profondeur=0;
	nb_plante=1;
	inter=0;
	a=b=c=d=0;
	Diam_Pl1=newArray(10);
	Diam_Pl2=newArray(10);
	count_pronf_Pl1=-1;
	count_pronf_Pl2=-1;
	area_zone=-1;
	area_root=-1;
	setBatchMode(true);	
	ncount=roiManager("count");
	for(i=0;i<ncount;i++){
			roiManager("Select", i);
			nom_item=Roi.getName;
						if (nom_item=="Pl1_Haut"){
							Roi.getCoordinates(xpoints, ypoints);
							Pl1_y_haut=ypoints[0];	
							Pl1_y_hcol=ypoints[0];
							}
						if (nom_item=="Pl1_Bas"){
							Roi.getCoordinates(xpoints, ypoints);
							Pl1_y_hbas=ypoints[0];							
							}						
						if (nom_item=="Pl1_AngleA"){
							Pl1_AngleA=Mesure_Angle();
						}
						if (nom_item=="Pl1_AngleB"){
							Roi.getCoordinates(xpoints, ypoints);
							a=(ypoints[1]-ypoints[0])/(xpoints[1]-xpoints[0]);
							b=(ypoints[1]-a*xpoints[1]);
							Pl1_AngleB=Mesure_Angle();
						}
						if (nom_item=="Pl2_Haut"){
							nb_plante++;
							Roi.getCoordinates(xpoints, ypoints);
							Pl2_y_haut=ypoints[0];
							
						}
						if (nom_item=="Pl2_Bas"){
							Roi.getCoordinates(xpoints, ypoints);
							Pl2_y_hbas=ypoints[0];							
						}			
						if (nom_item=="Pl1_Premiere_ramification"){
							Roi.getCoordinates(xpoints, ypoints);
							Pl1_y_hcol=ypoints[0];	
						}	
							
						if (nom_item=="Pl2_AngleA"){
							Roi.getCoordinates(xpoints, ypoints);
							c=(ypoints[1]-ypoints[0])/(xpoints[1]-xpoints[0]);
							d=(ypoints[1]-c*xpoints[1]);
							Pl2_AngleA=Mesure_Angle();
						}
						if (nom_item=="Pl2_AngleB"){
							Pl2_AngleB=Mesure_Angle();
						}
						if (nom_item=="Intersection"){
							Roi.getCoordinates(xpoints, ypoints);
							x_inter=xpoints[0];
							y_inter=ypoints[0];
							inter=y_inter-Pl1_y_haut;
							}
						
						if (startsWith(nom_item, "Pl1_Profondeur")){
							count_pronf_Pl1++;
							Diam_Pl1[3*count_pronf_Pl1]=substring(nom_item,lengthOf(nom_item)-2);
							nb_profondeur++;
							count=0;
							somme=0;
							for(j=0;j<ncount;j++){
								roiManager("Select", j);
								nom_item=Roi.getName;
								if (startsWith(nom_item, "Pl1_diam"+Diam_Pl1[3*count_pronf_Pl1])){
									count++;
									somme=somme+Mesure_Longueur();
									}
							}
							Diam_Pl1[(3*count_pronf_Pl1)+1]=count;
							Diam_Pl1[(3*count_pronf_Pl1)+2]=somme;
						}
						if (startsWith(nom_item, "Pl2_Profondeur")){
							count_pronf_Pl2++;
							Diam_Pl2[3*count_pronf_Pl2]=substring(nom_item,lengthOf(nom_item)-2);
							count=0;
							somme=0;
							for(j=0;j<ncount;j++){
								roiManager("Select", j);
								nom_item=Roi.getName;
								if (startsWith(nom_item, "Pl2_diam"+Diam_Pl2[3*count_pronf_Pl2])){
									count++;
									somme=somme+Mesure_Longueur();
									}
							}
							Diam_Pl2[(3*count_pronf_Pl2)+1]=count;
							Diam_Pl2[(3*count_pronf_Pl2)+2]=somme;
						}
						if (nom_item=="Zone_Racine"){
							getStatistics(area);							
							area_zone=area;////////////////////////////////////////////area_portion
						}
						if (nom_item=="Racine"){
							getStatistics(area);							
							area_root=area;////////////////////////////////////////////area_portion
						}
						
			}	
		run("Select None");
		if (isOpen("Results")) {
			   selectWindow("Results");
			   run("Close");
		   } 
		
		hauteur_colletramif=(Pl1_y_hcol-Pl1_y_haut)*pixelHeight;		
		hauteur_Pl1=(Pl1_y_hbas-Pl1_y_haut)*pixelHeight;
		angle_Pl1=abs(Pl1_AngleB-Pl1_AngleA);
		if (Diam_Pl1[1]!=0) Diam_Pl1[2]=Diam_Pl1[2]/Diam_Pl1[1];
		if (Diam_Pl1[4]!=0) Diam_Pl1[5]=Diam_Pl1[5]/Diam_Pl1[4];
		if (Diam_Pl1[7]!=0) Diam_Pl1[8]=Diam_Pl1[8]/Diam_Pl1[7];
		
		if (nb_plante==2) {
			hauteur_Pl2=(Pl2_y_hbas-Pl2_y_haut)*pixelHeight;
			inter=inter*pixelHeight;
			angle_Pl2=abs(Pl2_AngleB-Pl2_AngleA);
			if (Diam_Pl2[1]!=0) Diam_Pl2[2]=Diam_Pl2[2]/Diam_Pl2[1];
			if (Diam_Pl2[4]!=0) Diam_Pl2[5]=Diam_Pl2[5]/Diam_Pl2[4];
			if (Diam_Pl2[7]!=0) Diam_Pl2[8]=Diam_Pl2[8]/Diam_Pl2[7];
		
		delta=0;
		if(c!=0&&a!=c){
			y_intheor=(b-((d*a)/c))/(1-(a/c));
			x_intheor=(y_intheor-d)/c;
			makePoint(x_intheor, y_intheor);
			RoiAdd("Intheor","yellow");
			difference=(y_inter-y_intheor)*pixelHeight;
			}
		}
		
	titre="Resultats";
		if (nb_plante==1) {
			if(nb_profondeur==1){
				tab_entete=newArray("Image","Plante","Hauteur","Hauteur_collet-ramif","Angle","Surface zone","Surface racine","Nb-racin-"+Diam_Pl1[0],"Diam-"+Diam_Pl1[0]);
				tab_result=newArray(nom,1,hauteur_Pl1,hauteur_colletramif,angle_Pl1,area_zone,area_root,Diam_Pl1[1],Diam_Pl1[2]);
					}
			if(nb_profondeur==2){
				tab_entete=newArray("Image","Plante","Hauteur","Hauteur_collet-ramif","Angle","Surface zone","Surface racine","Nb-racin-"+Diam_Pl1[0],"Diam-"+Diam_Pl1[0],"Nb-racin-"+Diam_Pl1[3],"Diam-"+Diam_Pl1[3]);
				tab_result=newArray(nom,1,hauteur_Pl1,hauteur_colletramif,angle_Pl1,area_zone,area_root,Diam_Pl1[1],Diam_Pl1[2],Diam_Pl1[4],Diam_Pl1[5]);
					}
			if(nb_profondeur==3){
				tab_entete=newArray("Image","Plante","Hauteur","Hauteur_collet-ramif","Angle","Surface zone","Surface racine","Nb-racin-"+Diam_Pl1[0],"Diam-"+Diam_Pl1[0],"Nb-racin-"+Diam_Pl1[3],"Diam-"+Diam_Pl1[3],"Nb-racin-"+Diam_Pl1[6],"Diam-"+Diam_Pl1[6]);
				tab_result=newArray(nom,1,hauteur_Pl1,hauteur_colletramif,angle_Pl1,area_zone,area_root,Diam_Pl1[1],Diam_Pl1[2],Diam_Pl1[4],Diam_Pl1[5],Diam_Pl1[7],Diam_Pl1[8]);
					}
				}
		
		//TODO : adapt the scheme with measurement of collet stuff gnagnagna
		if (nb_plante==2) {
			if(nb_profondeur==1){
				tab_entete=newArray("Image","Plante","Hauteur","Angle","Surface zone","Surface racine","Intersection","Delta","Nb-racin-"+Diam_Pl1[0],"Diam-"+Diam_Pl1[0]);
				tab_result=newArray(nom,1,hauteur_Pl1,angle_Pl1,area_zone,area_root,"","",Diam_Pl1[1],Diam_Pl1[2]);
				tab_result2=newArray(nom,2,hauteur_Pl2,angle_Pl2,"","",inter,difference,Diam_Pl2[1],Diam_Pl2[2]);
						}
			if(nb_profondeur==2){
				tab_entete=newArray("Image","Plante","Hauteur","Angle","Surface zone","Surface racine","Intersection","Delta","Nb-racin-"+Diam_Pl1[0],"Diam-"+Diam_Pl1[0],"Nb-racin-"+Diam_Pl1[3],"Diam-"+Diam_Pl1[3]);
				tab_result=newArray(nom,1,hauteur_Pl1,angle_Pl1,area_zone,area_root,"","",Diam_Pl1[1],Diam_Pl1[2],Diam_Pl1[4],Diam_Pl1[5]);
				tab_result2=newArray(nom,2,hauteur_Pl2,angle_Pl2,"","",inter,difference,Diam_Pl2[1],Diam_Pl2[2],Diam_Pl2[4],Diam_Pl2[5]);
						}
			if(nb_profondeur==3){
				tab_entete=newArray("Image","Plante","Hauteur","Angle","Surface zone","Surface racine","Intersection","Delta","Nb-racin-"+Diam_Pl1[0],"Diam-"+Diam_Pl1[0],"Nb-racin-"+Diam_Pl1[3],"Diam-"+Diam_Pl1[3],"Nb-racin-"+Diam_Pl1[6],"Diam-"+Diam_Pl1[6]);
				tab_result=newArray(nom,1,hauteur_Pl1,angle_Pl1,area_zone,area_root,"","",Diam_Pl1[1],Diam_Pl1[2],Diam_Pl1[4],Diam_Pl1[5],Diam_Pl1[7],Diam_Pl1[8]);
				tab_result2=newArray(nom,2,hauteur_Pl2,angle_Pl2,"","",inter,difference,Diam_Pl2[1],Diam_Pl2[2],Diam_Pl2[4],Diam_Pl2[5],Diam_Pl2[7],Diam_Pl2[8]);
						}
					}
		Tablentete(titre,tab_entete);
			if( isOpen(titre))Tableresult(titre,tab_result);
			if( nb_plante==2) Tableresult(titre,tab_result2);
		/////descente en profondeur!
		if(PROFIL){
				ncount=roiManager("count");
				index_zone=RoiGetIndex("Zone_Racine");
				index_racine=RoiGetIndex("Racine");
				RoiSelect("Pl1_Haut");
				Roi.getCoordinates(xpoints, ypoints);
				y_haut=ypoints[0];
				RoiSelect("Pl1_Bas");
				Roi.getCoordinates(xpoints, ypoints);
				y_bas=ypoints[0];
				if(nb_plante==2){
					RoiSelect("Pl2_Haut");
					Roi.getCoordinates(xpoints, ypoints);
					y_haut=minOf(y_haut, ypoints[0]);
					RoiSelect("Pl2_Bas");
					Roi.getCoordinates(xpoints, ypoints);
					y_bas==maxOf(y_bas, ypoints[0]);
				}
				RoiSelect("Largeur_plaque");
				Roi.getCoordinates(xpoints, ypoints);
				bord=BOX_PAROI/pixelWidth;
				x_gauche=xpoints[0]+bord;
				x_droite=xpoints[1]-bord;
				hauteur=y_bas-y_haut;
				espace=2/pixelWidth;
				nb_val=floor(hauteur/espace);
				profondeur=newArray(nb_val);
				area_zones=newArray(nb_val);
				area_racines=newArray(nb_val);
				setBatchMode(true);
				roiManager("Show None");
				for(i=0;i<nb_val;i++){
						profondeur[i]=i*2;
						makeRectangle(x_gauche, y_haut+i*espace, x_droite-x_gauche, espace);
						//RoiAdd("test","yellow");
						roiManager("Add");
						ncount=roiManager("count");
						if(index_zone!=-1){
							roiManager("Select",  newArray(index_zone,ncount-1));
							roiManager("AND");
							getStatistics(area);							
							area_zones[i]=area;
							}
						if(index_racine!=-1){	
							roiManager("Select",  newArray(index_racine,ncount-1));
							roiManager("AND");
							getStatistics(area);
							area_racines[i]=area;
							}
						roiManager("Deselect");				
						roiManager("Select",ncount-1);
						roiManager("Delete");			
				}
				Array.show("Profil des surfaces", profondeur,area_zones, area_racines);
				
		}



}
