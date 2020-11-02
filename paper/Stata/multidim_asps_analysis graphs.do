
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
local firm		age_firm formal_tax size labour_total labour_nonfam_full

* Entrepreneur-level Characteristics (Add Variables Here!)
local entrep	male age_manager educ kids_3 ///
				digitspan_total risk_comp time_comp ///
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
				asp_customer /*asp_customer_w1*/ //asp_yrs

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
						
						local v = 100 - `w'
						winsor2 `wave'_`x', cuts(`w' `v') replace
						
						local label_`x': var label `wave'_`var'
						label var `wave'_`x'	"`label_`x'' (win `w' %)"

		}
	}
}


* IHS

foreach x in 	`perform' `bisasp' {
				if regexm("`x'", "_ihs") local ihs `ihs' `x'
}


foreach x in `ihs' {

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

}

/* Aspirations

quietly eststo asp12_1:	areg W4_asp12_shop_z `treat' `strata' W1_asp12_shop_z 	if W4_finished==1 & W1_asp12_shop_z_BM==0 	, absorb(W1_village) ro
quietly eststo asp12_0:	areg W4_asp12_shop_z `treat' `strata' W1_asp12_shop_z 	if W4_finished==1 & W1_asp12_shop_z_BM==1 	, absorb(W1_village) ro
quietly eststo asp_1: 	areg W4_asp_shop_z `treat' `strata' W1_asp_shop_z 		if W4_finished==1 & W1_asp_shop_z_BM==0 	, absorb(W1_village) ro
quietly eststo asp_0: 	areg W4_asp_shop_z `treat' `strata' W1_asp_shop_z 		if W4_finished==1 & W1_asp_shop_z_BM==1 	, absorb(W1_village) ro

coefplot	(asp12_1, label(High Aspirations)) 	(asp12_0, label(Low Aspirations))	,bylabel(ST Shop Aspirations)   ///
|| 			(asp_1)           					(asp_0)               				,bylabel(LT Shop Aspirations)  ///
||																					,drop(_cons W1_asp12_shop_z W1_asp_shop_z `strata') ///
																					xline(0) mlabel format(%7.2f) mlabposition(12) mlabgap(*2) ///
																					grid(glpattern(dash)) msymbol(D) mfcolor(white) ///
																					levels(95 90) ciopts(lwidth(3 ..) lcolor(*.4 *1)) ///
																					legend(order(1 "95%" 2 "90%" 3 4 "95%" 5 "90%" 6) row(2))
																					//ciopts(lwidth(*3) lcolor(*.6))
									

quietly eststo asp12_1:	areg W3_asp12_shop_z `treat' `strata' W1_asp12_shop_z 	if W3_finished==1 & W1_asp12_shop_z_BM==0 	, absorb(W1_village) ro
quietly eststo asp12_0:	areg W3_asp12_shop_z `treat' `strata' W1_asp12_shop_z 	if W3_finished==1 & W1_asp12_shop_z_BM==1 	, absorb(W1_village) ro
quietly eststo asp_1: 	areg W3_asp_shop_z `treat' `strata' W1_asp_shop_z 		if W3_finished==1 & W1_asp_shop_z_BM==0 	, absorb(W1_village) ro
quietly eststo asp_0: 	areg W3_asp_shop_z `treat' `strata' W1_asp_shop_z 		if W3_finished==1 & W1_asp_shop_z_BM==1 	, absorb(W1_village) ro

coefplot	(asp12_1, label(High Aspirations)) 	(asp12_0, label(Low Aspirations))	,bylabel(ST Shop Aspirations)   ///
|| 			(asp_1)           					(asp_0)               				,bylabel(LT Shop Aspirations)  ///
||																					,drop(_cons W1_asp12_shop_z W1_asp_shop_z `strata') ///
																					grid(glpattern(dash)) xline(0) msymbol(D) mfcolor(white) ///
																					levels(95 90) ciopts(lwidth(3 ..) lcolor(*.4 *1)) ///
																					legend(order(1 "95%" 2 "90%" 3 4 "95%" 5 "90%" 6) row(2))
																					//ciopts(lwidth(*3) lcolor(*.6)) 

*/
* Performance
	
quietly eststo prof_1:	areg W3_prof_est_w1 `treat' `strata' W1_prof_est_w1 			if W3_finished==1 & W1_asp12_shop_z_BM==0 	, absorb(W1_village) ro
quietly eststo prof_0:	areg W3_prof_est_w1 `treat' `strata' W1_prof_est_w1 			if W3_finished==1 & W1_asp12_shop_z_BM==1 	, absorb(W1_village) ro
quietly eststo sales_1: areg W3_sales_lastmth_w1 `treat' `strata' W1_sales_lastmth_w1 	if W3_finished==1 & W1_asp12_shop_z_BM==0 	, absorb(W1_village) ro
quietly eststo sales_0: areg W3_sales_lastmth_w1 `treat' `strata' W1_sales_lastmth_w1 	if W3_finished==1 & W1_asp12_shop_z_BM==1 	, absorb(W1_village) ro

coefplot	(prof_1, label(High Aspirations)) 	(prof_0, label(Low Aspirations))	,bylabel(Monthly profits)   ///
|| 			(sales_1)           				(sales_0)               			,bylabel(Monthly sales)  ///
||																					,drop(_cons W1_asp12_shop_z W1_asp_shop_z `strata') ///
																					xline(0) mlabel format(%7.2f) mlabposition(12) mlabgap(*2) ///
																					grid(glpattern(dash)) msymbol(D) mfcolor(white) ///
																					levels(95 90) ciopts(lwidth(3 ..) lcolor(*.4 *1)) ///
																					legend(order(1 "95%" 2 "90%" 3 4 "95%" 5 "90%" 6) row(2))
																					//ciopts(lwidth(*3) lcolor(*.6))
/*																				
quietly eststo prof_1:	areg W4_prof_est_w1 `treat' `strata' W1_prof_est_w1 			if W4_finished==1 & W1_asp12_shop_z_BM==0 	, absorb(W1_village) ro
quietly eststo prof_0:	areg W4_prof_est_w1 `treat' `strata' W1_prof_est_w1 			if W4_finished==1 & W1_asp12_shop_z_BM==1 	, absorb(W1_village) ro
quietly eststo sales_1: areg W4_sales_lastmth_w1 `treat' `strata' W1_sales_lastmth_w1 	if W4_finished==1 & W1_asp12_shop_z_BM==0 	, absorb(W1_village) ro
quietly eststo sales_0: areg W4_sales_lastmth_w1 `treat' `strata' W1_sales_lastmth_w1 	if W4_finished==1 & W1_asp12_shop_z_BM==1 	, absorb(W1_village) ro

coefplot	(prof_1, label(High Aspirations)) 	(prof_0, label(Low Aspirations))	,bylabel(Monthly profits)   ///
|| 			(sales_1)           				(sales_0)               			,bylabel(Monthly sales)  ///
||																					,drop(_cons W1_asp12_shop_z W1_asp_shop_z `strata') ///
																					xline(0) mlabel format(%7.2f) mlabposition(12) mlabgap(*2) ///
																					grid(glpattern(dash)) msymbol(D) mfcolor(white) ///
																					levels(95 90) ciopts(lwidth(3 ..) lcolor(*.4 *1)) ///
																					legend(order(1 "95%" 2 "90%" 3 4 "95%" 5 "90%" 6) row(2))
																					//ciopts(lwidth(*3) lcolor(*.6))
																				
																					


