## Data/features extraction from  tassellated images

The goal of this module is to extract from the segmented image acquisitions the data features for the statistical analysis and the classification module (see machine learning). Below is shown the the list of measured attributes. The data attributes are measured on three deifferent cellular region: nucleus, voronoi cell and voronoi cell excluded of the nuclear region. The  attribute name consits of tree sections: cell region, image channel and the measured features name.  Each channel from an acquired image will have set of 32 attributes. In the table below the attributes refers to the DNA channels. The software can measure attrbutes from four differnet channels at once.

![attributes](/IMG/ATTRIBUTE2.png)

Table 1.  




For this  software prototype I used a two channels (two colours) high-content image acquisitions of two molecule of interests: DNA and a protein which I call protein-1. the DNA channel was used for cell segmentation the voronoi diagram (see  previous section), and to measure features related to nuclear morphology and other information (see machine learning section). I choose the Protein-1 because it localizes into the nucleus when is  active (phosphorilation) and therfore is a good example of the drug screen phenotypic readout.  used in this prototype of the software to show teh importance of  including data about the cellular context, e,g, cell confinement, to accuratly  quantificatify the phenotypic effect of a drug on cells. 

## Software

The software for the measurement of the attributes from the segmented images operates in batch mode. It takes in input the folder where the images are stored and writes in output the data in a single excel file. The user needs to specifies in input also i) the file identificators (file name substrings) refering to the different channels of the images acquisitions, ii) the file indicator of the voronoi rois and optional information about the experiment (experiment ID and experimental conditions). Optionally the user can also specify the pixel intensity to for background subtraction from a single channel image.

The software  for the measurement of the attributes from the segmented images  was developped in imageJ/Fiji (2.0.0):
[data](./data).

![UI](./IMG/DATAUI.png)
