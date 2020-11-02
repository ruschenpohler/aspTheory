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

local McK_M			MWM1_visitcompetprice MWM2_visitcompetprod MWM3_askcustomprod ///
					MWM4_askcustomquit MWM5_asksupplprod MWM6_attrcustomdisc MWM7_advert
					
local McK_B			MWB1_negosupplprice MWB2_compsupplprod MWB3_notOOS

local McK_R			MWR1_recwritten MWR2_recpurchsale MWR3_recliquid MWR4_recsalesprods ///
					MWR5_costprods MWR6_profprods MWR7_recexpensemth MWR8_recloan
					
local McK_F 		MWF1_finperform MWF2_settargetyr MWF3_comptargetmth MWF4_expensenextyr ///
					MWF5_proflossyr MWF6_cashflowyr MWF7_balanceyr MWF8_incexpenseyr

local innov			practice_price_comp practice_sales_comp practice_discuss_newprod ///
					practice_discuss_suppl practice_discuss_bestsell practice_price_discount

local stockup		firm_stockout_wklyall firm_stockup_lateany firm_stockup_fixall ///
					firm_stockup_wklyall firm_stockup_dailyall

local reckeep		rec_ledger rec_receipts rec_twicewkly ///
					rec_suppl rec_brands rec_prods ///
					rec_sales rec_assets rec_stock ///
					rec_accpay_suppl rec_accpay_loan ///
					rec_costs rec_accrec_custom rec_accrec_fam

local prof			profcalc__nocosts profcalc__allcosts profcalc__any_daily ///
					practice_invent_profit practice_invent_supplprice

local dm_disc_pers	discuss_fam discuss_busifriend ///
					jointdec_any

local disc_topic	discuss_sales discuss_sellprice ///
					discuss_bestsell discuss_finance ///
					discuss_buyprice discuss_practice ///
					discuss_plan

local dm_topic		jointdec_sales jointdec_sellprice ///
					jointdec_bestsell jointdec_finance ///
					jointdec_buyprice jointdec_newprod ///
					jointdec_practice jointdec_plan

local fin1			credit_TC credit_TC_int ///
					separatefin loan_outstanding /*"loan_obtain_1*/

local fin2			sales_normday_top3_abvp80 practice_prods_new5 ///
					prods_dispose practice_invent_demand ///
					practice_invent_space practice_price_demand

local dims			McK_M McK_B McK_R McK_F innov stockup reckeep prof ///
					dm_disc_pers disc_topic dm_topic fin1 fin2
local dims_n 		: word count `dims'



***** Original variable selection (baseline data)

* Have: 	automized baseline regressions, calculated significance scores, and captured effect sizes
* Need to: 	select variables based on adoption effect sizes (upper 25 percentile), 
*			capture both in a 2 x m matrix (where m is the number of practices) -> see Bilal's files

* Variable selection
//replace `this_var'_best	= 1 if `this_var'_sig>5 & `this_var'_prev<0.26 & abs(_b[`this_var'])
// have to loop over all _b vars (coefficient sizes from the reg) and figure out percentiles, then condition selection on value being in 25th percentile



*** Regressions and scores

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




***** Additional analyses: Interaction effects for size and education


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

local i = 1
local m = 1

foreach hte in	size educ {
	
	foreach x in	McK_M McK_B McK_R McK_F innov stockup reckeep prof ///
					dm_disc_pers disc_topic dm_topic fin1 fin2 {

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
			eststo Int_`hte'_Table_C`m'_`i'
			estadd ysumm
			estadd local int_BM`hte' "Yes"
		
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

		capture erase "Data\Baseline Data\Practices Selection\Endline comparison\Tables\Additional\Int_`hte'_Table_C`m'.csv"
	
		* output
		#delimit ;
			esttab Int_`hte'_Table_C`m'_* using "Data\Baseline Data\Practices Selection\Endline comparison\Tables\Additional\Int_`hte'_Table_C`m'.csv", /*label*/ replace modelwidth(16) varwidth(50) depvar legend 
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









