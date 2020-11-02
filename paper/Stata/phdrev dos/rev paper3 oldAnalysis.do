
clear all
set more off
set scrollbufsize 600000



*********************************************************************************
**** DATA CLEANING *********************************************

//Bilal work
*cd "C:\Users\wb240247\Dropbox\Indonesia Analysis\"

//Julius work
* cd "C:\Users\jruschen\Dropbox\Indonesia\Aspirations\Stata\"
                                                                                      
//Julius home
 cd "C:\Users\Julius\Dropbox\Indonesia\Multidim Aspirations\Stata\Data\"

//Patricio work
*cd "C:\Users\pdalton\Dropbox\Papers\Indonesia\Aspirations\Stata\"

use Analysis_data.dta



*** Data management ***********************************************************


/* Missing value dummies
foreach var in	W1_age_firm W1_formal_tax W1_custom_total W1_prof_est_ihs ///
				W1_age_manager W1_asp12_customer W1_asp_customer W1_asp12_sales W1_aspgap12_sales ///
				W1_asp_cse W1_asp_yrs W1_asp_minprof {
				gen `var' = (`var'==.)
				
				gen `var'_m = 999 if `var'==.
				replace `var'_m = `var' if `var'!=.
				_crcslbl `var'_m `var'
}
*/


*** Macros *********************************************************************


*** Determinants

local wealth			W1_size W1_labour_total W1_custom_total W1_prof_est_ihs 
local wealth_spc				W1_labour_total W1_custom_total W1_prof_est_ihs
local wealth_lbr		W1_size 				W1_custom_total W1_prof_est_ihs
local wealth_cst		W1_size W1_labour_total 				W1_prof_est_ihs
local wealth_sls		W1_size W1_labour_total	W1_custom_total	
local custom_m			W1_custom_total
local prof_m			W1_prof_est_ihs

local firm				W1_age_firm 	W1_formal_tax 	W1_shop_house_sep	W1_loan_amt_ihs 
						
local indiv				W1_male W1_age_manager	W1_educ	W1_time_comp 	W1_risk_comp 	W1_digitspan_total 	W1_cogstyle_rel_perc 	W1_asp_cse
								
local pract				W1_MW_M_score_total W1_MW_B_score_total ///
						W1_MW_R_score_total W1_MW_F_score_total		
						
local horizon			W1_asp_yrs


*** Transformations


* Winsorisations

foreach x in	`wealth' `wealth_spc' `wealth_lbr' `wealth_cst' `wealth_sls' `prof_m' `firm' {
				if regexm("`x'", "_w1") local win1 `win1' `x'
				if regexm("`x'", "_w2") local win2 `win2' `x'
				if regexm("`x'", "_w5") local win5 `win5' `x'


}


foreach w in 			1 2 5 {

	foreach x in		`win`w'' {

		/*foreach wave in	W1 `Waves' {*/
					
						cap drop `x'
						
						local var = subinstr("`x'","_w`w'","",.)
						gen `x' = `var'
						
						local v = 100 - `w'
						winsor2 `x', cuts(`w' `v') replace
						
						local label_`x': var label `var'
						label var `x'	"`label_`x'' (win `w' %)"

		/*}*/
	}
}


* IHS

foreach x in 	`wealth' `wealth_spc' `wealth_lbr' `wealth_cst' `wealth_sls' `prof_m' `firm' {
				if regexm("`x'", "_ihs") local ihs `ihs' `x'
}


foreach x in `ihs' {

	/*foreach wave in	W1 `Waves' {*/

					cap drop `x'
					
					local var = subinstr("`x'","_ihs","",.)
					gen `x' 	= ln(`var' + sqrt((`var'*`var') + 1))
					
					local label_`x': var label `var'
					label var `x'	"`label_`x'' (IHS Transformation)"
	/*}*/
}



********************************************************************************


***** 1 Outcome: Simple aspirations ********************************************


keep if control==1

local i = 0

*** Size Aspirations

* FT asps
reg W1_asp12_size  `wealth' `firm' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i

reg W1_asp12_size W1_size `indiv' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i

reg W1_asp12_size W1_size `pract' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i

reg W1_asp12_size `wealth' `firm' `indiv' `pract' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i

* OT asps
reg W1_asp_size `wealth' `firm' `horizon' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i

reg W1_asp_size W1_size `indiv' `horizon' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i

reg W1_asp_size W1_size `pract' `horizon' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i

reg W1_asp_size `wealth' `firm' `indiv' `pract' `horizon' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i
		

*** Employee Aspirations

* FT asps
reg W1_asp12_employee `wealth' `firm' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i

reg W1_asp12_employee W1_labour_total `indiv' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i

reg W1_asp12_employee W1_labour_total `pract' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i

reg W1_asp12_employee `wealth' `firm' `indiv' `pract' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i

* OT asps
reg W1_asp_employee `wealth' `firm' `horizon' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i	

reg W1_asp_employee W1_labour_total `indiv' `horizon' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i	
	
reg W1_asp_employee W1_labour_total `pract' `horizon' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i	

reg W1_asp_employee `wealth' `firm' `indiv' `pract' `horizon' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i	
	
*** Customer Aspirations
	
* FT asps
reg W1_asp12_customer `wealth' `firm' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i

reg W1_asp12_customer `custom_m' `indiv' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i

reg W1_asp12_customer `custom_m' `pract' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i

reg W1_asp12_customer `wealth' `firm' `indiv' `pract' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i

* OT asps
reg W1_asp_customer `wealth' `firm' `horizon' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i

reg W1_asp_customer `custom_m' `indiv' `horizon' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i

reg W1_asp_customer `custom_m' `pract' `horizon' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i

reg W1_asp_customer `wealth' `firm' `indiv' `pract' `horizon' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i


*** Sales Aspirations
	
* FT asps
reg W1_asp12_sales `wealth' `firm' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i

reg W1_asp12_sales `prof_m' `indiv' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i

reg W1_asp12_sales `prof_m' `pract' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i

reg W1_asp12_sales `wealth' `firm' `indiv' `pract' i.W1_village, r
est store Det_asp_`i'
estadd ysumm
local ++i

* Output
capture erase "Tables\BL determinants\Det_asp.csv"
#delimit ;
esttab Det_asp_* using "Tables\BL determinants\Det_asp.csv", replace modelwidth(16) varwidth(50) depvar legend label
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N"))
	title("Firm- and individual-level determinants of simple aspirations")
	keep(	W1_asp_yrs W1_size W1_labour_total W1_custom_total W1_prof_est_ihs ///
			W1_formal_tax W1_shop_house_sep W1_loan_amt_ihs W1_age_firm ///
			W1_male W1_age_manager W1_educ W1_time_comp W1_risk_comp W1_digitspan_total W1_cogstyle_rel_perc W1_asp_cse ///
			W1_MW_M_score_total W1_MW_B_score_total W1_MW_R_score_total W1_MW_F_score_total)
	order(	W1_asp_yrs W1_size W1_labour_total W1_custom_total W1_prof_est_ihs ///
			W1_formal_tax W1_shop_house_sep W1_loan_amt_ihs W1_age_firm ///
			W1_male W1_age_manager W1_educ W1_time_comp W1_risk_comp W1_digitspan_total W1_cogstyle_rel_perc W1_asp_cse ///
			W1_MW_M_score_total W1_MW_B_score_total W1_MW_R_score_total W1_MW_F_score_total) ;
#delimit cr
	
est drop _all




***** 2 Outcome: Aspirations gaps *********************************************

local i = 0

*** Size Aspirations

* FT asps
reg W1_aspgap12_size  `wealth_spc' `firm' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i

reg W1_aspgap12_size `indiv' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i

reg W1_aspgap12_size `pract' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i

reg W1_aspgap12_size `wealth_spc' `firm' `indiv' `pract' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i

* OT asps
reg W1_aspgap_size `wealth_spc' `firm' `horizon' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i

reg W1_aspgap_size `indiv' `horizon' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i

reg W1_aspgap_size `pract' `horizon' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i

reg W1_aspgap_size `wealth_spc' `firm' `indiv' `pract' `horizon' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i
		
		
*** Employee Aspirations

* FT asps
reg W1_aspgap12_employee `wealth_lbr' `firm' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i

reg W1_aspgap12_employee `indiv' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i

reg W1_aspgap12_employee `pract' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i

reg W1_aspgap12_employee `wealth_lbr' `firm' `indiv' `pract' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i

* OT asps
reg W1_aspgap_employee `wealth_lbr' `firm' `horizon' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i	

reg W1_aspgap_employee `indiv' `horizon' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i	
	
reg W1_aspgap_employee `pract' `horizon' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i	

reg W1_aspgap_employee `wealth_lbr' `firm' `indiv' `pract' `horizon' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i	
	
*** Customer Aspirations
	
* FT asps
reg W1_aspgap12_customer `wealth_cst' `firm' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i

reg W1_aspgap12_customer `indiv' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i

reg W1_aspgap12_customer `pract' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i

reg W1_aspgap12_customer `wealth_cst' `firm' `indiv' `pract' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i

* OT asps
reg W1_aspgap_customer `wealth_cst' `firm' `horizon' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i

reg W1_aspgap_customer `indiv' `horizon' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i

reg W1_aspgap_customer `pract' `horizon' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i

reg W1_aspgap_customer `wealth_cst' `firm' `indiv' `pract' `horizon' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i


*** Sales Aspirations
	
* FT asps
reg W1_aspgap12_sales `wealth' `firm' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i

reg W1_aspgap12_sales `indiv' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i

reg W1_aspgap12_sales `pract' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i

reg W1_aspgap12_sales `wealth' `firm' `indiv' `pract' i.W1_village, r
est store Det_aspgap_`i'
estadd ysumm
local ++i

* Output
capture erase "Tables\BL determinants\Det_aspgap.csv"
#delimit ;
esttab Det_aspgap_* using "Tables\BL determinants\Det_aspgap.csv", replace modelwidth(16) varwidth(50) depvar legend label
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N"))
	title("Firm- and individual-level determinants of aspirations gaps")
	keep(	W1_asp_yrs W1_size W1_labour_total W1_custom_total W1_prof_est_ihs ///
			W1_formal_tax W1_shop_house_sep W1_loan_amt_ihs W1_age_firm ///
			W1_male W1_age_manager W1_educ W1_time_comp W1_risk_comp W1_digitspan_total W1_cogstyle_rel_perc W1_asp_cse ///
			W1_MW_M_score_total W1_MW_B_score_total W1_MW_R_score_total W1_MW_F_score_total)
	order(	W1_asp_yrs W1_size W1_labour_total W1_custom_total W1_prof_est_ihs ///
			W1_formal_tax W1_shop_house_sep W1_loan_amt_ihs W1_age_firm ///
			W1_male W1_age_manager W1_educ W1_time_comp W1_risk_comp W1_digitspan_total W1_cogstyle_rel_perc W1_asp_cse ///
			W1_MW_M_score_total W1_MW_B_score_total W1_MW_R_score_total W1_MW_F_score_total) ;
#delimit cr
	
est drop _all


***** 3) Outcome: Aspirations-related measures ***********************************

local i = 0

	foreach var in W1_imagine_fail W1_asp_yrs_fail W1_asp_yrs {
		
		* Firm-level characteristics
		reg `var' `wealth' `firm' i.W1_village, r
		est sto Det_asp_add_`i'
		estadd ysumm
		local ++i	
		
		* Individual-level characteristics
		reg `var' `indiv' i.W1_village, r
		est sto Det_asp_add_`i'
		estadd ysumm
		local ++i	
		
		* Business practices
		reg `var' `pract' i.W1_village, r
		est sto Det_asp_add_`i'
		estadd ysumm
		local ++i	
		
		* All controls + FEs
		reg `var' `wealth' `firm' `indiv' `pract' i.W1_village, r
		est sto Det_asp_add_`i'
		estadd ysumm
		local ++i
	}

/* Minimum profits
		
reg W1_asp_minprof `wealth' `firm' i.W1_village, r
est sto Det_asp_add_`i'
estadd ysumm
local ++i	
		
reg W1_asp_minprof `prof_m' `indiv' i.W1_village, r
est sto Det_asp_add_`i'
estadd ysumm
local ++i	
		
reg W1_asp_minprof `prof_m' `pract' i.W1_village, r
est sto Det_asp_add_`i'
estadd ysumm
local ++i	
		
reg W1_asp_minprof `wealth' `firm' `indiv' `pract' i.W1_village, r
est sto Det_asp_add_`i'
estadd ysumm
local ++i

* Minimum profits gaps

	reg W1_aspgap_minprof `wealth_sls' `firm' i.W1_village, r
	est sto Det_asp_add_`i'
	estadd ysumm
	local ++i	
		
	reg W1_aspgap_minprof `indiv' i.W1_village, r
	est sto Det_asp_add_`i'
	estadd ysumm
	local ++i	
		
	reg W1_aspgap_minprof `pract' i.W1_village, r
	est sto Det_asp_add_`i'
	estadd ysumm
	local ++i	
		
	reg W1_aspgap_minprof `wealth_sls' `firm' `indiv' `pract' i.W1_village, r
	est sto Det_asp_add_`i'
	estadd ysumm
	local ++i	


foreach var in W1_asp_minprof_diff W1_asp_minprof_frac {

	reg `var' `wealth' `firm' i.W1_village, r
	est sto Det_asp_add_`i'
	estadd ysumm
	local ++i	
		
	reg `var' `prof_m' `indiv' i.W1_village, r
	est sto Det_asp_add_`i'
	estadd ysumm
	local ++i	
		
	reg `var' `prof' `pract' i.W1_village, r
	est sto Det_asp_add_`i'
	estadd ysumm
	local ++i	
		
	reg `var' `wealth' `firm' `indiv' `pract' i.W1_village, r
	est sto Det_asp_add_`i'
	estadd ysumm
	local ++i
}*/
		
* Output
capture erase "Tables\BL determinants\Det_asp_add.csv"
#delimit ;
esttab Det_asp_add_* using "Tables\BL determinants\Det_asp_add.csv", replace modelwidth(16) varwidth(50) depvar legend label
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N"))
	title("Determinants of add aspirations-related measures")
	keep(	W1_size W1_labour_total W1_custom_total W1_prof_est_ihs ///
			W1_formal_tax W1_shop_house_sep W1_loan_amt_ihs W1_age_firm ///
			W1_male W1_age_manager W1_educ W1_time_comp W1_risk_comp W1_digitspan_total ///
			W1_cogstyle_rel_perc W1_asp_cse ///
			W1_MW_M_score_total W1_MW_B_score_total W1_MW_R_score_total W1_MW_F_score_total)
	order(	W1_size W1_labour_total W1_custom_total W1_prof_est_ihs ///
			W1_formal_tax W1_shop_house_sep W1_loan_amt_ihs W1_age_firm ///
			W1_male W1_age_manager W1_educ W1_time_comp W1_risk_comp W1_digitspan_total ///
			W1_cogstyle_rel_perc W1_asp_cse ///
			W1_MW_M_score_total W1_MW_B_score_total W1_MW_R_score_total W1_MW_F_score_total) ;
	#delimit cr
