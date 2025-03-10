# Set up example data for Buzzards Bay Analysis module
# B. Compton, 19 Feb 2025



library(BuzzardsBay)

# Set up example data. Run this, then copy c:\Work\etc\COMBB_analysis\RB1.zip into c:\Work\etc\COMBB_analysis\data\BB_Data\2024\ and unzip it
setup_example_dir(parent_dir = 'c:/Work/etc/COMBB_analysis/data/', year_filter = 2024, site_filter = c('AB2', 'E33'))


# Look up site info
x <- lookup_site_paths('c:/Work/etc/COMBB_analysis/data/BB_Data/2024/AB2')
x <- lookup_site_paths('c:/Work/etc/COMBB_analysis/data/BB_Data/2024/e33')



# stich sites
stitch_site('c:/Work/etc/COMBB_analysis/data/BB_Data/2024/ab2')
stitch_site('c:/Work/etc/COMBB_analysis/data/BB_Data/2024/e33')
stitch_site('c:/Work/etc/COMBB_analysis/data/BB_Data/2024/rb1')


# check sites
check_site('c:/Work/etc/COMBB_analysis/data/BB_Data/2024/ab2')
check_site('c:/Work/etc/COMBB_analysis/data/BB_Data/2024/e33')
check_site('c:/Work/etc/COMBB_analysis/data/BB_Data/2024/rb1')


# get reports
report_site('c:/Work/etc/COMBB_analysis/data/BB_Data/2024/ab2')
report_site('c:/Work/etc/COMBB_analysis/data/BB_Data/2024/e33')
report_site('c:/Work/etc/COMBB_analysis/data/BB_Data/2024/rb1')
