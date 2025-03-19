# Set up example data for Buzzards Bay Analysis module
# B. Compton, 19 Feb 2025



library(BuzzardsBay)

# Set up example data. Run this, then copy c:\Work\etc\COMBB_analysis\RB1.zip into c:\Work\etc\COMBB_analysis\data\BB_Data\2024\ and unzip it
setup_example_dir(parent_dir = 'c:/Work/etc/COMBB_analysis/data/', year_filter = 2024, site_filter = c('AB2', 'E33'))

setup_example_dir(parent_dir = 'c:/Work/etc/COMBB_analysis/data2/', year_filter = 2023, site_filter = c('WH1X'))


# Look up site info
x <- lookup_site_paths('c:/Work/etc/COMBB_analysis/data/BB_Data/2024/AB2')
x <- lookup_site_paths('c:/Work/etc/COMBB_analysis/data/BB_Data/2024/e33')


# extract Baywatchers data

extract_baywatchers('c:/Work/etc/COMBB_analysis/data/BB_Data', year = 2023)


# stich sites

stitch_site('c:/Work/etc/COMBB_analysis/data/BB_Data/2024/ab2')
stitch_site('c:/Work/etc/COMBB_analysis/data/BB_Data/2024/e33')
stitch_site('c:/Work/etc/COMBB_analysis/data/BB_Data/2024/rb1')
stitch_site('C:/Work/etc/COMBB_analysis/data/BB_Data/2024/OB1')
stitch_site('C:/Work/etc/COMBB_analysis/data/BB_Data/2024/OB2')
stitch_site('C:/Work/etc/COMBB_analysis/data/BB_Data/2024/OB3')
stitch_site('C:/Work/etc/COMBB_analysis/data/BB_Data/2023/wh1x')


# check sites

check_site('c:/Work/etc/COMBB_analysis/data/BB_Data/2024/ab2')
check_site('c:/Work/etc/COMBB_analysis/data/BB_Data/2024/e33')
check_site('c:/Work/etc/COMBB_analysis/data/BB_Data/2024/rb1')
check_site('C:/Work/etc/COMBB_analysis/data/BB_Data/2023/wh1x')


# get reports

report_site('c:/Work/etc/COMBB_analysis/data/BB_Data/2024/ab2')
report_site('c:/Work/etc/COMBB_analysis/data/BB_Data/2024/e33')
report_site('c:/Work/etc/COMBB_analysis/data/BB_Data/2024/rb1')
report_site('C:/Work/etc/COMBB_analysis/data/BB_Data/2023/wh1x')  # with Baywatchers
