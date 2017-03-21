# An Integrated Image data Analysis and Machine Learning approach for high-throughput drug and genetic phenotypic screening

## Goal
The goal of this project is to develop an initial Integrated image data analysis and machine learning  software prototype for high-throughput drug and genetic phenotypic screen. high-throughput phenotypic screening also called  high-content analysis (HCA) or cellomics, is a used in biological research and drug discovery to identify substances such as small molecules, peptides, or RNAi that alter the phenotype of a cell in a desired manner. The most common analysis involves first the labeling proteins with fluorescent tags, then  the acquisition of spatial and temporal  information by an automated microscope, and finally the measurement and analysis of the changes in cell phenotype   using an automated image analysis software. Through the use of fluorescent tags, it is possible to measure in parallel a wide range of cell components and  changes at a subcellular level 

for this project I focuse on quantifying and classifying the spatial heterogeneous effect of drugs and genetic alterations on a large population of cells acquired by using a cell-based in vitro microscopy assay.  “hidden” spatial information are critical in HTS cbecause drug and genetic phenotypic effects on cells strongly depend on cell to cell and cellular spatial interactions. This initaill prototype is structured as a pipeline of separated modules going from image segmentation, data extraction, data management to machine learning classification, statistical analysis and data visualization: 


![workflow](/IMG/workflow.png)

- [Image segmentation by tasselletion](/Image_Tessellation/README.md) 
- [Data extraction](/Data_Extraction/README.md)
- [Data management](/Data_Managment/README.md)
- Machine learning classification 
