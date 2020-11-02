

********************************************************************************
***** Raw data and public data / de-identified PII data *************************

* Input directory   : 	Raw data in sub-folder "raw data"
* Output	        : 	Merged data in sub-folder "merged data"
* Log files        	: 	"$DATE raw2clean_wave3.log" in sub-folder "logs"
* Last edit        	:	9 July 2018, Julius

********************************************************************************


clear all
set more off


/* 

*** Only if run separately

cd "`c(pwd)'"

*/

* Log file

 quietly {
	local sdate = date("$S_DATE","DMY")
	local YY = substr("`= year(`sdate')'",3,2)
	local MM = "`= month(`sdate')'"
	if length("`MM'") == 1 local MM = "0" + "`MM'"
	local DD = "`= day(`sdate')'"
	if length("`DD'") == 1 local DD = "0" + "`DD'"
	global DATE = "`YY'" + "`MM'" + "`DD'"
}

cap log using "/logs/$DATE raw2clean_W4.log", text replace


***** Prepare datasets 


*** f4_05

* Reshape wide
use "raw data/f4_05.dta", clear
drop f4_5_1_cd f4_ea f4_noshop
sort cspro_id type_5_1
reshape wide f4_5_1_a1 f4_5_1_a2 f4_5_1_a3, i(cspro_id) j(type_5_1)
save "raw data/f4_05_mod.dta", replace


*** f4_05_2

* Generate unique ID
use "raw data/f4_05_2.dta", clear
drop type_503_1 type_503_2 type_503_3
egen cspro_id = concat(f4_ea f4_noshop), punct("")
sort cspro_id
save "raw data/f4_05_2_mod.dta", replace

* Merge 05 with 05_2 previous
use "raw data/f4_05_mod.dta",  clear
sort cspro_id
merge 1:1 cspro_id using "raw data/F4_05_2_mod.dta"
drop _merge
save "raw data/f4_05_05_2_merged.dta", replace


*** f4_07_2

* Reshape wide
use "raw data/f4_07_2.dta", clear
sort cspro_id type_7_15
reshape wide f4_7_15a, i(cspro_id) j(type_7_15)
save "raw data/f4_07_2_mod.dta", replace

//by cspro_id type_7_15, sort: gen _j = _n


***** Combine datasets

use "raw data/f4_COV.dta",  clear


foreach x in CP 01 02 03 04 05_05_2_merged 07 07_2_mod 08 09 10 13 16 {

	* Merge with previous
	sort cspro_id
	merge 1:1 cspro_id using "raw data/F4_`x'.dta"
	drop _merge

}

sort cspro_id

*** Switch to English labels
label language eng

***** Save file and store log
save "merged data/W4_merged.dta", replace
clear

//qui log close
