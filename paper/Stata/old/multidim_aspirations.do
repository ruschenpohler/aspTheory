********************************************************************************
************** 			Multidimensional aspirations			****************
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
label var W1_aspgap12_shop_z "Aspirations Gap for Aggregate Short-Term Aspirations"
label var W1_asp_shop_z "Aggregate Long-Term Aspirations"
label var W1_aspgap_shop_z "Aspirations Gap for Aggregate Long-Term Aspirations"
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
label var W1_asp_educ_daughter_ma		"Aspired educ for daughter at least MA (yes=1)"
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


***** SUM STATS ***************************************************************


/* Scatters with lin regs (son & daughter)

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
*/
 
/* Correlation tables

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
	
*/


/* Balance table


local xvars1	W1_male W1_age_manager W1_educ W1_digitspan W1_risk_comp W1_time_comp ///
				W1_age_firm W1_labour_total W1_labour_nonfam_full W1_sales_lastmth ///
				W1_prof_lastmth W1_formal_tax W1_loan_outstanding W1_size ///
				W1_MW_M_score_total W1_MW_B_score_total W1_MW_R_score_total W1_MW_F_score_total ///
				W1_asp12_shop_z W1_asp_shop_z W1_aspgap12_shop_z W1_aspgap_shop_z W1_asp12_sales W1_asp12_sales_prob W1_aspgap12_sales W1_imagine_fail W1_asp_yrs_fail ///
				W1_asp_import W1_asp_prob W1_asp_seff W1_asp_loc W1_asp_cse ///
				W1_asp_educ_son W1_asp_educ_daughter W1_asp_educ_kids W1_aspgap_educ_son W1_aspgap_educ_daughter W1_aspgap_educ_kids ///
				W1_asp_educ_son_ma W1_asp_educ_daughter_ma W1_asp_educ_kids_ma ///
				W1_asp_occup_son W1_asp_occup_daughter W1_asp_occup_kids W1_asp_occup_son_govt W1_asp_occup_daughter_govt W1_asp_occup_kids_govt

cap gen tA		= control
label var tA	"Control Group"
cap gen tB		= book_only
label var tB	"Handbook Only"
cap gen tC		= book_mov
label var tC	"Handbook and Movie"
cap gen tD		= book_ast
label var tD	"Handbook and Assistance"
cap gen tE		= book_mov_ast
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

local z:			word count `xvars1'
matrix T = 			J(`z', 11, . ) 
matrix rownames T =	`xvars1' 
matrix colnames T =	Total sdTotal tA tB tC tD tE pvAB pvAC pvAD pvAE

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
	ttest `var' , by(treatAD) 
		mat T[rownumb(T, "`var'"), colnumb(T,"tD")] = `r(mu_1)' 
		mat T[rownumb(T, "`var'"), colnumb(T,"pvAD")] = `r(p)'
	ttest `var' , by(treatAE) 
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
capture erase "csv\descriptives\sumstats 1.csv"
outsheet using "csv\descriptives\sumstats 1.csv" , replace comma
*/



***** TREATMENT EFFECTS ********************************************************


***** LOCALS

*** Outcomes
local business_agg		asp12_shop_z asp12_shop_z_prob asp12_shop_z_cse asp12_shop_z_loc ///
						aspgap12_shop_z aspgap12_shop_z_prob aspgap12_shop_z_cse aspgap12_shop_z_loc ///
						asp_shop_z aspgap_shop_z ///
						imagine_fail asp_yrs_fail
local business_disagg	asp12_sales asp12_sales_prob asp12_sales_cse asp12_sales_loc ///
						aspgap12_sales aspgap12_sales_prob aspgap12_sales_cse aspgap12_sales_loc ///
						asp12_size aspgap12_size asp12_employee aspgap12_employee asp12_customer aspgap12_customer ///
						asp_size aspgap_size asp_employee aspgap_employee asp_customer aspgap_customer
local education			asp_educ_son aspgap_educ_son asp_educ_son_ma ///
						asp_educ_daughter aspgap_educ_daughter asp_educ_daughter_ma ///
						asp_educ_kids aspgap_educ_kids asp_educ_kids_ma
local occupation		asp_occup_son asp_occup_son_govt ///
						asp_occup_daughter asp_occup_daughter_govt ///
						asp_occup_kids asp_occup_kids_govt
local agency			asp_import asp_prob asp_seff asp_loc asp_cse
local satisfact			satisfact_life satisfact_fin			
local vars				business education occupation

*** Controls
local strata			W1_male W1_space_ord W1_MW_score_total_abovemd 

*** Treatment dummies
local treat 			book_only book_mov book_ast book_mov_ast 




/***** BUSINESS ASPIRATIONS (AGGREGATED)

set more off 

* Estimation

local i = 1
//local m = 1


//foreach this_var in `vars' {
	
	est drop _all
	
	//foreach x in ``this_var'' {
	foreach x in `business_agg' {

	
	//display `vars'
	//display `this_var'

	* Generating Dummies for missing BL vars 
	cap drop W1_`x'_m 
	cap drop W1b_`x'
	
	gen W1_`x'_m = (W1_`x'==.) if W3_`x'!=. 
	gen W1b_`x' = W1_`x'
	replace W1b_`x'= 999 if W1_`x'_m == 1
	
	/*TREATMENT DUMMIES ONLY
	display "ITT: NO CONTROLS"
	reg W3_`x' `treat' if W3_finished==1, robust
	est sto business_agg_`i', title("No Controls `i'")
	sum W3_`x' if W3_finished==1 & control==1
	estadd scalar mean = r(mean)
	estadd scalar sd = r(sd)
	local ++i */
		
	*With Strata Controls
	display "ITT: STRATA CONTROLS"
	reg W3_`x' `strata' `treat' if W3_finished==1, robust
	est sto business_agg_`i', title("Strata controls `i'")
	sum W3_`x' if W3_finished==1 & control==1
	estadd scalar mean = r(mean)
	estadd scalar sd = r(sd)
	local ++i
	
	*With Baseline Dep Var
	display "ITT: CONTROL FOR W1 OF DEP VAR"
	reg W3_`x' W1_`x'_m W1b_`x' `treat' if W3_finished==1, robust
	est sto business_agg_`i', title("ANCOVA spec `i'")
	sum W3_`x' if W3_finished==1 & control==1
	estadd scalar mean = r(mean)
	estadd scalar sd = r(sd)
	local ++i
	
	*With Baseline Dep Var And Strata Controls
	display "ITT: STRATA CONTROLS AND CONTROL FOR W1 OF DEP VAR"
	reg W3_`x' `strata' W1_`x'_m W1b_`x' `treat' if W3_finished==1, robust
	est sto business_agg_`i', title("Strata and BL control `i'")
	sum W3_`x' if W3_finished==1 & control==1
	estadd scalar mean = r(mean)
	estadd scalar sd = r(sd)
	local ++i
	
	}
	
*capture erase "Tex Output\business_agg_itt.tex"
capture erase "csv\treatment effects\business_agg_itt.csv"

* Tex and csv output
#delimit ;
	esttab business_agg_* using "csv\treatment effects\business_agg_itt.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N mean sd f1 f2 f3 f4 f5, fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) labels("R-squared" "N" "Dependent Variable Mean in Control Group" "Dependent Variable SD in Control Group" "F-test (p-value): Book = Book & Movie" "F-test (p-value): Book = Book & Assistance" "F-test (p-value): Book = Book & Movie & Assistance" "F-test (p-value): Book & Movie = Book & Assistance" "F-test (p-value): B & M + B & A > All Three"))
	title(Business Outcomes (Aggregated Shop Aspirations)) keep(book_*);
#delimit cr

	//local ++m

//}




***** BUSINESS ASPIRATIONS (DISAGGREGATED)

set more off 

* Estimation

local i = 1
//local m = 1


//foreach this_var in `vars' {
	
	est drop _all
	
	//foreach x in ``this_var'' {
	foreach x in `business_disagg' {

	
	//display `vars'
	//display `this_var'

	* Generating Dummies for missing BL vars 
	cap drop W1_`x'_m 
	cap drop W1b_`x'
	
	gen W1_`x'_m = (W1_`x'==.) if W3_`x'!=. 
	gen W1b_`x' = W1_`x'
	replace W1b_`x'= 999 if W1_`x'_m == 1
	
	/*TREATMENT DUMMIES ONLY
	display "ITT: NO CONTROLS"
	reg W3_`x' `treat' if W3_finished==1, robust
	est sto business_disagg_`i'
	sum W3_`x' if W3_finished==1 & control==1
	estadd scalar mean = r(mean)
	estadd scalar sd = r(sd)
	local ++i */
		
	*With Strata Controls
	display "ITT: STRATA CONTROLS"
	reg W3_`x' `strata' `treat' if W3_finished==1, robust
	est sto business_disagg_`i'
	sum W3_`x' if W3_finished==1 & control==1
	estadd scalar mean = r(mean)
	estadd scalar sd = r(sd)
	local ++i
	
	*With Baseline Dep Var
	display "ITT: CONTROL FOR W1 OF DEP VAR"
	reg W3_`x' W1_`x'_m W1b_`x' `treat' if W3_finished==1, robust
	est sto business_disagg_`i'
	sum W3_`x' if W3_finished==1 & control==1
	estadd scalar mean = r(mean)
	estadd scalar sd = r(sd)
	local ++i
	
	*With Baseline Dep Var And Strata Controls
	display "ITT: STRATA CONTROLS AND CONTROL FOR W1 OF DEP VAR"
	reg W3_`x' `strata' W1_`x'_m W1b_`x' `treat' if W3_finished==1, robust
	est sto business_disagg_`i'
	sum W3_`x' if W3_finished==1 & control==1
	estadd scalar mean = r(mean)
	estadd scalar sd = r(sd)
	local ++i
	
	}
	
*capture erase "Tex Output\business_disagg_itt.tex"
capture erase "csv\treatment effects\business_disagg_itt.csv"

* Tex and csv output
#delimit ;
	esttab business_disagg_* using "csv\treatment effects\business_disagg_itt.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N mean sd f1 f2 f3 f4 f5, fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) labels("R-squared" "N" "Dependent Variable Mean in Control Group" "Dependent Variable SD in Control Group" "F-test (p-value): Book = Book & Movie" "F-test (p-value): Book = Book & Assistance" "F-test (p-value): Book = Book & Movie & Assistance" "F-test (p-value): Book & Movie = Book & Assistance" "F-test (p-value): B & M + B & A > All Three"))
	title(Business Outcomes (Disaggregated Aspirations Dimensions)) keep(book_*);
#delimit cr

	//local ++m

//}




***** EDUCATION ASPIRATIONS

set more off 

* Estimation 

local i = 1
//local m = 1


//foreach this_var in `vars' {
	
	est drop _all
	
	//foreach x in ``this_var'' {
	foreach x in `education' {

	
	//display `vars'
	//display `this_var'

	* Generating Dummies for missing BL vars 
	cap drop W1_`x'_m 
	cap drop W1b_`x'
	
	gen W1_`x'_m = (W1_`x'==.) if W3_`x'!=. 
	gen W1b_`x' = W1_`x'
	replace W1b_`x'= 999 if W1_`x'_m == 1
	
	*TREATMENT DUMMIES ONLY
	/* display "ITT: NO CONTROLS"
	reg W3_`x' `treat' if W3_finished==1, robust
	est sto educ_`i'
	sum W3_`x' if W3_finished==1 & control==1
	estadd scalar mean = r(mean)
	estadd scalar sd = r(sd)
	local ++i */
		
	*With Strata Controls
	display "ITT: STRATA CONTROLS"
	reg W3_`x' `strata' `treat' if W3_finished==1, robust
	est sto educ_`i'
	sum W3_`x' if W3_finished==1 & control==1
	estadd scalar mean = r(mean)
	estadd scalar sd = r(sd)
	local ++i
	
	*With Baseline Dep Var
	display "ITT: CONTROL FOR W1 OF DEP VAR"
	reg W3_`x' W1_`x'_m W1b_`x' `treat' if W3_finished==1, robust
	est sto educ_`i'
	sum W3_`x' if W3_finished==1 & control==1
	estadd scalar mean = r(mean)
	estadd scalar sd = r(sd)
	local ++i
	
	*With Baseline Dep Var and Strata Controls
	display "ITT: STRATA CONTROLS AND CONTROL FOR W1 OF DEP VAR"
	reg W3_`x' `strata' W1_`x'_m W1b_`x' `treat' if W3_finished==1, robust
	est sto educ_`i'
	sum W3_`x' if W3_finished==1 & control==1
	estadd scalar mean = r(mean)
	estadd scalar sd = r(sd)
	local ++i
	
	}
	
*capture erase "Tex Output\educ_itt.tex"
capture erase "csv\treatment effects\educ_itt.csv"

* Tex and csv output
#delimit ;
	esttab educ_* using "csv\treatment effects\educ_itt.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N mean sd f1 f2 f3 f4 f5, fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) labels("R-squared" "N" "Dependent Variable Mean in Control Group" "Dependent Variable SD in Control Group" "F-test (p-value): Book = Book & Movie" "F-test (p-value): Book = Book & Assistance" "F-test (p-value): Book = Book & Movie & Assistance" "F-test (p-value): Book & Movie = Book & Assistance" "F-test (p-value): B & M + B & A > All Three"))
	title(Education Outcomes) keep(book_*);
#delimit cr

	//local ++m

//}



***** OCCUPATIONAL ASPIRATIONS


set more off 

* Estimation

local i = 1
//local m = 1


//foreach this_var in `vars' {
	
	est drop _all
	
	//foreach x in ``this_var'' {
	foreach x in `occupation' {

	
	//display `vars'
	//display `this_var'

	* Generating Dummies for missing BL vars 
	cap drop W1_`x'_m 
	cap drop W1b_`x'
	
	gen W1_`x'_m = (W1_`x'==.) if W3_`x'!=. 
	gen W1b_`x' = W1_`x'
	replace W1b_`x'= 999 if W1_`x'_m == 1
	
	/*TREATMENT DUMMIES ONLY
	display "ITT: NO CONTROLS"
	reg W3_`x' `treat' if W3_finished==1, robust
	est sto occup_`i'
	sum W3_`x' if W3_finished==1 & control==1
	estadd scalar mean = r(mean)
	estadd scalar sd = r(sd)
	local ++i */
		
	*With Strata Controls
	display "ITT: STRATA CONTROLS"
	reg W3_`x' `strata' `treat' if W3_finished==1, robust
	est sto occup_`i'
	sum W3_`x' if W3_finished==1 & control==1
	estadd scalar mean = r(mean)
	estadd scalar sd = r(sd)
	local ++i
	
	*With Baseline Dep Var
	display "ITT: CONTROL FOR W1 OF DEP VAR"
	reg W3_`x' W1_`x'_m W1b_`x' `treat' if W3_finished==1, robust
	est sto occup_`i'
	sum W3_`x' if W3_finished==1 & control==1
	estadd scalar mean = r(mean)
	estadd scalar sd = r(sd)
	local ++i
	
	*With Baseline Dep Var and Strata Controls
	display "ITT: CONTROL FOR W1 OF DEP VAR"
	reg W3_`x' `strata' W1_`x'_m W1b_`x' `treat' if W3_finished==1, robust
	est sto occup_`i'
	sum W3_`x' if W3_finished==1 & control==1
	estadd scalar mean = r(mean)
	estadd scalar sd = r(sd)
	local ++i
	
	}
	
*capture erase "Tex Output\occup_itt.tex"
capture erase "csv\treatment effects\occup_itt.csv"

* Tex and csv output
#delimit ;
	esttab occup_* using "csv\treatment effects\occup_itt.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N mean sd f1 f2 f3 f4 f5, fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) labels("R-squared" "N" "Dependent Variable Mean in Control Group" "Dependent Variable SD in Control Group" "F-test (p-value): Book = Book & Movie" "F-test (p-value): Book = Book & Assistance" "F-test (p-value): Book = Book & Movie & Assistance" "F-test (p-value): Book & Movie = Book & Assistance" "F-test (p-value): B & M + B & A > All Three"))
	title(Occupation Outcomes) keep(book_*);
#delimit cr

	//local ++m

//}



**** SATISFACTION


set more off 

* Estimation

local i = 1
//local m = 1


//foreach this_var in `vars' {
	
	est drop _all
	
	//foreach x in ``this_var'' {
	foreach x in `satisfact' {

	
	//display `vars'
	//display `this_var'

	
	/*TREATMENT DUMMIES ONLY
	display "ITT: NO CONTROLS"
	reg W3_`x' `treat' if W3_finished==1, robust
	est sto satisfact_`i'
	sum W3_`x' if W3_finished==1 & control==1
	estadd scalar mean = r(mean)
	estadd scalar sd = r(sd)
	local ++i */
		
	*With Strata Controls
	display "ITT: STRATA CONTROLS"
	reg W3_`x' `strata' `treat' if W3_finished==1, robust
	est sto satisfact_`i'
	sum W3_`x' if W3_finished==1 & control==1
	estadd scalar mean = r(mean)
	estadd scalar sd = r(sd)
	local ++i
	
	}
	
*capture erase "csv\treatment effects\satisfact_itt.tex"
capture erase "csv\treatment effects\satisfact_itt.csv"

* Tex and csv output
#delimit ;
	esttab satisfact_* using "csv\treatment effects\satisfact_itt.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N mean sd f1 f2 f3 f4 f5, fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) labels("R-squared" "N" "Dependent Variable Mean in Control Group" "Dependent Variable SD in Control Group" "F-test (p-value): Book = Book & Movie" "F-test (p-value): Book = Book & Assistance" "F-test (p-value): Book = Book & Movie & Assistance" "F-test (p-value): Book & Movie = Book & Assistance" "F-test (p-value): B & M + B & A > All Three"))
	title(Satisfaction Outcomes) keep(book_*);
#delimit cr

	//local ++m

//}


*/


****** Heterogeneous Treatment Effects


gen AMscore = W1_MW_score_total_abovemd
gen male = W1_male
gen shopspace = W1_space_ord


local vars_het AMasp2 male

local vars_het_male			book_only_male book_mov_male book_ast_male book_mov_ast_male
local vars_het_female		book_only_female book_mov_female book_ast_female book_mov_ast_female
local vars_het_AMasp2		book_only_AMasp2 book_mov_AMasp2 book_ast_AMasp2 book_mov_ast_AMasp2 AMasp2 
local vars_het_BMasp2		book_only_BMasp2 book_mov_BMasp2 book_ast_BMasp2 book_mov_ast_BMasp2 BMasp2 
local vars_het_ifail		book_only_ifail book_mov_ifail book_ast_ifail book_mov_ast_ifail ifail


set more off 


local i = 1
local m = 1

//foreach this_dim in `dims' {
	
est drop _all

foreach var in `business' {
	foreach v in `vars_het' {

		* Generating Dummies for missing BL vars 
		cap drop W1_`var'_m 
		cap drop W1b_`var'
	
		gen W1_`var'_m = (W1_`var'==.) if W3_`var'!=. 
		gen W1b_`var' = W1_`var'
		replace W1b_`var'= 5 if W1_`var'_m == 1
	
	
		*With Baseline Dep Var and Strata Controls		
		areg W3_`var' `treat' `vars_het_`v'' W1b_`var' W1_`var'_m `controls' if W3_finished==1, absorb(W1_village) robust
		est sto business_het_`i'
		estadd ysumm
		test book_only + book_only_`v'=0
		estadd scalar f1 = r(p)
		test book_mov + book_mov_`v'=0
		estadd scalar f2 = r(p)
		test book_ast + book_ast_`v'=0
		estadd scalar f3 = r(p)
		test book_mov_ast + book_mov_ast_`v'=0
		estadd scalar f4 = r(p)
		sum W3_`var' if control==1
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		
		local ++i
	
	}
}

	
capture erase "csv\treatment effects\T`m'_`this_dim'_vars_het.csv"

* output
#delimit ;
	esttab business_het_* using "csv\treatment effects\T`m'_`this_dim'_vars_het.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N mean sd f1 f2 f3 f4, fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) labels("R-squared" "N" "Dependent Variable Mean in Control Group" "Dependent Variable SD in Control Group" "F-test (p-value): Book + Interaction" "F-test (p-value): Book & Movie + Interaction" "F-test (p-value): Book & Assistaince + Interaction" "F-test (p-value): All Three + Interaction"))
	title(`this_dim' Outcomes) keep(book_*);
#delimit cr

	local ++m


//}


