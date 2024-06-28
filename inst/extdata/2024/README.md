# 2024 Example datasets

These were generally added to test and resolve errors that came up due to unanticipated
conditions.

### OB1 2024-05-21, 2024-05-31

 These two were added to resolve an issue where a sensor was swapped and 
placments.csv updated to indicate the swap, BUT the qc module was still
throwing errors. 

### SB2X 2024-05-15, 2024-06-10 

Conductivity was calibrated with a single point calibration on these two dates instead 
of the standard 2-point calibration. 

### BD1 2024-06-21
    This sensor has a wierd column name:  

    From Kristin:
    I was working through BD1 and got the error message: 
    
    `Error in qc_deployment(deployment_dir) : The calibration data data is missing some expected columns: "High_Range"`
    
    I believe it comes down to the fact that whenever I export .csv files from this particular sensor, it names the column "HIgh Range High Range (µS/cm)" as opposed to the normal "High Range (µS/cm)." If I try to manually adjust this, it screws up the dates saved in the .csv and I think spawns some other issues with the code. I am going to try to figure out why this particular data file exports that heading slightly differently, but could the code be adjusted to still recognize it if "High Range" is repeated?
    If you want to look at the data I'm working with, it's BD1 2024-06-21.
    
