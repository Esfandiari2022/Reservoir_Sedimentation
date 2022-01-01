This readme.txt file was generated on 2022-01-01 by Sara Esfandiari


GENERAL INFORMATION

1. Title of Dataset: Sefidrud reservoir hydrographic data 

2. Author Information
	A. Principal Investigator Contact Information
		Name: Sara Esfandiari
		Institution: Graduate student of Shahid Beheshti University
		Email: sa.esfandiari@mail.sbu.ac.ir

	B. Associate or Co-investigator Contact Information
		Name: Mohammad Reza Majdzadeh Tabatabai
		Institution: Faculty of Shahid Beheshti University
		Email: m_majdzadeh@sbu.ac.ir

	C. Associate or Co-investigator Contact Information
		Name: Seyyed Saeid Mousavi Nadoushani
		Institution: Faculty of Shahid Beheshti University
		Email: sa_mousavi@sbu.ac.ir
		
	 D. Associate or Co-investigator Contact Information
            Name: Farhad Imanshoar
            Institution: Iran Water Resources Management Company
            Email: imanshoar@gmail.com

3. Date of data collection (single date, range, approximate date): 2020-09-08

4. Geographic location of data collection: the Sefidrud dam is located in Gilan province in Rudbar city, Iran with a longitude of 49°23'16.01" and latitude of 36°45'31". 

5. Information about funding sources that supported the collection of the data: this project is part of a project under the Grant Ref Number of RIV 1400-10-2 that was carried out by Majdzadeh Tabatabai.


SHARING/ACCESS INFORMATION

1. Was data derived from another source? yes/no
	A. If yes, list source(s): the data were supplied by Iran Water Resources Management Company.


DATA & FILE OVERVIEW

1. File List: 
   The reservoir_sedimentation repository contains two folders as follows:

   Dataset:
   This folder consists of three following excel files, which were used for modeling MLP and RF models: 
   100mcross.csv: this file contains the years and coordinates of the extracted points with 100 m distance, which were used in MLP1.
   Data.csv: this file contains the years and coordinates of the extracted points with 10 m distance, which were used in MLP2 and RF.
   volume-height: this file contains the years and volume-height records of the reservoir which were used in the 5-layer MLP model.

   R Script:
   This folder contains three R scripts for developing MLP and RF models as follows:
   MLP1: this script is for developing the MLP model using the points with 100 m distance
   MLP2: this script is for developing the MLP model using the points with 10 m distance
   RF: this script is for developing the RF model using the points with 10 m distance
   5-layer MLP: this script is for developing the MLP model using the volume-elevation records

2. Relationship between files, if important:
   The 100mcross.csv was used in MLP1 script, while the Data.csv was used in MLP2 and RF. The volume-height file was also used in 5-layer MLP script.

METHODOLOGICAL INFORMATION

1. Description of methods used for collection/generation of data: four periods of the Sefidrud reservoir topographic maps were converted into triangular irregular networks (TIN). These models were then converted into DEMs with a spatial resolution of 30 m and numerous cross and longitudinal sections were extracted from them. The points of these sections were extracted to be used in MLP and RF models.

2. Instrument- or software-specific information needed to interpret the data: 
   R: A Language and Environment for Statistical Computing. The necnecessary packages or libraries are as follows: 
   keras, tensorflow, mlbench, dplyr, magrittr, neuralnet, caTools, plot3D, rgl, plot3Drgl, and randomForest.


DATA-SPECIFIC INFORMATION FOR: [100mcross.csv]

1. Number of variables: 4

2. Number of cases/rows: 29164

3. Variable List: 
   Year: the corresponding years of the extracted points
   X: the longitudes of the extracted points in meters
   Y: the latitudes of the extracted points in meters
   Z: the elevation of the extracted points in meters

4. Missing data codes: 
   -9999


DATA-SPECIFIC INFORMATION FOR: [Data.csv]

1. Number of variables: 4

2. Number of cases/rows: 681624

3. Variable List: 
   Year: the corresponding years of the extracted points
   X: the longitudes of the extracted points in meters
   Y: the latitudes of the extracted points in meters
   Z: the elevation of the extracted points in meters

4. Missing data codes: 
   -9999
   
   
   DATA-SPECIFIC INFORMATION FOR: [volume-height.csv]

1. Number of variables: 3

2. Number of cases/rows: 319

3. Variable List: 
   Year: the corresponding years of the volume-height records
   Elevation: the elevation of the recorded reservoir volume in meters
   Volume: the volume of the reservoir in million cubic meters (MCM)
