# CityScope Repository
Solely Developed by Ira Winder [jiw@mit.edu] MIT Media Lab, C. 2014 - 2017

(Note: Ownership of this repository was transferred from the discontinued "Changing Places" Repository on August 7, 2017.)

CityScope is a collection of open source scripts developed with Processing 2 IDE v2.2.1, largely to serve the "CityScope" platform at  [http://cp.media.mit.edu/city-simulation](http://cp.media.mit.edu/city-simulation).
* Colortizer has been moved to its [own repo](https://github.com/ChangingPlaces/Colortizer)!!
* Arrange a Meeting with Ira Winder [jiw@mit.edu] before making any commits to this repository.
* Avoid forking the repository and instead opt to make a new branch.

## Setup
1. Clone Repository to your machine
2. Download Processing 2.2.1 from [Processing.org](https://processing.org/download/?processing) and set its preferences such that the Sketchbook location is the *CityScope/Processing/* Folder. ( We use Processing 2 since CityScope uses some libraries which have not yet migrated to Processing 3 )
3. Re-start Processing 2.  Now all of the sketches should show up under File>Sketchbook>

## Useful Tips
* **Colortizer** (has been moved to its own repo!!) takes a webcam input of colored tags and turns it into a matrix of IDs & rotations passed via UDP
* **Legotizer** takes input from Colortizer and *legotizer_data/* folder to rebuild a digital model of the table.  It also sends and receives heatmap data from CitySim.
* **CitySim** takes JSON data of a point cloud received from Legotizer and does matrix math on it.  It tells Legotizer when it is done.
* **CityScope/Misc/** folder containes helper sketches and in-progress sketches.
* **DO NOT** edit the following folders needed to run Processing:
	* *CityScope/examples/*
	* *CityScope/libraries/*
	* *CityScope/modes/*
	* *CityScope/tools/*

## Documentation
CityScope scripts in the repository are compiled and tested with Processing IDE 2.2.1 on Windows 7:

As of January 12, 2016, the following Processing libraries are required.  These should be kept up to date in the repository’s *CityScope/Processing/libraries/* folder:
* **OpenCV** by Greg Borenstein (Colorizer, Legotizer)
* **Keystone** by David Bouchard (Legotizer)
* **UDP** by Stephane Cousot (Colorizer, Legotizer, CitySim)
* **DDPClient** by [Yasushi Sakai](https://github.com/yasushisakai/processing-ddp-client) (Colortizer,Legotizer)
