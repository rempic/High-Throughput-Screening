////////////////////////////////////////////////////////////////////
// DATA (BEGIN)
// by RemiGIO Picone
// 1/feb/2017
// Harvard Medical School/Dana Farber Cancer Research
////////////////////////////////////////////////////////////////////

    
  
   
  
var MACHLEARN_THETA0 =           9.2037; // bias
var MACHLEARN_THETA1 =-9.7613;    // ROUND/AR
var MACHLEARN_THETA2 =   -8.8776;    // Ac+An/Av


//var MACHLEARN_THETA0 =         -3.1160; // bias
//var MACHLEARN_THETA1 =-0.4310;    // ROUND/AR
//var MACHLEARN_THETA2 =  -0.3116;    // Fv/FminNucl (FminNucl = An/Fn)
//var MACHLEARN_THETA3 = 0.9341;   // Ac/Av
//var MACHLEARN_THETA4 =-1.0806;    // D/FminNucl (FminNucl = An/Fn)	

var MACHLEARN_THRESHOLD = 0.4;


var IN_DIR_FROM = "";
var IN_ID_ROIS = "nucleus.voronoi.roiset";
var IN_ID_SIGNAL_1 = "smad2";

var hyperStackID = 0;
var IDImage_SIGNAL1  = 0;
var IN_BKG_SIGNAL_1  = 0;

var LOG_DEBUG = 1;

macro "SHOW BORDER CELLS [F1]"{

// 1. Input parameters 
	input_parameters();

// 2. validate parameters 
	statistics_validate_parameters();

// 3. Get the acquisition list 
	LIST_GROUPKEYS = getFilesGroupKeys(IN_DIR_FROM);
	if(LIST_GROUPKEYS.length==0)
		exit("Please be sure that there are acquisition files into the folder: " + IN_DIR_FROM);

// 4. Find Border Cells according to the preloaded object function obtained by the logistic regression
	FindBorderCells();
	
}


function input_parameters(){

	Dialog.create("CELL SIGNALLING ANALYZER (by Remigio Picone, remigio_picone@dfci.harvard.edu)");
		
	// save paramenters in output
	LoadinfoFromFile();

	Dialog.addMessage("INPUT");
	Dialog.addString("Folder Images", IN_DIR_FROM, 70);
	Dialog.addString("File Identifier ROIS", IN_ID_ROIS, 70);
	Dialog.addMessage("SIGNAL");
	Dialog.addString("File Identifier", IN_ID_SIGNAL_1, 70);

	//Dialog.addString("Skip slides (ex. 1,2) ", IN_SKIP_SLIDES, 20);

	Dialog.show();

	IN_DIR_FROM = Dialog.getString();
	IN_ID_ROIS = Dialog.getString();
	
	IN_ID_SIGNAL_1 = Dialog.getString();

	// save paramenters in input
	SaveinfoToFile();
}


function statistics_validate_parameters(){

	if(!File.isDirectory(IN_DIR_FROM))
		exit("Please indicate an existing folder from where to load the acquisition files");
	
	oFileList = getFileList(IN_DIR_FROM);
	if(oFileList.length==0)
		exit("Please be sure the the folder indicated contains acquisition files");

}


function FindBorderCells(){

	
	
	ROI_CLEAR();
	
	CELL_COUNT = 0;
	nLen = LIST_GROUPKEYS.length;
	if(LOG_DEBUG) print("[LOG_DEBUG] num File key:" + nLen);
	
	//file_name_data = IN_DIR_TO + File.separator() + IN_STATISTICS_FILE_NAME;
	
	run("Subtract...", "value=150");

	for(j=0;j<nLen;j++)
	{
		key = LIST_GROUPKEYS[j];
		if(LOG_DEBUG) print("[LOG_DEBUG] File key:" + key);
		if(OpenFilesFromKey(IN_DIR_FROM, key)==1){
		    						
			n = roiManager("Count");

			for(i=0; i<n; i=i+2){
						
				S = is_bordercell(IDImage_SIGNAL1, i);
						
				if (S>MACHLEARN_THRESHOLD){
					roiManager("select", i);
					setColor("white");
					fill();
				}
				
				roiManager("select", i+1);
				setColor("white");
				roiManager("draw");
			}

		}
	}
	  
}


function is_bordercell(id_image, i){

	vals1 = get_bordercell_param(id_image, i);
	An = vals1[0];
	Xn = vals1[1];
	Yn = vals1[2];
	Fn = vals1[3];
	RNDn = vals1[4];
	ARn = vals1[5];

	vals2 = get_bordercell_param(id_image, i+1);
	Av = vals2[0];
	Xv = vals2[1];
	Yv = vals2[2];
	Fv = vals2[3];
	RNDv = vals2[4];
	ARv = vals2[5];

	v3 = get_cytosoldata(id_image,i);

	Ac = v3[0];
	MDc = v3[1];

	D = sqrt(pow((Xn-Xv),2)+pow((Yn-Yv),2));
	
	Acnv =((Ac+An)/Av);

	if(LOG_DEBUG) print("[LOG_DEBUG] (Ac+An)/Av :"+ Acnv);
	
	H = MACHLEARN_THETA0 + MACHLEARN_THETA2 * (RNDv/ARv) +  MACHLEARN_THETA1 * ((Ac+An)/Av) ;

	//H = MACHLEARN_THETA0 + MACHLEARN_THETA1 * ((Ac+An)/Av) + MACHLEARN_THETA2 * (RNDv/ARv) + MACHLEARN_THETA3 * (Fv/(An/Fn))+ MACHLEARN_THETA4 * (D/(An/Fn));
	
	S = 1/(1+exp(-1*H));

	return S;

}

function get_cytosoldata(id_image,roi_index){
	var out = newArray(2);
	 
	roiManager("select", roi_index); //nucleus
	
	// delete nucleus with zeros
	setColor("black");
	fill();
	roiManager("select", roi_index+1); //voronoi
	
	//setThreshold(5, MAX_INTENSITY);
	run("Median...", "radius=3");
	setAutoThreshold("Triangle dark");
	List.setMeasurements("Limit");
	out[0] = List.getValue("Area");
	out[1] = List.getValue("Median");

	return out;

}

function get_bordercell_param(id_image, roi_index){
	var out = newArray(6);
	if(id_image !=0){
		selectImage(id_image);
		roiManager("select", roi_index);
	
		List.setMeasurements();
		out[0] = List.getValue("Area");
		out[1] = List.getValue("X");
		out[2] = List.getValue("Y");
		out[3] = List.getValue("Feret");
		out[4] = List.getValue("Round");
		out[5] = List.getValue("AR");
		
	}

	return out;

}

function ROI_CLEAR(){
	// clear the ROI manager
	nLenRois = roiManager("count");
	if(nLenRois>0){
		roiManager("deselect");
		roiManager("Delete");
	}
	
}


function OpenAcquisitionROIS(dir_from, rois_file_name){
	
	roiManager("reset");
	
	file_name = dir_from + File.separator + rois_file_name;
	if(file_name!="" && !File.exists(file_name))
		return -1;
	
	roiManager("open", file_name);
	
	return 0;
}

function getExistingFileName(dir_from, key, suffix_id, extension){

	// open file SIGNAL1
	file_name =  dir_from + File.separator +  key + "_"  + suffix_id + "." + extension;
	if(LOG_DEBUG) print("[LOG_DEBUG] file_name:" + file_name);
	if(File.exists(file_name)==1){
		return file_name;
	}

	return -1;
}
function OpenFilesFromKey(dir_from, key){

	// OPEN ROIS (voronoi-nucleus)
	file_name =  getExistingFileName(dir_from, key, IN_ID_ROIS, "zip");
	//if(LOG_DEBUG) print("[LOG_DEBUG] file_name:" + file_name);
	if(file_name==-1){
		if(LOG_DEBUG) print("[LOG_DEBUG] problem opening file :" + file_name);
		return -1;
	
	}
	roiManager("Open", file_name ); 
	
	// open file SIGNAL1
	if (IN_ID_SIGNAL_1 != ""){
		file_name =  getExistingFileName(dir_from, key, IN_ID_SIGNAL_1, "tif");
		//if(LOG_DEBUG) print("[LOG_DEBUG] file_name:" + file_name);
		if(file_name==-1){
			if(LOG_DEBUG) print("[LOG_DEBUG] problem opening file :" + file_name);
			return -1; 
		}
		open(file_name);
		IDImage_SIGNAL1 = getImageID();
	}
	
	
	return 1;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////
// return an array of two items where the first one is the FRET file name and the secand one is the CFP
////////////////////////////////////////////////////////////////////////////////////////////////////////

function getRoisFileNames(dir_from, acq_name){

	oFileList = getFileList(dir_from);

	ROIS_LIST_TEMP = newArray(oFileList.length);
	
	rois_count = 0;

	for(i=0;i<oFileList.length;i++){
		acq_name_temp = getAcquistionName_FromFileName(oFileList[i]);
		isRoiFile = IsAcquistionRoisFile(oFileList[i]);
		if(acq_name == acq_name_temp  && isRoiFile){
			ROIS_LIST_TEMP[rois_count++] = oFileList[i];
		}
			
	}	

	ROIS_LIST = newArray(rois_count);
	for(i=0;i<rois_count;i++)
		ROIS_LIST[i]= ROIS_LIST_TEMP[i];


	return ROIS_LIST;
}

function IsAcquistionYFPFile(file_name){

	if(indexOf(file_name, suffix_YFP_CORR)>0)
		return true;

	return false;
}

function IsAcquistionSUMFile(file_name){

	if(indexOf(file_name, suffix_CFP_plus_FRET)>0)
		return true;

	return false;
}

function IsAcquistionRATIOFile(file_name){

	if(indexOf(file_name, suffix_RATIO)>0)
		return true;

	return false;
}


function IsAcquistionFRETFile(file_name){

	if(indexOf(file_name, suffix_FRET_CORR)>0)
		return true;

	return false;
}

function IsAcquistionCFPFile(file_name){

	if(indexOf(file_name, suffix_CFP_CORR)>0)
		return true;

	return false;
}

function IsAcquistionRoisFile(file_name){

	if(indexOf(file_name, "ROIS")>0)
		return true;

	return false;
}

// returns the prefix for the group of files 
function getFilesGroupKeys(dir_from){

	oFileList = getFileList(dir_from);	
	
	if(oFileList.length==0)
		return -1;

	ACQUISITION_COUNT = 0;
	ACQUISITION_LIST_TEMP = newArray(oFileList.length);

	//if(LOG_DEBUG) print("[LOG_DEBUG] File name found:" + oFileList[0]);
	acq_name_new="";
	acq_name_new=getAcquistionName_FromFileName(oFileList[0]);
	ACQUISITION_LIST_TEMP[ACQUISITION_COUNT++] = acq_name_new;

	for(i=0;i<oFileList.length;i++){
		if(LOG_DEBUG) print("[LOG_DEBUG] File name found:" + oFileList[i]);

		acq_name_new = getAcquistionName_FromFileName(oFileList[i]);
		if(acq_name_new=="")
			exit("Please verify that the file name indicated has the correct format:" + oFileList[i]);

		bIsNewAcqName = true;
		for(j=0;j<ACQUISITION_COUNT;j++){
			if(ACQUISITION_LIST_TEMP[j] == acq_name_new)
				bIsNewAcqName = false;
		}
		
		if(bIsNewAcqName==true){
			ACQUISITION_LIST_TEMP[ACQUISITION_COUNT++]=acq_name_new;
			if(LOG_DEBUG) print("[LOG_DEBUG] NEW ACQUISITION:" + acq_name_new);
		}
	}


	ACQUISITION_LIST = newArray(ACQUISITION_COUNT);
	for(i=0;i<ACQUISITION_COUNT;i++)
		ACQUISITION_LIST[i]= ACQUISITION_LIST_TEMP[i];

	if(LOG_DEBUG) print("[LOG_DEBUG] ACQUISITION_COUNT:" + ACQUISITION_COUNT);

	return ACQUISITION_LIST;
}

// return the file name before the last '_'
function getAcquistionName_FromFileName(file_name){

	acq_name = "";
	n = lastIndexOf(file_name, "_");
	if(n<0)
		return ""; 
	
	acq_name = substring(file_name, 0,n);
	if(LOG_DEBUG) print("[LOG_DEBUG] getAcquistionName_FromFileName:" + acq_name);

	return acq_name;

}







function get_folder_name_from_path(sFile){
	sFileName = "";
	n   =  lastIndexOf(sFile,  File.separator());
	if(n>-1) sFileName = substring(sFile, 0,  n); 
	if(LOG_DEBUG) print("[LOG_DEBUG] get_filename_with_extension_from_path:" + sFileName);
	return sFileName;
}


function get_filename_with_extension_from_path(sFile){
	sFileName = "";
	n   =  lastIndexOf(sFile,  File.separator());
	if(n>-1) sFileName = substring(sFile, n+1,  lengthOf(sFile)); 
	if(LOG_DEBUG) print("[LOG_DEBUG] get_filename_with_extension_from_path:" + sFileName);
	return sFileName;
}

function get_filename_without_extension_from_path(sFile){
	sFileName = "";
	n   =  lastIndexOf(sFile,  File.separator());
	if(n>-1) sFileName = substring(sFile, n,  lengthOf(sFile)); 
	else sFileName = sFile;

	n   = indexOf(sFileName, ".");
	if(n>-1) sFileName = substring(sFile, 0,  n); 
	if(LOG_DEBUG) print("[LOG_DEBUG] get_filename_without_extension_from_path:" + sFileName);

	return sFileName;
}



// SAVE AND LOAD INPUT VALUSE 
var m_sConstatsFileName = "urwerqqfssoosdfskdddsdsdsnfnasf.txt";

function LoadinfoFromFile(){

	//Load the values from temporary file
	sFilePath = getDirectory("temp") + File.separator() + m_sConstatsFileName;
	if(File.exists(sFilePath) != 1)
		return -1;
		
	oContent = split(File.openAsString(sFilePath),"\n") ;
	
	// CHANGE THIS WHEN YOU ADD OR DELETE A PARAMETER !!!!!!!!!!
	numb_of_parameters = 3;

	if(oContent.length<numb_of_parameters)
		return 0;	


	nIdx = 0;
	IN_DIR_FROM = oContent[nIdx++];
	IN_ID_ROIS = oContent[nIdx++];
	IN_ID_SIGNAL_1= oContent[nIdx++];
	//IN_BKG_SIGNAL_1 = oContent[nIdx++];
	//IN_ID_SIGNAL_2= oContent[nIdx++];
	//IN_BKG_SIGNAL_2 = oContent[nIdx++];
	//IN_ID_SIGNAL_3= oContent[nIdx++];
	//IN_BKG_SIGNAL_3 = oContent[nIdx++];
	//IN_ID_SIGNAL_4= oContent[nIdx++];
	//IN_BKG_SIGNAL_4 = oContent[nIdx++];
	//IN_DIR_TO = oContent[nIdx++];
	//IN_STATISTICS_FILE_NAME = oContent[nIdx++];
	//IN_EXPERIMENT_NAME = oContent[nIdx++];
	//IN_EXPERIMENT_CONDITION = oContent[nIdx++];
	//IN_SKIP_SLIDES = oContent[nIdx++];

	if(LOG_DEBUG) print("[LOG_DEBUG] input data loaded from " + sFilePath);
	
	return 0;
}


function SaveinfoToFile(){
	s="";
	s = s + IN_DIR_FROM + "\n";
	s = s + IN_ID_ROIS + "\n";
	s = s + IN_ID_SIGNAL_1 + "\n";
		
	sFilePath = getDirectory("temp") + File.separator() + m_sConstatsFileName;
	if(LOG_DEBUG) print("[LOG_DEBUG] input data saved in " + sFilePath);
			
	File.delete(sFilePath);
	f = File.open(sFilePath);
	print(f, s);
	File.close(f);

	return 0;
}

