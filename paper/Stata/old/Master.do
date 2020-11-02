
clear all
cls
set more off



**** Agenda
* Fix educ aspirations in EL
* Fix labels
* Merge datasets



***** Set root directory
cd "`c(pwd)'\"



***** MERGE WAVES ************************************************************


* Prepare baseline and endline data
do "BL_cleaning 051118.do"
do "EL_cleaning 051118.do"


* Merge waves
use	"dta\W1_clean_data.dta", clear

merge 1:1 shop_ID using "dta\W3_clean_data.dta"
tab _m
drop _m


***** SAVE DATA **************************************************************

***** Save file
save "dta\W1_W3_merged.dta", replace
