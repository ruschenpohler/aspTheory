
********************************************************************************
************** 		RETAILERS INDONESIA PROJECT, 2016-2017 		****************
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
local firm		age_firm formal_firm size labour_total labour_nonfam_full

* Individual-level Characteristics (Add Variables Here!)
local entrep	male age_manager educ kids_3 ///
				digitspan_total risk_comp cogstyle_rel ///
				MW_M_score_total MW_B_score_total MW_R_score_total MW_F_score_total
				
*** Outcomes

* Business Performance (Add Variables Here!)
local perform	prof_est prof_est_w1 prof_est_w2 ///
				sales_lastmth sales_lastmth_w1 sales_lastmth_w2

* Business Aspirations (Add Variables Here!)
local bisasp	asp12_shop_z /*asp12_shop_z_w1*/ asp12_sales asp12_sales_w1 ///
				asp12_size /*asp12_size_w1*/ asp12_employee /*asp12_employee_w1*/ ///
				asp12_customer /*asp12_customer_w1*/ ///
				asp_shop_z /*asp_shop_z_w1*/ ///
				asp_size /*asp_size_w1*/ asp_employee /*asp_employee_w1*/ ///
				asp_customer /*asp_customer_w1*/ asp_yrs asp_yrs_w1

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

/* Sorting Binary from Continuous Variables
foreach x in	`bisasp' `educasp' `satisfact' {
				capture assert inlist(W1_`x', 0, 1) //missing(W1_`x') |
                if _rc == 0 local bin `bin' `x'
				if _rc == 1 local cont `cont' `x'
       }
	   
* Retaining Variable for Binary Variables
foreach x in 	`bin'	{
				gen W1_`x'_AM		= W1_`x'
				gen W1_`x'_BM 		= 1 - W1_`x'_AM	
}

*/

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



***** Balance ***************************************************************


* Sum Stats and Balance Table

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
	ttest W1_`var' , by(treatAB) 
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
		mat T[rownumb(T, "`var'"), colnumb(T,"pvAE")] = `r(p)' 
		
} 


matrix list T

clear 
svmat T 
rename T1 Total 
rename T2 sdTotal 
rename T3 tA
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

foreach var in `cov' { 
	
	replace var_name = "$W1_`var'label" in `i' 
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


* Output
capture erase "csv\descriptives\sumstats.csv"
outsheet using "csv\descriptives\sumstats.csv" , replace comma





/***** Average Treatment Effects (ATE) ******************************************


***** Intention to treat (ITT)

										
* Estimation

local i = 1
local m = 1

foreach wave in `Waves' {

	foreach y in `perform' `bisasp' `educasp' `satisfact' {
	
	* Confirming endline data exists
	cap confirm variable `wave'_`y'
	
		if !_rc {
	
			* Confirming baseline data exists
			cap confirm variable W1_`y'
		
				if !_rc {
			
					* Generating Dummies for Missing BL Vars 
					cap drop W1_`y'_m 
					cap drop W1b_`y'
	
					gen W1_`y'_m = (W1_`y'==.) if `wave'_`y'!=. 
					gen W1b_`y' = W1_`y'
					replace W1b_`y'= 5 if W1_`y'_m == 1
		
					* Estimating OLS Specification With Baseline Dep Var and Strata Controls
					display "ITT: With Baseline Dep Var and Strata Controls"
					areg `wave'_`y' `treat' W1b_`y' W1_`y'_m `strata' if `wave'_finished==1, absorb(W1_village) robust

				}
		
				else {
		
					* Estimating OLS Specification With Strata Controls
					display "ITT: With Strata Controls"
					areg `wave'_`y' `treat' `strata' if `wave'_finished==1, absorb(W1_village) robust
						
				}
		
				* Storing Estimates
				eststo T`m'_`wave'_AllOutcomes_`i'
				estadd ysumm
		
				* Performing F-tests
				test B-BM=0
				estadd scalar f_BvsBM = r(p)
				test B-BC=0
				estadd scalar f_BvsBA = r(p)
				test B-BMC=0
				estadd scalar f_BvsBMA = r(p)
				test BM-BC=0
				estadd scalar f_BMvsBA = r(p)
				test BM+BC=BMC
				local sign = sign(_b[BMC]-_b[BM]-_b[BC])
				estadd scalar f_BM_BAvsBMA = ttail(r(df_r),`sign'*sqrt(r(F)))
		
				* Storing Control Group Stats
				sum `wave'_`y' if control==1
				estadd scalar mean = r(mean)
				estadd scalar sd = r(sd)
				
				local ++i
		}
		
		else {
		
		}
		
	}

	capture erase "csv\treatment effects\T`m'_`wave'_AllOutcomes_itt.csv"

	* Excel output
	#delimit ;
		esttab T`m'_`wave'_AllOutcomes_* using "csv\treatment effects\T`m'_`wave'_AllOutcomes_itt.csv", 
		label replace modelwidth(16) varwidth(50) depvar legend 
		cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01)
		stats(r2 N mean sd f_BvsBM f_BvsBA f_BvsBMA f_BMvsBA f_BM_BAvsBMA, 
		fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) 
		labels("R-squared" "N" "Dependent Variable Mean in Control Group" "Dependent Variable SD in Control Group" 
		"F-test (p-value): Book = Book & Movie" "F-test (p-value): Book = Book & Counseling" 
		"F-test (p-value): Book = Book & Movie & Counseling" "F-test (p-value): Book & Movie = Book & Counseling" 
		"F-test (p-value): B & M + B & A > All Three"))
		title(Wave `wave': ITT Effects on All Outcomes) keep(B*);
	#delimit cr

	local ++m	
	est drop _all

	
}
	

***** Treatment on the treated (TOT)


local i = 1

foreach wave in `Waves' {

	foreach y in `perform' `bisasp' `educasp' `satisfact' {
	
	* Confirming endline data exists
	cap confirm variable `wave'_`y'
	
		if !_rc {
	
			* Confirming baseline data exists
			cap confirm variable W1_`y'
		
				if !_rc {
				
					* Generating Dummies for missing BL vars 
					cap drop W1_`y'_m 
					cap drop W1b_`y'
	
					gen W1_`y'_m = (W1_`y'==.) if W3_`y'!=. 
					gen W1b_`y' = W1_`y'
					replace W1b_`y'= 5 if W1_`y'_m == 1
		
					*TOT - Saturated With BL Dep Variable and Strata Controls
					display "TOT: With Baseline Dep Var and Strata Controls"
					xi: ivreg2 `wave'_`y' (`takeup' = `treat') W1b_`y' W1_`y'_m `strata' i.W1_village if `wave'_finished==1, robust

				}
				
				else {
				
					*TOT - Saturated With Strata Controls
					display "TOT: With Strata Controls"
					xi: ivreg2 `wave'_`y' (`takeup' = `treat') `strata' i.W1_village if `wave'_finished==1, robust
				
				}
				
				* Storing Estimates
				eststo T`m'_`wave'_AllOutcomes_`i'
				estadd ysumm
				
				* Performing F-tests
				test BT-BMT=0
				estadd scalar f_BTvsBMT = r(p)
				test BT-BCT=0
				estadd scalar f_BTvsBCT = r(p)
				test BT-BMCT=0
				estadd scalar f_BTvsBMCT = r(p)
				test BMT-BCT=0
				estadd scalar f_BMTvsBCT = r(p)
				test BMT+BCT=BMCT
				local sign = sign(_b[BMCT]-_b[BMT]-_b[BCT])
				estadd scalar f_BMT_BCTvsBMCT = ttail(r(df_r),`sign'*sqrt(r(F)))
				
				* Storing Control Group Stats
				sum `wave'_`y' if control==1
				estadd scalar mean = r(mean)
				estadd scalar sd = r(sd)
				local ++i


		}
		
		else {
		
		}
		
	}

	capture erase "csv\treatment effects\T`m'_`wave'_AllOutcomes_tot.csv"

	* Excel output
	#delimit ;
		esttab T`m'_`wave'_AllOutcomes_* using "csv\treatment effects\T`m'_`wave'_AllOutcomes_tot.csv", 
		label replace modelwidth(16) varwidth(50) depvar legend 
		cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01)
		stats(r2 N mean sd f_BTvsBMT f_BTvsBAT f_BTvsBMAT f_BMTvsBAT f_BMT_BATvsBMAT, 
		fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) 
		labels("R-squared" "N" "Dependent Variable Mean in Control Group" "Dependent Variable SD in Control Group" 
		"F-test (p-value): Book = Book & Movie" "F-test (p-value): Book = Book & Counseling" 
		"F-test (p-value): Book = Book & Movie & Counseling" "F-test (p-value): Book & Movie = Book & Counseling" 
		"F-test (p-value): B & M + B & A > All Three"))
		title(Wave `wave': TOT Effects on All Outcomes) keep(B*);
	#delimit cr

	local ++m	
	est drop _all

}

	
	

***** Heterogeneous Treatment Effects (HTE) ************************************


*** Business Aspirations By Baseline Level of Outcome

local i = 1

foreach wave in `Waves' {

	foreach y in `bisasp12' {
	
		* Confirming endline data exists
		cap confirm variable `wave'_`y'
	
		if !_rc {
	
			* Confirming baseline data exists
			cap confirm variable W1_`y'
		
				if !_rc {

					* Generating Dummies for missing BL vars 
					cap drop W1_`y'_m 
					cap drop W1b_`y'
				
					gen W1_`y'_m 	= (W1_`y'==.) if `wave'_`y'!=. 
					gen W1b_`y' 	= W1_`y'
					replace W1b_`y'	= 5 if W1_`y'_m == 1
					
					* Generating local for HTE dummies
					local hte_`y'	B_`y'_BM BM_`y'_BM BC_`y'_BM BMC_`y'_BM
	
					* Estimating OLS Specification With Baseline Dep Var and Strata Controls
					display "HTE: With BL Dep Var and Strata Controls"
					areg `wave'_`y' `treat' `hte_`y'' W1b_`y' W1_`y'_m `strata' if `wave'_finished==1, absorb(W1_village) robust
		
					* Storing Estimates
					eststo T`m'_`wave'_BisAsps_hte`i'
					estadd ysumm
			
					* Performing F-tests
					test B + B_`y'_BM = 0
					estadd scalar f_BvsBX = r(p)
					test BM + BM_`y'_BM = 0
					estadd scalar f_BMvsBMX = r(p)
					test BC + BC_`y'_BM = 0
					estadd scalar f_BAvsBAX = r(p)
					test BMC + BMC_`y'_BM = 0
					estadd scalar F_BMAvsBMAX = r(p)
			
					* Storing Control Group Stats by Levels of Heterogeneous Variable
					foreach x in	`y'_AM `y'_BM {
									sum `wave'_`y' if control==1 & W1_`x'==1
									estadd scalar mean_`x' = r(mean)
									estadd scalar sd_`x' = r(sd)
					}
			
					local ++i

				}
				
				else {
		
					* Generating local for HTE dummies
					local hte_asp12_shop_z	B_asp12_shop_z_BM BM_asp12_shop_z_BM BC_asp12_shop_z_BM BMC_asp12_shop_z_BM
			
					* Estimating OLS Specification With Baseline Dep Var and Strata Controls
					display "HTE: With Strata Controls"
					areg `wave'_`y' `treat' `hte_asp12_shop_z' `strata' if `wave'_finished==1, absorb(W1_village) robust
				
					* Storing Estimates
					eststo T`m'_`wave'_BisAsps_hte`i'
					estadd ysumm
				
					* Performing F-tests
					test B + B_asp12_shop_z_BM = 0
					estadd scalar f_BvsBX = r(p)
					test BM + BM_asp12_shop_z_BM = 0
					estadd scalar f_BMvsBMX = r(p)
					test BC + BC_asp12_shop_z_BM = 0
					estadd scalar f_BAvsBAX = r(p)
					test BMC + BMC_asp12_shop_z_BM = 0
					estadd scalar F_BMAvsBMAX = r(p)
					
					* Storing Control Group Stats by Levels of Heterogeneous Variable
					foreach x in	asp12_shop_z_AM asp12_shop_z_BM {
									sum `wave'_`y' if control==1 & W1_`x'==1
									estadd scalar mean_`x' = r(mean)
									estadd scalar sd_`x' = r(sd)
									
					}

					local ++i

				}
				
		}
						
		else {
		
		}
		
	}

	capture erase "csv\treatment effects\T`m'_`wave'_BisAsps_hte.csv"
	
	* output
	#delimit ;
		esttab T`m'_`wave'_BisAsps_hte* using "csv\treatment effects\T`m'_`wave'_BisAsps_hte.csv", label replace modelwidth(16) varwidth(50) depvar legend 
		cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
		stats(r2 N 
		mean_asp12_shop_z_AM sd_asp12_shop_z_AM mean_asp12_shop_z_BM sd_asp12_shop_z_BM 
		mean_asp12_sales_AM sd_asp12_sales_AM mean_asp12_sales_BM sd_asp12_sales_BM 
		mean_asp12_sales_w1_AM sd_asp12_sales_w1_AM mean_asp12_sales_w1_BM sd_asp12_sales_w1_BM 
		mean_asp12_size_AM sd_asp12_size_AM mean_asp12_size_BM sd_asp12_size_BM 
		mean_asp12_employee_AM sd_asp12_employee_AM mean_asp12_employee_BM sd_asp12_employee_BM
		mean_asp12_customer_AM sd_asp12_customer_AM mean_asp12_customer_BM sd_asp12_customer_BM
		mean_asp_shop_z_AM sd_asp_shop_z_AM mean_asp_shop_z_BM sd_asp_shop_z_BM 
		mean_asp_size_AM sd_asp_size_AM mean_asp_size_BM sd_asp_size_BM 
		mean_asp_employee_AM sd_asp_employee_AM mean_asp_employee_BM sd_asp_employee_BM 
		mean_asp_customer_AM sd_asp_customer_AM mean_asp_customer_BM sd_asp_customer_BM 
		f_BvsBX f_BMvsBMX f_BAvsBAX F_BMAvsBMAX,
		fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f
		%9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) ///
		labels("R-squared" "N" 
		"Dep Var Mean for AM 12-Mth Shop Asps in Control" "Dep Var SD for AM 12-Mth Shop Asps in Control" "Dep Var Mean for BM 12-Mth Shop Asps in Control" "Dep Var SD for BM 12-Mth Shop Asps in Control" 
		"Dep Var Mean for AM 12-Mth Sales Asps in Control" "Dep Var SD for AM 12-Mth Sales Asps in Control" "Dep Var Mean for BM 12-Mth Sales Asps in Control" "Dep Var SD for BM 12-Mth Sales Asps in Control" 
		"Dep Var Mean for AM 12-Mth Sales Asps (W1) in Control" "Dep Var SD for AM 12-Mth Sales Asps (W1) in Control" "Dep Var Mean for BM 12-Mth Sales Asps (W1) in Control" "Dep Var SD for BM 12-Mth Sales Asps (W1) in Control" 
		"Dep Var Mean for AM 12-Mth Size Asps in Control" "Dep Var SD for AM 12-Mth Size Asps in Control" "Dep Var Mean for BM 12-Mth Size Asps in Control" "Dep Var SD for BM 12-Mth Size Asps in Control" 
		"Dep Var Mean for AM 12-Mth Employee Asps in Control" "Dep Var SD for AM 12-Mth Employee Asps in Control" "Dep Var Mean for BM 12-Mth Employee Asps in Control" "Dep Var SD for BM 12-Mth Employee Asps in Control" 
		"Dep Var Mean for AM 12-Mth Customer Asps in Control" "Dep Var SD for AM 12-Mth Customer Asps in Control" "Dep Var Mean for BM 12-Mth Customer Asps in Control" "Dep Var SD for BM 12-Mth Customer Asps in Control" 
		"Dep Var Mean for AM Ideal Shop Asps in Control" "Dep Var SD for AM Ideal Shop Asps in Control" "Dep Var Mean for BM Ideal Shop Asps in Control" "Dep Var SD for BM Ideal Shop Asps in Control" 
		"Dep Var Mean for AM Ideal Size Asps in Control" "Dep Var SD for AM Ideal Size Asps in Control" "Dep Var Mean for BM Ideal Size Asps in Control" "Dep Var SD for BM Ideal Size Asps in Control" 
		"Dep Var Mean for AM Ideal Employee Asps in Control" "Dep Var SD for AM Ideal Employee Asps in Control" "Dep Var Mean for BM Ideal Employee Asps in Control" "Dep Var SD for BM Ideal Employee Asps in Control" 
		"Dep Var Mean for AM Ideal Customer Asps in Control" "Dep Var SD for AM Ideal Customer Asps in Control" "Dep Var Mean for BM Ideal Customer Asps in Control" "Dep Var SD for BM Ideal Customer Asps in Control" 
		"F-test (p-value): Book + Interaction" "F-test (p-value): Book & Movie + Interaction" "F-test (p-value): Book & Assistaince + Interaction" 
		"F-test (p-value): All Three + Interaction"))
		title(Wave `wave': Heterogeneity in Impact on Business Aspirations by Outcome Level at Baseline) keep(B*);
	#delimit cr

	local ++m
	est drop _all
}




*** Educational Aspirations, Firm Performance, and Satisfaction by Baseline Level of Business Aspirations

local i = 1

foreach wave in `Waves' {

	foreach y in `perform' `educasp' `satisfact' {

	* Confirming endline data exists
	cap confirm variable `wave'_`y'
	
		if !_rc {

			* Confirming baseline data exists
			cap confirm variable W1_`y'
		
				if !_rc {

					* Generating Dummies for missing BL vars 
					cap drop W1_`y'_m 
					cap drop W1b_`y'
				
					gen W1_`y'_m = (W1_`y'==.) if W3_`y'!=. 
					gen W1b_`y' = W1_`y'
					replace W1b_`y'= 5 if W1_`y'_m == 1
	
					foreach hte_var in `hte' {
					
						* Generating local for HTE dummies
						local hte_`hte_var' B_`hte_var'_BM BM_`hte_var'_BM BC_`hte_var'_BM BMC_`hte_var'_BM
			
						* Estimating OLS Specification With Baseline Dep Var and Strata Controls
						display "HTE: With BL Dep Var and Strata Controls"
						areg `wave'_`y' `treat' `hte_`hte_var'' W1b_`y' W1_`y'_m `strata' if W3_finished==1, absorb(W1_village) robust
						
						* Storing Estimates
						eststo T`m'_`wave'_PerfEducSat_hte`i'
						estadd ysumm
						
						* Performing F-tests
						test B + B_`hte_var' = 0
						estadd scalar f_BvsBX = r(p)
						test BM + BM_`hte_var' = 0
						estadd scalar f_BMvsBMX = r(p)
						test BC + BC_`hte_var' = 0
						estadd scalar f_BAvsBAX = r(p)
						test BMC + BMC_`hte_var' = 0
						estadd scalar F_BMAvsBMAX = r(p)
	
						* Storing Control Group Stats by Levels of Heterogeneous Variable
						foreach x in `hte_var'_BM `hte_var'_AM {
							sum `wave'_`y' if control==1 & W1_`x'==1
							estadd scalar mean_`x' = r(mean)
							estadd scalar sd_`x' = r(sd)
						}
			
						local ++i

					}
				}
		
				else {
	
					foreach hte_var in `hte' {
					
						* Generating local for HTE dummies
						local hte_`hte_var' B_`hte_var'_BM BM_`hte_var'_BM BC_`hte_var'_BM BMC_`hte_var'_BM
	
						* Estimating OLS Specification With Strata Controls
						display "HTE: With BL Dep Var and Strata Controls"
						areg `wave'_`y' `treat' `hte_`hte_var'' `strata' if W3_finished==1, absorb(W1_village) robust
						
						* Storing Estimates
						eststo T`m'_`wave'_PerfEducSat_hte`i'
						estadd ysumm
				
						* Performing F-tests
						test B + B_`hte_var' = 0
						estadd scalar f_BvsBX = r(p)
						test BM + BM_`hte_var' = 0
						estadd scalar f_BMvsBMX = r(p)
						test BC + BC_`hte_var' = 0
						estadd scalar f_BAvsBAX = r(p)
						test BMC + BMC_`hte_var' = 0
						estadd scalar F_BMAvsBMAX = r(p)
			
						* Storing Control Group Stats by Levels of Heterogeneous Variable
						foreach x in `hte_var'_BM `hte_var'_AM {
							sum `wave'_`y' if control==1 & W1_`x'==1
							estadd scalar mean_`x' = r(mean)
							estadd scalar sd_`x' = r(sd)
						}
				
						local ++i
				
					}
		
				}
	
		}
		
		else {
			
		}

	}

	capture erase "csv\treatment effects\T`m'_`wave'_PerfEducSat_hte.csv"
	
	* output
	#delimit ;
		esttab T`m'_`wave'_PerfEducSat_hte* using "csv\treatment effects\T`m'_`wave'_PerfEducSat_hte.csv", label replace modelwidth(16) varwidth(50) depvar legend 
		cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
		stats(r2 N 
		mean_asp_shop_z_AM sd_asp_shop_z_AM mean_asp_shop_z_BM sd_asp_shop_z_BM 
		mean_asp12_shop_z_AM sd_asp12_shop_z_AM mean_asp12_shop_z_BM sd_asp12_shop_z_BM 
		f_BvsBX f_BMvsBMX f_BAvsBAX F_BMAvsBMAX,
		fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) ///
		labels("R-squared" "N" 
		"Dep Var Mean for AM 12-Mth Shop Asps in Control" "Dep Var SD for AM 12-Mth Shop Asps in Control" "Dep Var Mean for BM 12-Mth Shop Asps in Control" "Dep Var SD for BM 12-Mth Shop Asps in Control"
		"Dep Var Mean for AM Ideal Asps in Control" "Dep Var SD for AM Ideal Asps in Control" "Dep Var Mean for BM Ideal Asps in Control" "Dep Var SD for BM Ideal Asps in Control"
		"F-test (p-value): Book + Interaction" "F-test (p-value): Book & Movie + Interaction" "F-test (p-value): Book & Assistaince + Interaction" "F-test (p-value): All Three + Interaction"))
		title(Wave `wave': Heterogeneity in Impact on Firm Performance and Education Aspirations and Satisfaction Scores by Levels of 12-Mth and Ideal Business Aspirations at Baseline) keep(B*);
	#delimit cr

	local ++m
	est drop _all

} 

--- Update: Run w firm and entrep locals! ---

*** Characterising high-/low-aspiring entrepreneurs

local ses			W1_male W1_age_manager W1_kids_3 W1_educ /*W1_motive_entrep*/
local firm			W1_age_firm W1_formal_firm W1_size W1_prof_est_w1 W1_labour_total /*W1_sales_lastmth*/
local pract			W1_MW_M_score_total W1_MW_B_score_total W1_MW_R_score_total W1_MW_F_score_total W1_prods_new_5
local psych			W1_digitspan_total W1_cogstyle_intuit W1_cogstyle_system W1_risk_comp /*W1_risk_fin*/

local i = 1


foreach y in		asp12_shop_z_AM asp_shop_z_AM {

	foreach x in 	ses firm pract psych {
	
		* Generating Dummies for missing BL vars 
		foreach var in ``x'' {
		
			cap drop `var'_m 
			cap drop `var'_b
				
			gen `var'_m = (`var'==.)
			gen `var'_b = `var'
			replace `var'_b = 5 if `var'_m == 1
						
			local lbl: var label `var'
			label var `var'_b "`lbl'"
			
			local x_vect `x_vect' `var'_m `var'_b	
		}
		
		* Reg of outcome on current vector of characteristics
		areg W1_`y' `x_vect' if W3_finished==1, absorb(W1_village) robust
		eststo T`m'_AMchars_`i'
		sum W1_`y'
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
		
		
		* Reg of outcome on all vectors of characteristics combined
		local x_allvects `x_allvects' `x_vect'
		
		if "`x_allvects'" != "`x_vect'" {
			areg W1_`y' `x_allvects' if W3_finished==1, absorb(W1_village) robust
			eststo T`m'_AMchars_`i' 
			sum W1_`y'
			estadd scalar mean = r(mean)
			estadd scalar sd = r(sd)
		}
	
		local ++i
		local x_vect ""
		
	}
	
	local x_allvects ""
	
}

capture erase "csv\treatment effects\T`m'_AMchars.csv"
	
* output
#delimit ;
	esttab T`m'_AMchars* using "csv\treatment effects\T`m'_AMchars.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N mean sd, fmt(%9.3f %9.0g %9.3f %9.3f) labels("R-squared" "N" "Dependent Variable Mean" "Dependent Variable SD"))
	title(Wave W1: Characteristics of High-Aspiring Entrepreneurs) drop(*_m);
#delimit cr

	//local ++m
	est drop _all

	

/*

*** By Gender and by Shop Space at Baseline

local i = 1

local hte_size_BM	B_size_BM BM_size_BM BC_size_BM BMC_size_BM
local hte_male		B_male BM_male BC_male BMC_male


foreach wave in `Waves' {

	foreach y in `bisasp' `educasp' `satisfact' {

	* Confirming endline data exists
	cap confirm variable `wave'_`y'
	
		if !_rc {

			* Confirming baseline data exists
			cap confirm variable W1_`y'
		
				if !_rc {

					* Generating Dummies for missing BL vars 
					cap drop W1_`y'_m 
					cap drop W1b_`y'
				
					gen W1_`y'_m = (W1_`y'==.) if W3_`y'!=. 
					gen W1b_`y' = W1_`y'
					replace W1b_`y'= 5 if W1_`y'_m == 1
	
					foreach hte_var in size_BM male {
			
						* Estimating OLS Specification With Baseline Dep Var and Strata Controls
						display "HTE: With BL Dep Var and Strata Controls"
						areg W3_`y' `treat' `hte_`hte_var'' W1b_`y' W1_`y'_m `strata' if W3_finished==1, absorb(W1_village) robust
						eststo T`m'_`wave'_Asps_hte_byGenSize`i'
						estadd ysumm
						test B + B_`hte_var' = 0
						estadd scalar f_BvsBX = r(p)
						test BM + BM_`hte_var' = 0
						estadd scalar f_BMvsBMX = r(p)
						test BC + BC_`hte_var' = 0
						estadd scalar f_BAvsBAX = r(p)
						test BMC + BMC_`hte_var' = 0
						estadd scalar F_BMAvsBMAX = r(p)
	
						foreach x in size_AM size_BM male female {
							sum W3_`y' if control==1 & W1_`x'==1
							estadd scalar mean_`x' = r(mean)
							estadd scalar sd_`x' = r(sd)
						}
			
						local ++i

					}
				}
		
				else {
	
					foreach hte_var in size_BM male {
	
						* Estimating OLS Specification With Strata Controls
						display "HTE: With BL Dep Var and Strata Controls"
						areg W3_`y' `treat' `hte_`hte_var'' `strata' if W3_finished==1, absorb(W1_village) robust
						
						* Storing Estimates
						eststo T`m'_`wave'_Asps_hte_byGenSize`i'
						estadd ysumm
				
						* Performing F-tests
						test B + B_`hte_var' = 0
						estadd scalar f_BvsBX = r(p)
						test BM + BM_`hte_var' = 0
						estadd scalar f_BMvsBMX = r(p)
						test BC + BC_`hte_var' = 0
						estadd scalar f_BAvsBAX = r(p)
						test BMC + BMC_`hte_var' = 0
						estadd scalar F_BMAvsBMAX = r(p)
			
						* Storing Control Group Stats by Levels of Heterogeneous Variable
						foreach x in size_AM size_BM male female {
							sum W3_`y' if control==1 & W1_`x'==1
							estadd scalar mean_`x' = r(mean)
							estadd scalar sd_`x' = r(sd)
						}
				
					local ++i
				
					}
		
				}
		
			else {
			
			}
	
		}

	}



	capture erase "csv\treatment effects\T`m'_`wave'_Asps_hte_byGenderSize.csv"
	
	* output
	#delimit ;
		esttab T`m'_`wave'_Asps_hte_byGenSize* using "csv\treatment effects\T`m'_`wave'_Asps_hte_byGenderSize.csv", label replace modelwidth(16) varwidth(50) depvar legend 
		cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
		stats(r2 N mean_size_AM sd_size_AM mean_size_BM sd_size_BM mean_male sd_male mean_female sd_female f_BvsBX f_BMvsBMX f_BAvsBAX F_BMAvsBMAX,
		fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) ///
		labels("R-squared" "N" "Dep Var Mean for AM Size in Control" "Dep Var SD for AM Size in Control" "Dep Var Mean for BM Size in Control" "Dep Var SD for BM Size in Control"
		"Dep Var Mean for Males in Control" "Dep Var SD for Males in Control" "Dep Var Mean for Females in Control" "Dep Var SD for Females in Control"
		"F-test (p-value): Book + Interaction" "F-test (p-value): Book & Movie + Interaction" "F-test (p-value): Book & Assistaince + Interaction" "F-test (p-value): All Three + Interaction"))
		title(Heterogeneity in Impact on Wave `wave' Outcomes by Gender and Business Size) keep(B*);
	#delimit cr

	//local ++m
	est drop _all


}


