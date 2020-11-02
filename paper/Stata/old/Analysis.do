********************************************************************************
************** 			Multidimensional aspirations			****************
*
*				            Main analysis do-file
*		
********************************************************************************


set matsize 11000
clear all

cd "`c(pwd)'\"

do "Master.do"
use "dta\W1_W3_merged", clear

set more off



* VAR PREP

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


foreach var in W1_sales_lastmth W3_sales_lastmth W1_sales_nday W3_sales_nday {
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

label var W1_asp_occup_son				"Aspired occupation for son (ranked)"
label var W1_asp_occup_son_high			"Occup aspirations for son above md (yes=1)"
label var W1_asp_occup_son_govt			"Gov't job aspired for son (yes=1)"
label var W1_asp_occup_daughter			"Aspired occupation for daughter (ranked)"
label var W1_asp_occup_daughter_high	"Occup aspirations for daighter above md (yes=1)
label var W1_asp_occup_daughter_govt	"Gov't job aspired for either daughter (yes=1)"
label var W1_asp_occup_kids				"Aspired occupation for children (ranked)
label var W1_asp_occup_kids_govt		"Gov't job aspired for either son or daughter (yes=1)"
label var W1_asp_occup_kids_high		"Avg occup aspirations for children above md (yes=1)"

label var W1_asp_educ_son				"Aspired educ for son (Years)"
label var W1_aspgap_educ_son			"Aspirations gap for son's educ"
label var W1_asp_educ_son_high			"Aspired educ for son above md (Yes=1)"
label var W1_asp_educ_son_ma			"Aspired educ for son at least MA (Yes=1)"
label var W1_asp_educ_daughter			"Aspired educ for daughter (Years)"
label var W1_aspgap_educ_daughter		"Aspirations gap for daughter's educ"
label var W1_asp_educ_daughter_high		"Aspired educ for son above md (Yes=1)"
label var W1_asp_educ_daughter_ma		"Aspired educ for son at least MA (yes=1)"
label var W1_asp_educ_kids				"Aspired educ for children (Years)
label var W1_aspgap_educ_kids			"Aspirations gap for children's educ (Years)"
label var W1_asp_educ_kids_ma			"Aspired educ for children at least MA (Yes=1)"
label var W1_asp_educ_kids_high			"Aspired educ for children above md (Yes=1)"


* Missing value dummies
foreach var in	W1_age_manager W1_asp12_sales_z {
				gen `var'_dum = (`var'==.)
				
				gen `var'_m = 5 if `var'==.
				replace `var'_m = `var' if `var'!=.
				_crcslbl `var'_m `var'
}

label var W1_asp12_sales_z_m "Short-Term Sales Aspirations (Zscore)"


* Squares
gen W1_aspgap_educ_kids_sq = W1_aspgap_educ_kids*W1_aspgap_educ_kids
gen W1_aspgap12_sales_sq = W1_aspgap12_sales_w1*W1_aspgap12_sales_w1



********************************************************************************


*** Sum stats

sum W1_male W1_age_manager W1_educ W1_digitspan W1_risk_comp W1_time_comp ///
	W1_age_firm W1_labour_total W1_labour_nonfam_full W1_sales_lastmth ///
	W1_prof_lastmth W1_formal_tax W1_loan_outstanding W1_size ///
	W1_MW_M_score_total W1_MW_B_score_total W1_MW_R_score_total W1_MW_F_score_total ///
	W1_asp12_sales W1_aspgap12_sales ///
	W1_asp_import W1_asp_prob W1_asp_seff W1_asp_loc ///
	W1_asp_educ_son W1_asp_educ_daughter W1_aspgap_educ_son W1_aspgap_educ_daughter W1_asp_educ_son_ma W1_asp_educ_daughter_ma ///
	W1_asp_occup_son W1_asp_occup_daughter W1_asp_occup_son_govt W1_asp_occup_daughter_govt ///
	if W3_finished==1, det //& control==1


* Scatters with lin regs (son & daughter)

foreach x in son daughter {

twoway lfitci W1_asp12_sales W1_asp_educ_`x' if W3_finished==1, fintensity(inten10) acolor(g12) name(asp_`x') || ///
scatter W1_asp12_sales W1_asp_educ_`x', mcolor(g1) msize(small)
graph export "pdf/asp_sales_educ_`x'.pdf", name(asp_`x') replace

twoway lfitci W1_aspgap12_sales W1_aspgap_educ_`x' if W3_finished==1, fintensity(inten10) acolor(g12) name(aspgap_`x') || ///
scatter W1_aspgap12_sales W1_aspgap_educ_`x', mcolor(g1) msize(small)
graph export "pdf/aspgap_sales_educ_`x'.pdf", name(aspgap_`x') replace

graph combine asp_`x' aspgap_`x', graphreg(color(white)) name(asp_aspgap_sales_educ_`x') ///
title("Correlation Between Aspirations for Sales and for Schooling at Baseline (`x')", size(medsmall))
graph export "pdf/asp_aspgap_sales_educ_`x'.pdf", name(asp_aspgap_sales_educ_`x') replace
}

 
* Correlation tables

* All vars
mkcorr W1_male W1_age_manager W1_educ W1_digitspan W1_risk_comp W1_time_comp ///
	W1_age_firm W1_labour_total W1_labour_nonfam_full W1_sales_lastmth ///
	W1_prof_lastmth W1_formal_tax W1_loan_outstanding W1_size ///
	W1_MW_M_score_total W1_MW_B_score_total W1_MW_R_score_total W1_MW_F_score_total ///
	W1_asp12_sales W1_aspgap12_sales ///
	W1_asp_import W1_asp_prob W1_asp_seff W1_asp_loc ///
	W1_asp_educ_son W1_asp_educ_daughter W1_aspgap_educ_son W1_aspgap_educ_daughter W1_asp_educ_son_ma W1_asp_educ_daughter_ma ///
	W1_asp_occup_son W1_asp_occup_daughter W1_asp_occup_son_govt W1_asp_occup_daughter_govt ///
	if W3_finished==1, log(corr_all.csv) label replace

* Asps
mkcorr W1_asp12_sales W1_aspgap12_sales ///
	W1_asp_import W1_asp_prob W1_asp_seff W1_asp_loc ///
	W1_asp_educ_son W1_asp_educ_daughter W1_aspgap_educ_son W1_aspgap_educ_daughter W1_asp_educ_son_ma W1_asp_educ_daughter_ma ///
	W1_asp_occup_son W1_asp_occup_daughter W1_asp_occup_son_govt W1_asp_occup_daughter_govt ///
	if W3_finished==1, log(corr_asps.csv) label replace




/* TABLE 1: DESCRIPTIVES AND BALANCE *** To be completed when W2_groups available

* Variables to Check
local xvars1	W1_male W1_age_manager W1_educ W1_digitspan W1_risk_comp W1_time_comp ///
				W1_age_firm W1_bispartner_fam W1_labour_total W1_labour_paid_perm W1_sales_lastmth_ln W1_prof_lastmth_ihs W1_formal_tax W1_loan_obtained ///
				W1_MW_M_score_total W1_MW_B_score_total W1_MW_R_score_total W1_MW_F_score_total

		    						
cap gen tA		= control
label var tA	"Control group"
cap gen tB		= book_mov
label var tB	"Movie"
cap gen tC		= 1 if book_ast==1 | book_mov_ast==1
label var tC	"Assistance"

* Data
gen treatAB = 1 if tA==1 		
replace treatAB = 0 if tB==1 
gen treatAC = 1 if tA==1 
replace treatAC = 0 if tC==1  
gen treatBC = 1 if tB==1 
replace treatBC = 0 if tC==1 

* Estimation
local z: 		word count `xvars1'

matrix T = J(`z', 17, . ) 
matrix rownames T = `xvars1' 
matrix colnames T = Total sdTotal tA tB tC  pvAB pvAC pvBC


foreach var in `xvars1' { 

	global `var'label: var label `var' 
	
	sum `var' 
		mat T[rownumb(T, "`var'"), colnumb(T,"sdTotal")] = `r(sd)' 
		mat T[rownumb(T, "`var'"), colnumb(T,"Total")] = `r(mean)' 
	ttest `var' , by(treatAB) 
		mat T[rownumb(T, "`var'"), colnumb(T,"tA")] = `r(mu_2)' 
		mat T[rownumb(T, "`var'"), colnumb(T,"tB")] = `r(mu_1)' 
		mat T[rownumb(T, "`var'"), colnumb(T,"pvAB")] = `r(p)' 
	ttest `var' , by(treatAC) 
		mat T[rownumb(T, "`var'"), colnumb(T,"tC")] = `r(mu_1)' 
		mat T[rownumb(T, "`var'"), colnumb(T,"pvAC")] = `r(p)' 
	ttest `var' , by(treatBC) 
		mat T[rownumb(T, "`var'"), colnumb(T,"pvBC")] = `r(p)'		
} 

matrix list T

clear 
svmat T 
rename T1 Total 
rename T2 sdTotal 
rename T3 tA
rename T4 tB
rename T5 tC
rename T8 pvAB 
rename T9 pvAC 
rename T12 pvBC 

gen var_name = "" 
order var_name 

local i = 1 

foreach var in `xvars1' { 
	
	replace var_name = "$`var'label" in `i' 
	local i = `i' + 1 
	
} 

label var var_name "Variable" 
label var sdTotal "SD of Total" 
label var Total "Total" 
label var tA "Group A" 
label var tB "Group B" 
label var tC "Group C"  
label var pvAB "A vs B" 
label var pvAC "A vs C"
label var pvBC "B vs C" 


foreach var of varlist pvAB pvAC pvBC { 
	
	replace `var' = round(`var', 0.001) 
	format `var' %9.3f 
} 

foreach var of varlist Total sdTotal tA tB tC { 
	
	replace `var' = round(`var', 0.01) 
	format `var' %9.2f 
} 

foreach xy of varlist pvAB pvAC pvBC {

	local y = substr("`xy'",-2,2)
	gen stars`y' = ""

	replace stars`y' = "*" if `xy' <= 0.10 
	replace stars`y' = "**" if `xy' <= 0.05 
	replace stars`y' = "***" if `xy' <= 0.01
	move stars`y' `xy'
}

foreach x in Total tA tB tC pvAB pvAC pvBC { 
	replace `x'=. if var_name=="" 
} 

foreach x in starsAB starsAC starsBC {
	replace `x'="" if var_name=="" 
} 


* Output
capture erase "csv\sumstats.csv"
outsheet using "csv\sumstats.csv" , replace comma

*\









































/*

* EDUCATION ASPIRATIONS


***** Determinants of education aspirations

* Graphs
//twoway (scatter W1_asp12_sales W1_aspgap_educ_kids) (qfit W1_asp12_sales W1_aspgap_educ_kids)
//twoway (scatter W1_sales_nday_w1 W1_aspgap_educ_kids) (qfit W1_sales_nday_w1 W1_aspgap_educ_kids)

* Basic model
areg W1_aspgap_educ_kids W1_sales_nday_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust

* Gender (No effect)
areg W1_aspgap_educ_kids W1_male W1_sales_nday_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust

* Kids in fam -- Asps higher for larger fams
areg W1_aspgap_educ_kids W1_kids_3 W1_sales_nday_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust
// -- Holds for son? Yes.
areg W1_aspgap_educ_son W1_kids_3 W1_sales_nday_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust
// -- Holds for daughter? Yes.
areg W1_aspgap_educ_daughter W1_kids_3 W1_sales_nday_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust
// -- Gender effect? No.
areg W1_aspgap_educ_kids W1_male W1_kids_3 W1_sales_nday_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust

* BP composite -- Asps lower for better managed firms
areg W1_aspgap_educ_kids W1_MW_score_total W1_sales_nday_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust
// -- Holds for son? Yes.
areg W1_aspgap_educ_son W1_MW_score_total W1_sales_nday_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust
// -- Holds for daughter? Yes.
areg W1_aspgap_educ_daughter W1_MW_score_total W1_sales_nday_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust
// -- Holds for large fams? Yes.
areg W1_aspgap_educ_kids W1_kids_3 W1_MW_score_total W1_sales_nday_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust
// -- Gender effect? No.
areg W1_aspgap_educ_kids W1_male W1_MW_score_total W1_sales_nday_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust

* Perceived relative level of practices (No effect, tendency: lower for better managed firms)
areg W1_aspgap_educ_kids W1_practices_rel_high W1_sales_nday_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust


***** Predicting baseline business performance

* Basic model
areg W1_sales_nday_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust

* Educ asps (No effect, tendency: Positive)
areg W1_sales_nday_w1 W1_aspgap_educ_kids W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust

* Sales aps -- Negative!
areg W1_sales_nday_w1 W1_aspgap12_sales_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust
// -- Quadratic? Yes, inverted U.
areg W1_sales_nday_w1 W1_aspgap12_sales_w1 W1_aspgap12_sales_sq W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust
// -- Sales and educ asps? Sales asps negative, educ asps positive
areg W1_sales_nday_w1 W1_aspgap_educ_kids W1_aspgap12_sales_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust


***** Predicting baseline management quality

* Basic model
areg W1_MW_score_total W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust

* Educ asps -- Negative!
areg W1_MW_score_total W1_aspgap_educ_kids W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust

* Sales aps (No effect, tendency: Positive)
areg W1_MW_score_total W1_aspgap12_sales_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust
// -- Quadratic? Yes, U shaped.
areg W1_MW_score_total W1_aspgap12_sales_w1 W1_aspgap12_sales_sq W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust
// -- Sales and educ asps? Educ asps negative
areg W1_MW_score_total W1_aspgap_educ_kids W1_aspgap12_sales_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust

********************************************************************************


* OCCUPATION ASPIRATIONS


***** Determinants of occupation aspirations

* Basic model
areg W1_asp_occup_kids_govt W1_sales_nday_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust
areg W1_asp_occup_kids_high W1_sales_nday_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust

* Gender (No effect)
areg W1_asp_occup_kids_govt W1_male W1_sales_nday_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust
areg W1_asp_occup_kids_high W1_male W1_sales_nday_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust

* Kids in fam (No effect, tendency: gov't positive, high negative)
areg W1_asp_occup_kids_govt W1_kids_3 W1_sales_nday_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust
areg W1_asp_occup_kids_high W1_kids_3 W1_sales_nday_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust
// -- Gender effect? No.
areg W1_asp_occup_kids_govt W1_male W1_kids_3 W1_sales_nday_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust
areg W1_asp_occup_kids_high W1_male W1_kids_3 W1_sales_nday_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust

* BP composite (No effect)
areg W1_asp_occup_kids_govt W1_MW_score_total W1_sales_nday_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust
areg W1_asp_occup_kids_high W1_MW_score_total W1_sales_nday_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust

* Subjective relative practices (No effect, tendency: gov't negative, high positive)
areg W1_asp_occup_kids_govt W1_practices_rel_high W1_sales_nday_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust
areg W1_asp_occup_kids_high W1_practices_rel_high W1_sales_nday_w1 W1_size W1_custom_total W1_labour_total, absorb(W1_village) robust



