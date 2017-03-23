## Voronoi Image Segmentator

The Voronoi image segmentator is used to segment high content images (Figure 1) in cellular units. To determine the cellular units I used a Voronoi diagram (Figure 2). The voronoi diagram is built from a set of points called seeds, which in our case they are the cell nuclei. Then from each seed it determine a corresponding region consisting of all points closer to that seed than to any other. In other words the cells of a voronoi diagram, also called tassells, are a measure of how close the seed/nucleus of that region is to its neighbours seeds/nuclei. In terms of biology the single tassels of a voronoi diagram thranslates in a measurement cell density, which is critical for many biological processes: proliferation, apoptosis, cell signaling etc. 


![Screenshot](/IMG/HCI_example2.png)
**Figure 1**
High Content image acquisitions taken with an automated confocal microscope at 20x magnification from Human cells plated in 96wells under various drug treatment and genetic alterations. The image above show the acquistion of nuclei used for calcualting the voronoi diagram (figure below).


![Screenshot](/IMG/voronoi_5.png)
**Figure 2** An example of Voronoi diagram


## Software

The Voronoi/Segmentator takes in input i) the path to the folder where the images are located,ii)  the path to the folder where to save the calculated ROIs related to the single tassells of the voronoi diagram. iii) A string to identify the type of file name from which the Voronoi diagram is calculated and, iv) the median filter radius and thresholding method used for the sgementation of the seeds. The segmentator returns a file containing the regions of interest (ROIS) of all voronoi tessels .


![UI](/IMG/voronoi_imagej_UI.png)

In the [TEST](./TEST) folder find an image to test the segmentator

## NEXT
- [ ] to use a randomised algorithm based on a KD-TREE data structure to represent the voroni regions locations

The KD-TREE structure allows efficient calculation (O(k log n)) of spatial information, e.g., number and location of neighbouring nuclei/cells (voronoi cells) given a specific region/nucleus. "A k-d tree, or k-dimensional tree, is a data structure used for organizing some number of points in a space with k dimensions. It is a binary search tree with other constraints imposed on it. K-d trees are very useful for range and nearest neighbor searches"
![kd-tree](/IMG/kd_tree.png)
