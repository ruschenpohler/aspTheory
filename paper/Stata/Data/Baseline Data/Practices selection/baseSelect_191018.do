********************************************************************************
*****               RETAILER STUDY, INDONESIA 2015-2017                    *****
*****                 SELECTION OF LOCAL BEST PRACTICES                    *****
*****
*****				  + Add analysis for PhD defense					   *****	
*****														   		  	   *****
***** Julius, 19 Oct 2018                                       		   *****
********************************************************************************



clear
set more off

cd "`c(pwd)'\"

do do_datamanagement_2605_JR.do

use "Final data/data_final_practices_regs_1709.dta", clear



***** Define controls/outcomes

local controls 		labour_total firm_space_cont
local outcomes 		sales_mthly_comp_all_ihs_w sales_mthly_comp_all_w ///
					profit_mthly_comp_rep_ihs_w profit_mthly_comp_rep_w ///
					sales_normday_ihs_w sales_normday_topprods_ihs_w ///
					profit_normday_ihs_w ///
					firm_custom_total

					
***** Define dimensions of practices

local McK_M			practice_McKandW_M1 practice_McKandW_M2 practice_McKandW_M3 ///
					practice_McKandW_M4 practice_McKandW_M5 practice_McKandW_M6 ///
					practice_McKandW_M7

local innov			practice_price_comp practice_sales_comp practice_disc_newprod ///
					practice_disc_suppl practice_disc_bestsell practice_price_discount
					
local McK_B			practice_McKandW_B1 practice_McKandW_B2 practice_McKandW_B3

local stockup		firm_stockout_wklyall firm_stockup_lateany firm_stockup_fixall ///
					firm_stockup_wklyall firm_stockup_dailyall

local McK_R			practice_McKandW_R1 practice_McKandW_R2 practice_McKandW_R3 ///
					practice_McKandW_R4 practice_McKandW_R5 practice_McKandW_R6 ///
					practice_McKandW_R7 practice_McKandW_R8
					
local reckeep		practice_rec_ledger practice_rec_receipts practice_rec_twicewkly ///
					practice_rec_suppl practice_rec_brands practice_rec_prods ///
					practice_rec_sales practice_rec_assets practice_rec_stock ///
					practice_rec_accpay_suppl practice_rec_accpay_loan ///
					practice_rec_costs practice_rec_accrec_cus practice_rec_accrec_fam

local prof			practice_profit_nocosts practice_profit_allcosts practice_profit_any_daily ///
					practice_inv_profit practice_inv_supplprice		
					
local McK_F 		practice_McKandW_F1 practice_McKandW_F2 practice_McKandW_F3 ///
					practice_McKandW_F4 practice_McKandW_F5 practice_McKandW_F6 ///
					practice_McKandW_F7 practice_McKandW_F8

local fin1			sales_normday_top3_abvp80 practice_prods_new5 ///
					prods_dispose practice_inv_demand ///
					practice_inv_space practice_price_demand

local fin2			practice_credit_trade practice_credit_trade_int ///
					finances_separate owner_loan_obtain_1

local dm_disc_pers	practice_disc_fam practice_disc_bisfriend ///
					practice_decide_any

local disc_topic	practice_disc_sales practice_disc_sellprice ///
					practice_disc_bestsell practice_disc_finance ///
					practice_disc_buyprice practice_disc_practice ///
					practice_disc_plan

local dm_topic		practice_decide_sales practice_decide_sellprice ///
					practice_decide_bestsell practice_decide_finance ///
					practice_decide_buyprice practice_decide_newprod ///
					practice_decide_practice practice_decide_plan



local dims			McK_M innov McK_B stockup McK_R reckeep prof McK_F fin1 fin2 ///
					dm_disc_pers disc_topic dm_topic 
					
local dims_n 		: word count `dims'





*** Variable selection

* Have: 	automized baseline regressions, calculated significance scores, and captured effect sizes
* Need to: 	select variables based on adoption effect sizes (upper 25 percentile), 
*			capture both in a 2 x m matrix (where m is the number of practices) -> see Bilal's files

* Variable selection
//replace `this_var'_best	= 1 if `this_var'_sig>5 & `this_var'_prev<0.26 & abs(_b[`this_var'])
// have to loop over all _b vars (coefficient sizes from the reg) and figure out percentiles, then condition selection on value being in 25th percentile



****** Original regressions and scores

local i = 1
local m = 1

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
		est sto Orig_C`m'_`i'
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

		capture erase "Tables\Original\Orig_C`m'.csv"
		#delimit ;
		esttab Orig_C`m'_* using "Tables\Original\Orig_C`m'.csv", replace modelwidth(16) varwidth(50) depvar legend 
			cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
			stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N"))
			title("`this_dim' Outcomes") ;
			#delimit cr
			
	}		
	local ++m
	est drop _all

}




***** PhD defense: New regressions with CONTROLS for education and fin lit

local i = 1
local m = 1

* Loop over all dimensions
forval dim=1/`dims_n' {
	
	local this_dim : word `dim' of `dims'
	local this_dim_n : word count ``this_dim''
	di "`dims_n'"
	di "`this_dim'"
	di "`this_dim_n'"
	

	* Loop over all outcomes
	foreach x in owner_educ owner_finlit_compscore {
	
		local c = substr("`x'",7,6)
		di "`c'"
	
		foreach y in `outcomes' {

			* Within a dimension, regress each outcome on all practices of the dimension and controls
			reg `y' ``this_dim'' `x' `controls', r
			est sto Contr_`c'_C`m'_`i'
			local ++i

		}

*** Regression output

	capture erase "Tables\Additional\Contr_`c'_C`m'.csv"
	#delimit ;
	esttab Contr_`c'_C`m'_* using "Tables\Additional\Contr_`c'_C`m'.csv", replace modelwidth(16) varwidth(50) depvar legend 
		cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
		stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N"))
		title("`this_dim' Outcomes") ;
		#delimit cr
			
	est drop _all

	}
	
local ++m

}



***** PhD defense: New regressions with INTERACTION effects for size and education


*** Interaction Dummies and Labels

* Dummy
egen firm_space_cont_md = median(firm_space_cont)
gen AMsize = (firm_space_cont>firm_space_cont_md) if !missing(firm_space_cont)
gen BMsize = 1 - AMsize

egen owner_educ_md = median(owner_educ)
gen AMeduc = (owner_educ>owner_educ_md) if !missing(owner_educ)
gen BMeduc = 1 - AMeduc


* Interaction dummies

foreach var in	size educ {

foreach loc in	McK_M McK_B McK_R McK_F innov stockup reckeep prof ///
				dm_disc_pers disc_topic dm_topic fin1 fin2 {
		
	foreach p in ``loc'' {
				
	
		* Confirming does not exist yet
		cap confirm variable `p'_AM`var'
		
		if !_rc {
		
			* Allocate to locals
			local `loc'_AM`var' ``loc'_AM`var'' `p'_AM`var'
			local `loc'_BM`var' ``loc'_BM`var'' `p'_BM`var'
		}
	
		else{
				
			* Generating interaction
			gen `p'_AM`var'			= `p' * AM`var'
			gen `p'_BM`var'			= `p' * BM`var'
			
			* Label variable
			/*local label: var label `p'
			
			if missing("`label'") {
				label var `p'_AM`var'	"Above-Md BL `var' X Var `p'"
				label var `p'_BM`var'	"Below-Md BL `var' X Var `p'"
			}
			
			else {
				label var `p'_AM`var'	"Above-Md BL `var' X Var `label'"
				label var `p'_BM`var'	"Below-Md BL `var' X Var `label'"
			}*/
			
			* Allocate to locals
			local `loc'_AM`var' ``loc'_AM`var'' `p'_AM`var'
			local `loc'_BM`var' ``loc'_BM`var'' `p'_BM`var'
		}
	}	 
}

}


*** HTEs

local controls 		labour_total

local i = 1
local m = 1

foreach hte in	size {
	
	foreach x in	McK_M innov McK_B stockup McK_R reckeep prof McK_F fin1 fin2 ///
					dm_disc_pers disc_topic dm_topic  {

		foreach y in `outcomes' {


		
			/*			
			* Generating Dummies for missing BL vars 
			cap drop W1_`y'_m l
			cap drop W1b_`y'
				
			gen W1_`y'_m = (W1_`y'==.) if W3_`y'!=. 
			gen W1b_`y' = W1_`y'
			replace W1b_`y'= 5 if W1_`y'_m == 1
			*/
						
			reg `y' ``x'' ``x'_BM`hte'' `controls', r
									
			* Storing Estimates
			eststo Int_`hte'_C`m'_`i'
			estadd ysumm
			*estadd local int_BM`hte' "Yes"
		
			local length : word count ``x''
			/*local test `: word 7 of ``x'''
			di "`test'"*/

		* Performing F-test
			forval j=1/`length' {
				local `x'_`j'			`: word `j' of ``x'''
				local `x'_`j'_BM`hte' 	`: word `j' of ``x'_BM`hte'''
			
				di "``x'_`j''"
				di "``x'_`j'_BM`hte''"
			
				test ``x'_`j'' + ``x'_`j'_BM`hte'' = 0
				estadd scalar f_`x'_`j'_BM`hte' = r(p)
			}

	
			/** Storing Control Group Stats by Levels of Heterogeneous Variable
			foreach x in `hte_var'_BM `hte_var'_AM {
				sum `wave'_`y' if control==1 & W1_`x'==1
				estadd scalar mean_`x' = r(mean)
				estadd scalar sd_`x' = r(sd)
			}*/
		
			local ++i

		}

		capture erase "Tables\Additional\Int_`hte'_C`m'.csv"
	
		* output
		#delimit ;
			esttab Int_`hte'_C`m'_* using "Tables\Additional\Int_`hte'_C`m'.csv", /*label*/ replace modelwidth(16) varwidth(50) depvar legend 
			cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
			stats(r2 N 
			mean_asp_shop_z_AM sd_asp_shop_z_AM mean_asp_shop_z_BM sd_asp_shop_z_BM 
			mean_asp12_shop_z_AM sd_asp12_shop_z_AM mean_asp12_shop_z_BM sd_asp12_shop_z_BM 
			f_BvsBX f_BMvsBMX f_BAvsBAX F_BMAvsBMAX,
			fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) ///
			labels("R-squared" "N" 
			"Dep Var Mean for AM 12-Mth Shop Asps in Control" "Dep Var SD for AM 12-Mth Shop Asps in Control" "Dep Var Mean for BM 12-Mth Shop Asps in Control" "Dep Var SD for BM 12-Mth Shop Asps in Control"
			"Dep Var Mean for AM Ideal Asps in Control" "Dep Var SD for AM Ideal Asps in Control" "Dep Var Mean for BM Ideal Asps in Control" "Dep Var SD for BM Ideal Asps in Control"
			"F-test (p-value): Book + Interaction" "F-test (p-value): Book & Movie + Interaction" "F-test (p-value): Book & Assistaince + Interaction" "F-test (p-value): All Three + Interaction"))
			title(Baseline Regs with Interaction effect: `hte') keep() 
			scalars ("int_BM`hte' `hte' Interaction Term");
		#delimit cr

		local ++m
		est drop _all

	} 

	local m = 1

}
