********************************************************************************
*****               RETAILER STUDY, INDONESIA 2015-2017                    *****
*****                 SELECTION OF LOCAL BEST PRACTICES                    *****
***** 															   		   *****
***** Julius, 11 Sep 2017                                       		   *****
********************************************************************************



clear
set more off


use "Final data/data_final_practices_regs_0831.dta", clear



***** Define controls/outcomes

local controls 		labour_total firm_space_cont
local outcomes 		sales_mthly_comp_all_ihs_win sales_mthly_comp_all_win ///
					profit_mthly_comp_rep_ihs_win profit_mthly_comp_rep_win ///
					sales_normday_ihs_win sales_normday_topprods_ihs_win ///
					profit_normday_ihs_win ///
					firm_custom_total

					
***** Define dimensions of practices

local McK_M			practice_McKandW_M1 practice_McKandW_M2 practice_McKandW_M3 ///
					practice_McKandW_M4 practice_McKandW_M5 practice_McKandW_M6 ///
					practice_McKandW_M7
					
local McK_B			practice_McKandW_B1 practice_McKandW_B2 practice_McKandW_B3

local McK_R			practice_McKandW_R1 practice_McKandW_R2 practice_McKandW_R3 ///
					practice_McKandW_R4 practice_McKandW_R5 practice_McKandW_R6 ///
					practice_McKandW_R7 practice_McKandW_R8
					
local McK_F 		practice_McKandW_F1 practice_McKandW_F2 practice_McKandW_F3 ///
					practice_McKandW_F4 practice_McKandW_F5 practice_McKandW_F6 ///
					practice_McKandW_F7 practice_McKandW_F8

local innov			practice_price_comp practice_sales_comp practice_discuss_newprod ///
					practice_discuss_suppl practice_discuss_bestsell practice_price_discount

local stockup		firm_stockout_wklyall firm_stockup_lateany firm_stockup_fixall ///
					firm_stockup_wklyall firm_stockup_dailyall

local reckeep		practice_rec_ledger practice_rec_receipts practice_rec_twicewkly ///
					practice_rec_suppl practice_rec_brands practice_rec_prods ///
					practice_rec_sales practice_rec_assets practice_rec_stock ///
					practice_rec_accpay_suppl practice_rec_accpay_loan ///
					practice_rec_costs practice_rec_accrec_custom practice_rec_accrec_fam

local prof			practice_profit_nocosts practice_profit_allcosts practice_profit_any_daily ///
					practice_invent_profit practice_invent_supplprice

local dm_disc_pers	practice_discuss_fam practice_discuss_busifriend ///
					practice_decide_any

local disc_topic	practice_discuss_sales practice_discuss_sellprice ///
					practice_discuss_bestsell practice_discuss_finance ///
					practice_discuss_buyprice practice_discuss_practice ///
					practice_discuss_plan

local dm_topic		practice_decide_sales practice_decide_sellprice ///
					practice_decide_bestsell practice_decide_finance ///
					practice_decide_buyprice practice_decide_newprod ///
					practice_decide_practice practice_decide_plan

local fin1		practice_credit_trade practice_credit_trade_int ///
					finances_separate owner_loan_obtain_1

local fin2			sales_normday_top3_abvp80 practice_prods_new5 ///
					prods_dispose practice_invent_demand ///
					practice_invent_space practice_price_demand

local dims			McK_M McK_B McK_R McK_F innov stockup reckeep prof ///
					dm_disc_pers disc_topic dm_topic fin1 fin2
local dims_n 		: word count `dims'


***** Regressions and scores

* Loop over all dimensions
forval dim=1/`dims_n' {
	
	local this_dim : word `dim' of `dims'
	local this_dim_n : word count ``this_dim''
	di "`dims_n'"
	di "`this_dim'"
	di "`this_dim_n'"
	
	* Within a dimension, check whether variables exist already, if not create variables
	//foreach x in ``this_dim'' {
	
		//cap confirm variable `x'_p
		
		//if !_rc {
		//}
		
		//else {
		//	gen `x'_p 		= 0
		//	gen `x'_sig 	= 0
		//	gen	`x'_prev	= 0
		//	gen `x'_best	= 0
		//}
	//}

	* Prevalence of each practice at baseline
	//forval var=1/`this_dim_n' {
	
		//local this_var : word `var' of ``this_dim''
		
		//sum `this_var'
		//replace `this_var'_prev = r(mean)
	//}
	
	//macro drop `this_var'
	local i = 1

	* Loop over all outcomes
	foreach y in `outcomes' {

		* Within a dimension, regress each outcome on all practices of the dimension and controls
		reg `y' ``this_dim'' `controls', r
		est sto table_`this_dim'_`i'
		local ++i

		* Loop over all vars within current dimension and current outcome
		//forval dimvar=1/`this_dim_n' {
	
			//local this_var		: word `dimvar' of ``this_dim''
			
			* Calculate p values and significance scores	
			//replace `this_var'_p 	= (2 * ttail(e(df_r), abs(_b[`this_var']/_se[`this_var'])))
			//replace `this_var'_sig	= `this_var'_sig + 1 if `this_var'_p<=0.104
			
			//replace `this_var'_b		= abs(_b[`this_var'])
		//}


*** Regression output

		capture erase "Tables\table_`this_dim'.csv"
		#delimit ;
		esttab table_`this_dim'_* using "Tables\table_`this_dim'.csv", replace modelwidth(16) varwidth(50) depvar legend 
			cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
			stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N"))
			title("`this_dim' Outcomes") ;
			#delimit cr
	}
}



*** Variable selection

* Have: 	automized baseline regressions, calculated significance scores, and captured effect sizes
* Need to: 	select variables based on adoption effect sizes (upper 25 percentile), 
*			capture both in a 2 x m matrix (where m is the number of practices) -> see Bilal's files

* Variable selection
//replace `this_var'_best	= 1 if `this_var'_sig>5 & `this_var'_prev<0.26 & abs(_b[`this_var'])
// have to loop over all _b vars (coefficient sizes from the reg) and figure out percentiles, then condition selection on value being in 25th percentile




