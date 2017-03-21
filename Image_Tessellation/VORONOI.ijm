//////////////////////////////////////////
// Remigio Picone, PhD
// 
// 06 Jan 2017
//////////////////////////////////////////

var IN_TEST_RADIOUS = false;
var LOG_DEBUG 	= 0;

var sDIR_IN 	= '';
var sDIR_OUT 	= '';
var sFILE_ID	= ''; 

var IN_MIN_FILT_RADIOUS = 2;
var IN_THRESH_METHOD = "RenyiEntropy";

macro "2 VORONOI [F1]"{

	// DIALOG INPUT 
	LoadinfoFromFile();

			
	Dialog.create("CELL AREA SEGMENTATION BY VORONOI DIAGRAMS (by RemiGio Picone)");
	//Dialog.addMessage("Be aware that the 0-255 threshold-range generates an infinite loop in the segmentation routine ...");
	Dialog.addString("Folder Images", sDIR_IN, 80);
	Dialog.addString("File identifier (ex. nucleus)", sFILE_ID, 80);
	Dialog.addMessage("FILTER");
	Dialog.addNumber("Minimum Filter radious", IN_MIN_FILT_RADIOUS);
	Dialog.addString("Thresholding method (e.g., Otsu, Yen, etc..)", IN_THRESH_METHOD, 50);
	Dialog.addCheckbox("TEST the radious", false);
	
	Dialog.addString("Folder Output", sDIR_OUT, 80);
	
	Dialog.show();

	sDIR_IN = Dialog.getString();
	if(sDIR_IN=="")
		exit("No directory specified!");
	
	sFILE_ID = Dialog.getString();
	if(sFILE_ID=="")
		exit("No File identifier specified!");

	IN_MIN_FILT_RADIOUS = Dialog.getNumber();
	IN_THRESH_METHOD = Dialog.getString();
	IN_TEST_RADIOUS = Dialog.getCheckbox();
	
	sDIR_OUT = Dialog.getString();
	if(sDIR_OUT=="")
		exit("No directory output!");
		
	SaveinfoToFile();

	////////////////////////////////////////////////
	// Open each single image and run the main()
	////////////////////////////////////////////////
	setBatchMode(true);

	oFileList 	= getFileList(sDIR_IN);
	nLen 		= lengthOf(oFileList);
	
	if(LOG_DEBUG==1)print("file name 0:" + oFileList[0]); 
	if(LOG_DEBUG==1)print("[LOG_DEBUG] Num files:" + nLen); 

	// the test consider only the first image to show the resutls
	if(IN_TEST_RADIOUS==true)
		nLen = 1;
		
	for (i=0; i<nLen; i++) {
		sFile = oFileList[i];
		
		showProgress(i/nLen);
		if(indexOf(sFile, sFILE_ID)>0){
			open(sDIR_IN + File.separator + sFile);
			
			MAIN(sFile);

			
			if(LOG_DEBUG==1)print("whole file name :" + sDIR_IN + File.separator + sFile); 

			if(IN_TEST_RADIOUS==false){
				close();
			}

			if(IN_TEST_RADIOUS==true){
				open(sDIR_IN + File.separator + sFile);
				roiManager("Show All");
				roiManager("Show All without labels");
			}

		}

	}
	
	
	setBatchMode(false);

	exit("The Voroni diagrams have been completed!");

}

function MAIN(sFileImage){


		ROI_CLEAR();
	
	//run("Median...", "radius=3");
	// minimum filter is good for watershed becasue it reduces the shape isotropically 
	// I normally use IN_MIN_FILT_RADIOUS between 3 and 15
	run("Gaussian Blur...", "sigma=2");
	run("Minimum...", "radius="+IN_MIN_FILT_RADIOUS);

	// auto segmentation of nuclei
	setAutoThreshold(IN_THRESH_METHOD + " dark");
	setOption("BlackBackground", false);
	run("Convert to Mask");
	
	run("Fill Holes");
	
	// watershed to split touching nuclei
	run("Watershed");

	// reduces the shape a bit more to separate more apart  very close nuclei 
	run("Minimum...", "radius=1");
	
	
	// voronoi diagram to segment cell areas in a group of cells 
	// bigger the voronoi area more compact the cells (contact inhibition param) 
	run("Voronoi");
	
	// find the roi of the single voronoi areas
	// the single voronoi area represents a single cell
	
	run("Auto Local Threshold", "method=Mean radius=15 parameter_1=0 parameter_2=0 white");
	run("Invert");
	
	// find the ROIS including the edges
	run("Analyze Particles...", "size=300-Infinity show=Nothing add");

	// save rois
	
	if(lastIndexOf(sFileImage, ".")!=-1){
		sFileImage_noext = substring(sFileImage, 0, lastIndexOf(sFileImage, "."));
		sFileImage_KEY = substring(sFileImage_noext, 0, lastIndexOf(sFileImage_noext, "_"));
		roiManager("Save", sDIR_OUT + File.separator + sFileImage_KEY + "_voronoi.roiset.zip" );
	}

	if(IN_TEST_RADIOUS==false){
		ROI_CLEAR();
	}
	
	// TODO -------------------------
	// 
	// save rois
	// optional save  voronoi diagram image
	// save montage pf voroi diagram + nucleus (to visually validate the segmentation)
	// ------------------------------

}

function ROI_CLEAR(){
	// clear the ROI manager
	nLenRois = roiManager("count");
	if(nLenRois>0){
		roiManager("deselect");
		roiManager("Delete");
	}
	
}
//------------------------------------------------------------------
// LOAD and SAVE INPUT DATA
//

var m_sConstatsFileName = "dajrydeerrnddkkhhjj.txt";

function LoadinfoFromFile(){

	//Load the values from temporary file
	sFilePath = getDirectory("temp") + File.separator() + m_sConstatsFileName;
	if(File.exists(sFilePath) != 1)
		return -1;
	
	
	oContent = split(File.openAsString(sFilePath),"\n") ;
	
	if(lengthOf(oContent)<6) // NUM=4 x 5 controls each + 1 directory name control
		return -1;

	
	sDIR_IN = oContent[0];
	sFILE_ID = oContent[1]; 
	IN_MIN_FILT_RADIOUS = oContent[2];
	IN_THRESH_METHOD = oContent[3];
	IN_TEST_RADIOUS = oContent[4];
	sDIR_OUT = oContent[5];
	
	
	if(LOG_DEBUG) print("[LOG_DEBUG] input data loaded from " + sFilePath);
	
	return 0;
}


function SaveinfoToFile(){

	s="";
	s = s + sDIR_IN + "\n";
	s = s + sFILE_ID + "\n";
	s = s + IN_THRESH_METHOD + "\n";
	s = s + IN_MIN_FILT_RADIOUS + "\n";
	s = s + IN_TEST_RADIOUS + "\n";
	s = s + sDIR_OUT + "\n";
	

	sFilePath = getDirectory("temp") + File.separator() + m_sConstatsFileName;
	if(LOG_DEBUG) print("[LOG_DEBUG] input data saved in " + sFilePath);
			
	File.delete(sFilePath);
	f = File.open(sFilePath);
	print(f, s);
	File.close(f);

	return 0;
}
