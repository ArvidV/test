***********************************************************************************

* File: build_crop.do
* Modified by: Arvid Viaene (viaene@uchicago.edu)
* Contact: Arvid Viaene (viaene@uchicago.edu)
/* 
Objective: The objective of this program is to insheet the data, 
provide exploratory data analysis, and create a cleaned data for the project

1. Rename the variables, to their respective crop
2. See if both corn, soybeans and crops are matched 1-1 in all the counties, or for which counties there are missing variables


** If I have all the corn & wheat, can just rerun the script
*/

***********************************************************************************


// The files from the NASS quickstats-lite contain the planted and harvested acres as seperate files
// Therefore, the first step is to join them into the same by doing a merge within the sample

******************
**** ILLINOIS ****
******************

** Creating the planted acres variable from the csv file
insheet using "/Users/arvidviaene/Dropbox/1 Research/Data/1 Crops/Template file/build/input/CORN-IL.csv", clear
keep if commodity == "CORN"
sort year stateansi asdcode countyansi
save corn_planted, replace

** Creating the harvested, production, and yield data from the csv file
insheet using "/Users/arvidviaene/Dropbox/1 Research/Data/1 Crops/Template file/build/input/CORN-IL.csv", clear
keep if commodity == "CORN, GRAIN"
sort year stateansi asdcode countyansi
drop areaplantedinacres productionintons yieldintonsacre yieldinbunetplantedacre
save corn_harv_pr_y, replace

** merging them on state, county, agricultural and year  // not asd leads to duplicates because of "other" categories 
merge 1:1 year stateansi asdcode countyansi using corn_planted // all matched

** clean-up
rm corn_planted.dta 
rm corn_harv_pr_y.dta

** Dropping the variables that have no observations (left from the original file)
drop _merge productionintons yieldintonsacre yieldinbunetplantedacre //

** destring the variables, which have commas in them, you could drop the $ or % sign)
destring, replace ignore("$ ,%")

** rename the variables with the corn_suffix to allow for the merge
rename areaharvestedinacres area_h_corn
rename areaplantedinacres area_p_corn
rename productioninbu prod_corn
rename yieldinbuacre yield_corn

** saving the data
save corn_merged, replace


******************
**** OHIO - IOWA - INDIANA ****
******************


/*
destring countyansi, generate(countyansi_n) force
sort countyansi_n


