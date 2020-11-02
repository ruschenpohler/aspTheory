
********************************************************************************
************** 		RETAILERS INDONESIA PROJECT, 2016-2017 		****************
*
*
*				 Data management do-file for baseline data
*
*			 
********************************************************************************


clear all
set more off

cd "`c(pwd)'\"

use "dta\BL_raw_data.dta", clear



/***** OVERVIEW ************************************************

1. General									

2. Owner characteristics					
	+ psych scales
	
3. Firm characteristics						

4. Sales									

5. Expenses									

6. Profits									

7. Products & services						

8. Employees								

9. Productivity								

10. Record keeping and profit calcs			

11. McKenzie and Woodruff's practices		

12. Other practices							

13. Discussion and decision-making			

14. Loans & fin								

15. Aspirations								

16. Interviewer impressions							

17. Own business-practices composite score	*/



************************************************************************
***** GENERAL *****************************************************


***** UNFINISHED INTERVIEWS

*** Drop all but fully finished interviews --> 1263 obs (919 missing obs)!
////tab f4_17_01
mdesc f4_17_01
drop if f4_17_01 != 1


***** EXCHANGE RATE
* All sales/expenses/profits data converted to USD PPP with IDR 4052.20 = USD 1
* from WB data, 2015:  http://data.worldbank.org/indicator/PA.NUS.PPP
gen xchange = 4052.20


***** ID

* Destring

destring basesrid , replace
gen shop_ID = basesrid



***** LOCATION

*** Coordinates

* Elevation
gen gps_elevat = f322_d

* Deg, min, sec

egen gps_dms_temp1 = concat(f322_a2 f322_a3), punct(" ")
egen gps_dms_temp2 = concat(f322_b2 f322_b3), punct(" ")

egen gps_dms_lat = concat(f322_a1 gps_dms_temp1), punct("")
egen gps_dms_long = concat(f322_b1 gps_dms_temp2), punct("")

gen gps_dms_lat_sig = f322_a1
gen gps_dms_lat_deg = f322_a2
gen gps_dms_lat_min = f322_a3

gen gps_dms_long_sig= f322_b1
gen gps_dms_long_deg= f322_b2
gen gps_dms_long_min= f322_b3

egen gps_dms_latlong = concat(gps_dms_lat_deg gps_dms_lat_min gps_dms_long_deg gps_dms_long_min), punct("; ")

* Decimal degrees
gen gps_dec_lat = gps_dms_lat_deg + (gps_dms_lat_min/60)
gen gps_dec_long = gps_dms_long_deg + (gps_dms_long_min/60)


*** Village codes

gen village = f4_1_3_cd*1000 + f4_1_4_cd + f4_1_5_cd



************************************************************************
***** MANAGER CHARACTERISTICS ********************************************

***** AGE

gen age_temp1 = 2016 - f4_2_3b_yr
gen age_temp2 = 2016 - f4_2_4b_yr

* Detect missing values in both age vars --> 234 obs!
////tab age_temp1
////tab age_temp2
mdesc age_temp1 age_temp2

* Merging existant gender vars
gen age_manager= string(age_temp1)+string(age_temp2)
destring age_manager, replace ignore(".")

* Detect missing values in merged age var --> none!
////tab age_manager
mdesc age_manager

* Treating 1 extreme value as missing data --> 1 obs!
replace age_manager =. if age_manager<14
////tab age_manager

* Drop temporary vars
drop age_temp1 age_temp2

* Median manager age
egen age_manager_md = median(age_manager)
* Dummy for being above median age
gen age_manager_abvmd = 1 if age_manager>age_manager_md
replace age_manager_abvmd = 0 if age_manager_abvmd==.


***** GENDER

gen gender_temp1 = f4_2_3a
gen gender_temp2 = f4_2_4a

* Detect missing values in both gender vars --> 234 obs!
////tab gender_temp1
////tab gender_temp2
mdesc gender_temp1 gender_temp2

* Recoding "no" answers
replace gender_temp1 = 0 if gender_temp1==3
replace gender_temp2 = 0 if gender_temp2==3

* Merging existant gender vars
gen male= string(gender_temp1)+string(gender_temp2)
destring male, replace ignore(".")

* Detect missing values in merged gender var --> none!
////tab male
mdesc male

* Drop temporary vars
drop gender_temp1 gender_temp2


***** OFFSPRING

* Detect missing values in offspring var --> none!
mdesc f4_10_4a1_age f4_10_4a2_age f4_10_4a3_age f4_10_5a1_age ///
f4_10_5a2_age f4_10_5a3_age

* Dummy for having children
////tab f4_10_4a1_age
////tab f4_10_5a1_age
gen kids_1 = 1 if f4_10_4a1_age!=0 | f4_10_5a1_age!=0
replace kids_1 = 0 if f4_10_4a1_age==. & f4_10_5a1_age==.
mdesc kids_1

* Dummy for having at least 3 children
gen kids_3 = 1 if (f4_10_4a1_age!=. & f4_10_4a2_age!=. & f4_10_4a3_age!=.) ///
| (f4_10_4a1_age!=. & f4_10_4a2_age!=. & f4_10_5a1_age!=.) ///
| (f4_10_4a1_age!=. & f4_10_5a1_age!=. & f4_10_5a2_age!=.) ///
| (f4_10_5a1_age!=. & f4_10_5a2_age!=. & f4_10_5a3_age!=.)
replace kids_3 = 0 if kids_3==.
////tab kids_3

* Dummy for having at least 1 child under 7 ( age of primary school entry)
gen kids_young_1 = 1 if f4_10_4a1_age<7 | f4_10_4a2_age<7 | f4_10_4a3_age<7 | ///
f4_10_5a1_age<7 | f4_10_5a2_age<7 | f4_10_5a3_age<7
replace kids_young_1 = 0 if kids_young_1==.


***** EDUCATION

* Detect missing values in both education vars --> 234 obs!
////tab f4_2_3d
////tab f4_2_4d
mdesc f4_2_3d f4_2_4d

* Stacking existant educ vars
gen educ= string(f4_2_3d)+string(f4_2_4d)
destring educ, replace ignore(".")

* Detect missing values in merged gender var --> none!
////tab educ
mdesc educ

* Create dummies for finished secondary educ and BA degree
gen educ_second = 1 if educ>=12
replace educ_second = 0 if educ_second==.
gen educ_terc = 1 if educ>=16
replace educ_terc = 0 if educ_terc==.


***** MOTIVATION TO MANAGE FIRM

*** Missing values
* Detect missing values in both education vars --> none!
mdesc f4_3_3_D f4_3_3_P
mdesc f4_3_3_E f4_3_3_F f4_3_3_M
mdesc f4_3_3_C f4_3_3_L f4_3_3_Q f4_3_3_R 
mdesc f4_3_3_H f4_3_3_I
* Dummy for entrepreneurial motivation
////tab f4_3_3_D
////tab f4_3_3_P
gen motive_entrep = 1 if f4_3_3_D==1 | f4_3_3_L==1 | f4_3_3_P==1
replace motive_entrep = 0 if motive_entrep==.
* Dummy for inheritance or continuation as motivation
////tab f4_3_3_E
////tab f4_3_3_F
////tab f4_3_3_M
gen motive_continue = 1 if f4_3_3_E==1 | f4_3_3_F==1 | f4_3_3_M==1
replace motive_continue = 0 if motive_continue==.
* Dummy for retirement, hobby, or spare time engagement or to balance life and work
////tab f4_3_3_C
////tab f4_3_3_L
////tab f4_3_3_Q
////tab f4_3_3_R
gen motive_hobby = 1 if f4_3_3_C==1 | f4_3_3_L==1 | f4_3_3_Q==1 | f4_3_3_R==1
replace motive_hobby = 0 if motive_hobby==.
* Dummy when hard to get job or lost previous job (low opportunity costs)
////tab f4_3_3_H
////tab f4_3_3_I
gen motive_lowOC = 1 if f4_3_3_H==1 | f4_3_3_I==1
replace motive_lowOC = 0 if motive_lowOC==.
* Dummy for hobby etc. and low opportunity cost
gen motive_weak = 1 if motive_hobby==1 | motive_lowOC==1
replace motive_weak = 0 if motive_weak==.

* Dummy for fam business
gen motive_fambis = 1 if f4_3_3_E==1
replace motive_fambis = 0 if motive_fambis==.

////tab motive_entrep
////tab motive_continue
////tab motive_hobby
//tab motive_lowOC
//tab motive_fambis

* Gen continuation + fambis
gen motive_cont_fam = 1 if motive_continue==1 | motive_fambis==1
replace motive_cont_fam = 0 if missing(motive_cont_fam)

***** DIGITSPAN (STM & WM, INTELLIGENCE)

egen digitspan = rowtotal(f4_6_001 f4_6_002 f4_6_003 f4_6_004 ///
f4_6_005 f4_6_006 f4_6_007 f4_6_008)  		
egen digitspan_rev = rowtotal( f4_6_xx1 f4_6_xx2 f4_6_xx3 f4_6_xx4 ///
f4_6_xx5 f4_6_xx6 f4_6_xx7 f4_6_xx8)
gen digitspan_total = (digitspan + digitspan_rev)/2

* Detect missing values in digitspan var --> none!
//tab digitspan
//tab digitspan_rev
//tab digitspan_total
mdesc digitspan digitspan_rev


***** TRUST

*** Missing values
* Detect missing values in practices vars --> none!
mdesc f4_11_01 f4_11_02 f4_11_03 f4_11_04 f4_11_05 f4_11_06 f4_11_07 f4_11_08
* Idk's, etc. as missing values
//tab f4_11_01 // 5 idk's, 82 N/A
levelsof f4_11_01
//tab f4_11_02 // 2 idk's
//tab f4_11_03 // 1 idk
//tab f4_11_04 // 48 idk's, 3 not answering
levelsof f4_11_04
//tab f4_11_05 // 2 idk's, 1 not answering
//tab f4_11_06 // 3 idk's, 1 not answering (?)
//tab f4_11_07 // 9 idk's, 2 N/A
//tab f4_11_08 // 3 idk's

*** Trust in employees
gen trust_employ = f4_11_01

*** Trust in suupliers
gen trust_suppl = f4_11_02

*** Trust in customers
gen trust_custom = f4_11_03

*** Trust in other shop's owners
gen trust_othfirm = f4_11_04

*** Trust in family
gen trust_fam = f4_11_05

*** Trust in neighbours
gen trust_neigh = f4_11_06

*** Trust in friends
gen trust_friend = f4_11_07

*** Trust in strangers (outgroup trust)
gen trust_stranger = f4_11_08

foreach x of varlist 	trust_* {
						replace `x' =.  if `x'==6 | `x'==7 |`x'==8
}

*** Standard score
* Ingroup trust
egen trust_in = rmean(trust_fam trust_friend)
* Outgroup trust
egen trust_out = rmean(trust_stranger trust_othfirm)
* Mean trust
egen trust_mean = rmean(trust_employ trust_suppl ///
trust_custom trust_othfirm trust_fam trust_neigh /// 
trust_friend trust_stranger)

*** Standardisation to 0-1 scale (Delhey & Welzel, 2012)

gen trust_out_scaled = trust_out/3
gen trust_in_scaled = trust_in/3
gen trust_stranger_scaled = trust_stranger/3
gen trust_employ_scaled = trust_employ/3
gen trust_neigh_scaled = trust_neigh/3
gen trust_fam_scaled = trust_fam/3


//tab trust_stranger
//tab trust_stranger_stand
sum trust_stranger_scaled // mean==.35 (Delhey & Welzel, 2012: all Indonesia, 0.39)
//tab trust_out
//tab trust_in_stand
sum trust_in_scaled // mean==.73 (Delhey & Welzel, 2012: all Indonesia, 0.72)
//tab trust_mean

_crcslbl trust_employ f4_11_01
_crcslbl trust_suppl f4_11_02
_crcslbl trust_custom f4_11_03
_crcslbl trust_othfirm f4_11_04
_crcslbl trust_fam f4_11_05
_crcslbl trust_neigh f4_11_06
_crcslbl trust_friend f4_11_07
_crcslbl trust_stranger f4_11_08


***** WORKING AND THINKING STYLE SCALE

*** Missing values
* Detect missing values in working and thinking style items --> none!
mdesc f4_12_01 f4_12_02 f4_12_03 f4_12_04 f4_12_05 f4_12_06 f4_12_07 ///
f4_12_08 f4_12_09 f4_12_10
* Detect idk's and refused answers --> none!
//tab f4_12_01 
//tab f4_12_02
//tab f4_12_03
//tab f4_12_04
//tab f4_12_05
//tab f4_12_06
//tab f4_12_07
//tab f4_12_08
//tab f4_12_09
//tab f4_12_10

*** Generate scale items
gen cogstyle_system_01 = f4_12_01
gen cogstyle_intuit_02 = f4_12_02
gen cogstyle_intuit_03 = f4_12_03
gen cogstyle_system_04 = f4_12_04
gen cogstyle_system_05 = f4_12_05
gen cogstyle_intuit_06 = f4_12_06
gen cogstyle_system_07 = f4_12_07
gen cogstyle_intuit_08 = f4_12_08
gen cogstyle_system_09 = f4_12_09
gen cogstyle_intuit_10 = f4_12_10


*** Systematic-thinking score

* Score
egen cogstyle_system = rowtotal(cogstyle_system_*)
* Percentage score
gen cogstyle_system_perc = cogstyle_system/25*100
label var cogstyle_system_perc "Systematic working style (% score)"
* Above median score
egen cogstyle_system_md = median(cogstyle_system)
gen cogstyle_system_abvmd = 1 if cogstyle_system>cogstyle_system_md
replace cogstyle_system_abvmd = 0 if cogstyle_system_abvmd==.

*** Intuitive-thinking score

* Score
egen cogstyle_intuit = rowtotal(cogstyle_intuit_*)
* Percentage score
gen cogstyle_intuit_perc = cogstyle_intuit/25*100
label var cogstyle_intuit_perc "Intuitive working style (% score)"

*** Relative systematic-thinking score

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
gen cogstyle_rel_perc = cogstyle_rel/50
label var cogstyle_rel_perc "Systematic working style (% score)"

* Above-median rel score
egen cogstyle_rel_md = median(cogstyle_rel)
gen cogstyle_rel_abvmd = 1 if cogstyle_rel>cogstyle_rel_md
replace cogstyle_rel_abvmd = 0 if cogstyle_rel_abvmd==.
* Above-p80 rel score
egen cogstyle_rel_p80 = pctile(cogstyle_rel), p(80)
gen cogstyle_rel_abv80 = 1 if cogstyle_rel>cogstyle_rel_p80
replace cogstyle_rel_abv80 = 0 if cogstyle_rel_abv80==.


_crcslbl cogstyle_system_01 f4_12_01
_crcslbl cogstyle_intuit_02 f4_12_02
_crcslbl cogstyle_intuit_03 f4_12_03
_crcslbl cogstyle_system_04 f4_12_04
_crcslbl cogstyle_system_05 f4_12_05
_crcslbl cogstyle_intuit_06 f4_12_06
_crcslbl cogstyle_system_07 f4_12_07
_crcslbl cogstyle_intuit_08 f4_12_08
_crcslbl cogstyle_system_09 f4_12_09
_crcslbl cogstyle_intuit_10 f4_12_10


***** TIME PREFERENCES 

*** Missing values
* Detect missing values in both age vars --> none!
mdesc f4_14_01 f4_14_02 f4_14_03
* Idk's, etc. as missing values --> none!
//tab f4_14_01
//tab f4_14_02
//tab f4_14_03

*** Time-preference vars
gen time_fin = f4_14_01
gen time_bis = f4_14_02
gen time_gen = f4_14_03

gen time_comp = (time_fin + time_bis + time_gen)/3

_crcslbl time_fin f4_14_01
_crcslbl time_bis f4_14_02
_crcslbl time_gen f4_14_03


***** RISK PREFERENCES

*** Missing values
* Detect missing values in both age vars --> none!
mdesc f4_15_01 f4_15_02 f4_15_03
* Idk's, etc. as missing values --> none!
//tab f4_15_01
//tab f4_15_02
//tab f4_15_03

*** Risk-preference vars
gen risk_fin = f4_15_01
gen risk_bis = f4_15_02
gen risk_gen = f4_15_03

gen risk_comp = (risk_fin + risk_bis + risk_gen)/3


_crcslbl risk_fin f4_15_01
_crcslbl risk_bis f4_15_02
_crcslbl risk_gen f4_15_03



************************************************************************
***** FIRM CHARACTERISTICS *********************************************

***** FORMALITY

* Detect missing values in licences vars --> none!
mdesc f4_9_12a f4_9_12b f4_9_12c
* Idk's, etc. as missing values
//tab f4_9_12a
//tab f4_9_12b // 2 idk's
//tab f4_9_12c // 1 idk
levelsof f4_9_12b

* Company reg certificate (TDP)
gen formal_reg = f4_9_12a
label var formal_reg "Do you own a company registration certificate?"
label val formal_reg f4_9_12a

* Tax identification no
gen formal_tax = f4_9_12b
label var formal_tax "Do you own a tax ID?"
label val formal_tax f4_9_12b

* VAT collection no
gen formal_vat = f4_9_12c
label var formal_vat "Do you own a VAT collection no?"
label val formal_vat f4_9_12c

* Only 17 businesses have all certificates and nos
count if formal_reg==1 & formal_tax==1 & formal_vat==1

* Define idk's ("8") as missing values
foreach x of varlist formal_* {
   replace `x' =.  if `x'==8
   replace `x' = 0 if `x'==3
   }

//tab formal_reg
//tab formal_tax
//tab formal_vat

egen formal_firm=rowmax(formal_reg formal_tax formal_vat)


***** FIRM AGE

* Detect missing values in firm age var --> none!
mdesc f4_3_1 f4_3_2

* Generate firm age var
//tab f4_3_1 // 6 idk's
levelsof f4_3_1
gen age_firm = 2017-f4_3_1
replace age_firm =. if age_firm<0

* Dummy for firms older than their manager

gen age_firm_manager = 1 if age_firm>age_manager
replace age_firm_manager = 0 if age_firm_manager==.

//tab age_firm
//tab age_manager
//tab age_firm_manager

* Dummies for firms opened before 2007 and 2013 (flood)
gen age_firm_prior2007 = 1 if  f4_3_1<2007
replace age_firm_prior2007 = 0 if age_firm_prior2007==.
gen age_firm_prior2013 = 1 if f4_3_1<2013
replace age_firm_prior2013 = 0 if age_firm_prior2013==.

* Median firm age
egen age_firm_md = median(age_firm)

*Dummy for being above median age
gen age_firm_abvmd = 1 if age_firm>age_firm_md
replace age_firm_abvmd = 0 if age_firm_abvmd==.


***** SPACE

*** Total space
* Detect missing values in firm space var --> none!
mdesc f4_3_7a f4_10_01aa

* Dummies for businesses up to 6, between 6 and 10, and above 10 sqm from categorical variable
//tab f4_3_7a
gen space_micro = 1 if f4_3_7a==1
replace space_micro = 0 if space_micro==.
gen space_small = 1 if f4_3_7a==2
replace space_small = 0 if space_small==.
gen space_mid = 1 if f4_3_7a==3
replace space_mid = 0 if space_mid==.
//tab space_micro
//tab space_small
//tab space_mid

* Dummies for businesses up to 6, between 6 and 10, and above 10 sqm from continuous variable (aspirations)
//tab f4_10_01aa
gen space_cont_micro = 1 if f4_10_01aa>0 & f4_10_01aa<=6
replace space_cont_micro = 0 if space_cont_micro==.
gen space_cont_small = 1 if f4_10_01aa>6 & f4_10_01aa<=10
replace space_cont_small = 0 if space_cont_small==.
gen space_cont_mid = 1 if f4_10_01aa>10
replace space_cont_mid = 0 if space_cont_mid==.

* Consistency between categorical and continuous variables --> 306 inconsistencies
count if space_micro==1 & space_cont_micro!=1 ///
| space_micro==0 & space_cont_micro!=0 ///
| space_small==1 & space_cont_small!=1 ///
| space_small==0 & space_cont_small!=0 ///
| space_mid==1 & space_cont_mid!=1 ///
| space_mid==0 & space_cont_mid!=0 ///


* Ordinal variable for businesses of up to 6 (1), between 6 and 10 (2), and above 10 (3) sqm
gen space_ord = 1 if f4_10_01aa>0 & f4_10_01aa<=6
replace space_ord = 2 if f4_10_01aa>6 & f4_10_01aa<=10
replace space_ord = 3 if f4_10_01aa>10


*** Storage space (percentage)

gen space_store = f4_3_7b
* Detect missing values in storage space var --> none!
//tab f4_3_7b
mdesc f4_3_7b

* Dummy for dedicated storage space
gen space_store_yes = 1 if space_store>0 & space_store!=.
replace space_store_yes = 0 if space_store_yes==.
//tab space_store_yes


*** Occupany status

* Detect missing values in occupancy status var --> none!
//tab f4_3_6
mdesc f4_3_6

* Dummies for space owned, rented, and used without payment
gen space_own = 1 if f4_3_6==1
replace space_own = 0 if space_own==.
gen space_rent = 1 if f4_3_6==2
replace space_rent = 0 if space_rent==.
gen space_use = 1 if f4_3_6==3
replace space_use = 0 if space_use==.
//tab space_own
//tab space_rent
//tab space_use


***** OPENING HOURS (hours opened incl and net of closing time for prayer/food/etc.)

*** Generate vars for opening hours

* Total opening hours
gen open = (f4_3_5_endhr + f4_3_5_endmin/60) - (f4_3_5_beghr + f4_3_5_begmin/60)
* Opening hours per person
gen open_pp = open/(f4_4_3_b3+1)
* Net opening hours
gen open_break = (f4_3_5a_hr + f4_3_5a_min/60)
gen open_net = open - open_break
//tab open_break
count if open_net<4
* Net opening hours per person (owner + business partners)
gen open_net_pp = open_net/(f4_4_3_b3+1)

* Detect missing values in opening hours var --> none!
//tab open
//tab open_net
mdesc open open_net

* Dummy for break time below median
egen open_break_md = median(open_break) // md==2
gen open_break_blwmd = 1 if open_break<open_break_md
replace open_break_blwmd = 0 if open_break_blwmd==.
//tab open_break_md

* Dummy for opening hours above median and 80th perc
* Median
egen open_md = median(open) // md==15
gen open_abvmd = 1 if open>open_md
replace open_abvmd = 0 if open_abvmd==.
* p80
egen open_p80 = pctile(open), p(80) // p80==17
gen open_abv80 = 1 if open>open_p80
replace open_abv80 = 0 if open_abv80==.
sum open_p80

* Dummy for NET opening hours above median and in 80th percentile
* Median
egen open_net_md = median(open_net) // md==13
gen open_net_abvmd = 1 if open_net>open_net_md
replace open_net_abvmd = 0 if open_net_abvmd==.
* 80th perc
egen open_net_p80 = pctile(open_net), p(80) // p80==15
gen open_net_abv80 = 1 if open_net>open_net_p80
replace open_net_abv80 = 0 if open_net_abv80==.

//tab open
//tab open_break
//tab open_abvmd
//tab open_net_abvmd
//tab open_net_abv80


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



***** ELECTRICITY

*** All places have electricity (f4_3_8a)

*** Power outage
* Detect missing values in electricity var --> none!
//tab f4_3_8b
mdesc f4_3_8b
* Dummies for power outage monthly or more often and weekly or more often
gen powerout_mthly = 1 if f4_3_8b>2
replace powerout_mthly = 0 if powerout_mthly==.
gen powerout_wk = 1 if f4_3_8b>4
replace powerout_wk = 0 if powerout_wk==.


***** ASSETS

*** Only 9 businesses own a pick-up

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


*** Only 15 businesses own either a computer or a laptop

*** Landline
gen 		assets_landline = f4_4_1bg

* Detect missing values in asset var --> 0 obs
//tab 		landline
mdesc 		assets_landline



***** OTHER BUSINESSES
gen 		assets_otherfirm = f4_3_9



************************************************************************
***** SALES, EXPENSES, PROFITS *****************************************


***** SALES ***********************************************************


***** SALES LAST MONTH (+ln sales, +ln sales winsorised at p95)

* All sales/expenses/profits data converted to USD PPP with IDR 4060.46 = USD 1
* from WB data, 2015:  http://data.worldbank.org/indicator/PA.NUS.PPP
gen sales_lastmth = f4_8_2

*** Missing vars analysis
* Detect missing values in sales vars --> none!
mdesc sales_lastmth
* Treatment of extreme values as missing --> 15 obs!
replace sales_lastmth = sales_lastmth/xchange
replace sales_lastmth =. if sales_lastmth>=500000


***** SALES ON A NORM DAY

* All sales/expenses/profits data converted to USD PPP with IDR 4060.46 = USD 1
* from WB data, 2015:  http://data.worldbank.org/indicator/PA.NUS.PPP
gen sales_nday = f4_8_5

*** Missing vars analysis
* Detect missing values in sales vars --> none!
mdesc sales_nday
* Treatment of extreme values as missing --> 6 obs!
replace sales_nday = sales_nday/xchange
//replace sales_nday =. if sales_nday>17500

*gen sales_calc=sales_nday*30
gen	sales_calc=sales_nday*f4_3_4*(365/84)
* Note: f4_3_4 is the # of days the shop is open in normal week 

replace sales_lastmth=sales_calc if sales_lastmth==sales_nday
*replace sales_lastmth=sales_calc if sales_lastmth==.


**** SALES ON A NORM DAY, CALCULATED FROM TOP 3 PRODUCTS

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
drop sales_nday_top3

*replace sales_lastmth=sales_top3 if sales_lastmth==.
*replace sales_calc=sales_top3 if sales_calc==.


***** SALES MTHLY COMPOSITE

*** Comp score w both self-reported and calc vars
gen 		sales_comp1 = (sales_lastmth + sales_calc)/2
gen 		sales_comp2 = (sales_lastmth + sales_calc + sales_top3)/3



***** EXPENSES *********************************************************

* All expense data converted to USD PPP with IDR 4060.46 = USD 1
* from WB data, 2015:  http://data.worldbank.org/indicator/PA.NUS.PPP

***** STOCK-UP COSTS
gen expense_stockup = f4_8_3a
* Treatment of extreme values as missing --> 17 obs!
replace expense_stockup =. if f4_8_3a>1500000005
//replace expense_stockup = 0 if f4_8_3a==.
replace expense_stockup = expense_stockup/xchange

***** SALARIES AND BENEFITS
gen expense_wage = f4_8_3b
* No extreme values detected
// replace expense_wage = 0 if f4_8_3b==.
replace expense_wage = expense_wage/xchange

***** RENT AND FEES
gen expense_rent = f4_8_3c
* Treatment of extreme value as missing --> 1 obs!
replace expense_rent =. if f4_8_3c>999999999997
//replace expense_rent = 0 if f4_8_3c==.
replace expense_rent = expense_rent/xchange

***** ELECTRICITY AND UTILITIES
gen expense_electric = f4_8_3d
* Treatment of extreme values as missing --> 20 obs!
replace expense_electric =. if f4_8_3d>999999999997
//replace expense_electric = 0 if f4_8_3d==.
replace expense_electric = expense_electric/xchange

***** TRANSPORTATION COSTS
gen expense_transport = f4_8_3e
* Treatment of extreme values as missing --> 39 obs!
replace expense_transport =. if f4_8_3e>999999999997
//replace expense_transport = 0 if f4_8_3e==.
replace expense_transport = expense_transport/xchange

***** TAXES
gen expense_tax = f4_8_3f
* Treatment of extreme values as missing --> 42 obs!
replace expense_tax =. if f4_8_3f>999999999997
//replace expense_tax = 0 if f4_8_3f==.
replace expense_tax = expense_tax/xchange

***** COMMUNICATION
gen expense_phone = f4_8_3g
* Treatment of extreme values as missing --> 16 obs! 
replace expense_phone =. if f4_8_3g>999999999997
//replace expense_phone = 0 if f4_8_3g==.
replace expense_phone = expense_phone/xchange

***** MARKETING
gen expense_advert = f4_8_3h
* No extreme values detected
//replace expense_advert = 0 if f4_8_3h==.
replace expense_advert = expense_advert/xchange

***** SECURITY

*** Preman (organised, local thugs)
gen expense_preman = f4_8_3i
* No extreme values detected
//replace expense_preman = 0 if f4_8_3i==.
replace expense_preman = expense_preman/xchange

*** Police
gen expense_police = f4_8_3j
* Treatment of extreme value as missing --> 1 obs!
replace expense_police =. if f4_8_3j>999999999997
//replace expense_police = 0 if f4_8_3j==.
replace expense_police = expense_police/xchange

* Security
gen security = expense_preman + expense_police

***** OTHER EXPENSES

gen expense_other = f4_8_3k
* No extreme values detected
replace expense_other = 0 if expense_other>99999999997
//replace expense_other = 0 if f4_8_3k==.
replace expense_other = expense_other/xchange


*** Missing values analysis
* Detect missing values in expenses vars
mdesc expense_stockup expense_wage expense_rent expense_electric /// 
expense_transport expense_tax expense_phone expense_advert /// 
expense_preman expense_police expense_other


***** TOTAL EXPENSES

egen expense_total =	rowtotal(expense_stockup expense_wage expense_rent ///
								expense_electric expense_transport expense_tax ///
								expense_phone expense_advert expense_preman expense_police ///
								expense_other)

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


*** Confidence about profits
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

gen labour_total = f4_4_2

gen labour_fam_full = f4_4_3_b1 + f4_4_3_b3 
gen labour_fam_part = f4_4_3_b2
gen labour_fam = labour_fam_part + labour_fam_full

gen labour_nonfam_full = f4_4_3_a1 + f4_4_3_a3
gen labour_nonfam_part = f4_4_3_a2
gen labour_nonfam = labour_nonfam_part + labour_nonfam_full

gen labour_ft=labour_nonfam_full + labour_fam_full
gen labour_pt=labour_nonfam_part + labour_fam_part								



************************************************************************
*** BUSINESS RECORDS AND PROFIT CALCS ************************************

***** BUSINESS RECORDS

*** Content of records
* Detect missing values in asset var --> none!
mdesc f4_7_1daa f4_7_1dab f4_7_1dac f4_7_1dad f4_7_1dae f4_7_1daf f4_7_1dag ///
f4_7_1dah f4_7_1dai f4_7_1daj f4_7_1dak f4_7_1dal
* Prices of diff suppliers
//tab f4_7_1daa
gen rec_pricesuppliers = 1 if f4_7_1daa==1
replace rec_pricesuppliers = 0 if rec_pricesuppliers==.
* Prices of diff brands
//tab f4_7_1dab
gen rec_pricebrands = 1 if f4_7_1dab==1
replace rec_pricebrands = 0 if rec_pricebrands==.
* Product purchases
//tab f4_7_1dac
gen rec_stockup = 1 if f4_7_1dac==1
replace rec_stockup = 0 if rec_stockup==.
* Sales
//tab f4_7_1dad
gen rec_sales = 1 if f4_7_1dad==1
replace rec_sales = 0 if rec_sales==.
* Asset purchases
//tab f4_7_1dae
gen rec_assetpurch = 1 if f4_7_1dae==1
replace rec_assetpurch = 0 if rec_assetpurch==.
* Total stocks
//tab f4_7_1daf
gen rec_stocks = 1 if f4_7_1daf==1
replace rec_stocks = 0 if rec_stocks==.
* Outstanding payments to supliers
//tab f4_7_1dag
gen rec_accpaysupplier = 1 if f4_7_1dag==1
replace rec_accpaysupplier = 0 if rec_accpaysupplier==.
* Outstanding payments for loans/debts accrued
//tab f4_7_1dah
gen rec_accpayloan = 1 if f4_7_1dah==1
replace rec_accpayloan = 0 if rec_accpayloan==.
* Salary and other costs to the business
//tab f4_7_1dai // Only 19 businesses note salary payments
//tab f4_7_1daj
count if f4_7_1dai==1 & f4_7_1daj==0
gen rec_othercosts = 1 if f4_7_1daj==1 // Combined var of "any costs excl. new prods"
replace rec_othercosts = 0 if rec_othercosts==.
* Outstanding payments of customers
//tab f4_7_1dak
gen rec_accreccustom = 1 if f4_7_1dak==1
replace rec_accreccustom = 0 if rec_accreccustom==.
* Outstanding payments of customers when shop gives trade credit
gen rec_accreccustom_TC = 1 if f4_7_1dak==1 & f4_7_30a==1
replace rec_accreccustom_TC = 0 if rec_accreccustom_TC==.
* Outstanding payments of fam members
//tab f4_7_1dal
gen rec_accrecfam = 1 if f4_7_1dal==1
replace rec_accrecfam = 0 if rec_accrecfam==.

*** Kind of records
* Detect missing values in asset var --> none!
mdesc f4_7_1b
* Only 6 businesses keep electronic records
//tab f4_7_1b
* Dummy for electronic record-keeping or ledger book
gen rec_ledger = 1 if f4_7_1b==5 | f4_7_1b==6
replace rec_ledger = 0 if rec_ledger==.
* Dummy for receipt collection only
gen rec_receipts = 1 if f4_7_1b==2 | f4_7_1b==3
replace rec_receipts = 0 if rec_receipts==.
* Dummy for no records whatsoever
gen rec_none = 1 if f4_7_1b==0
replace rec_none = 0 if rec_none==.


*** Frequency of updating records
* Dummy for daily updating
gen 	rec_day = 1 if f4_7_1c==7
replace rec_day = 0 if rec_day==.

* Dummy for weekly updating
gen 	rec_weekly = 1 if f4_7_1c==7 | f4_7_1c==6 | f4_7_1c==5 
replace rec_weekly = 0 if rec_weekly==.


***** PROFIT CALCULATIONS

* Detect missing values in asset var --> none, 770, 770!
mdesc f4_7_5a f4_7_5c f4_7_5b

*** Kind of profit calculation
* Dummy for profit calculation with definition up to respondent
//tab f4_7_5a
gen profcalc_any = 1 if f4_7_5a==1
replace profcalc_any = 0 if profcalc_any==.
* Dummy for profit calculation accounting for all costs 
* --> only 58 businesses account for all costs!
//tab f4_7_5c
gen profcalc_allcosts = 1 if f4_7_5c==4
replace profcalc_allcosts = 0 if profcalc_allcosts==.
* Dummy for profit calculation AT LEAST accounting for costs through stock-ups
gen profcalc_stockup = 1 if f4_7_5c==2 | f4_7_5c==3 | f4_7_5c==4
replace profcalc_stockup = 0 if profcalc_stockup==.
* Dummy for supposed profit calculation accounting  for NO COSTS whatsoever
gen profcalc_nocosts = 1 if f4_7_5c==1
replace profcalc_nocosts = 0 if profcalc_nocosts==.

*** Frequency of profit calculations
* Dummies for profit calculations (whichever way defined) daily/at least weekly
//tab f4_7_5b
gen profcalc_any_day = 1 if f4_7_5b==7
replace profcalc_any_day = 0 if profcalc_any_day==.
gen profcalc_any_wk = 1 if f4_7_5b==5 | f4_7_5b==6 | f4_7_5b==7
replace profcalc_any_wk = 0 if profcalc_any_wk==.


************************************************************************
*** MCKENZIE & WOODRUFF (2015) **************************************

***** SINGLE PRACTICES

* M1 -- Visited competitor, see prices
gen MWM1_visitcompetprice = f4_7_17
replace MWM1_visitcompetprice = 0 if MWM1_visitcompetprice==3

* M2 -- Visited competitor, see products
gen MWM2_visitcompetprod = f4_7_18
replace MWM2_visitcompetprod = 0 if MWM2_visitcompetprod==3

* M3 -- Asked customers, wishes for new products
gen MWM3_askcustomprod = f4_7_28
replace MWM3_askcustomprod = 0 if MWM3_askcustomprod==3

* M4 -- Talked to former customer, why quit buying
gen MWM4_askcustomquit = f4_7_29
replace MWM4_askcustomquit = 0 if MWM4_askcustomquit==3

* M5 -- Asked supplier, well-selling products
gen MWM5_asksupplprod = f4_7_19
replace MWM5_asksupplprod = 0 if MWM5_asksupplprod==3

* M6 -- Attracted customer w special offer
gen MWM6_attrcustomdisc = f4_7_21
replace MWM6_attrcustomdisc = 0 if MWM6_attrcustomdisc==3

* M7 -- Advertised
gen MWM7_advert = f4_7_24
replace MWM7_advert = 0 if MWM7_advert==3

* B1 -- Negotiated w supplier, lower price
gen MWB1_negosupplprice = f4_7_31
replace MWB1_negosupplprice = 0 if MWB1_negosupplprice==3

* B2 -- Compared supplier, quality/quantity of products
gen MWB2_compsupplprod = f4_7_32
replace MWB2_compsupplprod = 0 if MWB2_compsupplprod==3

* B3 -- Did not run out of stock
gen MWB3_notOOS = f4_7_33
replace MWB3_notOOS = 0 if MWB3_notOOS==3

* R1 -- Kept written business records
gen MWR1_recwritten = f4_7_1a
replace MWR1_recwritten = 0 if MWR1_recwritten==3

* R2 -- Recorded every purchase and sale
gen MWR2_recpurchsale = f4_7_1d
replace MWR2_recpurchsale = 0 if MWR2_recpurchsale==3

* R3 -- Can use records, see cash on hand
gen MWR3_recliquid = f4_7_1g
replace MWR3_recliquid = 0 if MWR3_recliquid==3

* R4 -- Uses records, check sales of particular prod
gen MWR4_recsalesprods = f4_7_1h
replace MWR4_recsalesprods = 0 if MWR4_recsalesprods==3

* R5 -- Works out cost to business of main prods
gen MWR5_costprods = f4_7_2
replace MWR5_costprods = 0 if MWR5_costprods==3

* R6 -- Knows prods w most profit per item selling
gen MWR6_profprods = f4_7_3
replace MWR6_profprods = 0 if MWR6_profprods==3

* R7 -- Written monthly expenses budget
gen MWR7_recexpensemth = f4_7_4
replace MWR7_recexpensemth = 0 if MWR7_recexpensemth==3

* R8 -- Can use records, pay back hypothetical loan
gen MWR8_recloan = f4_7_1i
replace MWR8_recloan = 0 if MWR8_recloan==3

* F1 -- Reviews and analyses fin perform
gen MWF1_finperform = f4_7_7a
replace MWF1_finperform = 0 if MWF1_finperform==3

* F2 -- Sets sales target over next year
gen MWF2_settargetyr = f4_7_8
replace MWF2_settargetyr = 0 if MWF2_settargetyr==3

* F3 -- Compares target with sales at least monthly
gen MWF3_comptargetmth = f4_7_9a
replace MWF3_comptargetmth = 0 if MWF3_comptargetmth==3

* F4 -- Cost budget, next yr
gen MWF4_expensenextyr = f4_7_10
replace MWF4_expensenextyr = 0 if MWF4_expensenextyr==3

* F5 -- Annual profit and loss statement
gen MWF5_proflossyr = f4_7_11
replace MWF5_proflossyr = 0 if MWF5_proflossyr==3

* F6 -- Annual cash-flow statement
gen MWF6_cashflowyr = f4_7_12
replace MWF6_cashflowyr = 0 if MWF6_cashflowyr==3

* F7 -- Annual balance sheet
gen MWF7_balanceyr = f4_7_13
replace MWF7_balanceyr = 0 if MWF7_balanceyr==3

* F8 -- Annual income and expenditure sheet
gen MWF8_incexpenseyr = f4_7_14
replace MWF8_incexpenseyr = 0 if MWF8_incexpenseyr==3


*** Missing vars analysis

* Detect missing values in practice_McKandW_McKandW vars --> none!
mdesc MWM1_visitcompetprice MWM2_visitcompetprod MWM3_askcustomprod ///
MWM4_askcustomquit MWM5_asksupplprod MWM6_attrcustomdisc MWM7_advert ///
MWB1_negosupplprice MWB2_compsupplprod MWB3_notOOS MWR1_recwritten ///
MWR2_recpurchsale MWR3_recliquid MWR4_recsalesprods MWR5_costprods ///
MWR6_profprods MWR7_recexpensemth MWR8_recloan MWF1_finperform MWF2_settargetyr ///
MWF3_comptargetmth MWF4_expensenextyr MWF5_proflossyr MWF6_cashflowyr ///
MWF7_balanceyr MWF8_incexpenseyr

* Define idk's, etc. as missing values
//tab MWM1_visitcompetprice
//tab MWM2_visitcompetprod
//tab MWM3_askcustomprod
//tab MWM4_askcustomquit
//tab MWM5_asksupplprod  		// 2 idks
//tab MWM6_attrcustomdisc
//tab MWM7_advert
//tab MWB1_negosupplprice	 	// 1 idk
//tab MWB2_compsupplprod 		// 2 idks
//tab MWB3_notOOS
//tab MWR1_recwritten
//tab MWR2_recpurchsale
//tab MWR3_recliquid
//tab MWR4_recsalesprods 		// 1 idk
//tab MWR5_costprods			// 2 idks
//tab MWR6_profprods
//tab MWR7_recexpensemth 		// 1 idk
//tab MWR8_recloan				// 36 idks
//tab MWF1_finperform
//tab MWF2_settargetyr			// 5 idks
//tab MWF3_comptargetmth		// 2 idks
//tab MWF4_expensenextyr		// 1 idk
//tab MWF5_proflossyr			// 1 idk
//tab MWF6_cashflowyr
//tab MWF7_balanceyr
//tab MWF8_incexpenseyr


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
//tab MW_score_total
* Marketing sub-score
egen MW_M_score_total = rowmean(MWM2_visitcompetprod MWM3_askcustomprod ///
MWM4_askcustomquit MWM5_asksupplprod MWM6_attrcustomdisc MWM7_advert)
* Stock sub-score
egen MW_B_score_total = rowmean(MWB1_negosupplprice MWB2_compsupplprod MWB3_notOOS)
* Record sub-score
egen MW_R_score_total = rowmean(MWR1_recwritten MWR2_recpurchsale ///
MWR3_recliquid MWR4_recsalesprods MWR5_costprods MWR6_profprods ///
MWR7_recexpensemth MWR8_recloan MWF1_finperform)
* Planning sub-score
egen MW_F_score_total = rowmean( MWF1_finperform MWF2_settargetyr MWF3_comptargetmth ///
MWF4_expensenextyr MWF5_proflossyr MWF6_cashflowyr MWF7_balanceyr MWF8_incexpenseyr)

*Generating above median score
egen MW_score_total_md=median(MW_score_total)
gen MW_score_total_abovemd = 1 if MW_score_total > MW_score_total_md
replace MW_score_total_abovemd = 0 if MW_score_total<= MW_score_total_md




************************************************************************
*** OTHER BUSINESS PRACTICES **************************************

***** SEPARATION OF PRIVATE AND BUSINESS FIN

* Detect missing values in asset var --> none!
mdesc f4_7_6
* Dummy for having separate finances
//tab f4_7_6
gen separatefin = 1 if f4_7_6==1
replace separatefin = 0 if separatefin==.


***** SALES TARGETS

* Dummy for target set for sales over next year MWF2_settargetyr

* Dummy for comparing sales target to sales at least monthly MWF3_comptargetmth

* Frequency of comparing sales target to sales --> 823 missing values!
* Var not clearly defined. SM seems to have asked f4_7_9b conditional on 
* f4_7_9a==1, which is wrong considering the answering options 0, 1, and 2. 
* More confusing even still, there are 30 instances of respondents answering 1 or 2.
mdesc f4_7_9b 
count if MWF3_comptargetmth==0 & f4_7_9b==.


***** COMPARING SALES PERFORMANCE TO COMPETITORS

* Detect missing values in asset var --> none!
mdesc f4_7_16
* Dummy for comparing sales performance --> 2 idk's!
//tab f4_7_16
gen compsales_compet = 1 if f4_7_16==1
replace compsales_compet = 0 if compsales_compet==.


***** PRICE CHANGES

* Detect missing values in asset var --> none!
mdesc f4_7_19a f4_7_19a_A f4_7_19a_B f4_7_19a_C f4_7_19a_D f4_7_19a_E
//tab f4_7_19a
* Dummy for price change due to competitor's price
//tab f4_7_19a_A
gen price_change_comp = 1 if f4_7_19a_A==1
replace price_change_comp = 0 if price_change_comp==.
* Dummy for price change due to demand change
//tab f4_7_19a_B
gen price_change_demand = 1 if f4_7_19a_B==1
replace price_change_demand = 0 if price_change_demand==.
* Dummy for discount given (loyal customer, bulk, product in need to be sold)
//tab f4_7_19a_C
//tab f4_7_19a_D
//tab f4_7_19a_E
gen discount = 1 if f4_7_19a_C==1 | f4_7_19a_D==1 | f4_7_19a_E==1
replace discount = 0 if discount==.
gen discount_bulk = 1 if f4_7_19a_C==1
replace discount_bulk = 0 if discount_bulk==.
gen discount_loyal = 1 if f4_7_19a_D==1
replace discount_loyal = 0 if discount_loyal==.

//tab price_change_comp
//tab price_change_demand
//tab discount
//tab discount_bulk
//tab discount_loyal




***** TRADE CREDIT

* Detect missing values in asset var --> 0
mdesc f4_7_30a f4_7_30b
* Dummy for providing trade credit
//tab f4_7_30a
gen credit_TC = 1 if f4_7_30a==1
replace credit_TC = 0 if credit_TC==.
* Dummy for demanding interest -> Only 98 buinesses demand interest
//tab f4_7_30b
gen credit_TC_int = 1 if f4_7_30b==1
replace credit_TC_int = 0 if credit_TC_int==.



***** Level of sophistication in business practices relative to neighbour's

mdesc f4_7_34
gen practices_rel = 1 if f4_7_34==3
replace practices_rel = 0 if f4_7_34==2
replace practices_rel = -1 if f4_7_34==1
replace practices_rel = . if f4_7_34>=7

*Dummies
gen practices_rel_high = 1 if practices_rel>0
replace practices_rel_high = 0 if practices_rel<=0
replace practices_rel_high =. if practices_rel==.
gen practices_rel_low = 1 if practices_rel<0
replace practices_rel_low = 0 if practices_rel>=0
replace practices_rel_low =. if practices_rel==.



************************************************************************
*** PRACTICES (TO BE) IMPLEMENTED IN LAST/NEXT 12 MTH ********************

***** PRACTICES

* Detect missing values in asset var --> none!
mdesc f4_7_16 f4_7_15a1 f4_7_15b1 f4_7_15a2 f4_7_15b2 f4_7_15a3 f4_7_15b3 ///
f4_7_15a4 f4_7_15b4 f4_7_15a5 f4_7_15b5 f4_7_15a6 f4_7_15b6 f4_7_15a7 ///
f4_7_15b7 f4_7_15a8 f4_7_15b8 f4_7_15a9 f4_7_15b9 f4_7_15a10 f4_7_15b10 ///
f4_7_15a11 f4_7_15b11

*** Cut costs
//tab f4_7_15a1
//tab f4_7_15b1 // 14 idk's (as missing values)
gen cutcosts_lastyr = 1 if f4_7_15a1==1
replace cutcosts_lastyr = 0 if cutcosts_lastyr==.
gen cutcosts_nextyr = 1 if f4_7_15b1==1
replace cutcosts_nextyr = 0 if cutcosts_nextyr==.

*** Work with new supplier
//tab f4_7_15a2
//tab f4_7_15b2 // 58 idk's, 1 rejection (as missing values)
gen changesupplier_lastyr = 1 if f4_7_15a2==1
replace changesupplier_lastyr = 0 if changesupplier_lastyr==.
gen changesupplier_nextyr = 1 if f4_7_15b2==1
replace changesupplier_nextyr = 0 if changesupplier_nextyr==.

*** Buy higher qual prod
//tab f4_7_15a3
//tab f4_7_15b3 // 37 idk's (as missing values)
gen prodquality_lastyr =1 if f4_7_15a3==1
replace prodquality_lastyr = 0 if prodquality_lastyr==.
gen prodquality_nextyr = 1 if f4_7_15b3==1
replace prodquality_nextyr = 0 if prodquality_nextyr==.

*** Introduce new brand
//tab f4_7_15a4 // 2 idk's (as missing values)
//tab f4_7_15b4 // 62 idk's (as missing values)
gen newbrand_lastyr = 1 if f4_7_15a4==1
replace newbrand_lastyr = 0 if newbrand_lastyr==.
gen newbrand_nextyr = 1 if f4_7_15b4==1
replace newbrand_nextyr = 0 if newbrand_nextyr==.

*** Open new business
//tab f4_7_15a5 // 76 businesses opened new branch in last 12 mth!
//tab f4_7_15b5 // 12 idk's (as missing values)
gen newbranch_lastyr = 1 if f4_7_15a5==1
replace newbranch_lastyr = 0 if newbranch_lastyr==.
gen newbranch_nextyr = 1 if f4_7_15b5==1
replace newbranch_nextyr = 0 if newbranch_nextyr==.

*** Delegate more tasks to employees
//tab f4_7_15a6 // 65 "N/A"? (as missing values)
//tab f4_7_15b6 // 19 idk's, 53 "N/A"? (as missing values)
gen delegate_lastyr = 1 if f4_7_15a6==1
replace delegate_lastyr = 0 if delegate_lastyr==.
gen delegate_nextyr = 1 if f4_7_15b6==1
replace delegate_nextyr = 0 if delegate_nextyr==.

*** Develop business plan
//tab f4_7_15a7
//tab f4_7_15b7 // 13 idk's (as missing values)
gen bisplan_lastyr =1 if f4_7_15a7==1
replace bisplan_lastyr = 0 if bisplan_lastyr==.
gen bisplan_nextyr = 1 if f4_7_15b7==1
replace bisplan_nextyr = 0 if bisplan_nextyr==.

*** Start/improve records
//tab f4_7_15a8
//tab f4_7_15b8 // 17 idk's (as missing values)
gen startrec_lastyr = 1 if f4_7_15a8==1
replace startrec_lastyr = 0 if startrec_lastyr==.
gen startrec_nextyr = 1 if f4_7_15b8==1
replace startrec_nextyr = 0 if startrec_nextyr==.

*** Loan
//tab f4_7_15a9
//tab f4_7_15b9 // 35 idk's (as missing values)
gen loan_lastyr = 1 if f4_7_15a9==1
replace loan_lastyr = 0 if loan_lastyr==.
gen loan_nextyr = 1 if f4_7_15b9==1
replace loan_nextyr = 0 if loan_nextyr==.

*** Coop with competitor
//tab f4_7_15a10
//tab f4_7_15b10 // 12 idk's (as missing values)
gen coopcompet_lastyr = 1 if f4_7_15a10==1
replace coopcompet_lastyr = 0 if coopcompet_lastyr==.
gen coopcompet_nextyr = 1 if f4_7_15b10==1
replace coopcompet_nextyr = 0 if coopcompet_nextyr==.

*** VAT number
//tab f4_7_15a11 // 5 idk's (as missing values)
//tab f4_7_15b11 // 53 idk's (as missing values)
gen vat_lastyr = 1 if f4_7_15a11==1
replace vat_lastyr = 0 if vat_lastyr==.
gen vat_nextyr = 1 if f4_7_15b11==1
replace vat_nextyr = 0 if vat_nextyr==.



************************************************************************
*** DISCUSSION AND DECISION-MAKING **************************************

***** DISCUSSION OF BUSINESS TOPICS W OTHERS

*** Discussing any business topics w others

* Detect missing values in asset var --> 0, 296 obs!
mdesc f4_7_35a f4_7_35bx

* Dummy for discussing any business topics
//tab f4_7_35a
gen discuss_any = 1 if f4_7_35a==1
replace discuss_any = 0 if discuss_any==.
//tab discuss_any

* Jointly discussing anything on a daily basis
gen practice_discuss_any_daily = 0

foreach x of varlist f4_7_35dA f4_7_35dB f4_7_35dC f4_7_35dD f4_7_35dE f4_7_35dF ///
f4_7_35dG f4_7_35dH f4_7_35dI f4_7_35dJ f4_7_35dK f4_7_35dL f4_7_35dM f4_7_35dN ///
f4_7_35dO f4_7_35dP f4_7_35dQ f4_7_35dR f4_7_35dS{
   replace practice_discuss_any_daily = practice_discuss_any_daily+1  if `x'==7
   }

//tab practice_discuss_any_daily
   
replace practice_discuss_any_daily = 1 if practice_discuss_any_daily>0 & practice_discuss_any_daily!=.
   
//tab practice_discuss_any_daily



*** Specific topics

* Dummy for specific topics discussed with others and how frequently
//tab f4_7_35bx 
//tab f4_7_35bxxA 
//tab f4_7_35bxxB 
//tab f4_7_35bxxC 
//tab f4_7_35bxxD // Only 2 businesses answered in the affirmatve
//tab f4_7_35bxxE // Only 9 businesses answered in the affirmatve
//tab f4_7_35bxxF // 0 businesses answered in the affirmatve
//tab f4_7_35bxxG
//tab f4_7_35bxxH // 0 businesses answered in the affirmatve
//tab f4_7_35bxxI // Only 13 businesses answered in the affirmatve
//tab f4_7_35bxxJ
//tab f4_7_35bxxK
//tab f4_7_35bxxL
//tab f4_7_35bxxM
//tab f4_7_35bxxN // Only 15 businesses answered in the affirmatve
//tab f4_7_35bxxO // Only 7 businesses answered in the affirmatve
//tab f4_7_35bxxP // Only 1 business answered in the affirmatve
//tab f4_7_35bxxQ // Only 21 businesses answered in the affirmatve
//tab f4_7_35bxxR // Only 1 business answered in the affirmatve
//tab f4_7_35bxxS // Only 10 businesses answered in the affirmatve

//tab f4_7_35dA
//tab f4_7_35dB
//tab f4_7_35dC
//tab f4_7_35dG
//tab f4_7_35dJ
//tab f4_7_35dK
//tab f4_7_35dL
//tab f4_7_35dM

* A Sales
gen discuss_sales = 1 if f4_7_35bxxA==1
replace discuss_sales = 0 if discuss_sales==.
gen discuss_sales_wk = 1 if f4_7_35dA==5 | f4_7_35dA==6 | f4_7_35dA==7
replace discuss_sales_wk = 0 if discuss_sales_wk==.
* B Selling price
gen discuss_sellprice = 1 if f4_7_35bxxB==1
replace discuss_sellprice = 0 if discuss_sellprice==.
gen discuss_sellprice_wk = 1 if f4_7_35dB==5 | f4_7_35dB==6 | f4_7_35dB==7
replace discuss_sellprice_wk = 0 if discuss_sellprice_wk==.
* C Best-selling product
gen discuss_bestseller = 1 if f4_7_35bxxC==1
replace discuss_bestseller = 0 if discuss_bestseller==.
gen discuss_bestseller_wk = 1 if f4_7_35dC==5 | f4_7_35dC==6 | f4_7_35dC==7
replace discuss_bestseller_wk = 0 if discuss_bestseller_wk==.
* G Finance opportunities
gen discuss_finance = 1 if f4_7_35bxxG==1
replace discuss_finance = 0 if discuss_finance==.
* J Purchasing price
gen discuss_buyprice = 1 if f4_7_35bxxJ==1
replace discuss_buyprice = 0 if discuss_buyprice==.
* K New brand/product
gen discuss_newprod = 1 if f4_7_35bxxK==1
replace discuss_newprod = 0 if discuss_newprod==.
gen discuss_newprod_wk = 1 if f4_7_35dK==5 | f4_7_35dK==6 | f4_7_35dK==7
replace discuss_newprod_wk = 0 if discuss_newprod_wk==.
* L Common (?) business practice
gen discuss_practice = 1 if f4_7_35bxxL==1
replace discuss_practice = 0 if discuss_practice==.
gen discuss_practice_wk = 1 if f4_7_35dL==5 | f4_7_35dL==6 | f4_7_35dL==7
replace discuss_practice_wk = 0 if discuss_practice_wk==.
* M Business plan
gen discuss_bisplan = 1 if f4_7_35bxxM==1
replace discuss_bisplan = 0 if discuss_bisplan==.
gen discuss_bisplan_wk = 1 if f4_7_35dM==5 | f4_7_35dM==6 | f4_7_35dM==7
replace discuss_bisplan_wk = 0 if discuss_bisplan_wk==.



*** Specific people

* Detect missing values in asset var --> 1115, 1045, 1140, 1218, 1178, 1223, 1152, 1133 obs!
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
   replace discuss_fam = discuss_fam+1  if `x'==8
   replace discuss_friend = discuss_friend+1 if `x'==7
   replace discuss_bisfriend = discuss_bisfriend+1 if `x'==6 | `x'==5
   replace discuss_supplier = discuss_supplier+1 if `x'==4
   }

replace discuss_fam = 1 if discuss_fam>0 & discuss_fam!=.
replace discuss_friend = 1 if discuss_friend>0 & discuss_friend!=.
replace discuss_bisfriend = 1 if discuss_bisfriend>0 & discuss_bisfriend!=.
replace discuss_supplier = 1 if discuss_supplier>0 & discuss_supplier!=.

//tab discuss_fam
//tab discuss_friend
//tab discuss_supplier
//tab discuss_bisfriend


***** JOINT DECISION-MAKING ABOUT BUSINESS TOPICS W OTHERS

*** Decision-making w others in general

* Detect missing values in asset var --> 0, 745 obs!
mdesc f4_7_36a f4_7_36bx f4_7_36e

* Dummy for making any business decisions jointly with others
//tab f4_7_36a
gen jointdec_any = 1 if f4_7_36a==1
replace jointdec_any = 0 if jointdec_any==.

* Dummy for joint decision-making w informal agreement (only 7 formal agreements)
gen jointdec_agree = 1 if f4_7_36f==1
replace jointdec_agree = 0 if jointdec_agree==.

* Jointly deciding on anything on a daily basis
gen jointdec_any_day = 0

foreach x of varlist f4_7_36dA f4_7_36dB f4_7_36dC f4_7_36dD f4_7_36dE f4_7_36dF ///
f4_7_36dG f4_7_36dH f4_7_36dI f4_7_36dJ f4_7_36dK f4_7_36dL f4_7_36dM f4_7_36dN ///
f4_7_36dO f4_7_36dP f4_7_36dQ f4_7_36dR f4_7_36dS{
   replace jointdec_any_day = jointdec_any_day+1  if `x'==7
   }

replace jointdec_any_day = 1 if jointdec_any_day>0  & jointdec_any_day!=.
   
//tab jointdec_any_day




*** Specific topics

* Dummy for specific topics decided about jointly with others and how frequently
//tab f4_7_36bx
//tab f4_7_36bxxA
//tab f4_7_36bxxB
//tab f4_7_36bxxC
//tab f4_7_36bxxD // Only 1 business answered in the affirmatve
//tab f4_7_36bxxE // Only 3 businesses answered in the affirmatve
//tab f4_7_36bxxF // 0 businesses answered in the affirmatve
//tab f4_7_36bxxG
//tab f4_7_36bxxH // 0 businesses answered in the affirmatve
//tab f4_7_36bxxI // Only 8 businesses answered in the affirmatve
//tab f4_7_36bxxJ
//tab f4_7_36bxxK
//tab f4_7_36bxxL
//tab f4_7_36bxxM
//tab f4_7_36bxxN // Only 4 businesses answered in the affirmatve
//tab f4_7_36bxxO // Only 2 businesses answered in the affirmatve
//tab f4_7_36bxxP // Only 2 businesses answered in the affirmatve
//tab f4_7_36bxxQ // Only 17 businesses answered in the affirmatve
//tab f4_7_36bxxR // Only 8 businesses answered in the affirmatve
//tab f4_7_36bxxS // Only 16 businesses answered in the affirmatve

//tab f4_7_36dA
//tab f4_7_36dB
//tab f4_7_36dC
//tab f4_7_36dG // Only 17 businesses decide about financing opportunities w others at least weekly
//tab f4_7_36dJ // Only 26 businesses decide about purch price w others at least weekly
//tab f4_7_36dK
//tab f4_7_36dL
//tab f4_7_36dM

* A Sales
gen jointdec_sales = 1 if f4_7_36bxxA==1
replace jointdec_sales = 0 if jointdec_sales==.
gen jointdec_sales_wk = 1 if f4_7_36dA==5 | f4_7_36dA==6 | f4_7_36dA==7
replace jointdec_sales_wk = 0 if jointdec_sales_wk==.
* B Selling price
gen jointdec_sellprice = 1 if f4_7_36bxxB==1
replace jointdec_sellprice = 0 if jointdec_sellprice==.
gen jointdec_sellprice_wk = 1 if f4_7_36dB==5 | f4_7_36dB==6 | f4_7_36dB==7
replace jointdec_sellprice_wk = 0 if jointdec_sellprice_wk==.
* C Best-selling product
gen jointdec_bestseller = 1 if f4_7_36bxxC==1
replace jointdec_bestseller = 0 if jointdec_bestseller==.
gen jointdec_bestseller_wk = 1 if f4_7_36dC==5 | f4_7_36dC==6 | f4_7_36dC==7
replace jointdec_bestseller_wk = 0 if jointdec_bestseller_wk==.
* G Finance opportunities
gen jointdec_finance = 1 if f4_7_36bxxG==1
replace jointdec_finance = 0 if jointdec_finance==.
* J Purchasing price
gen jointdec_buyprice = 1 if f4_7_36bxxJ==1
replace jointdec_buyprice = 0 if jointdec_buyprice==.
* K New brand/product
gen jointdec_newprod = 1 if f4_7_36bxxK==1
replace jointdec_newprod = 0 if jointdec_newprod==.
gen jointdec_newprod_wk = 1 if f4_7_36dK==5 | f4_7_36dK==6 | f4_7_36dK==7
replace jointdec_newprod_wk = 0 if jointdec_newprod_wk==.
* L Common (?) business practice
gen jointdec_practice = 1 if f4_7_36bxxL==1
replace jointdec_practice = 0 if jointdec_practice==.
gen jointdec_practice_wk = 1 if f4_7_36dL==5 | f4_7_36dL==6 | f4_7_36dL==7
replace jointdec_practice_wk = 0 if jointdec_practice_wk==.
* M Business plan
gen jointdec_bisplan = 1 if f4_7_36bxxM==1
replace jointdec_bisplan = 0 if jointdec_bisplan==.
gen jointdec_bisplan_wk = 1 if f4_7_36dM==5 | f4_7_36dM==6 | f4_7_36dM==7
replace jointdec_bisplan_wk = 0 if jointdec_bisplan_wk==.



*** Specific people

* Detect missing values in asset var --> 1115, 1045, 1140, 1218, 1178, 1223, 1152, 1133 obs!
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

//tab jointdec_fam



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
/*this is incorrect

gen reinvest_daily 	= 1 if inlist(f4_8_6, 1,2)
replace reinvest_daily =. if f4_8_6==7==8

gen reinvest_daily_fix_amt = f4_8_7/xchange
gen reinvest_daily_prop_amt = f4_8_11*sales_nday 
gen reinvest_daily_amt = reinvest_daily_fix_amt
replace reinvest_daily_amt = reinvest_daily_prop_amt if reinvest_daily_fix_amt==.
*/


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

* Dummy for above-median shop aspirations
egen asp_shop_md = median(asp_shop_z)
gen asp_AM = (asp_shop_z>asp_shop_md)


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
replace sales_nday=. if sales_nday>25000	

* Gap
gen aspgap12_sales = (asp12_sales - sales_nday) / sales_nday
label var aspgap12_sales "12mth aspirations gap for daily sales"

* Cleaning
extremes aspgap12_sales asp12_sales sales_nday shop_ID

replace asp12_sales=. if aspgap12_sales<0
replace aspgap12_sales=. if aspgap12_sales<0

replace aspgap12_sales=5 if aspgap12_sales>5 & aspgap12_sales!=. 
replace asp12_sales=(1+aspgap12_sales)*sales_nday if aspgap12_sales==5

* Gap 2
gen aspgap12_sales2 = (asp12_sales - sales_nday) / asp12_sales
label var aspgap12_sales2 "12mth aspirations gap for daily sales (norm'ed by aspiration level)"

* Median
egen asp12_sales_md = median(asp12_sales)
gen asp12_sales_AM = (asp12_sales>asp12_sales_md)


*** Aspiration Z-score composites

foreach x of varlist asp12_* aspgap12_* {
	egen `x'_mu = mean(`x')
	egen `x'_sd = sd(`x')
	gen `x'_z = (`x' - `x'_mu)/ `x'_sd
	}

egen asp12_shop_z = rowmean(asp12_size_z asp12_employee_z asp12_customer_z asp12_sales_z)

* Dummy for above-median shop aspirations
egen asp12_shop_md = median(asp12_shop_z)
gen asp12_AM = (asp12_shop_z>asp12_shop_md)




**Sales aspirations follow-ups

*** Importance
gen asp_import = f4_10_3d
replace asp_import =. if asp_import==8 | asp_import==7
label var asp_import "Importance to reach sales asps"

*** Probability
gen asp_prob = f4_10_3e
replace asp_prob =. if asp_prob==7 | asp_prob==8
label var asp_prob "Subj likelihood to reach sales asps"

*** Self-efficacy
gen asp_seff = f4_10_3f
replace asp_seff =. if asp_seff==7 | asp_seff==8
label var asp_seff "Self-efficacy to reach sales asps"

*** LOC
gen asp_loc = f4_10_3g
replace asp_loc =. if asp_loc==7 | asp_loc==8
label var asp_loc "Locus of control to reach sales asps"


foreach x of varlist asp_import asp_prob asp_seff asp_loc {
* Dummy for high importance
gen `x'_sales_highest = (`x'==6)
gen `x'_sales_high = (`x'==6) | (`x'==5)

* Scaled to 0-1
replace `x' = `x'/6

* Median
egen `x'_md = median(`x')
}	

*** CSE

gen asp_cse = (asp_loc+asp_seff)/2
label var asp_cse "Perceived agency (self-efficacy and LOC)"

*Median
egen asp_cse_md = median(asp_cse)



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

gen daughter1_age = f4_10_5a1_age
gen daughter2_age = f4_10_5a2_age
gen daughter3_age = f4_10_5a3_age

gen oldestdaughter_age =.
replace oldestdaughter_age = daughter1_age if (daughter2_age==. | daughter2_age>=18) & daughter1_age<18
replace oldestdaughter_age = daughter2_age if (daughter3_age==. | daughter3_age>=18) & daughter2_age<18
replace oldestdaughter_age = daughter3_age if daughter3_age<18

_crcslbl daughter1_age f4_10_5a1_age
_crcslbl daughter2_age f4_10_5a2_age
_crcslbl daughter3_age f4_10_5a3_age


* Oldest child U18

gen oldestkid_male = .
replace oldestkid_male = 1 if oldestson_age>=oldestdaughter_age & oldestson_age!=. & oldestdaughter_age!=.
replace oldestkid_male = 0 if oldestson_age<oldestdaughter_age & oldestson_age!=. & oldestdaughter_age!=.



*** OCCUPATIONAL ASPIRATIONS


* Son's occup aspirations

gen asp_occup_son_oth = .
replace asp_occup_son_oth = 6 if f4_10_4c_ot=="RETAILERS"
replace asp_occup_son_oth = 7 if f4_10_4c_ot=="MINING" | f4_10_4c_ot=="BLACKSMITH"
replace asp_occup_son_oth = 8 if f4_10_4c_ot=="MACHINIST"
replace asp_occup_son_oth = 11 if f4_10_4c_ot=="MINI MART SUPERVISOR"
replace asp_occup_son_oth = 13 if f4_10_4c_ot=="ADMINISTRATION"
replace asp_occup_son_oth = 14 if inlist(f4_10_4c_ot,"HOTEL","OFFICE MANAGER","MANAGER","OFFICE SUPERVISOR")
replace asp_occup_son_oth = 19 if f4_10_4c_ot=="ARMY" | f4_10_4c_ot=="NAVY"
replace asp_occup_son_oth = 20 if inlist(f4_10_4c_ot,"CS IN PROVINCE AND MINISTERIAL LEVEL","GOVERNOR")
replace asp_occup_son_oth = 25 if inlist(f4_10_4c_ot,"ENGINEER","ELECTRONIC ENGINEER","OIL AND GAS ENGINEER","MECHANICAL ENGINEER")
replace asp_occup_son_oth = 27 if f4_10_4c_ot=="BANKER" | f4_10_4c_ot=="BANK MANAGER"
replace asp_occup_son_oth = 28 if f4_10_4c_ot=="MINISTER"

gen asp_occup_son_nongovt = 1 if inlist(f4_10_4c_ot,"ENTREPRENEUR","CLINIC ENTREPRENEUR","IT ENTREPRENEUR","MEDIA ENTREPRENEUR","IT","PROGRAMMER","SAILORMAN","PREACHER","WORKSHOP") | ///
inlist(f4_10_4c_ot,"WRITER","HEAD OF WORKSHOP","HEAVY EQUIPMENT TECHNICIAN","AUTOMOTIVE TYCOON","TYCOON","OIL TYCOON","ATHLETE","PREACHER & ENTREPRENEUR","DIPLOMAT") | ///
inlist(f4_10_4c_ot,"MARKETING","CONTRACTOR","GRAPHIC DESIGN","AGRICULTURE EXPERT","PRIVATE SECTOR","TOUR AND TRAVEL","CHEF")

gen asp_occup_son = f4_10_4c
replace asp_occup_son = asp_occup_son_oth if asp_occup_son==.
replace asp_occup_son =. if asp_occup_son>94


* Daughter' occup aspirations

gen asp_occup_daughter_oth = .
replace asp_occup_daughter_oth = 6 if f4_10_5c_ot=="RETAILERS"
replace asp_occup_daughter_oth = 7 if f4_10_5c_ot=="MINING" | f4_10_5c_ot=="BLACKSMITH"
replace asp_occup_daughter_oth = 8 if f4_10_5c_ot=="MACHINIST"
replace asp_occup_daughter_oth = 11 if f4_10_5c_ot=="MINI MART SUPERVISOR"
replace asp_occup_daughter_oth = 13 if f4_10_5c_ot=="ADMINISTRATION"
replace asp_occup_daughter_oth = 14 if inlist(f4_10_5c_ot,"HOTEL","OFFICE MANAGER","MANAGER","OFFICE SUPERVISOR","CHEF") 
replace asp_occup_daughter_oth = 19 if f4_10_5c_ot=="ARMY" | f4_10_5c_ot=="NAVY"
replace asp_occup_daughter_oth = 20 if inlist(f4_10_5c_ot,"CS IN PROVINCE AND MINISTERIAL LEVEL","GOVERNOR")
replace asp_occup_daughter_oth = 25 if inlist(f4_10_5c_ot,"ENGINEER","ELECTRONIC ENGINEER","OIL AND GAS ENGINEER","MECHANICAL ENGINEER")
replace asp_occup_daughter_oth = 27 if f4_10_5c_ot=="BANKER" | f4_10_5c_ot=="BANK MANAGER"
replace asp_occup_daughter_oth = 28 if f4_10_5c_ot=="MINISTER"

gen asp_occup_daughter_nongovt = 1	if 	inlist(f4_10_5c_ot,"ENTREPRENEUR","CLINIC ENTREPRENEUR","IT ENTREPRENEUR","MEDIA ENTREPRENEUR","IT","PROGRAMMER","SAILORMAN","PREACHER","WORKSHOP") | ///
inlist(f4_10_5c_ot,"WRITER","HEAD OF WORKSHOP","HEAVY EQUIPMENT TECHNICIAN","AUTOMOTIVE TYCOON","TYCOON","OIL TYCOON","ATHLETE","PREACHER & ENTREPRENEUR","DIPLOMAT") | ///
inlist(f4_10_5c_ot,"MARKETING","CONTRACTOR","GRAPHIC DESIGN","AGRICULTURE EXPERT","PRIVATE SECTOR","TOUR AND TRAVEL")

gen asp_occup_daughter = f4_10_5c
replace asp_occup_daughter = asp_occup_daughter_oth if asp_occup_daughter==.
replace asp_occup_daughter =. if asp_occup_daughter>94


* Kids aspirations

gen asp_occup_kids 		= asp_occup_son
replace asp_occup_kids 	= (asp_occup_son + asp_occup_daughter)/2 if oldestson_age!=. & oldestdaughter_age!=.
replace asp_occup_kids 	= asp_occup_daughter if asp_occup_kids==.


* Dummies for gov't/high aspirations

foreach x of varlist	asp_occup_son asp_occup_daughter{
	
						gen `x'_govt =.
						replace `x'_govt = 0 if `x'!=.
						replace `x'_govt = 1 if inlist(`x',12,13,15,17,18,19,20)

						egen `x'_md = median(`x')
						gen `x'_high = 1 if `x'>`x'_md & `x'!=.
						replace `x'_high = 0 if `x'<=`x' & `x'!=.
						}

replace asp_occup_son_govt = 0 if asp_occup_son_nongovt==1
replace asp_occup_daughter_govt = 0 if asp_occup_daughter_nongovt==1

_crcslbl asp_occup_son_high f4_10_4c
_crcslbl asp_occup_son_govt f4_10_4c
_crcslbl asp_occup_daughter_high f4_10_5c
_crcslbl asp_occup_daughter_govt f4_10_5c


* Dummies for kids

egen asp_occup_kids_md = median(asp_occup_kids)
gen asp_occup_kids_high = 1 if asp_occup_kids>asp_occup_kids_md & asp_occup_kids!=.
replace asp_occup_kids_high = 0 if asp_occup_kids<=asp_occup_kids_md

gen asp_occup_kids_govt =.
replace asp_occup_kids_govt = 1 if asp_occup_daughter_govt==1 | asp_occup_son_govt==1
replace asp_occup_kids_govt = 0 if asp_occup_daughter_govt!=1 & asp_occup_son_govt!=1 & asp_occup_kids!=.



*** EDUCATIONAL ASPIRATIONS

* Aspirations for oldest son U18
gen asp_educ_son = f4_10_4b
replace asp_educ_son = 25 if asp_educ_son==26
gen aspgap_educ_son = (asp_educ_son - educ)/asp_educ_son

* Aspirations for oldest daughter U18
gen asp_educ_daughter = f4_10_5b
gen aspgap_educ_daughter = (asp_educ_daughter - educ)/asp_educ_daughter


* Kids' aspirations
 
gen asp_educ_kids 		= asp_educ_son
replace asp_educ_kids 	= (asp_educ_son + asp_educ_daughter)/2 if (oldestson_age!=. & oldestson_age<=18) & (oldestdaughter_age!=. & oldestdaughter_age<=18)
replace asp_educ_kids 	= asp_educ_daughter if asp_educ_kids==.

gen aspgap_educ_kids = (asp_educ_kids - educ)/asp_educ_kids

* Dummies

foreach x of varlist	asp_educ_son asp_educ_daughter{
	
						gen `x'_ma =.
						replace `x'_ma = 1 if `x'>=17 & `x'!=.
						replace `x'_ma = 0 if `x'<17 & `x'!=.
				
						egen `x'_md = median(`x')
						gen `x'_high = 1 if `x'>`x'_md & `x'!=.
						replace `x'_high = 0 if `x'<=`x' & `x'!=.
						}


* Dummies for kids variable

gen asp_educ_kids_ma =.
replace asp_educ_kids_ma = 1 if asp_educ_kids>=17 & asp_educ_kids!=.
replace asp_educ_kids_ma = 0 if asp_educ_kids<17 & asp_educ_kids!=.

egen asp_educ_kids_md = median(asp_educ_kids)
gen asp_educ_kids_high = 1 if asp_educ_kids>asp_educ_kids_md & asp_educ_kids!=.
replace asp_educ_kids_high = 0 if asp_educ_kids<=asp_educ_kids_md



***** 3 practices to improve the business (free = without prompt)


* Detect missing values in practices vars --> none!

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

*** technology/banking/advertisement/licences
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

*** staff/competitor/shop space
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
	| `x'=="MORE SPIRIT" | | `x'=="FASTING" | `x'=="ACCEPTANCE" |`x'=="" ///
	//| `x'=="RENOVATION"
	//| `x'=="IMPROVE CUSTOMER SERVICE" | `x'=="IMPROVE FINANCIAL SYSTEM" | `x'=="IMPROVE RESTOCK SYSTEM" ///

	}
	

*** 3 most profitable practices, done last year & planned for next year
mdesc f4_10_6b f4_10_6c

gen practices_free_lastyr = f4_10_6b
replace practices_free_lastyr = 0 if f4_10_6b==3
replace practices_free_lastyr =. if practices_free_lastyr==7 | practices_free_lastyr==8

gen practices_free_nextyr = f4_10_6c
replace practices_free_nextyr = 0 if f4_10_6c==3
replace practices_free_nextyr =. if practices_free_nextyr==7 | practices_free_nextyr==8

//tab practices_free_lastyr
//tab practices_free_nextyr
//tab practices_free_bad



*/


************************************************************************
***** INTERVIEWER IMPRESSIONS *******************************************

*check missing value --> no missing obs
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


gen present_spouse = f4_16_1a
gen present_family = f4_16_1b
gen present_otheradult = f4_16_1c
gen present_child_under5 = f4_16_1d
gen present_child_over5 = f4_16_1e
gen present_employee = f4_16_1f
gen present_sm = f4_16_1g
gen present_jpal = f4_16_1h
gen present_tv = f4_16_1i
gen present_custom = f4_16_1j

foreach x of varlist present_* {
	replace `x'= 0  if `x'==3
	}


_crcslbl present_spouse f4_16_1a
_crcslbl present_family f4_16_1b
_crcslbl present_otheradult f4_16_1c
_crcslbl present_child_under5 f4_16_1d
_crcslbl present_child_over5 f4_16_1e
_crcslbl present_employee f4_16_1f
_crcslbl present_sm f4_16_1g
_crcslbl present_jpal f4_16_1h
_crcslbl present_tv f4_16_1i
_crcslbl present_custom f4_16_1j


**interviewer observation --> missing 778 obs in f4_16_05: because only for a shop with Sign
*missing 99 obs in f4_16_02: because no customer coming during the interview
mdesc f4_16_02 f4_16_03 f4_16_03a f4_16_04 f4_16_05 f4_16_06 f4_16_07 ///
f4_16_08 f4_16_09 f4_16_10 f4_16_11 f4_16_12ot f4_16_13

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
//tab f4_16_12ot
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


gen shop_sign = f4_16_04
gen shop_goods_prices = f4_16_06
gen shop_goods_display = f4_16_07
gen shop_shelf_full = f4_16_08
gen shop_advert = f4_16_09
gen shop_clean = f4_16_10
gen shop_bright = f4_16_11

foreach x of varlist shop_* {
	replace `x'= 0  if `x'==3
	}
	

_crcslbl present_custom_no f4_16_02
_crcslbl understand_perfect f4_16_03
_crcslbl shop_house_same f4_16_03a
_crcslbl shop_house_sep f4_16_03a
_crcslbl shop_sign f4_16_04
_crcslbl shop_sign_bright f4_16_05
_crcslbl shop_goods_prices f4_16_06
_crcslbl shop_goods_display f4_16_07
_crcslbl shop_shelf_full f4_16_08
_crcslbl shop_advert f4_16_09
_crcslbl shop_clean f4_16_10
_crcslbl shop_bright f4_16_11


*********************************************************************************
***** LABELLING

label var male				"Respondent's gender (Male=1)"
label var age_manager		"Respondent's age (Years)"
label var educ				"Formal education (Years)"
label var digitspan			"Digit Span (0-8 Scale)"
label var risk_comp			"Risk Preference (0-10 Scale)"
label var time_comp			"Time preference (0-10 Scale)"
label var age_firm			"Business age (Years)"
label var labour_total		"Total number of employees"
label var labour_nonfam_full"Number of full-time employees formally employed"
label var sales_lastmth		"Total sales last month (USD PPP)"
label var prof_lastmth		"Total profits last month (USD PPP)"
label var loan_outstanding	"Business Has Outstanding Loan (Yes=1)"
label var MW_M_score_total	"Marketing Subscore"
label var MW_B_score_total	"Stocking-up Subscore"
label var MW_R_score_total	"Record-keeping Subscore"
label var MW_F_score_total	"Financial Planning Subscore"



********************************************************************************
***** VAR MANAGEMENT

* Drop original vars
drop f4_* *srid type_* f3*


* Add prefix to identify baseline vars after merge
ds shop_ID, not
foreach x in `r(varlist)' { 
	rename `x' W1_`x' 
}

* Order vars
order shop_ID



******************************************************************************
***** DROP OBSERVATIONS

* Dropping 5 observations of Ps Baru
cap drop if W1_village==73071



*******************************************************************************
***** SAVE DATA

save "dta\W1_clean_data.dta", replace

