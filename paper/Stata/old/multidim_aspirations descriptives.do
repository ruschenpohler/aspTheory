
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


***** VAR PREP ***************************************************************

* Labels

foreach v in W1 W3 {

label var `v'_asp12_shop_z 				"Aggregate Short-Term Aspirations"
label var `v'_aspgap12_shop_z 			"Aspirations Gap for Aggregate Short-Term Aspirations"
label var `v'_asp_shop_z 				"Aggregate Long-Term Aspirations"
label var `v'_aspgap_shop_z 			"Aspirations Gap for Aggregate Long-Term Aspirations"
label var `v'_asp12_size_z 				"Short-Term Shop Size Aspirations (Zscore)"
label var `v'_asp12_employee_z 			"Short-Term Employee Aspirations (Zscore)"
label var `v'_asp12_customer_z 			"Short-Term Customer Aspirations (Zscore)"
label var `v'_asp12_sales_z 			"Short-Term Sales Aspirations (Zscore)"

label var `v'_asp_educ_son				"Aspired educ for son (Years)"
label var `v'_asp_educ_son_ma			"Aspired educ for son at least MA (Yes=1)"
label var `v'_asp_educ_dtr				"Aspired educ for daughter (Years)"
label var `v'_asp_educ_dtr_ma			"Aspired educ for daughter at least MA (yes=1)"
label var `v'_asp_educ_kids				"Aspired educ for children (Years)
label var `v'_asp_educ_kids_ma			"Aspired educ for children at least MA (Yes=1)"
}


* Firm-level Characteristics (Add Variables Here!)
local firm		age_firm formal_firm size labour_total labour_nonfam_full

* Individual-level Characteristics (Add Variables Here!)
local entrep	male age_manager educ kids_3 ///
				digitspan_total risk_comp cogstyle_intuit cogstyle_system ///
				MW_M_score_total MW_B_score_total MW_R_score_total MW_F_score_total

* Business Performance (Add Variables Here!)
local perform	prof_est prof_est_w1 prof_est_w2 prof_est_ihs ///
				sales_lastmth sales_lastmth_w1 sales_lastmth_w2 sales_lastmth_ihs

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



***** SUM STATS ***************************************************************


* Sum Stats and Balance Table

local cov		`entrep' `firm' `perform' `bisasp' `educasp' `satisfact'

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
*/

