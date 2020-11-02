
********************************************************************************
************** 		RETAILERS INDONESIA PROJECT, 2016-2018 		****************
*
*				     PhD corrections (L from P, Shocking Asps)
*		
********************************************************************************


set matsize 11000
clear all

cd "`c(pwd)'\"

do Data\merging_data.do

set more off

local rn


***** Variables

*** Variables

foreach var in W1 W3 W4 {
egen `var'_Mcore = rowmean(`var'_MWM4_askcustomquit `var'_discount `var'_prods_new_1 `var'_MWM3_askcustomprod `var'_MWM6_attrcustomdisc)
egen `var'_Mother	= rowmean(`var'_MWM2_visitcompetprod `var'_compsales_compet `var'_MWM5_asksupplprod `var'_MWM7_advert) 
egen `var'_Rcore = rowmean(`var'_MWR1_recwritten `var'_MWR8_recloan /*`var'_rec_accreccustom_TC*/ `var'_separatefin `var'_MWR2_recpurchsale ///
		`var'_rec_ledger /*`var'_startrec_lastyr `var'_rec_sales*/ `var'_rec_weekly /*`var'_rec_stockup `var'_rec_pricesuppliers `var'_rec_accpayloan*/ ///
		/*`var'_profcalc_any `var'_MWR5_costprods `var'_profcalc_any_wk*/)
egen `var'_Rother	= rowmean(`var'_MWR3_recliquid `var'_MWR4_recsalesprods `var'_MWR6_profprods `var'_MWR7_recexpensemth `var'_MWF4_expensenextyr `var'_MWF5_proflossyr `var'_MWF8_incexpenseyr)
egen `var'_DAGG	= rowmean(`var'_discuss_any `var'_jointdec_any) 
egen `var'_PAGG = rowmean(`var'_MWF1_finperform `var'_MWF2_settargetyr `var'_MWF3_comptargetmth)
egen `var'_SAGG = rowmean(`var'_stockup_comp `var'_inventory_change_prof /*`var'_rec_stockup*/ `var'_MWB1_negosupplprice `var'_MWB2_compsupplprod)
}


***** Labels

label var W1_digitspan_total "Respondent Digitspan Score"
label var W1_risk_comp "Respondent Risk Preference Score" 
label var W1_time_comp "Respondent Time Preference Score"
label var W1_male "Respondent is Male" 
label var W1_age_firm "Age of Firm at W1" 

foreach w in W1 W3 {
	label var `w'_educ "Respondent Years of Education at `w'" 
	label var `w'_labour_ft "Number of Full Time Paid Employees at `w'"
	label var `w'_dispose_wk_val "Stock Wastage Each Week (Value in USD PPP) at `w'"
	label var `w'_dispose_wk_propsales "Stock Wastage Each Week (Proportion of Sales) at `w'"
	
	label var `w'_kids_3				"Has at Least 3 Children (Yes=1)"
	label var `w'_formal_firm 			"Firm Registered (for Taxes or Else)
	label var `w'_cogstyle_intuit 		"Intuitive Working Style (0-10 Scale)"
	label var `w'_cogstyle_system		"Systematic Working Style (0-10 Scale)"
	label var `w'_prods_new_5			"At Least 5 New Products in Last 3 Months (Yes=1)"
}


foreach w in W1 W3 W4 {

	label var `w'_asp12_shop_z 			"Aggregate Short-Term Aspirations at `w'"
	label var `w'_asp12_size 			"Short-Term Shop Size Aspirations  at `w'"
	label var `w'_asp12_employee 		"Short-Term Employee Aspirations at `w'"
	label var `w'_asp12_customer 		"Short-Term Customer Aspirations at `w'"
	label var `w'_asp12_sales 			"Short-Term Sales Aspirations at `w'"
	label var `w'_asp_shop_z 			"Aggregate Long-Term Aspirations at `w'"
	label var `w'_asp_size 				"Long-Term Shop Size Aspirations at `w'"
	label var `w'_asp_employee 			"Long-Term Employee Aspirations at `w'"
	label var `w'_asp_customer 			"Long-Term Customer Aspirations at `w'"

	label var `w'_age_manager "Respondent Age at `w'"
	label var `w'_labour_total "Total Number of Employees at `w'"
	label var `w'_labour_nonfam "Total Number of Hired Employees at `w'"
	label var `w'_labour_nonfam_full "Total Number of Hired Full-Time Employees at `w'"
	label var `w'_custom_total "Total Number of Daily Customers at `w'"
	label var `w'_sales_lastmth "Total Sales Last Month (USD PPP) at `w'"
	label var `w'_prof_est "Total Profits Last Month (USD PPP) at `w'" 
	label var `w'_formal_tax "Firm has Tax ID at `w'"
	label var `w'_loan_amt "Outstanding Loans at `w'"
	label var `w'_MW_score_total "McKenzie & Woodruff (2016) Aggregate Score at `w'" 
	label var `w'_MW_M_score_total "MW Marketing Subscore at `w'"
	label var `w'_MW_B_score_total "MW Stocking Up Subscore at `w'"
	label var `w'_MW_R_score_total "MW Record Keeping Subscore at `w'"
	label var `w'_MW_F_score_total "MW Financial Planning Subscore at `w'"
	
	label var `w'_Mcore "Aggregate Marketing Practices (Core) at `w'"
	label var `w'_MWM4_askcustomquit "Consulted with Former Customers at `w'"
	label var `w'_discount "Offered Discount to Loyal/Bulk Customers at `w'"
	label var `w'_prods_new_1 "Offered a New Product for Sale at `w'"
	label var `w'_compsales_compet "Compared Sales Performance with Competitors at `w'"

	label var `w'_Mother "Aggregate Marketing Practices (Other) at `w'"
	label var `w'_MWM2_visitcompetprod "Observed Products for Sale at Competing Business at `w'"
	label var `w'_MWM3_askcustomprod	"Elicited Customer Demand for New Products at `w'"
	label var `w'_MWM5_asksupplprod "Asked Suppliers about High Demand Products at `w'"
	label var `w'_MWM6_attrcustomdisc "Introduced Special Sales Offers at `w'"
	label var `w'_MWM7_advert "Advertised the Business at `w'"

	label var `w'_Rcore "Aggregate Record Keeping Practices (Core) at `w'"
	label var `w'_MWR1_recwritten "Kept Written Business Records at `w'"
	//label var `w'_MWR5_costprods	"Calculated Cost of Sales for Main Products at `w'"
	label var `w'_MWR8_recloan "Have Records Needed to Obtain Business Loan at `w'"
	//label var `w'_startrec_lastyr "Itemized Business Revenues and Expenses at `w'"
	label var `w'_rec_ledger "Kept Formal Business Ledger at `w'"
	label var `w'_rec_weekly "Updated Records At Least Once a Week at `w'"
	/*label var `w'_rec_stockup "Tracked Purchase of Stocks at `w'"
	label var `w'_rec_pricesuppliers "Tracked Prices of Different Suppliers at `w'"
	label var `w'_rec_accreccustom_TC "Recorded Credit to Customers at `w'"
	label var `w'_rec_sales "Tracked Product Sales at `w'"
	label var `w'_rec_accpayloan "Tracked Loan Payments Due at `w'"
	label var `w'_profcalc_any "Calculated Business Profits at `w'"
	label var `w'_profcalc_any_wk "Updated Business Profits At Least Once a Week at `w'"*/
	label var `w'_separatefin "Separated Business and Household Finances at `w'"

	label var `w'_Rother "Aggregate Record Keeping Practices (Other) at `w'"
	label var `w'_MWR2_recpurchsale	"Recorded Every Purchase and Sale at `w'"
	label var `w'_MWR3_recliquid	"Estimated Cash on Hand at `w'"
	label var `w'_MWR4_recsalesprods "Compared Trends in Sales Across Products at `w'"
	label var `w'_MWR6_profprods	"Identified Profit Contribution of Best Products at `w'"
	label var `w'_MWR7_recexpensemth	"Kept Monthly Business Budget at `w'"
	label var `w'_MWB1_negosupplprice "Negotiated Lower Prices with a Supplier at `w'"
	label var `w'_MWB2_compsupplprod "Compare Product Prices and Quality Across Suppliers at `w'"

	label var `w'_DAGG "Aggregate Discussion Practices at `w'"
	label var `w'_discuss_any "Discussed Business Matters with Others at `w'"
	label var `w'_jointdec_any "Made Joint Decisions on Business Matters at `w'"

	label var `w'_PAGG "Aggregate Planning Practices at `w'"
	label var `w'_MWF1_finperform "Reviewed Financial Performance to Identify Areas of Improvement at `w'"
	label var `w'_MWF2_settargetyr "Set Sales Target at `w'"
	label var `w'_MWF3_comptargetmth "Compared Target vs. Actual Monthly Sales at `w'"

	label var `w'_MWF4_expensenextyr "Anticipated Budget for Upcoming Business Costs at `w'"
	label var `w'_MWF5_proflossyr "Kept Annual Profit and Loss Statement at `w'"
	label var `w'_MWF8_incexpenseyr "Kept Annual Income and Expenses Statement at `w'"

	label var `w'_SAGG "Aggregate Stock up Practices at `w'"
	label var `w'_stockup_comp "Top Selling Products Always in Stock (Yes/No) at `w'"
	label var `w'_dispose_wk "Stock Wastage Each Week (Yes/No) at `w'"
	label var `w'_inventory_change_demand "Adjusted Stock Based on Consumer Demand (Yes/No) at `w'"
	label var `w'_inventory_change_prof "Adjusted Stock Based on Product Profitability (Yes/No) at `w'"
}


***** Locals

local treat		B 	BM 	BC 	BMC
local takeup	BT 	BMT	BCT BMCT
local strata 	W1_male W1_space_ord W1_MW_score_total_abovemd
local Waves		W3 W4
local Miss_x 	W1_educ W1_digitspan W1_time_gen W1_risk_gen W1_cogstyle_system W1_motive_entrep ///
				W1_size W1_prof_est_w2 W1_labour_nonfam ///
				W1_formal_tax W1_powerout_wk W1_loan_amt W1_space_own W1_assets_fridges W1_assets_otherfirm ///
				W1_vat_nextyr W1_loan_nextyr W1_asp12_shop_z /*W1_asp_shop_z*/
local Compl_y	mov_attend_any ast_1_accept_any ast_2_accept_any
local Compl_x	W1_MW_M_score_total W1_MW_B_score W1_MW_R_score_total W1_MW_F_score_total ///
				/*W1_size W1_labour_total*/ W1_prof_est_w2 W1_educ W1_digitspan W1_time_gen W1_risk_gen W1_cogstyle_system W1_motive_entrep W1_asp12_shop_z




***** Attrition analysis


*** Transformations


* Winsorisations

foreach x in	`Miss_x' `Compl_x' {
				if regexm("`x'", "_w1") local win1 `win1' `x'
				if regexm("`x'", "_w2") local win2 `win2' `x'
				if regexm("`x'", "_w5") local win5 `win5' `x'
}


foreach w in 			1 2 5 {

	foreach x in		`win`w'' {

		//foreach wave in	W1 `Waves' {
					
						cap drop `x'
						
						local var = subinstr("`x'","_w`w'","",.)
						gen `x' = `var'
						
						local v = 100 - `w'
						winsor2 `x', cuts(`w' `v') replace
						
						local label_`x': var label `var'
						label var `x'	"`label_`x'' (win `w' %)"
		//}
	}
}


* IHS

foreach x in 	`Miss_x' `Compl_x' {
				if regexm("`x'", "_ihs") local ihs `ihs' `x'
}


foreach x in `ihs' {

	//foreach wave in	W1 `Waves' {

					cap drop `x'
					
					local var = subinstr("`x'","_ihs","",.)
					gen `x' 	= ln(`var' + sqrt((`var'*`var') + 1))
					
					local label_`x': var label `var'
					label var `x'	"`label_`x'' (IHS Transformation)"
	//}
}


*** Balance on baseline correlates

* Dummies
foreach w in W3 W4 {
	gen Sample_`w'				= (`w'_finished==1)
	lab var Sample_`w'			"Business Part of `w'"
	gen Sample_`w'_closed		= (`w'_closed==1)
	lab var Sample_`w'_closed	"Business Closed at `w'"
	gen Sample_`w'_refused		= (`w'_refused==1)
	lab var Sample_`w'_refused	"Business Refused at `w'"
}

* Estimation
est drop _all
local i = 1

foreach wave in `Waves' {

	//foreach t in `treat' {

		foreach x in `Miss_x' {

			areg Sample_`wave' `x', robust absorb(W1_village)
			* Storing Estimates
			est sto attrit_cov_`i'
			estadd ysumm
			* Storing Control Group Stats
			sum `x' if Sample_`wave'==1
			estadd scalar mean = r(mean)
		
			local ++i
			
		}
		
		* Storing Estimates
		areg Sample_`wave' `Miss_x', robust absorb(W1_village)
		est sto attrit_cov_`i'
		estadd ysumm
		* Performing F-test
		test `Miss_x'
		estadd scalar f_Miss_x = r(p)
		
		local ++i

	//}

}

* Output
capture erase "csv\phdrev\attrit_cov.csv"
#delimit ;
esttab attrit_cov_* using "csv\phdrev\attrit_cov.csv", label replace modelwidth(16) varwidth(50) depvar legend
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01)
	stats(r2 N mean sd f_Miss_x, fmt(%9.3f %9.0g %9.3f %9.3f %9.3f)
	labels("R-squared" "N" "Mean of Dependent Variable in Control Group" "F-test (p-value): All Cov = 0"))
	title("Balance of attrition on baseline covariates at endline 1 (W3) and endline 2 (W4)") keep() ;
#delimit cr




***** Compliance analysis


*** Balance on baseline correlates

* Estimation
est drop _all
local i = 1

foreach y in `treat' {

	* Restricted sample
	preserve
	keep if `y'==1

	foreach x in `Compl_x' {

		areg `y'T `x', robust absorb(W1_village)
		* Storing Estimates
		est sto compl_cov_`i'
		estadd ysumm
		* Storing Control Group Stats
		sum `x' if `y'==1
		estadd scalar mean = r(mean)
		
		local ++i	
	}
	
	areg `y'T `Compl_x', robust absorb(W1_village)
	* Storing Estimates
	est sto compl_cov_`i'
	estadd ysumm
	* F-test
	test `Compl_x'
	estadd scalar f_Compl_x = r(p)
		
	local ++i
	
	* Full sample from here on
	restore
	
}


* Output
capture erase "csv\phdrev\compl_cov.csv"
#delimit ;
esttab compl_cov_* using "csv\phdrev\compl_cov.csv", label replace modelwidth(16) varwidth(50) depvar legend
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01)
	stats(r2 N f_Compl_x, fmt(%9.3f %9.0g %9.3f)
	labels("R-squared" "N" "Mean of Dependent Variable in Control Group" "F-test (p-value): All Cov = 0"))
	title("Balance of compliance on baseline covariates") keep() ;
#delimit cr



/*
***** Treatment on the Treated


*** Locals

* Core business practices (returns to adoption information)
local marketingCore			Mcore MWM4_askcustomquit discount prods_new_1 MWM3_askcustomprod MWM6_attrcustomdisc    
local marketingOther		Mother MWM2_visitcompetprod compsales_compet MWM5_asksupplprod MWM7_advert 
local recordKeepingCore		Rcore MWR1_recwritten MWR8_recloan rec_accreccustom_TC separatefin MWR2_recpurchsale rec_ledger startrec_lastyr rec_sales rec_weekly rec_stockup rec_pricesuppliers  rec_accpayloan profcalc_any MWR5_costprods profcalc_any_wk      
local recordKeepingOther	Rother MWR3_recliquid MWR4_recsalesprods MWR6_profprods MWR7_recexpensemth MWF4_expensenextyr MWF5_proflossyr MWF8_incexpenseyr  
local decisions				DAGG discuss_any jointdec_any 
local stockup				SAGG stockup_comp dispose_wk_propsales inventory_change_prof rec_stockup MWB1_negosupplprice MWB2_compsupplprod 
local planning				PAGG MWF1_finperform MWF2_settargetyr MWF3_comptargetmth
local mainPract				Rcore Mcore DAGG SAGG PAGG

* Business practices in past and next 12 months
//local Past12				cutcosts_lastyr changesupplier_lastyr prodquality_lastyr newbrand_lastyr newbranch_lastyr delegate_lastyr bisplan_lastyr startrec_lastyr loan_lastyr coopcompet_lastyr vat_lastyr
//local Next12				cutcosts_nextyr changesupplier_nextyr prodquality_nextyr newbrand_nextyr newbranch_nextyr delegate_nextyr bisplan_nextyr startrec_nextyr loan_nextyr coopcompet_nextyr vat_nextyr
				
* Business performance
local profits				prof_est_w1 prof_est_w2 prof_est_w5 prof_est_ihs
local sales					sales_lastmth_w1 sales_lastmth_w2 sales_lastmth_w5 sales_lastmth_ln    
local expenses				expense_total_w1 expense_total_w2 expense_total_w5 expense_total_ln 
local size					size_w1 labour_total_w1 labour_nonfam_w1 labour_fam labour_nonfam size /*labour_ft labour_pt*/   
local customers				custom_total_w1 custom_loyal custom_general /*custom_avgpurch */
local credit				credit_TC loan_applied loan_outstanding loan_amt_ln    
local indivExpenses			expense_stockup_w1 expense_wage_w1 expense_rent_w1 ///
							expense_electric_w1 expense_transport_w1 expense_other_w1
							/*expense_tax_w1 expense_phone_w1 expense_advert_w1
							expense_preman_w1 expense_police_w1*/
local mainPerf				prof_est_w5 prof_est_ihs sales_lastmth_w5 sales_lastmth_ln size_w1 labour_total_w1 labour_nonfam_w1 custom_total_w1  

/* Aspirations
local asp12				asp12_size_w1 asp12_employee_w1  asp12_customer_w1 asp12_sales_ln /*asp12_sales_w1*/
local asp				asp_size_w1 asp_employee_w1  asp_customer_w1
local aspgap12			aspgap12_size_w1 aspgap12_employee_w1 aspgap12_customer_w1 aspgap12_sales_w1
local aspgap			aspgap_size_w1 aspgap_employee_w1 aspgap_customer_w1
local aspdiff			sizediff sizediff_w1 employeediff employeediff_w1 customerdiff customerdiff_w1
local aspfail			imagine_fail asp_yrs_fail
local psych				asp_import asp_prob asp_seff asp_loc
*/

* Outcomes for TE estimation
local dims				profits sales mainPract 
						/* expenses size customers credit*/
						/*marketingCore recordKeepingCore decisions stockup planning */

						
* HTE Variables
local hte		asp12_shop_z asp_shop_z

* Business Performance
local perform	prof_est prof_est_w1 prof_est_w2 ///
				sales_lastmth sales_lastmth_w1 sales_lastmth_w2

* Business Aspirations
local bisasp	asp12_shop_z /*asp12_shop_z_w1*/ asp12_sales asp12_sales_w1 ///
				asp12_size /*asp12_size_w1*/ asp12_employee /*asp12_employee_w1*/ ///
				asp12_customer /*asp12_customer_w1*/ ///
				asp_shop_z /*asp_shop_z_w1*/ ///
				asp_size /*asp_size_w1*/ asp_employee /*asp_employee_w1*/ ///
				asp_customer /*asp_customer_w1*/ //asp_yrs

* Placebos
local placebo	asp_cse asp12_sales_cse asp12_shop_z_cse ///	
				asp_prob asp12_sales_prob asp12_shop_z_prob //asp_loc asp_seff asp_prob
				//asp_loc asp12_sales_loc asp12_shop_z_loc ///
				//asp_seff asp12_sales_seff asp12_shop_z_seff ///
				//asp_cse asp12_sales_cse asp12_shop_z_cse					
						
						
						
*** Transformations


* Winsorisations

local win1
local win2
local win5

foreach x in	`mainPerf' `perform' `bisasp' /*`expenses' `size' `customers' `credit' `indivExpenses'*/ {
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


* IHS/Log

foreach x in 	`mainPerf' `perform' `bisasp' {
				if regexm("`x'", "_ihs") local ihs `ihs' `x'
				if regexm("`x'", "_ln") local ln `ln' `x'
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
						
foreach x in `ln' {

	foreach wave in	W1 `Waves' {

					cap drop `wave'_`x'
					
					local var = subinstr("`x'","_ln","",.)
					gen `wave'_`x' 	= ln(`wave'_`var')
					
					local label_`x': var label `wave'_`var'
					label var `wave'_`x'	"`label_`x'' (Log Transformation)"
	}
}					
						
						
						
*** Endogenous variables for TOT estimation (not used in final doc)

* Binary score for disposal of products
foreach w in	W1 W3 {
				egen `w'_dispose_wk_md = median(`w'_dispose_wk)
				gen `w'_dispose_wk_AM = (`w'_dispose_wk>`w'_dispose_wk_md) if !missing(`w'_dispose_wk)
}

* Composite scores among treated practices (endogenous variable)
foreach w in W1 `Waves' {

	cap confirm variable 	`w'_dispose_wk_less `w'_MWR5_costprods `w'_rec_accreccustom_TC ///
							`w'_rec_accreccustom_TC `w'_rec_ledger `w'_rec_sales `w'_rec_weekly ///
							`w'_rec_stockup `w'_rec_pricesuppliers `w'_rec_accpayloan `w'_rec_stockup ///
							`w'_profcalc_any `w'_profcalc_any_wk
	
		if !_rc {


			* Full score among treated practices for W1 and W3
			egen `w'_pract_comp =	rowtotal(`w'_MWM3_askcustomprod `w'_MWM4_askcustomquit ///
									`w'_MWM6_attrcustomdisc `w'_discount `w'_prods_new_1 ///
									`w'_MWR1_recwritten `w'_MWR2_recpurchsale ///
									`w'_MWR8_recloan `w'_startrec_lastyr `w'_separatefin 
									`w'_discuss_any `w'_jointdec_any ///
									`w'_MWB1_negosupplprice `w'_MWB2_compsupplprod ///
									`w'_stockup_comp `w'_inventory_change_prof ///
									`w'_MWF1_finperform `w'_MWF2_settargetyr `w'_MWF3_comptargetmth ///
									`w'_rec_accreccustom_TC `w'_rec_ledger `w'_rec_sales `w'_rec_weekly ///
									`w'_rec_stockup `w'_rec_pricesuppliers `w'_rec_accpayloan `w'_rec_stockup ///
									`w'_profcalc_any `w'_profcalc_any_wk `w'_dispose_wk_AM `w'_MWR5_costprods)
				/*}*/
		}
		
		* Restricted set for shortened W4
		else {
		
			egen `w'_pract_comp =	rowtotal(`w'_MWM3_askcustomprod `w'_MWM4_askcustomquit ///
										`w'_MWM6_attrcustomdisc `w'_discount `w'_prods_new_1 ///
										`w'_MWR1_recwritten `w'_MWR2_recpurchsale					///
										`w'_MWR8_recloan `w'_startrec_lastyr `w'_separatefin ///
										`w'_discuss_any `w'_jointdec_any ///
										`w'_MWB1_negosupplprice `w'_MWB2_compsupplprod ///
										`w'_stockup_comp `w'_inventory_change_prof ///
										`w'_MWF1_finperform `w'_MWF2_settargetyr `w'_MWF3_comptargetmth)
		}
}

* Composite score of change between waves
gen W3_pract_change = W3_pract_comp - W1_pract_comp
gen W4_pract_change = W4_pract_comp - W1_pract_comp



/*** Estimation of TOTs
est drop _all
local i = 1
local m = 1

foreach w in W3 W4 {

	foreach this_dim in `dims' {
	
		foreach var in ``this_dim'' {

			* Generating Dummies for missing BL vars 
			cap drop W1_`var'_m 
			cap drop W1b_`var'
		
			gen W1_`var'_m = (W1_`var'==.) if W3_`var'!=. 
			gen W1b_`var' = W1_`var'
			replace W1b_`var'= 5 if W1_`var'_m == 1
			
			*TOT - Saturated With BL Dep Variable and Strata Controls
			display "TOT: SATURATED, BL DEP VAR, CONTROLS"
			xi: ivreg2 `w'_`var' (`takeup' = `treat') W1b_`var' W1_`var'_m `strata' i.W1_village if `w'_finished==1, robust
			est sto T`m'_`w'_`this_dim'_TOT_`i'
			estadd ysumm
			test BT-BMT=0
			estadd scalar f1 = r(p)
			test BT-BCT=0
			estadd scalar f2 = r(p)
			test BT-BMCT=0
			estadd scalar f3 = r(p)
			test BMT-BCT=0
			estadd scalar f4 = r(p)
			test BMT+BCT=BMCT
			local sign = sign(_b[BMCT]-_b[BMT]-_b[BCT])
			estadd scalar f5 = ttail(r(df_r),`sign'*sqrt(r(F)))
			sum `w'_`var' if control==1
			estadd scalar mean = r(mean)
			estadd scalar sd = r(sd)
			local ++i
		}
	
		*   csv output
		capture erase "csv\phdrev\T`m'_`w'_`this_dim'_TOT.csv"

		#delimit ;
			esttab T`m'_`w'_`this_dim'_TOT_* using "csv\phdrev\T`m'_`w'_`this_dim'_TOT.csv", label replace modelwidth(16) varwidth(50) depvar legend 
			cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
			stats(r2 N mean sd f1 f2 f3 f4 f5, fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) labels("R-squared" "N" "Dependent Variable Mean in Control Group" "Dependent Variable SD in Control Group" "F-test (p-value): Book = Book & Movie" "F-test (p-value): Book = Book & Assistance" "F-test (p-value): Book = Book & Movie & Assistance" "F-test (p-value): Book & Movie = Book & Assistance" "F-test (p-value): B & M + B & A > All Three"))
			title("`e(title)' of treatment effects on `this_dim'") keep(B*);
		#delimit cr

		local ++m
		est drop _all
	}
}

*/



***** HTE (Paper 1)


*** Variables
egen W1_prof_est_md = median(W1_prof_est)
gen AMprof = (W1_prof_est>W1_prof_est_md) if !missing(W1_prof_est)
gen BMprof = 1 - AMprof

egen W1_sales_lastmth_md = median(W1_sales_lastmth)
gen AMsales = (W1_sales_lastmth>W1_sales_lastmth_md) if !missing(W1_sales_lastmth) 
gen BMsales = 1 - AMsales

gen BMscore = 1 - W1_MW_score_total_abovemd
gen AMscore = 1 - BMscore

foreach x in prof sales score {
	foreach t in B BM BC BMC {

		gen `t'_BM`x' =`t'*BM`x'
		gen `t'_AM`x' =`t'*AM`x'

	}
}


local hetero 		/*score*/ prof BMsales

local hetero_AMprof	B_AMprof BM_AMprof BC_AMprof BMC_AMprof 
local hetero_BMprof	B_BMprof BM_BMprof BC_BMprof BMC_BMprof 

local hetero_AMsales	B_AMsales BM_AMsales BC_AMsales BMC_AMsales 
local hetero_BMsales	B_BMsales BM_BMsales BC_BMsales BMC_BMsales


set more off 


local i = 1
*local m = 7

foreach w in W3 W4 {

	foreach this_dim in `dims' {
	
		est drop _all
		
		foreach v in `hetero' {
		
			foreach var in ``this_dim'' {

				* Generating Dummies for missing BL vars 
				cap drop W1_`var'_m 
				cap drop W1b_`var'
				gen W1_`var'_m = (W1_`var'==.) if W3_`var'!=. 
				gen W1b_`var' = W1_`var'
				replace W1b_`var'= 5 if W1_`var'_m == 1
		
				*ITT - Saturated With BL Dep Variable and Strata Controls
				areg `w'_`var' `treat' `hetero_BM`v'' W1b_`var' W1_`var'_m `strata' if `w'_finished==1, absorb(W1_village) robust
				est sto T`m'_`w'_`this_dim'_HTE_`i'
				estadd ysumm
				test B + B_BM`v'=0
				estadd scalar f1 = r(p)
				test BM + BM_BM`v'=0
				estadd scalar f2 = r(p)
				test BC + BC_BM`v'=0
				estadd scalar f3 = r(p)
				test BMC + BMC_BM`v'=0
				estadd scalar f4 = r(p)
				foreach x in AM BM {
				
				sum `w'_`var' if control==1 & `x'`v'==1
					estadd scalar `x'_mean = r(mean)
					estadd scalar `x'_sd = r(sd)
				}
			
				local ++i
		
			}

		}



	capture erase "csv\phdrev\T`m'_`w'_`this_dim'_prof_HTE.csv"

	* output
	#delimit ;
		esttab T`m'_`w'_`this_dim'_HTE_* using "csv\phdrev\T`m'_`w'_`this_dim'_prof_HTE.csv", label replace modelwidth(16) varwidth(50) depvar legend 
		cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
		stats(r2 N AM_mean AM_sd BM_mean BM_sd f1 f2 f3 f4, fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) labels("R-squared" "N" "Dependent Variable Mean in Control Group" "Dependent Variable SD in Control Group" "F-test (p-value): Book + Interaction" "F-test (p-value): Book & Movie + Interaction" "F-test (p-value): Book & Assistaince + Interaction" "F-test (p-value): All Three + Interaction"))
		title("Heterogeneity in treatment effects on `this_dim' by `hetero' at First Endline (W3) and Second Endline (W4)") keep(B*);
	#delimit cr

	local ++m

	}
}



/***** HTE (Paper 3)


* Outcomes for TE estimation
local dims				perform bisasp /*placebo*/



*** Variables

foreach x in	asp12 asp {
				gen AM`x'=W1_`x'_shop_z_AM
				gen BM`x'=1-AM`x'

}

egen W1_asp_cse_md = median(W1_asp_cse)
gen AMcse = (W1_asp_cse>W1_asp_cse_md) if !missing(W1_asp_cse)			/* TEST AGAIn */
gen BMcse = 1 - AMcse

egen W1_asp12_sales_cse_md = median(W1_asp12_sales_cse)
gen AMasp12salescse = (W1_asp12_sales_cse>W1_asp12_sales_cse_md) if !missing(W1_asp12_sales_cse)   /* TEST AGAIn */
gen BMasp12salescse = 1 - AMasp12salescse

egen W1_asp12_shop_z_cse_md = median(W1_asp12_shop_z_cse)
gen AMasp12cse = (W1_asp12_shop_z_cse>W1_asp12_shop_z_cse_md) if !missing(W1_asp12_shop_z_cse_md)   /* TEST AGAIn*/
gen BMasp12cse = 1 - AMasp12cse

egen W1_asp_seff_md = median(W1_asp_seff)
gen AMseff = (W1_asp_seff>W1_asp_seff_md) if !missing(W1_asp_seff)
gen BMseff = 1 - AMseff

egen W1_asp12_sales_seff_md = median(W1_asp12_sales_seff)
gen AMasp12salesseff = (W1_asp12_sales_seff>W1_asp12_sales_seff_md) if !missing(W1_asp12_sales_seff)
gen BMasp12salesseff = 1 - AMasp12salesseff

egen W1_asp12_shop_z_seff_md = median(W1_asp12_shop_z_seff)
gen AMasp12seff = (W1_asp12_shop_z_seff>W1_asp12_shop_z_seff_md) if !missing(W1_asp12_shop_z_seff)
gen BMasp12seff = 1 - AMasp12seff

egen W1_asp_loc_md = median(W1_asp_loc)
gen AMloc = (W1_asp_loc>W1_asp_loc_md) if !missing(W1_asp_loc)
gen BMloc = 1 - AMloc

egen W1_asp12_sales_loc_md = median(W1_asp12_sales_loc)
gen AMasp12salesloc = (W1_asp12_sales_loc>W1_asp12_sales_loc_md) if !missing(W1_asp12_sales_loc)
gen BMasp12salesloc = 1 - AMasp12salesloc

egen W1_asp12_shop_z_loc_md = median(W1_asp12_shop_z_loc)
gen AMasp12loc = (W1_asp12_shop_z_loc>W1_asp12_shop_z_loc_md) if !missing(W1_asp12_shop_z_loc)
gen BMasp12loc = 1 - AMasp12loc

egen W1_asp_prob_md = median(W1_asp_prob)
gen AMprob = (W1_asp_prob>W1_asp_prob_md) if !missing(W1_asp_prob)
gen BMprob = 1 - AMprob

egen W1_asp12_sales_prob_md = median(W1_asp12_sales_prob)
gen AMasp12salesprob = (W1_asp12_sales_prob>W1_asp12_sales_prob_md) if !missing(W1_asp12_sales_prob)
gen BMasp12salesprob = 1 - AMasp12salesprob

egen W1_asp12_shop_z_prob_md = median(W1_asp12_shop_z_prob)
gen AMasp12prob = (W1_asp12_shop_z_prob>W1_asp12_shop_z_prob_md) if !missing(W1_asp12_shop_z_prob)
gen BMasp12prob = 1 - AMasp12prob


/*
foreach t in B BM BC BMC {

gen `t'_BMasp12=`t'*BMasp12
gen `t'_AMas12=`t'*AMasp12

gen `t'_BMasp=`t'*BMasp
gen `t'_AMasp=`t'*AMasp

gen `t'_BMcse=`t'*BMcse
gen `t'_AMcse=`t'*AMcse

gen `t'_BMasp12cse=`t'*BMasp12cse
gen `t'_AMasp12cse=`t'*AMasp12cse

gen `t'_BMasp12salescse=`t'*BMasp12salescse
gen `t'_AMasp12salescse=`t'*AMasp12salescse

gen `t'_BMloc=`t'*BMloc
gen `t'_AMloc=`t'*AMloc

gen `t'_BMasp12loc=`t'*BMasp12loc
gen `t'_AMasp12loc=`t'*AMasp12loc

gen `t'_BMasp12salesloc=`t'*BMasp12salesloc
gen `t'_AMasp12salesloc=`t'*AMasp12salesloc

gen `t'_BMseff=`t'*BMseff
gen `t'_AMseff=`t'*AMseff

gen `t'_BMasp12seff=`t'*BMasp12seff
gen `t'_AMasp12seff=`t'*AMasp12seff

gen `t'_BMasp12salesseff=`t'*BMasp12salesseff
gen `t'_AMasp12salesseff=`t'*AMasp12salesseff

gen `t'_BMprob=`t'*BMprob
gen `t'_AMprob=`t'*AMprob

}
*/


foreach x in 	asp12 asp ///
				cse asp12cse asp12salescse ///
				seff asp12seff asp12salesseff ///
				loc asp12loc asp12salesloc ///
				prob asp12prob asp12salesprob {

	* Interaction terms treat and heterogenous variables
	foreach t in	B BM BC BMC {

		gen `t'_BM`x'=`t'*BM`x'
		gen `t'_AM`x'=`t'*AM`x'

	}

* Locals with interaction terms for every heterogenous variable
local hetero_AM`x'	B_AM`x' BM_AM`x' BC_AM`x' BMC_AM`x' 
local hetero_BM`x'	B_BM`x' BM_BM`x' BC_BM`x' BMC_BM`x' 

}

* Heterogenous variables as selected for the analysis
local hetero 		/*BMasp12 BMasp BMcse BMloc BMseff*/ BMprob



local hetero_AMcse				B_AMcse BM_AMcse BC_AMcse BMC_AMcse 
local hetero_BMcse				B_BMcse BM_BMcse BC_BMcse BMC_BMcse 

local hetero_AMasp12cse			B_AMasp12cse BM_AMasp12cse BC_AMasp12cse BMC_AMasp12cse 
local hetero_BMasp12cse			B_BMasp12cse BM_BMasp12cse BC_BMasp12cse BMC_BMasp12cse

local hetero_AMasp12salescse	B_AMasp12salescse BM_AMasp12salescse BC_AMasp12salescse BMC_AMasp12salescse 
local hetero_BMasp12salescse	B_BMasp12salescse BM_BMasp12salescse BC_BMasp12salescse BMC_BMasp12salescse

local hetero_AMasp12seff		B_AMasp12seff BM_AMasp12seff BC_AMasp12seff BMC_AMasp12seff 
local hetero_BMasp12seff		B_BMasp12seff BM_BMasp12seff BC_BMasp12seff BMC_BMasp12seff

local hetero_AMasp12salesseff	B_AMasp12salesseff BM_AMasp12salesseff BC_AMasp12salesseff BMC_AMasp12salesseff 
local hetero_BMasp12salesseff	B_BMasp12salesseff BM_BMasp12salesseff BC_BMasp12salesseff BMC_BMasp12salesseff

local hetero_AMasp12loc			B_AMasp12loc BM_AMasp12loc BC_AMasp12loc BMC_AMasp12loc 
local hetero_BMasp12loc			B_BMasp12loc BM_BMasp12loc BC_BMasp12loc BMC_BMasp12loc

local hetero_AMasp12salesloc	B_AMasp12salesloc BM_AMasp12salesloc BC_AMasp12salesloc BMC_AMasp12salesloc 
local hetero_BMasp12salesloc	B_BMasp12salesloc BM_BMasp12salesloc BC_BMasp12salesloc BMC_BMasp12salesloc 


local hetero_AMprob				B_AMprob BM_AMprob BC_AMprob BMC_AMprob 
local hetero_BMprob				B_BMprob BM_BMprob BC_BMprob BMC_BMprob


set more off 


local i = 1
local m = 1

foreach w in W3 W4 {

	foreach this_dim in `dims' {
	
		est drop _all
		
		foreach v in `hetero' {
		
			foreach var in ``this_dim'' {

				* Generating Dummies for missing BL vars 
				cap drop W1_`var'_m 
				cap drop W1b_`var'
				gen W1_`var'_m = (W1_`var'==.) if W3_`var'!=. 
				gen W1b_`var' = W1_`var'
				replace W1b_`var'= 5 if W1_`var'_m == 1
		
				*ITT - Saturated With BL Dep Variable and Strata Controls
				areg `w'_`var' `treat' `hetero_`v'' W1b_`var' W1_`var'_m `strata' if `w'_finished==1, absorb(W1_village) robust
				est sto T`m'_`w'_`this_dim'_HTE_`i'
				estadd ysumm
				test B + B_`v'=0
				estadd scalar f1 = r(p)
				test BM + BM_`v'=0
				estadd scalar f2 = r(p)
				test BC + BC_`v'=0
				estadd scalar f3 = r(p)
				test BMC + BMC_`v'=0
				estadd scalar f4 = r(p)
				sum W3_`var' if control==1
				estadd scalar mean = r(mean)
				estadd scalar sd = r(sd)
			
				local ++i
		
			}
		}


	
	/*capture erase "csv\phdrev\T`m'_`w'_`this_dim'_asp_HTE.csv"

	* output
	#delimit ;
		esttab T`m'_`w'_`this_dim'_HTE_* using "csv\phdrev\T`m'_`w'_`this_dim'_aspfals_HTE.csv", label replace modelwidth(16) varwidth(50) depvar legend 
		cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
		stats(r2 N mean sd f1 f2 f3 f4, fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) labels("R-squared" "N" "Dependent Variable Mean in Control Group" "Dependent Variable SD in Control Group" "F-test (p-value): Book + Interaction" "F-test (p-value): Book & Movie + Interaction" "F-test (p-value): Book & Assistaince + Interaction" "F-test (p-value): All Three + Interaction"))
		title("Heterogeneity in treatment effects on `this_dim' by `hetero' at First Endline (W3) and Second Endline (W4)") keep(B*);
	#delimit cr*/

	local ++m

	}
}

*/

