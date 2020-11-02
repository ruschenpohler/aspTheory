

set matsize 11000
clear all

cd "C:\Users\Julius\Dropbox\Indonesia\Multidim aspirations\Stata\"


do "Data\merging_data.do"

use "Data\Analysis_data.dta", clear

set more off

local rn



foreach w in 		W1 W3 {


***** Define controls/outcomes

local outcomes		`w'_sales_comp3_ihs_w1 `w'_sales_comp3_w1 `w'_prof_comp4_ihs_w1 ///
					`w'_prof_comp4_w1 `w'_sales_nday_ihs_w1 `w'_sales_nday_top3_w1 ///
					`w'_prof_nday_ihs_w1 `w'_custom_total
local controls		`w'_labour_total `w'_size



***** Define dimensions of practices

local McK_M			`w'_MWM1_visitcompetprice `w'_MWM2_visitcompetprod `w'_MWM3_askcustomprod ///
					`w'_MWM4_askcustomquit `w'_MWM5_asksupplprod `w'_MWM6_attrcustomdisc `w'_MWM7_advert
					
local innov			`w'_price_change_comp `w'_compsales_compet `w'_discount /// 
					`w'_discuss_newprod `w'_discuss_bestseller `w'_discuss_supplier 
					
local McK_B			`w'_MWB1_negosupplprice `w'_MWB2_compsupplprod `w'_MWB3_notOOS

local stockup		`w'_stockout_wklyall `w'_stockup_late `w'_stockup_fixschedule ///
					`w'_stockup_wklyall `w'_stockup_dayall

local McK_R			`w'_MWR1_recwritten `w'_MWR2_recpurchsale `w'_MWR3_recliquid ///
					`w'_MWR4_recsalesprods `w'_MWR5_costprods `w'_MWR6_profprods `w'_MWR7_recexpensemth `w'_MWR8_recloan
					
local reckeep		`w'_rec_ledger `w'_rec_receipts `w'_rec_twicewkly ///
					`w'_rec_pricesuppliers `w'_rec_pricebrands `w'_rec_stockup ///
					`w'_rec_sales `w'_rec_assetpurch `w'_rec_stocks ///
					`w'_rec_accpaysupplier `w'_rec_accpayloan ///
					`w'_rec_othercosts `w'_rec_accreccustom `w'_rec_accrecfam

local prof			`w'_profcalc_nocosts `w'_profcalc_allcosts `w'_profcalc_any_day ///
					`w'_inventory_change_prof `w'_inventory_change_price

local McK_F 		`w'_MWF1_finperform `w'_MWF2_settargetyr `w'_MWF3_comptargetmth ///
					`w'_MWF4_expensenextyr `w'_MWF5_proflossyr `w'_MWF6_cashflowyr ///
					`w'_MWF7_balanceyr `w'_MWF8_incexpenseyr
				
local fin1			`w'_sales_nday_top3_abvp80 `w'_prods_new_5 ///
					`w'_dispose_wk `w'_inventory_change_demand ///
					`w'_inventory_change_space `w'_price_change_demand
				
local fin2			`w'_credit_TC `w'_credit_TC_int ///
					`w'_separatefin `w'_loan_outstanding
	
				

local dm_disc_pers	`w'_discuss_fam `w'_discuss_bisfriend `w'_discuss_any


local disc_topic 	`w'_discuss_sales `w'_discuss_sellprice `w'_discuss_bestseller `w'_discuss_finance ///
					`w'_discuss_buyprice `w'_discuss_newprod `w'_discuss_practice `w'_discuss_bisplan
			
local dm_topic 		`w'_jointdec_sales `w'_jointdec_sellprice `w'_jointdec_bestseller `w'_jointdec_finance ///
					`w'_jointdec_buyprice `w'_jointdec_newprod `w'_jointdec_practice `w'_jointdec_bisplan


		
local dims			McK_M innov McK_B stockup McK_R reckeep prof McK_F ///
					fin1 fin2 dm_disc_pers disc_topic dm_topic
					
local dims_n 		: word count `dims'			



***** Transformations *****


***** IHS

foreach x in 	sales_comp3 prof_comp4 sales_nday prof_nday {

				gen `w'_`x'_ihs = ln(`w'_`x' + sqrt((`w'_`x'*`w'_`x') + 1))

}

					
***** Winsorisations

foreach x in 	sales_comp3_ihs sales_comp3 prof_comp4_ihs prof_comp4 ///
				sales_nday_ihs sales_nday_top3 prof_nday_ihs {
					
				winsor2 `w'_`x', suffix(_w1) cuts(1 99)
					
}


***** Best practices selection *****


***** I Original regressions and scores with W1 data

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
		est sto Table_C`m'_`w'_`i'
		local ++i

		* Loop over all vars within current dimension and current outcome
		//forval dimvar=1/`this_dim_n' {
	
			//local this_var		: word `dimvar' of ``this_dim''
			
			* Calculate p values and significance scores	
			//replace `this_var'_p 	= (2 * ttail(e(df_r), abs(_b[`this_var']/_se[`this_var'])))
			//replace `this_var'_sig	= `this_var'_sig + 1 if `this_var'_p<=0.104
			
			//replace `this_var'_b		= abs(_b[`this_var'])
		//}


		* Regression output

		capture erase "Data\Baseline Data\Practices Selection\Endline comparison\Tables\Original\Table_C`m'_`w'.csv"
		#delimit ;
		esttab Table_C`m'_`w'_* using "Data\Baseline Data\Practices Selection\Endline comparison\Tables\Original\Table_C`m'_`w'.csv", replace modelwidth(16) varwidth(50) depvar legend 
			cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
			stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N"))
			title("Original baseline selection of best pract with `this_dim' practices") ;
			#delimit cr
			
	}		
	local ++m
	est drop _all

}

}



***** II Addition for PhD defense


Fix this!



*** A -- CONTROLS for education and fin lit

local i = 1
local m = 1

* Loop over all dimensions
forval dim=1/`dims_n' {
	
	local this_dim : word `dim' of `dims'
	local this_dim_n : word count ``this_dim''
	di "`dims_n'"
	di "`this_dim'"
	di "`this_dim_n'"
	

	* Loop over all controls
	foreach c in owner_educ owner_finlit_compscore {
	
		local control = substr("`c'",7,6)
		di "`control'"
	
		foreach y in `outcomes' {

			* Within a dimension, regress each outcome on all practices of the dimension and controls
			reg `y' ``this_dim'' `c' `control', r
			est sto Control_`control'_C`m'_`i'
			local ++i

		}
	}

* Regression output

		capture erase "Data\Baseline Data\Practices Selection\Endline comparison\Tables\Additional\Control_`control'_C`m'.csv"
		#delimit ;
		esttab Control_`control'_C`m'_* using "Data\Baseline Data\Practices Selection\Endline comparison\Tables\Additional\Control_`control'_C`m'.csv", replace modelwidth(16) varwidth(50) depvar legend 
			cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
			stats(r2 N, fmt(%9.3f %9.0g) labels("R-squared" "N"))
			title("Additional regs controlling for baseline selection of best pract with `this_dim' pract") ;
			#delimit cr
			
	}	

	local ++m
	est drop _all

}





/***** II B -- INTERACTION effects for size and education


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






