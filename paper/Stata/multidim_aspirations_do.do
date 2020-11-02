
********************************************************************************
************** 		MULTIDIMENSIONAL ASPIRATION		****************
*
*				            Main analysis do-file
*		
********************************************************************************

/*
Julius's Notes:

The do files are: multidim_asps_analysis for the main analysis and multidim_asps_descriptives for the first tables on
balance, compliance, and attrition. 

For the heterogenous effects, we used a dummy of below/above-median aggregate short-term shop aspirations at baseline 
(variable name: W1_asp12_shop_z) for firm performance, education aspirations, and self-reported satisfaction as the outcome. 
When the outcome was one of the aspirations dimensions, we did not use the aggregate aspirations but used a dummy of 
below/above-median aspirations of the respective dimension (e.g., W1_asp12_employee, W1_asp_customer, etc.). That is why all 
but the the first loop, where the HTEs with aspirations dimensions as the outcome are computed, use the content of the local 
"hte" in which the heterogenous variables are determined. For the moment this local contains both short-term and long-term 
aggregate shop aspirations as we initially ran the analysis with both as the hetero variable.

*/




set matsize 11000
clear all
set more off

cd "C:\Users\pdalton\Dropbox\Indonesia Analysis Patricio"

log using "hetero_aspirations.txt", text replace

***REGRESSION TABLES***

use "Data\Analysis_data.dta", clear
set more off

*** VARIABLE PREP ***

*MANAGEMENT PRACTICES


	
* Marketing sub-score

*M&W Practice Scores

foreach var in W4 W3 W1 {

drop `var'_MW_M_score_total `var'_MW_R_score_total `var'_MW_F_score_total `var'_MW_B_score_total `var'_MW_score_total 

* Marketing sub-score
egen `var'_MW_M_score_total 	= rowmean(`var'_MWM1_visitcompetprice `var'_MWM2_visitcompetprod `var'_MWM3_askcustomprod  ///
								  `var'_MWM4_askcustomquit `var'_MWM5_asksupplprod `var'_MWM6_attrcustomdisc `var'_MWM7_advert)

* Record sub-score
egen `var'_MW_R_score_total 	= rowmean(`var'_MWR1_recwritten `var'_MWR2_recpurchsale `var'_MWR3_recliquid `var'_MWR4_recsalesprods /*MWR5_costprods*/ ///
								  `var'_MWR6_profprods `var'_MWR7_recexpensemth `var'_MWR8_recloan)

* Planning sub-score
egen `var'_MW_F_score_total 	= rowmean(`var'_MWF1_finperform `var'_MWF2_settargetyr `var'_MWF3_comptargetmth `var'_MWF4_expensenextyr `var'_MWF5_proflossyr ///
								  `var'_MWF6_cashflowyr `var'_MWF7_balanceyr `var'_MWF8_incexpenseyr)

* Stock sub-score
egen `var'_MW_B_score_total 	= rowmean(`var'_MWB1_negosupplprice `var'_MWB2_compsupplprod `var'_MWB3_notOOS)
							

* Aggregate score
egen `var'_MW_score_total = rowmean(`var'_MWM1_visitcompetprice `var'_MWM2_visitcompetprod `var'_MWM3_askcustomprod  ///
									`var'_MWM4_askcustomquit `var'_MWM5_asksupplprod `var'_MWM6_attrcustomdisc `var'_MWM7_advert ///
									`var'_MWR1_recwritten `var'_MWR2_recpurchsale `var'_MWR3_recliquid `var'_MWR4_recsalesprods /*MWR5_costprods*/ ///
									`var'_MWR6_profprods `var'_MWR7_recexpensemth `var'_MWR8_recloan /// 
									`var'_MWF1_finperform `var'_MWF2_settargetyr `var'_MWF3_comptargetmth `var'_MWF4_expensenextyr `var'_MWF5_proflossyr ///
									`var'_MWF6_cashflowyr `var'_MWF7_balanceyr `var'_MWF8_incexpenseyr ///
									`var'_MWB1_negosupplprice `var'_MWB2_compsupplprod `var'_MWB3_notOOS)
}	








*Enhanced Practice Scores (M&W + additional questions) 

/*
foreach var in W3 W1 {
egen `var'_Mcore = rowmean(`var'_MWM4_askcustomquit `var'_discount `var'_prods_new_1 `var'_MWM3_askcustomprod `var'_MWM6_attrcustomdisc)
egen `var'_Mother	= rowmean(`var'_MWM2_visitcompetprod `var'_compsales_compet `var'_MWM5_asksupplprod `var'_MWM7_advert) 
egen `var'_Rcore = rowmean(`var'_MWR1_recwritten `var'_MWR8_recloan `var'_rec_accreccustom_TC `var'_separatefin `var'_MWR2_recpurchsale `var'_rec_ledger `var'_startrec_lastyr `var'_rec_sales `var'_rec_weekly `var'_rec_stockup `var'_rec_pricesuppliers `var'_rec_accpayloan `var'_profcalc_any `var'_MWR5_costprods `var'_profcalc_any_wk)
egen `var'_Rother	= rowmean(`var'_MWR3_recliquid `var'_MWR4_recsalesprods `var'_MWR6_profprods `var'_MWR7_recexpensemth `var'_MWF4_expensenextyr `var'_MWF5_proflossyr `var'_MWF8_incexpenseyr)
egen `var'_DAGG	= rowmean(`var'_discuss_any `var'_jointdec_any) 
egen `var'_PAGG = rowmean(`var'_MWF1_finperform `var'_MWF2_settargetyr `var'_MWF3_comptargetmth)
egen `var'_SAGG = rowmean(`var'_stockup_comp `var'_inventory_change_prof `var'_rec_stockup `var'_MWB1_negosupplprice `var'_MWB2_compsupplprod)
}
*/

*Comparable Practices Across W3 and W4 (Not all questions were asked in W4)
foreach var in W4 W3 W1 {
*egen `var'_Mcoreb = rowmean(`var'_MWM4_askcustomquit `var'_discount `var'_prods_new_1 `var'_MWM3_askcustomprod `var'_MWM6_attrcustomdisc)
*egen `var'_Motherb	= rowmean(`var'_MWM2_visitcompetprod `var'_compsales_compet `var'_MWM5_asksupplprod `var'_MWM7_advert) 
*egen `var'_Rcoreb = rowmean(`var'_MWR1_recwritten `var'_MWR8_recloan `var'_separatefin `var'_MWR2_recpurchsale `var'_rec_ledger `var'_startrec_lastyr)
*egen `var'_Rotherb	= rowmean(`var'_MWR3_recliquid `var'_MWR4_recsalesprods `var'_MWR6_profprods `var'_MWR7_recexpensemth `var'_MWF4_expensenextyr `var'_MWF5_proflossyr `var'_MWF8_incexpenseyr)
egen `var'_MarketingAgg = rowmean(`var'_MWM4_askcustomquit `var'_discount `var'_MWM6_attrcustomdisc `var'_prods_new_1)
egen `var'_RecordKeepingAgg = rowmean(`var'_MWR1_recwritten `var'_MWR2_recpurchsale `var'_startrec_lastyr `var'_MWR3_recliquid `var'_MWR8_recloan) 
egen `var'_DiscussionAgg	= rowmean(`var'_discuss_nonfam `var'_discuss_fam `var'_jointdec_any `var'_jointdec_agree) 
egen `var'_PlanningAgg = rowmean(`var'_MWF1_finperform `var'_MWF4_expensenextyr `var'_MWF3_comptargetmth)
egen `var'_StockupAgg = rowmean(`var'_stockup_neverlate `var'_inventory_change_prof `var'_MWB1_negosupplprice `var'_MWB2_compsupplprod)
egen `var'_PracticesAgg = rowmean(`var'_MWM4_askcustomquit `var'_discount `var'_MWM6_attrcustomdisc `var'_prods_new_1 ///
								  `var'_MWR1_recwritten `var'_MWR2_recpurchsale `var'_startrec_lastyr `var'_MWR3_recliquid `var'_MWR8_recloan ///
								  `var'_MWF1_finperform `var'_MWF4_expensenextyr `var'_MWF3_comptargetmth ///
								  `var'_stockup_neverlate `var'_inventory_change_prof `var'_MWB1_negosupplprice `var'_MWB2_compsupplprod)
egen `var'_OthersAgg = rowmean(`var'_MWM2_visitcompetprod `var'_MWM5_asksupplprod `var'_MWM7_advert ///
									   `var'_MWR6_profprods `var'_MWF5_proflossyr `var'_MWF6_cashflowyr `var'_MWF7_balanceyr `var'_MWF8_incexpenseyr)
								  
}


*SALES AND PROFITS
foreach var in W1_sales_lastmth W3_sales_lastmth W4_sales_lastmth {
winsor2 `var', cuts(1 99) suffix(_w1)
winsor2 `var', cuts(2.5 97.5) suffix(_w25)
winsor2 `var', cuts(5 95) suffix(_w5)
g `var'_ihs = ln(`var' + sqrt((`var'*`var') + 1))
g `var'_ln = ln(`var')
}

foreach var in W1_prof_lastmth W3_prof_lastmth W4_prof_lastmth W1_prof_calc W3_prof_calc W4_prof_calc W1_prof_est W3_prof_est W4_prof_est W1_prof_comp3 W3_prof_comp3 W4_prof_comp3   {
winsor2 `var', cuts(1 99) suffix(_w1)
winsor2 `var', cuts(2.5 97.5) suffix(_w25)
winsor2 `var', cuts(5 95) suffix(_w5)
g `var'_ihs = ln(`var' + sqrt((`var'*`var') + 1))
g `var'_ln = ln(`var')
}


*EXPENSES
foreach var in expense_total expense_stockup expense_wage expense_rent expense_electric expense_transport /*expense_tax expense_phone expense_advert expense_preman expense_police*/ expense_other {
winsor2 W1_`var', cuts(1 99) suffix(_w1)
winsor2 W3_`var', cuts(1 99) suffix(_w1)
winsor2 W4_`var', cuts(1 99) suffix(_w1)

winsor2 W1_`var', cuts(2.5 97.5) suffix(_w25)
winsor2 W3_`var', cuts(2.5 97.5) suffix(_w25)
winsor2 W4_`var', cuts(2.5 97.5) suffix(_w25)

winsor2 W1_`var', cuts(5 95) suffix(_w5)
winsor2 W3_`var', cuts(5 95) suffix(_w5)
winsor2 W4_`var', cuts(5 95) suffix(_w5)

g W1_`var'_ihs = ln(W1_`var' + sqrt((W1_`var'*W1_`var') + 1))
g W3_`var'_ihs = ln(W3_`var' + sqrt((W3_`var'*W3_`var') + 1))
g W4_`var'_ihs = ln(W4_`var' + sqrt((W4_`var'*W4_`var') + 1))

g W1_`var'_ln = ln(W1_`var' + 1)
g W3_`var'_ln = ln(W3_`var' + 1)
g W4_`var'_ln = ln(W4_`var' + 1)
}


*LOANS AND CREDIT
foreach var in W3 W4 W1 {
gen `var'_loan_amt_ln=ln(`var'_loan_amt+1)
}


*ASPIRATIONS 
foreach var in size employee customer {
gen W1_`var'diff = W1_asp_`var' - W1_asp12_`var'
gen W3_`var'diff = W3_asp_`var' - W3_asp12_`var'
gen W4_`var'diff = W4_asp_`var' - W4_asp12_`var'
}

foreach var in size labour_total custom_total sizediff employeediff customerdiff asp18_prof asp_minprof aspgap18_prof asp12_shop_z asp_shop_z asp12_size asp12_employee asp12_customer asp12_sales asp_size asp_employee asp_customer aspgap12_size aspgap12_employee aspgap12_customer aspgap12_sales aspgap_size aspgap_employee aspgap_customer {
winsor2 W1_`var', cuts(1 99) suffix(_w1)
winsor2 W3_`var', cuts(1 99) suffix(_w1)
winsor2 W4_`var', cuts(1 99) suffix(_w1)

winsor2 W1_`var', cuts(2.5 97.5) suffix(_w25)
winsor2 W3_`var', cuts(2.5 97.5) suffix(_w25)
winsor2 W4_`var', cuts(2.5 97.5) suffix(_w25)

winsor2 W1_`var', cuts(5 95) suffix(_w5)
winsor2 W3_`var', cuts(5 95) suffix(_w5)
winsor2 W4_`var', cuts(5 95) suffix(_w5)

g W1_`var'_ihs = ln(W1_`var' + sqrt((W1_`var'*W1_`var') + 1))
g W3_`var'_ihs = ln(W3_`var' + sqrt((W3_`var'*W3_`var') + 1))
g W4_`var'_ihs = ln(W4_`var' + sqrt((W4_`var'*W4_`var') + 1))

g W1_`var'_ln = ln(W1_`var')
g W3_`var'_ln = ln(W3_`var')
g W4_`var'_ln = ln(W4_`var')
}







*Interactions for hetero effects
gen AMscore=W1_MW_score_total_abovemd
gen BMscore=1-W1_MW_score_total_abovemd
gen male=W1_male
gen female=1-W1_male
gen shopspace = W1_space_ord
gen AMasp=W1_asp12_AM
gen BMasp=1-AMasp
gen AMasp2=W1_asp_AM
gen BMasp2=1-AMasp2
gen AMaspsales=W1_asp12_sales_AM 
gen ifail=W1_imagine_fail
gen pfail=W1_asp_yrs_fail

foreach var in book_only book_mov book_ast book_mov_ast {
gen `var'_male=`var'*W1_male
gen `var'_female=`var'*female
gen `var'_BMscore=`var'*BMscore
gen `var'_AMscore=`var'*AMscore
gen `var'_shopspace=`var'*shopspace
gen `var'_AMasp=`var'*AMasp
gen `var'_AMasp2=`var'*AMasp2
gen `var'_AMaspsales=`var'*AMaspsales
gen `var'_ifail=`var'*ifail
gen `var'_BMasp=`var'*BMasp
gen `var'_BMasp2=`var'*BMasp2
gen `var'_pfail=`var'*pfail
}




***ANALYSIS***

***** Locals *******************************************************************


* Treatment Variables
local x_treatment			book_only book_mov book_ast book_mov_ast


* Take-up for TOT estimates
local takeup				book_only_takeup book_mov_takeup book_ast_takeup book_mov_ast_takeup


* Strata Controls
local controls 				W1_male W1_space_ord W1_MW_score_total_abovemd
local heterocontrols		female shopspace BMscore

* Other Baseline Controls
local xvars1	W1_male W1_age_manager W1_educ W1_risk_comp W1_time_comp ///
				W1_size W1_age_firm W1_formal_tax W1_labour_total ///
				W1_sales_lastmth_ln W1_prof_est_ihs  ///
				W1_PracticesAgg 	
				
local ifailcontrols W1_age_firm W1_labour_total W1_prof_est_ihs W1_loan_lastyr W1_asp_cse W1_PracticesAgg
				
				

* Management Practices
local MWPractices			MW_score_total MW_M_score_total MW_R_score_total MW_F_score_total MW_B_score_total 

local MWM					MW_M_score_total MWM1_visitcompetprice MWM2_visitcompetprod MWM3_askcustomprod ///
							MWM4_askcustomquit MWM5_asksupplprod ///
							MWM6_attrcustomdisc MWM7_advert

local MWR					MW_R_score_total MWR1_recwritten MWR2_recpurchsale ///
							MWR3_recliquid MWR4_recsalesprods /*MWR5_costprods*/ ///
							MWR6_profprods MWR7_recexpensemth MWR8_recloan

local MWF					MW_F_score_total MWF1_finperform MWF2_settargetyr ///
							MWF3_comptargetmth MWF4_expensenextyr MWF5_proflossyr ///
							MWF6_cashflowyr MWF7_balanceyr MWF8_incexpenseyr

local MWB					MW_B_score_total MWB1_negosupplprice MWB2_compsupplprod MWB3_notOOS

local Practices				PracticesAgg MarketingAgg RecordKeepingAgg DiscussionAgg PlanningAgg StockupAgg

local Marketing				MarketingAgg MWM4_askcustomquit discount MWM6_attrcustomdisc prods_new_1

local RecordKeeping			RecordKeepingAgg MWR1_recwritten MWR2_recpurchsale startrec_lastyr MWR3_recliquid MWR8_recloan       	  

local Discussion			/*DiscussionAgg*/ discuss_fam discuss_nonfam jointdec_any jointdec_agree 

local Planning				PlanningAgg MWF1_finperform MWF4_expensenextyr MWF3_comptargetmth 
							
local Stockup				StockupAgg stockup_neverlate inventory_change_prof MWB1_negosupplprice MWB2_compsupplprod 

local OtherPractices		OthersAgg MWM2_visitcompetprod MWM5_asksupplprod MWM7_advert ///
							MWR6_profprods MWF5_proflossyr MWF6_cashflowyr MWF7_balanceyr MWF8_incexpenseyr
								

local mainscores			MarketingAgg RecordKeepingAgg PlanningAgg StockupAgg DiscussionAgg  

*local FinLit				finlit_score

/*
* Business practices in past and next 12 months
local Past12				cutcosts_lastyr changesupplier_lastyr prodquality_lastyr newbrand_lastyr newbranch_lastyr delegate_lastyr bisplan_lastyr startrec_lastyr loan_lastyr coopcompet_lastyr vat_lastyr
local Next12				cutcosts_nextyr changesupplier_nextyr prodquality_nextyr newbrand_nextyr newbranch_nextyr delegate_nextyr bisplan_nextyr startrec_nextyr loan_nextyr coopcompet_nextyr vat_nextyr
*/
	
	
* Business Performance
local Profits				/*prof_est_w1 prof_est_w25*/ prof_est_w5 prof_est_ihs
local Sales					/*sales_lastmth_w1 sales_lastmth_w25*/ sales_lastmth_w5 sales_lastmth_ln /*sales_lastmth_ihs*/    
local Size					size labour_total labour_fam labour_nonfam /*labour_ft labour_pt*/   
local Customers				custom_total custom_total_ln custom_loyal custom_general /*custom_avgpurch*/ 
local perform				prof_est_w1 prof_est_w5 ///
							sales_lastmth_w1 sales_lastmth_w5
 
* Aspirations
local Asp12					asp12_shop_z asp12_size asp12_employee asp12_customer asp12_sales 
local Asp					asp_shop_z asp_size asp_employee asp_customer 
local Asp12_w5				asp12_shop_z_w5 asp12_size_w5 asp12_employee_w5 asp12_customer_w5 asp12_sales_w5
local Asp_w5				asp_shop_z_w5 asp_size_w5 asp_employee_w5 asp_customer_w5 

* Educational Aspirations 
local educasp	asp_educ_son /*aspgap_educ_son*/ asp_educ_son_ma ///
				asp_educ_dtr /*aspgap_educ_dtr*/ asp_educ_dtr_ma ///
				asp_educ_kids asp_educ_kids_ma /*aspgap_educ_kids*/

				
* Satisfaction (Add Variables Here!)
local satisfact	satisfact_life satisfact_fin


*******Outcomes for TE estimation (insert desired outcomes here)*******

local dims					Asp12 Asp
							 
local heterodims			Asp12 Asp mainscores perform
							  						 


*RESHAPING THE DATA SO EL1 (Wave 3) AND EL2 (Wave 4) ARE STACKED

rename W3_* *3
rename W4_* *4

drop *23

reshape long  ///
prof_est_w1 prof_est_w25 prof_est_w5 prof_est_ihs ///
prof_lastmth_w1 prof_lastmth_w5 ///
sales_lastmth_w1 sales_lastmth_w25 sales_lastmth_w5 sales_lastmth_ln sales_lastmth_ihs  ///
expense_total_w1 expense_total_w25 expense_total_w5 expense_total_ln expense_total_ihs ///
expense_stockup_ln expense_wage_ln expense_rent_ln ///
expense_electric_ln expense_transport_ln expense_other_ln ///
expense_stockup_ihs expense_wage_ihs expense_rent_ihs ///
expense_electric_ihs expense_transport_ihs expense_other_ihs ///
expense_stockup_w1 expense_wage_w1 expense_rent_w1 ///
expense_electric_w1 expense_transport_w1 expense_other_w1 ///
expense_stockup_w5 expense_wage_w5 expense_rent_w5 ///
expense_electric_w5 expense_transport_w5 expense_other_w5 ///
size labour_total labour_fam labour_nonfam labour_ft labour_pt    /// 
custom_total custom_total_ln custom_loyal custom_general ///
credit_TC loan_applied loan_outstanding loan_amt_ln ///
asp12_shop_z_w1 asp12_size_w1 asp12_employee_w1  asp12_customer_w1 asp12_sales_w1 asp12_sales_ln  ///
asp_shop_z_w1 asp_size_w1 asp_employee_w1  asp_customer_w1 ///
asp12_shop_z_w5 asp12_size_w5 asp12_employee_w5 asp12_customer_w5 asp12_sales_w5 ///
asp_shop_z_w5 asp_size_w5 asp_employee_w5 asp_customer_w5 ///
asp12_shop_z asp12_size asp12_employee  asp12_customer asp12_sales  ///
asp_shop_z asp_size asp_employee  asp_customer asp_cse ///
PracticesAgg ///
MarketingAgg discount prods_new_1 compsales_compet ///
RecordKeepingAgg separatefin startrec_lastyr ///
DiscussionAgg discuss_any discuss_fam discuss_nonfam jointdec_any jointdec_agree ///
PlanningAgg OthersAgg ///
StockupAgg stockup_comp stockup_neverlate stockout_never inventory_change_dem inventory_change_prof /// 
MW_score_total MW_M_score_total MW_B_score_total MW_R_score_total MW_F_score_total ///
MWM1_visitcompetprice MWM2_visitcompetprod MWM3_askcustomprod ///
MWM4_askcustomquit MWM5_asksupplprod MWM6_attrcustomdisc MWM7_advert ///
MWR1_recwritten MWR2_recpurchsale MWR3_recliquid MWR4_recsalesprods /*MWR5_costprods*/ ///
MWR6_profprods MWR7_recexpensemth MWR8_recloan ///
MWF1_finperform MWF2_settargetyr MWF3_comptargetmth MWF4_expensenextyr MWF5_proflossyr ///
MWF6_cashflowyr MWF7_balanceyr MWF8_incexpenseyr ///
MWB1_negosupplprice MWB2_compsupplprod MWB3_notOOS ///
dispose_wk dispose_wk_val dispose_wk_propsales inventory_change_demand ///
rec_weekly rec_stockup rec_pricesuppliers rec_accreccustom_TC rec_accpayloan ///
changesupplier_lastyr ///
profcalc_any profcalc_any_wk rec_sales rec_ledger ///
shop_clean shop_shelf_full shop_goods_prices ///
finished closed refused ///
,i(shop_ID) j(round)


label var finished "Completed Endline Survey"
label var closed "Business is Closed"
label var refused "Business Refused Survey"

label var PracticesAgg "Management Practices Aggregate Score"

label var MarketingAgg "Marketing Aggregate Score"
label var MWM4_askcustomquit "Consulted with Former Customers"
label var discount "Offered Discount to Loyal/Bulk Customers"
label var MWM6_attrcustomdisc "Introduced Special Sales Offers"
label var prods_new_1 "Offered a New Product to Customers"
label var MWM5_asksupplprod "Asked Suppliers about High Demand Products"
label var compsales_compet "Compared Sales Performance with Competitors"
label var MWM2_visitcompetprod "Observed Products for Sale at Competing Business"
label var MWM7_advert "Advertised the Business"

label var RecordKeepingAgg "Record Keeping Aggregate Score"
label var separatefin "Separated Business and Household Finances"
label var MWR1_recwritten "Kept Written Business Records"
label var MWR8_recloan "Have Records Needed to Obtain Business Loan"
label var MWR2_recpurchsale	"Recorded Every Purchase and Sale"
label var startrec_lastyr "Itemized Business Revenues and Expenses"
label var MWR3_recliquid	"Estimated Cash on Hand"
label var MWR6_profprods	"Identified Profit Contribution of Best Products"
label var MWF4_expensenextyr "Anticipated Budget for Upcoming Business Costs"
label var MWF5_proflossyr "Kept Annual Profit and Loss Statement"
label var MWF6_cashflowyr "Kept Annual Cash Flow Statement"
label var MWF7_balanceyr "Kept Annual Balance Sheet"
label var MWF8_incexpenseyr "Kept Annual Income and Expenses Statement"

/*
label var MWM3_askcustomprod	"Elicited Customer Demand for New Products"
label var MWM2_visitcompetprod "Observed Products for Sale at Competing Business"

label var rec_ledger "Kept Formal Business Ledger"
label var MWR7_recexpensemth	"Kept Monthly Business Budget"
*/

label var DiscussionAgg "Discussion Aggregate Score"
label var discuss_any "Discussed Business Matters with Others"
label var discuss_nonfam "Discussed Business Matters with Non-Family Members"
label var discuss_fam "Discussed Business Matters with Family Members"
label var jointdec_any "Made Joint Decisions on Business Matters"
label var jointdec_agree "Drafted an Agreement for Joint Decision-Making"

label var PlanningAgg "Planning Aggregate Score"
label var MWF1_finperform "Reviewed Financial Performance to Identify Areas of Improvement"
label var MWF2_settargetyr "Set Sales Target"
label var MWF3_comptargetmth "Compared Target vs. Actual Monthly Sales"
label var MWR4_recsalesprods "Compared Trends in Sales Across Products"

label var StockupAgg "Stock-Up Aggregate Score"
label var stockup_comp "Top Selling Products Always in Stock"
label var stockup_neverlate "Top Selling Products Always in Stock"
label var inventory_change_prof "Adjusted Stock Based on Product Profitability"
label var inventory_change_demand "Adjusted Stock Based on Consumer Demand"
label var MWB1_negosupplprice "Negotiated Lower Prices with a Supplier"
label var MWB2_compsupplprod "Compared Product Prices and Quality Across Suppliers"
label var MWB3_notOOS "Kept Stock Current Throughout Month"

label var OthersAgg "Other Business Practices Aggregate Score"

label var MW_score_total "MW Aggregate Score" 
label var MW_M_score_total "MW Marketing Subscore"
label var MW_R_score_total "MW Record Keeping Subscore"
label var MW_F_score_total "MW Financial Planning Subscore"
label var MW_B_score_total "MW Stocking Up Subscore"

/*

label var dispose_wk "Stock Wastage Each Week (Yes/No)"
label var dispose_wk_val "Stock Wastage Each Week (Value in USD)"
label var dispose_wk_propsales "Stock Wastage Each Week (Proportion of Sales)"
label var inventory_change_demand "Adjusted Stock Based on Consumer Demand (Yes/No)"
label var MWR5_costprods	"Calculated Cost of Sales for Main Products"
label var rec_weekly "Updated Records At Least Once a Week"
label var rec_stockup "Tracked Purchase of Stocks"
label var rec_pricesuppliers "Tracked Prices of Different Suppliers"
label var rec_accreccustom_TC "Recorded Credit to Customers"
label var rec_accpayloan "Tracked Loan Payments Due"
label var profcalc_any "Calculated Business Profits"
label var profcalc_any_wk "Updated Business Profits At Least Once a Week"
label var rec_sales "Tracked Product Sales"
*/

label var sales_lastmth_w1 "Sales Last Month (win 1)%" 
label var sales_lastmth_w25 "Sales Last Month (win 2.5%)" 
label var sales_lastmth_w5 "Sales Last Month (win 5%)" 
label var sales_lastmth_ln "Sales Last Month (Log)"

label var prof_est_w1 "Estimated Profits Last Month (win 1%)" 
label var prof_est_w25 "Estimated Profits Last Month (win 2.5%)" 
label var prof_est_w5 "Estimated Profits Last Month (win 5%)" 
label var prof_est_ihs "Estimated Profits Last Month (IHS Transformation)" 

label var expense_total_w1 "Total Expenses Last Month (win 1%)" 
label var expense_total_w25 "Total Expenses Last Month (win 2.5%)" 
label var expense_total_w5 "Total Expenses Last Month (win 5%)" 
label var expense_total_ln "Total Expenses Last Month (Log)" 
label var expense_total_ihs "Total Expenses Last Month (IHS Transformation)" 

label var expense_stockup_w1 "Stock Up Expenses Last Month (win 1%)" 
label var expense_wage_w1 "Wage Expenses Last Month (win 1%)" 
label var expense_rent_w1 "Rent Expenses Last Month (win 1%)" 
label var expense_electric_w1 "Electric Expenses Last Month (win 1%)" 
label var expense_transport_w1 "Transport Expenses Last Month (win 1%)" 
label var expense_other_w1 "Other Expenses Last Month (win 1%)" 

label var expense_stockup_ln "Stock Up Expenses Last Month (Log)" 
label var expense_wage_ln "Wage Expenses Last Month (Log)" 
label var expense_rent_ln "Rent Expenses Last Month (Log)" 
label var expense_electric_ln "Electric Expenses Last Month (Log)" 
label var expense_transport_ln "Transport Expenses Last Month (Log)" 
label var expense_other_ln "Other Expenses Last Month (Log)" 

label var expense_stockup_ihs "Stock Up Expenses Last Month (IHS)" 
label var expense_wage_ihs "Wage Expenses Last Month (IHS)" 
label var expense_rent_ihs "Rent Expenses Last Month (IHS)" 
label var expense_electric_ihs "Electric Expenses Last Month (IHS)" 
label var expense_transport_ihs "Transport Expenses Last Month (IHS)" 
label var expense_other_ihs "Other Expenses Last Month (IHS)" 

label var custom_total "Total Number of Customers"
label var custom_total_ln "Total Number of Customers (Log)"
label var custom_loyal "Total Number of Loyal Customers"
label var custom_general "Total Number of General Customers"

label var loan_amt_ln "Log of Outstanding Loan Amount"
label var credit_TC "Offered Credit or Delayed Payments to Customers" 
label var loan_applied "Applied for Business Loan" 
label var loan_outstanding "Obtained Business Loan" 

label var labour_total "Total Number of Employees" 
label var labour_fam "Total Number of Family Employees"
label var labour_nonfam "Total Number of Non-Family Employees" 
label var size "Shop Size in Square Meters" 

label var shop_clean "Shop is Clean and Tidy" 
label var shop_shelf_full "Shop is Well-Stocked"
label var shop_goods_prices "Prices are Clearly Marked"

label var asp12_size_w1 "Aspirations for Shop Size in Next 12 Months"
label var asp12_employee_w1 "Aspirations for Number of Employees in Next 12 Months"
label var asp12_customer_w1 "Aspirations for Number of Customers in Next 12 Months"
label var asp12_sales_ln "Aspirations for Sales (Log) in Next 12 Months"
label var asp12_sales_w1 "Aspirations for Sales in Next 12 Months"
 
label var asp_size_w1 "Aspirations for Shop Size"
label var asp_employee_w1 "Aspirations for Number of Employees"
label var asp_customer_w1 "Aspirations for Number of Customers" 
label var round "round"

label var W1_male "Respondent is Male" 
label var W1_age_manager "Respondent Age"
label var  W1_educ "Respondent Years of Education" 
label var W1_risk_comp "Respondent Risk Preference Score" 
label var W1_time_comp "Respondent Time Preference Score"
label var W1_age_firm "Age of Firm"  
label var W1_labour_total "Total Number of Employees" 
label var W1_sales_lastmth_w5 "Total Sales Last Month (USD PPP)"
label var W1_prof_est_w5 "Total Profits Last Month (USD PPP)" 
label var W1_sales_lastmth_ln "Total Sales Last Month (Log)"
label var W1_prof_est_ihs "Total Profits Last Month (IHS Transformation)" 

label var W1_size "Shop size (Sq. Meters)"
label var W1_PracticesAgg "Management Practices Aggregate Score"
label var W1_formal_tax "Firm has Tax ID"


*****REGRESSION ANALYSIS******



***** Intent-to-treat estimates (ITT)

set more off 

* Estimation 

local i = 1
local m = 1


foreach this_dim in `dims' {
	
	est drop _all
	
	foreach var in ``this_dim'' {

		* Generating Dummies for missing BL vars 
		cap drop W1_`var'_m 
		cap drop W1b_`var'
	
		gen W1_`var'_m = (W1_`var'==.) if `var'!=. 
		gen W1b_`var' = W1_`var'
		replace W1b_`var'= 5 if W1_`var'_m == 1
		
				
		*ITT - Saturated With BL Dep Variable and Strata Controls
		display "ITT: CONTROL FOR BL DEP VAR AND STRATA"
		areg `var' `x_treatment' W1b_`var' W1_`var'_m `controls' i.round if finished==1, absorb(W1_village) cluster(shop_ID) robust
		est sto T`m'_`this_dim'_`i'
		estadd ysumm
		test book_only-book_mov=0
		estadd scalar f1 = r(p)
		test book_only-book_ast=0
		estadd scalar f2 = r(p)
		test book_only-book_mov_ast=0
		estadd scalar f3 = r(p)
		test book_mov-book_ast=0
		estadd scalar f4 = r(p)
		test book_mov - book_mov_ast = 0
		estadd scalar f5 = r(p)
		*test book_mov+book_ast=book_mov_ast
		*local sign = sign(_b[book_mov_ast]-_b[book_mov]-_b[book_ast])
		*estadd scalar f5 = ttail(r(df_r),`sign'*sqrt(r(F)))
		sum `var' if control==1 & round==3
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
		
	}
	
capture erase "Aspirations\Excel Output\T`m'_`this_dim'_ITT.csv"

* csv output
#delimit ;
	esttab T`m'_`this_dim'_* using "Aspirations\Excel Output\T`m'_`this_dim'_ITT.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N mean sd f1 f2 f3 f4 f5, fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) labels("R-squared" "N" "Dependent Variable Mean in Control Group" "Dependent Variable SD in Control Group" "F-test (p-value): Book = Book & Movie" "F-test (p-value): Book = Book & Assistance" "F-test (p-value): Book = All Three" "F-test (p-value): Book & Movie = Book & Assistance" "F-test (p-value): Book & Move = All Three"))
	title(`this_dim' Outcomes) keep(book_*);
#delimit cr

	local ++m

}




****** Heterogeneous Treatment Effects


local hetero /*BMasp female  BMasp2 pfail*/ ifail 

*local hetero_BMasp			book_only_BMasp book_mov_BMasp book_ast_BMasp book_mov_ast_BMasp
*local hetero_female 		book_only_female book_mov_female book_ast_female book_mov_ast_female
*local hetero_shopspace 	book_only_shopspace book_mov_shopspace book_ast_shopspace book_mov_ast_shopspace
*local hetero_BMasp2		book_only_BMasp2 book_mov_BMasp2 book_ast_BMasp2 book_mov_ast_BMasp2
local hetero_ifail			book_only_ifail book_mov_ifail book_ast_ifail book_mov_ast_ifail
*local hetero_pfail			book_only_pfail book_mov_pfail book_ast_pfail book_mov_ast_pfail

/*
label var book_only_BMasp "Handbook * Below Median Expectations"
label var book_mov_BMasp "Handbook & Movie * Below Median Expectations"
label var book_ast_BMasp "Handbook & Assistance * Below Median Expectations"
label var book_mov_ast_BMasp "All Three * Below Median Expectations"

label var book_only_female "Handbook * Female"
label var book_mov_female "Handbook & Movie * Female"
label var book_ast_female "Handbook & Assistance * Female"
label var book_mov_ast_female "All Three * Female"

label var book_only_BMasp2 "Handbook * Below Median Aspirations"
label var book_mov_BMasp2 "Handbook & Movie * Below Median Aspirations"
label var book_ast_BMasp2 "Handbook & Assistance * Below Median Aspirations"
label var book_mov_ast_BMasp2 "All Three * Below Median Aspirations"

label var book_only_pfail "Handbook * Planning Failure"
label var book_mov_pfail "Handbook & Movie * Planning Failure"
label var book_ast_pfail "Handbook & Assistance * Planning Failure"
label var book_mov_ast_pfail "All Three * Planning Failure"
*/

label var book_only_ifail "Handbook * Imagination Failure"
label var book_mov_ifail "Handbook & Movie * Imagination Failure"
label var book_ast_ifail "Handbook & Assistance * Imagination Failure"
label var book_mov_ast_ifail "All Three * Imagination Failure"



set more off 

local i = 1
local m = 1

foreach this_dim in `heterodims' {
	
	est drop _all
	foreach v in `hetero' {
	foreach var in ``this_dim'' {

		* Generating Dummies for missing BL vars 
		cap drop W1_`var'_m 
		cap drop W1b_`var'
	
		gen W1_`var'_m = (W1_`var'==.) if `var'!=. 
		gen W1b_`var' = W1_`var'
		replace W1b_`var'= 5 if W1_`var'_m == 1
	
	
	
		*Interactions
		
		areg `var' `x_treatment' `v' `hetero_`v'' W1b_`var' W1_`var'_m `heterocontrols' `ifailcontrols' i.round if finished==1, absorb(W1_village) cluster(shop_ID) robust
		est sto T`m'_`this_dim'_`i'
		estadd ysumm
		test book_only + book_only_`v'=0
		estadd scalar f1 = r(p)
		test book_mov + book_mov_`v'=0
		estadd scalar f2 = r(p)
		test book_ast + book_ast_`v'=0
		estadd scalar f3 = r(p)
		test book_mov_ast + book_mov_ast_`v'=0
		estadd scalar f4 = r(p)
		sum `var' if control==1 & round==3
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
		
		*Discrete `v'==0
		areg `var' `x_treatment' W1b_`var' W1_`var'_m `heterocontrols' `ifailcontrols' i.round if finished==1 & `v'==0, absorb(W1_village) cluster(shop_ID) robust
		est sto T`m'_`this_dim'_`i'
		estadd ysumm
		test book_only-book_mov=0
		estadd scalar f1 = r(p)
		test book_only-book_ast=0
		estadd scalar f2 = r(p)
		test book_only-book_mov_ast=0
		estadd scalar f3 = r(p)
		test book_mov-book_ast=0
		estadd scalar f4 = r(p)
		test book_mov - book_mov_ast = 0
		estadd scalar f5 = r(p)
		sum `var' if control==1 & round==3 & `v'==0
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
	
		*Discrete `v'==1
		areg `var' `x_treatment' W1b_`var' W1_`var'_m `heterocontrols' `ifailcontrols' i.round if finished==1 & `v'==1, absorb(W1_village) cluster(shop_ID) robust
		est sto T`m'_`this_dim'_`i'
		estadd ysumm
		test book_only-book_mov=0
		estadd scalar f1 = r(p)
		test book_only-book_ast=0
		estadd scalar f2 = r(p)
		test book_only-book_mov_ast=0
		estadd scalar f3 = r(p)
		test book_mov-book_ast=0
		estadd scalar f4 = r(p)
		test book_mov - book_mov_ast = 0
		estadd scalar f5 = r(p)
		sum `var' if control==1 & round==3 & `v'==1
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
		
		}

	}


	
capture erase "Aspirations\Hetero Excel Output\T`m'_`this_dim'_hetero.csv"

* output
#delimit ;
	esttab T`m'_`this_dim'_* using "Aspirations\Hetero Excel Output\T`m'_`this_dim'_hetero_ifailcontrol.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N mean sd f1 f2 f3 f4, fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) labels("R-squared" "N" "Dependent Variable Mean in Control Group" "Dependent Variable SD in Control Group" "F-test (p-value): Book + Interaction" "F-test (p-value): Book & Movie + Interaction" "F-test (p-value): Book & Assistaince + Interaction" "F-test (p-value): All Three + Interaction"))
	title(`this_dim' Outcomes) keep(book_*);
#delimit cr

	local ++m


}

/*
*** CHANGES IN ASPIRATIONS IN THE SHORT RUN

local i = 1
local m = 1

foreach this_dim in `heterodims' {
	
	est drop _all
	foreach v in `hetero' {
	foreach var in ``this_dim'' {

		* Generating Dummies for missing BL vars 
		cap drop W1_`var'_m 
		cap drop W1b_`var'
	
		gen W1_`var'_m = (W1_`var'==.) if `var'!=. 
		gen W1b_`var' = W1_`var'
		replace W1b_`var'= 5 if W1_`var'_m == 1
	
	
	
		*Interactions
		
		areg `var' `x_treatment' `v' `hetero_`v'' W1b_`var' W1_`var'_m `heterocontrols' if finished==1 & round==3, absorb(W1_village) cluster(shop_ID) robust
		est sto T`m'_`this_dim'_`i'
		estadd ysumm
		test book_only + book_only_`v'=0
		estadd scalar f1 = r(p)
		test book_mov + book_mov_`v'=0
		estadd scalar f2 = r(p)
		test book_ast + book_ast_`v'=0
		estadd scalar f3 = r(p)
		test book_mov_ast + book_mov_ast_`v'=0
		estadd scalar f4 = r(p)
		sum `var' if control==1 & round==3
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
		
		*Discrete `v'==0
		areg `var' `x_treatment' W1b_`var' W1_`var'_m `heterocontrols' if finished==1 & `v'==0 & round==3, absorb(W1_village) cluster(shop_ID) robust
		est sto T`m'_`this_dim'_`i'
		estadd ysumm
		test book_only-book_mov=0
		estadd scalar f1 = r(p)
		test book_only-book_ast=0
		estadd scalar f2 = r(p)
		test book_only-book_mov_ast=0
		estadd scalar f3 = r(p)
		test book_mov-book_ast=0
		estadd scalar f4 = r(p)
		test book_mov - book_mov_ast = 0
		estadd scalar f5 = r(p)
		sum `var' if control==1 & round==3 & `v'==0
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
	
		*Discrete `v'==1
		areg `var' `x_treatment' W1b_`var' W1_`var'_m `heterocontrols' if finished==1 & `v'==1 & round==3, absorb(W1_village) cluster(shop_ID) robust
		est sto T`m'_`this_dim'_`i'
		estadd ysumm
		test book_only-book_mov=0
		estadd scalar f1 = r(p)
		test book_only-book_ast=0
		estadd scalar f2 = r(p)
		test book_only-book_mov_ast=0
		estadd scalar f3 = r(p)
		test book_mov-book_ast=0
		estadd scalar f4 = r(p)
		test book_mov - book_mov_ast = 0
		estadd scalar f5 = r(p)
		sum `var' if control==1 & round==3 & `v'==1
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		local ++i
		
		}

	}


	
capture erase "Aspirations\Hetero Excel Output\T`m'_`this_dim'_hetero.csv"

* output
#delimit ;
	esttab T`m'_`this_dim'_* using "Aspirations\Hetero Excel Output\T`m'_`this_dim'_hetero_6m.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N mean sd f1 f2 f3 f4, fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) labels("R-squared" "N" "Dependent Variable Mean in Control Group" "Dependent Variable SD in Control Group" "F-test (p-value): Book + Interaction" "F-test (p-value): Book & Movie + Interaction" "F-test (p-value): Book & Assistaince + Interaction" "F-test (p-value): All Three + Interaction"))
	title(`this_dim' Outcomes) keep(book_*);
#delimit cr

	local ++m


}

*/
log close
