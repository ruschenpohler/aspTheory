
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

set more off

local rn


/* Not available in W4: _rec_accreccustom_TC, _rec_sales, _startrec_lastyr, _rec_sales, _rec_stockup, 
						_rec_pricesuppliers, _rec_accpayloan, profcalc_any, MWR5_costprods, _startrec_lastyr
 						expense_tax, expense_phone, expense_advert, expense_preman, expense_police */


***** TABLE 1: SUMMARY STATS AND BALANCE TESTS *****
use Data\Analysis_data.dta, clear
set more off


* labels
label var W1_male "Respondent is Male" 
label var W1_age_manager "Respondent Age"
label var W1_educ "Respondent Years of Education" 
label var W1_digitspan_total "Respondent Digitspan Score"
label var W1_risk_comp "Respondent Risk Preference Score" 
label var W1_time_comp "Respondent Time Preference Score"
label var W1_age_firm "Age of Firm"  
*label var W1_bispartner_fam "Family Member is Business Partner"
label var W1_labour_total "Total Number of Employees"
label var W1_labour_ft "Number of Full Time Paid Employees"
label var W1_sales_lastmth "Total Sales Last Month (USD PPP)"
label var W1_prof_est "Total Profits Last Month (USD PPP)" 
label var W1_formal_tax "Firm has Tax ID"
label var W1_loan_amt "Outstanding Loans"
label var W1_MW_score_total "McKenzie & Woodruff (2016) Aggregate Score" 
label var W1_MW_M_score_total "MW Marketing Subscore"
label var W1_MW_B_score_total "MW Stocking Up Subscore"
label var W1_MW_R_score_total "MW Record Keeping Subscore"
label var W1_MW_F_score_total "MW Financial Planning Subscore"

* Variables to Check
local xvars1	W1_male W1_age_manager W1_educ W1_digitspan_total W1_risk_comp W1_time_comp ///
				W1_age_firm W1_labour_total W1_labour_ft W1_sales_lastmth W1_prof_est W1_formal_tax W1_loan_amt  ///
				W1_MW_score_total W1_MW_M_score_total W1_MW_B_score_total W1_MW_R_score_total W1_MW_F_score_total

cap gen tA				= control
label var tA			"Control Group"
cap gen tB				= B
label var tB			"Handbook Only"
cap gen tC				= BM
label var tC			"Handbook and Movie"
cap gen tD				= BC
label var tD			"Handbook and Assistance"
cap gen tE				= BMC
label var tE			"Handbook, Movie, and Assistance"

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
local z: 		word count `xvars1'

matrix T = J(`z', 11, . ) 
matrix rownames T = `xvars1' 
matrix colnames T = Total sdTotal tA tB tC tD tE pvAB pvAC pvAD pvAE

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
capture erase "csv\peer learning\descriptives\sumstats.csv"
outsheet using "csv\peer learning\descriptives\sumstats.csv" , replace comma





*** TABLE 2a: MOVIE ATTENDANCE AND FEEDBACK ***

use "Data\Analysis_data.dta", clear
set more off 

* Variables to Check
local xvars1 	mov_attend_any mov_eval_comprehend mov_eval_inspire mov_eval_hope mov_eval_bored 

				
cap gen tA				= BM
label var tA			"Handbook and Movie"

cap gen tB				= BMC
label var tB			"Handbook, Movie, and Assistance"

keep if BM==1 | BMC==1 


* Data
gen treatAB = 1 if tA==1 		
replace treatAB = 0 if tB==1 


* Estimation
local z: word count `xvars1' 

matrix T = J(`z', 3, . )
matrix rownames T = `xvars1' 
matrix colnames T = tA tB pvAB 

foreach var in `xvars1' {

	global `var'label: var label `var' 
	
	ttest `var' , by(treatAB) 
		mat T[rownumb(T, "`var'"), colnumb(T,"tA")] = `r(mu_2)' 
		mat T[rownumb(T, "`var'"), colnumb(T,"tB")] = `r(mu_1)' 
		mat T[rownumb(T, "`var'"), colnumb(T,"pvAB")] = `r(p)' 
			
	} 

	
matrix list T

clear 
svmat T 
rename T1 tA
rename T2 tB
rename T3 pvAB

gen var_name = "" 
order var_name 

local i = 1 
foreach var in `xvars1' { 
	replace var_name = "$`var'label" in `i' 
	local i = `i' + 1 
} 

label var var_name "Variable" 
label var tA "Handbook and Movie (A)" 
label var tB "Handbook, Movie, and Assistance (B)" 
label var pvAB "A vs B"
 
foreach var of varlist pvAB { 
	
	replace `var' = round(`var', 0.001) 
	format `var' %9.3f 
} 

 
 foreach var of varlist tA tB { 
	replace `var' = round(`var', 0.01) 
	format `var' %9.2f 
} 
 
gen starsab = "" 
replace starsab = "*" if pvAB <= 0.10 
replace starsab = "**" if pvAB <= 0.05 
replace starsab = "***" if pvAB <= 0.01 

 
foreach x in tA tB { 
replace `x'=. if var_name=="" 
} 


foreach x in starsab {
 
	replace `x'="" if var_name=="" 
} 


* Output
capture erase "csv\peer learning\descriptives\table_attend_mov.csv"
outsheet using "csv\peer learning\descriptives\table_attend_mov.csv" , replace comma




*** TABLE 2b: ASSISTANCE ACCEPTANCE AND FEEDBACK ***

use "Data\Analysis_data.dta", clear
set more off 

* Variables to Check
local xvars1 	ast_1_accept_any ast_2_accept_any ast_2_eval_comprehend ast_2_eval_inspire ast_2_eval_hope ast_2_eval_bored 

				
cap gen tA				= BC
label var tA			"Handbook and Assistance"

cap gen tB				= BMC
label var tB			"Handbook, Movie, and Assistance"

keep if BC==1 | BMC==1 


* Data
gen treatAB = 1 if tA==1 		
replace treatAB = 0 if tB==1 


* Estimation
local z: word count `xvars1' 

matrix T = J(`z', 3, . )
matrix rownames T = `xvars1' 
matrix colnames T = tA tB pvAB 

foreach var in `xvars1' {

	global `var'label: var label `var' 
	
	ttest `var' , by(treatAB) 
		mat T[rownumb(T, "`var'"), colnumb(T,"tA")] = `r(mu_2)' 
		mat T[rownumb(T, "`var'"), colnumb(T,"tB")] = `r(mu_1)' 
		mat T[rownumb(T, "`var'"), colnumb(T,"pvAB")] = `r(p)' 
			
	} 

	
matrix list T

clear 
svmat T 
rename T1 tA
rename T2 tB
rename T3 pvAB

gen var_name = "" 
order var_name 

local i = 1 
foreach var in `xvars1' { 
	replace var_name = "$`var'label" in `i' 
	local i = `i' + 1 
} 

label var var_name "Variable" 
label var tA "Handbook and Assistance (A)" 
label var tB "Handbook, Movie, and Assistance (B)" 
label var pvAB "A vs B"
 
foreach var of varlist pvAB { 
	
	replace `var' = round(`var', 0.001) 
	format `var' %9.3f 
} 

 
 foreach var of varlist tA tB { 
	replace `var' = round(`var', 0.01) 
	format `var' %9.2f 
} 
 
gen starsab = "" 
replace starsab = "*" if pvAB <= 0.10 
replace starsab = "**" if pvAB <= 0.05 
replace starsab = "***" if pvAB <= 0.01 

 
foreach x in tA tB { 
replace `x'=. if var_name=="" 
} 


foreach x in starsab {
 
	replace `x'="" if var_name=="" 
} 


* Output
capture erase "csv\peer learning\descriptives\table_attend_ast.csv"
outsheet using "csv\peer learning\descriptives\table_attend_ast.csv" , replace comma




***** TABLE 3: ATTRITION ANALYSIS *****

use "Data\Analysis_data.dta", clear
set more off

* Regressors
local x_treatment B BM BC BMC 
local controls W1_male W1_space_ord W1_MW_score_total_abovemd


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

foreach w in W3 W4 {

	foreach var in Sample_`w' Sample_`w'_closed {
		reg `var' `x_treatment', r
		est sto table_attrition_`i'
		estadd ysumm
		test B-BM=0
		estadd scalar p_B_BM = r(p)
		test B-BC=0
		estadd scalar p_B_BA = r(p)
		test B-BMC=0
		estadd scalar p_B_BMA = r(p)
		test BM-BC=0
		estadd scalar p_BM_BA = r(p)
		sum `var' if control==1
		estadd scalar mean = r(mean)
		local ++i
	
		areg `var' `x_treatment' `controls', absorb(W1_village) r
		est sto table_attrition_`i'
		estadd ysumm
		test B-BM=0
		estadd scalar p_B_BM = r(p)
		test B-BC=0
		estadd scalar p_B_BA = r(p)
		test B-BMC=0
		estadd scalar p_B_BMA = r(p)
		test BM-BC=0
		estadd scalar p_BM_BA = r(p)
		sum `var' if control==1
		estadd scalar mean = r(mean)
		local ++i
	}
}


* Output
capture erase "csv\peer learning\descriptives\table_attrition.csv"
#delimit ;
esttab table_attrition_* using "csv\peer learning\descriptives\table_attrition.csv", label replace modelwidth(16) varwidth(50) depvar legend
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01)
	stats(r2 N mean p_B_BM p_B_BA p_B_BMA p_BM_BA, fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f) 
	labels("R-squared" "N" "Mean of Dependent Variable in Control Group" "F-test (p-value): Book = Book & Movie" "F-test (p-value): Book = Book & Assistance" "F-test (p-value): Book = Book & Movie & Assistance" "F-test (p-value): Book & Movie = Book & Assistance"))
	title("Attrition at endline 1 (W3) and endline 2 (W4)") keep(B*) ;
#delimit cr




***REGRESSION TABLES***

use "Data\Analysis_data.dta", clear
set more off

* Variable prep

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

foreach w in W3 W4 {
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

label var W3_dispose_wk_val "Stock Wastage Each Week (Value in USD PPP) in W3"
label var W3_dispose_wk_propsales "Stock Wastage Each Week (Proportion of Sales) in W3"



foreach w in W1 W3 W4 {
		winsor2 `w'_sales_lastmth, cuts(1 99) suffix(_w1)
		winsor2 `w'_sales_lastmth, cuts(2.5 97.5) suffix(_w25)
		winsor2 `w'_sales_lastmth, cuts(5 95) suffix(_w5)
		g `w'_sales_lastmth_ln = ln(`w'_sales_lastmth)
		
		label var `w'_sales_lastmth_w1 "Sales Last Month in USD PPP (win 1)% at `w'" 
		label var `w'_sales_lastmth_w25 "Sales Last Month in USD PPP (win 2.5%) at `w'" 
		label var `w'_sales_lastmth_w5 "Sales Last Month in USD PPP (win 5%) at `w'" 
		label var `w'_sales_lastmth_ln "Sales Last Month in USD PPP (Log) at `w'"
		}

foreach w in W3 W4 {
	label var `w'_prof_lastmth "Profits Last Month in USD PPP at `w'" 
	label var `w'_prof_calc "Calculated Profits Last Month in USD PPP at `w'" 
	label var `w'_prof_est "Estimated Profits Last Month in USD PPP at `w'"
	label var `w'_prof_comp3 "Monthly Profits in USD PPP"
}

foreach var in prof_lastmth prof_calc prof_est prof_comp3  {
	
	foreach w in W1 W3 W4 {
	
		winsor2 `w'_`var', cuts(1 99) suffix(_w1)
		winsor2 `w'_`var', cuts(2.5 97.5) suffix(_w25)
		winsor2 `w'_`var', cuts(5 95) suffix(_w5)
		gen `w'_`var'_ihs = ln(`w'_`var' + sqrt((`w'_`var'*`w'_`var') + 1))
		local label_`var': var label `w'_`var'
		label var `w'_`var'_w1	"`label_`var'' (win 1%)"
		label var `w'_`var'_w25	"`label_`var'' (win 2.5%)"
		label var `w'_`var'_w5	"`label_`var'' (win 5%)"
		label var `w'_`var'_ihs	"`label_`var'' (IHS)"
		
	}
}


foreach w in W3 W4 {
	label var `w'_expense_total "Total Expenses Last Month in USD PPP" 
	label var `w'_expense_stockup "Stock Up Expenses Last Month in USD PPP" 
	label var `w'_expense_rent "Rent Expenses Last Month in USD PPP" 
	label var `w'_expense_electric "Electric Expenses Last Month in USD PPP" 
	label var `w'_expense_transport "Transport Expenses Last Month in USD PPP" 
	label var `w'_expense_other "Other Expenses Last Month in USD PPP"
} 

foreach var in expense_total expense_stockup expense_wage expense_rent expense_electric expense_transport /*expense_tax expense_phone expense_advert expense_preman expense_police*/ expense_other {
	
	foreach w in W1 W3 W4 {
	
		winsor2 `w'_`var', cuts(1 99) suffix(_w1)
		winsor2 `w'_`var', cuts(2.5 97.5) suffix(_w25)
		winsor2 `w'_`var', cuts(5 95) suffix(_w5)
		gen `w'_`var'_ihs = ln(W1_`var' + sqrt((W1_`var'*W1_`var') + 1))
		gen `w'_`var'_ln = ln(W1_`var')
		local label_`var': var label `w'_`var'
		label var `w'_`var'_w1	"`label_`var'' (win 1%)"
		label var `w'_`var'_w25	"`label_`var'' (win 2.5%)"
		label var `w'_`var'_w5	"`label_`var'' (win 5%)"
		label var `w'_`var'_ihs	"`label_`var'' (IHS)"
		label var `w'_`var'_ln	"`label_`var'' (Log)"	
		
		}

}


foreach w in W3 W4 {

	label var `w'_labour_total "Total Employees at `w'" 
	label var `w'_custom_total "Total Daily Customers at `w'"
	label var `w'_labour_fam "Total Family Employees at `w'"
	label var `w'_labour_nonfam "Total Non-Family Employees at `w'" 
	label var `w'_size "Shop Size at `w'" 

	label var `w'_MW_score_total "MW Aggregate Score at `w'" 
	label var `w'_MW_M_score_total "MW Marketing Subscore at `w'"
	label var `w'_MW_B_score_total "MW Stocking Up Subscore at `w'"
	label var `w'_MW_R_score_total "MW Record Keeping Subscore at `w'"
	label var `w'_MW_F_score_total "MW Financial Planning Subscore at `w'"

	label var `w'_credit_TC "Offered Credit or Delayed Payments to Customers at `w'" 
	label var `w'_loan_applied "Applied for Business Loan at `w'" 
	label var `w'_loan_outstanding "Obtained Business Loan at `w'" 
	
	gen `w'_loan_amt_ln=ln(`w'_loan_amt+1)
	label var `w'_loan_amt_ln "Log of Outstanding Loan Amount at `w'"


}



*** AM/BM Dummies

foreach x in	MW_score_total asp12_shop_z asp_shop_z asp12_sales {	

				cap drop W1_`x'_AM 
				cap drop W1_`x'_BM
				
				egen W1_`x'_md 		= median(W1_`x')
				gen W1_`x'_AM 		= (W1_`x'>W1_`x'_md) if !missing(W1_`x')
				gen W1_`x'_BM 		= 1 - W1_`x'_AM
				
}

*Interactions for hetero effects
gen BMscore=1-W1_MW_score_total_abovemd
gen female=1-W1_male
gen AMasp=W1_asp12_shop_z_AM
gen BMasp=1-AMasp
gen AMasp2=W1_asp_shop_z_AM
gen BMasp2=1-AMasp2
gen AMaspsales=W1_asp12_sales_AM 
gen ifail=W1_imagine_fail

foreach var in B BM BC BMC {
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

foreach var in size employee customer {

	foreach w in W1 W3 W4 {
		gen `w'_`var'diff = `w'_asp_`var' - `w'_asp12_`var'
	}
}

foreach var in 	size labour_total labour_nonfam custom_total sizediff employeediff customerdiff asp18_prof asp_minprof ///
				aspgap18_prof asp12_size asp12_employee asp12_customer asp12_sales asp_size asp_employee asp_customer ///
				aspgap12_size aspgap12_employee aspgap12_customer aspgap12_sales aspgap_size aspgap_employee aspgap_customer {
				
				foreach w in W1 W3 W4 {
					winsor2 `w'_`var', cuts(1 99) suffix(_w1)
					winsor2 `w'_`var', cuts(2.5 97.5) suffix(_w25)
					winsor2 `w'_`var', cuts(5 95) suffix(_w5)
					g `w'_`var'_ihs = ln(`w'_`var' + sqrt((`w'_`var'*`w'_`var') + 1))
					g `w'_`var'_ln = ln(`w'_`var')
				}
}


***** Locals *******************************************************************


* Treatment Variables
local x_treatment			B BM BC BMC

* Take-up for TOT estimates
local takeup				B_takeup BM_takeup BC_takeup BMC_takeup

* Strata Controls
local controls 				W1_male W1_space_ord W1_MW_score_total_abovemd


* Core business practices (returns to adoption information)
*local MWPractices			MW_score_total MW_M_score_total MW_B_score_total MW_R_score_total MW_F_score_total
local Marketingcore			Mcore MWM4_askcustomquit discount prods_new_1 MWM3_askcustomprod MWM6_attrcustomdisc    
local Marketingother		Mother MWM2_visitcompetprod compsales_compet MWM5_asksupplprod MWM7_advert 

local RecordKeepingcore		Rcore MWR1_recwritten MWR8_recloan rec_accreccustom_TC separatefin MWR2_recpurchsale rec_ledger startrec_lastyr rec_sales rec_weekly rec_stockup rec_pricesuppliers  rec_accpayloan profcalc_any MWR5_costprods profcalc_any_wk      
local RecordKeepingother	Rother MWR3_recliquid MWR4_recsalesprods MWR6_profprods MWR7_recexpensemth MWF4_expensenextyr MWF5_proflossyr MWF8_incexpenseyr  

local Decisions				DAGG discuss_any jointdec_any 

local Stockup				SAGG stockup_comp dispose_wk_propsales inventory_change_prof rec_stockup MWB1_negosupplprice MWB2_compsupplprod 

local Planning				PAGG MWF1_finperform MWF2_settargetyr MWF3_comptargetmth

local mainscores			Mcore Rcore DAGG SAGG PAGG



* Business practices in past and next 12 months
local Past12				cutcosts_lastyr changesupplier_lastyr prodquality_lastyr newbrand_lastyr newbranch_lastyr delegate_lastyr bisplan_lastyr startrec_lastyr loan_lastyr coopcompet_lastyr vat_lastyr
local Next12				cutcosts_nextyr changesupplier_nextyr prodquality_nextyr newbrand_nextyr newbranch_nextyr delegate_nextyr bisplan_nextyr startrec_nextyr loan_nextyr coopcompet_nextyr vat_nextyr
				
* Business performance
local Profits				prof_est_w1 prof_est_w25 prof_est_w5 /*prof_est_ihs*/
local Sales					sales_lastmth_w1 sales_lastmth_w25 sales_lastmth_w5 sales_lastmth_ln    
local Expenses				expense_total_w1 expense_total_w25 expense_total_w5 expense_total_ln 
local Size					size_w1 labour_total_w1 labour_nonfam_w1 labour_fam labour_nonfam size /*labour_ft labour_pt*/   
local Customers				custom_total_w1 custom_loyal custom_general /*custom_avgpurch */
local Credit				credit_TC loan_applied loan_outstanding loan_amt_ln    
local IndivExpenses			expense_stockup_w1 expense_wage_w1 expense_rent_w1 ///
							expense_electric_w1 expense_transport_w1 expense_other_w1
							/*expense_tax_w1 expense_phone_w1 expense_advert_w1
							expense_preman_w1 expense_police_w1*/
local mainperf				size_w1 labour_total_w1 labour_nonfam_w1 custom_total_w1 sales_lastmth_w5 prof_est_w5
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


* Outcomes for TE estimation (insert desired outcomes here)
local dims				aspfail asp asp12 mainperf mainscores /* asp18 Profits Sales RecordKeepingcore Marketingcore aspdiff aspgap18 aspgap12 aspgap psych*/
						/*Expenses Size Customers Credit ///
						RecordKeepingother Marketingother Decisions Stockup Planning ///
							 
							*/ 

						 
/***** Intent-to-treat estimates (ITT)

set more off 

* Estimation 

local i = 1
local m = 1

foreach w in W3 W4 {

	foreach this_dim in `dims' {
	
		est drop _all
	
		foreach var in ``this_dim'' {

			* Generating Dummies for missing BL vars 
			cap drop W1_`var'_m 
			cap drop W1b_`var'
	
			gen W1_`var'_m = (W1_`var'==.) if W3_`var'!=. 
			gen W1b_`var' = W1_`var'
			replace W1b_`var'= 5 if W1_`var'_m == 1
		
			/*
			*ITT - Saturated With No Controls
			display "ITT: NO CONTROLS"
			reg `w'_`var' `x_treatment', robust
			est sto T`m'_`w'_`this_dim'_`i'
			estadd ysumm
			test B-BM=0
			estadd scalar f1 = r(p)
			test B-BC=0
			estadd scalar f2 = r(p)
			test B-BMC=0
			estadd scalar f3 = r(p)
			test BM-BC=0
			estadd scalar f4 = r(p)
			sum `w'_`var' if control==1
			estadd scalar mean = r(mean)
			estadd scalar sd = r(sd)
			local ++i
						
			*ITT - Saturated With BL Dep Variable
			display "ITT: CONTROL FOR BL DEP VAR"
			reg `w'_`var' `x_treatment' W1b_`var' W1_`var'_m, robust
			est sto T`m'_`w'_`this_dim'_`i'
			estadd ysumm
			test B-BM=0
			estadd scalar f1 = r(p)
			test B-BC=0
			estadd scalar f2 = r(p)
			test B-BMC=0
			estadd scalar f3 = r(p)
			test BM-BC=0
			estadd scalar f4 = r(p)
			sum `w'_`var' if control==1
			estadd scalar mean = r(mean)
			estadd scalar sd = r(sd)
			local ++i
			*/
		
			*ITT - Saturated With BL Dep Variable and Strata Controls
			display "ITT: CONTROL FOR BL DEP VAR AND STRATA"
			areg `w'_`var' `x_treatment' W1b_`var' W1_`var'_m `controls' if `w'_finished==1, absorb(W1_village) robust
			est sto T`m'_`w'_`this_dim'_`i'
			estadd ysumm
			test B-BM=0
			estadd scalar f1 = r(p)
			test B-BC=0
			estadd scalar f2 = r(p)
			test B-BMC=0
			estadd scalar f3 = r(p)
			test BM-BC=0
			estadd scalar f4 = r(p)
			test BM+BC=BMC
			local sign = sign(_b[BMC]-_b[BM]-_b[BC])
			estadd scalar f5 = ttail(r(df_r),`sign'*sqrt(r(F)))
			sum `w'_`var' if control==1
			estadd scalar mean = r(mean)
			estadd scalar sd = r(sd)
			local ++i

		}
	
	capture erase "csv\peer learning\treatment effects\T`m'_`w'_`this_dim'_ITT.tex"
	capture erase "csv\peer learning\treatment effects\T`m'_`w'_`this_dim'_ITT.csv"

	* Tex and csv output
	#delimit ;
		esttab T`m'_`w'_`this_dim'_* using "csv\peer learning\treatment effects\T`m'_`w'_`this_dim'_ITT.csv", label replace modelwidth(16) varwidth(50) depvar legend 
		cells(b(star fmt(%9.3f))) se(par) starlevels(* 0.10 ** 0.05 *** 0.01) 
		stats(r2 N mean sd f1 f2 f3 f4, fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) labels("R-squared" "N" "Dependent Variable Mean in Control Group" "Dependent Variable SD in Control Group" "F-test (p-value): Book = Book & Movie" "F-test (p-value): Book = Book & Assistance" "F-test (p-value): Book = Book & Movie & Assistance" "F-test (p-value): Book & Movie = Book & Assistance"))
		style(tex) booktabs wrap title("`e(title)' of `this_dim' variables on treatment") eform keep(B*);
		esttab T`m'_`w'_`this_dim'_* using "csv\peer learning\treatment effects\T`m'_`w'_`this_dim'_ITT.csv", label replace modelwidth(16) varwidth(50) depvar legend 
		cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
		stats(r2 N mean sd f1 f2 f3 f4 f5, fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) labels("R-squared" "N" "Dependent Variable Mean in Control Group" "Dependent Variable SD in Control Group" "F-test (p-value): Book = Book & Movie" "F-test (p-value): Book = Book & Assistance" "F-test (p-value): Book = Book & Movie & Assistance" "F-test (p-value): Book & Movie = Book & Assistance" "F-test (p-value): B & M + B & A > All Three"))
		title(`this_dim' Outcomes at First Endline (W3) and Second Endline (W4)) keep(B*);
	#delimit cr

		local ++m

	}

}

*/



/***** Treatment-on-the-treated estimates (TOT)


*** Estimation 
est drop _all
local i = 1
//local m = 1


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
			xi: ivreg2 `w'_`var' (`takeup' = `x_treatment') W1b_`var' W1_`var'_m `controls' i.W1_village if `w'_finished==1, robust
			est sto T`m'_`w'_`this_dim'_`i'
			estadd ysumm
			test B_takeup-BM_takeup=0
			estadd scalar f1 = r(p)
			test B_takeup-BC_takeup=0
			estadd scalar f2 = r(p)
			test B_takeup-BMC_takeup=0
			estadd scalar f3 = r(p)
			test BM_takeup-BC_takeup=0
			estadd scalar f4 = r(p)
			test BM_takeup+BC_takeup=BMC_takeup
			local sign = sign(_b[BMC_takeup]-_b[BM_takeup]-_b[BC_takeup])
			estadd scalar f5 = ttail(r(df_r),`sign'*sqrt(r(F)))
			sum `w'_`var' if control==1
			estadd scalar mean = r(mean)
			estadd scalar sd = r(sd)
			local ++i

		}
	
	
		* Tex and csv output
		capture erase "csv\peer learning\treatment effects\T`m'_`w'_`this_dim'_TOT.tex"
		capture erase "csv\peer learning\treatment effects\T`m'_`w'_`this_dim'_TOT.csv"

		#delimit ;
			esttab T`m'_`w'_`this_dim'_* using "csv\peer learning\treatment effects\T`m'_`w'_`this_dim'_TOT.tex", label replace modelwidth(16) varwidth(50) depvar legend 
			cells(b(star fmt(%9.3f))) se(par) starlevels(* 0.10 ** 0.05 *** 0.01) 
			stats(r2 N mean sd f0 f1 f2 f3, fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) labels("R-squared" "N" "Mean of Outcome in Control" "SD of Outcome in Control" "F-test: Book only = Book & Movie (p-value)" "F-test: Book only = Book & Assistance (p-value)" "F-test: Book only = Book, Movie & Assistance (p-value)"))
			style(tex) booktabs wrap title("`e(title)' of `this_dim'" variables on treatment) eform keep(B*);
			esttab T`m'_`w'_`this_dim'_* using "csv\peer learning\treatment effects\T`m'_`w'_`this_dim'_TOT.csv", label replace modelwidth(16) varwidth(50) depvar legend 
			cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
			stats(r2 N mean sd f1 f2 f3 f4 f5, fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) labels("R-squared" "N" "Dependent Variable Mean in Control Group" "Dependent Variable SD in Control Group" "F-test (p-value): Book = Book & Movie" "F-test (p-value): Book = Book & Assistance" "F-test (p-value): Book = Book & Movie & Assistance" "F-test (p-value): Book & Movie = Book & Assistance" "F-test (p-value): B & M + B & A > All Three"))
			title("`e(title)' of `this_dim'" variables on treatment) keep(B*);
		#delimit cr

		local ++m
		est drop _all

	}
}

*/



/****** Heterogeneous Treatment Effects
gen AMscore = W1_MW_score_total_abovemd
gen male = W1_male
gen shopspace = W1_space_ord


local hetero /*female BMscore AMasp2 AMaspsales ifail*/ AMasp2  

local hetero_male		B_male BM_male BC_male BMC_male
local hetero_female		B_female BM_female BC_female BMC_female

local hetero_AMscore	B_AMscore BM_AMscore BC_AMscore BMC_AMscore 
local hetero_BMscore	B_BMscore BM_BMscore BC_BMscore BMC_BMscore 

local hetero_AMasp		B_AMasp BM_AMasp BC_AMasp BMC_AMasp AMasp 
local hetero_BMasp		B_BMasp BM_BMasp BC_BMasp BMC_BMasp BMasp 
local hetero_AMasp2		B_AMasp2 BM_AMasp2 BC_AMasp2 BMC_AMasp2 AMasp2 
local hetero_BMasp2		B_BMasp2 BM_BMasp2 BC_BMasp2 BMC_BMasp2 BMasp2 
local hetero_AMaspsales	B_AMaspsales BM_AMaspsales BC_AMaspsales BMC_AMaspsales AMaspsales
local hetero_ifail		B_ifail BM_ifail BC_ifail BMC_ifail ifail


set more off 



/*
* Estimation 1 

local i = 1
//local m = 1

foreach w in W3 W4 {

	foreach this_dim in `dims' {
	
		est drop _all
	
		foreach var in ``this_dim'' {

			* Generating Dummies for missing BL vars 
			cap drop W1_`var'_m 
			cap drop W1b_`var'
		
			gen W1_`var'_m = (W1_`var'==.) if W3_`var'!=. 
			gen W1b_`var' = W1_`var'
			replace W1b_`var'= 5 if W1_`var'_m == 1
		
		
		
			*ITT - Saturated With BL Dep Variable and Strata Controls
		
			areg `w'_`var' `x_treatment' B_AMasp2 BM_AMasp2 BC_AMasp2 BMC_AMasp2 AMasp2 W1b_`var' W1_`var'_m `controls' if `w'__finished==1, absorb(W1_village) robust
			est sto T`m'_`w'_`this_dim'_`i'
			estadd ysumm
			test B + B_AMasp2=0
			estadd scalar f1 = r(p)
			test BM + BM_AMasp2=0
			estadd scalar f2 = r(p)
			test BC + BC_AMasp2=0
			estadd scalar f3 = r(p)
			test BMC + BMC_AMasp2=0
			estadd scalar f4 = r(p)
			sum W3_`var' if control==1
			estadd scalar mean = r(mean)
			estadd scalar sd = r(sd)
			local ++i
		
			areg `w'_`var' `x_treatment' B_AMscore BM_AMscore BC_AMscore BMC_AMscore W1b_`var' W1_`var'_m `controls' if `w'_finished==1, absorb(W1_village) robust
			est sto T`m'_`w'_`this_dim'_`i'
			estadd ysumm
			test B + B_AMscore=0
			estadd scalar f1 = r(p)
			test BM + BM_AMscore=0
			estadd scalar f2 = r(p)
			test BC + BC_AMscore=0
			estadd scalar f3 = r(p)
			test BMC + BMC_AMscore=0
			estadd scalar f4 = r(p)
			sum W3_`var' if control==1
			estadd scalar mean = r(mean)
			estadd scalar sd = r(sd)
			local ++i

			areg `w'_`var' `x_treatment' B_AMasp2 BM_AMasp2 BC_AMasp2 BMC_AMasp2 B_AMscore BM_AMscore BC_AMscore BMC_AMscore AMasp2 W1b_`var' W1_`var'_m `controls' if `w'_finished==1, absorb(W1_village) robust
			est sto T`m'_`w'_`this_dim'_`i'
			estadd ysumm
			test B + B_AMasp2=0
			estadd scalar f1 = r(p)
			test BM + BM_AMasp2=0
			estadd scalar f2 = r(p)
			test BC + BC_AMasp2=0
			estadd scalar f3 = r(p)
			test BMC + BMC_AMasp2=0
			estadd scalar f4 = r(p)
			test B + B_AMscore=0
			estadd scalar f5 = r(p)
			test BM + BM_AMscore=0
			estadd scalar f6 = r(p)
			test BC + BC_AMscore=0
			estadd scalar f7 = r(p)
			test BMC + BMC_AMscore=0
			estadd scalar f8 = r(p)
			sum W3_`var' if control==1
			estadd scalar mean = r(mean)
			estadd scalar sd = r(sd)
			local ++i

			
			/*
			display "ITT: CONTROL FOR BL DEP VAR AND STRATA"
			areg `w'_`var' `x_treatment' W1b_`var' W1_`var'_m `controls' if `w'_finished==1 & `v'==1, absorb(W1_village) robust
			est sto T`m'_`w'_`this_dim'_`i'
		
			estadd ysumm
			test B-BM=0
			estadd scalar f1 = r(p)
			test B-BC=0
			estadd scalar f2 = r(p)
			test B-BMC=0
			estadd scalar f3 = r(p)
			test BM-BC=0
			estadd scalar f4 = r(p)
			sum W3_`var' if control==1
			estadd scalar mean = r(mean)
			estadd scalar sd = r(sd)
			
			local ++i
		
			areg `w'_`var' `x_treatment' W1b_`var' W1_`var'_m `controls' if `w'_finished==1 & `v'==0, absorb(W1_village) robust
			est sto T`m'_`w'_`this_dim'_`i'
			estadd ysumm
			test B-BM=0
			estadd scalar f1 = r(p)
			test B-BC=0
			estadd scalar f2 = r(p)
			test B-BMC=0
			estadd scalar f3 = r(p)
			test BM-BC=0
			estadd scalar f4 = r(p)
			sum W3_`var' if control==1
			estadd scalar mean = r(mean)
			estadd scalar sd = r(sd)
			
			local ++i
*/
		
		}


	capture erase "csv\peer learning\treatment effects\T`m'_`w'_`this_dim'_hetero.csv"

	* output
	#delimit ;
		esttab T`m'_`w'_`this_dim'_* using "csv\peer learning\treatment effects\T`m'_`w'_`this_dim'_hetero.csv", label replace modelwidth(16) varwidth(50) depvar legend 
		cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
		stats(r2 N mean sd f1 f2 f3 f4, fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) labels("R-squared" "N" "Dependent Variable Mean in Control Group" "Dependent Variable SD in Control Group" "F-test (p-value): Book + Interaction" "F-test (p-value): Book & Movie + Interaction" "F-test (p-value): Book & Assistaince + Interaction" "F-test (p-value): All Three + Interaction"))
		title(`this_dim' Outcomes at First Endline (W3) and Second Endline (W4)) keep(B*);
	#delimit cr

		local ++m

	}
}

*/




		
* Estimation 2 

local i = 1
//local m = 1

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
			
				areg `w'_`var' `x_treatment' `hetero_`v'' W1b_`var' W1_`var'_m `controls' if `w'_finished==1, absorb(W1_village) robust
				est sto T`m'_`w'_`this_dim'_`i'
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
			/*	
				
				display "ITT: CONTROL FOR BL DEP VAR AND STRATA"
				areg `w'_`var' `x_treatment' W1b_`var' W1_`var'_m `controls' if `w'_finished==1 & `v'==1, absorb(W1_village) robust
				est sto T`m'_`w'_`this_dim'_`i'
				
				estadd ysumm
				test B-BM=0
				estadd scalar f1 = r(p)
				test B-BC=0
				estadd scalar f2 = r(p)
				test B-BMC=0
				estadd scalar f3 = r(p)
				test BM-BC=0
				estadd scalar f4 = r(p)
				sum W3_`var' if control==1 & `v'==1 
				estadd scalar mean = r(mean)
				estadd scalar sd = r(sd)
		
				local ++i
				
				areg `w'_`var' `x_treatment' W1b_`var' W1_`var'_m `controls' if `w'_finished==1 & `v'==0, absorb(W1_village) robust
				est sto T`m'_`w'_`this_dim'_`i'
				estadd ysumm
				test B-BM=0
				estadd scalar f1 = r(p)
				test B-BC=0
				estadd scalar f2 = r(p)
				test B-BMC=0
				estadd scalar f3 = r(p)
				test BM-BC=0
				estadd scalar f4 = r(p)
				sum W3_`var' if control==1 & `v'==0
				estadd scalar mean = r(mean)
				estadd scalar sd = r(sd)
				
				local ++i
		*/
		
			}

		}


	
	capture erase "csv\peer learning\treatment effects\T`m'_`w'_`this_dim'_hetero.csv"

	* output
	#delimit ;
		esttab T`m'_`w'_`this_dim'_* using "csv\peer learning\treatment effects\T`m'_`w'_`this_dim'_hetero.csv", label replace modelwidth(16) varwidth(50) depvar legend 
		cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
		stats(r2 N mean sd f1 f2 f3 f4, fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) labels("R-squared" "N" "Dependent Variable Mean in Control Group" "Dependent Variable SD in Control Group" "F-test (p-value): Book + Interaction" "F-test (p-value): Book & Movie + Interaction" "F-test (p-value): Book & Assistaince + Interaction" "F-test (p-value): All Three + Interaction"))
		title(`this_dim' Outcomes at First Endline (W3) and Second Endline (W4)) keep(B*);
	#delimit cr

	local ++m

	}
}




