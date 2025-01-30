# 2024 Example datasets

These were generally added to test and resolve errors that came up due to unanticipated
conditions.

### OB1 2024-05-21, 2024-05-31

 These two were added to resolve an issue where a sensor was swapped and 
placments.csv updated to indicate the swap, BUT the qc module was still
throwing errors. 

### OB1 2024-07-30  

The conductivity meter had issues so a fixed (average) salinity was used for
calibration breaking the QC code.

### SB2X 2024-05-15, 2024-06-10 

Conductivity was calibrated with a single point calibration on these two dates instead 
of the standard 2-point calibration. 

### BD1 2024-06-21
    This sensor has a wierd column name:  

    From Kristin:
    I was working through BD1 and got the error message: 
    
    `Error in qc_deployment(deployment_dir) : The calibration data data is missing some expected columns: "High_Range"`
    
    I believe it comes down to the fact that whenever I export .csv files from this particular sensor, it names the column "HIgh Range High Range (?S/cm)" as opposed to the normal "High Range (?S/cm)." If I try to manually adjust this, it screws up the dates saved in the .csv and I think spawns some other issues with the code. I am going to try to figure out why this particular data file exports that heading slightly differently, but could the code be adjusted to still recognize it if "High Range" is repeated?
    If you want to look at the data I'm working with, it's BD1 2024-06-21.
    
### OB9 2024-07-23

    "OB9 for 2024-07-23 is a really good example of a dataset that has a sensor malfunction written in, so the graphs are difficult to read."
    (the sensor error code -888.88 is getting plotted resulting in a massive yrange on the plot).


## WFH 2024-04-09
    This is an example of tide rider output. The TR_WFH_20240409_TRSX01.csv was from Michael Jakuba and emailed to me by Kristin Huizenga on 2024-12-05. 
    It contained high frequency of observations that I resampled at 10 minute intervals. 
    The other calibrated data files are hacked copies from a separate deployment.  
    See data-raw/make_fake_tide_rider_calibration_dir.R  for how these files were generated.
     