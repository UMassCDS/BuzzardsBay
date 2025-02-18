These files were emailed by Lara Gulmann 2025-01-27 they are examples of data from the new logger with a file for each type of calibration:

2025-01-04 - has two point calibration.  I think this is the most common type.
2025-01-26 - has three point calibration.
2025-01-27 - has one point calibration.  


Additionally Lara included this information:



I've attached files with each type of calibration we anticipate using:?

**Conductivity:?2 or 3 standards**?

**Dissolved oxygen sensors: 1 or 2 'standards' which is at 100% only and both 100% and 0%)**


In the Details Tab, DO Percent Saturation Calibration will either be reported with 2 'standards':

  

```
DO Percent Saturation Calibration
	100% Saturation
	Temperature?20.84 ?C
	Barometric Pressure 102.1400 kPa
	Measured Dissolved Oxygen 9.140 mg/L
	0% Saturation
	Measured Dissolved Oxygen 0.010 mg/L
```

Please note, both the example files for Conductivity have 2 DO standards, and are representative of using both 0% and 100% DO for calibration.


Or will either be reported as here with only 100% saturation (and in the attached file):

```
DO Percent Saturation Calibration
    100% Saturation
    Temperature?18.46 ?C
    Barometric Pressure 101.2980 kPa
	  Measured Dissolved Oxygen 9.530 mg/L
```



For Conductivity, we are interested in keeping track of the following, here for the example with 3 calibration points.?
```
Series : Electrical Conductivity (W-CTD-00 22118267), ?S/cm??????

            Channel Parameters
			Conductivity Calibration Date 2025/01/26 15:01:30 EST
			Calibration Point 1 : "Specific Conductance at 25?C: 1413 ?S/cm

Measured Specific Conductance:?1314.4 ?S/cm

Temperature: 18.65 ?C"

    Calibration Point 2 : "Specific Conductance at 25?C: 12880 ?S/cm

Measured Specific Conductance: 12682.06 ?S/cm

Temperature: 19.54 ?C"

    Calibration Point 3 : "Specific Conductance at 25?C: 80000 ?S/cm

Measured Specific Conductance: 86761.64 ?S/cm

Temperature: 19.62 ?C"

```


As for the calibration metadata,

yes, moving forward, we'd like to keep track of DO calibration metadata from the older loggers (Nothing for the old conductivity loggers)

  

For the old loggers, this DO calibration metadata exists in the DO details file. The date/time and Calibration Gain and Offset would be useful to keep track of.??

? ?From the Dissolved Oxygen details file (i.e. DO_AB2_2024_06_12Details.txt)

  

? ? Calibration Date: 04/29/24 05:09:49 PM GMT-04:00
        ? Calibration Gain: 1.11108
        ? Calibration Offset: -0.00072

  

Lastly, for the new loggers, the column header output for the Data tab can vary slightly (see below).? The units of a metric are either in parentheses or not and the order of serial number and units can change.??

  
```

Date-Time (EST)
Temperature (?C) (W-DO 22124010)
Measured DO (mg/L) (W-DO 22124010)
Salinity-Adjusted DO (mg/L) (W-DO 22124010)
Temperature (?C) (W-CTD-00 22118266)
Absolute Pressure (kPa) (W-CTD-00 22118266)
Electrical Conductivity (?S/cm) (W-CTD-00 22118266)
Specific Conductivity (?S/cm) (W-CTD-00 22118266)
Salinity (PSU) (W-CTD-00 22118266)
Barometric Pressure (kPa)
Percent Saturation (%)
Water Level (m)


Date-Time (EST)
Temperature (W-DO 22124010), ?C
Measured DO (W-DO 22124010), mg/L
Salinity-Adjusted DO (W-DO 22124010), mg/L
Temperature (W-CTD-00 22118266), ?C
Absolute Pressure (W-CTD-00 22118266), kPa
Electrical Conductivity (W-CTD-00 22118266), ?S/cm
Specific Conductivity (W-CTD-00 22118266), ?S/cm
Salinity (W-CTD-00 22118266), PSU
Barometric Pressure , kPa
Percent Saturation , %
Water Level , m
