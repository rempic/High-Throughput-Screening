////////////////////////////////////////////////////////////////////
// DATA (BEGIN)
// by RemiGIO Picone
// 1/03/2017
// Harvard Medical School/Dana Farber Cancer Research
////////////////////////////////////////////////////////////////////


var LOG_DEBUG = 0;
var DEBUG_SHOW_BORDER = 1;
var DEBUG_SHOW_MITOSIS = 1;

// BORDER CELLS: This are the parameters to identify the border cells
var ADD_ISBORDERCELL = 0;
					// FEATURES (see matlab code)
var MACHLEARN_THETA0 = -4.2890; 	// bias
var MACHLEARN_THETA1 = -0.1427; 	// Ac/Av
var MACHLEARN_THETA2 = -0.0666; 	// ROUND/AR 
var MACHLEARN_THETA3 =  0.8984; 	// Fv/FminNucl	(FminNucl = An/Fn)	
var MACHLEARN_THETA4 = -0.6949; 	// D/FminNucl (FminNucl = An/Fn)	
var MACHLEARN_THRESHOLD = 0.5;

// MITOTIC CELLS: This are the parameters to identify Mitotic cells			
var ADD_ISMITOTICCELL = 0;
					// FEATURES (see matlab code)
var MACHLEARN2_THETA0 = -4.9591; 	//biasvar MACHLEARN2_THETA1 = -0.0925; 	// areavar MACHLEARN2_THETA2 =  0.0015; 	// MNvar MACHLEARN2_THETA3 =  0.0171;  	// SDvar MACHLEARN2_THETA4 =  -0.7507; 	// FERETvar MACHLEARN2_THETA5 = -0.3788; 	// ROUND var MACHLEARN2_THETA6 =0.8411;		// ARvar MACHLEARN2_THETA7 = 0.4273;  	// PERIM
var MACHLEARN2_THRESHOLD = 0.5;
 

					/
var MACHLEARN2_THETA0 = -4.9591; 	//biasvar MACHLEARN2_THETA1 = -0.0925; 	// areavar MACHLEARN2_THETA2 =  0.0015; 	// MNvar MACHLEARN2_THETA3 =  0.0171;  	// SDvar MACHLEARN2_THETA4 =  -0.7507; 	// FERETvar MACHLEARN2_THETA5 = -0.3788; 	// ROUND var MACHLEARN2_THETA6 =0.8411;		// ARvar MACHLEARN2_THETA7 = 0.4359;  	// PERIM
var MACHLEARN2_THRESHOLD = 0.5;	


var IN_DIR_FROM = "";
var IN_DIR_TO = "";
var IN_EXPERIMENT_NAME = "";
var IN_EXPERIMENT_CONDITION1 = "";
var IN_EXPERIMENT_CONDITION2 = "";
var IN_EXPERIMENT_CONDITION3 = "";
var IN_EXPERIMENT_CONDITION4 = "";

var IN_STATISTICS_FILE_NAME = "statistics.xls";
var IN_SKIP_SLIDES = "";

var IN_ID_ROIS = "nucleus.voronoi.roiset";
var IN_ID_SIGNAL_1 = "nucleus";
var IN_ID_SIGNAL_2 = "";
var IN_ID_SIGNAL_3 = "";
var IN_ID_SIGNAL_4 = "";

var IN_ID_SIGNAL_BORDER = "";
var IN_ID_SIGNAL_MITOSIS = "";

var hyperStackID = 0;
var IDImage_SIGNAL1  = 0;
var IDImage_SIGNAL2 = 0;
var IDImage_SIGNAL3  = 0;
var IDImage_SIGNAL4  = 0;
var IDImage_SIGNAL_BORDER = 0;
var IDImage_SIGNAL_MITOSIS = 0;

var IN_BKG_SIGNAL_1  = 0;
var IN_BKG_SIGNAL_2 = 0;
var IN_BKG_SIGNAL_3  = 0;
var IN_BKG_SIGNAL_4  = 0;

var CURRENT_PREFIX_NAME = "";


macro "5 DATA [F4]"{

// 1. Input parameters 
	input_parameters();

// 2. validate parameters 
	statistics_validate_parameters();

// 3. Get the acquisition list (eg., DOX_A1 is the acquisition for the files DOX_A1_FRET, DOX_A1_CFP, etc. ) 
	LIST_GROUPKEYS = getFilesGroupKeys(IN_DIR_FROM);
	if(LIST_GROUPKEYS.length==0)
		exit("Please be sure that there are acquisition files into the folder: " + IN_DIR_FROM);

// 4. MEasure the values assocaited with the nucleus and the voronoi area rois
	
	MeasureAndSave();
	
	
}


function input_parameters(){

	Dialog.create("CELL SIGNALLING ANALYZER (by Remigio Picone, remigio_picone@dfci.harvard.edu)");
		
	// save paramenters in output
	LoadinfoFromFile();

	Dialog.addMessage("INPUT");
	Dialog.addString("Folder Images", IN_DIR_FROM, 70);
	Dialog.addString("File Identifier ROIS", IN_ID_ROIS, 70);

	Dialog.addMessage("CHANNELS");
	Dialog.addString("SIGNAL 1 - File Identifier", IN_ID_SIGNAL_1, 70);
	Dialog.addNumber("Background Int.", IN_BKG_SIGNAL_1);
	Dialog.addString("SIGNAL 2 - File Identifier", IN_ID_SIGNAL_2, 70);
	Dialog.addNumber("Background Int.", IN_BKG_SIGNAL_2);
	Dialog.addString("SIGNAL 3 - File Identifier", IN_ID_SIGNAL_3, 70);
	Dialog.addNumber("Background Int.", IN_BKG_SIGNAL_3);
	Dialog.addString("SIGNAL 4 - File Identifier", IN_ID_SIGNAL_4, 70);
	Dialog.addNumber("Background Int.", IN_BKG_SIGNAL_4);

	Dialog.addMessage("MACHINE LEARNING CLASSIFIER");
	Dialog.addString("BORDER CELL File Identifier", IN_ID_SIGNAL_BORDER, 70);
	Dialog.addString("MITOTIC CELL File Identifier", IN_ID_SIGNAL_MITOSIS, 70);
	Dialog.addMessage("OUTPUT");
	Dialog.addString("Folder Data Output",  IN_DIR_TO, 70);
	Dialog.addString("Data Output file name", IN_STATISTICS_FILE_NAME, 20);

	Dialog.addMessage("INFO");
	Dialog.addString("Experiment name", IN_EXPERIMENT_NAME, 20);
	Dialog.addString("Experiment condition1", IN_EXPERIMENT_CONDITION1, 20);
	Dialog.addString("Experiment condition2", IN_EXPERIMENT_CONDITION2, 20);
	Dialog.addString("Experiment condition3", IN_EXPERIMENT_CONDITION3, 20);
	Dialog.addString("Experiment condition4", IN_EXPERIMENT_CONDITION4, 20);

	//Dialog.addString("Skip slides (ex. 1,2) ", IN_SKIP_SLIDES, 20);

	Dialog.show();

	IN_DIR_FROM = Dialog.getString();
	IN_ID_ROIS = Dialog.getString();
	
	IN_ID_SIGNAL_1 = Dialog.getString();
	IN_BKG_SIGNAL_1 = Dialog.getNumber();
	
	IN_ID_SIGNAL_2 = Dialog.getString();
	IN_BKG_SIGNAL_2 = Dialog.getNumber();
	
	IN_ID_SIGNAL_3 = Dialog.getString();
	IN_BKG_SIGNAL_3 = Dialog.getNumber();
	
	IN_ID_SIGNAL_4 = Dialog.getString();
	IN_BKG_SIGNAL_4 = Dialog.getNumber();
	
	IN_ID_SIGNAL_BORDER = Dialog.getString();
	IN_ID_SIGNAL_MITOSIS = Dialog.getString();

	IN_DIR_TO = Dialog.getString();
	IN_STATISTICS_FILE_NAME = Dialog.getString();
	
	IN_EXPERIMENT_NAME = Dialog.getString();
	IN_EXPERIMENT_CONDITION1 = Dialog.getString();
	IN_EXPERIMENT_CONDITION2 = Dialog.getString();
	IN_EXPERIMENT_CONDITION3 = Dialog.getString();
	IN_EXPERIMENT_CONDITION4 = Dialog.getString();
	
	
	//IN_SKIP_SLIDES = Dialog.getString();
	// save paramenters in input
	SaveinfoToFile();
}


function statistics_validate_parameters(){

	if(!File.isDirectory(IN_DIR_FROM))
		exit("Please indicate an existing folder from where to load the acquisition files");
	
	if(!File.isDirectory(IN_DIR_TO))
		exit("Please indicate an existing folder in which to save statistics file");
	
	//if (IN_ID_SIGNAL_BORDER=="")
	//	ADD_ISBORDERCELL =0;

	if(IN_STATISTICS_FILE_NAME == "")
		exit("Please insert a statistic file name");
	
	if(indexOf(IN_STATISTICS_FILE_NAME, "_")>0)
		exit("statistic file name cannot contain the character '-' (underscore) ");
	
	oFileList = getFileList(IN_DIR_FROM);
	if(oFileList.length==0)
		exit("Please be sure the the folder indicated contains acquisition files");

}


function MeasureAndSave(){

	// open the result table file
	RESULT_TABLE_open();
	
	ROI_CLEAR();
	
	CELL_COUNT = 0;
	nLen = LIST_GROUPKEYS.length;
	if(LOG_DEBUG) print("[LOG_DEBUG] num File key:" + nLen);
	
	file_name_data = IN_DIR_TO + File.separator() + IN_STATISTICS_FILE_NAME;
	
	if(DEBUG_SHOW_BORDER==0)
		setBatchMode(true);

	for(j=0;j<nLen;j++)
	{
		    showProgress(j/nLen);
		    key = LIST_GROUPKEYS[j];
		    if(LOG_DEBUG) print("[LOG_DEBUG] File key:" + key);
		    if(OpenFilesFromKey(IN_DIR_FROM, key)==1){
		    	
				var sInfo = RESULT_TABLE_row_info(key);
				
				n = roiManager("Count");
				var s = newArray(n/2);

				var p_bordercell = newArray(n/2);
				var p_mitoticcell = newArray(n/2);

				if(IDImage_SIGNAL1 !=0){
					selectImage(IDImage_SIGNAL1);
					run("Subtract...", "value=IN_BKG_SIGNAL_1");
					for(i=0; i<n; i = i+2){
						DATA_NUCL = get_data(i, false);
						DATA_VORO = get_data(i+1, false);
						DATA_VORONONUCL = get_data_nonuclei(IDImage_SIGNAL1,i);
						if(IDImage_SIGNAL1 == IDImage_SIGNAL_BORDER){
							p_bordercell[i/2]=prob_bordercell(DATA_NUCL, DATA_VORO, DATA_VORONONUCL);
							if (DEBUG_SHOW_BORDER){
								show_bordercell(i,p_bordercell[i/2]);
							}
						}
						if(IDImage_SIGNAL1 == IDImage_SIGNAL_MITOSIS){
							p_mitoticcell[i/2]=prob_mitoticcell(DATA_NUCL, DATA_VORO, DATA_VORONONUCL);
							if (DEBUG_SHOW_MITOSIS){
								show_mitoticcell(i,p_mitoticcell[i/2]);
							}
						}

						s[i/2] = "" + as_string(DATA_NUCL, DATA_VORO, DATA_VORONONUCL);
					}
				}
				
				if(IDImage_SIGNAL2 !=0){
					selectImage(IDImage_SIGNAL2);
					run("Subtract...", "value=IN_BKG_SIGNAL_2");
					for(i=0; i<n; i = i+2){
						DATA_NUCL = get_data(i, false);
						DATA_VORO = get_data(i+1, false);
						DATA_VORONONUCL = get_data_nonuclei(IDImage_SIGNAL2, i);
						if(IDImage_SIGNAL2 == IDImage_SIGNAL_BORDER){
							p_bordercell[i/2]=prob_bordercell(DATA_NUCL, DATA_VORO, DATA_VORONONUCL);
							if (DEBUG_SHOW_BORDER){
								show_bordercell(i,p_bordercell[i/2]);
								//show_bordercell2(i,DATA_NUCL, DATA_VORO, DATA_VORONONUCL);
							}
						}
						if(IDImage_SIGNAL2 == IDImage_SIGNAL_MITOSIS){
							p_mitoticcell[i/2]=prob_mitoticcell(DATA_NUCL, DATA_VORO, DATA_VORONONUCL);
							if (DEBUG_SHOW_MITOSIS){
								show_mitoticcell(i,p_mitoticcell[i/2]);
							}
						}
						
						s[i/2] = s[i/2] + "\t" + as_string(DATA_NUCL, DATA_VORO, DATA_VORONONUCL);
					}
				}

				if(IDImage_SIGNAL3 !=0){
					selectImage(IDImage_SIGNAL3);
					run("Subtract...", "value=IN_BKG_SIGNAL_3");
					for(i=0; i<n; i = i+2){
						DATA_NUCL = get_data(i, false);
						DATA_VORO = get_data(i+1, false);
						DATA_VORONONUCL = get_data_nonuclei(IDImage_SIGNAL3, i);
						if(IDImage_SIGNAL3 == IDImage_SIGNAL_BORDER){
							p_bordercell[i/2]=prob_bordercell(DATA_NUCL, DATA_VORO, DATA_VORONONUCL);
							if (DEBUG_SHOW_BORDER){
								show_bordercell(i,p_bordercell[i/2]);
							}
						}
						if(IDImage_SIGNAL3 == IDImage_SIGNAL_MITOSIS){
							p_mitoticcell[i/2]=prob_mitoticcell(DATA_NUCL, DATA_VORO, DATA_VORONONUCL);
							if (DEBUG_SHOW_MITOSIS){
								show_mitoticcell(i,p_mitoticcell[i/2]);
							}
						}
						s[i/2] = s[i/2] + "\t" + as_string(DATA_NUCL, DATA_VORO, DATA_VORONONUCL);
					}
				}
				
				if(IDImage_SIGNAL4 !=0){
					selectImage(IDImage_SIGNAL4);
					run("Subtract...", "value=IN_BKG_SIGNAL_4");
					for(i=0; i<n; i = i+2){
						DATA_NUCL = get_data(i, false);
						DATA_VORO = get_data(i+1, false);
						DATA_VORONONUCL = get_data_nonuclei(IDImage_SIGNAL4, i);
						if(IDImage_SIGNAL4 == IDImage_SIGNAL_BORDER){
							p_bordercell[i/2]=prob_bordercell(DATA_NUCL, DATA_VORO, DATA_VORONONUCL);
							if (DEBUG_SHOW_BORDER){
								show_bordercell(i,p_bordercell[i/2]);
							}
						}
						if(IDImage_SIGNAL4 == IDImage_SIGNAL_MITOSIS){
							p_mitoticcell[i/2]=prob_mitoticcell(DATA_NUCL, DATA_VORO, DATA_VORONONUCL);
							if (DEBUG_SHOW_MITOSIS){
								show_mitoticcell(i,p_mitoticcell[i/2]);
							}
						}

						
						s[i/2] = s[i/2] + "\t" + as_string(DATA_NUCL, DATA_VORO, DATA_VORONONUCL);
					}
				}	
		    		
				
				//SAVE THE RAWS OF THE CURRENT IMAGE INTO THE TABLE
				for(i=0; i<n/2; i++)
					RESULT_TABLE_add_row(file_name_data, sInfo+ "\t" + p_bordercell[i] + "\t" + p_mitoticcell[i] + "\t" +s[i]);
				

				// DEBUG (used to temporarly cancell the close all and see the calculated borders and the border cells)
				if (DEBUG_SHOW_BORDER ==0)
					close_all();

				
			}
			
	}
	if(DEBUG_SHOW_BORDER==0)
		setBatchMode(false);
	exit("The data processing was completed!");
	RESULT_TABLE_close();
}



function show_bordercell(roi_index_nucl, prob){

	if(prob> MACHLEARN_THRESHOLD){
		roiManager("select", roi_index_nucl);
	
		// delete nucleus with zeros
		setColor("white");
		fill();
	}

}



function show_mitoticcell(roi_index_nucl, prob){

	if(prob> MACHLEARN2_THRESHOLD){
		roiManager("select", roi_index_nucl+1);
	
		// delete nucleus with zeros
		setColor("white");
		run("Draw", "slice");
	}

}

// the parameters for the obejetive function were calculate by using a logistic regression machine learning (see matlab code)
function prob_bordercell(N,V,C){

	Xn 	= N[IDX_X];
	Yn 	= N[IDX_Y];
	Xv 	= V[IDX_X];
	Yv 	= V[IDX_Y];
	Ac 	= C[IDX_AREA];
	Av 	= V[IDX_AREA];
	RNDv 	= V[IDX_ROUND];
	ARv 	= V[IDX_AR];
	Fv 	= V[IDX_FERET];
	An 	= N[IDX_AREA];
	Fn 	= N[IDX_FERET];

	D = sqrt(pow((Xn-Xv),2)+pow((Yn-Yv),2));
	
	H = MACHLEARN_THETA0 + MACHLEARN_THETA1 * ((Ac+An)/Av) + MACHLEARN_THETA2 * (RNDv/ARv) + MACHLEARN_THETA3 * (Fv/(An/Fn))+ MACHLEARN_THETA4 * (D/(An/Fn));
	
	S = 1/(1+exp(-1*H));

	return S;
}

// the parameters for the obejetive function were calculate by using a logistic regression machine learning (see matlab code)
function prob_mitoticcell(N,V,C){

	PERn 	= N[IDX_PERIM];
	ARn 	= N[IDX_AR];
	RNDn 	= N[IDX_ROUND];
	SDn 	= N[IDX_STDEV];
	MNn 	= N[IDX_MEAN];
	Fn 	= N[IDX_FERET];
	An 	= N[IDX_AREA];
	
	H = MACHLEARN2_THETA0 + MACHLEARN2_THETA1 * An + MACHLEARN2_THETA2 * MNn + MACHLEARN2_THETA3 * SDn + MACHLEARN2_THETA4 * Fn + MACHLEARN2_THETA5 * RNDn + MACHLEARN2_THETA6 * ARn + MACHLEARN2_THETA7 * PERn ;
	
	S = 1/(1+exp(-1*H));

	return S;
}


// this function removes the nuclear area and take the median and IntDen for the voronoi area with no nucleus (cytosol)
function get_data_nonuclei(id_image, roi_index){

	 //select roi nucleus
	roiManager("select", roi_index); 
	
	// delete nucleus adding zeros
	setColor("black");
	fill();
	
	// select the vornoi area roi
	roiManager("select", roi_index+1); 
	
	// segmentation cyrosolic area contained in the voronoi area (exluded of the nucleus)
	run("Median...", "radius=3");
	setAutoThreshold("Triangle dark");

	// Measure the area and other values
	data = get_data(-1,true);

	// TEST CODE TO VISUALIZE THE SEGMENTED CYTOSOLIC AREA
	if (DEBUG_SHOW_BORDER ==1 && id_image==IDImage_SIGNAL_BORDER){
		run("Analyze Particles...", "size=500-Infinity add"); // adds the new foudn region to the roimanager
		roiManager("select", roiManager("Count")-1);
		setColor("white");
		roiManager("draw")
	}

	return data;
}


function ROI_CLEAR(){
	// clear the ROI manager
	n = roiManager("count");
	if(n>0){
		roiManager("deselect");
		roiManager("Delete");
	}
	
}

// the order of these index has to be the same of the column
var IDX_AREA	=0;
var IDX_MEAN	=1;
var IDX_MEDIAN	=2;
var IDX_STDEV	=3;
var IDX_FERET	=4;
var IDX_INTDEN	=5;
var IDX_ROUND	=6;
var IDX_AR	=7;
var IDX_X	=8;
var IDX_Y	=9;
var IDX_PERIM   =10;

var IDX_COUNT=11;	

function get_data(roi_index, isThresholdLimited){
	var out = newArray(IDX_COUNT);
	
	if(roi_index>-1)
		roiManager("select", roi_index);

	if(isThresholdLimited)
		List.setMeasurements("Limit");
	else
		List.setMeasurements();	

	out[IDX_AREA] 	= List.getValue("Area");
	out[IDX_MEAN] 	= List.getValue("Mean");
	out[IDX_MEDIAN] = List.getValue("Median");
	out[IDX_STDEV] 	= List.getValue("StdDev");
	out[IDX_FERET] 	= List.getValue("Feret");
	out[IDX_INTDEN] = List.getValue("IntDen");
	out[IDX_ROUND] 	= List.getValue("Round");
	out[IDX_AR] 	= List.getValue("AR");
	out[IDX_X] 	= List.getValue("X");
	out[IDX_Y] 	= List.getValue("Y");
	out[IDX_PERIM] 	= List.getValue("Perim.");		

	return out;
}



function as_string(N, V, VNN){
	
	s1="";
	s2="";
	s3="";

	for(i=0;i<IDX_COUNT;i++){
		s1 = s1 +  N[i] 	+ "\t";
 		s2 = s2 +  V[i] 	+ "\t" ;
		s3 = s3 +  VNN[i]	+ "\t";
	}
	//remove the last tab char
	s3= substring(s3, 0, lengthOf(s3)-3);
	return "" + s1+s2+s3;
}

// Colums General
var COL_FOLDER_FROM 		= "FOLDER_FROM";
var	COL_EXP_NAME 			= "EXP_ID";
var	COL_EXP_COND1 			= "EXP_COND1";
var	COL_EXP_COND2 			= "EXP_COND2";
var	COL_EXP_COND3 			= "EXP_COND3";
var	COL_EXP_COND4 			= "EXP_COND4";
var	COL_FILES_KEY 			= "FILES_KEY";
var 	COL_IS_BORDER_CELL		= "IS_BORDERCELL";
var 	COL_IS_MITOTIC_CELL		= "IS_MITOTICCELL";

// Columns Data
var 	COL_AREA 	= "A";
var	COL_INT_MEAN 	= "I_MN";
var	COL_INT_STDEV 	= "I_SD";
var	COL_INT_MEDIAN 	= "I_MD";
var	COL_FERET	= "F";
var	COL_INT_DEN 	= "I_DEN";
var 	COL_ROUND  	= "RND";
var 	COL_AR  	= "AR";
var	COL_CENTRE_X 	= "X";
var	COL_CENTRE_Y 	= "Y";
var	COL_PERIM 	= "PERIM";



function RESULT_TABLE_open(){
	file_name = IN_DIR_TO + File.separator() + IN_STATISTICS_FILE_NAME;
	if(!File.exists(file_name)){

		var PART_ID_NUCL 	= "NU_ROI";
		var PART_ID_VORO 	= "VO_ROI";
		var PART_ID_VORONONUCL 	= "CY_ROI";

		var H = "";

		if(IN_ID_SIGNAL_1!=0){
			H  =            RESULT_TABLE_header_info();
			H  = H + "\t" + RESULT_TABLE_header_data(PART_ID_NUCL, IN_ID_SIGNAL_1);
			H  = H + "\t" + RESULT_TABLE_header_data(PART_ID_VORO, IN_ID_SIGNAL_1);
			H  = H + "\t" + RESULT_TABLE_header_data(PART_ID_VORONONUCL, IN_ID_SIGNAL_1);
		}
		if(IN_ID_SIGNAL_2!=0){
			H  = H + "\t" + RESULT_TABLE_header_data(PART_ID_NUCL, IN_ID_SIGNAL_2);
			H  = H + "\t" + RESULT_TABLE_header_data(PART_ID_VORO, IN_ID_SIGNAL_2);
			H  = H + "\t" + RESULT_TABLE_header_data(PART_ID_VORONONUCL, IN_ID_SIGNAL_2);
		}
		if(IN_ID_SIGNAL_3!=0){
			H  = H + "\t" + RESULT_TABLE_header_data(PART_ID_NUCL, IN_ID_SIGNAL_3);
			H  = H + "\t" + RESULT_TABLE_header_data(PART_ID_VORO, IN_ID_SIGNAL_3);
			H  = H + "\t" + RESULT_TABLE_header_data(PART_ID_VORONONUCL, IN_ID_SIGNAL_3);
		}
		if(IN_ID_SIGNAL_4!=0){
			H  = H + "\t" + RESULT_TABLE_header_data(PART_ID_NUCL, IN_ID_SIGNAL_4);
			H  = H + "\t" + RESULT_TABLE_header_data(PART_ID_VORO, IN_ID_SIGNAL_4);
			H  = H + "\t" + RESULT_TABLE_header_data(PART_ID_VORONONUCL, IN_ID_SIGNAL_4);		
		}

		if(LOG_DEBUG) print("[LOG_DEBUG] TABLE HEADER:" + H);
		RESULT_TABLE_file = File.open(file_name);
		
		File.append(H, file_name);
	}
}	


function RESULT_TABLE_header_info(){
	HEADER = "";
	HEADER = HEADER + COL_FOLDER_FROM 	+ "\t";
	HEADER = HEADER + COL_EXP_NAME 		+ "\t";
 	HEADER = HEADER + COL_EXP_COND1 	+ "\t";
	HEADER = HEADER + COL_EXP_COND2 	+ "\t";
	HEADER = HEADER + COL_EXP_COND3 	+ "\t";
	HEADER = HEADER + COL_EXP_COND4 	+ "\t";
	HEADER = HEADER + COL_FILES_KEY		+ "\t";
	HEADER = HEADER + COL_IS_BORDER_CELL	+ "\t";
	HEADER = HEADER + COL_IS_MITOTIC_CELL;


	return HEADER;
}

// part_id is "NUCLEUS" of "VORONOI" (rois)
// signal_id refers to the image, which can be "nuclus", "smad", "microtubules" or "actin" etc.
function RESULT_TABLE_header_data(part_id, signal_id){
	HEADER = "";
	if(signal_id == "")
		signal_id = "NaN";
		
	HEADER = HEADER +  part_id + "." + signal_id + "." + COL_AREA 					+ "\t";
	HEADER = HEADER +  part_id + "." + signal_id + "." + COL_INT_MEAN 				+ "\t";
 	HEADER = HEADER +  part_id + "." + signal_id + "." + COL_INT_STDEV 				+ "\t";
	HEADER = HEADER +  part_id + "." + signal_id + "." + COL_INT_MEDIAN 			+ "\t";
	HEADER = HEADER +  part_id + "." + signal_id + "." + COL_FERET			+ "\t";
	HEADER = HEADER +  part_id + "." + signal_id + "." + COL_INT_DEN 				+ "\t";
	HEADER = HEADER +  part_id + "." + signal_id + "." + COL_ROUND			+ "\t";
	HEADER = HEADER +  part_id + "." + signal_id + "." + COL_AR			+ "\t";
	HEADER = HEADER +  part_id + "." + signal_id + "." + COL_CENTRE_X 				+ "\t";
	HEADER = HEADER +  part_id + "." + signal_id + "." + COL_CENTRE_Y		+ "\t";
	HEADER = HEADER +  part_id + "." + signal_id + "." + COL_PERIM;
	return HEADER;
}



function RESULT_TABLE_row_info(key){
	ROW = "";
	ROW = ROW + IN_DIR_FROM 				+ "\t";
	ROW = ROW + IN_EXPERIMENT_NAME 			+ "\t";
	ROW = ROW + IN_EXPERIMENT_CONDITION1 	+ "\t";
	ROW = ROW + IN_EXPERIMENT_CONDITION2 	+ "\t";
	ROW = ROW + IN_EXPERIMENT_CONDITION3 	+ "\t";
	ROW = ROW + IN_EXPERIMENT_CONDITION4 	+ "\t";
	ROW = ROW + key ;
	return ROW;
}


function RESULT_TABLE_add_row(file_name, sROW){
	
	File.append(sROW, file_name);
	return 1;

}



function RESULT_TABLE_close(){
	file_name = IN_DIR_TO + File.separator() + IN_STATISTICS_FILE_NAME;
	if(!File.exists(file_name))
		close(RESULT_TABLE_file); 
	
}




function close_all(){
	
	selectImage(IDImage_SIGNAL1);
	close();

	if(IDImage_SIGNAL2!=0){
		selectImage(IDImage_SIGNAL2);
		close();
	}
	if(IDImage_SIGNAL3!=0){
		selectImage(IDImage_SIGNAL3);
		close();
	}

	if(IDImage_SIGNAL4!=0){
		selectImage(IDImage_SIGNAL4);
		close();
	}

	ROI_CLEAR();
}

function save_all(acq_name){

	// save the ratio image
	selectImage(IDImage_RATIO);
	
	file_name = IN_DIR_TO + File.separator + acq_name + suffix_RATIO;
	if(File.exists(file_name))
		exit("It was not possible to save the file indicated because it does already exist. File name: " + acq_name + suffix_RATIO);

	save(IN_DIR_TO + File.separator + acq_name + suffix_RATIO);

	
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
	ROI_CLEAR();
	roiManager("Open", file_name ); 
	
	var file_name1 = "";
	var file_name2 = "";
	var file_name3 = "";
	var file_name4 = "";

	// open file SIGNAL1
	if (IN_ID_SIGNAL_1 != ""){
		file_name1 =  getExistingFileName(dir_from, key, IN_ID_SIGNAL_1, "tif");
		//if(LOG_DEBUG) print("[LOG_DEBUG] file_name:" + file_name1);
		if(file_name==-1){
			if(LOG_DEBUG) print("[LOG_DEBUG] problem opening file :" + file_name1);
			return -1; 
		}
		open(file_name1);
		IDImage_SIGNAL1 = getImageID();
	}
	
	// open file SIGNAL2
	if (IN_ID_SIGNAL_2 != ""){
		file_name2 =  getExistingFileName(dir_from, key, IN_ID_SIGNAL_2, "tif");
		//if(LOG_DEBUG) print("[LOG_DEBUG] file_name:" + file_name2);
		if(file_name==-1){
			if(LOG_DEBUG) print("[LOG_DEBUG] problem opening file :" + file_name2);
			return -1; 
		}
		open(file_name2);
		IDImage_SIGNAL2 = getImageID();
	}
	// open file SIGNAL3
	if (IN_ID_SIGNAL_3 != ""){
		file_name3 =  getExistingFileName(dir_from, key, IN_ID_SIGNAL_3, "tif");
		//if(LOG_DEBUG) print("[LOG_DEBUG] file_name:" + file_name3);
		if(file_name==-1){
			if(LOG_DEBUG) print("[LOG_DEBUG] problem opening file :" + file_name3);
			return -1; 
		}
		open(file_name3);
		IDImage_SIGNAL3 = getImageID();
	}

	// open file SIGNAL4
	if (IN_ID_SIGNAL_4 != ""){
		file_name4 =  getExistingFileName(dir_from, key, IN_ID_SIGNAL_4, "tif");
		//if(LOG_DEBUG) print("[LOG_DEBUG] file_name:" + file_name4);
		if(file_name==-1){
			if(LOG_DEBUG) print("[LOG_DEBUG] problem opening file :" + file_name4);
			return -1; 
		}
		open(file_name4);
		IDImage_SIGNAL4 = getImageID();
	}

	// open file SIGNAL BORDER
	if (IN_ID_SIGNAL_BORDER != ""){
		file_name =  getExistingFileName(dir_from, key, IN_ID_SIGNAL_BORDER, "tif");
		//if(LOG_DEBUG) print("[LOG_DEBUG] file_name:" + file_name);
		if(file_name==-1){
			if(LOG_DEBUG) print("[LOG_DEBUG] problem opening file :" + file_name);
			return -1; 
		}
		if(file_name==file_name1) 
			IDImage_SIGNAL_BORDER = IDImage_SIGNAL1;
		else
		if(file_name== file_name2) 
			IDImage_SIGNAL_BORDER = IDImage_SIGNAL2;	
		else
		if(file_name== file_name3) 
			IDImage_SIGNAL_BORDER = IDImage_SIGNAL3;
		else
		if(file_name== file_name4) 
			IDImage_SIGNAL_BORDER = IDImage_SIGNAL4;
		else{
			open(file_name);
			IDImage_SIGNAL_BORDER = getImageID();
		}

		ADD_ISBORDERCELL = 1;
	}
	else
		ADD_ISBORDERCELL = 0;

	// open file SIGNAL MITOSIS
	if (IN_ID_SIGNAL_MITOSIS != ""){
		file_name =  getExistingFileName(dir_from, key, IN_ID_SIGNAL_MITOSIS, "tif");
		//if(LOG_DEBUG) print("[LOG_DEBUG] file_name:" + file_name);
		if(file_name==-1){
			if(LOG_DEBUG) print("[LOG_DEBUG] problem opening file :" + file_name);
			return -1; 
		}
		if(file_name==file_name1) 
			IDImage_SIGNAL_MITOSIS = IDImage_SIGNAL1;
		else
		if(file_name== file_name2) 
			IDImage_SIGNAL_MITOSIS = IDImage_SIGNAL2;	
		else
		if(file_name== file_name3) 
			IDImage_SIGNAL_MITOSIS = IDImage_SIGNAL3;
		else
		if(file_name== file_name4) 
			IDImage_SIGNAL_MITOSIS = IDImage_SIGNAL4;
		else{
			open(file_name);
			IDImage_SIGNAL_MITOSIS = getImageID();
		}

		ADD_ISMITOTICCELL = 1;
	}
	else
		ADD_ISMITOTICCELL = 0;

	
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
var m_sConstatsFileName = "urwerqqfssookdddsdsdsnfnasf.txt";

function LoadinfoFromFile(){

	//Load the values from temporary file
	sFilePath = getDirectory("temp") + File.separator() + m_sConstatsFileName;
	if(File.exists(sFilePath) != 1)
		return -1;
		
	oContent = split(File.openAsString(sFilePath),"\n") ;
	
	// CHANGE THIS WHEN YOU ADD OR DELETE A PARAMETER !!!!!!!!!!
	numb_of_parameters = 19;

	if(oContent.length<numb_of_parameters)
		return 0;	


	nIdx = 0;
	IN_DIR_FROM = oContent[nIdx++];
	IN_ID_ROIS = oContent[nIdx++];
	IN_ID_SIGNAL_1= oContent[nIdx++];
	IN_BKG_SIGNAL_1 = oContent[nIdx++];
	IN_ID_SIGNAL_2= oContent[nIdx++];
	IN_BKG_SIGNAL_2 = oContent[nIdx++];
	IN_ID_SIGNAL_3= oContent[nIdx++];
	IN_BKG_SIGNAL_3 = oContent[nIdx++];
	IN_ID_SIGNAL_4= oContent[nIdx++];
	IN_BKG_SIGNAL_4 = oContent[nIdx++];
	IN_ID_SIGNAL_BORDER = oContent[nIdx++];
	IN_ID_SIGNAL_MITOSIS = oContent[nIdx++];
	IN_DIR_TO = oContent[nIdx++];
	IN_STATISTICS_FILE_NAME = oContent[nIdx++];
	IN_EXPERIMENT_NAME = oContent[nIdx++];
	IN_EXPERIMENT_CONDITION1 = oContent[nIdx++];
	IN_EXPERIMENT_CONDITION2 = oContent[nIdx++];
	IN_EXPERIMENT_CONDITION3 = oContent[nIdx++];
	IN_EXPERIMENT_CONDITION4 = oContent[nIdx++];
	//IN_SKIP_SLIDES = oContent[nIdx++];

	if(LOG_DEBUG) print("[LOG_DEBUG] input data loaded from " + sFilePath);
	
	return 0;
}


function SaveinfoToFile(){
	s="";
	s = s + IN_DIR_FROM + "\n";
	s = s + IN_ID_ROIS + "\n";
	s = s + IN_ID_SIGNAL_1 + "\n";
	s = s + IN_BKG_SIGNAL_1 + "\n";
	s = s + IN_ID_SIGNAL_2 + "\n";
	s = s + IN_BKG_SIGNAL_2 + "\n";
	s = s + IN_ID_SIGNAL_3 + "\n";
	s = s + IN_BKG_SIGNAL_3 + "\n";
	s = s + IN_ID_SIGNAL_4 + "\n";
	s = s + IN_BKG_SIGNAL_4 + "\n";
	s = s + IN_ID_SIGNAL_BORDER + "\n";
	s = s + IN_ID_SIGNAL_MITOSIS + "\n";
	s = s + IN_DIR_TO + "\n";
	s = s + IN_STATISTICS_FILE_NAME + "\n";
	s = s + IN_EXPERIMENT_NAME + "\n";
	s = s + IN_EXPERIMENT_CONDITION1 + "\n";
	s = s + IN_EXPERIMENT_CONDITION2 + "\n";
	s = s + IN_EXPERIMENT_CONDITION3 + "\n";
	s = s + IN_EXPERIMENT_CONDITION4 + "\n";

	
	sFilePath = getDirectory("temp") + File.separator() + m_sConstatsFileName;
	if(LOG_DEBUG) print("[LOG_DEBUG] input data saved in " + sFilePath);
			
	File.delete(sFilePath);
	f = File.open(sFilePath);
	print(f, s);
	File.close(f);

	return 0;
}

