
********************************************************************************
************** 		RETAILERS INDONESIA PROJECT, 2016-2018 		****************
*
*
*				 Data management do-file for endline 1 data
*
*				
********************************************************************************
 

clear all
set more off

*cd "`c(pwd)'\"

use "Data\Endline Data\EL_raw_data.dta", clear




/****** OVERVIEW ***************************************************************

1. GENERAL									~70

2. MANAGER CHARACTERISTICS 					~90
	
3. FIRM CHARACTERISTICS						~440

4. SALES									~910

5. EXPENSES									~1110

6. PROFITS									~1280

7. PRODUCTS AND SERVICES					~1460

8. EMPLOYEES								~2100

9. PRODUCTIVITY								~2230

10. BUSINESS RECORDS AND PROFIT CALCS		~2270

11. MCKENZIE & WOODRUFF (2015)				~2390

12. OTHER BUSINESS PRACTICES				~2680

13. DISCUSSION AND DECISION-MAKING 			~2980

14. LOANS AND FINANCES						~3280

15. ASPIRATIONS								~3340

16. SATISFACTION							~4090

17. MENTAL MODEL							~4110

18. INTERVIEWER IMPRESSIONS					~4130		

19. Own business-practices composite score	~*/



************************************************************************
***** GENERAL **********************************************************


***** UNFINISHED INTERVIEWS
***** Drop all but fully finished interviews --> 1,186 obs (120 missing obs)

//tab 		f4_17_01
mdesc 		f4_17_01
rename 		f4_17_01 interview_result

gen finished = 0
replace finished = (interview_result==1)

gen closed = 0
replace closed = (interview_result==4)

gen refused = 0
replace refused = inlist(interview_result, 2, 3, 7)


***** EXCHANGE RATE
* All sales/expenses/profits data converted to USD PPP with IDR 4052.20 = USD 1			// Lukman's note: In the BL do-file, it was "IDR 4060.46 = USD 1". But after checking the WB data, it's now 4052.20 = USD 1
* from WB data, 2016:  http://data.worldbank.org/indicator/PA.NUS.PPP
gen 		xchange = 4052.20

* ID
* Destring
destring	endsrid, replace
gen			shop_ID = endsrid

														// Lukman's note: We agreed to not ask for GPS in endline
*** COORDINATES


*** DELETING ATTRITERS
keep if finished==1


**************************************************************************
***** MANAGER CHARACTERISTICS ********************************************


***** AGE
gen			age_manager = 2017 - f4_2_4b_yr
destring 	age_manager, replace ignore(".")

* Detect missing values in both age vars --> 0 obs
//tab			age_manager
mdesc		age_manager

* Median manager age
egen		age_manager_md = median(age_manager)

* Dummy for being above median age
gen			age_manager_abvmd = 1 if age_manager>age_manager_md
replace 	age_manager_abvmd = 0 if age_manager_abvmd==.


***** GENDER
gen 		male 	= f4_2_4a
gen 		female 	= 1 - male

* Detect missing values in both gender vars --> 0 obs
//tab			male
mdesc		male

* Recoding "no" answers
replace 	male = 0 if male==3


***** OFFSPRING

* Detect missing values in offspring var
* 343, 794, 1051, 329, 826, 1069 obs
mdesc 		f4_10_4a1_age f4_10_4a2_age f4_10_4a3_age f4_10_5a1_age f4_10_5a2_age f4_10_5a3_age 

* Dummy for having children
//tab 		f4_10_4a1_age
//tab 		f4_10_5a1_age
gen 		kids_1	= 1 if f4_10_4a1_age!=0 | f4_10_5a1_age!=0
replace 	kids_1	= 0 if f4_10_4a1_age==. & f4_10_5a1_age==.
mdesc 		kids_1

* Dummy for having at least 3 children
gen 		kids_3 = 1 if (f4_10_4a1_age!=. & f4_10_4a2_age!=. & f4_10_4a3_age!=.) ///
						| (f4_10_4a1_age!=. & f4_10_4a2_age!=. & f4_10_5a1_age!=.) ///
						| (f4_10_4a1_age!=. & f4_10_5a1_age!=. & f4_10_5a2_age!=.) ///
						| (f4_10_5a1_age!=. & f4_10_5a2_age!=. & f4_10_5a3_age!=.)
replace 	kids_3 = 0 if kids_3==.
//tab 		kids_3

* Dummy for having at least 1 child under 7 (age of primary school entry)
gen 		kids_young_1 = 1 if f4_10_4a1_age<7 | f4_10_4a2_age<7 | f4_10_4a3_age<7 | ///
								f4_10_5a1_age<7 | f4_10_5a2_age<7 | f4_10_5a3_age<7
replace 	kids_young_1 = 0 if kids_young_1==.


***** EDUCATION

* Detect missing values in both education vars --> 0 obs
//tab			f4_2_4d
mdesc		f4_2_4d

gen educ = f4_2_4d

* Create dummies for finished secondary educ and BA degree
gen 		educ_second = 1 if f4_2_4d >= 12
replace 	educ_second = 0 if educ_second==.

gen 		educ_terc = 1 	if f4_2_4d >= 16
replace 	educ_terc = 0 	if educ_terc==.


***** MOTIVATION TO MANAGE FIRM														// Lukman's note: Agreed to remove for endline

	
***** DIGITSPAN (STM & WM, INTELLIGENCE)											// Lukman's note: Agreed to remove for endline


***** TRUST																			// Lukman's note: Agreed to remove for endline


***** WORKING AND THINKING STYLE SCALE
*** Missing values treatment
* Detect missing values in working and thinking style items --> 0 obs
mdesc		f4_12_01 f4_12_02 f4_12_03 f4_12_04 f4_12_05 f4_12_06 f4_12_07 ///
			f4_12_08 f4_12_09 f4_12_10
	
* Detect idk's and refused answers --> 0 obs
//tab 		f4_12_01 
//tab 		f4_12_02
//tab 		f4_12_03
//tab 		f4_12_04
//tab 		f4_12_05
//tab 		f4_12_06
//tab 		f4_12_07
//tab 		f4_12_08
//tab 		f4_12_09
//tab 		f4_12_10

*** Generate scale items
gen			cogstyle_system_01 = f4_12_01
gen			cogstyle_intuit_02 = f4_12_02
gen 		cogstyle_intuit_03 = f4_12_03
gen 		cogstyle_system_04 = f4_12_04
gen 		cogstyle_system_05 = f4_12_05
gen 		cogstyle_intuit_06 = f4_12_06
gen 		cogstyle_system_07 = f4_12_07
gen 		cogstyle_intuit_08 = f4_12_08
gen 		cogstyle_system_09 = f4_12_09
gen 		cogstyle_intuit_10 = f4_12_10

*** Systematic-thinking score
* Create var for total answers given
gen 		cogstyle_system_answers = 0
foreach 	x of varlist cogstyle_system_* {
   replace 	cogstyle_system_answers = cogstyle_system_answers+1  if `x'<.
   }

* Score
egen 		cogstyle_system = rowtotal(cogstyle_system_01 ///
			cogstyle_system_04 cogstyle_system_05 cogstyle_system_07 ///
			cogstyle_system_09)

* Percentage score
gen 		cogstyle_system_perc = cogstyle_system/cogstyle_system_answers

* Above median score
egen 		cogstyle_system_md		= median(cogstyle_system)
gen 		cogstyle_system_abvmd 	= 1 if cogstyle_system > cogstyle_system_md
replace 	cogstyle_system_abvmd 	= 0 if cogstyle_system_abvmd ==.

*** Intuitive-thinking score
* Create var for total answers given
gen 		cogstyle_intuit_answers = 0
foreach 	x of varlist cogstyle_intuit_* {
   replace 	cogstyle_intuit_answers = cogstyle_intuit_answers+1  if `x'<.
   }

* Score
egen 		cogstyle_intuit = rowtotal(cogstyle_intuit_02 ///
			cogstyle_intuit_03 cogstyle_intuit_06 cogstyle_intuit_08 ///
			cogstyle_intuit_10)

* Percentage score
gen 		cogstyle_intuit_perc = cogstyle_intuit/cogstyle_intuit_answers

*** Relative systematic-thinking score (as per Sagiv 2014, p. 11)

foreach var in	cogstyle_intuit_02 cogstyle_intuit_03 cogstyle_intuit_06 ///
				cogstyle_intuit_08 cogstyle_intuit_10 {
				
				gen `var'_rev = 0
				replace `var'_rev = 5 if `var'==1
				replace `var'_rev = 4 if `var'==2
				replace `var'_rev = 3 if `var'==3
				replace `var'_rev = 2 if `var'==4
				replace `var'_rev = 1 if `var'==5
}

egen cogstyle_intuit_rev = rowtotal(cogstyle_*_rev)
gen cogstyle_rel = cogstyle_intuit_rev + cogstyle_system
gen cogstyle_rel_perc = cogstyle_rel/100
label var cogstyle_rel_perc "Systematic working style (% score)"

* Above-median rel score
egen cogstyle_rel_md = median(cogstyle_rel)
gen cogstyle_rel_abvmd = 1 if cogstyle_rel>cogstyle_rel_md
replace cogstyle_rel_abvmd = 0 if cogstyle_rel_abvmd==.
* Above-p80 rel score
egen cogstyle_rel_p80 = pctile(cogstyle_rel), p(80)
gen cogstyle_rel_abv80 = 1 if cogstyle_rel>cogstyle_rel_p80
replace cogstyle_rel_abv80 = 0 if cogstyle_rel_abv80==.

//tab 		cogstyle_system
//tab 		cogstyle_intuit
//tab 		cogstyle_rel
//tab 		cogstyle_rel_abvmd		// md	==	1.2
//tab 		cogstyle_rel_abv80	// p80	==	1.47

_crcslbl 	cogstyle_system_01 f4_12_01
_crcslbl 	cogstyle_intuit_02 f4_12_02
_crcslbl 	cogstyle_intuit_03 f4_12_03
_crcslbl 	cogstyle_system_04 f4_12_04
_crcslbl 	cogstyle_system_05 f4_12_05
_crcslbl 	cogstyle_intuit_06 f4_12_06
_crcslbl 	cogstyle_system_07 f4_12_07
_crcslbl 	cogstyle_intuit_08 f4_12_08
_crcslbl 	cogstyle_system_09 f4_12_09
_crcslbl 	cogstyle_intuit_10 f4_12_10


***** TIME PREFERENCES 																// Lukman's note: Agreed to remove for endline


***** RISK PREFERENCES																// Lukman's note: Agreed to remove for endline

	

************************************************************************
***** FIRM CHARACTERISTICS *********************************************


***** FORMALITY

* Detect missing values in licences vars --> 0 obs
mdesc 		f4_9_12a f4_9_12b f4_9_12c

* Idk's, etc. as missing values
//tab 		f4_9_12a	// 1 idk
//tab 		f4_9_12b	// 3 idk
//tab 		f4_9_12c	// 3 idk
levelsof 	f4_9_12b

* Company reg certificate (TDP)
gen 		formal_reg = f4_9_12a
label var 	formal_reg "Do you own a company registration certificate?"
label val 	formal_reg f4_9_12a

* Tax identification no
gen 		formal_tax = f4_9_12b
label var	formal_tax "Business Has Tax ID (Yes=1)"
label val	formal_tax f4_9_12b

* VAT collection no
gen 		formal_vat = f4_9_12c
label var 	formal_vat "Do you own a VAT collection no?"
label val 	formal_vat f4_9_12c

* Only 2 businesses have all certificates and nos
count if 	formal_reg==1 & formal_tax==1 & formal_vat==1

* Define idk's ("8") as missing values
foreach x of varlist formal_* {
   replace `x' =.  if `x'==8
   replace `x' = 0 if `x'==3
   }

//tab 		formal_reg
//tab 		formal_tax
//tab 		formal_vat

egen formal_firm=rowmax(formal_reg formal_tax formal_vat)


***** FIRM AGE																		// Lukman's note: Agreed to remove for endline


***** SPACE

*** Total space
* Detect missing values in firm space var --> 0 obs
mdesc 		f4_3_7a f4_10_01aa

* Dummies for businesses up to 6, between 6 and 10, and above 10 sqm from categorical variable
//tab 		f4_3_7a

gen 		space_micro = 1 if f4_3_7a==1
replace 	space_micro = 0 if space_micro==.

gen 		space_small = 1 if f4_3_7a==2
replace 	space_small = 0 if space_small==.

gen 		space_mid	= 1 if f4_3_7a==3
replace 	space_mid	= 0 if space_mid==.

//tab 		space_micro
//tab 		space_small
//tab 		space_mid

* Dummies for businesses up to 6, between 6 and 10, and above 10 sqm from continuous variable (aspirations)
//tab 		f4_10_01aa

gen 		space_cont_micro = 1 if f4_10_01aa>0 & f4_10_01aa<=6
replace 	space_cont_micro = 0 if space_cont_micro==.

gen 		space_cont_small = 1 if f4_10_01aa>6 & f4_10_01aa<=10
replace 	space_cont_small = 0 if space_cont_small==.

gen 		space_cont_mid	 = 1 if f4_10_01aa>10
replace 	space_cont_mid 	 = 0 if space_cont_mid==.

* Consistency between categorical and continuous variables --> 180 inconsistencies
count if 	space_micro==1 & space_cont_micro!=1 ///
			| space_micro==0 & space_cont_micro!=0 ///
			| space_small==1 & space_cont_small!=1 ///
			| space_small==0 & space_cont_small!=0 ///
			| space_mid==1 & space_cont_mid!=1 ///
			| space_mid==0 & space_cont_mid!=0 

* Ordinal variable for businesses of up to 6 (1), between 6 and 10 (2), and above 10 (3) sqm
gen 		space_ord = 1 if f4_10_01aa>0 & f4_10_01aa<=6
replace 	space_ord = 2 if f4_10_01aa>6 & f4_10_01aa<=10
replace 	space_ord = 3 if f4_10_01aa>10

* Storage space (percentage)
gen 		space_store = f4_3_7b

* Detect missing values in storage space var --> 0 obs
//tab 		f4_3_7b
mdesc 		f4_3_7b

* Dummy for dedicated storage space
gen 		space_store_yes = 1 if space_store>0 & space_store!=.
replace 	space_store_yes = 0 if space_store_yes==.
//tab 		space_store_yes


*** Occupany status

* Detect missing values in occupancy status var --> 0 obs
//tab			f4_3_6
mdesc		f4_3_6

* Dummies for space owned, rented, and used without payment
gen 		space_own = 1 if f4_3_6==1
replace 	space_own = 0 if space_own==.

gen 		space_rent = 1 if f4_3_6==2
replace 	space_rent = 0 if space_rent==.

gen 		space_use = 1 if f4_3_6==3
replace 	space_use = 0 if space_use==.

//tab 		space_own
//tab 		space_rent
//tab 		space_use


***** OPENING HOURS 

* Hours opened incl and net of closing time for prayer/food/etc.)
* Both in normal season and in fasting month

*** NORMAL SEASON

*** Generate vars for opening hours

* Total opening hours
gen 		open 		= (f4_3_5_endhr + f4_3_5_endmin/60) - (f4_3_5_beghr + f4_3_5_begmin/60)

* Opening hours per person
gen 		open_pp 		= open/(f4_44_a+1)				// Household members work in shop

* Net opening hours
gen 		open_break 	= (f4_3_5a_hr + f4_3_5a_min/60)
gen 		open_net 	= open - open_break
//tab 		open_break
count if 	open_net<4

* Net opening hours per person (owner + business partners)
gen 		open_net_pp 			= open_net/(f4_44_a+1)	// Lukman's note: in BL it's f4_4_3_b3. I use f4_44_a because it' the endline's equivalent

* Detect missing values in opening hours var --> 0 obs
//tab 		open
//tab 		open_net
mdesc 		open open_net

* Dummy for break time below median
egen 		open_break_md 		= median(open_break) // 			md==2.5
gen 		open_break_blwmd 	= 1 if open_break<open_break_md
replace 	open_break_blwmd 	= 0 if open_break_blwmd==.
//tab 		open_break_md

* Dummy for opening hours above median and 80th perc

* Median
egen 		open_md 			= median(open) // md==15
gen 		open_abvmd 		= 1 if open>open_md
replace 	open_abvmd 		= 0 if open_abvmd==.

* p80
egen 		open_p80 		= pctile(open), p(80) // p80==17
gen 		open_abv80 		= 1 if open>open_p80
replace 	open_abv80 		= 0 if open_abv80==.
sum 		open_p80

* Dummy for NET opening hours above median and in 80th percentile

* Median
egen 		open_net_md 		= median(open_net) // md==12
gen 		open_net_abvmd 	= 1 if open_net>open_net_md
replace 	open_net_abvmd 	= 0 if open_net_abvmd==.

* 80th perc
egen 		open_net_p80 	= pctile(open_net), p(80) // p80==14.17
gen 		open_net_abv80 	= 1 if open_net>open_net_p80
replace 	open_net_abv80 	= 0 if open_net_abv80==.

//tab 		open
//tab 		open_break
//tab 		open_abvmd
//tab 		open_net_abvmd
//tab 		open_net_abv80


*** RAMADAN

* Shop close during tarawih prayer --> 612 closed during tarawih, 494 not closed, 47 do not observe tarawih (not a Muslim) 
//tab 		f4_38_cx

* Shop re-open after tarawih prayer --> 347 shop re-open after tarawih
//tab 		f4_38_c_bx 
gen			open_break_tarawih 	= (f4_38_c_b_hr+f4_38_c_b_min/60)-(f4_38_c_a_hr+f4_38_c_a_min/60)

* Total opening hour
gen			open_fast			= (f4_38b_hr+f4_38b_min/60)-(f4_38a_hr+f4_38a_min/60)

* Opening hours per person
gen			open_fast_pp			= open_fast/(f4_44_a+1)

* Net opening hours
gen			open_fast_break		= (f4_3_5a_hr + f4_3_5a_min/60)
gen			open_fast_net		= open_fast - open_fast_break - open_break_tarawih
//tab			open_fast_break
//tab			open_fast_net

* Net opening hours per person (owner + business partners)
gen 		open_fast_net_pp 	= open_fast_net/(f4_44_a+1)

* Detect missing values in opening hours var --> 0 obs
//tab 		open_fast
//tab 		open_fast_net
mdesc 		open open_fast_net

* Dummy for break time below median
egen 		open_fast_break_md 		= median(open_fast_break) // md==2.5
gen 		open_fast_break_blwmd 	= 1 if open_fast_break<open_fast_break_md
replace 	open_fast_break_blwmd 	= 0 if open_fast_break_blwmd==.
//tab 		open_fast_break_md

* Dummy for opening hours above median and 80th perc
* Median
egen 		open_fast_md 			= median(open_fast) // md==13
gen 		open_fast_abvmd 			= 1 if open_fast>open_fast_md
replace 	open_fast_abvmd 			= 0 if open_fast_abvmd==.

* p80
egen 		open_fast_p80 			= pctile(open_fast), p(80) // p80==16
gen 		open_fast_abv80 		= 1 if open_fast>open_fast_p80
replace 	open_fast_abv80 		= 0 if open_fast_abv80==.
sum 		open_fast_p80

* Dummy for NET opening hours above median and in 80th percentile
* Median
egen 		open_fast_net_md			= median(open_fast_net) // md==8.67
gen 		open_fast_net_abvmd 		= 1 if open_fast_net>open_fast_net_md
replace 	open_fast_net_abvmd 		= 0 if open_fast_net_abvmd==.

* 80th perc
egen 		open_fast_net_p80 		= pctile(open_fast_net), p(80) // p80==11.5
gen 		open_fast_net_abv80 	= 1 if open_fast_net>open_fast_net_p80
replace 	open_fast_net_abv80 	= 0 if open_fast_net_abv80==.

//tab 		open_fast
//tab 		open_fast_break
//tab 		open_fast_abvmd
//tab 		open_fast_net_abvmd
//tab 		open_fast_net_abv80


***** RELIGIOSITY


***** FLOODING

*** Perceived risk of being flooded in 2018
gen floodrisk_nextyr = f4_3_13
replace floodrisk_nextyr =. if f4_3_13==98
destring floodrisk_nextyr, replace

*** Dummy takes on 1 if flooded recently
gen flood_lastyr = 1 if f4_3_12_yr==2016 | f4_3_12_yr==2017
replace flood_lastyr = 0 if flood_lastyr==.
replace flood_lastyr =. if flood_lastyr==9998



***** CUSTOMERS

*** General and loyal customers (at least one purchase per week)
gen 		custom_general = f4_3_10b
gen 		custom_loyal = f4_3_10a

* Total customers
gen 		custom_total = custom_general+custom_loyal


* Treating extreme values in total customers as missing data --> 0 obs
replace 	custom_total =. if custom_total>=998
replace 	custom_general =. if custom_general>=998
replace 	custom_loyal =. if custom_loyal>=998


*** Avg purchase value per customer
gen 		custom_avgpurch = f4_3_11

* Detect missing values in purchase val per customer var --> 4 obs
//tab 		custom_avgpurch
mdesc 		custom_avgpurch

* Treating extreme value missing data --> 1 obs!
replace 	custom_avgpurch =. if custom_avgpurch>1500000

//tab 		custom_avgpurch

* Convert into dollars
replace custom_avgpurch = custom_avgpurch/xchange



***** ASSETS

*** Only 10 businesses own a pick-up

* Car dummy
* Detect missing values in asset var --> 0 obs
//tab 		f4_4_1ab
mdesc 		f4_4_1ab

* Dummy for availability of car

gen 		assets_car = 1 if f4_4_1ab>0
replace 	assets_car = 0 if assets_car==.

*** Scooter dummy
* Detect missing values in asset var --> 0 obs
//tab 		f4_4_1ad
mdesc 		f4_4_1ad

* Dummy for availability of scooter
gen 		assets_scooter = 1 if f4_4_1ad>0 
replace 	assets_scooter = 0 if assets_scooter==.

*** Fridge
* Detect missing values in asset var --> 0 obs
//tab 		f4_4_1ba
mdesc 		f4_4_1ba

* Dummy for no fridge (possible proxy for no perishables) and at least 2 fridges 
* (as investment in basic tech; 1 fridge often provided by large supplier)
gen 		assets_nofridge = 1 if f4_4_1ba==0
replace 	assets_nofridge = 0 if assets_nofridge==.

gen 		assets_fridges = 1 if f4_4_1ba>1
replace 	assets_fridges = 0 if assets_fridges==.


*** Only 15 businesses own either a computer or a laptop // Lukman's note: in BL, it was only 8

*** Landline
gen 		assets_landline = f4_4_1bg

* Detect missing values in asset var --> 0 obs
//tab 		landline
mdesc 		assets_landline

***** OTHER BUSINESSES
gen 		assets_otherfirm = f4_3_9



************************************************************************
***** SALES, EXPENSES, AND PROFIT ************************************************************


***** SALES LAST MONTH 

* All sales/expenses/profits data converted to USD PPP with IDR 4052.20 = USD 1
* from WB data, 2015:  http://data.worldbank.org/indicator/PA.NUS.PPP
gen 		sales_lastmth = f4_8_2

*** Missing vars analysis
* Detect missing values in sales vars --> 0 obs
mdesc 		sales_lastmth

* Treatment of extreme values as missing --> 1 obs
replace 	sales_lastmth 		= sales_lastmth/xchange
replace 	sales_lastmth 		=. if sales_lastmth>500000


***** SALES ON A NORM DAY (+ln sales, +ln sales winsorised at p95)

* All sales/expenses/profits data converted to USD PPP with IDR 4052.20 = USD 1
* from WB data, 2015:  http://data.worldbank.org/indicator/PA.NUS.PPP
gen sales_nday = f4_8_5

*** Missing vars analysis
* Detect missing values in sales vars --> 0 obs
mdesc 		sales_nday

* Treatment of extreme values as missing --> 0 obs
replace 	sales_nday = sales_nday/xchange
replace 	sales_nday =. if sales_nday>17500

*gen sales_calc=sales_nday*30
gen	sales_calc=sales_nday*f4_3_4*(365/84)
* Note: f4_3_4 is the # of days the shop is open in normal week 

replace sales_lastmth=sales_calc if sales_lastmth==sales_nday
*replace sales_lastmth=sales_calc if sales_lastmth==.


***** SALES ON A NORM DAY, CALCULATED FROM TOP 3 PRODUCTS

*** Daily sales for each top 3 product 
* All sales/expenses/profits data converted to USD PPP with IDR 4052.20 = USD 1
* from WB data, 2015:  http://data.worldbank.org/indicator/PA.NUS.PPP
gen prod1 = f4_5_1_b1
gen prod2 = f4_5_1_b2
gen prod3 = f4_5_1_b3

* Treatment of zero and extreme values as missing values
replace prod1 =. if f4_5_1_b1>999999999995
replace prod1 = prod1/xchange

replace prod2 =. if f4_5_1_b2>999999999995
replace prod2 = prod2/xchange

replace prod3 =. if f4_5_1_b3>999999999995
replace prod3 = prod3/xchange

*** Total daily sales from top 3 products
egen sales_nday_top3 = rowtotal(prod1 prod2 prod3)
gen sales_top3=sales_nday_top3*30

* Dummy for top3 prod share above p80
egen sales_nday_top3_p80 = pctile(sales_nday_top3), p(80)
gen sales_nday_top3_abvp80 = 1 if sales_nday_top3>sales_nday_top3_p80
replace sales_nday_top3_abvp80 = 0 if sales_nday_top3_abvp80==.


***** SALES MTHLY COMPOSITE

*** Comp score w both self-reported and calc vars
gen 		sales_comp1 = (sales_lastmth + sales_calc)/2
gen 		sales_comp2 = (sales_lastmth + sales_calc + sales_top3)/3
gen 		sales_comp3 = (sales_lastmth + sales_nday*30 + sales_top3)/3



************************************************************************
***** EXPENSES *********************************************************

* All expense data converted to USD PPP with IDR 4052.20 = USD 1
* from WB data, 2015:  http://data.worldbank.org/indicator/PA.NUS.PPP


***** STOCK-UP COSTS
gen 		expense_stockup = f4_8_3a

* Treatment of extreme values as missing --> 3 obs
//tab 		expense_stockup
replace 	expense_stockup =.	if f4_8_3a>999999999995
//replace		expense_stockup = 0 if f4_8_3a==.
replace 	expense_stockup = 	expense_stockup/xchange


***** SALARIES AND BENEFITS
gen 		expense_wage = f4_8_3b

* No extreme values detected														
//tab 		expense_wage
// replace		expense_wage = 0 if f4_8_3b==.
replace 	expense_wage = expense_wage/xchange

***** RENT AND FEES
gen 		expense_rent = f4_8_3c

* Treatment of extreme value as missing --> 0 obs
//tab 		expense_rent
replace 	expense_rent =.	if f4_8_3c>999999999995
//replace		expense_rent = 0 if f4_8_3c==.
replace 	expense_rent = 	expense_rent/xchange

***** ELECTRICITY AND UTILITIES
gen 		expense_electric = f4_8_3d

* Treatment of extreme values as missing --> 15 obs
//tab 		expense_electric
replace 	expense_electric =.	if f4_8_3d>999999999995
//replace		expense_electric = 0 if f4_8_3d==.
replace 	expense_electric = 	expense_electric/xchange

***** TRANSPORTATION COSTS
gen 		expense_transport = f4_8_3e

* Treatment of extreme values as missing --> 7 obs
//tab 		expense_transport
replace 	expense_transport =. if f4_8_3e>999999999995
//replace		expense_transport = 0 if f4_8_3e==.
replace 	expense_transport =  expense_transport/xchange

***** TAXES
gen 		expense_tax = f4_8_3f

* Treatment of extreme values as missing --> 1 obs
//tab 		expense_tax
replace 	expense_tax =.	if f4_8_3f>999999999995
//replace		expense_tax = 0 if f4_8_3f==.
replace 	expense_tax =	expense_tax/xchange

***** COMMUNICATION
gen 		expense_phone = f4_8_3g

* Treatment of extreme values as missing --> 2 obs
//tab 		expense_phone 
replace 	expense_phone =.	if f4_8_3g>999999999995
//replace		expense_phone = 0 if f4_8_3g==.
replace 	expense_phone = 	expense_phone/xchange

***** MARKETING
gen 		expense_advert = f4_8_3h

* No extreme values detected
//tab 		expense_advert	
//replace		expense_advert = 0 if f4_8_3h==.
replace 	expense_advert = expense_advert/xchange


***** SECURITY

*** Preman (organised, local thugs)
gen 		expense_preman = f4_8_3i
* No extreme values detected
//replace		expense_preman = 0 if f4_8_3i==.
replace		expense_preman = expense_preman/xchange

*** Police
gen 		expense_police = f4_8_3j
* Treatment of extreme value as missing --> 0 obs
replace 	expense_police =. 	if f4_8_3j>999999999995
//replace		expense_police = 0 if f4_8_3j==.
replace 	expense_police = 	expense_police/xchange

*** Security
gen			security = expense_preman + expense_police

***** OTHER EXPENSES
gen 		expense_other = f4_8_3k
* No extreme values detected
replace 	expense_other = 0 if expense_other>99999999995
//replace		expense_other = 0 if f4_8_3k==.
replace 	expense_other = expense_other/xchange

*** Missing values analysis
* Detect missing values in expenses vars
mdesc		expense_stockup expense_wage expense_rent expense_electric /// 
			expense_transport expense_tax expense_phone expense_advert /// 
			expense_preman expense_police
			

***** TOTAL EXPENSES

egen expense_total = rowtotal(expense_stockup expense_wage expense_rent ///
						expense_electric expense_transport ///
						expense_tax expense_phone ///
						expense_advert expense_preman expense_police expense_other)

foreach var in expense_stockup expense_wage expense_rent expense_electric /// 
			expense_transport expense_tax expense_phone expense_advert /// 
			expense_preman expense_police expense_other expense_total {
			
replace `var'=. if `var'==0
}

												
												
***** PROFITS ************************************************************


***** PROFITS LAST MONTH, SELF-REPORTED

* All sales/expenses/profits data converted to USD PPP with IDR 4060.46 = USD 1
* from WB data, 2015:  http://data.worldbank.org/indicator/PA.NUS.PPP
gen prof_lastmth = f4_8_1

*** Missing vars analysis
* Detect missing values in profit vars --> none!
mdesc prof_lastmth
* Treatment of extreme values as missing --> 32 obs!
replace prof_lastmth = prof_lastmth/xchange

replace prof_lastmth =. if prof_lastmth>30000

*** Confidence 
gen confid_prof_lastmth = f4_8_1a
* Dummy for high confidence
gen confid_prof_lastmth_high = 0
replace confid_prof_lastmth_high = 1 if f4_8_1a== 4 | f4_8_1a==5


***** PROFITS ON A NORM DAY, SELF-REPORTED

gen prof_nday = f4_8_4
*** Missing vars analysis
* Detect missing values in profit vars --> none!
mdesc prof_nday

* Treatment of extreme values as missing --> 33 obs!
replace prof_nday = prof_nday/xchange
replace prof_nday =. if prof_nday>1000

*gen prof_calc=prof_nday*30
gen	prof_calc=prof_nday*f4_3_4*(365/84)
* Note: f4_3_4 is the # of days the shop is open in normal week 

replace prof_lastmth=prof_calc if prof_lastmth==prof_nday
*replace prof_lastmth=prof_calc if prof_lastmth==.
*replace prof_calc=prof_lastmth if prof_calc==.

***** PROFITS LAST MONTH, CALCULATED (from sales/expenses)

* Profits calculated from sales and expenses info
gen prof_est = sales_lastmth - expense_total


***** PROFITS FOR 30 NORM DAYS, CALCULATED FROM SALES ON 30 NORM DAYS (from 30-day sales and expenses)

gen prof_est2 = sales_calc - expense_total


***** PROFITS MTHLY COMPOSITE

gen prof_comp1 = (prof_lastmth + prof_calc)/2
gen prof_comp2 = (prof_lastmth + prof_est)/2
gen prof_comp3 = (prof_lastmth + prof_calc + prof_est)/3
gen prof_comp4 = (prof_lastmth + prof_nday*30)/2



***** DISPOSAL OF PRODUCTS

*** Dummy for weekly disposal
gen 	dispose_wk = f4_5_2a
replace dispose_wk = 0 if dispose_wk==3


*** Avg value of weekly disposal
gen 	dispose_wk_val = f4_5_2c
replace dispose_wk_val = 0 if dispose_wk==0
replace dispose_wk_val =. if dispose_wk_val>999998
replace dispose_wk_val=dispose_wk_val/xchange

*** Proportion of weekly disposal in sales (calculated from 7 norm days)
gen 	dispose_wk_propsales = dispose_wk_val/(sales_lastmth/(365/84))
gen 	dispose_wk_propsales2 = dispose_wk_val/(sales_nday*f4_3_4)



***** STOCK-UP BEHAVIOUR FOR TOP3 PRODUCTS

*** Stock-up schedule
* Dummy for fixed stock-up schedule for ANY top3 prod
gen 	stockup_fixschedule = 1 if (f4_5_4_1==3 | f4_5_4_1==4) ///
									| (f4_5_4_2==3 | f4_5_4_2==4) ///
									| (f4_5_4_3==3 | f4_5_4_3==4)
replace stockup_fixschedule = 0 if stockup_fixschedule==.
//tab 	stockup_top3_fix_any

* .. for all
gen 	stockup_fixschedule_all = 1 if (f4_5_4_1==3 | f4_5_4_1==4) ///
									& (f4_5_4_2==3 | f4_5_4_2==4) ///
									& (f4_5_4_3==3 | f4_5_4_3==4)
replace stockup_fixschedule_all = 0 if stockup_fixschedule_all==.

* Dummy for stocking-up only when already out of stock for ANY top3 prod
gen 	stockup_late = 1 if f4_5_4_1==1 | f4_5_4_2==1 | f4_5_4_3==1
replace stockup_late = 0 if stockup_late==.
gen stockup_neverlate= 1 - stockup_late

* Weekly stock-ups for all top 3
gen 	stockup_wklyall = 1 if (f4_5_6_1==0 | f4_5_6_1==1 | f4_5_6_1==2 | f4_5_6_1==3) ///
								& (f4_5_6_2==0 | f4_5_6_2==1 | f4_5_6_2==2 | f4_5_6_2==3) ///
								& (f4_5_6_3==0 | f4_5_6_3==1 | f4_5_6_3==2 | f4_5_6_3==3)
replace stockup_wklyall = 0 if stockup_wklyall==.

* .. daily
gen 	stockup_dayall = 1 if (f4_5_6_1==6 | f4_5_6_1==7) ///
										& (f4_5_6_2==6 | f4_5_6_2==7) ///
										& (f4_5_6_3==6 | f4_5_6_3==7)
replace stockup_dayall = 0 if stockup_dayall==.


*** Out-of-stock frequency

* Dummy Never out of stock when customer asks 
gen 	stockout_never = 1 if f4_5_7_1==0 | f4_5_7_2==0 | f4_5_7_3==0
replace stockout_never = 0 if stockout==.

egen stockup_comp=rowmean(stockup_neverlate stockout_never)

gen 	stockout_wklyall = 1 if (f4_5_7_1==5 | f4_5_7_1==6 | f4_5_7_1==7) ///
									& (f4_5_7_2==5 | f4_5_7_2==6 | f4_5_7_2==7) ///
									& (f4_5_7_3==5 | f4_5_7_3==6 | f4_5_7_3==7)
replace stockout_wklyall = 0 if stockout_wklyall==.


***** INVENTORY CHANGES

* Dummy for inventory change due to demand change
gen 	inventory_change_demand = 1 if f4_7_26a==1
replace inventory_change_demand = 0 if inventory_change_demand==.

* Dummy for inventory change according to shelfspace
gen 	inventory_change_space = 1 if f4_7_26b==1
replace inventory_change_space = 0 if inventory_change_space==.

* Dummy for inventory change according to profit earned
gen 	inventory_change_prof = 1 if f4_7_26d==1
replace inventory_change_prof = 0 if inventory_change_prof==.

* Dummy for inventory change due to change in supplier price
gen 	inventory_change_price = 1 if f4_7_26c==1
replace inventory_change_price = 0 if inventory_change_price==.


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


gen labour_total = f4_44_a+f4_44_b
gen labour_fam = f4_44_a
gen labour_nonfam = f4_44_b


*** Permanent family labour, full-time
gen 	labour_fam_full = f4_44_a if inlist(f4_45_b1,f4_45_b2,f4_45_b3,f4_45_b4 ///
							,f4_45_b5,f4_45_b6,f4_45_b7,f4_45_b8,f4_45_b9,f4_45_b10 ///
							,f4_45_b11,f4_45_b12, 1)

*** Permanent family labour, part-time
gen 	labour_fam_part 	= f4_44_a if inlist(f4_45_b1,f4_45_b2,f4_45_b3,f4_45_b4 ///
							,f4_45_b5,f4_45_b6,f4_45_b7,f4_45_b8,f4_45_b9,f4_45_b10 ///
							,f4_45_b11,f4_45_b12, 3)

*** Permanent outside labour, full-time (only 27)
gen 	labour_nonfam_full = f4_44_b if inlist(f4_46_b1,f4_46_b2,f4_46_b3 ///
								,f4_46_b4,f4_46_b5,f4_46_b6, 1)

*** Permanent outside labour, part-time (only 29)
gen 	labour_nonfam_part = f4_44_b if inlist(f4_46_b1,f4_46_b2,f4_46_b3 ///
								,f4_46_b4,f4_46_b5,f4_46_b6, 3)

egen labour_ft= rowtotal(labour_nonfam_full labour_fam_full), missing
egen labour_pt=rowtotal(labour_nonfam_part labour_fam_part), missing	

replace labour_ft=0 if labour_ft==.
replace labour_pt=0 if labour_pt==.							
											
								
								
************************************************************************
*** BUSINESS RECORDS AND PROFIT CALCS ************************************


***** BUSINESS RECORDS

*** Content of records

			* Prices of diff suppliers
//tab 		f4_7_1daa
gen 		rec_pricesuppliers = 1 if f4_7_1daa==1
replace 	rec_pricesuppliers = 0 if rec_pricesuppliers==.

* Prices of diff brands
//tab 		f4_7_1dab
gen 		rec_pricebrands = 1 if f4_7_1dab==1
replace 	rec_pricebrands = 0 if rec_pricebrands==.

* Product purchases
//tab 		f4_7_1dac
gen 		rec_stockup = 1 if f4_7_1dac==1
replace 	rec_stockup = 0 if rec_stockup==.

* Sales
//tab 		f4_7_1dad
gen 		rec_sales = 1 if f4_7_1dad==1
replace 	rec_sales = 0 if rec_sales==.

* Asset purchases
//tab 		f4_7_1dae
gen 		rec_assetpurch = 1 if f4_7_1dae==1
replace 	rec_assetpurch = 0 if rec_assetpurch==.

* Total stocks
//tab 		f4_7_1daf
gen 		rec_stocks = 1 if f4_7_1daf==1
replace 	rec_stocks = 0 if rec_stocks==.

* Outstanding payments to supliers
//tab 		f4_7_1dag
gen 		rec_accpaysupplier = 1 if f4_7_1dag==1
replace 	rec_accpaysupplier = 0 if rec_accpaysupplier==.

* Outstanding payments for loans/debts accrued
//tab 		f4_7_1dah
gen 		rec_accpayloan = 1 if f4_7_1dah==1
replace 	rec_accpayloan = 0 if rec_accpayloan==.

* Salary and other costs to the business
//tab 		f4_7_1dai // Only 19 businesses note salary payments
//tab 		f4_7_1daj
count if 	f4_7_1dai==1 & f4_7_1daj==0
gen 		rec_othercosts = 1 if f4_7_1daj==1 // Combined var of "any costs excl. new prods"
replace 	rec_othercosts = 0 if rec_othercosts==.

* Outstanding payments of customers
//tab			f4_7_1dak
gen 		rec_accreccustom = 1 if f4_7_1dak==1
replace 	rec_accreccustom = 0 if rec_accreccustom==.

* Outstanding payments of customers when shop gives trade credit
gen 		rec_accreccustom_TC = 1 if f4_7_1dak==1 & f4_7_30a==1
replace 	rec_accreccustom_TC = 0 if rec_accreccustom_TC==.

* Outstanding payments of fam members
//tab 		f4_7_1dal
gen 		rec_accrecfam = 1 if f4_7_1dal==1
replace 	rec_accrecfam = 0 if rec_accrecfam==.



*rec_pricesuppliers rec_pricebrands rec_stockup rec_sales rec_assetpurch rec_stocks rec_accpaysupplier rec_othercosts rec_accreccustom_TC rec_accrecfam


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

* .. twice weekly
gen rec_twicewkly = 1 if f4_7_1c==7 | f4_7_1c==6
replace rec_twicewkly = 0 if rec_twicewkly==.


***** PROFIT CALCULATIONS

* Detect missing values in asset var --> 0, 680, 680
mdesc 	f4_7_5a f4_7_5c f4_7_5b


*** Kind of profit calculation

* Dummy for profit calculation with definition up to respondent
//tab 	f4_7_5a
gen 	profcalc_any = 1 if f4_7_5a==1
replace profcalc_any = 0 if profcalc_any==.

* Dummy for profit calculation accounting for all costs 
* --> only 45 businesses account for all costs!
//tab 	f4_7_5c
gen 	profcalc_allcosts = 1 if f4_7_5c==4
replace profcalc_allcosts = 0 if profcalc_allcosts==.

* Dummy for supposed profit calculation accounting  for NO COSTS whatsoever
gen profcalc_nocosts = 1 if f4_7_5c==1
replace profcalc_nocosts = 0 if profcalc_nocosts==.


*** Frequency of profit calculations

* Dummies for profit calculations (whichever way defined) daily/at least weekly
//tab 	f4_7_5b
gen 	profcalc_any_day 	= 1 if f4_7_5b==7
replace profcalc_any_day 	= 0 if profcalc_any_day==.
gen 	profcalc_any_wk 	= 1 if f4_7_5b==5 | f4_7_5b==6 | f4_7_5b==7
replace profcalc_any_wk 	= 0 if profcalc_any_wk==.


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

* R5 -- Works out cost to business of main prods
gen 	MWR5_costprods = f4_7_2
replace MWR5_costprods = 0 if MWR5_costprods==3

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
   replace `x' =.  if `x'==8
   }


***** COMP SCORE

egen MW_score_total = rowmean(MWM2_visitcompetprod ///
	MWM3_askcustomprod MWM4_askcustomquit MWM5_asksupplprod MWM6_attrcustomdisc ///
	MWM7_advert MWB1_negosupplprice MWB2_compsupplprod MWB3_notOOS MWR1_recwritten ///
	MWR2_recpurchsale MWR3_recliquid MWR4_recsalesprods MWR5_costprods ///
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
							MWR3_recliquid MWR4_recsalesprods MWR5_costprods ///
							MWR6_profprods MWR7_recexpensemth MWR8_recloan ///
							MWF1_finperform)
* Planning sub-score
egen MW_F_score_total 	= rowmean(MWF1_finperform MWF2_settargetyr ///
							MWF3_comptargetmth MWF4_expensenextyr MWF5_proflossyr ///
							MWF6_cashflowyr MWF7_balanceyr MWF8_incexpenseyr)




************************************************************************
*** OTHER BUSINESS PRACTICES *******************************************

***** SEPARATION OF PRIVATE AND BUSINESS FIN

* Detect missing values in asset var --> 0 obs
mdesc 	f4_7_6
* Dummy for having separate finances
//tab 	f4_7_6
gen 	separatefin = 1 if f4_7_6==1
replace separatefin = 0 if separatefin==.


***** SALES TARGETS

* Dummy for target set for sales over next year MWF2_settargetyr

* Dummy for comparing sales target to sales at least monthly MWF3_comptargetmth

* Frequency of comparing sales target to sales --> 823 missing values!				// Lukman's note: I don't understand this context in BL
* Var not clearly defined. SM seems to have asked f4_7_9b conditional on 
* f4_7_9a==1, which is wrong considering the answering options 0, 1, and 2. 
* More confusing even still, there are 30 instances of respondents answering 1 or 2.
mdesc f4_7_9b 
count if MWF3_comptargetmth==0 & f4_7_9b==.


***** COMPARING SALES PERFORMANCE TO COMPETITORS

* Detect missing values in asset var --> 0 obs
mdesc 	f4_7_16
* Dummy for comparing sales performance --> 1 idk's, 6 N/A
//tab 	f4_7_16
gen 	compsales_compet = 1 if f4_7_16==1
replace compsales_compet = 0 if compsales_compet==.


***** PRICE CHANGES															
													
* Generate dummy variables for each f4_7_19a_*
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

* Detect missing values in asset var --> 0 obs
mdesc 	f4_7_19a f4_7_19a_A f4_7_19a_B f4_7_19a_C f4_7_19a_D f4_7_19a_E
//tab 	f4_7_19a 

* Dummy for price change due to competitor's price
//tab 	f4_7_19a_A
gen 	price_change_comp = 1 if f4_7_19a_A==1
replace price_change_comp = 0 if price_change_comp==.
* Dummy for price change due to demand change
//tab 	f4_7_19a_B
gen 	price_change_demand = 1 if f4_7_19a_B==1
replace price_change_demand = 0 if price_change_demand==.
* Dummy for discount given (loyal customer, bulk, product in need to be sold)
//tab 	f4_7_19a_C
//tab 	f4_7_19a_D
//tab 	f4_7_19a_E
gen 	discount 		= 1 if f4_7_19a_C==1 | f4_7_19a_D==1 | f4_7_19a_E==1
replace discount 		= 0 if discount==.
gen		discount_bulk	= 1 if f4_7_19a_C==1
replace discount_bulk 	= 0 if discount_bulk==.
gen 	discount_loyal 	= 1 if f4_7_19a_D==1
replace discount_loyal	= 0 if discount_loyal==.

//tab 	price_change_comp
//tab 	price_change_demand
//tab 	discount
//tab 	discount_bulk
//tab 	discount_loyal 




***** TRADE CREDIT

* Detect missing values in asset var --> 0, 184
mdesc 	f4_7_30a f4_7_30b
* Dummy for providing trade credit -> Onlh 184 businesses do not accept delayed payment
//tab 	f4_7_30a
gen 	credit_TC = 1 if f4_7_30a==1
replace credit_TC = 0 if credit_TC==.
* Dummy for demanding interest -> Only 54 buinesses demand interest
//tab 	f4_7_30b
gen 	credit_TC_int = 1 if f4_7_30b==1
replace credit_TC_int = 0 if credit_TC_int==.

//tab 	credit_TC
//tab 	credit_TC_int


**************************************************************************
*** PRACTICES (TO BE) IMPLEMENTED IN LAST/NEXT 12 MTH ********************

***** PRACTICES

* Detect missing values in asset var --> 0 obs
mdesc f4_7_16 f4_7_15a1 f4_7_15b1 f4_7_15a2 f4_7_15b2 f4_7_15a3 f4_7_15b3 ///
f4_7_15a4 f4_7_15b4 f4_7_15a5 f4_7_15b5 f4_7_15a6 f4_7_15b6 f4_7_15a7 ///
f4_7_15b7 f4_7_15a8 f4_7_15b8 f4_7_15a9 f4_7_15b9 f4_7_15a10 f4_7_15b10 ///
f4_7_15a11 f4_7_15b11

*** Cut costs
//tab 	f4_7_15a1
//tab 	f4_7_15b1 // 11 idk's (as missing values)
gen 	cutcosts_lastyr = 1 if f4_7_15a1==1
replace cutcosts_lastyr = 0 if cutcosts_lastyr==.
gen 	cutcosts_nextyr = 1 if f4_7_15b1==1
replace cutcosts_nextyr = 0 if cutcosts_nextyr==.

*** Work with new supplier
//tab 	f4_7_15a2
//tab 	f4_7_15b2 // 12 idk's, (as missing values)
gen 	changesupplier_lastyr = 1 if f4_7_15a2==1
replace changesupplier_lastyr = 0 if changesupplier_lastyr==.
gen 	changesupplier_nextyr = 1 if f4_7_15b2==1
replace changesupplier_nextyr = 0 if changesupplier_nextyr==.

*** Buy higher qual prod
//tab 	f4_7_15a3 // 1 N/A
//tab 	f4_7_15b3 // 3 idk's (as missing values)
gen 	prodquality_lastyr = 1 if f4_7_15a3==1
replace prodquality_lastyr = 0 if prodquality_lastyr==.
gen 	prodquality_nextyr = 1 if f4_7_15b3==1
replace prodquality_nextyr = 0 if prodquality_nextyr==.

*** Introduce new brand
//tab 	f4_7_15a4 // 1 N/A (as missing values)
//tab 	f4_7_15b4 // 13 idk's (as missing values)
gen 	newbrand_lastyr = 1 if f4_7_15a4==1
replace newbrand_lastyr = 0 if newbrand_lastyr==.
gen 	newbrand_nextyr = 1 if f4_7_15b4==1
replace newbrand_nextyr = 0 if newbrand_nextyr==.

*** Open new business
//tab 	f4_7_15a5 // 96 businesses opened new branch in last 12 mth!
//tab 	f4_7_15b5 // 5 idk's (as missing values)
gen 	newbranch_lastyr = 1 if f4_7_15a5==1
replace newbranch_lastyr = 0 if newbranch_lastyr==.
gen 	newbranch_nextyr = 1 if f4_7_15b5==1
replace newbranch_nextyr = 0 if newbranch_nextyr==.

*** Delegate more tasks to employees
//tab 	f4_7_15a6 // 47 "N/A"? (as missing values)
//tab 	f4_7_15b6 // 1 idk's, 37 "N/A"? (as missing values)
gen 	delegate_lastyr = 1 if f4_7_15a6==1
replace delegate_lastyr = 0 if delegate_lastyr==.
gen 	delegate_nextyr = 1 if f4_7_15b6==1
replace delegate_nextyr = 0 if delegate_nextyr==.

*** Develop business plan
//tab 	f4_7_15a7
//tab 	f4_7_15b7 // 1 reject, 4 idk's (as missing values)
gen 	bisplan_lastyr = 1 if f4_7_15a7==1
replace bisplan_lastyr = 0 if bisplan_lastyr==.
gen 	bisplan_nextyr = 1 if f4_7_15b7==1
replace bisplan_nextyr = 0 if bisplan_nextyr==.

*** Start/improve records
//tab 	f4_7_15a8 // 1 N/A
//tab 	f4_7_15b8 // 5 idk's (as missing values)
gen 	startrec_lastyr = 1 if f4_7_15a8==1
replace startrec_lastyr = 0 if startrec_lastyr==.
gen 	startrec_nextyr = 1 if f4_7_15b8==1
replace startrec_nextyr = 0 if startrec_nextyr==.

*** Loan
//tab 	f4_7_15a9
//tab 	f4_7_15b9 // 6 idk's (as missing values)
gen 	loan_lastyr = 1 if f4_7_15a9==1
replace loan_lastyr = 0 if loan_lastyr==.
gen 	loan_nextyr = 1 if f4_7_15b9==1
replace loan_nextyr = 0 if loan_nextyr==.

*** Coop with competitor
//tab 	f4_7_15a10 // 6 N/A
//tab 	f4_7_15b10 // 6 N/A, 4 idk's (as missing values)
gen 	coopcompet_lastyr = 1 if f4_7_15a10==1
replace coopcompet_lastyr = 0 if coopcompet_lastyr==.
gen 	coopcompet_nextyr = 1 if f4_7_15b10==1
replace coopcompet_nextyr = 0 if coopcompet_nextyr==.

*** VAT number
//tab 	f4_7_15a11 // 4 idk's (as missing values)
//tab 	f4_7_15b11 // 19 idk's (as missing values)
gen 	vat_lastyr = 1 if f4_7_15a11==1
replace vat_lastyr = 0 if vat_lastyr==.
gen 	vat_nextyr = 1 if f4_7_15b11==1
replace vat_nextyr = 0 if vat_nextyr==.



*************************************************************************
*** DISCUSSION AND DECISION-MAKING **************************************


***** DISCUSSION OF BUSINESS TOPICS W OTHERS

*** Discussing any business topics w others

* Detect missing values in asset var --> 0, 217 obs!
mdesc 	f4_7_35a f4_7_35bx

* Dummy for discussing any business topics
//tab 	f4_7_35a
gen 	discuss_any = 1 if f4_7_35a==1
replace discuss_any = 0 if discuss_any==.
//tab 	discuss_any

* Jointly discussing anything on a daily basis
gen discuss_any_daily = 0

foreach x of varlist f4_7_35dA f4_7_35dB f4_7_35dC f4_7_35dD f4_7_35dE f4_7_35dF ///
f4_7_35dG f4_7_35dH f4_7_35dI f4_7_35dJ f4_7_35dK f4_7_35dL f4_7_35dM f4_7_35dN ///
f4_7_35dO f4_7_35dP f4_7_35dQ f4_7_35dR f4_7_35dS{
   replace discuss_any_daily = discuss_any_daily+1  if `x'==7
   }

//tab 	discuss_any_daily
   
replace discuss_any_daily = 1 if discuss_any_daily>0 & discuss_any_daily!=.
   

* A Sales
gen 	discuss_sales 	= 1 if f4_7_35bxxA==1
replace discuss_sales 	= 0 if discuss_sales==.
gen 	discuss_sales_wk = 1 if f4_7_35dA==5 | f4_7_35dA==6 | f4_7_35dA==7
replace discuss_sales_wk = 0 if discuss_sales_wk==.
* B Selling price
gen 	discuss_sellprice 	= 1 if f4_7_35bxxB==1
replace discuss_sellprice 	= 0 if discuss_sellprice==.
gen 	discuss_sellprice_wk 	= 1 if f4_7_35dB==5 | f4_7_35dB==6 | f4_7_35dB==7
replace discuss_sellprice_wk 	= 0 if discuss_sellprice_wk==.
* C Best-selling product
gen 	discuss_bestseller 		= 1 if f4_7_35bxxC==1
replace discuss_bestseller 		= 0 if discuss_bestseller==.
gen 	discuss_bestseller_wk	= 1 if f4_7_35dC==5 | f4_7_35dC==6 | f4_7_35dC==7
replace discuss_bestseller_wk 	= 0 if discuss_bestseller_wk==.
* G Finance opportunities
gen 	discuss_finance = 1 if f4_7_35bxxG==1
replace discuss_finance = 0 if discuss_finance==.
* J Purchasing price
gen 	discuss_buyprice = 1 if f4_7_35bxxJ==1
replace discuss_buyprice = 0 if discuss_buyprice==.
* K New brand/product
gen 	discuss_newprod 		= 1 if f4_7_35bxxK==1
replace discuss_newprod 		= 0 if discuss_newprod==.
gen 	discuss_newprod_wk	= 1 if f4_7_35dK==5 | f4_7_35dK==6 | f4_7_35dK==7
replace discuss_newprod_wk 	= 0 if discuss_newprod_wk==.
* L Common (?) business practice
gen 	discuss_practice 	= 1 if f4_7_35bxxL==1
replace discuss_practice 	= 0 if discuss_practice==.
gen 	discuss_practice_wk 	= 1 if f4_7_35dL==5 | f4_7_35dL==6 | f4_7_35dL==7
replace discuss_practice_wk 	= 0 if discuss_practice_wk==.
* M Business plan
gen 	discuss_bisplan 		= 1 if f4_7_35bxxM==1
replace discuss_bisplan 		= 0 if discuss_bisplan==.
gen 	discuss_bisplan_wk 	= 1 if f4_7_35dM==5 | f4_7_35dM==6 | f4_7_35dM==7
replace discuss_bisplan_wk 	= 0 if discuss_bisplan_wk==.


*** Specific people

* Detect missing values in asset var --> 873, 882, 1024, 1123, 1003, 1075, 1096, 1036 obs!
mdesc f4_7_35cA f4_7_35cB f4_7_35cC f4_7_35cG f4_7_35cJ f4_7_35cK ///
		f4_7_35cL f4_7_35cM
* Remainder not commonly discussed (see above)

//tab f4_7_35cA
//tab f4_7_35cB
//tab f4_7_35cC
//tab f4_7_35cG
//tab f4_7_35cJ
//tab f4_7_35cK
//tab f4_7_35cL
//tab f4_7_35cM
levelsof f4_7_35cA 
levelsof f4_7_35cB
levelsof f4_7_35cC
levelsof f4_7_35cG
levelsof f4_7_35cJ
levelsof f4_7_35cK
levelsof f4_7_35cL
levelsof f4_7_35cM

* Dummies for specific persons to discuss business topics w
gen discuss_fam = 0
gen discuss_friend = 0
gen discuss_bisfriend = 0
gen discuss_supplier = 0

foreach x of varlist f4_7_35cA f4_7_35cB f4_7_35cC f4_7_35cD f4_7_35cE f4_7_35cF ///
f4_7_35cG f4_7_35cH f4_7_35cI f4_7_35cJ f4_7_35cK f4_7_35cL f4_7_35cM f4_7_35cN ///
f4_7_35cO f4_7_35cP f4_7_35cQ f4_7_35cR f4_7_35cS{
   replace discuss_fam 		= discuss_fam+1  		if `x'==8
   replace discuss_friend	= discuss_friend+1 		if `x'==7
   replace discuss_bisfriend = discuss_bisfriend+1	if `x'==6 | `x'==5
   replace discuss_supplier 	= discuss_supplier+1 	if `x'==4
   }

replace discuss_fam 			= 1 if discuss_fam>0 & discuss_fam!=.
replace discuss_friend 		= 1 if discuss_friend>0 & discuss_friend!=.
replace discuss_bisfriend 	= 1 if discuss_bisfriend>0 & discuss_bisfriend!=.
replace discuss_supplier 	= 1 if discuss_supplier>0 & discuss_supplier!=.

//tab discuss_fam
//tab discuss_friend
//tab discuss_supplier
//tab discuss_bisfriend


***** JOINT DECISION-MAKING ABOUT BUSINESS TOPICS W OTHERS

*** Decision-making w others in general

* Detect missing values in asset var --> 0, 746, 746 obs
mdesc f4_7_36a f4_7_36bx f4_7_36e

* Dummy for making any business decisions jointly with others
gen 	jointdec_any = 1 if f4_7_36a==1
replace jointdec_any = 0 if jointdec_any==.

* Dummy for joint decision-making w informal agreement (only 6 formal agreements)
gen 	jointdec_agree = 1 if f4_7_36f==1
replace jointdec_agree = 0 if jointdec_agree==.

* Jointly deciding on anything on a daily basis
gen 	jointdec_any_day = 0

foreach x of varlist f4_7_36dA f4_7_36dB f4_7_36dC f4_7_36dD f4_7_36dE f4_7_36dF ///
f4_7_36dG f4_7_36dH f4_7_36dI f4_7_36dJ f4_7_36dK f4_7_36dL f4_7_36dM f4_7_36dN ///
f4_7_36dO f4_7_36dP f4_7_36dQ f4_7_36dR f4_7_36dS{
   replace jointdec_any_day = jointdec_any_day+1  if `x'==7
   }

replace jointdec_any_day = 1 if jointdec_any_day>0  & jointdec_any_day!=.
   

* A Sales
gen 	jointdec_sales 		= 1 if f4_7_36bxxA==1
replace jointdec_sales 		= 0 if jointdec_sales==.
gen 	jointdec_sales_wk 	= 1 if f4_7_36dA==5 | f4_7_36dA==6 | f4_7_36dA==7
replace jointdec_sales_wk 	= 0 if jointdec_sales_wk==.
* B Selling price
gen 	jointdec_sellprice 	= 1 if f4_7_36bxxB==1
replace jointdec_sellprice 	= 0 if jointdec_sellprice==.
gen 	jointdec_sellprice_wk = 1 if f4_7_36dB==5 | f4_7_36dB==6 | f4_7_36dB==7
replace jointdec_sellprice_wk = 0 if jointdec_sellprice_wk==.
* C Best-selling product
gen 	jointdec_bestseller 		= 1 if f4_7_36bxxC==1
replace jointdec_bestseller 		= 0 if jointdec_bestseller==.
gen 	jointdec_bestseller_wk 	= 1 if f4_7_36dC==5 | f4_7_36dC==6 | f4_7_36dC==7
replace jointdec_bestseller_wk 	= 0 if jointdec_bestseller_wk==.
* G Finance opportunities
gen 	jointdec_finance = 1 if f4_7_36bxxG==1
replace jointdec_finance = 0 if jointdec_finance==.
* J Purchasing price
gen 	jointdec_buyprice = 1 if f4_7_36bxxJ==1
replace jointdec_buyprice = 0 if jointdec_buyprice==.
* K New brand/product
gen 	jointdec_newprod 	= 1 if f4_7_36bxxK==1
replace jointdec_newprod 	= 0 if jointdec_newprod==.
gen 	jointdec_newprod_wk 	= 1 if f4_7_36dK==5 | f4_7_36dK==6 | f4_7_36dK==7
replace jointdec_newprod_wk 	= 0 if jointdec_newprod_wk==.
* L Common (?) business practice
gen 	jointdec_practice 	= 1 if f4_7_36bxxL==1
replace jointdec_practice 	= 0 if jointdec_practice==.
gen 	jointdec_practice_wk = 1 if f4_7_36dL==5 | f4_7_36dL==6 | f4_7_36dL==7
replace jointdec_practice_wk = 0 if jointdec_practice_wk==.
* M Business plan
gen 	jointdec_bisplan 	= 1 if f4_7_36bxxM==1
replace jointdec_bisplan 	= 0 if jointdec_bisplan==.
gen 	jointdec_bisplan_wk 	= 1 if f4_7_36dM==5 | f4_7_36dM==6 | f4_7_36dM==7
replace jointdec_bisplan_wk 	= 0 if jointdec_bisplan_wk==.


*** Specific people

* Detect missing values in asset var --> 873, 882 1024, 1123, 1003, 1075, 1096, 1036 obs
mdesc f4_7_35cA f4_7_35cB f4_7_35cC f4_7_35cG f4_7_35cJ f4_7_35cK ///
		f4_7_35cL f4_7_35cM
* Remainder not commonly discussed (see above)

//tab f4_7_36cA
//tab f4_7_36cB
//tab f4_7_36cC
//tab f4_7_36cG
//tab f4_7_36cJ
//tab f4_7_36cK
//tab f4_7_36cL
//tab f4_7_36cM
levelsof f4_7_36cA 
levelsof f4_7_36cB
levelsof f4_7_36cC
levelsof f4_7_36cG
levelsof f4_7_36cJ
levelsof f4_7_36cK
levelsof f4_7_36cL
levelsof f4_7_36cM

* Dummies for specific persons to decide on business topics w
gen jointdec_fam = 0
* All other possible partners are being consulted by <10 firms

foreach x of varlist f4_7_36cA f4_7_36cB f4_7_36cC f4_7_36cD f4_7_36cE f4_7_36cF ///
f4_7_36cG f4_7_36cH f4_7_36cI f4_7_36cJ f4_7_36cK f4_7_36cL f4_7_36cM f4_7_36cN ///
f4_7_36cO f4_7_36cP f4_7_36cQ f4_7_36cR f4_7_36cS{
   replace jointdec_fam = jointdec_fam+1  if `x'==8
   }

replace jointdec_fam = 1 if jointdec_fam>0  & jointdec_fam!=.

//tab 	jointdec_fam



************************************************************************
***** LOANS AND FINANCES ***********************************************


* Generate loan vars
gen 	loan_applied 	= (f4_9_1>0) & (f4_9_1!=.)
gen 	loan_outstanding 	= (f4_9_2>0) & (f4_9_2!=.)
gen 	loan_amt = f4_9_8/xchange
replace loan_amt = 0 if loan_amt==.



*** Vars for financial literacy

* Interest
gen 	finlit_int = 1 if f4_9_11b==1
replace finlit_int = 0 if finlit_int==.

* Compound interest
gen 	finlit_compoundint 	= 1 if f4_9_11a==1
replace finlit_compoundint 	= 0 if finlit_compoundint==.

*composite
egen 	finlit_score 		= rowmean(finlit_int finlit_compoundint)



***** SAVINGS

gen save_daily 	= 1 if inlist(f4_8_9, 1,2)
replace save_daily = 0 if f4_8_9==3
replace save_daily = . if f4_8_9==7==8

gen save_daily_fix_amt = f4_8_10/xchange if f4_8_10 < 999999996
gen save_daily_prop_amt = f4_8_11*sales_nday 
gen save_daily_amt = save_daily_fix_amt
replace save_daily_amt = save_daily_prop_amt if save_daily_fix_amt==.


***** INVESTMENT

gen reinvest_daily 	= 1 if inlist(f4_8_6, 1,2)
replace reinvest_daily =. if f4_8_6==7==8

gen reinvest_daily_fix_amt = f4_8_7/xchange
gen reinvest_daily_prop_amt = f4_8_11*sales_nday 
gen reinvest_daily_amt = reinvest_daily_fix_amt
replace reinvest_daily_amt = reinvest_daily_prop_amt if reinvest_daily_fix_amt==.



************************************************************************
***** ASPIRATIONS ******************************************************



***** "IDEAL" ASPIRATIONS (SELF-CHOSEN TIME HORIZON) *******************


***** Imagination failure
gen imagine_fail = (f4_10_01a==3)
label var imagine_fail "Imagination failure (yes/no)"


***** Current shop size
gen size = f4_10_01aa
label var size "Business size (square meters)"

egen size_md = median(size)

gen size_AM = (size>size_md)

gen size_BM = 1 - size_AM


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
replace asp12_sales = asp12_sales/xchange
label var asp12_sales "12mth aspirations for daily sales (USD PPP)"

extremes sales_nday asp12_sales shop_ID 
replace asp12_sales =. if asp12_sales>25000
replace sales_nday=. if sales_nday>25000	//Redunant since above replace sales_nday=. if sales_nday>17500

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
gen asp_minprof = f4_10_3b
replace asp_minprof = asp_minprof/xchange
replace asp_minprof=. if asp_minprof>=250
label var asp_minprof "Minimum income requirements (USD PPP)"

* Minimum profits normalised by current profits (proportion)
gen aspgap_minprof = asp_minprof/prof_nday

replace aspgap_minprof=. if aspgap_minprof>1

* Aspirations
gen asp18_prof = f4_10_3h
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



***** ASPIRATIONS FOR OFFSPRING ************************************************


*** OLDEST CHILD'S AGE


* Oldest son U18

gen son1_age = f4_10_4a1_age
gen son2_age = f4_10_4a2_age
gen son3_age = f4_10_4a3_age

gen oldestson_age =.
replace oldestson_age = son1_age if (son2_age==. | son2_age>=18) & son1_age<18
replace oldestson_age = son2_age if (son3_age==. | son3_age>=18) & son2_age<18
replace oldestson_age = son3_age if son3_age<18

_crcslbl son1_age f4_10_4a1_age
_crcslbl son2_age f4_10_4a2_age
_crcslbl son3_age f4_10_4a3_age


* Oldest daughter U18

gen dtr1_age = f4_10_5a1_age
gen dtr2_age = f4_10_5a2_age
gen dtr3_age = f4_10_5a3_age

gen oldestdtr_age =.
replace oldestdtr_age = dtr1_age if (dtr2_age==. | dtr2_age>=18) & dtr1_age<18
replace oldestdtr_age = dtr2_age if (dtr3_age==. | dtr3_age>=18) & dtr2_age<18
replace oldestdtr_age = dtr3_age if dtr3_age<18

_crcslbl dtr1_age f4_10_5a1_age
_crcslbl dtr2_age f4_10_5a2_age
_crcslbl dtr3_age f4_10_5a3_age


* Oldest child U18

gen oldestkid_male = .
replace oldestkid_male = 1 if oldestson_age>=oldestdtr_age & oldestson_age!=. & oldestdtr_age!=.
replace oldestkid_male = 0 if oldestson_age<oldestdtr_age & oldestson_age!=. & oldestdtr_age!=.



*** OCCUPATIONAL ASPIRATIONS


* Re-coding son's occup aspirations ("other")

gen asp_occup_son_oth = .
replace asp_occup_son_oth = 7 if inlist(f4_10_4c_ot,"KARYAWAN PABRIK","PEGAWAI PABRIK","PEKERJA PABRIK SEPATU","KARYAWAN INDUSTRI")
replace asp_occup_son_oth = 8 if f4_10_4c_ot=="MACHINIST"
replace asp_occup_son_oth = 13 if inlist(f4_10_4c_ot,"KARYAWAN DI KANTOR","ADMINISTRASI","ADMINISTRASI STAFF","KANTORAN","STAF KANTOR SWASTA","STAFF KANTORAN","KARYAWAN KANTORAN","KARYAWAN SWASTA","KARYAWQAN SWASTA TAPI GA TAU PROFESINYA")
replace asp_occup_son_oth = 14 if inlist(f4_10_4c_ot,"MANAGER","SUPERVISOR","MANAJER PERUHASAAN")
replace asp_occup_son_oth = 19 if f4_10_4c_ot=="PELAYARAN ATAU ANGKATAN LAUT"
replace asp_occup_son_oth = 20 if f4_10_4c_ot=="WALIKOTA"
replace asp_occup_son_oth = 26 if f4_10_4c_ot=="ARSITEK"
replace asp_occup_son_oth = 29 if inlist(f4_10_4c_ot,"PRESIDEN","MENTERI KEUANGAN")

gen asp_occup_son_nongovt = 1 if inlist(f4_10_4c_ot,"MASINIS","KONTRAKTOR","PABRIK","KAPTEN PELAYARAN","USTADZ","USTAD","USTADZAH","IHUTAN(AHLI KEAGAMAAN) PAUS DI KRISTEN","APOTEKER") | ///
inlist(f4_10_4c_ot,"WARTAWAN","MULTIMEDIA","ATLET SEPAKBOLA","SEKRETARIS","CHEF","BAGIAN PEMASARAN","PENARI BALET","MARKETING")


* Re-coding daughter' occup aspirations ("other")

gen asp_occup_dtr_oth = .
replace asp_occup_dtr_oth = 7 if inlist(f4_10_5c_ot,"KARYAWAN PABRIK","PEGAWAI PABRIK","PEKERJA PABRIK SEPATU","KARYAWAN INDUSTRI")
replace asp_occup_dtr_oth = 8 if f4_10_5c_ot=="MACHINIST"
replace asp_occup_dtr_oth = 13 if inlist(f4_10_5c_ot,"KARYAWAN DI KANTOR","ADMINISTRASI","ADMINISTRASI STAFF","KANTORAN","STAF KANTOR SWASTA","STAFF KANTORAN","KARYAWAN KANTORAN","KARYAWAN SWASTA","KARYAWQAN SWASTA TAPI GA TAU PROFESINYA")
replace asp_occup_dtr_oth = 14 if inlist(f4_10_5c_ot,"MANAGER","SUPERVISOR","MANAJER PERUHASAAN")
replace asp_occup_dtr_oth = 19 if f4_10_5c_ot=="PELAYARAN ATAU ANGKATAN LAUT"
replace asp_occup_dtr_oth = 20 if f4_10_5c_ot=="WALIKOTA"
replace asp_occup_dtr_oth = 26 if f4_10_5c_ot=="ARSITEK"
replace asp_occup_dtr_oth = 29 if inlist(f4_10_5c_ot,"PRESIDEN","MENTERI KEUANGAN")

* Social status not clear, but certainly non-govt
gen asp_occup_dtr_nongovt = 1 if inlist(f4_10_5c_ot,"MASINIS","KONTRAKTOR","PABRIK","KAPTEN PELAYARAN","USTADZ","USTAD","USTADZAH","IHUTAN(AHLI KEAGAMAAN) PAUS DI KRISTEN","APOTEKER") | ///
inlist(f4_10_5c_ot,"WARTAWAN","MULTIMEDIA","ATLET SEPAKBOLA","SEKRETARIS","CHEF","BAGIAN PEMASARAN","PENARI BALET","MARKETING")

* Aspirations for oldest son U18

gen asp_occup_son = f4_10_4c
replace asp_occup_son = asp_occup_son_oth if asp_occup_son==.
replace asp_occup_son =. if asp_occup_son>94


* Aspirations for oldest daughter U18

gen asp_occup_dtr = f4_10_5c
replace asp_occup_dtr = asp_occup_dtr_oth if asp_occup_dtr==.
replace asp_occup_dtr =. if asp_occup_dtr>94


* Kids aspirations

gen asp_occup_kids 		= asp_occup_son
replace asp_occup_kids 	= (asp_occup_son + asp_occup_dtr)/2 if oldestson_age!=. & oldestdtr_age!=.
replace asp_occup_kids 	= asp_occup_dtr if asp_occup_kids==.


* Dummies for daughter and son

foreach x of varlist	asp_occup_son asp_occup_dtr {
	
						gen `x'_govt =.
						replace `x'_govt = 0 if `x'!=.
						replace `x'_govt = 1 if inlist(`x',12,13,15,17,18,19,20)
						
						egen `x'_md = median(`x')
						gen `x'_AM = 1 if `x'>`x'_md & `x'!=.
						replace `x'_AM = 0 if `x'<=`x'_md
						}

replace asp_occup_son_govt = 0 if asp_occup_son_nongovt==1
replace asp_occup_dtr_govt = 0 if asp_occup_dtr_nongovt==1

_crcslbl asp_occup_son_AM f4_10_4c
_crcslbl asp_occup_son_govt f4_10_4c
_crcslbl asp_occup_dtr_AM f4_10_5c
_crcslbl asp_occup_dtr_govt f4_10_5c


* Dummies for kids

egen asp_occup_kids_md = median(asp_occup_kids)
gen asp_occup_kids_AM = 1 if asp_occup_kids>asp_occup_kids_md & asp_occup_kids!=.
replace asp_occup_kids_AM = 0 if asp_occup_kids<=asp_occup_kids_md

gen asp_occup_kids_govt =.
replace asp_occup_kids_govt = 1 if asp_occup_dtr_govt==1 | asp_occup_son_govt==1
replace asp_occup_kids_govt = 0 if asp_occup_dtr_govt!=1 & asp_occup_son_govt!=1 & asp_occup_kids!=.

label var asp_occup_kids_AM "Avg occup aspirations for children above md (yes=1)"
label var asp_occup_kids_govt "Gov't job aspired for either son or dtr (yes=1)"



*** EDUCATIONAL ASPIRATIONS

* Aspirations for oldest son U18
gen asp_educ_son = f4_10_4b
gen aspgap_educ_son = (asp_educ_son - educ)/asp_educ_son

* Aspirations for oldest daughter U18
gen asp_educ_dtr = f4_10_5b
replace asp_educ_dtr = 25 if asp_educ_dtr==26
gen aspgap_educ_dtr = (asp_educ_dtr - educ)/asp_educ_dtr


* Kids' aspirations

gen asp_educ_kids 		= asp_educ_son
replace asp_educ_kids 	= (asp_educ_son + asp_educ_dtr)/2 if (oldestson_age!=. & oldestson_age<=18) & (oldestdtr_age!=. & oldestdtr_age<=18)
replace asp_educ_kids 	= asp_educ_dtr if asp_educ_kids==.

gen aspgap_educ_kids = (asp_educ_kids - educ)/asp_educ_kids

* Dummies

foreach x of varlist	asp_educ_son asp_educ_dtr {
	
						gen `x'_ma =.
						replace `x'_ma = 1 if `x'>=17 & `x'!=.
						replace `x'_ma = 0 if `x'<17 & `x'!=.
						}
						
foreach x of varlist	asp_educ_son asp_educ_dtr aspgap_educ_son aspgap_educ_dtr {
	
						egen `x'_md = median(`x')
						gen `x'_AM = 1 if `x'>`x'_md & `x'!=.
						replace `x'_AM = 0 if `x'<=`x'_md
											
						gen `x'_BM 		= 1 - `x'_AM
						}
						
* Dummies for kids variable

gen asp_educ_kids_ma 		=.
replace asp_educ_kids_ma 	= 1 if asp_educ_kids>=17 & asp_educ_kids!=.
replace asp_educ_kids_ma 		= 0 if asp_educ_kids<17 & asp_educ_kids!=.

egen asp_educ_kids_md 		= median(asp_educ_kids)
gen asp_educ_kids_AM 		= 1 if asp_educ_kids>asp_educ_kids_md & asp_educ_kids!=.
replace asp_educ_kids_AM 		= 0 if asp_educ_kids<=asp_educ_kids_md

gen asp_educ_kids_BM		= 1 - asp_educ_kids_AM


label var asp_educ_son				"Aspired education for son (years)"
label var asp_educ_son_AM			"Aspired education for son above md (yes=1)"
label var asp_educ_son_ma			"Aspired education for son at least MA (yes=1)"
label var asp_educ_dtr				"Aspired education for dtr (years)"
label var asp_educ_dtr_AM			"Aspired education for son above md (yes=1)"
label var asp_educ_dtr_ma			"Aspired education for son at least MA (yes=1)"
label var asp_educ_kids				"Aspired education for children (years)
label var asp_educ_kids_ma			"Avg educ aspirations for children at least MA (yes=1)"
label var asp_educ_kids_AM			"Avg educ aspirations for children above md (yes=1)"


* Walk-around for HTE effects in "Multidim paper"
gen asp_educ_son_ma_AM		= asp_educ_son_ma
gen asp_educ_son_ma_BM		= 1 - asp_educ_son_ma
gen asp_educ_dtr_ma_AM		= asp_educ_dtr_ma
gen asp_educ_dtr_ma_BM		= 1 - asp_educ_dtr_ma
gen asp_educ_kids_ma_AM		= asp_educ_kids_ma
gen asp_educ_kids_ma_BM		= 1 - asp_educ_kids_ma


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

/*

***** 3 practices to improve the business

* Detect missing values in practices vars --> 0 obs

*** records/profits/targets/statements
mdesc f4_10_6a_a01 f4_10_6a_a02 f4_10_6a_a03 f4_10_6a_a04 f4_10_6a_a05 ///
f4_10_6a_a06 f4_10_6a_a07 f4_10_6a_a08 f4_10_6a_a09 f4_10_6a_a10 f4_10_6a_a11

//tab f4_10_6a_a01
//tab f4_10_6a_a02
//tab f4_10_6a_a03
//tab f4_10_6a_a04
//tab f4_10_6a_a05
//tab f4_10_6a_a06
//tab f4_10_6a_a07
//tab f4_10_6a_a08
//tab f4_10_6a_a09
//tab f4_10_6a_a10
//tab f4_10_6a_a11

*** suppliers/products/customers/prices
mdesc f4_10_6a_b01 f4_10_6a_b02 f4_10_6a_b03 f4_10_6a_b04 f4_10_6a_b05 ///
f4_10_6a_b06 f4_10_6a_b07 f4_10_6a_b08 f4_10_6a_b09 f4_10_6a_b10 f4_10_6a_b11 ///
f4_10_6a_b12 f4_10_6a_b13 f4_10_6a_b14 f4_10_6a_b15 f4_10_6a_b16 f4_10_6a_b17 ///
f4_10_6a_b18 f4_10_6a_b19

//tab f4_10_6a_b01
//tab f4_10_6a_b02
//tab f4_10_6a_b03
//tab f4_10_6a_b04
//tab f4_10_6a_b05
//tab f4_10_6a_b06
//tab f4_10_6a_b07
//tab f4_10_6a_b08
//tab f4_10_6a_b09
//tab f4_10_6a_b10
//tab f4_10_6a_b11
//tab f4_10_6a_b12
//tab f4_10_6a_b13
//tab f4_10_6a_b14
//tab f4_10_6a_b15
//tab f4_10_6a_b16
//tab f4_10_6a_b17
//tab f4_10_6a_b18
//tab f4_10_6a_b19

*** technology/banking/advertisement/licences --> 0 obs of missing value
mdesc f4_10_6a_c01 f4_10_6a_c02 f4_10_6a_c03 f4_10_6a_c04 f4_10_6a_c05 ///
f4_10_6a_c06 f4_10_6a_c07 f4_10_6a_c08 f4_10_6a_c09 f4_10_6a_c10 f4_10_6a_c11

//tab f4_10_6a_c01
//tab f4_10_6a_c02
//tab f4_10_6a_c03
//tab f4_10_6a_c04
//tab f4_10_6a_c05
//tab f4_10_6a_c06
//tab f4_10_6a_c07
//tab f4_10_6a_c08
//tab f4_10_6a_c09
//tab f4_10_6a_c10
//tab f4_10_6a_c11

*** staff/competitor/shop space --> 0 obs of missing value
mdesc f4_10_6a_d01 f4_10_6a_d02 f4_10_6a_d03 f4_10_6a_d04 f4_10_6a_d05 ///
f4_10_6a_d06 f4_10_6a_d07 f4_10_6a_d08 f4_10_6a_d09 f4_10_6a_d10 ///
f4_10_6a_d11 f4_10_6a_d12

//tab f4_10_6a_d01
//tab f4_10_6a_d02
//tab f4_10_6a_d03
//tab f4_10_6a_d04
//tab f4_10_6a_d05
//tab f4_10_6a_d06
//tab f4_10_6a_d07
//tab f4_10_6a_d08
//tab f4_10_6a_d09
//tab f4_10_6a_d10
//tab f4_10_6a_d11
//tab f4_10_6a_d12


*** 3 most profitable practices (open question)

gen practices_free_score = 6
foreach x of varlist	f4_10_6ax1 f4_10_6ax2 f4_10_6ax3{
						replace practices_free_score = practices_free_score-1 ///
						if `x'== "" | `x'== "A03" | `x'== "B14" | ///
						`x'== "B15" | `x'== "B17" | `x'== "B18" | `x'== "B19" | `x'== "D12" | ///
						`x'== "Z95" | `x'== "Z96"
}
				
	
foreach x of varlist f4_10_6a_z95_*_ot {
	replace practices_free_score = practices_free_score-1 if `x'=="DILLIGENT" | `x'=="PRAYING" ///
	| `x'=="WAITING FOR MIRACLE" | `x'== "BE HEALTHY" | `x'=="WILLINGNESS" | `x'=="KEEP FIGHTING" ///
	| `x'=="IMPROVE HABBIT" | `x'=="BE PATIENT" | `x'=="BE MORE RESPONSIBLE" | `x'=="MORE SPIRIT" ///
	| `x'=="CONDUCIVE SHOP" | `x'=="95. OUT OF RANGE" | `x'=="OUT OF RANGE" ///
	| `x'=="MORE SPIRIT" | `x'=="FASTING" | `x'=="ACCEPTANCE" |`x'=="" ///
	//| `x'=="RENOVATION"
	//| `x'=="IMPROVE CUSTOMER SERVICE" | `x'=="IMPROVE FINANCIAL SYSTEM" | `x'=="IMPROVE RESTOCK SYSTEM" ///

	}
	
	

*** 3 most profitable practices, done last year & planned for next year
mdesc f4_10_6b f4_10_6c

gen 	practices_free_lastyr = f4_10_6b
replace practices_free_lastyr = 0 if f4_10_6b==3
replace practices_free_lastyr =. if practices_free_lastyr==7 | practices_free_lastyr==8 | practices_free_lastyr==9

gen 	practices_free_nextyr = f4_10_6c
replace practices_free_nextyr = 0 if f4_10_6c==3
replace practices_free_nextyr =. if practices_free_nextyr==7 | practices_free_nextyr==8 | practices_free_lastyr==9

//tab practices_free_lastyr
//tab practices_free_nextyr
//tab practices_free_bad


***** Transformations *********************************************************

local asp1				asp_ideal_space asp_ideal_employ asp_ideal_custom asp_ideal_shop ///
						asp_gap3_ideal_space asp_gap3_ideal_employ asp_gap3_ideal_custom asp_gap3_ideal_shop ///
						asp_12mth_space asp_12mth_employ asp_12mth_custom asp_12mth_shop ///
						asp_gap3_12mth_space asp_gap3_12mth_employ asp_gap3_12mth_custom asp_gap3_12mth_shop ///
						asp_12mth_space_cse asp_12mth_employ_cse asp_12mth_custom_cse asp_12mth_shop_cse /// 	
						asp_12mth_sales asp_gap3_12mth_sales asp_12mth_sales_cse

local asp2				`asp1'

***** Winsorisation
				
foreach var of varlist 	`asp1'{

						winsor `var', gen(`var'_w1) p(0.01)
						local asp2 `asp2' `var'_w1
						winsor `var', gen(`var'_w25) p(0.025)
						local asp2 `asp2' `var'_w25
	}

	
***** IHS

foreach var of varlist 	`asp1' {

						gen `var'_ihs = ln(`var' + sqrt(`var'^2 +1))
						local asp2 `asp2' `var'_ihs 							
						// see missing values treatment at the end of the file
}






*************************************************************************
***** MENTAL MODELS OF RETURNS TO ADOPTION ******************************
//tab f4_13_03a
//tab f4_13_02b
//tab f4_13_03b

* Treating missing values --> 28, 3, 8, 7
mdesc f4_13_02a if f4_13_00		==1
mdesc f4_13_03a if f4_13_02a	==1
mdesc f4_13_02a if f4_13_00		==1
mdesc f4_13_03b if f4_13_02b	==1


* Generating dummy variable

gen 		book_prof					= 0
replace 	book_prof					= 1 if f4_13_02a == 1 | f4_13_02b==1
replace		book_prof					=. if f4_13_02a==. & f4_13_02b==.


gen 		book_prof_perc				= 0
replace 	book_prof_perc				= f4_13_03a if f4_13_03a<=100
replace		book_prof_perc				= f4_13_03b if f4_13_03b<=100
replace 	book_prof_perc				=. if book_prof==.

/*
gen 		book_prof_plan				= 1 if f4_13_02b == 1
replace		book_prof_plan				= 0 if f4_13_02b == 3
replace 	book_prof_plan				=. if f4_13_02b>3

gen 		book_prof_plan_perc			= f4_13_03b
replace 	book_prof_plan_perc			=. if f4_13_03b>100
*/

*/


*************************************************************************
***** INTERVIEWER IMPRESSIONS *******************************************

*check missing value --> 0 obs
mdesc f4_16_1a f4_16_1b f4_16_1c f4_16_1d f4_16_1e f4_16_1f f4_16_1g ///
f4_16_1h f4_16_1i f4_16_1j f4_16_1fa

//tab f4_16_1a
//tab f4_16_1b
//tab f4_16_1c
//tab f4_16_1d
//tab f4_16_1e
//tab f4_16_1f
//tab f4_16_1g
//tab f4_16_1h
//tab f4_16_1i
//tab f4_16_1j
//tab f4_16_1fa


gen present_spouse 		= f4_16_1a
gen present_family 		= f4_16_1b
gen present_otheradult 	= f4_16_1c
gen present_child_under5 = f4_16_1d
gen present_child_over5 	= f4_16_1e
gen present_employee 	= f4_16_1f
gen present_sm 			= f4_16_1g
gen present_jpal 		= f4_16_1h
gen present_tv 			= f4_16_1i
gen present_custom 		= f4_16_1j

foreach x of varlist present_* {
	replace `x'= 0  if `x'==3
	}


_crcslbl present_spouse 			f4_16_1a
_crcslbl present_family 			f4_16_1b
_crcslbl present_otheradult 		f4_16_1c
_crcslbl present_child_under5 	f4_16_1d
_crcslbl present_child_over5 	f4_16_1e
_crcslbl present_employee 		f4_16_1f
_crcslbl present_sm 				f4_16_1g
_crcslbl present_jpal 			f4_16_1h
_crcslbl present_tv 				f4_16_1i
_crcslbl present_custom 			f4_16_1j


**interviewer observation --> 585 obs f4_16_05, 121 obs in f4_16_02, 1183 obs in f4_16_12b
mdesc f4_16_02 f4_16_03 f4_16_03a f4_16_04 f4_16_05 f4_16_06 f4_16_07 ///
f4_16_08 f4_16_09 f4_16_10 f4_16_11 f4_16_12b f4_16_13

//tab f4_16_02
//tab f4_16_03
//tab f4_16_03a
//tab f4_16_04
//tab f4_16_05
//tab f4_16_06
//tab f4_16_07
//tab f4_16_08
//tab f4_16_09
//tab f4_16_10
//tab f4_16_11
//tab f4_16_12b
//tab f4_16_13


gen present_custom_no = f4_16_02
replace present_custom_no = 0 if present_custom_no==.

gen understand_perfect = 1 if f4_16_03==1
replace understand_perfect = 0 if f4_16_03==inlist(2,3,4)

gen shop_house_same = 1 if f4_16_03a==1 | f4_16_03a==2
replace shop_house_same = 0 if f4_16_03a==3 | f4_16_03a==4

gen shop_house_sep = 1 if f4_16_03a==3 | f4_16_03a==4
replace shop_house_sep = 0 if f4_16_03a==1 | f4_16_03a==2

gen shop_sign_bright = f4_16_05
replace shop_sign_bright = 0 if shop_sign_bright==2


gen shop_sign 			= f4_16_04
gen shop_goods_prices	= f4_16_06
gen shop_goods_display 	= f4_16_07
gen shop_shelf_full 		= f4_16_08
gen shop_advert 			= f4_16_09
gen shop_clean 			= f4_16_10
gen shop_bright 			= f4_16_11

foreach x of varlist shop_* {
	replace `x'= 0  if `x'==3
	}
	

_crcslbl present_custom_no 		f4_16_02
_crcslbl understand_perfect 		f4_16_03
_crcslbl shop_house_same 		f4_16_03a
_crcslbl shop_house_sep 			f4_16_03a
_crcslbl shop_sign 				f4_16_04
_crcslbl shop_sign_bright 		f4_16_05
_crcslbl shop_goods_prices 		f4_16_06
_crcslbl shop_goods_display 		f4_16_07
_crcslbl shop_shelf_full 		f4_16_08
_crcslbl shop_advert 			f4_16_09
_crcslbl shop_clean 				f4_16_10
_crcslbl shop_bright 			f4_16_11


*******************************************************************************
***** LABEL VARIABLES 
/*
label var shop_ID 								"Shop ID"
label var W3_xchange 							"Exchange rate at EL (USD PPP)"
label var W3_age_manager 						"Respondent's age at EL"
label var W3_age_manager_abvmd 					"Dummy for respondent's age being above md"
label var W3_male 								"Gender (male=1)"
label var W3_kids_1 							"Dummy for having children"
label var W3_kids_3 							"Dummy for >= 3 children"
label var W3_kids_young_1 						"Dummy for >=1 child under 7"
label var W3_educ_second 						"Dummy for having sec education"
label var W3_educ_terc 							"Dummy for having bachelor deg"
label var W3_cogstyle_system_01 				"Working style: plan before action"
label var W3_cogstyle_intuit_02 				"Working style: often follow instincts"
label var W3_cogstyle_intuit_03 				"Working style: a way of conduct if feels right"
label var W3_cogstyle_system_04 				"Working style: gather info before working"
label var W3_cogstyle_system_05 				"Working style: follow plan when doing important"
label var W3_cogstyle_intuit_06 				"Working style: start working without any idea"
label var W3_cogstyle_system_07 				"Working style: system and organized decision making"
label var W3_cogstyle_intuit_08 				"Working style: decide based on feelings and emotions"
label var W3_cogstyle_system_09 				"Working style: choose best alternatives"
label var W3_cogstyle_intuit_10 				"Working style: good decision not knowing how"
label var W3_cogstyle_system_answers 			"Systematic working style (answers given)"
label var W3_cogstyle_system 					"Systematic working style score at EL"
label var W3_cogstyle_system_perc 				"Systematic working style % score at EL"
label var W3_cogstyle_system_abvmd 				"Dummy for systematic working style above md at EL"
label var W3_cogstyle_intuit_answers 			"Intuitive working style (answers given)"
label var W3_cogstyle_intuit 					"Intuitive working style score at EL"
label var W3_cogstyle_intuit_perc 				"Intuitive working style % score at EL"
label var W3_cogstyle_rel 						"Working style: Rel score system-intuit"
label var W3_cogstyle_rel_md					"Work style: rel system thinking score (md)"
label var W3_cogstyle_rel_abvmd					"Work style: rel system thinking score (above md)"
label var W3_cogstyle_rel_p80					"Work style: rel system thinking score (p80)"
label var W3_cogstyle_rel_abv80					"Work style: rel system thinking score (above p80)"
label var W3_formal_reg 						"Dummy for having company reg cert"
label var W3_formal_tax 						"Dummy for having tax ID"
label var W3_formal_vat 						"Dummy for having VAT no"
label var W3_space_micro 						"Dummy for shop space <= 6 sqm"
label var W3_space_small 						"Dummy for shop space > 6 & <= 10 sqm"
label var W3_space_mid 							"Dummy for shop space > 10 sqm"
label var W3_space_cont_micro 					"Dummy for shop space <= 6 sqm (cont., asp)"
label var W3_space_cont_small 					"Dummy for shop space > 6 & <= 10 sqm (cont., asp)"
label var W3_space_cont_mid 					"Dummy for shop space > 10 sqm (cont., asp)"
label var W3_space_ord 							"Space (ordinal)"
label var W3_space_store 						"Prop storage to total area"
label var W3_space_store_yes 					"Dummy for having storage space"
label var W3_space_own 							"Dummy for owning shop space"
label var W3_space_rent 						"Dummy for renting shop space"
label var W3_space_use 							"Dummy for shop space used w/out cost"
label var W3_open 								"Total opening hours at EL"
label var W3_open_pp 							"Total opening hours at EL (pp)"
label var W3_open_break 						"Total break time at EL"
label var W3_open_net 							"Opening hours net of breaks at EL"
label var W3_open_net_pp 						"Opening hours net of breaks at EL (pp)"
label var W3_open_break_blwmd 					"Dummy break time below md"
label var W3_open_abvmd 						"Dummy for opening hours above md"
label var W3_open_p80 							"Opening hours (p80)"
label var W3_open_abv80 						"Dummy for opening hours above p80"
label var W3_open_net_abvmd 					"Dummy for opening hours net of breaks above md"
label var W3_open_net_p80 						"Net opening hours (p80)"
label var W3_open_net_abv80 					"Dummy opening hours net of breaks above p80"
label var W3_open_break_tarawih					"Tarawih break hours (Ramadan)"
label var W3_open_fast							"Total opening hours (Ramadan)"
label var W3_open_fast_pp						"Total opening hours (pp, Ramadan)"
label var W3_open_fast_break					"Total break time (Ramadan)"
label var W3_open_fast_net						"Opening hours net of breaks (Ramadan)"
label var W3_open_fast_net_pp					"Opening hours net of breaks (pp, Ramadan)"
label var W3_open_fast_break_blwmd				"Dummy break time (Ramadan, ELwmd)"
label var W3_open_fast_abvmd					"Dummy opening hours (Ramadan, abvmd)"
label var W3_open_fast_p80						"Opening hours (Ramadan, p80)"
label var W3_open_fast_abv80					"Dummy opening hours (Ramadan, abv80)"
label var W3_open_fast_net_abvmd				"Dummy net opening hours (Ramadan, abvmd)"
label var W3_open_fast_net_p80					"Net opening hours (Ramadan, p80)"
label var W3_open_fast_net_abv80				"Dummy net open hours (Ramadan, abv80)"
label var W3_custom_total 						"Total customers (norm day)"
label var W3_custom_loyal 						"Loyal customers (norm day)"
label var W3_custom_casual 						"Casual customers (norm day)"
label var W3_custom_avgpurch 					"Avg purchase per customer"
label var W3_flood								"Dummy flood experience"
label var W3_flood_next							"Dummy flood expected in 2018"
label var W3_flood_either						"Dummy flood experience or expected == 0"
label var W3_flood_info1						"Flood info source (1)"
label var W3_flood_info1_ot						"Flood other info source (1)"
label var W3_flood_info2						"Flood info source (2)"
label var W3_flood_info2_ot						"Flood other info source (2)"
label var W3_flood_info3						"Flood info source (3)"
label var W3_flood_info3_ot						"Flood other info source (3)"
label var W3_flood_info_fam_RW					"Flood info: friend/fam/neigh in same RW"
label var W3_flood_info_fam_gate				"Flood info: friend/fam/neigh near floodgate"
label var W3_flood_info_fam_any					"Flood info: friend/fam in Jakarta"
label var W3_flood_info_fam_depok				"Flood info: friend/fam in Depok/Bogor"
label var W3_flood_info_lurah					"Flood info: lurah official"
label var W3_flood_info_RW						"Flood info: RW member"
label var W3_flood_info_RT						"Flood info: RT member"
label var W3_flood_info_govt					"Flood info: other govt staff"
label var W3_flood_info_mosque					"Flood info: mosque member"
label var W3_flood_info_tv						"Flood info: television"
label var W3_flood_info_radio					"Flood info: radio"
label var W3_flood_info_internet				"Flood info: internet"
label var W3_flood_info_govinternet				"Flood info: govt info on internet"
label var W3_flood_info_map						"Flood info: disaster map"
label var W3_flood_info_percept					"Flood info: own observ (rain/flood)"
label var W3_flood_info_forecast				"Flood info: forecast"
label var W3_flood_info_ot						"Flood info: others"
label var W3_flood_preparation					"Flood preparation"
label var W3_assets_car								"Dummy car"
label var W3_assets_scooter							"Dummy scooter"
label var W3_assets_nofridge							"Dummy no fridge"
label var W3_assets_fridges							"Dummy >= 2 fridges"
label var W3_assets_landline							"Dummy landline"
label var W3_assets_otherfirm						"Other businesses owned"
label var W3_sales_lastmth 						"Sales last month"
label var W3_expense_stockup_ln					"Baseline Baseline expenses: Stock-up (ln)"
label var W3_expense_stockup 					"Baseline Baseline expenses: Stock-up"
label var W3_expense_stockup_w1 				"Baseline expenses: Stock-up win 1%"
label var W3_expense_stockup_w25 				"Baseline expenses: Stock-up win 2.5%"
label var W3_expense_wage 						"Baseline expenses: Salaries"
label var W3_expense_wage_ln 					"Baseline expenses: Salaries (ln)"
label var W3_expense_wage_w1 					"Baseline expenses: Salaries win 1%"
label var W3_expense_wage_w25 					"Baseline expenses: Salaries win 2.5%"
label var W3_expense_rent 						"Baseline expenses: Rent and fees"
label var W3_expense_rent_ln 					"Baseline expenses: Rent and fees (ln)"
label var W3_expense_rent_w1 					"Baseline expenses: Rent and fees win 1%"
label var W3_expense_rent_w25 					"Baseline expenses: Rent and fees win 2.5%"
label var W3_expense_electric 					"Baseline expenses: Electricity and utilities"
label var W3_expense_electric_ln 				"Baseline expenses: Electricity and utilities (ln)"
label var W3_expense_electric_w1 				"Baseline expenses: Electricity and utilities win 1%"
label var W3_expense_electric_w25 				"Baseline expenses: Electricity and utilities win 2.5%"
label var W3_expense_transport 					"Baseline expenses: Transport"
label var W3_expense_transport_ln 				"Baseline expenses: Transport (ln)"
label var W3_expense_transport_w1 				"Baseline expenses: Transport win 1%"
label var W3_expense_transport_w25				"Baseline expenses: Transport win 2.5%"
label var W3_expense_tax 						"Baseline expenses: Tax"
label var W3_expense_tax_ln						"Baseline expenses: Tax (ln)"
label var W3_expense_tax_w1 					"Baseline expenses: Tax win 1%"
label var W3_expense_tax_w25 					"Baseline expenses: Tax win 2.5%"
label var W3_expense_phone 						"Baseline expenses: Communication"
label var W3_expense_phone_ln 					"Baseline expenses: Communication (ln)"
label var W3_expense_phone_w1					"Baseline expenses: Communication win 1%"
label var W3_expense_phone_w25 				"Baseline expenses: Communication win 2.5%"
label var W3_expense_advert 					"Baseline expenses: Marketing"
label var W3_expense_advert_ln					"Baseline expenses: Marketing (ln)"
label var W3_expense_advert_w1				"Baseline expenses: Marketing win 1%"
label var W3_expense_advert_w25 				"Baseline expenses: Marketing win 2.5%"
label var W3_expense_preman 					"Baseline expenses: Local thugs"
label var W3_expense_preman_ln 					"Baseline expenses: Local thugs (ln)"
label var W3_expense_preman_w1				"Baseline expenses: Local thugs win 1%"
label var W3_expense_preman_w25 				"Baseline expenses: Local thugs win 2.5%"
label var W3_expense_police 					"Baseline expenses: Police"
label var W3_expense_police_ln 					"Baseline expenses: Police (ln)"
label var W3_expense_police_w1 				"Baseline expenses: Police win 1%"
label var W3_expense_police_w25 				"Baseline expenses: Police win 2.5%"
label var W3_security							"Baseline expenses: Security"
label var W3_expense_other 						"Baseline expenses: Other"
label var W3_expense_other_ln					"Baseline expenses: Other (ln)"
label var W3_expense_other_w1 				"Baseline expenses: Other win 1%"
label var W3_expense_other_w25 				"Baseline expenses: Other win 2.5%"
label var W3_expense_total 						"Baseline expenses: Total"
label var W3_expense_total_ln				"Baseline expenses: Total (ln)"
label var W3_expense_total_w1 				"Baseline expenses: Total win 1%"
label var W3_expense_total_w25 				"Baseline expenses: Total win 2.5%"
label var W3_prof_lastmth_w1					"Profits last month win 1%"
label var W3_prof_lastmth_w25					"Profits last month win 2.5%"
label var W3_prof_lastmth_w25hi					"Profits last month win 2.5% (right tail)"
label var W3_confid_prof_lastmth 				"Dummy for being confident about profits last month"
label var W3_prof_lastmth_ihs 					"Profits last month IHS"
label var W3_prof_lastmth_w1_ihs 				"IHS of profits last month win at 1%"
label var W3_prof_lastmth_w25_ihs				"IHS of profits last month win 2.5%"
label var W3_prof_nday 							"Daily profits"
label var W3_prof_nday_w1 						"Daily profits win 1%"
label var W3_prof_nday_w25 						"Daily profits win 2.5%"
label var W3_prof_nday_w25hi						"Daily profits win 2.5% (right tail)"
label var W3_prof_nday_ihs 						"Daily profits (IHS)"
label var W3_prof_nday_w1_ihs 					"Daily profits (IHS) month win 1%"
label var W3_prof_nday_frac 					"Daily profit margin"
label var W3_prof_lastmth_calc 					"Calc profits last month"
label var W3_prof_lastmth_calc_w1				"Calculated profits last month win 1%"
label var W3_prof_lastmth_calc_w25				"Calculated profits last month win 2.5%"
label var W3_prof_lastmth_calc_w25hi			"Calculated profits last month win 2.5% (right tail)"
label var W3_prof_lastmth_calc_m 				"Calc profits last month (miss vals)"
label var W3_prof_lastmth_calc_ihs 				"Calc profits last month (IHS)"
label var W3_prof_lastmth_calc_w1_ihs 			"Calc profits last month (IHS) win 1%"
label var W3_prof_lastmth_calc_w25_ihs			"Calc profits last month (IHS) win 2.5%"
label var W3_prof_lastmth_diff					"Diff betw self-rep and calc profits at endline"
label var W3_prof_lastmth_diff_w1				"Diff betw self-rep and calc profits win at 1%"
label var W3_prof_lastmth_diff_w25				"Diff betw self-rep and calc profits win 2.5%"
label var W3_prof_lastmth_diff_w25hi			"Diff betw self-rep and calc profits win 2.5% (right tail)"
label var W3_prof_lastmth_diff_m				"Diff betw self-rep and calc profits (miss vals)"
label var W3_prof_lastmth_diff_ihs				"Diff betw self-rep and calc profits (IHS)"
label var W3_prof_lastmth_diff_w1_ihs 			"Diff betw self-rep and calc profits (IHS) win 1%"
label var W3_prof_lastmth_diff_w25_ihs			"Diff betw self-rep and calc profits (IHS) win 2.5%"
label var W3_prof_30normdays 					"Profits 30 norm days"
label var W3_prof_30normdays_ihs 				"Profits 30 norm days (IHS)"
label var W3_prof_30normdays_w1_ihs 			"Profits 30 norm days (IHS) win 1%"
label var W3_prof_mth_comp_all 					"Monthly profits comp
label var W3_prof_mth_comp_all_w1 				"Monthly profits comp win 1%"
label var W3_prof_mth_comp_all_w25 				"Monthly profits comp win 2.5%"
label var W3_prof_mth_comp_all_w25hi 			"Monthly profits comp win 2.5% (right tail)"
label var W3_prof_mth_comp_all_ihs 				"Monthly profits comp (IHS)"
label var W3_prof_mth_comp_all_w1_ihs 			"Monthly profits comp (IHS) win 1%"
label var W3_prof_mth_comp_rep 					"Monthly profits comp self-rep"
label var W3_prof_mth_comp_rep_w1 				"Monthly profits comp self-rep win 1%"
label var W3_prof_mth_comp_rep_w25				"Monthly profits comp self-rep win 2.5%"
label var W3_prof_mth_comp_rep_w25hi 			"Monthly profits comp self-rep win 2.5% (right tail)"
label var W3_prof_mth_comp_rep_ihs 				"Monthly profits comp self-rep (IHS)"
label var W3_prof_mth_comp_rep_w1_ihs 			"Monthly profits comp self-rep (IHS) win 1%"
label var W3_prof_mth_comp 						"Monthly profits comp rep/calc"
label var W3_prof_mth_comp_w1 					"Monthly profits comp rep/calc win 1%"
label var W3_prof_mth_comp_w25					"Monthly profits comp rep/calc win 2.5%"
label var W3_prof_mth_comp_w25hi 				"Monthly profits comp rep/calc win 2.5% (right tail)"
label var W3_prof_mth_comp_ihs 					"Monthly profits comp rep/calc (IHS)"
label var W3_prof_mth_comp_w1_ihs 				"Monthly profits comp rep/calc (IHS) win 1%"
label var W3_top3_prod1							"Top 3 prods (1)"
label var W3_top3_prod2							"Top 3 prods (2)"
label var W3_top3_prod3							"Top 3 prods (3)"
label var W3_top3_veg							"Top 3 prods: veggies"
label var W3_top3_fruit							"Top 3 prods: fruits"
label var W3_top3_nutspeas						"Top 3 prods: grains, peas, nuts"
label var W3_top3_rice							"Top 3 prods: rice"
label var W3_top3_flour							"Top 3 prods: flour"
label var W3_top3_meatfish						"Top 3 prods: meat, fist"
label var W3_top3_eggs							"Top 3 prods: eggs"
label var W3_top3_noodles						"Top 3 prods: noodles"
label var W3_top3_spices						"Top 3 prods: spices, leaves"
label var W3_top3_oil							"Top 3 prods: cooking oil"
label var W3_top3_saltsugar						"Top 3 prods: salt, sugar"
label var W3_top3_bread							"Top 3 prods: bread, buns, cakes"
label var W3_top3_coffeetea						"Top 3 prods: coffee, tea"
label var W3_top3_homecooked					"Top 3 prods: home-made food"
label var W3_top3_readymade						"Top 3 prods: ready-made food"
label var W3_top3_deepfrozen					"Top 3 prods: deep-frozen food"
label var W3_top3_snacks						"Top 3 prods: snacks"
label var W3_top3_freshdrinks					"Top 3 prods: fresh drinks"
label var W3_top3_softdrinks					"Top 3 prods: soft drinks"
label var W3_top3_sanitary						"Top 3 prods: sanitary prods"
label var W3_top3_cleaning						"Top 3 prods: cleaning prods"
label var W3_top3_baby							"Top 3 prods: baby prods"
label var W3_top3_kids							"Top 3 prods: kids' prods"
label var W3_top3_tobacco						"Top 3 prods: tobacco, cigs"
label var W3_top3_meds							"Top 3 prods: drugs and meds"
label var W3_top3_household						"Top 3 prods: household"
label var W3_top3_stationary					"Top 3 prods: stationery"
label var W3_top3_plastic						"Top 3 prods: plastic, packaging"
label var W3_top3_gaspetrol						"Top 3 prods: petrol"
label var W3_top3_phone							"Top 3 prods: telecom"
label var W3_top3_laundry						"Top 3 prods: laundry"
label var W3_top3_copying						"Top 3 prods: copying"
label var W3_top3_veg_prop						"Prop top 3 prods: veggies"
label var W3_top3_fruit_prop					"Prop top 3 prods: fruits"
label var W3_top3_nutspeas_prop					"Prop top 3 prods: grains, peas, nuts"
label var W3_top3_rice_prop						"Prop top 3 prods: rice"
label var W3_top3_flour_prop					"Prop top 3 prods: flour"
label var W3_top3_meatfish_prop					"Prop top 3 prods: meat, fish"
label var W3_top3_eggs_prop						"Prop top 3 prods: eggs"
label var W3_top3_noodles_prop					"Prop top 3 prods: noodles"
label var W3_top3_spices_prop					"Prop top 3 prods: spices, leaves"
label var W3_top3_oil_prop						"Prop top 3 prods: cooking oil"
label var W3_top3_saltsugar_prop				"Prop top 3 prods: salt, sugar"
label var W3_top3_bread_prop					"Prop top 3 prods: bread, buns, cakes"
label var W3_top3_coffeetea_prop				"Prop top 3 prods: coffee, tea"
label var W3_top3_homecooked_prop				"Prop top 3 prods: home made food"
label var W3_top3_readymade_prop				"Prop top 3 prods: ready-made food"
label var W3_top3_deepfrozen_prop				"Prop top 3 prods: deep-frozen food"
label var W3_top3_snacks_prop					"Prop top 3 prods: snacks"
label var W3_top3_freshdrinks_prop				"Prop top 3 prods: fresh drinks"
label var W3_top3_softdrinks_prop				"Prop top 3 prods: soft drinks"
label var W3_top3_sanitary_prop					"Prop top 3 prods: sanitary"
label var W3_top3_cleaning_prop					"Prop top 3 prods: cleaning prods"
label var W3_top3_baby_prop						"Prop top 3 prods: baby prods"
label var W3_top3_kids_prop						"Prop top 3 prods: kids' prod"
label var W3_top3_tobacco_prop					"Prop top 3 prods: tobacco, cigs"
label var W3_top3_meds_prop						"Prop top 3 prods: drugs, meds"
label var W3_top3_household_prop				"Prop top 3 prods: household"
label var W3_top3_stationary_prop				"Prop top 3 prods: stationery"
label var W3_top3_plastic_prop					"Prop top 3 prods: plastic, package"
label var W3_top3_gaspetrol_prop				"Prop top 3 prods: petrol"
label var W3_top3_phone_prop					"Prop top 3 prods: telecom"
label var W3_top3_laundry_prop					"Prop top 3 prods: laundry"
label var W3_top3_copying_prop					"Prop top 3 prods: copying"
label var W3_top3_rice_1						"Dummy top 3 prods: rice"
label var W3_top3_flour_1						"Dummy top 3 prods: flour"
label var W3_top3_eggs_1						"Dummy top 3 prods: eggs"
label var W3_top3_noodles_1						"Dummy top 3 prods: noodles"
label var W3_top3_oil_1							"Dummy top 3 prods: oil"
label var W3_top3_saltsugar_1					"Dummy top 3 prods: salt and sugar"
label var W3_top3_bread_1						"Dummy top 3 prods: bread, buns, cakes"
label var W3_top3_coffeetea_1					"Dummy top 3 prods: coffee and tea"
label var W3_top3_homecooked_1					"Dummy top 3 prods: home made food"
label var W3_top3_snacks_1						"Dummy top 3 prods: snacks"
label var W3_top3_freshdrinks_1					"Dummy top 3 prods: fresh drink"
label var W3_top3_softdrinks_1					"Dummy top 3 prods: soft drinks"
label var W3_top3_sanitary_1					"Dummy top 3 prods: sanitary prods"
label var W3_top3_cleaning_1					"Dummy top 3 prods: cleaning prods"
label var W3_top3_baby_1						"Dummy top 3 prods: baby prods"
label var W3_top3_tobacco_1						"Dummy top 3 prods: tobacco and cigarettes"
label var W3_top3_meds_1						"Dummy top 3 prods: drugs and medicines"
label var W3_top3_gaspetrol_1					"Dummy top 3 prods: gas and petrol"
label var W3_top3_phone_1						"Dummy top 3 prods: telecommunication prods"
label var W3_sales_nday_top1shr 			"Prop top 1 sales in total"
label var W3_sales_nday_top3shr 			"Prop top 3 sales in total"
label var W3_dispose_wk 						"Dummy weekly disposal"
label var W3_dispose_wk_val 					"Avg value weekly disposal"
label var W3_dispose_wk_propsales 				"Prop weekly disposal to sales"
label var W3_stockup_top3_fix 					"Dummy stock-up fixed all top 3"
label var W3_stockup_top3_fix_any 				"Dummy stock-up fixed any top 3"
label var W3_stockup_top3_late_any 				"Dummy stock-up late any top 3"
label var W3_stockup_top3_day 					"Dummy stock-up >= daily all top 3"
label var W3_stockup_top3_day_any 				"Dummy stock-up >= daily any top 3"
label var W3_stockup_top3_wk 					"Dummy stock-up <= weekly all top 3"
label var W3_stockout_top3_day_any 				"Dummy stock-out >= daily any top 3"
label var W3_stockout_top3_wk 					"Dummy stock-out >= weekly all top 3"
label var W3_stockout_top3_wk_any 				"Dummy stock-out >= weekly any top 3"
label var W3_bispartner_fam 					"Dummy fam bis partner"
label var W3_labour_total 						"Labour: total excl owner"
label var W3_labour_total_inclowner 			"Labour: total incl owner"
label var W3_labour_fam_full 					"Labour: fam full"
label var W3_labour_fam_full_m 				"Labour: fam full (miss vals)"
label var W3_labour_fam_part 					"Labour: fam part"
label var W3_labour_fam_part_m 				"Labour: fam part (miss vals)"
label var W3_labour_fam 						"Labour: fam full/part"
label var W3_labour_fam_shr 					"Labour: prop fam to total"
label var W3_labour_nonfam_full 				"Labour: non-fam full"
label var W3_labour_nonfam_part 				"Labour: non-fam part"
label var W3_labour_nonfam 						"Labour: non-fam full/part"
label var W3_labour_nonfam_hiredlastyr 			"Labour: non-fam hired last 12 mth"
label var W3_product_lab_sales						"Labour productivity (sales)"
label var W3_product_lab_prof						"Labour productivity (prof)"
label var W3_product_firm							"Firm productivity (opening hours)"
label var W3_product_lab_pplhrs					"Firm productivity (opening hours per person)"
label var W3_rec_pricesuppliers 				"Record: prices diff suppl"
label var W3_rec_pricebrands 					"Record: prices equiv prods diff brands"
label var W3_rec_stockup 						"Record: prod purchases"
label var W3_rec_sales 							"Record: prod sales"
label var W3_rec_assetpurch 					"Record: asset purchases"
label var W3_rec_stocks 						"Record: total stock of prods"
label var W3_rec_accpaysupplier 				"Record: credit from supplier"
label var W3_rec_accpayloan 					"Record: credit from bank"
label var W3_rec_othercosts 					"Record: other costs"
label var W3_rec_accreccustom 					"Record: credit to custom"
label var W3_rec_accreccustom_TC 				"Record: trade credit to custom"
label var W3_rec_accrecfam 						"Record: credit to fam"
label var W3_rec_ledger 						"Record: dummy ledger book"
label var W3_rec_receipts 						"Record: dummy collect receipts"
label var W3_rec_none 							"Record: dummy no records"
label var W3_rec_day 							"Record: dummy daily update"
label var W3_rec_twicewk 						"Record: dummy update >= twice a week update"
label var W3_rec_ledger_day 					"Record: dummy update >= daily ledger prod purch/sales"
label var W3_profcalc_any 					"Profit calc: dummy any calc"
label var W3_profcalc_allcosts 				"Profit calc: dummy all costs"
label var W3_profcalc_stockup 				"Profit calc: dummy stock-up costs"
label var W3_profcalc_nocosts 				"Profit calc: dummy no costs"
label var W3_profcalc_any_day 				"Profit calc: dummy any calc daily"
label var W3_profcalc_any_wk 					"Profit calc: dummy any calc >=weekly"
label var W3_MWM1_visitcompetprice 				"McK&W2016: visit competitors prices"
label var W3_MWM2_visitcompetprod 				"McK&W2016: visit competitors prods"
label var W3_MWM3_askcustomprod 				"McK&W2016: ask custom for new prods"
label var W3_MWM4_askcustomquit 				"McK&W2016: talk to former customers"
label var W3_MWM5_asksupplprod 					"McK&W2016: ask suppliers for well-sell prods"
label var W3_MWM6_attrcustomdisc 				"McK&W2016: attract customers w/ spec offer"
label var W3_MWM7_advert 						"McK&W2016: advertise"
label var W3_MWB1_negosupplprice 				"McK&W2016: negotiate lower price suppl"
label var W3_MWB2_compsupplprod 				"McK&W2016: compare prods between suppliers"
label var W3_MWB3_notOOS 						"McK&W2016: no out-of-stocks"
label var W3_MWR1_recwritten 					"McK&W2016: written bis rec"
label var W3_MWR2_recpurchsale 					"McK&W2016: rec every purch and sale"
label var W3_MWR3_recliquid 					"McK&W2016: use rec cash on hand"
label var W3_MWR4_recsalesprods 				"McK&W2016: use rec sales of prods"
label var W3_MWR5_costprods 					"McK&W2016: calc costs of main prods"
label var W3_MWR6_profprods 					"McK&W2016: items highest mark-up"
label var W3_MWR7_recexpensemth 				"McK&W2016: mthly expense budget"
label var W3_MWR8_recloan 						"McK&W2016: use rec to pay hypo loan"
label var W3_MWF1_finperform 					"McK&W2016: review fin perform"
label var W3_MWF2_settargetyr 					"McK&W2016: set sales target next yr"
label var W3_MWF3_comptargetmth 				"McK&W2016: comp target w sales >= monthly"
label var W3_MWF4_expensenextyr 				"McK&W2016: cost budget next yr"
label var W3_MWF5_proflossyr 					"McK&W2016: ann profit-loss state"
label var W3_MWF6_cashflowyr 					"McK&W2016: ann cash flow state"
label var W3_MWF7_balanceyr 					"McK&W2016: ann balance sheet"
label var W3_MWF8_incexpenseyr 					"McK&W2016: ann inc and expend"
label var W3_MW_resp_total 						"McK&W2016: total answers given"
label var W3_MW_M_resp_total 					"McK&W2016: marketing anwers given"
label var W3_MW_B_resp_total 					"McK&W2016: stock-up answers given"
label var W3_MW_R_resp_total 					"McK&W2016: rec keep answers given"
label var W3_MW_F_resp_total 					"McK&W2016: fin planning answers given"
label var W3_MW_resp_m 						"McK&W2016: miss vals"
label var W3_MW_score_total 					"McK&W2016: total score at EL"
label var W3_MW_M_score_total 					"McK&W2016: marketing score at EL"
label var W3_MW_B_score_total 					"McK&W2016: stock-up score at EL"
label var W3_MW_R_score_total 					"McK&W2016: record-keeping score"
label var W3_MW_F_score_total 					"McK&W2016: fin planning sub-score"
label var W3_MW_percscore_total 				"McK&W2016: total % score at EL"
label var W3_MW_percscore_total_qtile 			"McK&W2016: total % score (qtiles)"
label var W3_MW_M_percscore_total 				"McK&W2016: marketing % score at EL"
label var W3_MW_B_percscore_total 				"McK&W2016: stock-up % score at EL"
label var W3_MW_R_percscore_total 				"McK&W2016: record-keeping % score at EL"
label var W3_MW_F_percscore_total 				"McK&W2016: fin planning % score at EL"
label var W3_separatefin 						"Dummy sep finances"
label var W3_compsales_compet 					"Dummy comp compet sales perform"
label var W3_price_change_comp 					"Dummy price change compet"
label var W3_price_change_demand 				"Dummy price change demand"
label var W3_discount 							"Dummy discount any"
label var W3_discount_bulk 						"Dummy discount bulk"
label var W3_discount_loyal 					"Dummy discount loyal"
label var W3_inventory_change_demand 			"Dummy invent change demand"
label var W3_inventory_change_space 			"Dummy invent change shelf"
label var W3_inventory_change_prof 			"Dummy invent change profit"
label var W3_inventory_change_price 			"Dummy invent change suppl price"
label var W3_prods_new 							"New prods last 12 months"
label var W3_prods_new_1 						"Dummy any new prod last 12 mth"
label var W3_prods_new_5 						"Dummy >= 5 news prods last 12 mth"
label var W3_credit_TC 							"Dummy trade cred"
label var W3_credit_TC_int 						"Dummy trade cred + int"
label var W3_cutcosts_lastyr 					"Prac last yr: cut costs"
label var W3_cutcosts_nextyr 					"Prac next yr: cut costs"
label var W3_changesupplier_lastyr 				"Prac last yr: new suppl"
label var W3_changesupplier_nextyr 				"Prac next yr: new suppl"
label var W3_prodquality_lastyr 				"Prac last yr: higher qual prods"
label var W3_prodquality_nextyr 				"Prac next yr: higher qual prods"
label var W3_newbrand_lastyr 					"Prac last yr: new brand"
label var W3_newbrand_nextyr 					"Prac next yr: new brand"
label var W3_newbranch_lastyr 					"Prac last yr: new branch"
label var W3_newbranch_nextyr 					"Prac next yr: new branch"
label var W3_delegate_lastyr 					"Prac last yr: delegate tasks employ"
label var W3_delegate_nextyr 					"Prac next yr: delegate tasks employ"
label var W3_bisplan_lastyr 					"Prac last yr: bis plan"
label var W3_bisplan_nextyr 					"Prac next yr: bis plan"
label var W3_startrec_lastyr 					"Prac last yr: improve record-keeping"
label var W3_startrec_nextyr 					"Prac next yr: improve record-keeping"
label var W3_loan_lastyr 						"Prac last yr: apply for loan"
label var W3_loan_nextyr 						"Prac next yr: apply for loan"
label var W3_coopcompet_lastyr 					"Prac last yr: coop with compet"
label var W3_coopcompet_nextyr 					"Prac next yr: coop with compet"
label var W3_vat_lastyr 						"Prac last yr: reg VAT"
label var W3_vat_nextyr 						"Prac next yr: reg VAT"
label var W3_practices_lastyr 					"Prac last yr: total score"
label var W3_practices_lastyr_abvmd 			"Prac last yr: total score above md"
label var W3_practices_nextyr 					"Prac next yr: total score"
label var W3_practices_nextyr_abvmd 			"Prac next yr: total score above md"
label var W3_practices_nextyr_diff 				"Diff score prac next yr/last yr"
label var W3_practices_nextyr_diff_0 			"Dummy diff score prac next yr/last yr <=0"
label var W3_socialcomp_super 					"Dummy prac social comp superior"
label var W3_socialcomp_infer 					"Dummy prac social comp superior"
label var W3_socialcomp_refuse 					"Dummy prac social comp refused"
label var W3_discuss_any 						"Dummy discuss bis any"
label var W3_discuss_any_daily 					"Dummy discuss bis any daily"
label var W3_discuss_sales 						"Dummy discuss bis sales"
label var W3_discuss_sales_wk 					"Dummy discuss bis sales wkly"
label var W3_discuss_sellprice 				"Dummy discuss bis sell price"
label var W3_discuss_sellprice_wk 			"Dummy discuss bis sell price wkly"
label var W3_discuss_bestseller 				"Dummy discuss bis best sell prod"
label var W3_discuss_bestseller_wk 				"Dummy discuss bis best sell prod wkly"
label var W3_discuss_finance 					"Dummy discuss bis finance"
label var W3_discuss_buyprice 				"Dummy discuss bis purch price"
label var W3_discuss_newprod 					"Dummy discuss bis new prod"
label var W3_discuss_newprod_wk 				"Dummy discuss bis new prod wkly"
label var W3_discuss_practice 					"Dummy discuss bis practices"
label var W3_discuss_practice_wk 				"Dummy discuss bis practices wkly"
label var W3_discuss_bisplan 					"Dummy discuss bis bis plan"
label var W3_discuss_bisplan_wk 				"Dummy discuss bis bis plan wkly"
label var W3_discuss_fam 						"Dummy discuss bis fam"
label var W3_discuss_friend 					"Dummy discuss bis pers friend"
label var W3_discuss_bisfriend 					"Dummy discuss bis bis friend"
label var W3_discuss_supplier 					"Dummy discuss bis suppl"
label var W3_jointdec_any 						"Dummy joint dec any"
label var W3_jointdec_agree 					"Dummy joint dec informal agree"
label var W3_jointdec_any_day 					"Dummy joint dec daily"
label var W3_jointdec_sales 					"Dummy joint dec sales"
label var W3_jointdec_sales_wk 					"Dummy joint dec sales wkly"
label var W3_jointdec_sellprice 				"Dummy joint dec sell price"
label var W3_jointdec_sellprice_wk 			"Dummy joint dec sell price wkly"
label var W3_jointdec_bestseller 				"Dummy joint dec best sell prod"
label var W3_jointdec_bestseller_wk 			"Dummy joint dec best sell prod wkly"
label var W3_jointdec_finance 					"Dummy joint dec finance"
label var W3_jointdec_buyprice 					"Dummy joint dec purch price"
label var W3_jointdec_newprod 					"Dummy joint dec new prod"
label var W3_jointdec_newprod_wk 				"Dummy joint dec new prod wkly"
label var W3_jointdec_practice 					"Dummy joint dec practices"
label var W3_jointdec_practice_wk 				"Dummy joint dec practices wkly"
label var W3_jointdec_bisplan 					"Dummy joint dec bis plan"
label var W3_jointdec_bisplan_wk 				"Dummy joint dec bis plan wkly"
label var W3_jointdec_fam 						"Dummy joint dec fam"
label var W3_loans_applied						"No of loans applied for in last 12 mth at EL"
label var W3_loans_obtained 					"No of loans obtained in last 12 mth at EL"
label var W3_loans_principal 					"Total principal owed at EL"
label var W3_loan_obtained 						"Dummy for having obtained any loan in last 12 mth"
label var W3_loans_principal_prop 				"Principal owed in prop to profits last month at EL"
label var W3_finlit_int 						"Fin literacy: interest"
label var W3_finlit_compoundint 				"Fin literacy: compound interest"
label var W3_finlit_score 						"Fin literacy: comp score"
label var W3_save_daily							"Dummy for saving daily at EL"
label var W3_save_daily_fix_amt					"Daily savings if saved as fixed amount"
label var W3_save_daily_prop_amt				"Daily savings if saved as % of daily sales"
label var W3_save_daily_amt						"Daily savings at EL"
label var W3_space_cont 						"Shop size at EL"
label var W3_asp_ideal_space 					"Ideal shop size aspirations at EL"
label var W3_asp_ideal_employ 					"Ideal employee aspirations at EL"
label var W3_asp_ideal_custom 					"Ideal customer aspirations at EL"
label var W3_asp_ideal_shop 					"Ideal shop aspirations at EL"
label var W3_asp_gap3_ideal_space 				"Asp gap: ideal size (normalized by EL VALUE!)"
label var W3_asp_gap3_ideal_employ 				"Asp gap: ideal employ (normalized by EL VALUE!)"
label var W3_asp_gap3_ideal_custom 				"Asp gap: ideal custom (normalized by EL VALUE!)"
label var W3_asp_gap3_ideal_space_neg 			"Asp gap: dummy ideal size <0"
label var W3_asp_gap3_ideal_space_0 				"Asp gap: dummy ideal size =0"
label var W3_asp_gap3_ideal_space_pos 			"Asp gap: dummy ideal size >0"
label var W3_asp_gap3_ideal_employ_neg 			"Asp gap: dummy ideal employ <0"
label var W3_asp_gap3_ideal_employ_0 			"Asp gap: dummy ideal employ =0"
label var W3_asp_gap3_ideal_employ_pos 			"Asp gap: dummy ideal employ >0"
label var W3_asp_gap3_ideal_custom_neg 			"Asp gap: dummy ideal custom <0"
label var W3_asp_gap3_ideal_custom_0 			"Asp gap: dummy ideal custom =0"
label var W3_asp_gap3_ideal_custom_pos 			"Asp gap: dummy ideal custom >0"
label var W3_asp_ideal_yrs 						"Aspiration horizon at EL"
label var W3_asp_ideal_yrs_dk 					"Aspiration horizon (dk/refused) at EL"
label var W3_asp_ideal_space_mu 				"Asp: ideal size (mu)"
label var W3_asp_ideal_space_sd 				"Asp: ideal size (sd)"
label var W3_asp_ideal_space_z 					"Asp: ideal size (z)"
label var W3_asp_ideal_employ_mu 				"Asp: ideal employees (mu)"
label var W3_asp_ideal_employ_sd 				"Asp: ideal employees (sd)"
label var W3_asp_ideal_employ_z 				"Asp: ideal employees (z)"
label var W3_asp_ideal_custom_mu 				"Asp: ideal customers (mu)"
label var W3_asp_ideal_custom_sd 				"Asp: ideal customers (sd)"
label var W3_asp_ideal_custom_z 				"Asp: ideal customers (z)"
label var W3_asp_gap3_ideal_space_mu 			"Asp gap: ideal space (mu)"
label var W3_asp_gap3_ideal_space_sd 			"Asp gap: ideal space (sd)"
label var W3_asp_gap3_ideal_space_z 				"Asp gap: ideal space (z)"
label var W3_asp_gap3_ideal_employ_mu 			"Asp gap: ideal employees (mu)"
label var W3_asp_gap3_ideal_employ_sd 			"Asp gap: ideal employees (sd)"
label var W3_asp_gap3_ideal_employ_z 			"Asp gap: ideal employee (z)"
label var W3_asp_gap3_ideal_custom_mu 			"Asp gap: ideal customers (mu)"
label var W3_asp_gap3_ideal_custom_sd 			"Asp gap: ideal customers (sd)"
label var W3_asp_gap3_ideal_custom_z 			"Asp gap: ideal customers (z)"
label var W3_asp_gap3_ideal_shop 				"Asp gap: ideal shop composite"
label var W3_asp_12mth_space_mu 				"Asp: 12 months size (mu)"
label var W3_asp_12mth_space_sd 				"Asp: 12 months size (sd)"
label var W3_asp_12mth_space_z 					"Asp: 12 months size (z)"
label var W3_asp_12mth_employ_mu 				"Asp: 12 months employees (mu)"
label var W3_asp_12mth_employ_sd 				"Asp: 12 months employees (sd)"
label var W3_asp_12mth_employ_z 				"Asp: 12 months employees (z)"
label var W3_asp_12mth_custom_mu 				"Asp: 12 months customers (mu)"
label var W3_asp_12mth_custom_sd 				"Asp: 12 months customers (sd)"
label var W3_asp_12mth_custom_z 				"Asp: 12 months customers (z)"
label var W3_asp_12mth_space 					"12mth shop size aspirations at EL"
label var W3_asp_12mth_employ 					"12mth employee aspirations at EL"
label var W3_asp_12mth_custom 					"12mth customer aspirations at EL"
label var W3_asp_12mth_shop 					"12 mth shop aspirations at EL"
label var W3_asp_gap3_12mth_space_mu 			"Asp gap: 12 mth space (mu)"
label var W3_asp_gap3_12mth_space_sd 			"Asp gap: 12 mth space (sd)"
label var W3_asp_gap3_12mth_space_z 				"Asp gap: 12 mth space (z)"
label var W3_asp_gap3_12mth_employ_mu 			"Asp gap: 12 mth employees (mu)"
label var W3_asp_gap3_12mth_employ_sd 			"Asp gap: 12 mth employee (sd)"
label var W3_asp_gap3_12mth_employ_z 			"Asp gap: 12 mth employee (z)"
label var W3_asp_gap3_12mth_custom_mu 			"Asp gap: 12 mth customers (mu)"
label var W3_asp_gap3_12mth_custom_sd 			"Asp gap: 12 mth customers (sd)"
label var W3_asp_gap3_12mth_custom_z 			"Asp gap: 12 mth customers (z)"
label var W3_asp_gap3_12mth_shop 				"Asp gap: 12 mth shop composite"
label var W3_asp_fail 							"Imagination failure at EL"
label var W3_asp_gap3_12mth_space 				"12mth shop space aspiration gap at EL (normalized by EL VALUE!)"
label var W3_asp_gap3_12mth_employ 				"12mth employee aspiration gap at EL (normalized by EL VALUE!)"
label var W3_asp_gap3_12mth_custom 				"12mth customer aspiration gap at EL (normalized by EL VALUE!)"
label var W3_asp_gap3_12mth_space_neg 			"Asp gap: dummy 12mth size <0"
label var W3_asp_gap3_12mth_space_0 				"Asp gap: dummy 12mth size =0"
label var W3_asp_gap3_12mth_space_pos 			"Asp gap: dummy 12mth size >0"
label var W3_asp_gap3_12mth_employ_neg 			"Asp gap: dummy 12mth employ <0"
label var W3_asp_gap3_12mth_employ_0 			"Asp gap: dummy 12mth employ =0"
label var W3_asp_gap3_12mth_employ_pos 			"Asp gap: dummy 12mth employ >0"
label var W3_asp_gap3_12mth_custom_neg 			"Asp gap: dummy 12mth custom <0"
label var W3_asp_gap3_12mth_custom_0 			"Asp gap: dummy 12mth custom =0"
label var W3_asp_gap3_12mth_custom_pos 			"Asp gap: dummy 12mth custom >0"
label var W3_asp_gap3_employ_neg_rebound 		"Asp gap: dummy 12mth employ <0 rebound"
label var W3_asp_gap3_employ_neg_perm 			"Asp gap: dummy 12mth employ <0 perm"
label var W3_asp_12mth_lpred_space 				"Asp: Lin predict 12mth size asp"
label var W3_asp_12mth_lpred_employ 			"Asp: Lin predict 12mth employ asp"
label var W3_asp_12mth_lpred_custom 			"Asp: Lin predict 12mth custom asp"
label var W3_asp_12mth_resid_space 				"Asp: Lin predict 12mth size asp residual"
label var W3_asp_12mth_resid_employ 			"Asp: Lin predict 12mth employ asp residual"
label var W3_asp_12mth_resid_custom 			"Asp: Lin predict 12mth custom asp residual"
label var W3_asp_12mth_fail_space 				"Asp: Dummy asp 12mth size < lin predict"
label var W3_asp_12mth_fail_employ 				"Asp: Dummy asp 12mth employ < lin predict"
label var W3_asp_12mth_fail_custom 				"Asp: Dummy asp 12mth custom < lin predict"
label var W3_asp_12mth_sales 					"Asp: 12mth sales"
label var W3_asp_gap3_12mth_sales 				"Asp gap: 12mth sales"
label var W3_asp_gap3_12mth_sales_neg 			"Asp gap: dummy 12mth sales <0"
label var W3_asp_gap3_12mth_sales_0 				"Asp gap: dummy 12mth sales =0"
label var W3_asp_gap3_12mth_sales_pos 			"Asp gap: dummy 12mth sales >0"
label var W3_asp_import_sales 					"Subj. importance to reach 12mth asps"
label var W3_asp_import_sales_highest 			"Dummy for highest subj. import to reach 12mth asps"
label var W3_asp_import_sales_scaled 			"Subj. importance to reach 12mth asps"
label var W3_asp_prob_sales 					"Subj. probability to reach 12mth asps"
label var W3_asp_prob_sales_highest 			"Dummy for highest subj. prob to reach 12mth asps"
label var W3_asp_prob_sales_scaled 				"Subj. probability to reach 12mth asps"
label var W3_asp_seff_sales 					"Perc. self-efficacy to reach 12mth asps"
label var W3_asp_seff_sales_highest 			"Dummy for highest perc. self-eff to reach 12mth asps"
label var W3_asp_seff_sales_scaled 				"Perc. self-efficacy to reach 12mth asps"
label var W3_asp_loc_sales 						"Perc. LOC to reach 12mth asps"
label var W3_asp_loc_sales_highest 				"Dummy for highest perc. LOC to reach 12mth asps"
label var W3_asp_loc_sales_scaled 				"Perc. LOC to reach 12mth asps"
label var W3_asp_cse_sales_scaled				"Perc. CSE to reach 12mth asps "
label var W3_asp_ideal_shop_yrs 				"Asp ideal shop: per year"
label var W3_asp_gap3_ideal_shop_yrs 			"Asp gap ideal shop: per year"
label var W3_asp_ideal_shop_cse 				"Ideal belief-based aspiration at EL"
label var W3_asp_ideal_shop_probimp 			"Asp ideal shop: weight prob, import"
label var W3_asp_12mth_shop_cse 				"12 mth belief-based aspiration at EL"
label var W3_asp_12mth_shop_probimp 			"12 mth aspiration weighted by importance"
label var W3_asp_gap3_ideal_shop_seff 			"Ideal belief-based aspiration gap at EL"
label var W3_asp_gap3_ideal_shop_cse 			"Ideal belief-based aspiration gap at EL"
label var W3_asp_gap3_ideal_shop_imp 			"Asp gap ideal shop: weight import"
label var W3_asp_gap3_ideal_shop_prob 			"Asp gap ideal shop: weight prob"
label var W3_asp_gap3_ideal_shop_cseimp 			"Asp gap ideal shop: weight self-eff/LOC, import"
label var W3_asp_gap3_ideal_shop_probimp 		"Asp gap ideal shop: weight prob, import"
label var W3_asp_gap3_12mth_shop_seff 			"12 mth belief-based aspiration gap at EL"
label var W3_asp_gap3_12mth_shop_cse 			"12 mth belief-based aspiration gap at EL"
label var W3_asp_gap3_12mth_shop_imp 			"12 mth aspiration gap weighted by importance"
label var W3_asp_gap3_12mth_shop_cseimp 			"Asp gap 12mth shop: weight self-eff/LOC, import"
label var W3_asp_gap3_12mth_shop_probimp 		"Asp gap 12mth shop: weight prob-import"
label var W3_asp_12mth_space_cse				"12mth belief-based shop space aspirations at EL"
label var W3_asp_12mth_space_probimp			"12mth shop space aspiration: weighted by prob/import"
label var W3_asp_gap3_12mth_space_cse			"12mth belief-based shop space aspiration gap at EL"
label var W3_asp_gap3_12mth_space_probimp		"12mth shop space aspiration gap: weight import"
label var W3_asp_12mth_employ_cse				"12mth belief-based employee aspirations at EL"
label var W3_asp_12mth_employ_probimp			"12mth employee aspiration: weight prob/import"
label var W3_asp_gap3_12mth_employ_cse			"12mth belief-based employee aspiration gap at EL"
label var W3_asp_gap3_12mth_employ_probimp		"12mth employee aspiration gap: weight prob/import"
label var W3_asp_12mth_custom_cse				"12mth belief-based customers aspirations at EL"
label var W3_asp_12mth_custom_probimp			"12mth customers aspiration: weight prob/import"
label var W3_asp_gap3_12mth_custom_cse			"12mth belief-based customers aspiration gap at EL"
label var W3_asp_gap3_12mth_custom_probimp		"12mth customers aspiration gap: weight prob/import"
label var W3_asp_12mth_sales_cse				"12mth belief-based sales aspirations at EL"
label var W3_asp_12mth_sales_probimp			"12mth sales aspiration: weight prob/import"
label var W3_asp_gap3_12mth_sales_cse			"12mth belief-based sales aspiration gap at EL"
label var W3_asp_gap3_12mth_sales_probimp		"12mth sales aspiration gap: weight prob/import"
label var W3_asp_min_sales 					"Minimum profits to get by with at EL"
label var W3_asp_gap3_min_prof 				"Asp gap: Min profits"
label var W3_asp_gap3_min_prof_ihs 			"Asp gap: Min profits (IHS)"
label var W3_asp_18mth_sales 					"Asp: 18 months profits"
label var W3_asp_18mth_sales 					"Asp: 18 months sales"
label var W3_asp_gap3_18mth_prof 				"Asp gap: 18 mth profits"
label var W3_asp_gap3_18mth_prof_neg 			"Asp gap: dummy 18 mth profits <0"
label var W3_asp_gap3_18mth_prof_0 			"Asp gap: dummy 18 mth profits =0"
label var W3_asp_gap3_18mth_prof_pos 			"Asp gap: dummy 18 mth profits >0"
label var W3_asp_gap3_18mth_sales 				"Asp gap: 18 mth sales (from prof data)"
label var W3_asp_occup_son_oth 					"Asp: son's occup other"
label var W3_asp_occup_son_employ 				"Asp: son's occup employee"
label var W3_asp_occup_son_entrep 				"Asp: son's occup entrepreneur"
label var W3_asp_occup_son 						"Asp: son's occup"
label var W3_asp_occup_dtr_oth 			"Asp: daughter's occup other"
label var W3_asp_occup_dtr_employ 			"Asp: daughter's occup employee"
label var W3_asp_occup_dtr_entrep 			"Asp: daughter's occup entrepreneur"
label var W3_asp_occup_dtr 				"Asp: daughter's occup"
label var W3_son1_age 							"Son's age (1)"
label var W3_son2_age 							"Son's age (2)"
label var W3_son3_age 							"Son's age (3)"
label var W3_oldestson_age 						"Oldest son's age"
label var W3_asp_educ_son 						"Asp: son's educ years"
label var W3_asp_educ_son_ma 					"Asp: dummy son's educ master's"
label var W3_asp_occup_son_AM 				"Asp: dummy son's occup (high asp)"
label var W3_asp_occup_son_govt 				"Asp: dummy son's occup gov't"
label var W3_dtr1_age 						"Daughter age (1)"
label var W3_dtr2_age 						"Daughter age (2)"
label var W3_dtr3_age 						"Daughter age (3)"
label var W3_oldestdtr_age 				"Oldest daughter's age"
label var W3_asp_educ_dtr 					"W3_asp_educ_daughter"
label var W3_asp_educ_dtr_ma 				"Asp: dummy daughter's educ master's"
label var W3_asp_occup_dtr_AM 			"Asp: dummy daughter's occup (high asp)"
label var W3_asp_occup_dtr_govt 			"Asp: dummy daughter's occup gov't"
label var W3_asp_educ_kids 						"Aspiration for kids' education (oldest U18)"
label var W3_asp_occup_kids						"Aspiration for kids' occupation (oldest U18)"
label var W3_asp_educ_kids_AM 				"Asp: kids' educ (abvmc)"
label var W3_asp_occup_kids_AM 				"Asp: kids' occup (abvmd) "
label var W3_asp_occup_kids_govt 				"Asp: kids' occup govt"
label var W3_practices_free_score 				"3 most profitable practices (open question)"
label var W3_practices_free_lastyr 				"3 most profitable practices: last year"
label var W3_practices_free_nextyr 				"3 most profitable practices: next year"
label var W3_MW_M_space_12mth 					"McK-W x Asp: marketing, 12 mth space"
label var W3_MW_B_space_12mth 					"McK-W x Asp: stock-up, 12 mth space"
label var W3_MW_R_space_12mth 					"McK-W x Asp: record-keeping, 12 mth space"
label var W3_MW_F_space_12mth 					"McK-W x Asp: fin planning, 12 mth space"
label var W3_MW_M_employ_12mth 					"McK-W x Asp: marketing, 12 mth employ"
label var W3_MW_B_employ_12mth 					"McK-W x Asp: stock-up, 12 mth employ"
label var W3_MW_R_employ_12mth 					"McK-W x Asp: record-keeping, 12 mth employ"
label var W3_MW_F_employ_12mth 					"McK-W x Asp: fin planning, 12 mth employ"
label var W3_MW_M_custom_12mth 					"McK-W x Asp: marketing, 12 mth custom"
label var W3_MW_B_custom_12mth 					"McK-W x Asp: stock-up, 12 mth custom"
label var W3_MW_R_custom_12mth 					"McK-W x Asp: record-keeping, 12 mth custom"
label var W3_MW_F_custom_12mth 					"McK-W x Asp: fin planning, 12 mth custom"
label var W3_MW_M_sales_12mth 					"McK-W x Asp: marketing, 12 mth sales"
label var W3_MW_B_sales_12mth 					"McK-W x Asp: stock-up, 12 mth sales"
label var W3_MW_R_sales_12mth 					"McK-W x Asp: record-keeping, 12 mth sales"
label var W3_MW_F_sales_12mth 					"McK-W x Asp: fin planning, 12 mth sales"
label var W3_MW_M_sales_18mth 					"McK-W x Asp: marketing, 18 mth sales"
label var W3_MW_B_sales_18mth 					"McK-W x Asp: stock-up, 18 mth sales"
label var W3_MW_R_sales_18mth 					"McK-W x Asp: record-keeping, 18 mth sales"
label var W3_MW_F_sales_18mth 					"McK-W x Asp: fin planning, 18 mth sales"
label var W3_MW_M_space_ideal 					"McK-W x Asp: marketing, ideal space"
label var W3_MW_B_space_ideal 					"McK-W x Asp: stock-up, ideal space"
label var W3_MW_R_space_ideal 					"McK-W x Asp: record-keeping, ideal space"
label var W3_MW_F_space_ideal 					"McK-W x Asp: fin planning, ideal space"
label var W3_MW_M_employ_ideal 					"McK-W x Asp: marketing, ideal employ"
label var W3_MW_B_employ_ideal 					"McK-W x Asp: stock-up, ideal employ"
label var W3_MW_R_employ_ideal 					"McK-W x Asp: record-keeping, ideal employ"
label var W3_MW_F_employ_ideal 					"McK-W x Asp: fin planning, ideal employ"
label var W3_MW_M_custom_ideal 					"McK-W x Asp: marketing, ideal custom"
label var W3_MW_B_custom_ideal 					"McK-W x Asp: stock-up, ideal custom"
label var W3_MW_R_custom_ideal 					"McK-W x Asp: record-keeping, ideal custom"
label var W3_MW_F_custom_ideal 					"McK-W x Asp: fin planning, ideal custom"
label var W3_MW_M_fail 							"McK-W x Asp: marketing, imagination fail"
label var W3_MW_B_fail 							"McK-W x Asp: stock-up, imagination fail"
label var W3_MW_R_fail 							"McK-W x Asp: record-keeping, imagination fail"
label var W3_MW_F_fail 							"McK-W x Asp: fin planning, imagination fail"
label var W3_satisfac_life						"Satisfaction: current life"
label var W3_satisfac_fin						"Satisfaction: current financial condition"
label var W3_book_prof							"Dummy for thinking handbook increased/would increase profits"
label var W3_book_prof_perc						"Expected increase in profits due to handbook in %"
label var W3_present_spouse 					"Enum comments: dummy spouse present"
label var W3_present_family						"Interviewer impressions: adult family member"
label var W3_present_otheradult 				"Enum comments: dummy non-fam present"
label var W3_present_child_under5 				"Enum comments: dummy <=5 yo child"
label var W3_present_child_over5 				"Enum comments: dummy >5 yo child"
label var W3_present_employee 					"Enum comments: dummy employee present"
label var W3_present_sm 						"Enum comments: dummy supervisor present"
label var W3_present_jpal 						"Enum comments: dummy J-PAL/ TiU present"
label var W3_present_tv 						"Enum comments: dummy TV running"
label var W3_present_custom 					"Enum comments: dummy any custom present"
label var W3_present_custom_no 					"Enum comments: total customers coming"
label var W3_understand_perfect 				"Enum comments: dummy perfect comprehension"
label var W3_shop_house_same 					"Enum comments: dummy shop loc = home"
label var W3_shop_house_sep 					"Enum comments: dummy shop loc != home"
label var W3_shop_sign_bright 					"Shop appear: dummy sign bright/new"
label var W3_shop_sign 							"Shop appear: dummy sign visiELe"
label var W3_shop_goods_prices 					"Shop appear: dummy display prices"
label var W3_shop_goods_display 				"Shop appear: dummy display goods"
label var W3_shop_shelf_full					"Store appearance: dummy shelves full"
label var W3_shop_advert 						"Shop appear: dummy adverts"
label var W3_shop_clean 						"Shop appear: dummy clean"
label var W3_shop_bright 						"Shop appear: dummy well lit"
*/


********************************************************************************
***** VAR MANAGEMENT

* Drop original vars
//drop f4_* *srid type_* *_md


* Add prefix to identify endline vars after merge
ds shop_ID, not
foreach x in `r(varlist)' {
	rename `x' W3_`x'
}

* Order vars
order shop_ID


********************************************************************************
***** SAVE DATA

save "Data\Endline Data\W3_clean_data.dta", replace
