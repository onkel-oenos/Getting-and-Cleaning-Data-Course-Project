---
title: "Codebook"
author: "Bob Gravestijn"
date: "22 January, 2015"
output: html_document
---

## Introduction  
******
A codebook is a technical description of the data that was collected for a particular purpose. It describes how the data are arranged in the computer file or files, what the various numbers and letters mean, and any special instructions on how to use the data properly.

This code book, together with README.md and run_analysis.R are the result of a Course Project assignment for the course "Getting and Cleaning Data" of the Data Science Specialization in Coursera. The purpose of this project is to demonstrate my ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

The work is peer-reviewed.  

This document is part of a set of documents:  

* CodeBook.md - snapshot of the tidy dataset.
* README.md - detailed explanation about the project and the R script.
* run_analysis.R - R script code.
* tidydata.txt - tidy data output of the R script.

## Tidydata.txt description  
******
7200 obs. of  8 variables  

**activity**  
*description*: activity carried out by a volenteer within an age bracket of 19-48 years  
*format*: character, 8 labels  
*labels*: 

1. LAYING   
2. SITTING  
3. STANDING  
4. WALKING  
5. WALKING_DOWNSTAIRS  
6. WALKING_UPSTAIRS  

**subject**  
*description*: identification code for each volunteer  
*format*: integer, 30 labels, ordered numerically from 1 to 30  
*label*: 1..30
  
**motion component**  
*description*: motion component of the sensor acceleration signal  
*format*: character, 2 labels  
*labels*:  

1. body
2. gravitational 

**measurement of motion**  
*description*:  
*format*: character, 8 labels  
*labels*:  

1. angularvelocity (rate of change of angular displacement)
2. angularvelocityjerk (rate of change of angular velocity)
3. angularvelocityjerkmagnitude (rate of change of magnitude of angular velocity)       
4. angularvelocitymagnitude ()
5. linearacceleration (the rate of change of the rate of change of displacement)
6. linearaccelerationjerk (the rate of change of lineair acceleration)    
7. linearaccelerationjerkmagnitude (the rate of change magnitude of lineair acceleration) 
8. linearaccelerationmagnitude ()

**average statistical value**  
*description*:  
*format*: character, 2 levels  
*variables*:  

1. mean (or average, the sum of a collection of numbers divided by the number of numbers in the collection)
2. stddev (standard deviation, the amount of variation or dispersion from the average)

**(axial) direction**  
*description*:  
*format*: character, 4 levels  
*variables*:  

1. x
2. y
3. z
4. '-' (i.e. no direction)

**frequency**  
*description*: value of the average statistical arithmic of a motion measurement in the frequency domain  
*format*: numeric  

**time**  
*description*: value of the average statistical arithmic of a motion measurement in the time domain  
*format*: numeric  


### Missing values

* frequency: 2520 NA's