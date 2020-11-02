
********************************************************************************
************** 		RETAILERS INDONESIA PROJECT, 2016-2018 		****************
*
*
*				 Data management do-file for endline 2 data
*
*				
********************************************************************************
 

clear all
set more off

*cd "`c(pwd)'\"

use "Data\Endline 2 Data\merged data\W4_merged.dta", clear


************************************************************************
***** GENERAL **********************************************************


*** ID
destring cspro_id, gen(shop_ID)


*** Unfinished interviews

mdesc 		f4_17_01
rename 		f4_17_01 interview_result

gen finished = 0
replace finished = (interview_result==1)

gen closed = 0
replace closed = (interview_result==4)

gen refused = 0
replace refused = inlist(interview_result, 2, 3, 7)

* Deleting attriters
keep if finished==1


***** Cleaning monetary variables

foreach x in	f4_8_1 f4_8_2 f4_8_3a-f4_8_3k f4_8_4 f4_8_5 f4_9_8 f4_10_3aa f4_10_3ba ///
				f4_10_3c f4_10_3ha {

destring `x', replace ig("___.___.___.__" "___.___.___.__" "___.___._" "___.___." "___.__" "___._" "___.")

}


*** Exchange rate

* All sales/expenses/profits data converted to USD PPP with IDR 4190.49 = 1 USD
* from WB data, 2017:  https://data.worldbank.org/indicator/PA.NUS.PPP?locations=ID
gen 		xchange = 4190.49



**************************************************************************
***** MANAGER CHARACTERISTICS ********************************************


***** AGE
gen			age_manager = 2017 - f4_2_4b_yr
destring 	age_manager, replace ignore(".")
replace 	age_manager =. if age_manager>9997

* Detect missing values in both age vars --> 0 obs
mdesc		age_manager

* Median manager age
egen		age_manager_md = median(age_manager)

* Dummy for being above median age
gen			age_manager_abvmd = 1 if age_manager>age_manager_md
replace 	age_manager_abvmd = 0 if age_manager_abvmd==.


***** GENDER *************************************************** n = 102!
//gen 		male 	= f4_2_4a
//gen 		female 	= 1 - male

* Detect missing values in both gender vars --> 0 obs
//mdesc		male

* Recoding "no" answers
//replace 	male = 0 if male==3


***** OFFSPRING ***************************************************************** Data not available for EL2


***** EDUCATION ************************************************ n = 102!

* Detect missing values in both education vars --> 0 obs
//tab			f4_2_4d
//mdesc		f4_2_4d

//gen educ = f4_2_4d

* Create dummies for finished secondary educ and BA degree
//gen 		educ_second = 1 if f4_2_4d >= 12
//replace 	educ_second = 0 if educ_second==.

//gen 		educ_terc = 1 	if f4_2_4d >= 16
//replace 	educ_terc = 0 	if educ_terc==.


***** WORKING AND THINKING STYLE SCALE ****************************************** Data not available for EL2



************************************************************************
***** FIRM CHARACTERISTICS *********************************************


***** FORMALITY

* Company reg certificate (TDP) ************************************************** Data not available for EL2

* Tax identification no
gen 		formal_tax = f4_9_12b
label var	formal_tax "Business Has Tax ID (Yes=1)"
label val	formal_tax f4_9_12b

* VAT collection no ************************************************************* Data not available for EL2


***** SPACE

gen size = f4_10_01aa
label var size "Business size (square meters)"

egen size_md = median(size)
gen size_AM = (size>size_md)
gen size_BM = 1 - size_AM


*** Storage space *************************************************************** Data not available in EL2


*** Occupancy status *********************************************************** Data not available in EL2


***** Opening hours ************************************************************* Data not available for EL2

* Days per week open
gen 		open_days = f4_3_4


***** CUSTOMERS
gen 		custom_total = f4_3_10b
replace 	custom_total =. if custom_total>=998


***** ASSETS ******************************************************************** Data not available for EL2


************************************************************************
***** SALES, EXPENSES, AND PROFIT ************************************************************


***** SALES LAST MONTH 

gen sales_lastmth = f4_8_2

mdesc 		sales_lastmth

replace		sales_lastmth		=. if sales_lastmth>999999999996
replace 	sales_lastmth 		= sales_lastmth/xchange
replace 	sales_lastmth 		=. if sales_lastmth>500000


***** SALES ON A NORM DAY

gen sales_nday = f4_8_5

mdesc 		sales_nday

replace		sales_nday			=. if sales_nday>999999999996
replace 	sales_nday 			= sales_nday/xchange
//replace 	sales_nday 			=. if sales_nday>17500

gen	sales_calc=sales_nday*f4_3_4*(365/84)
replace sales_lastmth=sales_calc if sales_lastmth==sales_nday
*replace sales_lastmth=sales_calc if sales_lastmth==.


***** SALES MTHLY COMPOSITE
gen 		sales_comp1 = (sales_lastmth + sales_calc)/2


************************************************************************
***** EXPENSES *********************************************************


***** STOCK-UP COSTS
gen expense_stockup = f4_8_3a
replace 	expense_stockup 	=. if expense_stockup>999999999995
replace 	expense_stockup 	= expense_stockup/xchange

***** SALARIES AND BENEFITS
gen expense_wage = f4_8_3b
replace 	expense_wage 		= expense_wage/xchange

***** RENT AND FEES
gen expense_rent = f4_8_3c
replace 	expense_rent 		=. if expense_rent>999999999995
replace 	expense_rent 		= expense_rent/xchange

***** ELECTRICITY AND UTILITIES
gen expense_electric = f4_8_3d
replace 	expense_electric 	=. if expense_electric>999999999995
replace 	expense_electric 	= expense_electric/xchange

***** TRANSPORTATION COSTS
gen expense_transport = f4_8_3e
replace 	expense_transport 	=. if expense_transport>999999999995
replace 	expense_transport 	= expense_transport/xchange

***** OTHER EXPENSES
gen expense_other = f4_8_3k
replace 	expense_other 		= 0 if expense_other>99999999995
replace 	expense_other 		= expense_other/xchange

*** Missing values analysis
mdesc		expense_stockup expense_wage expense_rent expense_electric /// 
			expense_transport


***** TOTAL EXPENSES
egen expense_total 				= rowtotal(expense_stockup expense_wage expense_rent ///
								expense_electric expense_transport)

replace expense_total 			=. if expense_total>500000

foreach var in expense_stockup expense_wage expense_rent expense_electric /// 
			expense_transport expense_other expense_total {
			
replace `var'=. if `var'==0
}

												
***** PROFITS ************************************************************


***** PROFITS LAST MONTH, SELF-REPORTED

gen prof_lastmth = f4_8_1

mdesc prof_lastmth

replace		prof_lastmth		=. if prof_lastmth>999999999996
replace 	prof_lastmth 		= prof_lastmth/xchange
//replace 	prof_lastmth 		=. if prof_lastmth>30000


***** PROFITS ON A NORM DAY, SELF-REPORTED

gen prof_nday = f4_8_4

mdesc prof_nday


replace		prof_nday			=. if prof_nday>999999999996
replace 	prof_nday 			= prof_nday/xchange
//replace prof_nday 			=. if prof_nday>1000


gen	prof_calc=prof_nday*f4_3_4*(365/84)
* Note: f4_3_4 is the # of days the shop is open in normal week 

replace prof_lastmth=prof_calc if prof_lastmth==prof_nday
*replace prof_lastmth=prof_calc if prof_lastmth==.
*replace prof_calc=prof_lastmth if prof_calc==.


***** PROFITS LAST MONTH, CALCULATED (from sales/expenses)
gen prof_est = sales_lastmth - expense_total


***** PROFITS FOR 30 NORM DAYS, CALCULATED FROM SALES ON 30 NORM DAYS (from 30-day sales and expenses)
gen prof_est2 = sales_calc - expense_total


***** PROFITS MTHLY COMPOSITES
gen prof_comp1 = (prof_lastmth + prof_calc)/2
gen prof_comp2 = (prof_lastmth + prof_est)/2
gen prof_comp3 = (prof_lastmth + prof_calc + prof_est)/3



***** DISPOSAL OF PRODUCTS

*** Dummy for weekly disposal
gen 	dispose_wk = f4_5_2a
replace dispose_wk = 0 if dispose_wk==3


*** Avg value of weekly disposal ************************************************ Data not available in EL2


***** STOCK-UP BEHAVIOUR FOR TOP3 PRODUCTS

*** Stock-up schedule
* Dummy for fixed stock-up schedule for ANY top3 prod
gen 	stockup_fixschedule = 1 if (f4_5_4_1==3 | f4_5_4_1==4) ///
									| (f4_5_4_2==3 | f4_5_4_2==4) ///
									| (f4_5_4_3==3 | f4_5_4_3==4)
replace stockup_fixschedule = 0 if stockup_fixschedule==.
//tab 	stockup_top3_fix_any

* Dummy for stocking-up only when already out of stock for ANY top3 prod
gen 	stockup_late = 1 if f4_5_4_1==1 | f4_5_4_2==1 | f4_5_4_3==1
replace stockup_late = 0 if stockup_late==.
gen stockup_neverlate= 1 - stockup_late


*** Out-of-stock frequency

* Dummy Never out of stock when customer asks 
gen 	stockout_never = 1 if f4_5_7_1==0 | f4_5_7_2==0 | f4_5_7_3==0
replace stockout_never = 0 if stockout==.

egen stockup_comp=rowmean(stockup_neverlate stockout_never)


***** INVENTORY CHANGES

* Dummy for inventory change due to demand change
gen inventory_change_demand = (f4_7_26a==1)

* Dummy for inventory change according to shelfspace
gen inventory_change_space = (f4_7_26b==1)

* Dummy for inventory change due to change in supplier price
gen inventory_change_price = (f4_7_26c==1)

* Dummy for inventory change according to profit earned
gen inventory_change_prof = (f4_7_26d==1)


***** INTRO OF NEW PRODS

* Detect missing values in asset var --> 0 obs
mdesc 	f4_7_27
* Product introduction last 12 mth
* (Not clear whether extreme values are mistakes)
//tab 	f4_7_27
gen 	prods_new = f4_7_27
replace prods_new=10 if prods_new>10
* Dummy for having introduced any new product in the past 12 mth
gen 	prods_new_1 = 1 if f4_7_27>0
replace prods_new_1 = 0 if prods_new_1==.
* Dummy for having introduced at least 5 new products
gen 	prods_new_5 = 1 if f4_7_27>4
replace prods_new_5 = 0 if prods_new_5==.



************************************************************************
***** EMPLOYEES ********************************************************


gen labour_total = f4_44_a + f4_44_a2 + f4_44_b + f4_44_b2

gen labour_fam = f4_44_a + f4_44_a2

gen labour_nonfam = f4_44_b + f4_44_b2

gen labour_fam_full = f4_44_a

gen labour_fam_part = f4_44_a2

gen labour_nonfam_full = f4_44_b

gen labour_nonfam_part = f4_44_b2
						
											
							
								
************************************************************************
*** BUSINESS RECORDS AND PROFIT CALCS ************************************


***** BUSINESS RECORDS

*** Content of records ********************************************************** Data not available for EL2

*** Kind of records

* Detect missing values in asset var --> 0 obs
mdesc 	f4_7_1b

* Only 6 businesses keep electronic records
//tab 	f4_7_1b

* Dummy for electronic record-keeping or ledger book
gen 	rec_ledger = 1 if f4_7_1b==5 | f4_7_1b==6
replace rec_ledger = 0 if rec_ledger==.

* Dummy for receipt collection only
gen 	rec_receipts = 1 if f4_7_1b==2 | f4_7_1b==3
replace rec_receipts = 0 if rec_receipts==.

* Dummy for no records whatsoever
gen 	rec_none = 1 if f4_7_1b==0
replace rec_none = 0 if rec_none==.


*** Frequency of updating records

* Dummy for daily updating
gen 	rec_day = 1 if f4_7_1c==7
replace rec_day = 0 if rec_day==.

* Dummy for weekly updating
gen 	rec_weekly = 1 if f4_7_1c==7 | f4_7_1c==6 | f4_7_1c==5 
replace rec_weekly = 0 if rec_weekly==.



***** PROFIT CALCULATIONS ******************************************************* Data not available for EL2


************************************************************************
*** MCKENZIE & WOODRUFF (2015) *****************************************

***** SINGLE PRACTICES

* M1 -- Visited competitor, see prices
gen 	MWM1_visitcompetprice = f4_7_17
replace MWM1_visitcompetprice = 0 if MWM1_visitcompetprice==3

* M2 -- Visited competitor, see products
gen 	MWM2_visitcompetprod = f4_7_18
replace MWM2_visitcompetprod = 0 if MWM2_visitcompetprod==3

* M3 -- Asked customers, wishes for new products
gen 	MWM3_askcustomprod = f4_7_28
replace MWM3_askcustomprod = 0 if MWM3_askcustomprod==3

* M4 -- Talked to former customer, why quit buying
gen 	MWM4_askcustomquit = f4_7_29
replace MWM4_askcustomquit = 0 if MWM4_askcustomquit==3

* M5 -- Asked supplier, well-selling products
gen 	MWM5_asksupplprod = f4_7_19
replace MWM5_asksupplprod = 0 if MWM5_asksupplprod==3

* M6 -- Attracted customer w special offer
gen 	MWM6_attrcustomdisc = f4_7_21
replace MWM6_attrcustomdisc = 0 if MWM6_attrcustomdisc==3

* M7 -- Advertised
gen 	MWM7_advert = f4_7_24
replace MWM7_advert = 0 if MWM7_advert==3

* B1 -- Negotiated w supplier, lower price
gen 	MWB1_negosupplprice = f4_7_31
replace MWB1_negosupplprice = 0 if MWB1_negosupplprice==3

* B2 -- Compared supplier, quality/quantity of products
gen 	MWB2_compsupplprod = f4_7_32
replace MWB2_compsupplprod = 0 if MWB2_compsupplprod==3

* B3 -- Did not run out of stock
gen 	MWB3_notOOS = f4_7_33
replace MWB3_notOOS = 0 if MWB3_notOOS==3

* R1 -- Kept written business records
gen 	MWR1_recwritten = f4_7_1a
replace MWR1_recwritten = 0 if MWR1_recwritten==3

* R2 -- Recorded every purchase and sale
gen 	MWR2_recpurchsale = f4_7_1d
replace MWR2_recpurchsale = 0 if MWR2_recpurchsale==3

* R3 -- Can use records, see cash on hand
gen 	MWR3_recliquid = f4_7_1g
replace MWR3_recliquid = 0 if MWR3_recliquid==3

* R4 -- Uses records, check sales of particular prod
gen 	MWR4_recsalesprods = f4_7_1h
replace MWR4_recsalesprods = 0 if MWR4_recsalesprods==3

* R5 -- Works out cost to business of main prods ******************************** Data not available for EL2

* R6 -- Knows prods w most profit per item selling
gen 	MWR6_profprods = f4_7_3
replace MWR6_profprods = 0 if MWR6_profprods==3

* R7 -- Written monthly expenses budget
gen 	MWR7_recexpensemth = f4_7_4
replace MWR7_recexpensemth = 0 if MWR7_recexpensemth==3

* R8 -- Can use records, pay back hypothetical loan
gen 	MWR8_recloan = f4_7_1i
replace MWR8_recloan = 0 if MWR8_recloan==3

* F1 -- Reviews and analyses fin perform
gen 	MWF1_finperform = f4_7_7a
replace MWF1_finperform = 0 if MWF1_finperform==3

* F2 -- Sets sales target over next year
gen 	MWF2_settargetyr = f4_7_8
replace MWF2_settargetyr = 0 if MWF2_settargetyr==3

* F3 -- Compares target with sales at least monthly
gen 	MWF3_comptargetmth = f4_7_9a
replace MWF3_comptargetmth = 0 if MWF3_comptargetmth==3

* F4 -- Cost budget, next yr
gen 	MWF4_expensenextyr = f4_7_10
replace MWF4_expensenextyr = 0 if MWF4_expensenextyr==3

* F5 -- Annual profit and loss statement
gen 	MWF5_proflossyr = f4_7_11
replace MWF5_proflossyr = 0 if MWF5_proflossyr==3

* F6 -- Annual cash-flow statement
gen 	MWF6_cashflowyr = f4_7_12
replace MWF6_cashflowyr = 0 if MWF6_cashflowyr==3

* F7 -- Annual balance sheet
gen 	MWF7_balanceyr = f4_7_13
replace MWF7_balanceyr = 0 if MWF7_balanceyr==3

* F8 -- Annual income and expenditure sheet
gen 	MWF8_incexpenseyr = f4_7_14
replace MWF8_incexpenseyr = 0 if MWF8_incexpenseyr==3


* Define idk's ("8") as missing values
foreach x of varlist MW* {
   replace `x' =.  if inlist(`x',7,8)
   }


***** COMP SCORE

egen MW_score_total = rowmean(MWM2_visitcompetprod ///
	MWM3_askcustomprod MWM4_askcustomquit MWM5_asksupplprod MWM6_attrcustomdisc ///
	MWM7_advert MWB1_negosupplprice MWB2_compsupplprod MWB3_notOOS MWR1_recwritten ///
	MWR2_recpurchsale MWR3_recliquid MWR4_recsalesprods /*MWR5_costprods*/ ///
	MWR6_profprods MWR7_recexpensemth MWR8_recloan MWF1_finperform ///
	MWF2_settargetyr MWF3_comptargetmth MWF4_expensenextyr MWF5_proflossyr ///
	MWF6_cashflowyr MWF7_balanceyr MWF8_incexpenseyr)
	
* Marketing sub-score
egen MW_M_score_total 	= rowmean(MWM2_visitcompetprod MWM3_askcustomprod ///
							MWM4_askcustomquit MWM5_asksupplprod ///
							MWM6_attrcustomdisc MWM7_advert)
* Stock sub-score
egen MW_B_score_total 	= rowmean(MWB1_negosupplprice MWB2_compsupplprod MWB3_notOOS)

* Record sub-score
egen MW_R_score_total 	= rowmean(MWR1_recwritten MWR2_recpurchsale ///
							MWR3_recliquid MWR4_recsalesprods /*MWR5_costprods*/ ///
							MWR6_profprods MWR7_recexpensemth MWR8_recloan ///
							MWF1_finperform)
* Planning sub-score
egen MW_F_score_total 	= rowmean(MWF1_finperform MWF2_settargetyr ///
							MWF3_comptargetmth MWF4_expensenextyr MWF5_proflossyr ///
							MWF6_cashflowyr MWF7_balanceyr MWF8_incexpenseyr)




************************************************************************
*** OTHER BUSINESS PRACTICES *******************************************

***** SEPARATION OF PRIVATE AND BUSINESS FIN

gen 	separatefin = 1 if f4_7_6==1
replace separatefin = 0 if separatefin==.


***** SALES TARGETS
* Dummy for target set for sales over next year: MWF2_settargetyr
* Dummy for comparing sales target to sales at least monthly: MWF3_comptargetmth


***** COMPARING SALES PERFORMANCE TO COMPETITORS

gen 	compsales_compet = 1 if f4_7_16==1
replace compsales_compet = 0 if compsales_compet==.


***** PRICE CHANGES															
													
* Generate dummy variables for each level of f4_7_19a
gen 	f4_7_19a_A 	= 1 if inlist(f4_7_19a, "A","AB","ABC","ABCD","ABCDE","ABCE","ABD","ABDE","ABE") ///
					| inlist(f4_7_19a,"AC","ACD","ACDE","ACE") ///
					| inlist(f4_7_19a,"AD","ADE") ///
					| inlist(f4_7_19a,"AE")
replace f4_7_19a_A	= 0 if missing(f4_7_19a_A)
order 	f4_7_19a_A, a(f4_7_19a)

gen		f4_7_19a_B	= 1 if inlist(f4_7_19a, "AB","ABC","ABCD","ABCDE","ABCE","ABD","ABDE","ABE") ///
					| inlist(f4_7_19a, "B","BC","BCD","BCDE","BD","BE")
replace f4_7_19a_B	= 0 if missing(f4_7_19a_B)
order	f4_7_19a_B, a(f4_7_19a_A)

gen		f4_7_19a_C	= 1 if inlist(f4_7_19a, "ABC","ABCD","ABCDE","ABCE","AC","ACD","ACDE","ACE") ///
					| inlist(f4_7_19a, "BC","BCD","BCDE","C","CD","CDE","CE")
replace f4_7_19a_C	= 0 if missing(f4_7_19a_C)
order	f4_7_19a_C, a(f4_7_19a_B)

gen		f4_7_19a_D	= 1 if inlist(f4_7_19a, "ABCD","ABCDE","ABD","ABDE","ACD","ACDE","AD","ADE") ///
					| inlist(f4_7_19a, "BCD","BCDE","BD","CD","CDE","D","DE")
replace f4_7_19a_D	= 0 if missing(f4_7_19a_D)
order	f4_7_19a_D, a(f4_7_19a_C)

gen		f4_7_19a_E	= 1 if inlist(f4_7_19a, "ABCDE","ABCE","ABDE","ABE","ACDE","ACE","ADE","AE") ///
					| inlist(f4_7_19a, "BCDE","BE","CDE","CE","DE","E")
replace f4_7_19a_E	= 0 if missing(f4_7_19a_E)
order	f4_7_19a_E, a(f4_7_19a_D)

* Dummy for price change due to competitor's price
gen 	price_change_comp = 1 if f4_7_19a_A==1
replace price_change_comp = 0 if price_change_comp==.
* Dummy for price change due to demand change
gen 	price_change_demand = 1 if f4_7_19a_B==1
replace price_change_demand = 0 if price_change_demand==.
* Dummy for discount given (loyal customer, bulk, product in need to be sold)
gen 	discount 		= 1 if f4_7_19a_C==1 | f4_7_19a_D==1 | f4_7_19a_E==1
replace discount 		= 0 if discount==.
gen		discount_bulk	= 1 if f4_7_19a_C==1
replace discount_bulk 	= 0 if discount_bulk==.
gen 	discount_loyal 	= 1 if f4_7_19a_D==1
replace discount_loyal	= 0 if discount_loyal==.


***** TRADE CREDIT

* Detect missing values in asset var --> 0, 184
mdesc 	f4_7_30a f4_7_30b
* Dummy for providing trade credit -> Onlh 184 businesses do not accept delayed payment
gen 	credit_TC = 1 if f4_7_30a==1
replace credit_TC = 0 if credit_TC==.
* Dummy for demanding interest -> Only 54 buinesses demand interest
gen 	credit_TC_int = 1 if f4_7_30b==1
replace credit_TC_int = 0 if credit_TC_int==.



**************************************************************************
*** PRACTICES (TO BE) IMPLEMENTED IN LAST/NEXT 12 MTH ****************


***** PRACTICES LAST YR

*** Cut costs
gen 	cutcosts_lastyr = 1 if f4_7_15a1==1
replace cutcosts_lastyr = 0 if cutcosts_lastyr==.

*** Work with new supplier
gen 	changesupplier_lastyr = 1 if f4_7_15a2==1
replace changesupplier_lastyr = 0 if changesupplier_lastyr==.

*** Buy higher qual prod
gen 	prodquality_lastyr = 1 if f4_7_15a3==1
replace prodquality_lastyr = 0 if prodquality_lastyr==.

*** Introduce new brand
gen 	newbrand_lastyr = 1 if f4_7_15a4==1
replace newbrand_lastyr = 0 if newbrand_lastyr==.

*** Open new business
gen 	newbranch_lastyr = 1 if f4_7_15a5==1
replace newbranch_lastyr = 0 if newbranch_lastyr==.

*** Delegate more tasks to employees
gen 	delegate_lastyr = 1 if f4_7_15a6==1
replace delegate_lastyr = 0 if delegate_lastyr==.

*** Develop business plan
gen 	bisplan_lastyr = 1 if f4_7_15a7==1
replace bisplan_lastyr = 0 if bisplan_lastyr==.

*** Start/improve records
gen 	startrec_lastyr = 1 if f4_7_15a8==1
replace startrec_lastyr = 0 if startrec_lastyr==.

*** Loan
gen 	loan_lastyr = 1 if f4_7_15a9==1
replace loan_lastyr = 0 if loan_lastyr==.

*** Coop with competitor
gen 	coopcompet_lastyr = 1 if f4_7_15a10==1
replace coopcompet_lastyr = 0 if coopcompet_lastyr==.

*** VAT number
gen 	vat_lastyr = 1 if f4_7_15a11==1
replace vat_lastyr = 0 if vat_lastyr==.


*** Pract next year ********************************************************** Data not available in EL2
*/

*************************************************************************
*** DISCUSSION AND DECISION-MAKING **************************************


***** DISCUSSION W OTHERS

*** In general
gen 	discuss_any = 1 if f4_7_35a==1
replace discuss_any = 0 if discuss_any==.

*** W specific people
gen discuss_fam = (f4_7_35a2==8)
gen discuss_friend = (f4_7_35a2==7)
gen discuss_bisfriend = (f4_7_35a2==6)
gen discuss_supplier = (f4_7_35a2==4)


***** JOINT DECISION-MAKING W OTHERS

*** In general
gen 	jointdec_any = 1 if f4_7_36a==1
replace jointdec_any = 0 if jointdec_any==.

* Dummy for joint decision-making w informal agreement
gen 	jointdec_agree = 1 if f4_7_36a==1 & f4_7_36e==1
replace jointdec_agree = 0 if jointdec_agree==.


*** W specific people ************************************************************* Data not available in EL2



************************************************************************
***** LOANS AND FINANCES ***********************************************


* Generate loan vars
gen 	loan_applied 			= (f4_9_1>0) & (f4_9_1!=.)
gen 	loan_outstanding 		= (f4_9_2>0) & (f4_9_2!=.)
gen 	loan_amt 				= f4_9_8/xchange
replace loan_amt 				= 0 if loan_amt==.



*** Vars for financial literacy ************************************************ Data not available for EL2


***** Savings ****************************************************************** Data not available for EL2


***** Investment **************************************************************** Data not avaialble in EL2


************************************************************************
***** ASPIRATIONS ******************************************************



***** "IDEAL" ASPIRATIONS (SELF-CHOSEN TIME HORIZON) *******************


***** Imagination failure
gen imagine_fail = (f4_10_01a==3)
label var imagine_fail "Imagination failure (yes/no)"


***** Size
* Aspirations
gen asp_size = f4_10_01b
label var asp_size "Aspirations for ideal business size"

extremes size asp_size shop_ID
replace asp_size=121 if shop_ID==2190

* Gap
gen aspgap_size = (asp_size - size) / size
label var aspgap_size "Aspirations gap for ideal business size (norm'ed by current level)"


* Cleaning
extremes aspgap_size asp_size size shop_ID

replace asp_size=. if asp_size==0
replace aspgap_size=. if aspgap_size==-1

replace aspgap_size=5 if aspgap_size>5
replace asp_size=(1+aspgap_size)*size if aspgap_size==5

* Gap2
gen aspgap_size2= (asp_size - size) / asp_size
label var aspgap_size2 "Aspirations gap for ideal business size (norm'ed by aspiration level)"


***** Employees

* Aspirations
gen asp_employee = f4_10_01c
label var asp_employee "Aspirations for ideal number of employees"

extremes labour_total asp_employee shop_ID

* Gap
gen aspgap_employee = (asp_employee - labour_total) / labour_total
label var aspgap_employee "Aspirations gap for ideal number of employees (norm'ed by current level)"

* Cleaning
extremes aspgap_employee asp_employee labour_total shop_ID

replace aspgap_employee=5 if aspgap_employee>5 
replace asp_employee=(1+aspgap_employee)*labour_total if aspgap_employee==5

* Gap2
gen aspgap_employee2 = (asp_employee - labour_total) / asp_employee
label var aspgap_employee2 "Aspirations gap for ideal number of employees (norm'ed by aspiration level)"


***** Customers

* Aspirations
gen asp_customer = f4_10_01d
replace asp_customer =. if f4_10_01d>=9995
label var asp_customer "Aspirations for ideal number of customers"

extremes custom_total asp_customer shop_ID

* Gap
gen aspgap_customer = (asp_customer - custom_total) / custom_total
label var aspgap_customer "Aspirations gap for ideal number of customers (norm'ed by current level)"

* Cleaning
extremes aspgap_customer asp_customer custom_total shop_ID

replace asp_customer=. if asp_customer==0
replace aspgap_customer=. if aspgap_customer==-1

replace aspgap_customer=5 if aspgap_customer>5 
replace asp_customer=(1+aspgap_customer)*custom_total if aspgap_customer==5

* Gap2
gen aspgap_customer2 = (asp_customer - custom_total) / asp_customer
label var aspgap_customer2 "Aspirations gap for ideal number of customers (norm'ed by aspiration level)"


*** Dummies for negative, positive, 0 gaps

foreach x of varlist aspgap_* {
	gen `x'_neg = (`x'<0)
	gen `x'_zero = (`x'==0)
	gen `x'_zeroneg = (`x'<0) | (`x'==0)
	gen `x'_pos = (`x'>0) & (`x'!=.)
	}

	
*** Aspiration Z-score composites

foreach x of varlist asp_* aspgap_* {
	egen `x'_mu = mean(`x')
	egen `x'_sd = sd(`x')
	gen `x'_z = (`x' - `x'_mu)/ `x'_sd
	}

egen asp_shop_z = rowmean(asp_size_z asp_employee_z asp_customer_z)

gen aspgap_shop_z = (aspgap_size_z + aspgap_employee_z + aspgap_customer_z)/3	
gen aspgap_shop = (aspgap_size + aspgap_employee + aspgap_customer)/3	

gen aspgap_shop2_z = (aspgap_size2_z + aspgap_employee2_z + aspgap_customer2_z)/3	
gen aspgap_shop2 = (aspgap_size2 + aspgap_employee2 + aspgap_customer2)/3	


*** AM/BM scores

foreach x of varlist asp_shop_z asp_size asp_employee asp_customer {
	egen `x'_md = median(`x')
	gen `x'_AM = (`x'>`x'_md) if !missing(`x')
	gen `x'_BM = (`x'<=`x'_md)
	}


***** Aspirations horizon

gen asp_yrs = f4_10_01e
replace asp_yrs =. if asp_yrs>9995 | asp_yrs==0
label var asp_yrs "Aspirations horizon for ideal business (years)"

* Median
egen asp_yrs_md = median(asp_yrs)

* Dk dummy (imagination failure proxy)
gen asp_yrs_fail = (f4_10_01e>=9995)
label var asp_yrs_fail "Planning failure (yes/no)"



***** 12 MTH ASPIRATIONS ****************************************************


***** Size

* Aspirations
gen asp12_size = f4_10_02a
label var asp12_size "12mth aspirations for business size"

extremes size asp12_size shop_ID
replace asp_size=121 if shop_ID==2190

* Gap
gen aspgap12_size = (asp12_size - size) / size
label var aspgap12_size "12mth aspirations gap for business size (norm'ed by current level)"

* Cleaning
extremes aspgap12_size asp12_size size shop_ID

replace asp12_size=. if asp12_size==0
replace aspgap12_size=. if aspgap12_size==-1

replace aspgap12_size=5 if aspgap12_size>5 
replace asp12_size=(1+aspgap12_size)*size if aspgap12_size==5

* Gap2
gen aspgap12_size2 = (asp12_size - size) / asp12_size
label var aspgap12_size2 "12mth aspirations gap for business size (norm'ed by aspiration level)"


***** Employees

* Aspirations
gen asp12_employee = f4_10_02b
label var asp12_employee "12mth aspirations for number of employees"

extremes labour_total asp12_employee shop_ID

* Gap
gen aspgap12_employee = (asp12_employee - labour_total) / labour_total
label var aspgap12_employee "12mth aspirations gap for number of employees (norm'ed by current level)"

* Cleaning
extremes aspgap12_employee asp12_employee labour_total shop_ID

replace aspgap12_employee=5 if aspgap12_employee>5 
replace asp12_employee=(1+aspgap12_employee)*labour_total if aspgap12_employee==5

* Gap2
gen aspgap12_employee2 = (asp12_employee - labour_total) / asp12_employee
label var aspgap12_employee2 "12mth aspirations gap for number of employees (norm'ed by aspiration level)"


***** Customers

* Aspirations
gen asp12_customer = f4_10_02c
replace asp12_customer =. if f4_10_02c>=9995
label var asp12_customer "12mth aspirations for number of customers"

extremes custom_total asp12_customer shop_ID

* Gap
gen aspgap12_customer = (asp12_customer - custom_total) / custom_total
label var aspgap12_customer "12mth aspirations gap for number of customers (norm'ed by current level)"

* Cleaning
extremes aspgap12_customer asp12_customer custom_total shop_ID

replace asp12_customer=. if asp12_customer==0
replace aspgap12_customer=. if aspgap12_customer==-1

replace aspgap12_customer=5 if aspgap12_customer>5 
replace asp12_customer=(1+aspgap12_customer)*custom_total if aspgap12_customer==5

* Gap2
gen aspgap12_customer2 = (asp12_customer - custom_total) / asp12_customer
label var aspgap12_customer2 "12mth aspirations gap for number of customers (norm'ed by aspiration level)"


*** Dummies for negative, positive, 0 gaps

foreach x of varlist aspgap12_* {
	gen `x'_neg = (`x'<0)
	gen `x'_zero = (`x'==0)
	gen `x'_zeroneg = (`x'<0) | (`x'==0)
	gen `x'_pos = (`x'>0) & (`x'!=.)
	}

	
***** Sales

* Aspirations
gen asp12_sales = f4_10_3c
replace asp12_sales =. if asp12_sales>999999999996
replace asp12_sales = asp12_sales/xchange
label var asp12_sales "12mth aspirations for daily sales (USD PPP)"

extremes sales_nday asp12_sales shop_ID 
replace asp12_sales =. if asp12_sales>25000
//replace sales_nday=. if sales_nday>25000	

* Gap
gen aspgap12_sales = (asp12_sales - sales_nday) / sales_nday
label var aspgap12_sales "12mth aspirations gap for daily sales (norm'ed by current level)"

* Cleaning
extremes aspgap12_sales asp12_sales sales_nday shop_ID

replace asp12_sales=. if aspgap12_sales<0
replace aspgap12_sales=. if aspgap12_sales<0

replace aspgap12_sales=5 if aspgap12_sales>5 & aspgap12_sales!=. 
replace asp12_sales=(1+aspgap12_sales)*sales_nday if aspgap12_sales==5

* Gap 2
gen aspgap12_sales2 = (asp12_sales - sales_nday) / asp12_sales
label var aspgap12_sales2 "12mth aspirations gap for daily sales (norm'ed by aspiration level)"


*** Aspiration Z-score composites

foreach x of varlist asp12_* aspgap12_* {
	egen `x'_mu = mean(`x')
	egen `x'_sd = sd(`x')
	gen `x'_z = (`x' - `x'_mu)/ `x'_sd
	}	

egen asp12_shop_z = rowmean(asp12_size_z asp12_employee_z asp12_customer_z asp12_sales_z)
label var asp12_shop_z "12mth shop aspirations (z score)"
egen aspgap12_shop_z = rowmean(aspgap12_size_z aspgap12_employee_z aspgap12_customer_z aspgap12_sales_z)
label var aspgap12_shop_z "12mth shop aspirations gap (z score)"


*** AM/BM scores

foreach x of varlist asp12_shop_z asp12_sales asp12_size asp12_employee asp12_customer {
	egen `x'_md = median(`x')
	gen `x'_AM = (`x'>`x'_md) if !missing(`x')
	gen `x'_BM = 1 - `x'_AM
	}

	
**Sales aspirations follow-ups

*** Importance
gen asp_import = f4_10_3d
replace asp_import =. if asp_import==8 | asp_import==7
label var asp_import "Importance to reach aspired sales in 12 mth"

*** Probability
gen asp_prob = f4_10_3e
replace asp_prob =. if asp_prob==7 | asp_prob==8
label var asp_prob "Subj likelihood to reach aspired sales in 12 mth"

*** Self-efficacy
gen asp_seff = f4_10_3f
replace asp_seff =. if asp_seff==7 | asp_seff==8
label var asp_seff "Self-efficacy to reach aspired sales in 12 mth"

*** LOC
gen asp_loc = f4_10_3g
replace asp_loc =. if asp_loc==7 | asp_loc==8
label var asp_loc "Locus of control to reach aspired sales in 12 mth"

*** CSE
gen asp_cse = (asp_loc+asp_seff)/2
label var asp_cse "Perceived agency (self-efficacy and LOC)"


foreach x of varlist asp_import asp_prob asp_seff asp_loc {
* Dummy for high importance
gen `x'_sales_highest = (`x'==6)
gen `x'_sales_high = (`x'==6) | (`x'==5)

* Scaled to 0-1
replace `x' = `x'/6

* AM/BM
egen `x'_md	= median(`x')
gen `x'_AM 	= (`x' > `x'_md)
gen `x'_BM	= (`x' <= `x'_md)
}	




*** Interaction terms


foreach x in asp12_sales aspgap12_sales asp12_shop_z aspgap12_shop_z {

gen `x'_prob = `x' * asp_prob

gen `x'_loc = `x' * asp_loc

gen `x'_seff = `x' * asp_seff

gen `x'_cse = `x' * asp_cse

}

label var asp12_sales_prob "12mth sales aspirations weighted by perceived likelihood"

label var asp12_sales_loc "12mth sales aspirations weighted by perceived locus of control"

label var asp12_sales_cse "12mth sales aspirations weighted by perceived agency"

label var asp12_shop_z_prob "12mth shop aspirations weighted by perceived likelihood"

label var asp12_shop_z_loc "12mth shop aspirations weighted by perceived locus of control"

label var asp12_shop_z_cse "12mth sales aspirations weighted by perceived agency"



***** 18 MONTHS ASPIRATIONS ****************************************************


***** Profits

*** Minimum profits for survival
gen asp_minprof = f4_10_3ba
replace asp_minprof = asp_minprof/xchange
replace asp_minprof=. if asp_minprof>=250
label var asp_minprof "Minimum income requirements (USD PPP)"

* Minimum profits normalised by current profits (proportion)
gen aspgap_minprof = asp_minprof/prof_nday

replace aspgap_minprof=. if aspgap_minprof>1

* Aspirations
gen asp18_prof = f4_10_3ha
replace asp18_prof = asp18_prof/xchange
replace asp18_prof=. if asp18_prof>=5000
label var asp18_prof "18mth aspirations for daily profits"

extremes prof_nday asp18_prof shop_ID

* Gap
gen aspgap18_prof = (asp18_prof - prof_nday) / prof_nday
label var aspgap18_prof "18mth aspirations gap for daily profits (norm'ed by current level)"

* Cleaning
extremes aspgap18_prof asp18_prof prof_nday shop_ID

replace asp18_prof=. if aspgap18_prof<0
replace aspgap18_prof=. if aspgap18_prof<0

replace aspgap18_prof=5 if aspgap18_prof>5 & aspgap18_prof!=. 
replace asp18_prof=(1+aspgap18_prof)*prof_nday if aspgap18_prof==5

* Gap2
gen aspgap18_prof2 = (asp18_prof - prof_nday) / asp18_prof
label var aspgap18_prof2 "18mth aspirations gap for daily profits (norm'ed by aspiration level)"


*** Dummies for negative, positive, and 0 gaps

foreach x of varlist aspgap12_sales aspgap18_prof aspgap12_sales2 aspgap18_prof2 {
	gen `x'_neg = (`x'<0)
	gen `x'_zero = (`x'==0)
	gen `x'_zeroneg = (`x'<0) | (`x'==0)
	gen `x'_pos = (`x'>0) & (`x'!=.)
	}



*************************************************************************
***** SATISFACTION ******************************************************

gen	satisfact_life		= f4_13a_01
mdesc satisfact_life
replace satisfact_life=. if f4_13a_01>10

gen	satisfact_fin		= f4_13a_02
mdesc satisfact_fin
replace satisfact_fin=. if f4_13a_02>10

* AM/BM dummies

foreach x in 	satisfact_life satisfact_fin {

				egen `x'_md	= median(`x')
				gen `x'_AM 	= (`x'>`x'_md) if !missing(`x')
				gen `x'_BM 	= (`x'<=`x'_md)
	
}

label var satisfact_life	"Satisfaction with Life (0-10 Scale)"
label var satisfact_fin		"Satisfaction with Household Finances (0-10 Scale)"


********************************************************************************
***** PRACTICES (OPEN QUESTIONS) ***********************************************

***** 3 practices to improve profits

gen practices_free_score = 6
foreach x of varlist	f4_10_6ax1 f4_10_6ax2 f4_10_6ax3{
						replace practices_free_score = practices_free_score-1 ///
						if `x'== "" | `x'== "A03" | `x'== "B14" | ///
						`x'== "B15" | `x'== "B17" | `x'== "B18" | `x'== "B19" | `x'== "D12" | ///
						`x'== "Z95" | `x'== "Z96"
}
				
	
foreach x of varlist f4_10_6a_z95_*_ot {
	replace practices_free_score = practices_free_score-1 if `x'=="BERDOA" | `x'=="DOA"

	}
	
	

*** 3 most profitable practices, done last year & planned for next year
mdesc f4_10_6b f4_10_6c

gen 	practices_free_lastyr = f4_10_6b
replace practices_free_lastyr = 0 if f4_10_6b==3
replace practices_free_lastyr =. if practices_free_lastyr==7 | practices_free_lastyr==8

gen 	practices_free_nextyr = f4_10_6c
replace practices_free_nextyr = 0 if f4_10_6c==3
replace practices_free_nextyr =. if practices_free_nextyr==7 | practices_free_nextyr==8



***** MENTAL MODELS OF RETURNS TO ADOPTION ************************************** Data not available in EL2


*************************************************************************
***** INTERVIEWER IMPRESSIONS *******************************************



gen shop_sign_bright = f4_16_05
replace shop_sign_bright = 0 if shop_sign_bright==2


gen shop_sign 			= f4_16_04
gen shop_goods_prices	= f4_16_06
gen shop_goods_display 	= f4_16_07
gen shop_shelf_full 	= f4_16_08
gen shop_advert 		= f4_16_09
gen shop_clean 			= f4_16_10
gen shop_bright 		= f4_16_11

foreach x of varlist shop_* {
	replace `x'= 0  if `x'==3
	}
	

_crcslbl shop_sign 				f4_16_04
_crcslbl shop_sign_bright 		f4_16_05
_crcslbl shop_goods_prices 		f4_16_06
_crcslbl shop_goods_display 		f4_16_07
_crcslbl shop_shelf_full 		f4_16_08
_crcslbl shop_advert 			f4_16_09
_crcslbl shop_clean 				f4_16_10
_crcslbl shop_bright 			f4_16_11


********************************************************************************
***** VAR MANAGEMENT

* Drop original vars
drop f4_* cspro_id *_md


* Add prefix to identify endline vars after merge
ds shop_ID, not
foreach x in `r(varlist)' {
	rename `x' W4_`x'
}

* Order vars
order shop_ID


********************************************************************************
***** SAVE DATA


save "Data\Endline 2 Data\W4_clean_data.dta", replace
