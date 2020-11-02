
********************************************************************************
************** 					ASPIRATIONS				  		****************
*
*				            Main analysis do-file
*		
********************************************************************************


set matsize 11000
clear all
set more off

cd "C:\Users\wb240247\Dropbox\Indonesia Analysis\"
*cd "C:\Users\pdalton\Dropbox\Indonesia Analysis\"
*cd "D:\Dropbox\Dropbox\Indonesia Analysis\"

use "Data\Analysis_data.dta", clear
set more off

* Variable prep

foreach var in W3 W1 {
egen `var'_Mcore = rowmean(`var'_MWM4_askcustomquit `var'_discount `var'_prods_new_1 `var'_MWM3_askcustomprod `var'_MWM6_attrcustomdisc)
egen `var'_Mother	= rowmean(`var'_MWM2_visitcompetprod `var'_compsales_compet `var'_MWM5_asksupplprod `var'_MWM7_advert) 
egen `var'_Rcore = rowmean(`var'_MWR1_recwritten `var'_MWR8_recloan `var'_rec_accreccustom_TC `var'_separatefin `var'_MWR2_recpurchsale `var'_rec_ledger `var'_startrec_lastyr `var'_rec_sales `var'_rec_weekly `var'_rec_stockup `var'_rec_pricesuppliers `var'_rec_accpayloan `var'_profcalc_any `var'_MWR5_costprods `var'_profcalc_any_wk)
egen `var'_Rother	= rowmean(`var'_MWR3_recliquid `var'_MWR4_recsalesprods `var'_MWR6_profprods `var'_MWR7_recexpensemth `var'_MWF4_expensenextyr `var'_MWF5_proflossyr `var'_MWF8_incexpenseyr)
egen `var'_DAGG	= rowmean(`var'_discuss_any `var'_jointdec_any) 
egen `var'_PAGG = rowmean(`var'_MWF1_finperform `var'_MWF2_settargetyr `var'_MWF3_comptargetmth)
egen `var'_SAGG = rowmean(`var'_stockup_comp `var'_inventory_change_prof `var'_rec_stockup `var'_MWB1_negosupplprice `var'_MWB2_compsupplprod)
}


label var W3_Mcore "Aggregate Marketing Practices (Core)"
label var W3_MWM4_askcustomquit "Consulted with Former Customers"
label var W3_discount "Offered Discount to Loyal/Bulk Customers"
label var W3_prods_new_1 "Offered a New Product for Sale"
label var W3_compsales_compet "Compared Sales Performance with Competitors"

label var W3_Mother "Aggregate Marketing Practices (Other)"
label var W3_MWM2_visitcompetprod "Observed Products for Sale at Competing Business"
label var W3_MWM3_askcustomprod	"Elicited Customer Demand for New Products"
label var W3_MWM5_asksupplprod "Asked Suppliers about High Demand Products"
label var W3_MWM6_attrcustomdisc "Introduced Special Sales Offers"
label var W3_MWM7_advert "Advertised the Business"

label var W3_Rcore "Aggregate Record Keeping Practices (Core)"
label var W3_MWR1_recwritten "Kept Written Business Records"
label var W3_MWR5_costprods	"Calculated Cost of Sales for Main Products"
label var W3_MWR8_recloan "Have Records Needed to Obtain Business Loan"
label var W3_startrec_lastyr "Itemized Business Revenues and Expenses"
label var W3_rec_ledger "Kept Formal Business Ledger"
label var W3_rec_weekly "Updated Records At Least Once a Week"
label var W3_rec_stockup "Tracked Purchase of Stocks"
label var W3_rec_pricesuppliers "Tracked Prices of Different Suppliers"
label var W3_rec_accreccustom_TC "Recorded Credit to Customers"
label var W3_rec_accpayloan "Tracked Loan Payments Due"
label var W3_profcalc_any "Calculated Business Profits"
label var W3_profcalc_any_wk "Updated Business Profits At Least Once a Week"
label var W3_separatefin "Separated Business and Household Finances"
label var W3_rec_sales "Tracked Product Sales"

label var W3_Rother "Aggregate Record Keeping Practices (Other)"
label var W3_MWR2_recpurchsale	"Recorded Every Purchase and Sale"
label var W3_MWR3_recliquid	"Estimated Cash on Hand"
label var W3_MWR4_recsalesprods "Compared Trends in Sales Across Products"
label var W3_MWR6_profprods	"Identified Profit Contribution of Best Products"
label var W3_MWR7_recexpensemth	"Kept Monthly Business Budget"
label var W3_MWB1_negosupplprice "Negotiated Lower Prices with a Supplier"
label var W3_MWB2_compsupplprod "Compare Product Prices and Quality Across Suppliers"

label var W3_DAGG "Aggregate Discussion Practices"
label var W3_discuss_any "Discussed Business Matters with Others"
label var W3_jointdec_any "Made Joint Decisions on Business Matters"

label var W3_PAGG "Aggregate Planning Practices"
label var W3_MWF1_finperform "Reviewed Financial Performance to Identify Areas of Improvement"
label var W3_MWF2_settargetyr "Set Sales Target"
label var W3_MWF3_comptargetmth "Compared Target vs. Actual Monthly Sales"

label var W3_MWF4_expensenextyr "Anticipated Budget for Upcoming Business Costs"
label var W3_MWF5_proflossyr "Kept Annual Profit and Loss Statement"
label var W3_MWF8_incexpenseyr "Kept Annual Income and Expenses Statement"

label var W3_SAGG "Aggregate Stock up Practices"
label var W3_stockup_comp "Top Selling Products Always in Stock (Yes/No)"
label var W3_dispose_wk "Stock Wastage Each Week (Yes/No)"
label var W3_dispose_wk_val "Stock Wastage Each Week (Value in USD)"
label var W3_dispose_wk_propsales "Stock Wastage Each Week (Proportion of Sales)"
label var W3_inventory_change_demand "Adjusted Stock Based on Consumer Demand (Yes/No)"
label var W3_inventory_change_prof "Adjusted Stock Based on Product Profitability (Yes/No)"



foreach var in W1_sales_lastmth W3_sales_lastmth {
winsor2 `var', cuts(1 99) suffix(_w1)
winsor2 `var', cuts(2.5 97.5) suffix(_w25)
winsor2 `var', cuts(5 95) suffix(_w5)
g `var'_ln = ln(`var')
}

label var W3_sales_lastmth_w1 "Sales Last Month (win 1)%" 
label var W3_sales_lastmth_w25 "Sales Last Month (win 2.5%)" 
label var W3_sales_lastmth_w5 "Sales Last Month (win 5%)" 
label var W3_sales_lastmth_ln "Sales Last Month (Log)"


foreach var in W1_prof_lastmth W3_prof_lastmth W3_prof_calc W1_prof_calc W3_prof_est W1_prof_est W3_prof_comp3 W1_prof_comp3  {
winsor2 `var', cuts(1 99) suffix(_w1)
winsor2 `var', cuts(2.5 97.5) suffix(_w25)
winsor2 `var', cuts(5 95) suffix(_w5)
g `var'_ihs = ln(`var' + sqrt((`var'*`var') + 1))
}

label var W3_prof_est_w1 "Estimated Profits Last Month (win 1%)" 
label var W3_prof_est_w25 "Estimated Profits Last Month (win 2.5%)" 
label var W3_prof_est_w5 "Estimated Profits Last Month (win 5%)" 
label var W3_prof_est_ihs "Estimated Profits Last Month (IHS Transformation)" 
  

foreach var in expense_total expense_stockup expense_wage expense_rent expense_electric expense_transport expense_tax expense_phone expense_advert expense_preman expense_police expense_other {
winsor2 W1_`var', cuts(1 99) suffix(_w1)
winsor2 W3_`var', cuts(1 99) suffix(_w1)
winsor2 W1_`var', cuts(2.5 97.5) suffix(_w25)
winsor2 W3_`var', cuts(2.5 97.5) suffix(_w25)
winsor2 W1_`var', cuts(5 95) suffix(_w5)
winsor2 W3_`var', cuts(5 95) suffix(_w5)
g W1_`var'_ihs = ln(W1_`var' + sqrt((W1_`var'*W1_`var') + 1))
g W3_`var'_ihs = ln(W3_`var' + sqrt((W3_`var'*W3_`var') + 1))
g W1_`var'_ln = ln(W1_`var')
g W3_`var'_ln = ln(W3_`var')
}

label var W3_expense_total_w1 "Total Expenses Last Month (win 1%)" 
label var W3_expense_total_w25 "Total Expenses Last Month (win 2.5%)" 
label var W3_expense_total_w5 "Total Expenses Last Month (win 5%)" 
label var W3_expense_total_ln "Total Expenses Last Month (Log)" 
label var W3_expense_stockup_w25 "Stock Up Expenses Last Month (win 2.5%)" 
label var W3_expense_rent_w25 "Rent Expenses Last Month (win 2.5%)" 
label var W3_expense_electric_w25 "Electric Expenses Last Month (win 2.5%)" 
label var W3_expense_transport_w25 "Transport Expenses Last Month (win 2.5%)" 
label var W3_expense_phone_w25 "Phone Expenses Last Month (win 2.5%)" 
label var W3_expense_other_w25 "Other Expenses Last Month (win 2.5%)" 

label var W3_labour_total "Total Employees" 
label var W3_labour_fam "Total Family Employees"
label var W3_labour_nonfam "Total Non-Family Employees" 
label var W3_size "Shop Size" 

label var W3_MW_score_total "MW Aggregate Score" 
label var W3_MW_M_score_total "MW Marketing Subscore"
label var W3_MW_B_score_total "MW Stocking Up Subscore"
label var W3_MW_R_score_total "MW Record Keeping Subscore"
label var W3_MW_F_score_total "MW Financial Planning Subscore"

label var W3_credit_TC "Offered Credit or Delayed Payments to Customers" 
label var W3_loan_applied "Applied for Business Loan" 
label var W3_loan_outstanding "Obtained Business Loan" 

gen W3_loan_amt_ln=ln(W3_loan_amt+1)
gen W1_loan_amt_ln=ln(W1_loan_amt+1)
label var W3_loan_amt_ln "Log of Outstanding Loan Amount"

*Interactions for hetero effects
gen BMscore=1-W1_MW_score_total_abovemd
gen female=1-W1_male
gen AMasp=W1_asp12_AM
gen BMasp=1-AMasp
gen AMasp2=W1_asp_AM
gen BMasp2=1-AMasp2
gen AMaspsales=W1_asp12_sales_AM 
gen ifail=W1_imagine_fail

foreach var in book_only book_mov book_ast book_mov_ast {
gen `var'_male=`var'*W1_male
gen `var'_female=`var'*female
gen `var'_BMscore=`var'*BMscore
gen `var'_AMscore=`var'*W1_MW_score_total_abovemd
gen `var'_AMasp=`var'*AMasp
gen `var'_AMasp2=`var'*AMasp2
gen `var'_AMaspsales=`var'*AMaspsales
gen `var'_ifail=`var'*ifail
gen `var'_BMasp=`var'*BMasp
gen `var'_BMasp2=`var'*BMasp2
}

*Aspirations 

label var W1_newbranch_nextyr "Plans to Expand Business in Next 12 Months" 
label var W1_bisplan_nextyr "Plans to Develop Business Plan in Next 12 Months" 
label var W1_startrec_nextyr "Plans to Start/Improve Record Keeping in Next 12 Months"

foreach var in size employee customer {
gen W1_`var'diff = W1_asp_`var' - W1_asp12_`var'
gen W3_`var'diff = W3_asp_`var' - W3_asp12_`var'
}

foreach var in size labour_total custom_total sizediff employeediff customerdiff asp18_prof asp_minprof aspgap18_prof asp12_size asp12_employee asp12_customer asp12_sales asp_size asp_employee asp_customer aspgap12_size aspgap12_employee aspgap12_customer aspgap12_sales aspgap_size aspgap_employee aspgap_customer {
winsor2 W1_`var', cuts(1 99) suffix(_w1)
winsor2 W3_`var', cuts(1 99) suffix(_w1)
winsor2 W1_`var', cuts(2.5 97.5) suffix(_w25)
winsor2 W3_`var', cuts(2.5 97.5) suffix(_w25)
winsor2 W1_`var', cuts(5 95) suffix(_w5)
winsor2 W3_`var', cuts(5 95) suffix(_w5)
g W1_`var'_ihs = ln(W1_`var' + sqrt((W1_`var'*W1_`var') + 1))
g W3_`var'_ihs = ln(W3_`var' + sqrt((W3_`var'*W3_`var') + 1))
g W1_`var'_ln = ln(W1_`var')
g W3_`var'_ln = ln(W3_`var')
}

label var W3_custom_total_w1 "Total Customers"

*labels
label var W1_asp12_shop_z "Aggregate Short-Term Aspirations"
label var W1_asp_shop_z "Aggregate Long-Term Aspirations"
label var W1_asp12_size_z "Short-Term Shop Size Aspirations (Zscore)"
label var W1_asp12_employee_z "Short-Term Employee Aspirations (Zscore)"
label var W1_asp12_customer_z "Short-Term Customer Aspirations (Zscore)"
label var W1_asp12_sales_z "Short-Term Sales Aspirations (Zscore)"


* Missing value dummies
foreach var in	W1_age_manager W1_asp12_sales_z {
				gen `var'_dum = (`var'==.)
				
				gen `var'_m = 5 if `var'==.
				replace `var'_m = `var' if `var'!=.
				_crcslbl `var'_m `var'
}

label var W1_asp12_sales_z_m "Short-Term Sales Aspirations (Zscore)"


* Aspirations achievement

gen W3_sales = W3_sales_nday
gen W3_employee = W3_labour_total
gen W3_customer = W3_custom_total

foreach x in sales size customer employee {

gen W3_asp_achieve_`x' = (W3_`x' - W1_asp12_`x')/W1_asp12_`x'

*Realistic aspirations (within 10% margin)
gen W1_realistic_asp_`x'= (W3_asp_achieve_`x'>=-0.1) & (W3_asp_achieve_`x'<=0.1) 
replace W1_realistic_asp_`x'=. if W3_asp_achieve_`x'==. 
label var W1_realistic_asp_`x' "Business had realistic aspirations for `x'"

*Optimistic aspirations 
gen W1_optimistic_asp_`x'= (W3_asp_achieve_`x'<-0.1) 
replace W1_optimistic_asp_`x'=. if W3_asp_achieve_`x'==. 
label var W1_optimistic_asp_`x' "Business had optimistic aspirations for `x'"

*Pessimistic aspirations 
gen W1_pessimistic_asp_`x'= (W3_asp_achieve_`x'>0.1) 
replace W1_pessimistic_asp_`x'=. if W3_asp_achieve_`x'==. 
label var W1_pessimistic_asp_`x' "Business had pessimistic aspirations for `x'"

}


* Aspirations Growth
gen W3_asp12_growth_sales = W3_asp12_sales_ln - W1_asp12_sales_ln
gen W3_asp12_growth_size = W3_asp12_size_ln - W1_asp12_size_ln
gen W3_asp12_growth_customer = W3_asp12_customer_ln - W1_asp12_customer_ln
gen W3_asp12_growth_employee = W3_asp12_employee_ln - W1_asp12_employee_ln

label var W3_asp12_growth_sales "Growth in sales aspirations" 
label var W3_asp12_growth_size "Growth in size aspirations" 
label var W3_asp12_growth_customer "Growth in customer aspirations" 
label var W3_asp12_growth_employee "Growth in employee aspirations" 



***** Locals *******************************************************************


* Controls
local controls 				W1_formal_tax W1_age_firm W1_male W1_age_manager_m W1_age_manager_dum W1_educ W1_time_comp W1_risk_comp W1_digitspan_total W1_cogstyle_rel_perc W1_MW_M_score_total W1_MW_B_score_total W1_MW_R_score_total W1_MW_F_score_total  
							
							/*W1_labour_total W1_custom_total*/ 
							  
*W1_Mcore W1_Rcore W1_DAGG W1_SAGG W1_PAGG 


* Core business practices (returns to adoption information)
*local MWPractices			MW_score_total MW_M_score_total MW_B_score_total MW_R_score_total MW_F_score_total
local Marketingcore			Mcore MWM4_askcustomquit discount prods_new_1 MWM3_askcustomprod MWM6_attrcustomdisc    
local Marketingother		Mother MWM2_visitcompetprod compsales_compet MWM5_asksupplprod MWM7_advert 

local RecordKeepingcore		Rcore MWR1_recwritten MWR8_recloan rec_accreccustom_TC separatefin MWR2_recpurchsale rec_ledger startrec_lastyr rec_sales rec_weekly rec_stockup rec_pricesuppliers  rec_accpayloan profcalc_any MWR5_costprods profcalc_any_wk      
local RecordKeepingother	Rother MWR3_recliquid MWR4_recsalesprods MWR6_profprods MWR7_recexpensemth MWF4_expensenextyr MWF5_proflossyr MWF8_incexpenseyr  

local Decisions				DAGG discuss_any jointdec_any 

local Stockup				SAGG stockup_comp dispose_wk_propsales inventory_change_prof rec_stockup MWB1_negosupplprice MWB2_compsupplprod 

local Planning				PAGG MWF1_finperform MWF2_settargetyr MWF3_comptargetmth

*local mainscores			Mcore Rcore DAGG SAGG PAGG
local mainscores			MW_score_total MW_M_score_total MW_B_score_total MW_R_score_total MW_F_score_total


* Business practices in past and next 12 months
local Past12				cutcosts_lastyr changesupplier_lastyr prodquality_lastyr newbrand_lastyr newbranch_lastyr delegate_lastyr bisplan_lastyr startrec_lastyr loan_lastyr coopcompet_lastyr vat_lastyr
local Next12				cutcosts_nextyr changesupplier_nextyr prodquality_nextyr newbrand_nextyr newbranch_nextyr delegate_nextyr bisplan_nextyr startrec_nextyr loan_nextyr coopcompet_nextyr vat_nextyr
				
* Business performance
local Profits				prof_est_w1 prof_est_w25 prof_est_w5 /*prof_est_ihs*/
local Sales					sales_lastmth_w1 sales_lastmth_w25 sales_lastmth_w5 sales_lastmth_ln    
local Expenses				expense_total_w1 expense_total_w25 expense_total_w5 expense_total_ln 
local Size					size_w1 labour_total_w1 labour_fam labour_nonfam size /*labour_ft labour_pt*/   
local Customers				custom_total_w1 custom_loyal custom_general /*custom_avgpurch */
local Credit				credit_TC loan_applied loan_outstanding loan_amt_ln    
local IndivExpenses			expense_stockup_w1 expense_wage_w1 expense_rent_w1 ///
							expense_electric_w1 expense_transport_w1 ///
							expense_tax_w1 expense_phone_w1 expense_advert_w1 ///
							expense_preman_w1 expense_police_w1 expense_other_w1 
local mainperf				sales_lastmth_w5 prof_est_w5
local otherperf				size labour_total custom_total   
*local FinLit				finlit_score


* Aspirations
local asp18				asp18_prof_w1 asp18_prof_ihs  asp_minprof_w1 asp_minprof_ihs
local asp12				asp12_size_w1 asp12_employee_w1  asp12_customer_w1 asp12_sales_ln /*asp12_sales_w1*/
local asp				asp_size_w1 asp_employee_w1  asp_customer_w1

local aspgap18			aspgap18_prof_w1
local aspgap12			aspgap12_size_w1 aspgap12_employee_w1 aspgap12_customer_w1 aspgap12_sales_w1
local aspgap			aspgap_size_w1 aspgap_employee_w1 aspgap_customer_w1
local aspdiff			sizediff sizediff_w1 employeediff employeediff_w1 customerdiff customerdiff_w1
local aspfail			imagine_fail asp_yrs_fail


local psych				asp_import asp_prob asp_seff asp_loc


local forward			newbranch_nextyr bisplan_nextyr startrec_nextyr

* Outcomes for TE estimation (insert desired outcomes here)
local dims					mainperf otherperf 
							/*mainscores asp18 Profits Sales 
							RecordKeepingcore Marketingcore aspdiff aspgap18 aspgap12 aspgap psych Expenses Size ///
							Customers Credit RecordKeepingother Marketingother Decisions Stockup Planning */
							 

local dims2				forward
						 
***** Regressions

set more off 

* Estimation 

local i = 1
local m = 1

/*
foreach this_dim in `dims' {
	
	est drop _all
	
	foreach var in ``this_dim'' {

		* Generating Dummies for missing BL vars 
		cap drop W1_`var'_m 
		cap drop W1b_`var'
	
		gen W1_`var'_m = (W1_`var'==.) if W3_`var'!=. 
		gen W1b_`var' = W1_`var'
		replace W1b_`var'= 5 if W1_`var'_m == 1
		
			
		*With Full Controls
		display "ITT: CONTROL FOR BL DEP VAR AND STRATA"
		areg W3_`var' W1_asp12_shop_z `controls' W1b_`var' W1_`var'_m  if W3_finished==1 & control==1, absorb(W1_village) robust
		est sto T`m'_`this_dim'_`i'
		sum W3_`var' if W3_finished==1 & control==1
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
						
		areg W3_`var' W1_asp_shop_z `controls' W1b_`var' W1_`var'_m  if W3_finished==1 & control==1, absorb(W1_village) robust
		est sto T`m'_`this_dim'_`i'
		sum W3_`var' if W3_finished==1 & control==1
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
			
		areg W3_`var' W1_imagine_fail `controls' W1b_`var' W1_`var'_m  if W3_finished==1 & control==1, absorb(W1_village) robust
		est sto T`m'_`this_dim'_`i'
		sum W3_`var' if W3_finished==1 & control==1
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
		
		areg W3_`var' W1_asp_yrs_fail `controls' W1b_`var' W1_`var'_m  if W3_finished==1 & control==1, absorb(W1_village) robust
		est sto T`m'_`this_dim'_`i'
		sum W3_`var' if W3_finished==1 & control==1
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
		
	}
	
capture erase "Aspirations Output\T`m'_`this_dim'.csv"

* output
#delimit ;
	esttab T`m'_`this_dim'_* using "Aspirations Output\T`m'_`this_dim'.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N mean sd, fmt(%9.3f %9.0g %9.3f %9.3f) labels("R-squared" "N" "Dependent Variable Mean" "Dependent Variable SD"))
	title(`this_dim' Outcomes) keep(W1_asp* W1_imagine_fail W1_MW*) order(W1_asp12_shop* W1_asp_shop* W1_imagine_fail W1_asp_yrs_fail W1_MW*) ;
#delimit cr

	local ++m

}
*/


foreach this_dim in `dims' {
	
	est drop _all
	
	foreach var in ``this_dim'' {

		* Generating Dummies for missing BL vars 
		cap drop W1_`var'_m 
		cap drop W1b_`var'
	
		gen W1_`var'_m = (W1_`var'==.) if W3_`var'!=. 
		gen W1b_`var' = W1_`var'
		replace W1b_`var'= 5 if W1_`var'_m == 1
		
			
		*With Full Controls
		display "ITT: CONTROL FOR BL DEP VAR AND STRATA"
		areg W3_`var' W1_asp12_size_z `controls' W1b_`var' W1_`var'_m  if W3_finished==1 & control==1, absorb(W1_village) robust
		est sto T`m'_`this_dim'_`i'
		sum W3_`var' if W3_finished==1 & control==1
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
		
		areg W3_`var' W1_asp12_employee_z `controls' W1b_`var' W1_`var'_m  if W3_finished==1 & control==1, absorb(W1_village) robust
		est sto T`m'_`this_dim'_`i'
		sum W3_`var' if W3_finished==1 & control==1
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
		
		areg W3_`var' W1_asp12_customer_z `controls' W1b_`var' W1_`var'_m  if W3_finished==1 & control==1, absorb(W1_village) robust
		est sto T`m'_`this_dim'_`i'
		sum W3_`var' if W3_finished==1 & control==1
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
		
		areg W3_`var' W1_asp12_sales_z_m `controls' W1b_`var' W1_`var'_m W1_asp12_sales_z_dum  if W3_finished==1 & control==1, absorb(W1_village) robust
		est sto T`m'_`this_dim'_`i'
		sum W3_`var' if W3_finished==1 & control==1
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
				
	}
	
capture erase "Aspirations Output\T`m'_`this_dim'_disaggregated.csv"

* output
#delimit ;
	esttab T`m'_`this_dim'_* using "Aspirations Output\T`m'_`this_dim'_disaggregated.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N mean sd, fmt(%9.3f %9.0g %9.3f %9.3f) labels("R-squared" "N" "Dependent Variable Mean" "Dependent Variable SD"))
	title(`this_dim' Outcomes) keep(W1_asp12_size_z W1_asp12_employee_z W1_asp12_customer_z W1_asp12_sales_z_m ) order(W1_asp12_size_z W1_asp12_employee_z W1_asp12_customer_z W1_asp12_sales_z_m ) ;
#delimit cr

	local ++m

}

/* Baseline predictiveness of aspirations for forward looking behavior
foreach this_dim in `dims2' {
	
	est drop _all
	
	foreach var in ``this_dim'' {

		*With Full Controls
		display "ITT: CONTROL FOR BL DEP VAR AND STRATA"
		areg W1_`var' W1_asp12_size_z `controls', absorb(W1_village) robust
		est sto T`m'_`this_dim'_`i'
		sum W1_`var'
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
		
		areg W1_`var' W1_asp12_employee_z `controls', absorb(W1_village) robust
		est sto T`m'_`this_dim'_`i'
		sum W1_`var'
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
		
		areg W1_`var' W1_asp12_customer_z `controls', absorb(W1_village) robust
		est sto T`m'_`this_dim'_`i'
		sum W1_`var'
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
		
		areg W1_`var' W1_asp12_sales_z_m `controls' W1_asp12_sales_z_dum, absorb(W1_village) robust
		est sto T`m'_`this_dim'_`i'
		sum W1_`var'
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
				
	}
	
capture erase "Aspirations Output\T`m'_`this_dim'_disaggregated.csv"

* output
#delimit ;
	esttab T`m'_`this_dim'_* using "Aspirations Output\T`m'_`this_dim'_disaggregated.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N mean sd, fmt(%9.3f %9.0g %9.3f %9.3f) labels("R-squared" "N" "Dependent Variable Mean" "Dependent Variable SD"))
	title(`this_dim' Outcomes) keep(W1_asp12_size_z W1_asp12_employee_z W1_asp12_customer_z W1_asp12_sales_z_m ) order(W1_asp12_size_z W1_asp12_employee_z W1_asp12_customer_z W1_asp12_sales_z_m ) ;
#delimit cr

	local ++m

}

*/

*******************************


*Summary Stats for Realization of Aspirations

*How realistic are businesses aspirations? 

foreach x in sales customer size employee { 
sum W1_realistic_asp_`x' W1_pessimistic_asp_`x' W1_optimistic_asp_`x' if W3_finished==1 & control==1
}

******************************


*Determinants of Aspirations Type

*Who are more likely to set realistic/optimistic/pessimistic aspirations? 

local i = 1
est drop _all
	
foreach var in sales customer size employee {

	areg W1_realistic_asp_`var' W1_sales_lastmth_ln W1_size_w1 W1_custom_total_w1 W1_labour_total_w1 `controls' if W3_finished==1 & control==1, absorb(W1_village) robust
		est sto T_aspdet_`i'
		sum W1_realistic_asp_`var' if W3_finished==1 & control==1
		estadd scalar mean = r(mean)
		local ++i
		
	areg W1_optimistic_asp_`var' W1_sales_lastmth_ln W1_size_w1 W1_custom_total_w1 W1_labour_total_w1 `controls' if W3_finished==1 & control==1, absorb(W1_village) robust
		est sto T_aspdet_`i'
		sum W1_optimistic_asp_`var' if W3_finished==1 & control==1
		estadd scalar mean = r(mean)
		local ++i
		
	areg W1_pessimistic_asp_`var' W1_sales_lastmth_ln W1_size_w1 W1_custom_total_w1 W1_labour_total_w1 `controls' if W3_finished==1 & control==1, absorb(W1_village) robust
		est sto T_aspdet_`i'
		sum W1_pessimistic_asp_`var' if W3_finished==1 & control==1
		estadd scalar mean = r(mean)
		local ++i

	}
	
capture erase "Aspirations Output\T_aspdet.csv"

* output
#delimit ;
	esttab T_aspdet_* using "Aspirations Output\T_aspdet.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N mean, fmt(%9.3f %9.0g %9.3f) labels("R-squared" "N" "Dependent Variable Mean"))
	title(`var' aspirations growth)  ;
#delimit cr

	 
***************************	 


*Who Adjusts Aspirations?

* Do businesses adapt their aspirations with the outcome realized? 
* Do pessimistic become more realisitic, i.e. adjust their aspirations up? 
* Do overly-optimistic become more realisitc, i.e. adjust their aspirations down? 
* If the answer is NO, then it is suggestive evidence of an aspirations failure: people systematically aspire bellow or above their own potential


local i = 1
est drop _all
	
foreach var in sales customer size employee {

	areg W3_asp12_growth_`var' W1_pessimistic_asp_`var' W1_optimistic_asp_`var' `controls' if W3_finished==1 & control==1, absorb(W1_village) robust
		est sto T_aspgrowth_`i'
		sum W3_asp12_growth_`var' if W3_finished==1 & W1_realistic_asp_`var'==1 & control==1
		estadd scalar mean = r(mean)
		local ++i
					
	}
	
capture erase "Aspirations Output\T_aspgrowth.csv"

* output
#delimit ;
	esttab T_aspgrowth_* using "Aspirations Output\T_aspgrowth.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N mean, fmt(%9.3f %9.0g %9.3f) labels("R-squared" "N" "Dependent Variable Mean for realistic aspirers"))
	title(`var' aspirations growth) keep(W1_pessimistic_asp_* W1_optimistic_asp_*) ;
#delimit cr

***********************************


***VERSION 2 WITH FULL SAMPLE AND CONTROLLING FOR TREATMENT EFFECTS

***** Regressions

set more off 

* Estimation 

local i = 1
local m = 1

/*
foreach this_dim in `dims' {
	
	est drop _all
	
	foreach var in ``this_dim'' {

		* Generating Dummies for missing BL vars 
		cap drop W1_`var'_m 
		cap drop W1b_`var'
	
		gen W1_`var'_m = (W1_`var'==.) if W3_`var'!=. 
		gen W1b_`var' = W1_`var'
		replace W1b_`var'= 5 if W1_`var'_m == 1
		
			
		*With Full Controls
		display "ITT: CONTROL FOR BL DEP VAR AND STRATA"
		areg W3_`var' W1_asp12_shop_z `controls' W1b_`var' W1_`var'_m book_only book_mov book_ast book_mov_ast if W3_finished==1, absorb(W1_village) robust
		est sto T`m'_`this_dim'_`i'
		sum W3_`var' if W3_finished==1 & control==1
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
						
		areg W3_`var' W1_asp_shop_z `controls' W1b_`var' W1_`var'_m book_only book_mov book_ast book_mov_ast if W3_finished==1, absorb(W1_village) robust
		est sto T`m'_`this_dim'_`i'
		sum W3_`var' if W3_finished==1 & control==1
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
			
		areg W3_`var' W1_imagine_fail `controls' W1b_`var' W1_`var'_m book_only book_mov book_ast book_mov_ast if W3_finished==1, absorb(W1_village) robust
		est sto T`m'_`this_dim'_`i'
		sum W3_`var' if W3_finished==1 & control==1
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
		
		areg W3_`var' W1_asp_yrs_fail `controls' W1b_`var' W1_`var'_m book_only book_mov book_ast book_mov_ast if W3_finished==1, absorb(W1_village) robust
		est sto T`m'_`this_dim'_`i'
		sum W3_`var' if W3_finished==1 & control==1
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
		
	}
	
capture erase "Aspirations Output\v2\T`m'_`this_dim'.csv"

* output
#delimit ;
	esttab T`m'_`this_dim'_* using "Aspirations Output\v2\T`m'_`this_dim'.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N mean sd, fmt(%9.3f %9.0g %9.3f %9.3f) labels("R-squared" "N" "Dependent Variable Mean" "Dependent Variable SD"))
	title(`this_dim' Outcomes) keep(W1_asp* W1_imagine_fail W1_MW*) order(W1_asp12_shop* W1_asp_shop* W1_imagine_fail W1_asp_yrs_fail W1_MW*) ;
#delimit cr

	local ++m

}
*/

foreach this_dim in `dims' {
	
	est drop _all
	
	foreach var in ``this_dim'' {

		* Generating Dummies for missing BL vars 
		cap drop W1_`var'_m 
		cap drop W1b_`var'
	
		gen W1_`var'_m = (W1_`var'==.) if W3_`var'!=. 
		gen W1b_`var' = W1_`var'
		replace W1b_`var'= 5 if W1_`var'_m == 1
		
			
		*With Full Controls
		display "ITT: CONTROL FOR BL DEP VAR AND STRATA"
		areg W3_`var' W1_asp12_size_z `controls' W1b_`var' W1_`var'_m book_only book_mov book_ast book_mov_ast if W3_finished==1, absorb(W1_village) robust
		est sto T`m'_`this_dim'_`i'
		sum W3_`var' if W3_finished==1 & control==1
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
		
		areg W3_`var' W1_asp12_employee_z `controls' W1b_`var' W1_`var'_m book_only book_mov book_ast book_mov_ast if W3_finished==1, absorb(W1_village) robust
		est sto T`m'_`this_dim'_`i'
		sum W3_`var' if W3_finished==1 & control==1
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
		
		areg W3_`var' W1_asp12_customer_z `controls' W1b_`var' W1_`var'_m book_only book_mov book_ast book_mov_ast if W3_finished==1, absorb(W1_village) robust
		est sto T`m'_`this_dim'_`i'
		sum W3_`var' if W3_finished==1 & control==1
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
		
		areg W3_`var' W1_asp12_sales_z_m `controls' W1b_`var' W1_`var'_m W1_asp12_sales_z_dum book_only book_mov book_ast book_mov_ast if W3_finished==1, absorb(W1_village) robust
		est sto T`m'_`this_dim'_`i'
		sum W3_`var' if W3_finished==1 & control==1
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
				
	}
	
capture erase "Aspirations Output\v2\T`m'_`this_dim'_disaggregated.csv"

* output
#delimit ;
	esttab T`m'_`this_dim'_* using "Aspirations Output\v2\T`m'_`this_dim'_disaggregated.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N mean sd, fmt(%9.3f %9.0g %9.3f %9.3f) labels("R-squared" "N" "Dependent Variable Mean" "Dependent Variable SD"))
	title(`this_dim' Outcomes) keep(W1_asp12_size_z W1_asp12_employee_z W1_asp12_customer_z W1_asp12_sales_z_m ) order(W1_asp12_size_z W1_asp12_employee_z W1_asp12_customer_z W1_asp12_sales_z_m ) ;
#delimit cr

	local ++m

}


*******************************


*Determinants of Aspirations Type

*Who are more likely to set realistic/optimistic/pessimistic aspirations? 

local i = 1
est drop _all
	
foreach var in sales customer size employee {

	areg W1_realistic_asp_`var' W1_sales_lastmth_ln W1_size_w1 W1_custom_total_w1 W1_labour_total_w1 `controls' book_only book_mov book_ast book_mov_ast if W3_finished==1, absorb(W1_village) robust
		est sto T_aspdet_`i'
		sum W1_realistic_asp_`var' if W3_finished==1 & control==1
		estadd scalar mean = r(mean)
		local ++i
		
	areg W1_optimistic_asp_`var' W1_sales_lastmth_ln W1_size_w1 W1_custom_total_w1 W1_labour_total_w1 `controls' book_only book_mov book_ast book_mov_ast if W3_finished==1, absorb(W1_village) robust
		est sto T_aspdet_`i'
		sum W1_optimistic_asp_`var' if W3_finished==1 & control==1
		estadd scalar mean = r(mean)
		local ++i
		
	areg W1_pessimistic_asp_`var' W1_sales_lastmth_ln W1_size_w1 W1_custom_total_w1 W1_labour_total_w1 `controls' book_only book_mov book_ast book_mov_ast if W3_finished==1, absorb(W1_village) robust
		est sto T_aspdet_`i'
		sum W1_pessimistic_asp_`var' if W3_finished==1 & control==1
		estadd scalar mean = r(mean)
		local ++i

	}
	
capture erase "Aspirations Output\v2\T_aspdet.csv"

* output
#delimit ;
	esttab T_aspdet_* using "Aspirations Output\v2\T_aspdet.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N mean, fmt(%9.3f %9.0g %9.3f) labels("R-squared" "N" "Dependent Variable Mean"))
	title(`var' aspirations growth)  ;
#delimit cr

	 
***************************	 


*Who Adjusts Aspirations?

* Do businesses adapt their aspirations with the outcome realized? 
* Do pessimistic become more realisitic, i.e. adjust their aspirations up? 
* Do overly-optimistic become more realisitc, i.e. adjust their aspirations down? 
* If the answer is NO, then it is suggestive evidence of an aspirations failure: people systematically aspire bellow or above their own potential


local i = 1
est drop _all
	
foreach var in sales customer size employee {

	areg W3_asp12_growth_`var' W1_pessimistic_asp_`var' W1_optimistic_asp_`var' `controls' book_only book_mov book_ast book_mov_ast if W3_finished==1, absorb(W1_village) robust
		est sto T_aspgrowth_`i'
		sum W3_asp12_growth_`var' if W3_finished==1 & W1_realistic_asp_`var'==1
		estadd scalar mean = r(mean)
		local ++i
					
	}
	
capture erase "Aspirations Output\v2\T_aspgrowth.csv"

* output
#delimit ;
	esttab T_aspgrowth_* using "Aspirations Output\v2\T_aspgrowth.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N mean, fmt(%9.3f %9.0g %9.3f) labels("R-squared" "N" "Dependent Variable Mean for realistic aspirers"))
	title(`var' aspirations growth) keep(W1_pessimistic_asp_* W1_optimistic_asp_*) ;
#delimit cr




