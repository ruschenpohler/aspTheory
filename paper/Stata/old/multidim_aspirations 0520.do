
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
label var `v'_asp_occup_son_high		"Occup aspirations for son above md (yes=1)"
label var `v'_asp_occup_son_govt		"Gov't job aspired for son (yes=1)"
label var `v'_asp_occup_daughter		"Aspired occupation for daughter (ranked)"
label var `v'_asp_occup_daughter_high	"Occup aspirations for daughter above md (yes=1)
label var `v'_asp_occup_daughter_govt	"Gov't job aspired for daughter (yes=1)"
label var `v'_asp_occup_kids			"Aspired occupation for children (ranked)
label var `v'_asp_occup_kids_govt		"Gov't job aspired for either son or daughter (yes=1)"
label var `v'_asp_occup_kids_high		"Avg occup aspirations for children above md (yes=1)"

label var `v'_asp_educ_son				"Aspired educ for son (Years)"
label var `v'_aspgap_educ_son			"Aspirations gap for son's educ"
label var `v'_asp_educ_son_high			"Aspired educ for son above md (Yes=1)"
label var `v'_asp_educ_son_ma			"Aspired educ for son at least MA (Yes=1)"
label var `v'_asp_educ_daughter			"Aspired educ for daughter (Years)"
label var `v'_aspgap_educ_daughter		"Aspirations gap for daughter's educ"
label var `v'_asp_educ_daughter_high	"Aspired educ for son above md (Yes=1)"
label var `v'_asp_educ_daughter_ma		"Aspired educ for daughter at least MA (yes=1)"
label var `v'_asp_educ_kids				"Aspired educ for children (Years)
label var `v'_aspgap_educ_kids			"Aspirations gap for children's educ (Years)"
label var `v'_asp_educ_kids_ma			"Aspired educ for children at least MA (Yes=1)"
label var `v'_asp_educ_kids_high		"Aspired educ for children above md (Yes=1)"

}

/***** SUM STATS ***************************************************************


* Scatters with lin regs (son & daughter)

foreach x in son daughter {

twoway lfitci W1_asp12_sales W1_asp_educ_`x' if W3_finished==1, fintensity(inten10) name(asp_`x') || ///
scatter W1_asp12_sales W1_asp_educ_`x', mcolor(g7) msize(small)
graph export "pdf/asp_sales_educ_`x'.pdf", name(asp_`x') replace

twoway lfitci W1_aspgap12_sales W1_aspgap_educ_`x' if W3_finished==1, fintensity(inten10) name(aspgap_`x') || ///
scatter W1_aspgap12_sales W1_aspgap_educ_`x', mcolor(g7) msize(small)
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
	



* Balance table

local cov		W1_male W1_age_manager W1_educ W1_digitspan W1_risk_comp W1_time_comp ///
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

local z:			word count `cov'
matrix T = 			J(`z', 11, . ) 
matrix rownames T =	`cov' 
matrix colnames T =	Total sdTotal tA tB tC tD tE pvAB pvAC pvAD pvAE

foreach var in `cov' { 

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

foreach var in `cov' { 
	
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


*** Locals

* Treatment Variables
local treat					book_only book_mov book_ast book_mov_ast

* Strata Controls
local strata 				W1_male W1_space_ord W1_MW_score_total_abovemd

* Outcomes
local Business_ST			asp12_shop_z asp12_shop_z_prob asp12_shop_z_cse asp12_shop_z_loc ///
							asp12_sales asp12_sales_prob asp12_sales_cse asp12_sales_loc ///
							asp12_size asp12_employee asp12_customer
local Business_LT			asp_shop_z ///
							asp_size asp_employee asp_customer
local Education				asp_educ_son aspgap_educ_son asp_educ_son_ma /// 				//asp_educ_son_high
							asp_educ_daughter aspgap_educ_daughter asp_educ_daughter_ma ///	//asp_educ_daughter_high
							asp_educ_kids aspgap_educ_kids asp_educ_kids_ma		 			//asp_educ_kids_high
local Occupation			asp_occup_son asp_occup_son_govt ///							//asp_occup_son_high
							asp_occup_daughter asp_occup_daughter_govt /// 					//asp_occup_daughter_high
							asp_occup_kids asp_occup_kids_govt 								//asp_occup_kids_high
local Agency				asp_import asp_prob asp_seff asp_loc asp_cse


* Outcomes for TE estimation (insert desired outcomes here)
local Outcomes_ST			Business_ST Education Occupation
local Outcomes_LT			Business_LT Education Occupation
local Outcomes_all			Business_ST Business_LT Education Occupation
local Satisfaction			satisfact_life satisfact_fin


						 
***** Intent-to-treat estimates (ITT)


set more off 


* Estimation 

local i = 1
local m = 1


foreach this_Outcome in `Outcomes_all' {
	
	est drop _all
	
	foreach var in ``this_Outcome'' {

		* Generating Dummies for Missing BL Vars 
		cap drop W1_`var'_m 
		cap drop W1b_`var'
	
		gen W1_`var'_m = (W1_`var'==.) if W3_`var'!=. 
		gen W1b_`var' = W1_`var'
		replace W1b_`var'= 5 if W1_`var'_m == 1
		
		/*
		*Simple OLS (No Controls)
		display "ITT: Simple OLS (No Controls)"
		reg W3_`var' `treat', robust
		est sto T`m'_`this_Outcome'_`i'
		estadd ysumm
		test book_only-book_mov=0
		estadd scalar f1 = r(p)
		test book_only-book_ast=0
		estadd scalar f2 = r(p)
		test book_only-book_mov_ast=0
		estadd scalar f3 = r(p)
		test book_mov-book_ast=0
		estadd scalar f4 = r(p)
		sum W3_`var' if control==1
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		
		local ++i
						
		*With Baseline Dep Var
		display "ITT: With Baseline Dep Var"
		reg W3_`var' `treat' W1b_`var' W1_`var'_m, robust
		est sto T`m'_`this_Outcome'_`i'
		estadd ysumm
		test book_only-book_mov=0
		estadd scalar f1 = r(p)
		test book_only-book_ast=0
		estadd scalar f2 = r(p)
		test book_only-book_mov_ast=0
		estadd scalar f3 = r(p)
		test book_mov-book_ast=0
		estadd scalar f4 = r(p)
		sum W3_`var' if control==1
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		
		local ++i
		*/
		
		*With Baseline Dep Var and Strata Controls
		display "ITT: With Baseline Dep Var and Strata Controls"
		areg W3_`var' `treat' W1b_`var' W1_`var'_m `strata' if W3_finished==1, absorb(W1_village) robust
		eststo T`m'_`this_Outcome'_`i'
		estadd ysumm
		test book_only-book_mov=0
		estadd scalar f_B_BMov = r(p)
		test book_only-book_ast=0
		estadd scalar f_B_BAst = r(p)
		test book_only-book_mov_ast=0
		estadd scalar f_B_MovAst = r(p)
		test book_mov-book_ast=0
		estadd scalar f_BMov_BAst = r(p)
		test book_mov+book_ast=book_mov_ast
		local sign = sign(_b[book_mov_ast]-_b[book_mov]-_b[book_ast])
		estadd scalar f_BMovBAst_BMovAst = ttail(r(df_r),`sign'*sqrt(r(F)))
		sum W3_`var' if control==1
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		
		local ++i

	}
	
capture erase "csv\treatment effects\T`m'_`this_Outcome'_itt.csv"

* Excel output
#delimit ;
	esttab T`m'_`this_Outcome'_* using "csv\treatment effects\T`m'_`this_Outcome'_itt.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01)
	stats(r2 N mean sd f_B_BMov f_B_BAst f_B_MovAst f_BMov_BAst f_BMovBAst_BMovAst, fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) labels("R-squared" "N" "Dependent Variable Mean in Control Group" "Dependent Variable SD in Control Group" "F-test (p-value): Book = Book & Movie" "F-test (p-value): Book = Book & Assistance" "F-test (p-value): Book = Book & Movie & Assistance" "F-test (p-value): Book & Movie = Book & Assistance" "F-test (p-value): B & M + B & A > All Three"))
	title(`this_Outcome' Outcomes) keep(book_*);
#delimit cr

	local ++m
}


*** Satisfaction

* Estimation 

local i = 1

	est drop _all
	
	foreach var in `Satisfaction' {

		*With Strata Controls
		display "ITT: With Baseline Dep Var and Strata Controls"
		areg W3_`var' `treat' `strata' if W3_finished==1, absorb(W1_village) robust
		eststo T`m'_Satisfaction_`i'
		estadd ysumm
		test book_only-book_mov=0
		estadd scalar f_B_BMov = r(p)
		test book_only-book_ast=0
		estadd scalar f_B_BAst = r(p)
		test book_only-book_mov_ast=0
		estadd scalar f_B_MovAst = r(p)
		test book_mov-book_ast=0
		estadd scalar f_BMov_BAst = r(p)
		test book_mov+book_ast=book_mov_ast
		local sign = sign(_b[book_mov_ast]-_b[book_mov]-_b[book_ast])
		estadd scalar f_BMovBAst_BMovAst = ttail(r(df_r),`sign'*sqrt(r(F)))
		sum W3_`var' if control==1
		estadd scalar mean = r(mean)
		estadd scalar sd = r(sd)
		
		local ++i
	}
	
capture erase "csv\treatment effects\T`m'_Satisfaction_itt.csv"

* Excel output
#delimit ;
	esttab T`m'_Satisfaction_* using "csv\treatment effects\T`m'_Satisfaction_itt.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N mean sd f_B_BMov f_B_BAst f_B_MovAst f_BMov_BAst f_BMovBAst_BMovAst, fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) labels("R-squared" "N" "Dependent Variable Mean in Control Group" "Dependent Variable SD in Control Group" "F-test (p-value): Book = Book & Movie" "F-test (p-value): Book = Book & Assistance" "F-test (p-value): Book = Book & Movie & Assistance" "F-test (p-value): Book & Movie = Book & Assistance" "F-test (p-value): B & M + B & A > All Three"))
	title(Satisfaction Outcomes) keep(book_*);
#delimit cr

	local ++m



***** Heterogeneous Treatment Effects


*** Interactions for HTE effects

gen AMshopspace 	= W1_size_abovemd
gen BMshopspace		= 1 - W1_size_abovemd

gen male 			= W1_male
gen female			= 1 - W1_male

gen AMscore 		= W1_MW_score_total_abovemd
gen BMscore			= 1 - W1_MW_score_total_abovemd

gen AMbisaspST		= W1_asp12_shop_z_AM
gen BMbisaspST		= 1 - AMbisaspST

gen AMbisaspLT		= W1_asp_shop_z_AM
gen BMbisaspLT		= 1 - AMbisaspLT

gen AMbisaspSTSales	= W1_asp12_sales_AM
gen AMbisaspSTSize	= W1_asp12_size_AM
gen AMbisaspSTEmpl	= W1_asp12_employee_AM
gen AMbisaspSTCust	= W1_asp12_customer_AM

gen ifail			= W1_imagine_fail

gen AMeducasp 		= W1_asp_educ_kids_high
gen AMoccupasp		= W1_asp_occup_kids_high


foreach var in book_only book_mov book_ast book_mov_ast {

gen	`var'_AMshopspace		= `var'*AMshopspace
gen	`var'_BMshopspace		= `var'*BMshopspace

gen `var'_male 				= `var'*male
gen `var'_female 			= `var'*female

gen `var'_AMscore			= `var'*AMscore
gen `var'_BMscore			= `var'*BMscore

gen `var'_AMbisaspST		= `var'*AMbisaspST
gen `var'_BMbisaspST		= `var'*BMbisaspST

gen `var'_AMbisaspLT		= `var'*AMbisaspLT
gen `var'_BMbisaspLT		= `var'*BMbisaspLT

gen `var'_AMbisaspSTSales	= `var'*AMbisaspSTSales
gen `var'_AMbisaspSTSize	= `var'*AMbisaspSTSize
gen `var'_AMbisaspSTEmpl	= `var'*AMbisaspSTEmpl
gen `var'_AMbisaspSTCust	= `var'*AMbisaspSTCust

gen `var'_ifail				= `var'*ifail

gen `var'_AMeducasp			= `var'*AMeducasp
gen `var'_AMoccupasp		= `var'*AMoccupasp
}

label var book_only_AMshopspace			"Abv MD Shop Space X Assigned Handbook"
label var book_mov_AMshopspace			"Abv MD Shop Space X Assigned Handbook & Movie"
label var book_ast_AMshopspace			"Abv MD Shop Space X Assigned Handbook & Assistance"
label var book_mov_ast_AMshopspace		"Abv MD Shop Space X Assigned All Three"

label var book_only_AMbisaspST			"Abv MD Business Asps X Assigned Handbook"
label var book_mov_AMbisaspST			"Abv MD Business Asps X Assigned Handbook & Movie"
label var book_ast_AMbisaspST			"Abv MD Business Asps X Assigned Handbook & Assistance"
label var book_mov_ast_AMbisaspST		"Abv MD Business Asps X Assigned All Three"

label var book_only_AMbisaspSTSales		"Abv MD Sales Asps X Assigned Handbook"
label var book_mov_AMbisaspSTSales		"Abv MD Sales Asps X Assigned Handbook & Movie"
label var book_ast_AMbisaspSTSales		"Abv MD Sales Asps X Assigned Handbook & Assistance"
label var book_mov_ast_AMbisaspSTSales	"Abv MD Sales Asps X Assigned All Three"

label var book_only_AMbisaspSTSize    	"Abv MD Size Asps X Assigned Handbook"
label var book_mov_AMbisaspSTSize		"Abv MD Size Asps X Assigned Handbook & Movie"
label var book_ast_AMbisaspSTSize		"Abv MD Size Asps X Assigned Handbook & Assistance"
label var book_mov_ast_AMbisaspSTSize	"Abv MD Size Asps X Assigned All Three"

label var book_only_AMbisaspSTEmpl    	"Abv MD Employee Asps X Assigned Handbook"
label var book_mov_AMbisaspSTEmpl		"Abv MD Employee Asps X Assigned Handbook & Movie"
label var book_ast_AMbisaspSTEmpl		"Abv MD Employee Asps X Assigned Handbook & Assistance"
label var book_mov_ast_AMbisaspSTEmpl	"Abv MD Employee Asps X Assigned All Three"

label var book_only_AMbisaspSTCust    	"Abv MD Customer Asps X Assigned Handbook"
label var book_mov_AMbisaspSTCust		"Abv MD Customer Asps X Assigned Handbook & Movie"
label var book_ast_AMbisaspSTCust		"Abv MD Customer Asps X Assigned Handbook & Assistance"
label var book_mov_ast_AMbisaspSTCust	"Abv MD Customer Asps X Assigned All Three"

label var book_only_AMbisaspLT			"Abv MD Business Asps X Assigned Handbook"
label var book_mov_AMbisaspLT			"Abv MD Business Asps X Assigned Handbook & Movie"
label var book_ast_AMbisaspLT			"Abv MD Business Asps X Assigned Handbook & Assistance"
label var book_mov_ast_AMbisaspLT		"Abv MD Business Asps X Assigned All Three"
label var book_only_female				"Female X Assigned Handbook"
label var book_mov_female				"Female X Assigned Handbook & Movie"
label var book_ast_female				"Female X Assigned Handbook & Assistance"
label var book_mov_ast_female			"Female X Assigned All Three"
label var book_only_AMeducasp			"Abv MD Educ Asps X Assigned Handbook"
label var book_mov_AMeducasp			"Abv MD Educ Asps X Assigned Handbook & Movie"
label var book_ast_AMeducasp			"Abv MD Educ Asps X Assigned Handbook & Assistance"
label var book_mov_ast_AMeducasp		"Abv MD Educ Asps X Assigned All Three"
label var book_only_AMoccupasp			"Abv MD Occup Asps X Assigned Handbook"
label var book_mov_AMoccupasp			"Abv MD Occup Asps X Assigned Handbook & Movie"
label var book_ast_AMoccupasp			"Abv MD Occup Asps X Assigned Handbook & Assistance"
label var book_mov_ast_AMoccupasp		"Abv MD Occup Asps X Assigned All Three"

local het_bisST 		AMbisaspST AMshopspace female 
local het_bisLT			AMbisaspLT AMshopspace female
local het_educ			AMeducasp AMshopspace female
local het_occup			AMoccupasp AMshopspace female

local het_AMshopspace	book_only_AMshopspace book_mov_AMshopspace book_ast_AMshopspace book_mov_ast_AMshopspace

local het_male			book_only_male book_mov_male book_ast_male book_mov_ast_male
local het_female		book_only_female book_mov_female book_ast_female book_mov_ast_female

local het_AMbisaspST	book_only_AMbisaspST book_mov_AMbisaspST book_ast_AMbisaspST book_mov_ast_AMbisaspST AMbisaspST 
local het_BMbisaspST	book_only_BMbisaspST book_mov_BMbisaspST book_ast_BMbisaspST book_mov_ast_BMbisaspST BMbisaspST 

local het_AMbisaspLT	book_only_AMbisaspLT book_mov_AMbisaspLT book_ast_AMbisaspLT book_mov_ast_AMbisaspLT AMbisaspLT 
local het_BMbisaspLT	book_only_BMbisaspLT book_mov_BMbisaspLT book_ast_BMbisaspLT book_mov_ast_BMbisaspLT BMbisaspLT 

local het_AMeducasp		book_only_AMeducasp book_mov_AMeducasp book_ast_AMeducasp book_mov_ast_AMeducasp AMeducasp
local het_AMoccupasp	book_only_AMoccupasp book_mov_AMoccupasp book_ast_AMoccupasp book_mov_ast_AMoccupasp AMoccupasp

set more off 

		
* 12 months business aspirations

local i = 1
	
est drop _all

//foreach this_Outcome in `Outcomes_ST' {
foreach v in `het_bisST' {
	foreach var in `Business_ST' {

	* Generating Dummies for missing BL vars 
	cap drop W1_`var'_m 
	cap drop W1b_`var'
		
	gen W1_`var'_m = (W1_`var'==.) if W3_`var'!=. 
	gen W1b_`var' = W1_`var'
	replace W1b_`var'= 5 if W1_`var'_m == 1
	

	*With BL Dep Var and Strata Controls	
	display "HTE: With BL Dep Var and Strata Controls"
	areg W3_`var' `treat' `het_`v'' W1b_`var' W1_`var'_m `strata' if W3_finished==1, absorb(W1_village) robust
	eststo T`m'_Business_ST_`i'
	estadd ysumm
	test book_only + book_only_`v'=0
	estadd scalar f_B_BInt = r(p)
	test book_mov + book_mov_`v'=0
	estadd scalar f_BMov_BMovInt = r(p)
	test book_ast + book_ast_`v'=0
	estadd scalar f_BAst_BAstInt = r(p)
	test book_mov_ast + book_mov_ast_`v'=0
	estadd scalar f_BMovAst_BMovAstInt = r(p)
	
	foreach x in AMbisaspST BMbisaspST male female {
		sum W3_`var' if control==1 & `x'==1
		estadd scalar mean_`x' = r(mean)
		estadd scalar sd_`x' = r(sd)
	}
		
	local ++i
		
	}
}

capture erase "csv\treatment effects\T`m'_Business_ST_hte.csv"
	
* output
#delimit ;
	esttab T`m'_Business_ST_* using "csv\treatment effects\T`m'_Business_ST_hte.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N mean_AMbisaspST sd_AMbisaspST mean_BMbisaspST sd_BMbisaspST mean_male sd_male mean_female sd_female f_B_BInt f_BMov_BMovInt f_BAst_BAstInt f_BMovAst_BMovAstInt,
	fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) ///
	labels("R-squared" "N" "Dep Var Mean for AM Asps in Control" "Dep Var SD for AM Asps in Control" "Dep Var Mean for BM Asps in Control" "Dep Var SD for BM Asps in Control"
	"Dep Var Mean for Males in Control" "Dep Var SD for Males in Control" "Dep Var Mean for Females in Control" "Dep Var SD for Females in Control"
	"F-test (p-value): Book + Interaction" "F-test (p-value): Book & Movie + Interaction" "F-test (p-value): Book & Assistaince + Interaction" "F-test (p-value): All Three + Interaction"))
	title(Short-term Business Outcomes) keep(book_*);
#delimit cr

local ++m

//}

* LT business aspirations
	
//foreach this_Outcome in `Outcomes_LT' {
foreach v in `het_bisLT' {
	foreach var in `Business_LT' {

	* Generating Dummies for missing BL vars 
	cap drop W1_`var'_m 
	cap drop W1b_`var'
		
	gen W1_`var'_m = (W1_`var'==.) if W3_`var'!=. 
	gen W1b_`var' = W1_`var'
	replace W1b_`var'= 5 if W1_`var'_m == 1

	*With BL Dep Var and Strata Controls	
	display "HTE: With BL Dep Var and Strata Controls"
	areg W3_`var' `treat' `het_`v'' W1b_`var' W1_`var'_m `strata' if W3_finished==1, absorb(W1_village) robust
	eststo T`m'_Business_LT_`i'
	estadd ysumm
	test book_only + book_only_`v'=0
	estadd scalar f1 = r(p)
	test book_mov + book_mov_`v'=0
	estadd scalar f2 = r(p)
	test book_ast + book_ast_`v'=0
	estadd scalar f3 = r(p)
	test book_mov_ast + book_mov_ast_`v'=0
	estadd scalar f4 = r(p)
	
	foreach x in AMbisaspST BMbisaspST male female {
		sum W3_`var' if control==1 & `x'==1
		estadd scalar mean_`x' = r(mean)
		estadd scalar sd_`x' = r(sd)
	}
		
	local ++i
		
	}
}
	
capture erase "csv\treatment effects\T`m'_Business_LT_hte.csv"

* output
#delimit ;
	esttab T`m'_Business_LT_* using "csv\treatment effects\T`m'_Business_LT_hte.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N mean_AMbisaspST sd_AMbisaspST mean_BMbisaspST sd_BMbisaspST mean_male sd_male mean_female sd_female f_B_BInt f_BMov_BMovInt f_BAst_BAstInt f_BMovAst_BMovAstInt,
	fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) ///
	labels("R-squared" "N" "Dep Var Mean for AM Asps in Control" "Dep Var SD for AM Asps in Control" "Dep Var Mean for BM Asps in Control" "Dep Var SD for BM Asps in Control"
	"Dep Var Mean for Males in Control" "Dep Var SD for Males in Control" "Dep Var Mean for Females in Control" "Dep Var SD for Females in Control"
	"F-test (p-value): Book + Interaction" "F-test (p-value): Book & Movie + Interaction" "F-test (p-value): Book & Assistaince + Interaction" "F-test (p-value): All Three + Interaction"))
	title(Long-term Business Outcomes) keep(book_*);
#delimit cr

local ++m
//}



* Educ aspirations
	
foreach v in `het_educ' {
	foreach var in `Education' {

	* Generating Dummies for missing BL vars 
	cap drop W1_`var'_m 
	cap drop W1b_`var'
		
	gen W1_`var'_m = (W1_`var'==.) if W3_`var'!=. 
	gen W1b_`var' = W1_`var'
	replace W1b_`var'= 5 if W1_`var'_m == 1
	
	*With BL Dep Var and Strata Controls	
	display "HTE: With BL Dep Var and Strata Controls"
	areg W3_`var' `treat' `het_`v'' W1b_`var' W1_`var'_m `strata' if W3_finished==1, absorb(W1_village) robust
	eststo T`m'_Education_`i'
	estadd ysumm
	test book_only + book_only_`v'=0
	estadd scalar f1 = r(p)
	test book_mov + book_mov_`v'=0
	estadd scalar f2 = r(p)
	test book_ast + book_ast_`v'=0
	estadd scalar f3 = r(p)
	test book_mov_ast + book_mov_ast_`v'=0
	estadd scalar f4 = r(p)
	
	foreach x in AMbisaspST BMbisaspST male female {
		sum W3_`var' if control==1 & `x'==1
		estadd scalar mean_`x' = r(mean)
		estadd scalar sd_`x' = r(sd)
	}
		
	local ++i
		
	}
}
	
capture erase "csv\treatment effects\T`m'_Education_hte.csv"

* output
#delimit ;
	esttab T`m'_Education_* using "csv\treatment effects\T`m'_Education_hte.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N mean_AMbisaspST sd_AMbisaspST mean_BMbisaspST sd_BMbisaspST mean_male sd_male mean_female sd_female f_B_BInt f_BMov_BMovInt f_BAst_BAstInt f_BMovAst_BMovAstInt,
	fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) ///
	labels("R-squared" "N" "Dep Var Mean for AM Asps in Control" "Dep Var SD for AM Asps in Control" "Dep Var Mean for BM Asps in Control" "Dep Var SD for BM Asps in Control"
	"Dep Var Mean for Males in Control" "Dep Var SD for Males in Control" "Dep Var Mean for Females in Control" "Dep Var SD for Females in Control"
	"F-test (p-value): Book + Interaction" "F-test (p-value): Book & Movie + Interaction" "F-test (p-value): Book & Assistaince + Interaction" "F-test (p-value): All Three + Interaction"))
	title(Children's Educ Outcomes) keep(book_*);
#delimit cr

local ++m
	
	

* Occup aspirations
	
foreach v in `het_occup' {
	foreach var in `Occupation' {

	* Generating Dummies for missing BL vars 
	cap drop W1_`var'_m 
	cap drop W1b_`var'
		
	gen W1_`var'_m = (W1_`var'==.) if W3_`var'!=. 
	gen W1b_`var' = W1_`var'
	replace W1b_`var'= 5 if W1_`var'_m == 1
	
	*With BL Dep Var and Strata Controls	
	display "HTE: With BL Dep Var and Strata Controls"
	areg W3_`var' `treat' `het_`v'' W1b_`var' W1_`var'_m `strata' if W3_finished==1, absorb(W1_village) robust
	eststo T`m'_Occupation_`i'
	estadd ysumm
	test book_only + book_only_`v'=0
	estadd scalar f1 = r(p)
	test book_mov + book_mov_`v'=0
	estadd scalar f2 = r(p)
	test book_ast + book_ast_`v'=0
	estadd scalar f3 = r(p)
	test book_mov_ast + book_mov_ast_`v'=0
	estadd scalar f4 = r(p)
	
	foreach x in AMbisaspST BMbisaspST male female {
		sum W3_`var' if control==1 & `x'==1
		estadd scalar mean_`x' = r(mean)
		estadd scalar sd_`x' = r(sd)
	}
		
	local ++i
		
	}
}
	
capture erase "csv\treatment effects\T`m'_Occupation_hte.csv"

* output
#delimit ;
	esttab T`m'_Occupation_* using "csv\treatment effects\T`m'_Occupation_hte.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N mean_AMbisaspST sd_AMbisaspST mean_BMbisaspST sd_BMbisaspST mean_male sd_male mean_female sd_female f_B_BInt f_BMov_BMovInt f_BAst_BAstInt f_BMovAst_BMovAstInt,
	fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) ///
	labels("R-squared" "N" "Dep Var Mean for AM Asps in Control" "Dep Var SD for AM Asps in Control" "Dep Var Mean for BM Asps in Control" "Dep Var SD for BM Asps in Control"
	"Dep Var Mean for Males in Control" "Dep Var SD for Males in Control" "Dep Var Mean for Females in Control" "Dep Var SD for Females in Control"
	"F-test (p-value): Book + Interaction" "F-test (p-value): Book & Movie + Interaction" "F-test (p-value): Book & Assistaince + Interaction" "F-test (p-value): All Three + Interaction"))	
	title(Children's Occup Outcomes) keep(book_*);
#delimit cr

local ++m



* Satisfaction

local i = 1
		
est drop _all

foreach v in `het_bisST' {
	foreach var in `Satisfaction' {

	*With Strata Controls
	display "HTE: With Baseline Dep Var and Strata Controls"
	areg W3_`var' `treat' `het_`v'' `strata' if W3_finished==1, absorb(W1_village) robust
	eststo T`m'_Satisfaction_`i'
	estadd ysumm
	test book_only + book_only_`v'=0
	estadd scalar f1 = r(p)
	test book_mov + book_mov_`v'=0
	estadd scalar f2 = r(p)
	test book_ast + book_ast_`v'=0
	estadd scalar f3 = r(p)
	test book_mov_ast + book_mov_ast_`v'=0
	estadd scalar f4 = r(p)
	
	foreach x in AMbisaspST BMbisaspST male female {
		sum W3_`var' if control==1 & `x'==1
		estadd scalar mean_`x' = r(mean)
		estadd scalar sd_`x' = r(sd)
	}
	
	local ++i

	}
}
	
capture erase "csv\treatment effects\T`m'_Satisfaction_hte.csv"

* output
#delimit ;
	esttab T`m'_Satisfaction_* using "csv\treatment effects\T`m'_Satisfaction_hte.csv", label replace modelwidth(16) varwidth(50) depvar legend 
	cells(b(star fmt(%9.3f)) se(par)) star(* 0.10 ** 0.05 *** 0.01) 
	stats(r2 N mean_AMbisaspST sd_AMbisaspST mean_BMbisaspST sd_BMbisaspST mean_male sd_male mean_female sd_female f_B_BInt f_BMov_BMovInt f_BAst_BAstInt f_BMovAst_BMovAstInt,
	fmt(%9.3f %9.0g %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f %9.3f) ///
	labels("R-squared" "N" "Dep Var Mean for AM Asps in Control" "Dep Var SD for AM Asps in Control" "Dep Var Mean for BM Asps in Control" "Dep Var SD for BM Asps in Control"
	"Dep Var Mean for Males in Control" "Dep Var SD for Males in Control" "Dep Var Mean for Females in Control" "Dep Var SD for Females in Control"
	"F-test (p-value): Book + Interaction" "F-test (p-value): Book & Movie + Interaction" "F-test (p-value): Book & Assistaince + Interaction" "F-test (p-value): All Three + Interaction"))	
	title(`this_Outcome' Outcomes) keep(book_*);
#delimit cr

