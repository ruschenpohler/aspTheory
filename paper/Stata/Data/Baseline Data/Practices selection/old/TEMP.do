



*** B

local regressors	practice_McKandW_B*
local tab_name		McK_B

local i 			= 0

*Regressions
foreach y in		`outcomes' {

					reg `y' `regressors' `controls', r
					est sto table_`tab_name'_`i'
					local ++i
	}

* Output
capture erase "Tables\table_`tab_name'.csv"
#delimit ;
esttab table_`tab_name'_* using "Tables\table_`tab_name'.csv", replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N"))
	title("`tab_name' Outcomes") ;
	#delimit cr

		
*** R

local regressors	practice_McKandW_R*
local tab_name		McK_R

local i 			= 0

*Regressions
foreach y in		`outcomes' {

					reg `y' `regressors' `controls', r
					est sto table_`tab_name'_`i'
					local ++i
	}

* Output
capture erase "Tables\table_`tab_name'.csv"
#delimit ;
esttab table_`tab_name'_* using "Tables\table_`tab_name'.csv", replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N"))
	title("`tab_name' Outcomes") ;
	#delimit cr


*** F

local regressors	practice_McKandW_F*
local tab_name		McK_F

local i 			= 0

*Regressions
foreach y in		`outcomes' {

					reg `y' `regressors' `controls', r
					est sto table_`tab_name'_`i'
					local ++i
	}

* Output
capture erase "Tables\table_`tab_name'.csv"
#delimit ;
esttab table_`tab_name'_* using "Tables\table_`tab_name'.csv", replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N"))
	title("`tab_name' Outcomes") ;
	#delimit cr
	
	
***** Other practices **********************************************************


*** Arbitrage and innovation


local tab_name		customers	
local regressors	practice_price_comp practice_sales_comp ///
					practice_discuss_newprod practice_discuss_suppl ///
					practice_discuss_bestsell practice_price_discount

local i 			= 0

*Regressions
foreach y in		`outcomes' {

					reg `y' `regressors' `controls', r
					est sto table_`tab_name'_`i'
					local ++i
	}

* Output
capture erase "Tables\table_`tab_name'.csv"
#delimit ;
esttab table_`tab_name'_* using "Tables\table_`tab_name'.csv", replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N"))
	title("`tab_name' Outcomes") ;
	#delimit cr

	
*** Stocking up

local tab_name		stock_up	
local regressors	firm_stockout_wklyall ///
					firm_stockup_lateany ///
					firm_stockup_fixall ///
					firm_stockup_wklyall firm_stockup_dailyall

local i 			= 0

*Regressions
foreach y in		`outcomes' {

					reg `y' `regressors' `controls', r
					est sto table_`tab_name'_`i'
					local ++i
	}

* Output
capture erase "Tables\table_`tab_name'.csv"
#delimit ;
esttab table_`tab_name'_* using "Tables\table_`tab_name'.csv", replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N"))
	title("`tab_name' Outcomes") ;
	#delimit cr


*** Record-keeping

local tab_name		rec_keep
local regressors	practice_rec_ledger practice_rec_receipts ///
					practice_rec_twicewkly ///
					practice_rec_suppl practice_rec_brands ///
					practice_rec_prods practice_rec_sales ///
					practice_rec_assets practice_rec_stock ///
					practice_rec_accpay_suppl practice_rec_accpay_loan ///
					practice_rec_costs practice_rec_accrec_custom ///
					practice_rec_accrec_fam
					
local i 			= 0

*Regressions
foreach y in		`outcomes' {

					reg `y' `regressors' `controls', r
					est sto table_`tab_name'_`i'
					local ++i
	}

* Output
capture erase "Tables\table_`tab_name'.csv"
#delimit ;
esttab table_`tab_name'_* using "Tables\table_`tab_name'.csv", replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N"))
	title("`tab_name' Outcomes") ;
	#delimit cr


*** Profits

local tab_name		prof_calc
local regressors	practice_profit_nocosts practice_profit_allcosts ///
					practice_profit_any_daily ///
					practice_inventory_profit practice_inventory_supplprice

					
local i 			= 0

*Regressions
foreach y in		`outcomes' {

					reg `y' `regressors' `controls', r
					est sto table_`tab_name'_`i'
					local ++i
	}

* Output
capture erase "Tables\table_`tab_name'.csv"
#delimit ;
esttab table_`tab_name'_* using "Tables\table_`tab_name'.csv", replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N"))
	title("`tab_name' Outcomes") ;
	#delimit cr


*** Joint decision-making


* Counterpart

local tab_name		dm_discuss_pers
local regressors	practice_discuss_fam practice_discuss_busifriend ///
					practice_decide_any

local i 			= 0

*Regressions
foreach y in		`outcomes' {

					reg `y' `regressors' `controls', r
					est sto table_`tab_name'_`i'
					local ++i
	}

* Output
capture erase "Tables\table_`tab_name'.csv"
#delimit ;
esttab table_`tab_name'_* using "Tables\table_`tab_name'.csv", replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N"))
	title("`tab_name' Outcomes") ;
	#delimit cr
	

* Discussion topic

local tab_name		discuss_topic
local regressors	practice_discuss_sales practice_discuss_sellprice ///
					practice_discuss_bestsell practice_discuss_finance ///
					practice_discuss_buyprice practice_discuss_practice ///
					practice_discuss_plan

local i 			= 0

*Regressions
foreach y in		`outcomes' {

					reg `y' `regressors' `controls', r
					est sto table_`tab_name'_`i'
					local ++i
	}

* Output
capture erase "Tables\table_`tab_name'.csv"
#delimit ;
esttab table_`tab_name'_* using "Tables\table_`tab_name'.csv", replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N"))
	title("`tab_name' Outcomes") ;
	#delimit cr


* Decision.making topic

local tab_name		dm_topic
local regressors	practice_decide_sales practice_decide_sellprice ///
					practice_decide_bestsell practice_decide_finance ///
					practice_decide_buyprice practice_decide_newprod ///
					practice_decide_practice practice_decide_plan

local i 			= 0

*Regressions
foreach y in		`outcomes' {

					reg `y' `regressors' `controls', r
					est sto table_`tab_name'_`i'
					local ++i
	}

* Output
capture erase "Tables\table_`tab_name'.csv"
#delimit ;
esttab table_`tab_name'_* using "Tables\table_`tab_name'.csv", replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N"))
	title("`tab_name' Outcomes") ;
	#delimit cr


*** Finance

local tab_name		finance
local regressors	practice_credit_trade practice_credit_trade_int ///
					finances_separate owner_loan_obtain_1
					
local i 			= 0

*Regressions
foreach y in		`outcomes' {

					reg `y' `regressors' `controls', r
					est sto table_`tab_name'_`i'
					local ++i
	}

* Output
capture erase "Tables\table_`tab_name'.csv"
#delimit ;
esttab table_`tab_name'_* using "Tables\table_`tab_name'.csv", replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N"))
	title("`tab_name' Outcomes") ;
	#delimit cr

	




/*

***** Outcomes and controls

local controls 		labour_total firm_space_cont
local outcomes 		sales_mthly_comp_all_ihs_win sales_mthly_comp_all_win ///
					profit_mthly_comp_all_ihs_win profit_mthly_comp_all_win ///
					sales_normday_ihs ///
					sales_normday_topprods_ihs ///
					profit_normday_ihs ///
					firm_custom_total

					
					
***** McKenzie and Woodruff (2015) *********************************************

* Specifications

local tab_name		McK
local m				practice_McKandW_M*
local b				practice_McKandW_B*
local r				practice_McKandW_R*
local f				practice_McKandW_F*
local McK			`m' `b' `r' `f'



foreach x in `McK' {

	local i 		= 0
	local dim		= substr(`x',-2,1)
	
	*Regressions
	foreach y in		`outcomes' {

					reg `y' `x' `controls', vce(robust)
					est sto table_`tab_name'_`i'
					//estadd ysumm
						
					local ++i
	}

	* Output
	capture erase "Tables\table_`tab_name'.csv"
	#delimit ;
	esttab table_`tab_name'_* using "Tables\table_`tab_name'_`dim'.csv", replace modelwidth(16) varwidth(50) depvar legend 
		cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
		stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N"))
		title("`tab_name' `dim' Outcomes") /*keep(any* book*)*/ ;
		#delimit cr
}
	
	
	

/*

/*
************************************************************************
***** SUM STATS ********************************************************

tabstat owner_male owner_age owner_educ owner_digitspan owner_digitspan_rev ///
firm_age firm_formal_tax labour_total ///
sales_lastmth sales_lastmth_log_win ///
sales_mthly_comp_all sales_mthly_comp_all_log_win ///
profit_lastmth profit_lastmth_log_win profit_lastmth_ihs_win ///
profit_mthly_comp_all profit_mthly_comp_all_ihs_win ///
practice_McKandW_perc_total practice_McKandW_perc_M ///
practice_McKandW_perc_B practice_McKandW_perc_R practice_McKandW_perc_F ///
, stat(n mean sd min max median) col(stat) long format(%8.2g) varwidth (16)

*lpoly sales_lastmth_log_win practice_McKandW_perc_total, noscatter ci degree(1) bwidth(0.05)
*lpoly sales_normday_log_win practice_McKandW_perc_total, noscatter ci degree(1) bwidth(0.05)
*lpoly profit_lastmth_log_win practice_McKandW_perc_total, noscatter ci degree(1) bwidth(0.05)
*lpoly profit_normday_log_win practice_McKandW_perc_total, noscatter ci degree(1) bwidth(0.05)

*histogram practice_McKandW_perc_total, frequency normal
tab practice_McKandW_perc_total_qs

* Need to think about excluding 3 obs with McKandW perc score >.76

cor practice_McKandW_perc_M practice_McKandW_perc_B practice_McKandW_perc_R practice_McKandW_perc_F ///
firm_open_abovemd ///
firm_formal_reg sales_normday_top3share prods_dispose firm_stockout_wklyall ///
firm_stockup_fixall firm_stockup_lateany firm_stockup_wklyall firm_stockup_dailyall ///
practice_rec_suppl practice_rec_brands practice_rec_prods practice_rec_sales ///
practice_rec_assets practice_rec_stock practice_rec_accpay_suppl ///
practice_rec_accpay_loan practice_rec_costs practice_rec_accrec_custom ///
practice_rec_accrec_fam practice_rec_ledger practice_rec_receipts practice_rec_twicewkly ///
practice_profit_nocosts practice_profit_allcosts practice_profit_any_daily ///
practice_inventory_demand practice_inventory_space practice_inventory_profit practice_inventory_supplprice /// 
practice_price_comp practice_price_demand practice_price_discount ///
practice_credit_trade practice_credit_trade_int owner_loan_apply /*owner_loan_obtain*/ ///
/*owner_finlit_compscore*/ practice_sales_comp practice_prods_new5 /// 
practice_discuss_sales practice_discuss_sellprice practice_discuss_bestsell ///
practice_discuss_finance practice_discuss_buyprice practice_discuss_newprod ///
practice_discuss_practice practice_discuss_plan ///
practice_decide_sales practice_decide_sellprice practice_decide_bestsell ///
practice_decide_finance practice_decide_buyprice practice_decide_newprod ///
practice_decide_practice practice_decide_plan ///
practice_decide_agreed finances_separate

* Answer distribution of vars --> 24, 24, 21, 14, 22, 11, 2%
sum practice_McKandW_M1 practice_McKandW_M2 practice_McKandW_M3 ///
practice_McKandW_M4 practice_McKandW_M5 practice_McKandW_M6 practice_McKandW_M7, detail

* Answer distribution of vars --> 21, 28, 6, 2, 13, 36%
sum practice_price_comp practice_sales_comp practice_discuss_newprod ///
practice_discuss_suppl practice_discuss_bestsell practice_price_discount, detail

* Answer distribution of vars --> 16, 55, 67%
sum practice_McKandW_B1 practice_McKandW_B2 practice_McKandW_B3, detail

* Answer distribution of vars --> 19, 16, 4, 10, 5%
sum firm_stockout_wklyall firm_stockup_lateany firm_stockup_fixall ///
firm_stockup_wklyall firm_stockup_dailyall, detail

* Answer distribution of vars --> 87, 9, 22, 38, 80, 82, 19, 21%
sum practice_McKandW_R1 practice_McKandW_R2 practice_McKandW_R3 ///
practice_McKandW_R4 practice_McKandW_R5 practice_McKandW_R6 practice_McKandW_R7 ///
practice_McKandW_R8, detail

* Answer distribution of vars --> 36, 27, 50, 35, 30, 59, 7, 10, 6, 22, 16, 52, 77, 10%
sum practice_rec_ledger practice_rec_receipts practice_rec_twicewkly ///
practice_rec_suppl practice_rec_brands practice_rec_prods practice_rec_sales ///
practice_rec_assets practice_rec_stock practice_rec_accpay_suppl ///
practice_rec_accpay_loan practice_rec_costs practice_rec_accrec_custom ///
practice_rec_accrec_fam, detail

* Answer distribution of vars --> 10, 4, 20, 41, 45%
sum practice_profit_nocosts practice_profit_allcosts practice_profit_any_daily ///
practice_inventory_profit practice_inventory_supplprice , detail

* Answer distribution of vars -- > 69, 34, 37, 15, 3, 3, 1, 4%
sum practice_McKandW_F1 practice_McKandW_F2 practice_McKandW_F3 ///
practice_McKandW_F4 practice_McKandW_F5 practice_McKandW_F6 practice_McKandW_F7 ///
practice_McKandW_F8, detail

* Answer distribution of vars --> 28, 16, 11, 58, 64,10, 55%
sum sales_normday_top3share_abovep80 practice_prods_new5 prods_dispose ///
practice_inventory_demand practice_inventory_space practice_price_demand ///
sales_normday_top3share_abovemd, detail

* Answer distribution of p80 vars --> 44, 16, 44, 66, 35, 33, 15, 34, 8, 52, 21, 80, 29, 57, 7, 81, 8, 34, 5%
sum topprods_rice_1 topprods_flour_1 topprods_eggs_1 topprods_noodles_1 topprods_oil_1 ///
topprods_saltsugar_1 topprods_bread_1 topprods_coffeetea_1 topprods_homecooked_1 ///
topprods_snacks_1 topprods_freshdrinks_1 topprods_softdrinks_1 topprods_sanitary_1 ///
topprods_cleaning_1 topprods_baby_1 topprods_tobacco_1 topprods_meds_1 ///
topprods_gaspetrol_1 topprods_phone_1, detail

* Answer distribution of median-split vars --> 20, 16, 20, 21, 20, 20, 15, 20, 8, 20, 20, 20, 20, 20, 7, 20, 8, 20, 5%
sum topprods_rice_abovep80 topprods_flour_abovep80 topprods_eggs_abovep80 topprods_noodles_abovep80 topprods_oil_abovep80 ///
topprods_saltsugar_abovep80 topprods_bread_abovep80 topprods_coffeetea_abovep80 topprods_homecooked_abovep80 ///
topprods_snacks_abovep80 topprods_freshdrinks_abovep80 topprods_softdrinks_abovep80 topprods_sanitary_abovep80 ///
topprods_cleaning_abovep80 topprods_baby_abovep80 topprods_tobacco_abovep80 topprods_meds_abovep80 ///
topprods_gaspetrol_abovep80 topprods_phone_abovep80, detail

* Answer distribution of vars --> 15, 20, 13, 7, 10, 12, 13%
sum practice_discuss_sales practice_discuss_sellprice practice_discuss_bestsell ///
practice_discuss_finance practice_discuss_buyprice practice_discuss_practice ///
practice_discuss_plan, detail

* Answer distribution of vars --> 4, 12, 6, 3, 3, 4, 6., 8%
sum practice_decide_sales practice_decide_sellprice practice_decide_bestsell ///
practice_decide_finance practice_decide_buyprice practice_decide_newprod ///
practice_decide_practice practice_decide_plan, detail

* Answer distribution of vars --> 67, 6, 43%
sum practice_discuss_fam practice_discuss_busifriend practice_decide_any, detail

* Answer distribution of vars --> 86, 7, 43, 16%
sum practice_credit_trade practice_credit_trade_int ///
finances_separate owner_loan_obtain_1, detail


*/


************************************************************************
***** MCK AND W REGS *****************************************************

***** SALES AND PROFITS, COMP SCORE (calc and self-rep vars)

*** Total perc score (control for labour, firm size)

* Sig and pos
reg sales_mthly_comp_all_ihs_win practice_McKandW_perc_total ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store tot_Scompall

* Sig and pos
reg profit_mthly_comp_all_ihs_win practice_McKandW_perc_total ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store tot_Pcompall


*** Sub-scores (control for labour, firm size)

* M sig and neg, B, R, F sig and pos
reg sales_mthly_comp_all_ihs_win practice_McKandW_perc_M practice_McKandW_perc_B ///
practice_McKandW_perc_R practice_McKandW_perc_F ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store sub_Scompall

* R sig and pos
reg profit_mthly_comp_all_ihs_win practice_McKandW_perc_M practice_McKandW_perc_B ///
practice_McKandW_perc_R practice_McKandW_perc_F ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store sub_Pcompall


*** Single practices (control for labour, firm size)

* M2, M5 sig and neg, M4, B2, R1, R2, R5, R8, F4 sig and pos
reg sales_mthly_comp_all_ihs_win i.practice_McKandW_M1 i.practice_McKandW_M2 ///
i.practice_McKandW_M3 i.practice_McKandW_M4 i.practice_McKandW_M5 i.practice_McKandW_M6 ///
i.practice_McKandW_M7 i.practice_McKandW_B1 i.practice_McKandW_B2 i.practice_McKandW_B3 ///
i.practice_McKandW_R1 i.practice_McKandW_R2 i.practice_McKandW_R3 i.practice_McKandW_R4 ///
i.practice_McKandW_R5 i.practice_McKandW_R6 i.practice_McKandW_R7 i.practice_McKandW_R8 ///
i.practice_McKandW_F1 i.practice_McKandW_F2 i.practice_McKandW_F3 i.practice_McKandW_F4 ///
i.practice_McKandW_F5 i.practice_McKandW_F6 i.practice_McKandW_F7 i.practice_McKandW_F8 ///
labour_total c.firm_space_cont, vce(robust)
estimates store sin_Scompall

* M2 sig and neg, R6 sig and pos
reg profit_mthly_comp_all_ihs_win i.practice_McKandW_M1 i.practice_McKandW_M2 ///
i.practice_McKandW_M3 i.practice_McKandW_M4 i.practice_McKandW_M5 i.practice_McKandW_M6 ///
i.practice_McKandW_M7 i.practice_McKandW_B1 i.practice_McKandW_B2 i.practice_McKandW_B3 ///
i.practice_McKandW_R1 i.practice_McKandW_R2 i.practice_McKandW_R3 i.practice_McKandW_R4 ///
i.practice_McKandW_R5 i.practice_McKandW_R6 i.practice_McKandW_R7 i.practice_McKandW_R8 ///
i.practice_McKandW_F1 i.practice_McKandW_F2 i.practice_McKandW_F3 i.practice_McKandW_F4 ///
i.practice_McKandW_F5 i.practice_McKandW_F6 i.practice_McKandW_F7 i.practice_McKandW_F8 ///
labour_total c.firm_space_cont, vce(robust)
estimates store sin_Pcompall


***** COMP SCORES, SALES AND PROFITS (only self-rep vars)

*** Total perc score (control for labour, firm size)

* Sig and pos
reg sales_mthly_comp_rep_ihs_win practice_McKandW_perc_total ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store tot_Scomprep

* Sig and pos
reg profit_mthly_comp_rep_ihs_win practice_McKandW_perc_total ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store tot_Pcomprep


*** Sub-scores (control for labour, firm size)

* M sig and neg, B, R, F sig and pos
reg sales_mthly_comp_rep_ihs_win practice_McKandW_perc_M practice_McKandW_perc_B ///
practice_McKandW_perc_R practice_McKandW_perc_F ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store sub_Scomprep

* M sig and neg, B, R, F sig and pos
reg profit_mthly_comp_rep_ihs_win practice_McKandW_perc_M practice_McKandW_perc_B ///
practice_McKandW_perc_R practice_McKandW_perc_F ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store sub_Pcomprep


*** Single practices (control for labour, firm size)

* M1, M2, M5 sig and neg, M4, B2, R1, R5, R8, F4 sig and pos
reg sales_mthly_comp_rep_ihs_win i.practice_McKandW_M1 i.practice_McKandW_M2 ///
i.practice_McKandW_M3 i.practice_McKandW_M4 i.practice_McKandW_M5 i.practice_McKandW_M6 ///
i.practice_McKandW_M7 i.practice_McKandW_B1 i.practice_McKandW_B2 i.practice_McKandW_B3 ///
i.practice_McKandW_R1 i.practice_McKandW_R2 i.practice_McKandW_R3 i.practice_McKandW_R4 ///
i.practice_McKandW_R5 i.practice_McKandW_R6 i.practice_McKandW_R7 i.practice_McKandW_R8 ///
i.practice_McKandW_F1 i.practice_McKandW_F2 i.practice_McKandW_F3 i.practice_McKandW_F4 ///
i.practice_McKandW_F5 i.practice_McKandW_F6 i.practice_McKandW_F7 i.practice_McKandW_F8 ///
labour_total c.firm_space_cont, vce(robust)
estimates store sin_Scomprep

* M1 sig and neg, M4, R1, R5, R8, F3, F4 sig and pos
reg profit_mthly_comp_rep_ihs_win i.practice_McKandW_M1 i.practice_McKandW_M2 ///
i.practice_McKandW_M3 i.practice_McKandW_M4 i.practice_McKandW_M5 i.practice_McKandW_M6 ///
i.practice_McKandW_M7 i.practice_McKandW_B1 i.practice_McKandW_B2 i.practice_McKandW_B3 ///
i.practice_McKandW_R1 i.practice_McKandW_R2 i.practice_McKandW_R3 i.practice_McKandW_R4 ///
i.practice_McKandW_R5 i.practice_McKandW_R6 i.practice_McKandW_R7 i.practice_McKandW_R8 ///
i.practice_McKandW_F1 i.practice_McKandW_F2 i.practice_McKandW_F3 i.practice_McKandW_F4 ///
i.practice_McKandW_F5 i.practice_McKandW_F6 i.practice_McKandW_F7 i.practice_McKandW_F8 ///
labour_total c.firm_space_cont, vce(robust)
estimates store sin_Pcomprep



***** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

*** Total perc score (control for labour, firm size)

* Sig and pos
reg sales_normday_ihs_win practice_McKandW_perc_total ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store tot_Sday

* Sig and pos
reg profit_normday_ihs_win practice_McKandW_perc_total ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store tot_Pday


*** Sub-scores (control for labour, firm size)

* M sig and neg, B, R, F sig and pos
reg sales_normday_ihs_win practice_McKandW_perc_M practice_McKandW_perc_B ///
practice_McKandW_perc_R practice_McKandW_perc_F ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store sub_Sday

* B, R, F sig and pos
reg profit_normday_ihs_win practice_McKandW_perc_M practice_McKandW_perc_B ///
practice_McKandW_perc_R practice_McKandW_perc_F ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store sub_Pday


*** Single practices (control for labour, firm size)

* M1, M5 sig and neg, M4, B2, R1, R5, R8, F4 sig and pos
reg sales_normday_ihs_win i.practice_McKandW_M1 i.practice_McKandW_M2 ///
i.practice_McKandW_M3 i.practice_McKandW_M4 i.practice_McKandW_M5 i.practice_McKandW_M6 ///
i.practice_McKandW_M7 i.practice_McKandW_B1 i.practice_McKandW_B2 i.practice_McKandW_B3 ///
i.practice_McKandW_R1 i.practice_McKandW_R2 i.practice_McKandW_R3 i.practice_McKandW_R4 ///
i.practice_McKandW_R5 i.practice_McKandW_R6 i.practice_McKandW_R7 i.practice_McKandW_R8 ///
i.practice_McKandW_F1 i.practice_McKandW_F2 i.practice_McKandW_F3 i.practice_McKandW_F4 ///
i.practice_McKandW_F5 i.practice_McKandW_F6 i.practice_McKandW_F7 i.practice_McKandW_F8 ///
labour_total c.firm_space_cont, vce(robust)
estimates store sin_Sday

* M1 sig and neg, R1, R8, F3, F4 sig and pos
reg profit_normday_ihs_win i.practice_McKandW_M1 i.practice_McKandW_M2 ///
i.practice_McKandW_M3 i.practice_McKandW_M4 i.practice_McKandW_M5 i.practice_McKandW_M6 ///
i.practice_McKandW_M7 i.practice_McKandW_B1 i.practice_McKandW_B2 i.practice_McKandW_B3 ///
i.practice_McKandW_R1 i.practice_McKandW_R2 i.practice_McKandW_R3 i.practice_McKandW_R4 ///
i.practice_McKandW_R5 i.practice_McKandW_R6 i.practice_McKandW_R7 i.practice_McKandW_R8 ///
i.practice_McKandW_F1 i.practice_McKandW_F2 i.practice_McKandW_F3 i.practice_McKandW_F4 ///
i.practice_McKandW_F5 i.practice_McKandW_F6 i.practice_McKandW_F7 i.practice_McKandW_F8 ///
labour_total c.firm_space_cont, vce(robust)
estimates store sin_Pday


***** LAB PRODUCTIVITY

*** Total perc score (control for labour, firm size)

* Sig and pos
reg productiv_labour practice_McKandW_perc_total ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store tot_prodlab


*** Sub-scores (control for labour, firm size)

* M sig and neg, R sig and pos
reg productiv_labour practice_McKandW_perc_M practice_McKandW_perc_B ///
practice_McKandW_perc_R practice_McKandW_perc_F ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store sub_prodlab


*** Single practices (control for labour, firm size)

* B2, R5, R8 sig and pos
reg productiv_labour i.practice_McKandW_M1 i.practice_McKandW_M2 ///
i.practice_McKandW_M3 i.practice_McKandW_M4 i.practice_McKandW_M5 i.practice_McKandW_M6 ///
i.practice_McKandW_M7 i.practice_McKandW_B1 i.practice_McKandW_B2 i.practice_McKandW_B3 ///
i.practice_McKandW_R1 i.practice_McKandW_R2 i.practice_McKandW_R3 i.practice_McKandW_R4 ///
i.practice_McKandW_R5 i.practice_McKandW_R6 i.practice_McKandW_R7 i.practice_McKandW_R8 ///
i.practice_McKandW_F1 i.practice_McKandW_F2 i.practice_McKandW_F3 i.practice_McKandW_F4 ///
i.practice_McKandW_F5 i.practice_McKandW_F6 i.practice_McKandW_F7 i.practice_McKandW_F8 ///
labour_total c.firm_space_cont, vce(robust)
estimates store sin_prodlab


***** CUSTOMERS

*** Total perc score (control for labour, firm size)

* Sig and pos
reg firm_custom_total practice_McKandW_perc_total ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store tot_custot

* Sig and pos
reg firm_custom_loyal practice_McKandW_perc_total ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store tot_cusloy


*** Sub-scores (control for labour, firm size)

* R and F sig and pos
reg firm_custom_total practice_McKandW_perc_M practice_McKandW_perc_B ///
practice_McKandW_perc_R practice_McKandW_perc_F ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store sub_custot

* None sig
reg firm_custom_loyal practice_McKandW_perc_M practice_McKandW_perc_B ///
practice_McKandW_perc_R practice_McKandW_perc_F ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store sub_cusloy


*** Single practices (control for labour, firm size)

* M6, B2, R8, F4 sig and pos
reg firm_custom_total i.practice_McKandW_M1 i.practice_McKandW_M2 ///
i.practice_McKandW_M3 i.practice_McKandW_M4 i.practice_McKandW_M5 i.practice_McKandW_M6 ///
i.practice_McKandW_M7 i.practice_McKandW_B1 i.practice_McKandW_B2 i.practice_McKandW_B3 ///
i.practice_McKandW_R1 i.practice_McKandW_R2 i.practice_McKandW_R3 i.practice_McKandW_R4 ///
i.practice_McKandW_R5 i.practice_McKandW_R6 i.practice_McKandW_R7 i.practice_McKandW_R8 ///
i.practice_McKandW_F1 i.practice_McKandW_F2 i.practice_McKandW_F3 i.practice_McKandW_F4 ///
i.practice_McKandW_F5 i.practice_McKandW_F6 i.practice_McKandW_F7 i.practice_McKandW_F8 ///
labour_total c.firm_space_cont, vce(robust)
estimates store sin_custot

* M1 sig and neg
reg firm_custom_loyal i.practice_McKandW_M1 i.practice_McKandW_M2 ///
i.practice_McKandW_M3 i.practice_McKandW_M4 i.practice_McKandW_M5 i.practice_McKandW_M6 ///
i.practice_McKandW_M7 i.practice_McKandW_B1 i.practice_McKandW_B2 i.practice_McKandW_B3 ///
i.practice_McKandW_R1 i.practice_McKandW_R2 i.practice_McKandW_R3 i.practice_McKandW_R4 ///
i.practice_McKandW_R5 i.practice_McKandW_R6 i.practice_McKandW_R7 i.practice_McKandW_R8 ///
i.practice_McKandW_F1 i.practice_McKandW_F2 i.practice_McKandW_F3 i.practice_McKandW_F4 ///
i.practice_McKandW_F5 i.practice_McKandW_F6 i.practice_McKandW_F7 i.practice_McKandW_F8 ///
labour_total c.firm_space_cont, vce(robust)
estimates store sin_cusloy


***** TABLES

*** Sales and profits comp scores
estimates table tot_Scompall tot_Pcompall tot_Scomprep tot_Pcomprep, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse) 
estimates table sub_Scompall sub_Pcompall sub_Scomprep sub_Pcomprep, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse) 
estimates table sin_Scompall sin_Pcompall sin_Scomprep sin_Pcomprep, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse)


*** Sales snd profits on a norm day
estimates table tot_Sday tot_Pday, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse) 
estimates table sub_Sday sub_Pday, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse) 
estimates table sin_Sday sin_Pday, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse)


*** Lab prod, customers (total and loyal)
estimates table tot_prodlab tot_custot tot_cusloy, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse) 
estimates table sub_prodlab sub_custot sub_cusloy, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse) 
estimates table sin_prodlab sin_custot sin_cusloy, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse)










************************************************************************
***** "OTHER PRACTICES" REGS ************************************************


***** FIRM CHARS (assets, opening time, formality), PRODUCTS, STOCK-UP/-OUTS AND DISPOSAL

*** Sales and profits, comp scores (self-rep and calc for sales, only self-rep for profits)

*
reg sales_mthly_comp_all_ihs_win i.firm_scooter i.firm_car i.firm_open_net_abovemd i.firm_open_net_abovep80 ///
i.firm_formal_reg sales_normday_top3share i.prods_dispose i.firm_stockout_wklyall ///
i.firm_stockup_fixall i.firm_stockup_lateany i.firm_stockup_wklyall i.firm_stockup_dailyall ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store char_Scompall

*
reg profit_mthly_comp_rep_ihs_win i.firm_scooter i.firm_car i.firm_open_net_abovemd i.firm_open_net_abovep80 ///
i.firm_formal_reg sales_normday_top3share i.prods_dispose i.firm_stockout_wklyall ///
i.firm_stockup_fixall i.firm_stockup_lateany i.firm_stockup_wklyall i.firm_stockup_dailyall ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store char_Pcomprep


*** Labour prod

*
reg productiv_labour i.firm_scooter i.firm_car i.firm_open_net_abovemd i.firm_open_net_abovep80 ///
i.firm_formal_reg sales_normday_top3share i.prods_dispose i.firm_stockout_wklyall ///
i.firm_stockup_fixall i.firm_stockup_lateany i.firm_stockup_wklyall i.firm_stockup_dailyall ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store char_prodlab


*** Customers

*
reg firm_custom_total i.firm_scooter i.firm_car i.firm_open_net_abovemd i.firm_open_net_abovep80 ///
i.firm_formal_reg c.sales_normday_top3share i.prods_dispose i.firm_stockout_wklyall ///
i.firm_stockup_fixall i.firm_stockup_lateany i.firm_stockup_wklyall i.firm_stockup_dailyall ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store char_custot

*
reg firm_custom_loyal i.firm_scooter i.firm_car i.firm_open_net_abovemd i.firm_open_net_abovep80 ///
i.firm_formal_reg sales_normday_top3share i.prods_dispose i.firm_stockout_wklyall ///
i.firm_stockup_fixall i.firm_stockup_lateany i.firm_stockup_wklyall i.firm_stockup_dailyall ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store char_cusloy


*** Tables

* Sales and profits comp scores
estimates table char_Scompall char_Pcomprep, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse) 

* Lab prod, customers (total and loyal)
estimates table char_prodlab char_custot char_cusloy, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse)



***** RECORD-KEEPING AND PROFIT CALC

*** Sales and profits, comp scores (self-rep and calc for sales, only self-rep for profits)

*
reg sales_mthly_comp_all_ihs_win i.practice_rec_suppl i.practice_rec_brands ///
i.practice_rec_prods i.practice_rec_sales i.practice_rec_assets ///
i.practice_rec_stock i.practice_rec_accpay_suppl i.practice_rec_accpay_loan ///
i.practice_rec_costs i.practice_rec_accrec_custom i.practice_rec_accrec_fam ///
i.practice_rec_ledger i.practice_rec_receipts i.practice_rec_twicewkly ///
i.practice_profit_nocosts i.practice_profit_allcosts i.practice_profit_any_daily ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store rec_Scompall


*
reg profit_mthly_comp_rep_ihs_win i.practice_rec_suppl i.practice_rec_brands ///
i.practice_rec_prods i.practice_rec_sales i.practice_rec_assets ///
i.practice_rec_stock i.practice_rec_accpay_suppl i.practice_rec_accpay_loan ///
i.practice_rec_costs i.practice_rec_accrec_custom i.practice_rec_accrec_fam ///
i.practice_rec_ledger i.practice_rec_receipts i.practice_rec_twicewkly ///
i.practice_profit_nocosts i.practice_profit_allcosts i.practice_profit_any_daily ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store rec_Pcomprep


*** Labour prod

*
reg productiv_labour practice_rec_suppl i.practice_rec_suppl i.practice_rec_brands ///
i.practice_rec_prods i.practice_rec_sales i.practice_rec_assets ///
i.practice_rec_stock i.practice_rec_accpay_suppl i.practice_rec_accpay_loan ///
i.practice_rec_costs i.practice_rec_accrec_custom i.practice_rec_accrec_fam ///
i.practice_rec_ledger i.practice_rec_receipts i.practice_rec_twicewkly ///
i.practice_profit_nocosts i.practice_profit_allcosts i.practice_profit_any_daily ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store rec_prodlab

*
reg productiv_labour practice_rec_suppl i.practice_rec_suppl i.practice_rec_brands ///
i.practice_rec_prods i.practice_rec_sales i.practice_rec_assets ///
i.practice_rec_stock i.practice_rec_accpay_suppl i.practice_rec_accpay_loan ///
i.practice_rec_costs i.practice_rec_accrec_custom i.practice_rec_accrec_fam ///
i.practice_rec_ledger i.practice_rec_receipts i.practice_rec_twicewkly ///
i.practice_profit_nocosts i.practice_profit_allcosts i.practice_profit_any_daily ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store rec_prodlab


*** Customers

*
reg firm_custom_total i.practice_rec_suppl i.practice_rec_brands ///
i.practice_rec_prods i.practice_rec_sales i.practice_rec_assets ///
i.practice_rec_stock i.practice_rec_accpay_suppl i.practice_rec_accpay_loan ///
i.practice_rec_costs i.practice_rec_accrec_custom i.practice_rec_accrec_fam ///
i.practice_rec_ledger i.practice_rec_receipts i.practice_rec_twicewkly ///
i.practice_profit_nocosts i.practice_profit_allcosts i.practice_profit_any_daily ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store rec_custot

*
reg firm_custom_loyal i.practice_rec_suppl i.practice_rec_brands ///
i.practice_rec_prods i.practice_rec_sales i.practice_rec_assets ///
i.practice_rec_stock i.practice_rec_accpay_suppl i.practice_rec_accpay_loan ///
i.practice_rec_costs i.practice_rec_accrec_custom i.practice_rec_accrec_fam ///
i.practice_rec_ledger i.practice_rec_receipts i.practice_rec_twicewkly ///
i.practice_profit_nocosts i.practice_profit_allcosts i.practice_profit_any_daily ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store rec_cusloy


*** Tables

* Sales and profits comp scores
estimates table rec_Scompall rec_Pcomprep, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse) 

* Lab prod, customers (total and loyal)
estimates table rec_prodlab rec_custot rec_cusloy, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse)



***** PRICES AND INVENTORY, CREDIT, LOAN AND LITERACY, DISCUSSION AND JOINT DECISION-MAKING

*** Sales and profits, comp scores (self-rep and calc for sales, only self-rep for profits)

*
reg sales_mthly_comp_all_ihs_win i.practice_inventory_demand ///
i.practice_inventory_space i.practice_inventory_profit i.practice_inventory_supplprice ///
i.practice_price_comp i.practice_price_demand i.practice_price_discount ///
i.practice_credit_trade i.practice_credit_trade_int c.owner_loan_apply c.owner_loan_obtain ///
c.owner_finlit_compscore i.practice_sales_comp i.practice_prods_new5 ///
i.practice_decide i.practice_discuss_any ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store oth_Scompall

*
reg profit_mthly_comp_rep_ihs_win i.practice_inventory_demand ///
i.practice_inventory_space i.practice_inventory_profit i.practice_inventory_supplprice ///
i.practice_price_comp i.practice_price_demand i.practice_price_discount ///
i.practice_credit_trade i.practice_credit_trade_int c.owner_loan_apply c.owner_loan_obtain ///
c.owner_finlit_compscore i.practice_sales_comp i.practice_prods_new5 ///
i.practice_decide i.practice_discuss_any ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store oth_Pcomprep


*** Labour prod

*
reg productiv_labour i.practice_inventory_demand ///
i.practice_inventory_space i.practice_inventory_profit i.practice_inventory_supplprice ///
i.practice_price_comp i.practice_price_demand i.practice_price_discount ///
i.practice_credit_trade i.practice_credit_trade_int c.owner_loan_apply c.owner_loan_obtain ///
c.owner_finlit_compscore i.practice_sales_comp i.practice_prods_new5 ///
i.practice_decide i.practice_discuss_any ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store oth_prodlab


*** Customers

*
reg firm_custom_total i.practice_inventory_demand ///
i.practice_inventory_space i.practice_inventory_profit i.practice_inventory_supplprice ///
i.practice_price_comp i.practice_price_demand i.practice_price_discount ///
i.practice_credit_trade i.practice_credit_trade_int c.owner_loan_apply c.owner_loan_obtain ///
c.owner_finlit_compscore i.practice_sales_comp i.practice_prods_new5 ///
i.practice_decide i.practice_discuss_any ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store oth_custot

*
reg firm_custom_loyal i.practice_inventory_demand ///
i.practice_inventory_space i.practice_inventory_profit i.practice_inventory_supplprice ///
i.practice_price_comp i.practice_price_demand i.practice_price_discount ///
i.practice_credit_trade i.practice_credit_trade_int c.owner_loan_apply c.owner_loan_obtain ///
c.owner_finlit_compscore i.practice_sales_comp i.practice_prods_new5 ///
i.practice_decide i.practice_discuss_any ///
labour_total firm_space_cont, vce(robust) // level(90)
estimates store oth_cusloy


*** Tables

* Sales and profits comp scores
estimates table oth_Scompall oth_Pcomprep, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse) 

* Lab prod, customers (total and loyal)
estimates table oth_prodlab oth_custot oth_cusloy, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse)



************************************************************************
***** ALL COMBINED ************************************************

***** SALES AND PROFITS, COMP SCORE (calc and self-rep vars)

* 3 sig and neg, 17 sig and pos
reg sales_mthly_comp_all_ihs_win i.practice_McKandW_M1 i.practice_McKandW_M2 ///
i.practice_McKandW_M3 i.practice_McKandW_M4 i.practice_McKandW_M5 i.practice_McKandW_M6 ///
i.practice_McKandW_M7 i.practice_McKandW_B1 i.practice_McKandW_B2 i.practice_McKandW_B3 ///
i.practice_McKandW_R1 i.practice_McKandW_R2 i.practice_McKandW_R3 i.practice_McKandW_R4 ///
i.practice_McKandW_R5 i.practice_McKandW_R6 i.practice_McKandW_R7 i.practice_McKandW_R8 ///
i.practice_McKandW_F1 i.practice_McKandW_F2 i.practice_McKandW_F3 i.practice_McKandW_F4 ///
i.practice_McKandW_F5 i.practice_McKandW_F6 i.practice_McKandW_F7 i.practice_McKandW_F8 ///
i.firm_scooter i.firm_car i.firm_open_net_abovemd i.firm_open_net_abovep80 ///
i.firm_formal_reg sales_normday_top3share i.prods_dispose i.firm_stockout_wklyall ///
i.firm_stockup_fixall i.firm_stockup_lateany i.firm_stockup_wklyall i.firm_stockup_dailyall ///
i.practice_rec_suppl i.practice_rec_brands ///
i.practice_rec_prods i.practice_rec_sales i.practice_rec_assets ///
i.practice_rec_stock i.practice_rec_accpay_suppl i.practice_rec_accpay_loan ///
i.practice_rec_costs i.practice_rec_accrec_custom i.practice_rec_accrec_fam ///
i.practice_rec_ledger i.practice_rec_receipts i.practice_rec_twicewkly ///
i.practice_profit_nocosts i.practice_profit_allcosts i.practice_profit_any_daily ///
i.practice_inventory_demand ///
i.practice_inventory_space i.practice_inventory_profit i.practice_inventory_supplprice ///
i.practice_price_comp i.practice_price_demand i.practice_price_discount ///
i.practice_credit_trade i.practice_credit_trade_int c.owner_loan_apply c.owner_loan_obtain ///
c.owner_finlit_compscore i.practice_sales_comp i.practice_prods_new5 ///
i.practice_decide i.practice_discuss_any ///
labour_total c.firm_space_cont, vce(robust)
estimates store all_Scompall

* 2 sig and neg, 6 sig and pos
reg profit_mthly_comp_rep_ihs_win i.practice_McKandW_M1 i.practice_McKandW_M2 ///
i.practice_McKandW_M3 i.practice_McKandW_M4 i.practice_McKandW_M5 i.practice_McKandW_M6 ///
i.practice_McKandW_M7 i.practice_McKandW_B1 i.practice_McKandW_B2 i.practice_McKandW_B3 ///
i.practice_McKandW_R1 i.practice_McKandW_R2 i.practice_McKandW_R3 i.practice_McKandW_R4 ///
i.practice_McKandW_R5 i.practice_McKandW_R6 i.practice_McKandW_R7 i.practice_McKandW_R8 ///
i.practice_McKandW_F1 i.practice_McKandW_F2 i.practice_McKandW_F3 i.practice_McKandW_F4 ///
i.practice_McKandW_F5 i.practice_McKandW_F6 i.practice_McKandW_F7 i.practice_McKandW_F8 ///
i.firm_scooter i.firm_car i.firm_open_net_abovemd i.firm_open_net_abovep80 ///
i.firm_formal_reg sales_normday_top3share i.prods_dispose i.firm_stockout_wklyall ///
i.firm_stockup_fixall i.firm_stockup_lateany i.firm_stockup_wklyall i.firm_stockup_dailyall ///
practice_rec_suppl practice_rec_brands ///
practice_rec_prods practice_rec_sales practice_rec_assets ///
practice_rec_stock practice_rec_accpay_suppl practice_rec_accpay_loan ///
practice_rec_costs practice_rec_accrec_custom practice_rec_accrec_fam ///
practice_rec_ledger practice_rec_receipts practice_rec_twicewkly ///
practice_profit_nocosts practice_profit_allcosts practice_profit_any_daily ///
i.practice_inventory_demand ///
i.practice_inventory_space i.practice_inventory_profit i.practice_inventory_supplprice ///
i.practice_price_comp i.practice_price_demand i.practice_price_discount ///
i.practice_credit_trade i.practice_credit_trade_int c.owner_loan_apply c.owner_loan_obtain ///
c.owner_finlit_compscore i.practice_sales_comp i.practice_prods_new5 ///
i.practice_decide i.practice_discuss_any ///
labour_total c.firm_space_cont, vce(robust)
estimates store all_Pcomprep


*** Labour prod

reg productiv_labour i.practice_McKandW_M1 i.practice_McKandW_M2 ///
i.practice_McKandW_M3 i.practice_McKandW_M4 i.practice_McKandW_M5 i.practice_McKandW_M6 ///
i.practice_McKandW_M7 i.practice_McKandW_B1 i.practice_McKandW_B2 i.practice_McKandW_B3 ///
i.practice_McKandW_R1 i.practice_McKandW_R2 i.practice_McKandW_R3 i.practice_McKandW_R4 ///
i.practice_McKandW_R5 i.practice_McKandW_R6 i.practice_McKandW_R7 i.practice_McKandW_R8 ///
i.practice_McKandW_F1 i.practice_McKandW_F2 i.practice_McKandW_F3 i.practice_McKandW_F4 ///
i.practice_McKandW_F5 i.practice_McKandW_F6 i.practice_McKandW_F7 i.practice_McKandW_F8 ///
i.firm_scooter i.firm_car i.firm_open_net_abovemd i.firm_open_net_abovep80 ///
i.firm_formal_reg sales_normday_top3share i.prods_dispose i.firm_stockout_wklyall ///
i.firm_stockup_fixall i.firm_stockup_lateany i.firm_stockup_wklyall i.firm_stockup_dailyall ///
practice_rec_suppl practice_rec_brands ///
practice_rec_prods practice_rec_sales practice_rec_assets ///
practice_rec_stock practice_rec_accpay_suppl practice_rec_accpay_loan ///
practice_rec_costs practice_rec_accrec_custom practice_rec_accrec_fam ///
practice_rec_ledger practice_rec_receipts practice_rec_twicewkly ///
practice_profit_nocosts practice_profit_allcosts practice_profit_any_daily ///
i.practice_inventory_demand ///
i.practice_inventory_space i.practice_inventory_profit i.practice_inventory_supplprice ///
i.practice_price_comp i.practice_price_demand i.practice_price_discount ///
i.practice_credit_trade i.practice_credit_trade_int c.owner_loan_apply c.owner_loan_obtain ///
c.owner_finlit_compscore i.practice_sales_comp i.practice_prods_new5 ///
i.practice_decide i.practice_discuss_any ///
labour_total c.firm_space_cont, vce(robust)
estimates store all_prodlab


*** Customers

reg firm_custom_total i.practice_McKandW_M1 i.practice_McKandW_M2 ///
i.practice_McKandW_M3 i.practice_McKandW_M4 i.practice_McKandW_M5 i.practice_McKandW_M6 ///
i.practice_McKandW_M7 i.practice_McKandW_B1 i.practice_McKandW_B2 i.practice_McKandW_B3 ///
i.practice_McKandW_R1 i.practice_McKandW_R2 i.practice_McKandW_R3 i.practice_McKandW_R4 ///
i.practice_McKandW_R5 i.practice_McKandW_R6 i.practice_McKandW_R7 i.practice_McKandW_R8 ///
i.practice_McKandW_F1 i.practice_McKandW_F2 i.practice_McKandW_F3 i.practice_McKandW_F4 ///
i.practice_McKandW_F5 i.practice_McKandW_F6 i.practice_McKandW_F7 i.practice_McKandW_F8 ///
i.firm_scooter i.firm_car i.firm_open_net_abovemd i.firm_open_net_abovep80 ///
i.firm_formal_reg sales_normday_top3share i.prods_dispose i.firm_stockout_wklyall ///
i.firm_stockup_fixall i.firm_stockup_lateany i.firm_stockup_wklyall i.firm_stockup_dailyall ///
practice_rec_suppl practice_rec_brands ///
practice_rec_prods practice_rec_sales practice_rec_assets ///
practice_rec_stock practice_rec_accpay_suppl practice_rec_accpay_loan ///
practice_rec_costs practice_rec_accrec_custom practice_rec_accrec_fam ///
practice_rec_ledger practice_rec_receipts practice_rec_twicewkly ///
practice_profit_nocosts practice_profit_allcosts practice_profit_any_daily ///
i.practice_inventory_demand ///
i.practice_inventory_space i.practice_inventory_profit i.practice_inventory_supplprice ///
i.practice_price_comp i.practice_price_demand i.practice_price_discount ///
i.practice_credit_trade i.practice_credit_trade_int c.owner_loan_apply c.owner_loan_obtain ///
c.owner_finlit_compscore i.practice_sales_comp i.practice_prods_new5 ///
i.practice_decide i.practice_discuss_any ///
labour_total c.firm_space_cont, vce(robust)
estimates store all_custot

reg firm_custom_loy i.practice_McKandW_M1 i.practice_McKandW_M2 ///
i.practice_McKandW_M3 i.practice_McKandW_M4 i.practice_McKandW_M5 i.practice_McKandW_M6 ///
i.practice_McKandW_M7 i.practice_McKandW_B1 i.practice_McKandW_B2 i.practice_McKandW_B3 ///
i.practice_McKandW_R1 i.practice_McKandW_R2 i.practice_McKandW_R3 i.practice_McKandW_R4 ///
i.practice_McKandW_R5 i.practice_McKandW_R6 i.practice_McKandW_R7 i.practice_McKandW_R8 ///
i.practice_McKandW_F1 i.practice_McKandW_F2 i.practice_McKandW_F3 i.practice_McKandW_F4 ///
i.practice_McKandW_F5 i.practice_McKandW_F6 i.practice_McKandW_F7 i.practice_McKandW_F8 ///
i.firm_scooter i.firm_car i.firm_open_net_abovemd i.firm_open_net_abovep80 ///
i.firm_formal_reg sales_normday_top3share i.prods_dispose i.firm_stockout_wklyall ///
i.firm_stockup_fixall i.firm_stockup_lateany i.firm_stockup_wklyall i.firm_stockup_dailyall ///
practice_rec_suppl practice_rec_brands ///
practice_rec_prods practice_rec_sales practice_rec_assets ///
practice_rec_stock practice_rec_accpay_suppl practice_rec_accpay_loan ///
practice_rec_costs practice_rec_accrec_custom practice_rec_accrec_fam ///
practice_rec_ledger practice_rec_receipts practice_rec_twicewkly ///
practice_profit_nocosts practice_profit_allcosts practice_profit_any_daily ///
i.practice_inventory_demand ///
i.practice_inventory_space i.practice_inventory_profit i.practice_inventory_supplprice ///
i.practice_price_comp i.practice_price_demand i.practice_price_discount ///
i.practice_credit_trade i.practice_credit_trade_int c.owner_loan_apply c.owner_loan_obtain ///
c.owner_finlit_compscore i.practice_sales_comp i.practice_prods_new5 ///
i.practice_decide i.practice_discuss_any ///
labour_total c.firm_space_cont, vce(robust)
estimates store all_cusloy


*** Tables

* Sales and profits comp scores
estimates table all_Scompall all_Pcomprep, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse) 

* Lab prod, customers (total and loyal)
estimates table all_prodlab all_custot all_cusloy, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse)



* regress yvar xvarlist, vce(robust) // level(#)
* reg wage c.age##i.male c.age#c.age c.age#c.age#i.male, vce(robust) // Regress wage on age, male,ageحale, age2, and age2حale with age being continuous (c) and male a binary (i)

* dprobit survival bscore b_lnworkers b_paidworkers_miss b_paidworkers_zero b_manuf b_trade b_services  kenya nigeria srilanka if (country=="Kenya" & round==2)|(country=="Nigeria" & round==2)|(country=="Sri Lanka" & round==3), r
* probit yvar xvarlist, vce(robust) 


* dprobit survival bscore b_lnworkers b_paidworkers_miss b_paidworkers_zero b_manuf b_trade b_services  kenya nigeria srilanka if (country=="Kenya" & round==2)|(country=="Nigeria" & round==2)|(country=="Sri Lanka" & round==3), r
* probit yvar xvarlist, vce(robust) 



*** Heteroscedasticity
* estat imtest, white

*** Fitted value and residual for each obs
* predict yhatvar
* predict rvar, residuals

*** Table
* esttab est1 est2 using regs, rtf b(a3) se(a3) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) r2(3) ar2(3) scalars(F) nogaps


*** Graph
* twoway function y=_b[_cons]+_b[age]*x +_b[age2]*x^2 +_b[female]*1+_b[black]*1, range(0 30)

* probit survival bscore b_lnworkers b_paidworkers_miss b_paidworkers_zero b_manuf b_trade b_services  kenya nigeria srilanka if (country=="Kenya" & round==2)|(country=="Nigeria" & round==2)|(country=="Sri Lanka" & round==3), r
* probit yvar xvarlist, vce(robust)



************************************************************************
***** FACTOR ANALYSIS ************************************************


* Factors structure of McKandW vars
factor practice_McKandW_M1 practice_McKandW_M2 practice_McKandW_M3 ///
practice_McKandW_M4 practice_McKandW_M5 practice_McKandW_M6 practice_McKandW_M7 ///
practice_McKandW_B1 practice_McKandW_B2 practice_McKandW_B3 practice_McKandW_R1 ///
practice_McKandW_R2 practice_McKandW_R3 practice_McKandW_R4 practice_McKandW_R5 ///
practice_McKandW_R6 practice_McKandW_R7 practice_McKandW_R8 practice_McKandW_F1 ///
practice_McKandW_F2 practice_McKandW_F3 practice_McKandW_F4 practice_McKandW_F5 ///
practice_McKandW_F6 practice_McKandW_F7 practice_McKandW_F8, ml blanks(0.2) factors(4)


* Factor structur of var set
factor practice_McKandW_M1 practice_McKandW_M2 practice_McKandW_M3 ///
practice_McKandW_M4 practice_McKandW_M5 practice_McKandW_M6 practice_McKandW_M7 ///
practice_McKandW_B1 practice_McKandW_B2 practice_McKandW_B3 practice_McKandW_R1 ///
practice_McKandW_R2 practice_McKandW_R3 practice_McKandW_R4 practice_McKandW_R5 ///
practice_McKandW_R6 practice_McKandW_R7 practice_McKandW_R8 practice_McKandW_F1 ///
practice_McKandW_F2 practice_McKandW_F3 practice_McKandW_F4 practice_McKandW_F5 ///
practice_McKandW_F6 practice_McKandW_F7 practice_McKandW_F8 ///
/*firm_scooter firm_car*/ firm_open_net_abovemd ///
firm_formal_reg sales_normday_top3share prods_dispose firm_stockout_wklyall ///
firm_stockup_fixall firm_stockup_lateany firm_stockup_wklyall firm_stockup_dailyall ///
practice_rec_suppl practice_rec_brands practice_rec_prods practice_rec_sales ///
practice_rec_assets practice_rec_stock practice_rec_accpay_suppl ///
practice_rec_accpay_loan practice_rec_costs practice_rec_accrec_custom ///
practice_rec_accrec_fam practice_rec_ledger practice_rec_receipts practice_rec_twicewkly ///
practice_profit_nocosts practice_profit_allcosts practice_profit_any_daily ///
practice_inventory_demand practice_inventory_space practice_inventory_profit practice_inventory_supplprice /// 
practice_price_comp practice_price_demand practice_price_discount ///
practice_credit_trade practice_credit_trade_int owner_loan_apply /*owner_loan_obtain*/ ///
/*owner_finlit_compscore*/ practice_sales_comp practice_prods_new5 /// 
practice_discuss_sales practice_discuss_sellprice practice_discuss_bestsell ///
practice_discuss_finance practice_discuss_buyprice practice_discuss_newprod ///
practice_discuss_practice practice_discuss_plan ///
practice_decide_sales practice_decide_sellprice practice_decide_bestsell ///
practice_decide_finance practice_decide_buyprice practice_decide_newprod ///
practice_decide_practice practice_decide_plan ///
practice_decide_agreed finances_separate, ml blanks(0.3) factors(6)



************************************************************************
***** M Marketing regs ************************************************


***** SALES AND PROFITS, COMP SCORE (calc and self-rep for sales, self-rep only for profits)

*** Sales, IHS-transformed and w/out transformation (both win at p99)
reg sales_mthly_comp_all_ihs_win ///
i.practice_McKandW_M1 i.practice_McKandW_M2 i.practice_McKandW_M3 ///
i.practice_McKandW_M4 i.practice_McKandW_M5 i.practice_McKandW_M6 i.practice_McKandW_M7 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_mthly_comp_all_win ///
i.practice_McKandW_M1 i.practice_McKandW_M2 i.practice_McKandW_M3 ///
i.practice_McKandW_M4 i.practice_McKandW_M5 i.practice_McKandW_M6 i.practice_McKandW_M7 ///
labour_total firm_space_cont, vce(robust) // level(90)

*** Profits, IHS-transformed and w/out transformation (both win at p99)
reg profit_mthly_comp_rep_ihs_win ///
i.practice_McKandW_M1 i.practice_McKandW_M2 i.practice_McKandW_M3 ///
i.practice_McKandW_M4 i.practice_McKandW_M5 i.practice_McKandW_M6 i.practice_McKandW_M7 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_mthly_comp_rep_win ///
i.practice_McKandW_M1 i.practice_McKandW_M2 i.practice_McKandW_M3 ///
i.practice_McKandW_M4 i.practice_McKandW_M5 i.practice_McKandW_M6 i.practice_McKandW_M7 ///
labour_total firm_space_cont, vce(robust) // level(90)


***** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

reg sales_normday_ihs_win ///
i.practice_McKandW_M1 i.practice_McKandW_M2 i.practice_McKandW_M3 ///
i.practice_McKandW_M4 i.practice_McKandW_M5 i.practice_McKandW_M6 i.practice_McKandW_M7 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_normday_topprods_ihs_win ///
i.practice_McKandW_M1 i.practice_McKandW_M2 i.practice_McKandW_M3 ///
i.practice_McKandW_M4 i.practice_McKandW_M5 i.practice_McKandW_M6 i.practice_McKandW_M7 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_normday_ihs_win ///
i.practice_McKandW_M1 i.practice_McKandW_M2 i.practice_McKandW_M3 ///
i.practice_McKandW_M4 i.practice_McKandW_M5 i.practice_McKandW_M6 i.practice_McKandW_M7 ///
labour_total firm_space_cont, vce(robust) // level(90)


***** CUSTOMERS

reg firm_custom_total ///
i.practice_McKandW_M1 i.practice_McKandW_M2 i.practice_McKandW_M3 ///
i.practice_McKandW_M4 i.practice_McKandW_M5 i.practice_McKandW_M6 i.practice_McKandW_M7 ///
labour_total firm_space_cont, vce(robust) // level(90)



************************************************************************
***** M+ Additional marketing regs ************************************************


***** SALES AND PROFITS, COMP SCORE (calc and self-rep for sales, self-rep only for profits)

*** Sales, IHS-transformed and w/out transformation (both win at p99)
reg sales_mthly_comp_all_ihs_win ///
i.practice_price_comp i.practice_sales_comp ///
i.practice_discuss_newprod ///
i.practice_discuss_suppl i.practice_discuss_bestsell ///
i.practice_price_discount ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_mthly_comp_all_win ///
i.practice_price_comp i.practice_sales_comp ///
i.practice_discuss_newprod ///
i.practice_discuss_suppl i.practice_discuss_bestsell ///
i.practice_price_discount ///
labour_total firm_space_cont, vce(robust) // level(90)

*** Profits, IHS-transformed and w/out transformation (both win at p99)
reg profit_mthly_comp_rep_ihs_win ///
i.practice_price_comp i.practice_sales_comp ///
i.practice_discuss_newprod ///
i.practice_discuss_suppl i.practice_discuss_bestsell ///
i.practice_price_discount ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_mthly_comp_rep_win ///
i.practice_price_comp i.practice_sales_comp ///
i.practice_discuss_newprod ///
i.practice_discuss_suppl i.practice_discuss_bestsell ///
i.practice_price_discount ///
labour_total firm_space_cont, vce(robust) // level(90)


***** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

reg sales_normday_ihs_win ///
i.practice_price_comp i.practice_sales_comp ///
i.practice_discuss_newprod ///
i.practice_discuss_suppl i.practice_discuss_bestsell ///
i.practice_price_discount ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_normday_topprods_ihs_win ///
i.practice_price_comp i.practice_sales_comp ///
i.practice_discuss_newprod ///
i.practice_discuss_suppl i.practice_discuss_bestsell ///
i.practice_price_discount ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_normday_ihs_win ///
i.practice_price_comp i.practice_sales_comp ///
i.practice_discuss_newprod ///
i.practice_discuss_suppl i.practice_discuss_bestsell ///
i.practice_price_discount ///
labour_total firm_space_cont, vce(robust) // level(90)


***** CUSTOMERS

reg firm_custom_total ///
i.practice_price_comp i.practice_sales_comp ///
i.practice_discuss_newprod ///
i.practice_discuss_suppl i.practice_discuss_bestsell ///
i.practice_price_discount ///
labour_total firm_space_cont, vce(robust) // level(90)



************************************************************************
***** B Stocking-up regs ************************************************


***** SALES AND PROFITS, COMP SCORE (calc and self-rep for sales, self-rep only for profits)

*** Sales, IHS-transformed and w/out transformation (both win at p99)
reg sales_mthly_comp_all_ihs_win ///
i.practice_McKandW_B1 i.practice_McKandW_B2 i.practice_McKandW_B3 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_mthly_comp_all_win ///
i.practice_McKandW_B1 i.practice_McKandW_B2 i.practice_McKandW_B3 ///
labour_total firm_space_cont, vce(robust) // level(90)

*** Profits, IHS-transformed and w/out transformation (both win at p99)
reg profit_mthly_comp_rep_ihs_win ///
i.practice_McKandW_B1 i.practice_McKandW_B2 i.practice_McKandW_B3 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_mthly_comp_rep_win ///
i.practice_McKandW_B1 i.practice_McKandW_B2 i.practice_McKandW_B3 ///
labour_total firm_space_cont, vce(robust) // level(90)


***** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

reg sales_normday_ihs_win ///
i.practice_McKandW_B1 i.practice_McKandW_B2 i.practice_McKandW_B3 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_normday_topprods_ihs_win ///
i.practice_McKandW_B1 i.practice_McKandW_B2 i.practice_McKandW_B3 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_normday_ihs_win ///
i.practice_McKandW_B1 i.practice_McKandW_B2 i.practice_McKandW_B3 ///
labour_total firm_space_cont, vce(robust) // level(90)


***** CUSTOMERS

reg firm_custom_total ///
i.practice_McKandW_B1 i.practice_McKandW_B2 i.practice_McKandW_B3 ///
labour_total firm_space_cont, vce(robust) // level(90)



************************************************************************
***** B+ Additional stocking-up regs ************************************************


***** SALES AND PROFITS, COMP SCORE (calc and self-rep for sales, self-rep only for profits)

*** Sales, IHS-transformed and w/out transformation (both win at p99)
reg sales_mthly_comp_all_ihs_win ///
i.firm_stockout_wklyall i.firm_stockup_lateany ///
i.firm_stockup_fixall i.firm_stockup_wklyall i.firm_stockup_dailyall ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_mthly_comp_all_win ///
i.firm_stockout_wklyall i.firm_stockup_lateany ///
i.firm_stockup_fixall i.firm_stockup_wklyall i.firm_stockup_dailyall ///
labour_total firm_space_cont, vce(robust) // level(90)

*** Profits, IHS-transformed and w/out transformation (both win at p99)
reg profit_mthly_comp_rep_ihs_win ///
i.firm_stockout_wklyall i.firm_stockup_lateany ///
i.firm_stockup_fixall i.firm_stockup_wklyall i.firm_stockup_dailyall ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_mthly_comp_rep_win ///
i.firm_stockout_wklyall i.firm_stockup_lateany ///
i.firm_stockup_fixall i.firm_stockup_wklyall i.firm_stockup_dailyall ///
labour_total firm_space_cont, vce(robust) // level(90)


***** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

reg sales_normday_ihs_win ///
i.firm_stockout_wklyall i.firm_stockup_lateany ///
i.firm_stockup_fixall i.firm_stockup_wklyall i.firm_stockup_dailyall ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_normday_topprods_ihs_win ///
i.firm_stockout_wklyall i.firm_stockup_lateany ///
i.firm_stockup_fixall i.firm_stockup_wklyall i.firm_stockup_dailyall ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_normday_ihs_win ///
i.firm_stockout_wklyall i.firm_stockup_lateany ///
i.firm_stockup_fixall i.firm_stockup_wklyall i.firm_stockup_dailyall ///
labour_total firm_space_cont, vce(robust) // level(90)


***** CUSTOMERS

reg firm_custom_total ///
i.firm_stockout_wklyall i.firm_stockup_lateany ///
i.firm_stockup_fixall i.firm_stockup_wklyall i.firm_stockup_dailyall ///
labour_total firm_space_cont, vce(robust) // level(90)



***********************************************************************
***** R Record-keeping regs *****************************************


***** SALES AND PROFITS, COMP SCORE (calc and self-rep for sales, self-rep only for profits)

*** Sales, IHS-transformed and w/out transformation (both win at p99)
reg sales_mthly_comp_all_ihs_win ///
i.practice_McKandW_R1 i.practice_McKandW_R2 i.practice_McKandW_R3 i.practice_McKandW_R4 ///
i.practice_McKandW_R5 i.practice_McKandW_R6 i.practice_McKandW_R7 i.practice_McKandW_R8 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_mthly_comp_all_win ///
i.practice_McKandW_R1 i.practice_McKandW_R2 i.practice_McKandW_R3 i.practice_McKandW_R4 ///
i.practice_McKandW_R5 i.practice_McKandW_R6 i.practice_McKandW_R7 i.practice_McKandW_R8 ///
labour_total firm_space_cont, vce(robust) // level(90)

*** Profits, IHS-transformed and w/out transformation (both win at p99)
reg profit_mthly_comp_rep_ihs_win ///
i.practice_McKandW_R1 i.practice_McKandW_R2 i.practice_McKandW_R3 i.practice_McKandW_R4 ///
i.practice_McKandW_R5 i.practice_McKandW_R6 i.practice_McKandW_R7 i.practice_McKandW_R8 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_mthly_comp_rep_win ///
i.practice_McKandW_R1 i.practice_McKandW_R2 i.practice_McKandW_R3 i.practice_McKandW_R4 ///
i.practice_McKandW_R5 i.practice_McKandW_R6 i.practice_McKandW_R7 i.practice_McKandW_R8 ///
labour_total firm_space_cont, vce(robust) // level(90)


***** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

reg sales_normday_ihs_win ///
i.practice_McKandW_R1 i.practice_McKandW_R2 i.practice_McKandW_R3 i.practice_McKandW_R4 ///
i.practice_McKandW_R5 i.practice_McKandW_R6 i.practice_McKandW_R7 i.practice_McKandW_R8 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_normday_topprods_ihs_win ///
i.practice_McKandW_R1 i.practice_McKandW_R2 i.practice_McKandW_R3 i.practice_McKandW_R4 ///
i.practice_McKandW_R5 i.practice_McKandW_R6 i.practice_McKandW_R7 i.practice_McKandW_R8 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_normday_ihs_win ///
i.practice_McKandW_R1 i.practice_McKandW_R2 i.practice_McKandW_R3 i.practice_McKandW_R4 ///
i.practice_McKandW_R5 i.practice_McKandW_R6 i.practice_McKandW_R7 i.practice_McKandW_R8 ///
labour_total firm_space_cont, vce(robust) // level(90)


***** CUSTOMERS

reg firm_custom_total ///
i.practice_McKandW_R1 i.practice_McKandW_R2 i.practice_McKandW_R3 i.practice_McKandW_R4 ///
i.practice_McKandW_R5 i.practice_McKandW_R6 i.practice_McKandW_R7 i.practice_McKandW_R8 ///
labour_total firm_space_cont, vce(robust) // level(90)



************************************************************************
***** R+ Additional: record-keeping *************************************


***** SALES AND PROFITS, COMP SCORE (calc and self-rep for sales, self-rep only for profits)

*** Sales, IHS-transformed and w/out transformation (both win at p99)
reg sales_mthly_comp_all_ihs_win ///
i.practice_rec_ledger i.practice_rec_receipts i.practice_rec_twicewkly ///
i.practice_rec_suppl i.practice_rec_brands i.practice_rec_prods i.practice_rec_sales ///
i.practice_rec_assets i.practice_rec_stock i.practice_rec_accpay_suppl ///
i.practice_rec_accpay_loan i.practice_rec_costs i.practice_rec_accrec_custom i.practice_rec_accrec_fam ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_mthly_comp_all_win ///
i.practice_rec_ledger i.practice_rec_receipts i.practice_rec_twicewkly ///
i.practice_rec_suppl i.practice_rec_brands i.practice_rec_prods i.practice_rec_sales ///
i.practice_rec_assets i.practice_rec_stock i.practice_rec_accpay_suppl ///
i.practice_rec_accpay_loan i.practice_rec_costs i.practice_rec_accrec_custom i.practice_rec_accrec_fam ///
labour_total firm_space_cont, vce(robust) // level(90)

*** Profits, IHS-transformed and w/out transformation (both win at p99)
reg profit_mthly_comp_rep_ihs_win ///
i.practice_rec_ledger i.practice_rec_receipts i.practice_rec_twicewkly ///
i.practice_rec_suppl i.practice_rec_brands i.practice_rec_prods i.practice_rec_sales ///
i.practice_rec_assets i.practice_rec_stock i.practice_rec_accpay_suppl ///
i.practice_rec_accpay_loan i.practice_rec_costs i.practice_rec_accrec_custom i.practice_rec_accrec_fam ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_mthly_comp_rep_win ///
i.practice_rec_ledger i.practice_rec_receipts i.practice_rec_twicewkly ///
i.practice_rec_suppl i.practice_rec_brands i.practice_rec_prods i.practice_rec_sales ///
i.practice_rec_assets i.practice_rec_stock i.practice_rec_accpay_suppl ///
i.practice_rec_accpay_loan i.practice_rec_costs i.practice_rec_accrec_custom i.practice_rec_accrec_fam ///
labour_total firm_space_cont, vce(robust) // level(90)


***** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

reg sales_normday_ihs_win ///
i.practice_rec_ledger i.practice_rec_receipts i.practice_rec_twicewkly ///
i.practice_rec_suppl i.practice_rec_brands i.practice_rec_prods i.practice_rec_sales ///
i.practice_rec_assets i.practice_rec_stock i.practice_rec_accpay_suppl ///
i.practice_rec_accpay_loan i.practice_rec_costs i.practice_rec_accrec_custom i.practice_rec_accrec_fam ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_normday_topprods_ihs_win ///
i.practice_rec_ledger i.practice_rec_receipts i.practice_rec_twicewkly ///
i.practice_rec_suppl i.practice_rec_brands i.practice_rec_prods i.practice_rec_sales ///
i.practice_rec_assets i.practice_rec_stock i.practice_rec_accpay_suppl ///
i.practice_rec_accpay_loan i.practice_rec_costs i.practice_rec_accrec_custom i.practice_rec_accrec_fam ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_normday_ihs_win ///
i.practice_rec_ledger i.practice_rec_receipts i.practice_rec_twicewkly ///
i.practice_rec_suppl i.practice_rec_brands i.practice_rec_prods i.practice_rec_sales ///
i.practice_rec_assets i.practice_rec_stock i.practice_rec_accpay_suppl ///
i.practice_rec_accpay_loan i.practice_rec_costs i.practice_rec_accrec_custom i.practice_rec_accrec_fam ///
labour_total firm_space_cont, vce(robust) // level(90)


***** CUSTOMERS

reg firm_custom_total ///
i.practice_rec_ledger i.practice_rec_receipts i.practice_rec_twicewkly ///
i.practice_rec_suppl i.practice_rec_brands i.practice_rec_prods i.practice_rec_sales ///
i.practice_rec_assets i.practice_rec_stock i.practice_rec_accpay_suppl ///
i.practice_rec_accpay_loan i.practice_rec_costs i.practice_rec_accrec_custom i.practice_rec_accrec_fam ///
labour_total firm_space_cont, vce(robust) // level(90)


************************************************************************
***** R+ Additional: profit calcs ********************************************


***** SALES AND PROFITS, COMP SCORE (calc and self-rep for sales, self-rep only for profits)

*** Sales, IHS-transformed and w/out transformation (both win at p99)
reg sales_mthly_comp_all_ihs_win ///
i.practice_profit_nocosts i.practice_profit_allcosts i.practice_profit_any_daily ///
i.practice_inventory_profit i.practice_inventory_supplprice ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_mthly_comp_all_win ///
i.practice_profit_nocosts i.practice_profit_allcosts i.practice_profit_any_daily ///
i.practice_inventory_profit i.practice_inventory_supplprice ///
labour_total firm_space_cont, vce(robust) // level(90)

*** Profits, IHS-transformed and w/out transformation (both win at p99)
reg profit_mthly_comp_rep_ihs_win ///
i.practice_profit_nocosts i.practice_profit_allcosts i.practice_profit_any_daily ///
i.practice_inventory_profit i.practice_inventory_supplprice ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_mthly_comp_rep_win ///
i.practice_profit_nocosts i.practice_profit_allcosts i.practice_profit_any_daily ///
i.practice_inventory_profit i.practice_inventory_supplprice ///
labour_total firm_space_cont, vce(robust) // level(90)


***** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

reg sales_normday_ihs_win ///
i.practice_profit_nocosts i.practice_profit_allcosts i.practice_profit_any_daily ///
i.practice_inventory_profit i.practice_inventory_supplprice ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_normday_topprods_ihs_win ///
i.practice_profit_nocosts i.practice_profit_allcosts i.practice_profit_any_daily ///
i.practice_inventory_profit i.practice_inventory_supplprice ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_normday_ihs_win ///
i.practice_profit_nocosts i.practice_profit_allcosts i.practice_profit_any_daily ///
i.practice_inventory_profit i.practice_inventory_supplprice ///
labour_total firm_space_cont, vce(robust) // level(90)


***** CUSTOMERS

reg firm_custom_total ///
i.practice_profit_nocosts i.practice_profit_allcosts i.practice_profit_any_daily ///
i.practice_inventory_profit i.practice_inventory_supplprice ///
labour_total firm_space_cont, vce(robust) // level(90)



************************************************************************
***** F Planning regs ************************************************


***** SALES AND PROFITS, COMP SCORE (calc and self-rep for sales, self-rep only for profits)

*** Sales, IHS-transformed and w/out transformation (both win at p99)
reg sales_mthly_comp_all_ihs_win ///
i.practice_McKandW_F1 i.practice_McKandW_F2 i.practice_McKandW_F3 i.practice_McKandW_F4 ///
i.practice_McKandW_F5 i.practice_McKandW_F6 i.practice_McKandW_F7 i.practice_McKandW_F8 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_mthly_comp_all_win ///
i.practice_McKandW_F1 i.practice_McKandW_F2 i.practice_McKandW_F3 i.practice_McKandW_F4 ///
i.practice_McKandW_F5 i.practice_McKandW_F6 i.practice_McKandW_F7 i.practice_McKandW_F8 ///
labour_total firm_space_cont, vce(robust) // level(90)

*** Profits, IHS-transformed and w/out transformation (both win at p99)
reg profit_mthly_comp_rep_ihs_win ///
i.practice_McKandW_F1 i.practice_McKandW_F2 i.practice_McKandW_F3 i.practice_McKandW_F4 ///
i.practice_McKandW_F5 i.practice_McKandW_F6 i.practice_McKandW_F7 i.practice_McKandW_F8 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_mthly_comp_rep_win ///
i.practice_McKandW_F1 i.practice_McKandW_F2 i.practice_McKandW_F3 i.practice_McKandW_F4 ///
i.practice_McKandW_F5 i.practice_McKandW_F6 i.practice_McKandW_F7 i.practice_McKandW_F8 ///
labour_total firm_space_cont, vce(robust) // level(90)


***** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

reg sales_normday_ihs_win ///
i.practice_McKandW_F1 i.practice_McKandW_F2 i.practice_McKandW_F3 i.practice_McKandW_F4 ///
i.practice_McKandW_F5 i.practice_McKandW_F6 i.practice_McKandW_F7 i.practice_McKandW_F8 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_normday_topprods_ihs_win ///
i.practice_McKandW_F1 i.practice_McKandW_F2 i.practice_McKandW_F3 i.practice_McKandW_F4 ///
i.practice_McKandW_F5 i.practice_McKandW_F6 i.practice_McKandW_F7 i.practice_McKandW_F8 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_normday_ihs_win ///
i.practice_McKandW_F1 i.practice_McKandW_F2 i.practice_McKandW_F3 i.practice_McKandW_F4 ///
i.practice_McKandW_F5 i.practice_McKandW_F6 i.practice_McKandW_F7 i.practice_McKandW_F8 ///
labour_total firm_space_cont, vce(robust) // level(90)


***** CUSTOMERS

reg firm_custom_total ///
i.practice_McKandW_F1 i.practice_McKandW_F2 i.practice_McKandW_F3 i.practice_McKandW_F4 ///
i.practice_McKandW_F5 i.practice_McKandW_F6 i.practice_McKandW_F7 i.practice_McKandW_F8 ///
labour_total firm_space_cont, vce(robust) // level(90)



************************************************************************
***** F+ Additional planning regs ************************************************



************************************************************************
***** Product management (inventory, pricing) and firm characteristics ************


***** W  TOP3 SHARE ABOVE P80

*** SALES AND PROFITS, COMP SCORE (calc and self-rep for sales, self-rep only for profits)

* Sales, IHS-transformed and w/out transformation (both win at p99)
reg sales_mthly_comp_all_ihs_win ///
i.sales_normday_top3share_abovep80 i.practice_prods_new5 prods_dispose ///
i.practice_inventory_demand i.practice_inventory_space ///
i.practice_price_demand ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_mthly_comp_all_win ///
i.sales_normday_top3share_abovep80 i.practice_prods_new5 prods_dispose ///
i.practice_inventory_demand i.practice_inventory_space ///
i.practice_price_demand ///
labour_total firm_space_cont, vce(robust) // level(90)

* Profits, IHS-transformed and w/out transformation (both win at p99)
reg profit_mthly_comp_rep_ihs_win ///
i.sales_normday_top3share_abovep80 i.practice_prods_new5 prods_dispose ///
i.practice_inventory_demand i.practice_inventory_space ///
i.practice_price_demand ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_mthly_comp_rep_win ///
i.sales_normday_top3share_abovep80 i.practice_prods_new5 prods_dispose ///
i.practice_inventory_demand i.practice_inventory_space ///
i.practice_price_demand ///
labour_total firm_space_cont, vce(robust) // level(90)


*** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

reg sales_normday_ihs_win ///
i.sales_normday_top3share_abovep80 i.practice_prods_new5 prods_dispose ///
i.practice_inventory_demand i.practice_inventory_space ///
i.practice_price_demand ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_normday_topprods_ihs_win ///
i.sales_normday_top3share_abovep80 i.practice_prods_new5 prods_dispose ///
i.practice_inventory_demand i.practice_inventory_space ///
i.practice_price_demand ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_normday_ihs_win ///
i.sales_normday_top3share_abovep80 i.practice_prods_new5 prods_dispose ///
i.practice_inventory_demand i.practice_inventory_space ///
i.practice_price_demand ///
labour_total firm_space_cont, vce(robust) // level(90)


*** CUSTOMERS

reg firm_custom_total ///
i.sales_normday_top3share_abovep80 i.practice_prods_new5 prods_dispose ///
i.practice_inventory_demand i.practice_inventory_space ///
i.practice_price_demand ///
labour_total firm_space_cont, vce(robust) // level(90)



***** W  TOP3 SHARE ABOVE MEDIAN


*** SALES AND PROFITS, COMP SCORE (calc and self-rep for sales, self-rep only for profits)

* Sales, IHS-transformed and w/out transformation (both win at p99)
reg sales_mthly_comp_all_ihs_win ///
i.sales_normday_top3share_abovemd i.practice_prods_new5 prods_dispose ///
i.practice_inventory_demand i.practice_inventory_space ///
i.practice_price_demand ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_mthly_comp_all_win ///
i.sales_normday_top3share_abovemd i.practice_prods_new5 prods_dispose ///
i.practice_inventory_demand i.practice_inventory_space ///
i.practice_price_demand ///
labour_total firm_space_cont, vce(robust) // level(90)

* Profits, IHS-transformed and w/out transformation (both win at p99)
reg profit_mthly_comp_rep_ihs_win ///
i.sales_normday_top3share_abovemd i.practice_prods_new5 prods_dispose ///
i.practice_inventory_demand i.practice_inventory_space ///
i.practice_price_demand ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_mthly_comp_rep_win ///
i.sales_normday_top3share_abovemd i.practice_prods_new5 prods_dispose ///
i.practice_inventory_demand i.practice_inventory_space ///
i.practice_price_demand ///
labour_total firm_space_cont, vce(robust) // level(90)


*** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

reg sales_normday_ihs_win ///
i.sales_normday_top3share_abovemd i.practice_prods_new5 prods_dispose ///
i.practice_inventory_demand i.practice_inventory_space ///
i.practice_price_demand ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_normday_topprods_ihs_win ///
i.sales_normday_top3share_abovemd i.practice_prods_new5 prods_dispose ///
i.practice_inventory_demand i.practice_inventory_space ///
i.practice_price_demand ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_normday_ihs_win ///
i.sales_normday_top3share_abovemd i.practice_prods_new5 prods_dispose ///
i.practice_inventory_demand i.practice_inventory_space ///
i.practice_price_demand ///
labour_total firm_space_cont, vce(robust) // level(90)


*** CUSTOMERS

reg firm_custom_total ///
i.sales_normday_top3share_abovemd i.practice_prods_new5 prods_dispose ///
i.practice_inventory_demand i.practice_inventory_space ///
i.practice_price_demand ///
labour_total firm_space_cont, vce(robust) // level(90)



************************************************************************
***** Assortment *******************************************


***** SPECIFIC PROD AMONG TOP7 W POS DAILY SALES

*** PROFITS, COMP SCORE (calc and self-rep for sales, self-rep only for profits)

* Sales, IHS-transformed and w/out transformation (both win at p99)
reg sales_mthly_comp_all_ihs_win ///
i.topprods_rice_1 i.topprods_flour_1 i.topprods_eggs_1 i.topprods_noodles_1 i.topprods_oil_1 ///
i.topprods_saltsugar_1 i.topprods_bread_1 i.topprods_coffeetea_1 i.topprods_homecooked_1 ///
i.topprods_snacks_1 i.topprods_freshdrinks_1 i.topprods_softdrinks_1 i.topprods_sanitary_1 ///
i.topprods_cleaning_1 i.topprods_baby_1 i.topprods_tobacco_1 i.topprods_meds_1 ///
i.topprods_gaspetrol_1 i.topprods_phone_1 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_mthly_comp_all_win ///
i.topprods_rice_1 i.topprods_flour_1 i.topprods_eggs_1 i.topprods_noodles_1 i.topprods_oil_1 ///
i.topprods_saltsugar_1 i.topprods_bread_1 i.topprods_coffeetea_1 i.topprods_homecooked_1 ///
i.topprods_snacks_1 i.topprods_freshdrinks_1 i.topprods_softdrinks_1 i.topprods_sanitary_1 ///
i.topprods_cleaning_1 i.topprods_baby_1 i.topprods_tobacco_1 i.topprods_meds_1 ///
i.topprods_gaspetrol_1 i.topprods_phone_1 ///
labour_total firm_space_cont, vce(robust) // level(90)

* Profits, IHS-transformed and w/out transformation (both win at p99)
reg profit_mthly_comp_rep_ihs_win ///
i.topprods_rice_1 i.topprods_flour_1 i.topprods_eggs_1 i.topprods_noodles_1 i.topprods_oil_1 ///
i.topprods_saltsugar_1 i.topprods_bread_1 i.topprods_coffeetea_1 i.topprods_homecooked_1 ///
i.topprods_snacks_1 i.topprods_freshdrinks_1 i.topprods_softdrinks_1 i.topprods_sanitary_1 ///
i.topprods_cleaning_1 i.topprods_baby_1 i.topprods_tobacco_1 i.topprods_meds_1 ///
i.topprods_gaspetrol_1 i.topprods_phone_1 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_mthly_comp_rep_win ///
i.topprods_rice_1 i.topprods_flour_1 i.topprods_eggs_1 i.topprods_noodles_1 i.topprods_oil_1 ///
i.topprods_saltsugar_1 i.topprods_bread_1 i.topprods_coffeetea_1 i.topprods_homecooked_1 ///
i.topprods_snacks_1 i.topprods_freshdrinks_1 i.topprods_softdrinks_1 i.topprods_sanitary_1 ///
i.topprods_cleaning_1 i.topprods_baby_1 i.topprods_tobacco_1 i.topprods_meds_1 ///
i.topprods_gaspetrol_1 i.topprods_phone_1 ///
labour_total firm_space_cont, vce(robust) // level(90)


*** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

reg sales_normday_ihs_win ///
i.topprods_rice_1 i.topprods_flour_1 i.topprods_eggs_1 i.topprods_noodles_1 i.topprods_oil_1 ///
i.topprods_saltsugar_1 i.topprods_bread_1 i.topprods_coffeetea_1 i.topprods_homecooked_1 ///
i.topprods_snacks_1 i.topprods_freshdrinks_1 i.topprods_softdrinks_1 i.topprods_sanitary_1 ///
i.topprods_cleaning_1 i.topprods_baby_1 i.topprods_tobacco_1 i.topprods_meds_1 ///
i.topprods_gaspetrol_1 i.topprods_phone_1 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_normday_topprods_ihs_win ///
i.topprods_rice_1 i.topprods_flour_1 i.topprods_eggs_1 i.topprods_noodles_1 i.topprods_oil_1 ///
i.topprods_saltsugar_1 i.topprods_bread_1 i.topprods_coffeetea_1 i.topprods_homecooked_1 ///
i.topprods_snacks_1 i.topprods_freshdrinks_1 i.topprods_softdrinks_1 i.topprods_sanitary_1 ///
i.topprods_cleaning_1 i.topprods_baby_1 i.topprods_tobacco_1 i.topprods_meds_1 ///
i.topprods_gaspetrol_1 i.topprods_phone_1 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_normday_ihs_win ///
i.topprods_rice_1 i.topprods_flour_1 i.topprods_eggs_1 i.topprods_noodles_1 i.topprods_oil_1 ///
i.topprods_saltsugar_1 i.topprods_bread_1 i.topprods_coffeetea_1 i.topprods_homecooked_1 ///
i.topprods_snacks_1 i.topprods_freshdrinks_1 i.topprods_softdrinks_1 i.topprods_sanitary_1 ///
i.topprods_cleaning_1 i.topprods_baby_1 i.topprods_tobacco_1 i.topprods_meds_1 ///
i.topprods_gaspetrol_1 i.topprods_phone_1 ///
labour_total firm_space_cont, vce(robust) // level(90)


*** CUSTOMERS

reg firm_custom_total ///
i.topprods_rice_1 i.topprods_flour_1 i.topprods_eggs_1 i.topprods_noodles_1 i.topprods_oil_1 ///
i.topprods_saltsugar_1 i.topprods_bread_1 i.topprods_coffeetea_1 i.topprods_homecooked_1 ///
i.topprods_snacks_1 i.topprods_freshdrinks_1 i.topprods_softdrinks_1 i.topprods_sanitary_1 ///
i.topprods_cleaning_1 i.topprods_baby_1 i.topprods_tobacco_1 i.topprods_meds_1 ///
i.topprods_gaspetrol_1 i.topprods_phone_1 ///
labour_total firm_space_cont, vce(robust) // level(90)



***** TOP7 PROD W DAILY SALES IN P80 OF SAMPLE


*** PROFITS, COMP SCORE (calc and self-rep for sales, self-rep only for profits)

* Sales, IHS-transformed and w/out transformation (both win at p99)
reg sales_mthly_comp_all_ihs_win ///
i.topprods_rice_abovep80 i.topprods_flour_abovep80 i.topprods_eggs_abovep80 i.topprods_noodles_abovep80 i.topprods_oil_abovep80 ///
i.topprods_saltsugar_abovep80 i.topprods_bread_abovep80 i.topprods_coffeetea_abovep80 i.topprods_homecooked_abovep80 ///
i.topprods_snacks_abovep80 i.topprods_freshdrinks_abovep80 i.topprods_softdrinks_abovep80 i.topprods_sanitary_abovep80 ///
i.topprods_cleaning_abovep80 i.topprods_baby_abovep80 i.topprods_tobacco_abovep80 i.topprods_meds_abovep80 ///
i.topprods_gaspetrol_abovep80 i.topprods_phone_abovep80 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_mthly_comp_all_win ///
i.topprods_rice_abovep80 i.topprods_flour_abovep80 i.topprods_eggs_abovep80 i.topprods_noodles_abovep80 i.topprods_oil_abovep80 ///
i.topprods_saltsugar_abovep80 i.topprods_bread_abovep80 i.topprods_coffeetea_abovep80 i.topprods_homecooked_abovep80 ///
i.topprods_snacks_abovep80 i.topprods_freshdrinks_abovep80 i.topprods_softdrinks_abovep80 i.topprods_sanitary_abovep80 ///
i.topprods_cleaning_abovep80 i.topprods_baby_abovep80 i.topprods_tobacco_abovep80 i.topprods_meds_abovep80 ///
i.topprods_gaspetrol_abovep80 i.topprods_phone_abovep80 ///
labour_total firm_space_cont, vce(robust) // level(90)

* Profits, IHS-transformed and w/out transformation (both win at p99)
reg profit_mthly_comp_rep_ihs_win ///
i.topprods_rice_abovep80 i.topprods_flour_abovep80 i.topprods_eggs_abovep80 i.topprods_noodles_abovep80 i.topprods_oil_abovep80 ///
i.topprods_saltsugar_abovep80 i.topprods_bread_abovep80 i.topprods_coffeetea_abovep80 i.topprods_homecooked_abovep80 ///
i.topprods_snacks_abovep80 i.topprods_freshdrinks_abovep80 i.topprods_softdrinks_abovep80 i.topprods_sanitary_abovep80 ///
i.topprods_cleaning_abovep80 i.topprods_baby_abovep80 i.topprods_tobacco_abovep80 i.topprods_meds_abovep80 ///
i.topprods_gaspetrol_abovep80 i.topprods_phone_abovep80 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_mthly_comp_rep_win ///
i.topprods_rice_abovep80 i.topprods_flour_abovep80 i.topprods_eggs_abovep80 i.topprods_noodles_abovep80 i.topprods_oil_abovep80 ///
i.topprods_saltsugar_abovep80 i.topprods_bread_abovep80 i.topprods_coffeetea_abovep80 i.topprods_homecooked_abovep80 ///
i.topprods_snacks_abovep80 i.topprods_freshdrinks_abovep80 i.topprods_softdrinks_abovep80 i.topprods_sanitary_abovep80 ///
i.topprods_cleaning_abovep80 i.topprods_baby_abovep80 i.topprods_tobacco_abovep80 i.topprods_meds_abovep80 ///
i.topprods_gaspetrol_abovep80 i.topprods_phone_abovep80 ///
labour_total firm_space_cont, vce(robust) // level(90)


*** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

reg sales_normday_ihs_win ///
i.topprods_rice_abovep80 i.topprods_flour_abovep80 i.topprods_eggs_abovep80 i.topprods_noodles_abovep80 i.topprods_oil_abovep80 ///
i.topprods_saltsugar_abovep80 i.topprods_bread_abovep80 i.topprods_coffeetea_abovep80 i.topprods_homecooked_abovep80 ///
i.topprods_snacks_abovep80 i.topprods_freshdrinks_abovep80 i.topprods_softdrinks_abovep80 i.topprods_sanitary_abovep80 ///
i.topprods_cleaning_abovep80 i.topprods_baby_abovep80 i.topprods_tobacco_abovep80 i.topprods_meds_abovep80 ///
i.topprods_gaspetrol_abovep80 i.topprods_phone_abovep80 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_normday_topprods_ihs_win ///
i.topprods_rice_abovep80 i.topprods_flour_abovep80 i.topprods_eggs_abovep80 i.topprods_noodles_abovep80 i.topprods_oil_abovep80 ///
i.topprods_saltsugar_abovep80 i.topprods_bread_abovep80 i.topprods_coffeetea_abovep80 i.topprods_homecooked_abovep80 ///
i.topprods_snacks_abovep80 i.topprods_freshdrinks_abovep80 i.topprods_softdrinks_abovep80 i.topprods_sanitary_abovep80 ///
i.topprods_cleaning_abovep80 i.topprods_baby_abovep80 i.topprods_tobacco_abovep80 i.topprods_meds_abovep80 ///
i.topprods_gaspetrol_abovep80 i.topprods_phone_abovep80 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_normday_ihs_win ///
i.topprods_rice_abovep80 i.topprods_flour_abovep80 i.topprods_eggs_abovep80 i.topprods_noodles_abovep80 i.topprods_oil_abovep80 ///
i.topprods_saltsugar_abovep80 i.topprods_bread_abovep80 i.topprods_coffeetea_abovep80 i.topprods_homecooked_abovep80 ///
i.topprods_snacks_abovep80 i.topprods_freshdrinks_abovep80 i.topprods_softdrinks_abovep80 i.topprods_sanitary_abovep80 ///
i.topprods_cleaning_abovep80 i.topprods_baby_abovep80 i.topprods_tobacco_abovep80 i.topprods_meds_abovep80 ///
i.topprods_gaspetrol_abovep80 i.topprods_phone_abovep80 ///
labour_total firm_space_cont, vce(robust) // level(90)


*** CUSTOMERS

reg firm_custom_total ///
i.topprods_rice_abovep80 i.topprods_flour_abovep80 i.topprods_eggs_abovep80 i.topprods_noodles_abovep80 i.topprods_oil_abovep80 ///
i.topprods_saltsugar_abovep80 i.topprods_bread_abovep80 i.topprods_coffeetea_abovep80 i.topprods_homecooked_abovep80 ///
i.topprods_snacks_abovep80 i.topprods_freshdrinks_abovep80 i.topprods_softdrinks_abovep80 i.topprods_sanitary_abovep80 ///
i.topprods_cleaning_abovep80 i.topprods_baby_abovep80 i.topprods_tobacco_abovep80 i.topprods_meds_abovep80 ///
i.topprods_gaspetrol_abovep80 i.topprods_phone_abovep80 ///
labour_total firm_space_cont, vce(robust) // level(90)


************************************************************************
***** Discussion topics ************************************************


***** Sales and profits, comp scores (calc and self-rep for sales, self-rep only for profits)

*** Sales, IHS-transformed and w/out transformation (both win at p99)

reg sales_mthly_comp_all_ihs_win ///
i.practice_discuss_sales i.practice_discuss_sellprice i.practice_discuss_bestsell ///
i.practice_discuss_finance i.practice_discuss_buyprice i.practice_discuss_practice ///
i.practice_discuss_plan ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_mthly_comp_all_win ///
i.practice_discuss_sales i.practice_discuss_sellprice i.practice_discuss_bestsell ///
i.practice_discuss_finance i.practice_discuss_buyprice i.practice_discuss_practice ///
i.practice_discuss_plan ///
labour_total firm_space_cont, vce(robust) // level(90)


*** Profits, IHS-transformed and w/out transformation (both win at p99)

reg profit_mthly_comp_rep_ihs_win ///
i.practice_discuss_sales i.practice_discuss_sellprice i.practice_discuss_bestsell ///
i.practice_discuss_finance i.practice_discuss_buyprice i.practice_discuss_practice ///
i.practice_discuss_plan ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_mthly_comp_rep_win ///
i.practice_discuss_sales i.practice_discuss_sellprice i.practice_discuss_bestsell ///
i.practice_discuss_finance i.practice_discuss_buyprice i.practice_discuss_practice ///
i.practice_discuss_plan ///
labour_total firm_space_cont, vce(robust) // level(90)


***** Sales and profits, self-reported, on a normal day

reg sales_normday_ihs_win ///
i.practice_discuss_sales i.practice_discuss_sellprice i.practice_discuss_bestsell ///
i.practice_discuss_finance i.practice_discuss_buyprice i.practice_discuss_practice ///
i.practice_discuss_plan ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_normday_topprods_ihs_win ///
i.practice_discuss_sales i.practice_discuss_sellprice i.practice_discuss_bestsell ///
i.practice_discuss_finance i.practice_discuss_buyprice i.practice_discuss_practice ///
i.practice_discuss_plan ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_normday_ihs_win ///
i.practice_discuss_sales i.practice_discuss_sellprice i.practice_discuss_bestsell ///
i.practice_discuss_finance i.practice_discuss_buyprice i.practice_discuss_practice ///
i.practice_discuss_plan ///
labour_total firm_space_cont, vce(robust) // level(90)


***** Customers

reg firm_custom_total ///
i.practice_discuss_sales i.practice_discuss_sellprice i.practice_discuss_bestsell ///
i.practice_discuss_finance i.practice_discuss_buyprice i.practice_discuss_practice ///
i.practice_discuss_plan ///
labour_total firm_space_cont, vce(robust) // level(90)



************************************************************************
***** Decision making topics ************************************************


***** Sales and profits, comp scores (calc and self-rep for sales, self-rep only for profits)

*** Sales, IHS-transformed and w/out transformation (both win at p99)

reg sales_mthly_comp_all_ihs_win ///
i.practice_decide_sales i.practice_decide_sellprice i.practice_decide_bestsell ///
i.practice_decide_finance i.practice_decide_buyprice i.practice_decide_newprod ///
i.practice_decide_practice i.practice_decide_plan ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_mthly_comp_all_win ///
i.practice_decide_sales i.practice_decide_sellprice i.practice_decide_bestsell ///
i.practice_decide_finance i.practice_decide_buyprice i.practice_decide_newprod ///
i.practice_decide_practice i.practice_decide_plan ///
labour_total firm_space_cont, vce(robust) // level(90)


*** Profits, IHS-transformed and w/out transformation (both win at p99)

reg profit_mthly_comp_rep_ihs_win ///
i.practice_decide_sales i.practice_decide_sellprice i.practice_decide_bestsell ///
i.practice_decide_finance i.practice_decide_buyprice i.practice_decide_newprod ///
i.practice_decide_practice i.practice_decide_plan ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_mthly_comp_rep_win ///
i.practice_decide_sales i.practice_decide_sellprice i.practice_decide_bestsell ///
i.practice_decide_finance i.practice_decide_buyprice i.practice_decide_newprod ///
i.practice_decide_practice i.practice_decide_plan ///
labour_total firm_space_cont, vce(robust) // level(90)


***** Sales and profits, self-reported, on a normal day
reg sales_normday_ihs_win ///
i.practice_decide_sales i.practice_decide_sellprice i.practice_decide_bestsell ///
i.practice_decide_finance i.practice_decide_buyprice i.practice_decide_newprod ///
i.practice_decide_practice i.practice_decide_plan ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_normday_topprods_ihs_win ///
i.practice_decide_sales i.practice_decide_sellprice i.practice_decide_bestsell ///
i.practice_decide_finance i.practice_decide_buyprice i.practice_decide_newprod ///
i.practice_decide_practice i.practice_decide_plan ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_normday_ihs_win ///
i.practice_decide_sales i.practice_decide_sellprice i.practice_decide_bestsell ///
i.practice_decide_finance i.practice_decide_buyprice i.practice_decide_newprod ///
i.practice_decide_practice i.practice_decide_plan ///
labour_total firm_space_cont, vce(robust) // level(90)


***** Customers

reg firm_custom_total ///
i.practice_decide_sales i.practice_decide_sellprice i.practice_decide_bestsell ///
i.practice_decide_finance i.practice_decide_buyprice i.practice_decide_newprod ///
i.practice_decide_practice i.practice_decide_plan ///
labour_total firm_space_cont, vce(robust) // level(90)


************************************************************************
***** Discussion and decision-making partners ***************************


***** Sales and profits, comp scores (calc and self-rep for sales, self-rep only for profits)

*** Sales, IHS-transformed and w/out transformation (both win at p99)

reg sales_mthly_comp_all_ihs_win ///
i.practice_discuss_fam i.practice_discuss_busifriend ///
i.practice_decide_any ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_mthly_comp_all_win ///
i.practice_discuss_fam i.practice_discuss_busifriend ///
i.practice_decide_any ///
labour_total firm_space_cont, vce(robust) // level(90)


* Profits, IHS-transformed and w/out transformation (both win at p99)

reg profit_mthly_comp_rep_ihs_win ///
i.practice_discuss_fam i.practice_discuss_busifriend ///
i.practice_decide_any ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_mthly_comp_rep_win ///
i.practice_discuss_fam i.practice_discuss_busifriend ///
i.practice_decide_any ///
labour_total firm_space_cont, vce(robust) // level(90)


***** Sales and profits, self-reported, on a normal day

reg sales_normday_ihs_win ///
i.practice_discuss_fam i.practice_discuss_busifriend ///
i.practice_decide_any ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_normday_topprods_ihs_win ///
i.practice_discuss_fam i.practice_discuss_busifriend ///
i.practice_decide_any ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_normday_ihs_win ///
i.practice_discuss_fam i.practice_discuss_busifriend ///
i.practice_decide_any ///
labour_total firm_space_cont, vce(robust) // level(90)


***** Customers

reg firm_custom_total ///
i.practice_discuss_fam i.practice_discuss_busifriend ///
i.practice_decide_any ///
labour_total firm_space_cont, vce(robust) // level(90)



************************************************************************
***** Finances ************************************************


***** SALES AND PROFITS, COMP SCORE (calc and self-rep for sales, self-rep only for profits)

*** Sales, IHS-transformed and w/out transformation (both win at p99)

reg sales_mthly_comp_all_ihs_win ///
i.practice_credit_trade i.practice_credit_trade_int ///
i.finances_separate i.owner_loan_obtain_1 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_mthly_comp_all_win ///
i.practice_credit_trade i.practice_credit_trade_int ///
i.finances_separate i.owner_loan_obtain_1 ///
labour_total firm_space_cont, vce(robust) // level(90)


*** Profits, IHS-transformed and w/out transformation (both win at p99)

reg profit_mthly_comp_rep_ihs_win ///
i.practice_credit_trade i.practice_credit_trade_int ///
i.finances_separate i.owner_loan_obtain_1 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_mthly_comp_rep_win ///
i.practice_credit_trade i.practice_credit_trade_int ///
i.finances_separate i.owner_loan_obtain_1 ///
labour_total firm_space_cont, vce(robust) // level(90)


***** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

reg sales_normday_ihs_win ///
i.practice_credit_trade i.practice_credit_trade_int ///
i.finances_separate i.owner_loan_obtain_1 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg sales_normday_topprods_ihs_win ///
i.practice_credit_trade i.practice_credit_trade_int ///
i.finances_separate i.owner_loan_obtain_1 ///
labour_total firm_space_cont, vce(robust) // level(90)

reg profit_normday_ihs_win ///
i.practice_credit_trade i.practice_credit_trade_int ///
i.finances_separate i.owner_loan_obtain_1 ///
labour_total firm_space_cont, vce(robust) // level(90)


***** CUSTOMERS

reg firm_custom_total ///
i.practice_credit_trade i.practice_credit_trade_int ///
i.finances_separate i.owner_loan_obtain_1 ///
labour_total firm_space_cont, vce(robust) // level(90)


	
