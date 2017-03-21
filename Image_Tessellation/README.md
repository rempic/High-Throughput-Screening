## Image segmentation by voronoi tassellation

The goal of this part of the project is to segment an image acquisition (Figure 1) in cellular units so that we can calculate the data features for the single cells in the entire cell population. In particularr to determine the cellular units I used a voronoi diagram (Figure 2) on the cell nuclei.  the voronoi diagram is built from a set of points, called seeds, sites or generators, in this project the seeds are the nuclei centrois and for each seed is determned  a corresponding region consisting of all points closer to that seed than to any other. In other words the  regions of a voronoi diagrma , also called Voronoi cells or tassells , are a measure of how close the seed/nucleus of that region is to its neighbours seeds/nuclei. In terms of biology the single tassels of a voronoi diagram gives a mearumented of he level of cell confinement or contact inhibition, which is know to affect many cellular phenotypic effect: proliferation, apoptosis, cell signaling etc. This type of information might be critical to increase the accurancy for example of a drug or genetic screen which has as readout for example the cell proliferation. 


![Screenshot](/IMG/HCI_example2.png)
**Figure 1**
I used  to test my software High Content image acquisitions taken with an automated confocal microscope at 20x magnification from Human cells plated in 96wells under various drug treatment and genetic alterations. The image above show the acquistion of nuclei used for calcualting the voronoi diagram. The acquistion covers a total area of about 3x3mm from a single well. 


![Screenshot](/IMG/voronoi_5.png)
**Figure 2** Voronoi diagram on an entire High content image acquisiton. More or less confined of regions of the images are hightlited. 


## Software
the Image Voronoi/Segmentation software prototype was developped in imageJ/Fiji (2.0.0):
[Voronoi](./Voronoi).
![UI](/IMG/voronoi_imagej_UI.png)
The Image Voronoi/Segmentation software returns a list of region of interest (ROIS) to be used on the actuired images and measure their content. 

## TO DO
- [ ] to use a randomised algorithm based on a KD-TREE data structure to represent the voroni regions locations

The KD-TREE structure  allows efficient calculation (O(k log n)) of spatial information, e.g., number and location of neighbouring nuclei/cells (voronoi cells) given a specific region/nucleus. "A k-d tree, or k-dimensional tree, is a data structure used for organizing some number of points in a space with k dimensions. It is a binary search tree with other constraints imposed on it. K-d trees are very useful for range and nearest neighbor searches"
![kd-tree](/IMG/kd_tree.png)
