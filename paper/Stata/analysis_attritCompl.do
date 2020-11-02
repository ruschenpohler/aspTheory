
********************************************************************************
************** 		RETAILERS INDONESIA PROJECT, 2016-2018 		****************
*																			
*				  	PhD corrections (L from P, Shocking Asps)
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




