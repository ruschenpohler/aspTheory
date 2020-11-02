
********************************************************************************
************** 		RETAILERS INDONESIA PROJECT, 2016-2017 		****************
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



***** VAR PREP ***************************************************************

* Labels

foreach v in W1 W3 {

label var `v'_asp12_shop_z 				"Aggregate Short-Term Aspirations"
label var `v'_aspgap12_shop_z 			"Aspirations Gap for Aggregate Short-Term Aspirations"
label var `v'_asp_shop_z 				"Aggregate Long-Term Aspirations"
label var `v'_aspgap_shop_z 			"Aspirations Gap for Aggregate Long-Term Aspirations"
label var `v'_asp12_size_z 				"Short-Term Shop Size Aspirations (Zscore)"
label var `v'_asp12_employee_z 			"Short-Term Employee Aspirations (Zscore)"
label var `v'_asp12_customer_z 			"Short-Term Customer Aspirations (Zscore)"
label var `v'_asp12_sales_z 			"Short-Term Sales Aspirations (Zscore)"

label var `v'_asp_occup_son				"Aspired occupation for son (ranked)"
label var `v'_asp_occup_son_AM		"Occup aspirations for son above md (yes=1)"
label var `v'_asp_occup_son_govt		"Gov't job aspired for son (yes=1)"
label var `v'_asp_occup_dtr		"Aspired occupation for daughter (ranked)"
label var `v'_asp_occup_dtr_AM	"Occup aspirations for daughter above md (yes=1)
label var `v'_asp_occup_dtr_govt	"Gov't job aspired for daughter (yes=1)"
label var `v'_asp_occup_kids			"Aspired occupation for children (ranked)
label var `v'_asp_occup_kids_govt		"Gov't job aspired for either son or daughter (yes=1)"
label var `v'_asp_occup_kids_AM		"Avg occup aspirations for children above md (yes=1)"

label var `v'_asp_educ_son				"Aspired educ for son (Years)"
label var `v'_aspgap_educ_son			"Aspirations gap for son's educ"
label var `v'_asp_educ_son_AM			"Aspired educ for son above md (Yes=1)"
label var `v'_asp_educ_son_ma			"Aspired educ for son at least MA (Yes=1)"
label var `v'_asp_educ_dtr			"Aspired educ for daughter (Years)"
label var `v'_aspgap_educ_dtr		"Aspirations gap for daughter's educ"
label var `v'_asp_educ_dtr_AM	"Aspired educ for son above md (Yes=1)"
label var `v'_asp_educ_dtr_ma		"Aspired educ for daughter at least MA (yes=1)"
label var `v'_asp_educ_kids				"Aspired educ for children (Years)
label var `v'_aspgap_educ_kids			"Aspirations gap for children's educ (Years)"
label var `v'_asp_educ_kids_ma			"Aspired educ for children at least MA (Yes=1)"
label var `v'_asp_educ_kids_AM		"Aspired educ for children above md (Yes=1)"

}



***** TREATMENT EFFECTS ********************************************************


***** Locals

* Treatment Variables
local treat		book_only book_mov book_ast book_mov_ast

* Strata Controls
local strata 	W1_male W1_space_ord W1_MW_score_total_abovemd

* Outcomes (Add Selection Here!)
local Outcomes	asp12_shop_z asp12_sales asp12_size asp12_employee asp12_customer ///
				asp_shop_z asp_size asp_employee asp_customer ///
				asp_educ_son aspgap_educ_son asp_educ_son_ma ///
				asp_educ_dtr aspgap_educ_dtr asp_educ_dtr_ma ///
				asp_educ_kids asp_educ_kids_ma aspgap_educ_kids ///
				satisfact_life satisfact_fin
			
			
			
***** Average Treatment Effects

										
* Estimation 

local i = 1
local m = 1


foreach y in `Outcomes' {
	
	* Confirming baseline data exists
	cap confirm variable W1_`y'
		
		if !_rc {
			
			* Generating Dummies for Missing BL Vars 
			cap drop W1_`y'_m 
			cap drop W1b_`y'
	
			gen W1_`y'_m = (W1_`y'==.) if W3_`y'!=. 
			gen W1b_`y' = W1_`y'
			replace W1b_`y'= 5 if W1_`y'_m == 1
		
			* Estimating OLS Specification With Baseline Dep Var and Strata Controls
			display "ITT: With Baseline Dep Var and Strata Controls"
			areg W3_`y' `treat' W1b_`y' W1_`y'_m `strata' if W3_finished==1, absorb(W1_village) robust

		}
		
		else {
		
			* Estimating OLS Specification With Strata Controls
			display "ITT: With Strata Controls"
			areg W3_`y' `treat' `strata' if W3_finished==1, absorb(W1_village) robust
				
		}
		
		* Storing Estimates
		eststo T`m'_Asps_`i'
		estadd ysumm
		
		* Performing F-tests
		test book_only-book_mov=0
		estadd scalar f_BvsBM = r(p)
		test book_only-book_ast=0
		estadd scalar f_BvsBA = r(p)
		test book_only-book_mov_ast=0
		estadd scalar f_BvsBMA = r(p)
		test book_mov-book_ast=0
		estadd scalar f_BMvsBA = r(p)
		test book_mov+book_ast=book_mov_ast
		local sign = sign(_b[book_mov_ast]-_b[book_mov]-_b[book_ast])
		estadd scalar f_BM_BAvsBMA = ttail(r(df_r),`sign'*sqrt(r(F)))
		
		* Storing Control Group Stats
		sum W3_`y' if control==1
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
				
		local ++i
}

capture erase "csv\treatment effects\T`m'_Asps_itt.csv"

* Excel output
#delimit ;
	esttab T`m'_Asps_* using "csv\treatment effects\T`m'_Asps_itt.csv", 
	label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01)
	stats(r2 N mean sd f_BvsBM f_BvsBA f_BvsBMA f_BMvsBA f_BM_BAvsBMA, 
	fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) 
	labels("R-squared" "N" "Dependent Variable Mean in Control Group" "Dependent Variable SD in Control Group" 
	"F-test (p-value): Book = Book & Movie" "F-test (p-value): Book = Book & Assistance" 
	"F-test (p-value): Book = Book & Movie & Assistance" "F-test (p-value): Book & Movie = Book & Assistance" 
	"F-test (p-value): B & M + B & A > All Three"))
	title(ITT effects) keep(book_*);
#delimit cr

	local ++m						
				
	
	
***** Heterogeneous Treatment Effects


*** AM/BM Dummies

* Sorting Binary from Continuous Variables
foreach v in	`Outcomes' {
				capture assert missing(`v') | inlist(`v', 0, 1)
                if _rc == 0 local bin `bin' `v'
				if _rc == 1 local cont `cont' `v'
       }

* Creating AM/BM Dummies for Continuous Variables
foreach x in	`cont'	{	
				cap drop 		W1_`x'_AM 
				cap drop		W1_`x'_BM
				egen W1_`x' 	= median(W1_`x')
				gen W1_`x'_AM 	= (W1_`x'>W1_`x'_md) if !missing(`x')
				gen `x'_BM 		= 1 - `x'_AM
}

* Retaining Variable for Binary Variables
foreach x in 	`bin'	{
				gen W1_`x'_AM	= W1_`x'
				gen `x'_BM 		= 1 - `x'_AM	
	}


*** Interaction Dummies and Labels

foreach T in	book_only book_mov book_ast book_mov_ast {

	foreach y in 	`Outcomes' {
	
		* Confirming baseline data exists
		cap confirm variable W1_`y'
		
		* Generating Dummies
		if !_rc {
		
			gen `T'_`y'_AM			= `T' * W1_`y'_AM	
			local label: var label `T'
			label var `T'_`y'_AM	"Above-Md Baseline Level of Outcome X `label'"
			
		}
		
		else {
		}

	}
	
	* Additional Dummies for HTEs
	gen `T'_size_AM					= `T' * W1_size_AM
	label var `T'_size_AM			"Abv MD Business Size X `label'"
				
	gen `T'_male					= `T' * W1_male
	label var `T'_male				"Male X `label'"
}



*** By Baseline Level of Outcome

local i = 1
	
est drop _all


foreach y in `Outcomes' {
	
	* Confirming baseline data exists
	cap confirm variable W1_`y'
		
		if !_rc {

			* Generating Dummies for missing BL vars 
			cap drop W1_`y'_m 
			cap drop W1b_`y'
		
			gen W1_`y'_m 	= (W1_`y'==.) if W3_`y'!=. 
			gen W1b_`y' 	= W1_`y'
			replace W1b_`y'	= 5 if W1_`y'_m == 1
			
			* Generating local for HTE dummies
			local hte_`y'	book_only_`y'_AM book_mov_`y'_AM book_ast_`y'_AM book_mov_ast_`y'_AM
	
			* Estimating OLS Specification With Baseline Dep Var and Strata Controls
			display "HTE: With BL Dep Var and Strata Controls"
			areg W3_`y' `treat' `hte_`y'' W1b_`y' W1_`y'_m `strata' if W3_finished==1, absorb(W1_village) robust

			* Storing Estimates
			eststo T`m'_Asps_hte_byOutcome`i'
			estadd ysumm
		
			* Performing F-tests
			test book_only + book_only_`y'_AM = 0
			estadd scalar f_BvsBX = r(p)
			test book_mov + book_mov_`y'_AM = 0
			estadd scalar f_BMvsBMX = r(p)
			test book_ast + book_ast_`y'_AM = 0
			estadd scalar f_BAvsBAX = r(p)
			test book_mov_ast + book_mov_ast_`y'_AM = 0
			estadd scalar F_BMAvsBMAX = r(p)
			
			* Storing Control Group Stats by Levels of Heterogeneous Variable
			foreach x in	`y'_AM `y'_BM {
							sum W3_`y' if control==1 & W1_`x'==1
							estadd scalar mean_`x' = r(mean)
							estadd scalar sd_`x' = r(sd)
			}
			
			local ++i

		}
		
		else {
		
			* Generating local for HTE dummies
			local hte_asp12_shop_z	book_only_asp12_shop_z_AM book_mov_asp12_shop_z_AM book_ast_asp12_shop_z_AM book_mov_ast_asp12_shop_z_AM
	
			* Estimating OLS Specification With Baseline Dep Var and Strata Controls
			display "HTE: With Strata Controls"
			areg W3_`y' `treat' `hte_asp12_shop_z' `strata' if W3_finished==1, absorb(W1_village) robust
		
			* Storing Estimates
			eststo T`m'_Asps_hte_byOutcome`i'
			estadd ysumm
		
			* Performing F-tests
			test book_only + book_only_asp12_shop_z_AM = 0
			estadd scalar f_BvsBX = r(p)
			test book_mov + book_mov_asp12_shop_z_AM = 0
			estadd scalar f_BMvsBMX = r(p)
			test book_ast + book_ast_asp12_shop_z_AM = 0
			estadd scalar f_BAvsBAX = r(p)
			test book_mov_ast + book_mov_ast_asp12_shop_z_AM = 0
			estadd scalar F_BMAvsBMAX = r(p)
			
			* Storing Control Group Stats by Levels of Heterogeneous Variable
			foreach x in	asp12_shop_z_AM asp12_shop_z_BM {
							sum W3_`y' if control==1 & W1_`x'==1
							estadd scalar mean_`x' = r(mean)
							estadd scalar sd_`x' = r(sd)
			}

		local ++i

		}		
}

capture erase "csv\treatment effects\T`m'_Asps_HTE_byOutcome.csv"
	
* output
#delimit ;
	esttab T`m'_Asps_hte_byOutcome* using "csv\treatment effects\T`m'_Asps_hte_byOutcome.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N mean_asp_shop_z_AM sd_asp_shop_z_AM mean_asp_shop_z_BM sd_asp_shop_z_BM mean_asp12_shop_z_AM sd_asp12_shop_z_AM mean_asp12_shop_z_BM sd_asp12_shop_z_BM f_BvsBX f_BMvsBMX f_BAvsBAX F_BMAvsBMAX,
	fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) ///
	labels("R-squared" "N" "Dep Var Mean for AM Ideal Asps in Control" "Dep Var SD for AM Ideal Asps in Control" "Dep Var Mean for BM Ideal Asps in Control" "Dep Var SD for BM Ideal Asps in Control"
	"Dep Var Mean for AM 12-mth Asps in Control" "Dep Var SD for AM 12-mth Asps in Control" "Dep Var Mean for BM 12-mth Asps in Control" "Dep Var SD for BM 12-mth Asps in Control" 
	"F-test (p-value): Book + Interaction" "F-test (p-value): Book & Movie + Interaction" "F-test (p-value): Book & Assistaince + Interaction" "F-test (p-value): All Three + Interaction"))
	title(Heterogeneity in Impact by Aspirations Level at Baseline) keep(book_*);
#delimit cr

local ++m




* By Gender and by Shop Space at Baseline

local i = 1
	
est drop _all

local hte_size_AM	book_only_size_AM book_mov_size_AM book_ast_size_AM book_mov_ast_size_AM
local hte_male		book_only_male book_mov_male book_ast_male book_mov_ast_male


foreach y in `Outcomes' {

	cap confirm variable W1_`y'
		
		if !_rc {

			* Generating Dummies for missing BL vars 
			cap drop W1_`y'_m 
			cap drop W1b_`y'
		
			gen W1_`y'_m = (W1_`y'==.) if W3_`y'!=. 
			gen W1b_`y' = W1_`y'
			replace W1b_`y'= 5 if W1_`y'_m == 1
	
			foreach hte_var in size_AM male {
			
				* Estimating OLS Specification With Baseline Dep Var and Strata Controls
				display "HTE: With BL Dep Var and Strata Controls"
				areg W3_`y' `treat' `hte_`hte_var'' W1b_`y' W1_`y'_m `strata' if W3_finished==1, absorb(W1_village) robust
				eststo T`m'_Asps_hte_byGenderSize`i'
				estadd ysumm
				test book_only + book_only_`hte_var' = 0
				estadd scalar f_BvsBX = r(p)
				test book_mov + book_mov_`hte_var' = 0
				estadd scalar f_BMvsBMX = r(p)
				test book_ast + book_ast_`hte_var' = 0
				estadd scalar f_BAvsBAX = r(p)
				test book_mov_ast + book_mov_ast_`hte_var' = 0
				estadd scalar F_BMAvsBMAX = r(p)
	
				foreach x in size_AM size_BM male female {
					sum W3_`y' if control==1 & W1_`x'==1
					estadd scalar mean_`x' = r(mean)
					estadd scalar sd_`x' = r(sd)
				}
			
			local ++i

			}
		}
		
		else {
	
			foreach hte_var in size_AM male {
	
				* Estimating OLS Specification With Strata Controls
				display "HTE: With BL Dep Var and Strata Controls"
				areg W3_`y' `treat' `hte_`hte_var'' `strata' if W3_finished==1, absorb(W1_village) robust
				
				* Storing Estimates
				eststo T`m'_Asps_hte_byGenderSize`i'
				estadd ysumm
				
				* Performing F-tests
				test book_only + book_only_`hte_var' = 0
				estadd scalar f_BvsBX = r(p)
				test book_mov + book_mov_`hte_var' = 0
				estadd scalar f_BMvsBMX = r(p)
				test book_ast + book_ast_`hte_var' = 0
				estadd scalar f_BAvsBAX = r(p)
				test book_mov_ast + book_mov_ast_`hte_var' = 0
			estadd scalar F_BMAvsBMAX = r(p)
	
				* Storing Control Group Stats by Levels of Heterogeneous Variable
				foreach x in size_AM size_BM male female {
					sum W3_`y' if control==1 & W1_`x'==1
					estadd scalar mean_`x' = r(mean)
					estadd scalar sd_`x' = r(sd)
				}
				
			local ++i
				
			}
		
		}

}

capture erase "csv\treatment effects\T`m'_Asps_hte_byGenderSize.csv"
	
* output
#delimit ;
	esttab T`m'_Asps_hte_byGenderSize* using "csv\treatment effects\T`m'_Asps_hte_byGenderSize.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N mean_size_AM sd_size_AM mean_size_BM sd_size_BM mean_male sd_male mean_female sd_female f_BvsBX f_BMvsBMX f_BAvsBAX F_BMAvsBMAX,
	fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) ///
	labels("R-squared" "N" "Dep Var Mean for AM Size in Control" "Dep Var SD for AM Size in Control" "Dep Var Mean for BM Size in Control" "Dep Var SD for BM Size in Control"
	"Dep Var Mean for Males in Control" "Dep Var SD for Males in Control" "Dep Var Mean for Females in Control" "Dep Var SD for Females in Control"
	"F-test (p-value): Book + Interaction" "F-test (p-value): Book & Movie + Interaction" "F-test (p-value): Book & Assistaince + Interaction" "F-test (p-value): All Three + Interaction"))
	title(Heterogeneity in Impact by Gender and Business Size) keep(book_*);
#delimit cr

//local ++m


