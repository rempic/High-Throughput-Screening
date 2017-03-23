## Image segmentation by voronoi tassellation

The goal of this module is to segment  acquired  high content images (Figure 1) in cellular units and then to measure  single cell spatial and morphological values. In particular, to determine the cellular units I calculate a voronoi diagram (Figure 2).  The voronoi diagram is built from a set of points, called seeds, sites or generators, in this project the seeds are the nuclei, and, from each seed it determine a corresponding region consisting of all points closer to that seed than to any other. In other words the  regions of a voronoi diagram, also called Voronoi cells or tassells , are a measure of how close the seed/nucleus of that region is to its neighbours seeds/nuclei. In terms of biology the single tassels of a voronoi diagram gives a measurement cell density, which is know to be importatn for many biological processes: proliferation, apoptosis, cell signaling etc. 


![Screenshot](/IMG/HCI_example2.png)
**Figure 1**
High Content image acquisitions taken with an automated confocal microscope at 20x magnification from Human cells plated in 96wells under various drug treatment and genetic alterations. The image above show the acquistion of nuclei used for calcualting the voronoi diagram (figure below).


![Screenshot](/IMG/voronoi_5.png)
**Figure 2** An example of Voronoi diagram


## Software

The Image Voronoi/Segmentation software is developped in imageJ/Fiji. It takes in input the path to the folder where the images are located, the path to the folder where to save the calculated ROIs related to the single tassells of the voronoi diagram. A string to identify the type of file name from which the Voronoi diagram is calculated and median radius and threshoolding metdho for sementation  of the seeds from the image. It returns a list of region of interest (ROIS) . related to the single tassells of the voronoi diagram


[Voronoi](./Voronoi).
![UI](/IMG/voronoi_imagej_UI.png)

## TO DO
- [ ] to use a randomised algorithm based on a KD-TREE data structure to represent the voroni regions locations

The KD-TREE structure  allows efficient calculation (O(k log n)) of spatial information, e.g., number and location of neighbouring nuclei/cells (voronoi cells) given a specific region/nucleus. "A k-d tree, or k-dimensional tree, is a data structure used for organizing some number of points in a space with k dimensions. It is a binary search tree with other constraints imposed on it. K-d trees are very useful for range and nearest neighbor searches"
![kd-tree](/IMG/kd_tree.png)
