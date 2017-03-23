# An Integrated Image data Analysis and Machine Learning approach for high-throughput drug and genetic phenotypic screening

## Goal
The goal of this project is to develop an initial Integrated image data analysis and machine learning  software prototype for high-throughput drug and genetic phenotypic screen. high-throughput phenotypic screening also called  high-content analysis (HCA) or cellomics, is a used in biological research and drug discovery to identify substances such as small molecules, peptides, or RNAi that alter the phenotype of a cell in a desired manner. 

As a proof of concept for this project I focused on quantifying and classifying the spatial heterogeneous effect of drugs and genetic alterations on a large population of cells acquired by using a cell-based in vitro microscopy assay. The rationale for uncovering “hidden” spatial information in HTS comes from my experimental work on cell signaling, which shows that drug and genetic phenotypic effects on cells strongly depend on cell to cell and cellular spatial interactions. This initaill prototype is structured as a pipeline of five main modules (see figure below)


![workflow](/IMG/workflow.png)

- [Voronoi Image Segmentator](/Image_Tessellation/README.md) 
- [Data extraction](/Data_Extraction/README.md)
- [Data management](/Data_Managment/README.md)
- Machine learning classification 
