********************************************************************************
************** 		RETAILERS INDONESIA PROJECT, 2016-2018 		****************
*
*				            Main analysis do-file
*		
********************************************************************************


set matsize 11000
clear all

cd "`c(pwd)'\"

do Data\merging_data.do

use Data\Analysis_data.dta, clear

set more off

local rn



***** Locals


*** Treatment Dummies
local treat		B 	BM 	BC 	BMC
local takeup	BT 	BMT	BCT	BMCT


*** Strata Controls
local strata 	W1_male W1_space_ord W1_MW_score_total_abovemd


*** Waves (Add Selection Here!)
local Waves		W3 W4


*** HTE Variables (for Outcomes Other Than Business Aspirations)
local hte		asp12_shop_z asp_shop_z


*** Descriptives

* Firm-level Characteristics (Add Variables Here!)
local firm		age_firm formal_tax size labour_total labour_nonfam_full custom_total

* Entrepreneur-level Characteristics (Add Variables Here!)
local entrep	male age_manager educ kids_3 ///
				digitspan_total risk_comp time_comp ///
				MW_M_score_total MW_B_score_total MW_R_score_total MW_F_score_total
				
*** Outcomes

* Business Performance (Add Variables Here!)
local perform	prof_est prof_est_w1 prof_est_w2 ///
				sales_lastmth sales_lastmth_w1 sales_lastmth_w2 ///
				sales_nday sales_nday_w1 sales_nday_w2

* Business Aspirations (Add Variables Here!)
local bisasp	asp12_shop_z /*asp12_shop_z_w1*/ asp12_sales asp12_sales_w1 ///
				asp12_size /*asp12_size_w1*/ asp12_employee /*asp12_employee_w1*/ ///
				asp12_customer /*asp12_customer_w1*/ ///
				asp_shop_z /*asp_shop_z_w1*/ ///
				asp_size /*asp_size_w1*/ asp_employee /*asp_employee_w1*/ ///
				asp_customer /*asp_customer_w1*/ asp_yrs

* Educational Aspirations (Add Variables Here!)
local educasp	asp_educ_son /*aspgap_educ_son*/ asp_educ_son_ma ///
				asp_educ_dtr /*aspgap_educ_dtr*/ asp_educ_dtr_ma ///
				asp_educ_kids asp_educ_kids_ma /*aspgap_educ_kids*/
				
* Satisfaction (Add Variables Here!)
local satisfact	satisfact_life satisfact_fin

	
***** Variable preparation *****************************************************


* Labels

foreach wave in W1 W3 W4 {

label var `wave'_asp12_shop_z 			"Aggregate Short-Term Aspirations"
label var `wave'_asp12_size 			"Short-Term Shop Size Aspirations"
label var `wave'_asp12_employee 		"Short-Term Employee Aspirations "
label var `wave'_asp12_customer 		"Short-Term Customer Aspirations "
label var `wave'_asp12_sales 			"Short-Term Sales Aspirations"
label var `wave'_asp_shop_z 			"Aggregate Long-Term Aspirations"
label var `wave'_asp_size 				"Long-Term Shop Size Aspirations"
label var `wave'_asp_employee 			"Long-Term Employee Aspirations "
label var `wave'_asp_customer 			"Long-Term Customer Aspirations "

label var `wave'_sales_lastmth			"Sales Last Month"
label var `wave'_prof_est				"Estimated Profits Last Month"

label var `wave'_prof_est				"Estimated Profits Last Month"
label var `wave'_prof_lastmth			"Self-reported Profits Last Month"
label var `wave'_sales_lastmth			"Sales Last Month"

}

foreach wave in W1 W3 {

label var `wave'_asp_educ_son			"Aspired Educ for Son"
local son: var label `wave'_asp_educ_son
label var `wave'_aspgap_educ_son		"`son' (Gap)"
label var `wave'_asp_educ_son_AM		"`son' Above Md (Yes=1)"
label var `wave'_asp_educ_son_BM		"`son' Below Md (Yes=1)"
label var `wave'_asp_educ_son_ma		"`son' at Least MA (Yes=1)"

label var `wave'_asp_educ_dtr			"Aspired Educ for Daughter"
local dtr: var label `wave'_asp_educ_dtr
label var `wave'_aspgap_educ_dtr		"`dtr' (Gap)"
label var `wave'_asp_educ_dtr_AM		"`dtr' Above Md (Yes=1)"
label var `wave'_asp_educ_dtr_BM		"`dtr' Below Md (Yes=1)"
label var `wave'_asp_educ_dtr_ma		"`dtr' at Least MA (yes=1)"

label var `wave'_asp_educ_kids			"Aspired Educ for Children"
local kid: var label `wave'_asp_educ_kids
label var `wave'_aspgap_educ_kids		"`kid' (Gap)"
label var `wave'_asp_educ_kids_ma		"`kid' at Least MA (Yes=1)"
label var `wave'_asp_educ_kids_AM		"`kid' Above Md (Yes=1)"
label var `wave'_asp_educ_kids_BM		"`kid' Below Md (Yes=1)"

label var `wave'_kids_3					"Has at Least 3 Children (Yes=1)"
label var `wave'_formal_firm 			"Firm Registered (for Taxes or Else)
label var `wave'_cogstyle_intuit 		"Intuitive Working Style (0-10 Scale)"
label var `wave'_cogstyle_system		"Systematic Working Style (0-10 Scale)"

label var `wave'_prods_new_5			"At Least 5 New Products in Last 3 Months (Yes=1)"

}

label var W1_digitspan_total 			"Digit Span (0-8 Scale)"



*** Transformations


* Winsorisations

foreach x in	`perform' `bisasp' {
				if regexm("`x'", "_w1") local win1 `win1' `x'
				if regexm("`x'", "_w2") local win2 `win2' `x'
				if regexm("`x'", "_w5") local win5 `win5' `x'


}


foreach w in 			1 2 5 {

	foreach x in		`win`w'' {

		foreach wave in	W1 `Waves' {
					
						cap drop `wave'_`x'
						
						local var = subinstr("`x'","_w`w'","",.)
						gen `wave'_`x' = `wave'_`var'
						
						local temp = 100 - `w'
						winsor2 `wave'_`x', cuts(`w' `temp') replace
						
						local label_`x': var label `wave'_`var'
						label var `wave'_`x'	"`label_`x'' (win `w' %)"

		}
	}
}


* IHS

foreach x in	`perform' `bisasp' {
				if regexm("`x'", "_ihs") local ihs `ihs' `x'
}

foreach x in 		`ihs' {

	foreach wave in	W1 `Waves' {

					cap drop `wave'_`x'
					local var = subinstr("`x'","_ihs","",.)
					gen `wave'_`x' 	= ln(`wave'_`var' + sqrt((`wave'_`var'*`wave'_`var') + 1))
					local label_`x': var label `wave'_`var'
					label var `wave'_`x'	"`label_`x'' (IHS Transformation)"
	}
}


*** AM/BM Dummies

foreach x in	`perform' `bisasp' `educasp' {	
				cap drop W1_`x'_AM 
				cap drop W1_`x'_BM
				egen W1_`x'_md 		= median(W1_`x')
				gen W1_`x'_AM 		= (W1_`x'>W1_`x'_md) if !missing(W1_`x')
				gen W1_`x'_BM 		= 1 - W1_`x'_AM
}




*** Interaction Dummies and Labels

foreach T in	`treat' {

	foreach y in `perform' `bisasp' `educasp' `satisfact' {
	
		* Confirming baseline data exists
		cap confirm variable W1_`y'
		
		* Generating Dummies
		if !_rc {
		
			gen `T'_`y'_BM			= `T' * W1_`y'_BM	
			local label: var label `T'
			label var `T'_`y'_BM	"Below-Md Aspirations at Baseline X `label'"
		}

		else {

		}

	}

	* Additional Dummies for HTEs
	gen `T'_size_BM					= `T' * W1_size_BM
	label var `T'_size_BM			"Below-Md Business Size at Baseline X `label'"
				
	gen `T'_male					= `T' * W1_male
	label var `T'_male				"Male Entrepreneur X `label'"
}



***** Balance (T1 and T2) ***************************************************************


* Sum Stats and Balance Table

keep if control==1

local cov		`entrep' `firm' `perform' `bisasp' `educasp'

cap gen tA		= control
label var tA	"Control Group"
cap gen tB		= B
label var tB	"Handbook Only"
cap gen tC		= BM
label var tC	"Handbook and Movie"
cap gen tD		= BC
label var tD	"Handbook and Assistance"
cap gen tE		= BMC
label var tE	"Handbook, Movie, and Assistance"

* Data
gen treatAB = 1 if tA==1 		
replace treatAB = 0 if tB==1 
gen treatAC = 1 if tA==1 
replace treatAC = 0 if tC==1 
gen treatAD = 1 if tA==1 
replace treatAD = 0 if tD==1  
gen treatAE = 1 if tA==1 
replace treatAE = 0 if tE==1  
gen treatBC = 1 if tB==1 
replace treatBC = 0 if tC==1 
gen treatBD = 1 if tB==1 
replace treatBD = 0 if tD==1
gen treatBE = 1 if tB==1 
replace treatBE = 0 if tE==1 
gen treatCD = 1 if tC==1 
replace treatCD = 0 if tD==1 
gen treatCE = 1 if tC==1 
replace treatCE = 0 if tE==1
gen treatDE = 1 if tD==1 
replace treatDE = 0 if tE==1


* Estimation

local z:			word count `cov'
matrix T = 			J(`z', 11, . ) 
matrix rownames T =	`cov' 
matrix colnames T =	Total sdTotal tA tB tC tD tE pvAB pvAC pvAD pvAE

foreach var in `cov' { 

	global W1_`var'label: var label W1_`var' 
	
	sum W1_`var' 
		mat T[rownumb(T, "`var'"), colnumb(T,"sdTotal")] = `r(sd)' 
		mat T[rownumb(T, "`var'"), colnumb(T,"Total")] = `r(mean)' 
		mat T[rownumb(T, "`var'"), colnumb(T,"Md")] = `r(median)' 
	/*ttest W1_`var' , by(treatAB) 
		mat T[rownumb(T, "`var'"), colnumb(T,"tA")] = `r(mu_2)' 
		mat T[rownumb(T, "`var'"), colnumb(T,"tB")] = `r(mu_1)' 
		mat T[rownumb(T, "`var'"), colnumb(T,"pvAB")] = `r(p)' 
	ttest W1_`var' , by(treatAC) 
		mat T[rownumb(T, "`var'"), colnumb(T,"tC")] = `r(mu_1)' 
		mat T[rownumb(T, "`var'"), colnumb(T,"pvAC")] = `r(p)' 
	ttest W1_`var' , by(treatAD) 
		mat T[rownumb(T, "`var'"), colnumb(T,"tD")] = `r(mu_1)' 
		mat T[rownumb(T, "`var'"), colnumb(T,"pvAD")] = `r(p)'
	ttest W1_`var' , by(treatAE) 
		mat T[rownumb(T, "`var'"), colnumb(T,"tE")] = `r(mu_1)' 
		mat T[rownumb(T, "`var'"), colnumb(T,"pvAE")] = `r(p)' */
		
} 


matrix list T

clear 
svmat T 
rename T1 Total 
rename T2 sdTotal 
rename T3 Md
rename T4 tB
rename T5 tC
rename T6 tD
rename T7 tE
rename T8 pvAB 
rename T9 pvAC 
rename T10 pvAD
rename T11 pvAE
 

gen var_name = "" 
order var_name 

local i = 1 

foreach x in `cov' { 
	
	//local label_`x': var label W1_`x'
	//replace var_name = "`label_`x''" in `i'
	replace var_name = "$W1_`x'label" in `i' 
	local i = `i' + 1 

} 


label var var_name "Variable" 
label var sdTotal "SD of Total" 
label var Total "Total" 
label var tA "Group A" 
label var tB "Group B" 
label var tC "Group C" 
label var tD "Group D" 
label var tE "Group E" 
label var pvAB "A vs B" 
label var pvAC "A vs C"
label var pvAD "A vs D" 
label var pvAE "A vs E" 

/*
foreach var of varlist pvAB pvAC pvAD pvAE { 
	
	replace `var' = round(`var', 0.001) 
	format `var' %9.3f 
} 

foreach var of varlist Total sdTotal tA tB tC tD tE { 
	
	replace `var' = round(`var', 0.01) 
	format `var' %9.2f 
} 


gen starsab = "" 
replace starsab = "*" if pvAB <= 0.10 
replace starsab = "**" if pvAB <= 0.05 
replace starsab = "***" if pvAB <= 0.01 
move starsab pvAC 
gen starsac = "" 
replace starsac = "*" if pvAC <= 0.10 
replace starsac = "**" if pvAC <= 0.05 
replace starsac = "***" if pvAC <= 0.01 
move starsac pvAD 
gen starsad = "" 
replace starsad = "*" if pvAD <= 0.10 
replace starsad = "**" if pvAD <= 0.05 
replace starsad = "***" if pvAD <= 0.01 
move starsad pvAE 
gen starsae = "" 
replace starsae = "*" if pvAE <= 0.10 
replace starsae = "**" if pvAE <= 0.05 
replace starsae = "***" if pvAE <= 0.01 


foreach x in Total tA tB tC tD tE pvAB pvAC pvAD pvAE { 

	replace `x'=. if var_name=="" 
} 

foreach x in starsab starsac starsad starsae {
 
	replace `x'="" if var_name=="" 
} 
*/

* Output
capture erase "csv\phdrev\paper3\sumstats.csv"
outsheet using "csv\phdrev\paper3\sumstats.csv" , replace comma


/*
***** Attrition ***********************************************************


*** Balance across experimental groups

use "Data\Analysis_data.dta", clear
set more off


* Regressors

foreach wave in `Waves' {

gen `wave'_sample		= (`wave'_finished==1)
lab var `wave'_sample	"Business Part of Endline"
gen `wave'_shutdown		= (`wave'_closed==1)
lab var `wave'_shutdown	"Business Closed at Endline"
gen `wave'_refusal		= (`wave'_refused==1)
lab var `wave'_refusal	"Business Refused Endline Interview"

}

* Estimation 

est drop _all
local i = 1

foreach wave in `Waves' {

	foreach y in `wave'_sample `wave'_shutdown {
	

		reg `y' `treat', absorb(W1_village) robust
		est sto `wave'_attrit_treat_`i'
		estadd ysumm
		
		test B-BM=0
		estadd scalar p_B_BM = r(p)
		test B-BC=0
		estadd scalar p_B_BC = r(p)
		test B-BMC=0
		estadd scalar p_B_BMC = r(p)
		test BM-BC=0
		estadd scalar p_BM_BC = r(p)
		sum `y' if control==1
		estadd scalar mean = r(mean)
		
		local ++i

	
		areg `y' `treat' `strata', absorb(W1_village) robust
		est sto `wave'_attrit_treat_`i'
		estadd ysumm
		
		test B-BM=0
		estadd scalar p_B_BM = r(p)
		test B-BC=0
		estadd scalar p_B_BA = r(p)
		test B-BMC=0
		estadd scalar p_B_BMC = r(p)
		test BM-BC=0
		estadd scalar p_BM_BC = r(p)
		sum `y' if control==1
		estadd scalar mean = r(mean)
	
		local ++i
		
	}
	
* Output
capture erase "csv\multidim asps\descriptives\`wave'_attrit_treat.csv"
#delimit ;
esttab `wave'_attrit_treat_* using "csv\multidim asps\descriptives\`wave'_attrit_treat.csv", label replace modelwidth(16) varwidth(50) depvar legend
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01)
	stats(r2 N mean p_B_BM p_B_BC p_B_BMC p_BM_BC, fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f) 
	labels("R-squared" "N" "Mean of Dependent Variable in Control Group" "F-test (p-value): Book = Book & Movie" "F-test (p-value): Book = Book & Assistance" "F-test (p-value): Book = Book & Movie & Assistance" "F-test (p-value): Book & Movie = Book & Assistance"))
	title("Balance of attrition across experimental groups at wave `wave'") keep(B*) ;
#delimit cr
	
}


*** Balance on baseline covariates

* Regressors

local Miss_x W1_size /*W1_newbranch_nextyr*/ W1_loan_amt W1_assets_otherfirm W1_formal_firm W1_space_own /*W1_age_firm*/ /*W1_MW_score_total*/ W1_prof_est W1_kids_3 /*W1_age_manager*/ /*W1_finlit_score*/ W1_educ W1_digitspan W1_trust_stranger W1_motive_entrep

est drop _all
local i = 1

foreach wave in `Waves' {

	//foreach t in `treat' {

		foreach x in `Miss_x' {

			areg `wave'_sample `x', robust absorb(W1_village)
			est sto `wave'_attrit_cov_`i'
			estadd ysumm
		
			sum `wave'_sample if control==1
			estadd scalar mean = r(mean)
		
			local ++i
			
		}

	//}

* Output
capture erase "csv\multidim asps\descriptives\`wave'_attrit_cov.csv"
#delimit ;
esttab `wave'_attrit_cov_* using "csv\multidim asps\descriptives\`wave'_attrit_cov.csv", label replace modelwidth(16) varwidth(50) depvar legend
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01)
	stats(r2 N mean p_B_BM p_B_BC p_B_BMC p_BM_BC, fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f) 
	labels("R-squared" "N" "Mean of Dependent Variable in Control Group" "F-test (p-value): Book = Book & Movie" "F-test (p-value): Book = Book & Assistance" "F-test (p-value): Book = Book & Movie & Assistance" "F-test (p-value): Book & Movie = Book & Assistance"))
	title("Balance of attrition on baseline covariates at wave `wave'") keep();
#delimit cr

}

* Output
capture erase "csv\multidim asps\descriptives\sumstats.csv"
outsheet using "csv\multidim asps\descriptives\sumstats.csv" , replace comma





