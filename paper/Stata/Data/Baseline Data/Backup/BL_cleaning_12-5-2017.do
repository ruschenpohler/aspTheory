
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

cd "C:\Users\wb240247\Dropbox\Indonesia Analysis\"

use "Data\Baseline Data\BL_raw_data.dta", clear



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
gen digitspan_total = digitspan + digitspan_rev

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
* Create var for total answers given
gen cogstyle_system_answers = 0
foreach x of varlist cogstyle_system_* {
   replace cogstyle_system_answers = cogstyle_system_answers+1  if `x'<.
   }
* Score
egen cogstyle_system = rowtotal(cogstyle_system_01 ///
cogstyle_system_04 cogstyle_system_05 cogstyle_system_07 ///
cogstyle_system_09)
* Percentage score
gen cogstyle_system_perc = cogstyle_system/cogstyle_system_answers
* Above median score
egen cogstyle_system_md = median(cogstyle_system)
gen cogstyle_system_abvmd = 1 if cogstyle_system>cogstyle_system_md
replace cogstyle_system_abvmd = 0 if cogstyle_system_abvmd==.

*** Intuitive-thinking score
* Create var for total answers given
gen cogstyle_intuit_answers = 0
foreach x of varlist cogstyle_intuit_* {
   replace cogstyle_intuit_answers = cogstyle_intuit_answers+1  if `x'<.
   }
* Score
egen cogstyle_intuit = rowtotal(cogstyle_intuit_02 ///
cogstyle_intuit_03 cogstyle_intuit_06 cogstyle_intuit_08 ///
cogstyle_intuit_10)
* Percentage score
gen cogstyle_intuit_perc = cogstyle_intuit/cogstyle_intuit_answers

*** Relative systematic-thinking score
* Relative systematic-thinking score
gen cogstyle_rel = cogstyle_system-cogstyle_intuit
* Above-median rel score
egen cogstyle_rel_md = median(cogstyle_rel)
gen cogstyle_rel_abvmd = 1 if cogstyle_rel>cogstyle_rel_md
replace cogstyle_rel_abvmd = 0 if cogstyle_rel_abvmd==.
* Above-p80 rel score
egen cogstyle_rel_p80 = pctile(cogstyle_rel), p(80)
gen cogstyle_rel_abv80 = 1 if cogstyle_rel>cogstyle_rel_p80
replace cogstyle_rel_abv80 = 0 if cogstyle_rel_abv80==.

//tab cogstyle_system
//tab cogstyle_intuit
//tab cogstyle_rel
//tab cogstyle_rel_abvmd	// md==1.21
//tab cogstyle_rel_abv80	// p80==1.5

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
replace sales_nday =. if sales_nday>17500

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

//tab credit_TC
//tab credit_TC_int



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

gen reinvest_daily 	= 1 if inlist(f4_8_6, 1,2)
replace reinvest_daily =. if f4_8_6==7==8

gen reinvest_daily_fix_amt = f4_8_7/xchange
gen reinvest_daily_prop_amt = f4_8_11*sales_nday 
gen reinvest_daily_amt = reinvest_daily_fix_amt
replace reinvest_daily_amt = reinvest_daily_prop_amt if reinvest_daily_fix_amt==.



************************************************************************
***** ASPIRATIONS ******************************************************


***** SHOP ASPIRATIONS FOR SHOP SIZE, EMPLOYEES, CUSTOMERS **************************


***** "IDEAL" ASPIRATIONS (INDEFINITE TIME HORIZON)

* Detect missing values in aspiration vars --> none!
mdesc f4_10_01aa f4_10_01a f4_10_01b f4_10_01c f4_10_01d

*** Current shop size
//tab f4_10_01aa
gen space_cont = f4_10_01aa
label val space_cont f4_10_01aa
//tab space_cont
_crcslbl space_cont f4_10_01aa

egen space_cont_md = median(space_cont)

/*
*** "Ideal" aspirations

*"Ideal" size
gen asp_ideal_space = f4_10_01b
replace asp_ideal_space =. if f4_10_01b>9994
label var asp_ideal_space "Ideal aspirations: size"

* "Ideal" no of employees
gen asp_ideal_employ = f4_10_01c
replace asp_ideal_employ =. if f4_10_01c>9994
label var asp_ideal_employ "Ideal aspirations: employees"

* "Ideal" no of customers
gen asp_ideal_custom = f4_10_01d
replace asp_ideal_custom =. if f4_10_01d>9994
label var asp_ideal_custom "Ideal aspirations: customers"


*** Aspiration gaps
gen asp_gap_ideal_space = (asp_ideal_space - space_cont) / asp_ideal_space
gen asp_gap_ideal_employ = (asp_ideal_employ - labour_total) / asp_ideal_employ
gen asp_gap_ideal_custom = (asp_ideal_custom - custom_total) / asp_ideal_custom

foreach x of varlist asp_gap_ideal_* {
	gen `x'_neg = 1 if `x'<0
	replace `x'_neg = 0 if `x'_neg ==.
	gen `x'_0 = 1 if `x'==0
	replace `x'_0 = 0 if `x'_0 ==.
	gen `x'_pos = 1 if `x'>0
	replace `x'_pos = 0 if `x'_pos ==.
	}


*** Time horizon
gen asp_ideal_yrs = f4_10_01e
replace asp_ideal_yrs =. if asp_ideal_yrs>9995
label var asp_ideal_yrs "When do you think you can have achieved this?"

* Dummy for "don't know time horizon" (dream rather than aspiration)
gen asp_ideal_yrs_dk = 1 if f4_10_01e>=9995
replace asp_ideal_yrs_dk = 0 if f4_10_01e<9995


label val asp_ideal_space f4_10_01b
label val asp_ideal_employ f4_10_01c
label val asp_ideal_custom f4_10_01d
label val asp_ideal_yrs f4_10_01e

//tab asp_ideal_space
//tab asp_ideal_employ
//tab asp_ideal_custom
//tab asp_ideal_yrs



***** SHOP ASPIRATION FAILURE

gen asp_fail = 1 if f4_10_01a==3
replace asp_fail = 0 if asp_fail==.



***** 12 MTH ASPIRATIONS

* Detect missing values in aspiration vars --> none!
mdesc f4_10_02a f4_10_02b f4_10_02c


*** 12 mth Aspirations

* Size in 12 mth
gen asp_12mth_space = f4_10_02a
replace	asp_12mth_space =. if f4_10_02a>9995
label var asp_12mth_space "12 mth aspirations: size"
label val asp_12mth_space f4_10_02a

* No of employees in 12 mth
gen asp_12mth_employ = f4_10_02b
replace	asp_12mth_employ =. if f4_10_02b>9995
label val asp_12mth_employ f4_10_02b
label var asp_12mth_employ "12 mth aspirations: employees"

* No of customers in 12 mth
gen asp_12mth_custom = f4_10_02c
replace asp_12mth_custom =. if f4_10_02c>9995
label var asp_12mth_custom "12 mth aspirations: customers"
label val asp_12mth_custom f4_10_02c



*** Aspiration gaps
gen asp_gap_12mth_space =  (asp_12mth_space - space_cont) / asp_12mth_space
gen asp_gap_12mth_employ = (asp_12mth_employ - labour_total) / asp_12mth_employ
gen asp_gap_12mth_custom = (asp_12mth_custom - custom_total) / asp_12mth_custom


* Dummies for neg, zero, pos gaps
foreach x of varlist asp_gap_12mth_* {
	gen `x'_neg = 1 if `x'<0
	replace `x'_neg = 0 if `x'_neg ==.
	gen `x'_0 = 1 if `x'==0
	replace `x'_0 = 0 if `x'_0 ==.
	gen `x'_pos = 1 if `x'>0
	replace `x'_pos = 0 if `x'_pos ==.
	}


* Dummy for permanently neg employee aspirations and those rebounding
gen asp_gap_employ_neg_rebound = 1 if asp_gap_12mth_employ<0 & asp_ideal_employ>asp_12mth_employ
replace asp_gap_employ_neg_rebound = 0 if asp_gap_employ_neg_rebound==.

gen asp_gap_employ_neg_perm = 1 if asp_gap_12mth_employ<0 & asp_ideal_employ<=asp_12mth_employ
replace asp_gap_employ_neg_perm = 0 if asp_gap_employ_neg_perm==.

	
_crcslbl asp_12mth_space f4_10_02a
_crcslbl asp_12mth_employ f4_10_02b
_crcslbl asp_12mth_custom f4_10_02c



*** Linear predictions for 12 mth aspirations *********************************

* Calculated as a linear projection from both today's sales and "ideal" aspirations 
* as well as the time horizon to achieve those


* Linear predictions for 12 mth aspirations
gen asp_12mth_lpred_space = ((asp_ideal_space - space_cont)/asp_ideal_yrs) + space_cont
replace asp_12mth_lpred_space =. if asp_gap_ideal_space_pos==0

gen asp_12mth_lpred_employ = ((asp_ideal_employ - labour_total)/asp_ideal_yrs) + labour_total
replace asp_12mth_lpred_employ =. if asp_gap_ideal_employ_pos==0

gen asp_12mth_lpred_custom = ((asp_ideal_custom - custom_total)/asp_ideal_yrs) + custom_total
replace asp_12mth_lpred_custom =. if asp_gap_ideal_custom_pos==0


* Gap to lin predictions for 12mth aspirations
gen asp_12mth_resid_space = asp_12mth_space - asp_12mth_lpred_space
gen asp_12mth_resid_employ = asp_12mth_employ - asp_12mth_lpred_employ
gen asp_12mth_resid_custom = asp_12mth_custom - asp_12mth_lpred_custom


* Dummies for reported 12mth aspirations below prediction
gen asp_12mth_fail_space = 1 if asp_12mth_resid_space>0 & asp_12mth_resid_space!=.
replace asp_12mth_fail_space = 0 if asp_12mth_fail_space==.

gen asp_12mth_fail_employ = 1 if asp_12mth_resid_employ>0 & asp_12mth_resid_employ!=.
replace asp_12mth_fail_employ = 0 if asp_12mth_fail_space==.

gen asp_12mth_fail_custom = 1 if asp_12mth_resid_custom>0 & asp_12mth_resid_custom!=.
replace asp_12mth_fail_custom = 0 if asp_12mth_fail_space==.



***** ASPIRATIONS FOR SALES ****************************************************

* Due to an error in the survey questions, some questions were asked for profits, some for sales

* Detect missing values in aspiration vars --> none!
mdesc f4_10_3a f4_10_3b f4_10_3c f4_10_3h


*** Aspirations (12 mth)
gen asp_12mth_sales = f4_10_3c
replace asp_12mth_sales =. if f4_10_3c>999999999996
replace asp_12mth_sales = asp_12mth_sales/xchange
label var asp_12mth_sales "Sales aspirations in 12mth"
label val asp_12mth_sales f4_10_3c
//tab asp_12mth_sales


*** Aspirations gap
gen asp_gap_12mth_sales = (asp_12mth_sales - sales_nday) / asp_12mth_sales

gen asp_gap_12mth_sales_neg = 1 if asp_gap_12mth_sales<0
replace asp_gap_12mth_sales_neg = 0 if asp_gap_12mth_sales_neg ==.

gen asp_gap_12mth_sales_0 = 1 if asp_gap_12mth_sales==0
replace asp_gap_12mth_sales_0 = 0 if asp_gap_12mth_sales_0 ==.

gen asp_gap_12mth_sales_pos = 1 if asp_gap_12mth_sales>0
replace asp_gap_12mth_sales_pos = 0 if asp_gap_12mth_sales_pos ==.


*** Importance
mdesc f4_10_3d
gen asp_import_sales = f4_10_3d
replace asp_import_sales =. if asp_import_sales==8 | asp_import_sales==7
label val asp_import_sales f4_10_3d
* Dummy for high importance
gen asp_import_sales_highest = 1 if asp_import_sales==6
replace asp_import_sales_highest = 0 if asp_import_sales<6
* Scaled to 0-1
gen asp_import_sales_scaled = asp_import_sales/6

*** Probability
mdesc f4_10_3e
gen asp_prob_sales = f4_10_3e
replace asp_prob_sales =. if asp_prob_sales==7 | asp_prob_sales==8
label val asp_prob_sales f4_10_3e
* Dummy for high confidence
gen asp_prob_sales_highest = 1 if asp_prob_sales==6
replace asp_prob_sales_highest = 0 if asp_prob_sales<6
* Scaled to 0-1
gen asp_prob_sales_scaled = asp_prob_sales/6

*** Self-efficacy
mdesc f4_10_3e
gen asp_seff_sales = f4_10_3f
replace asp_seff_sales =. if asp_seff_sales==7 | asp_seff_sales==8
label val asp_seff_sales f4_10_3f
* Dummy for high self-efficacy
gen asp_seff_sales_highest = 1 if asp_seff_sales==6
replace asp_seff_sales_highest = 0 if asp_seff_sales<6
* Scaled to 0-1
gen asp_seff_sales_scaled = asp_seff_sales/6
egen asp_seff_sales_scaled_md = median(asp_seff_sales_scaled)

*** LOC
mdesc f4_10_3f
gen asp_loc_sales = f4_10_3g
replace asp_loc_sales =. if asp_loc_sales==7 | asp_loc_sales==8
label val asp_loc_sales f4_10_3g
* Dummy for high value (internal)
gen asp_loc_sales_highest = 1 if asp_loc_sales==6
replace asp_loc_sales_highest = 0 if asp_loc_sales<6
* Scaled to 0-1
gen asp_loc_sales_scaled = asp_loc_sales/6
egen asp_loc_sales_scaled_md = median(asp_loc_sales_scaled)

*** CSE
gen asp_cse_sales_scaled = asp_loc_sales_scaled*asp_seff_sales_scaled
egen asp_cse_sales_scaled_md = median(asp_cse_sales_scaled)



*** Aspiration composites ******************************************************


* Ideal aspirations composite

egen asp_ideal_space_mu = mean(asp_ideal_space)
egen asp_ideal_space_sd = sd(asp_ideal_space)
gen asp_ideal_space_z = (asp_ideal_space - asp_ideal_space_mu)/ asp_ideal_space_sd

egen asp_ideal_employ_mu = mean(asp_ideal_employ)
egen asp_ideal_employ_sd = sd(asp_ideal_employ)
gen asp_ideal_employ_z = (asp_ideal_employ - asp_ideal_employ_mu)/ asp_ideal_employ_sd

egen asp_ideal_custom_mu = mean(asp_ideal_custom)
egen asp_ideal_custom_sd = sd(asp_ideal_custom)
gen asp_ideal_custom_z = (asp_ideal_custom - asp_ideal_custom_mu)/ asp_ideal_custom_sd

gen asp_ideal_shop = (asp_ideal_space_z + asp_ideal_employ_z + asp_ideal_custom_z)/3


* Ideal aspiration gap composite

egen asp_gap_ideal_space_mu = mean(asp_gap_ideal_space)
egen asp_gap_ideal_space_sd = sd(asp_gap_ideal_space)
gen asp_gap_ideal_space_z = (asp_gap_ideal_space - asp_gap_ideal_space_mu)/ asp_gap_ideal_space_sd

egen asp_gap_ideal_employ_mu = mean(asp_gap_ideal_employ)
egen asp_gap_ideal_employ_sd = sd(asp_gap_ideal_employ)
gen asp_gap_ideal_employ_z = (asp_gap_ideal_employ - asp_gap_ideal_employ_mu)/ asp_gap_ideal_employ_sd

egen asp_gap_ideal_custom_mu = mean(asp_gap_ideal_custom)
egen asp_gap_ideal_custom_sd = sd(asp_gap_ideal_custom)
gen asp_gap_ideal_custom_z = (asp_gap_ideal_custom - asp_gap_ideal_custom_mu)/ asp_gap_ideal_custom_sd

gen asp_gap_ideal_shop = (asp_gap_ideal_space_z + asp_gap_ideal_employ_z + asp_gap_ideal_custom_z)/3


* 12mth aspirations composite

egen asp_12mth_space_mu = mean(asp_12mth_space)
egen asp_12mth_space_sd = sd(asp_12mth_space)
gen asp_12mth_space_z = (asp_12mth_space - asp_12mth_space_mu)/ asp_12mth_space_sd

egen asp_12mth_employ_mu = mean(asp_12mth_employ)
egen asp_12mth_employ_sd = sd(asp_12mth_employ)
gen asp_12mth_employ_z = (asp_12mth_employ - asp_12mth_employ_mu)/ asp_12mth_employ_sd

egen asp_12mth_custom_mu = mean(asp_12mth_custom)
egen asp_12mth_custom_sd = sd(asp_12mth_custom)
gen asp_12mth_custom_z = (asp_12mth_custom - asp_12mth_custom_mu)/ asp_12mth_custom_sd

gen asp_12mth_shop = (asp_12mth_space_z + asp_12mth_employ_z + asp_12mth_custom_z)/3

egen asp_12mth_shop_md = median(asp_12mth_shop)
gen asp_12mth_shop_abvmd = 0
replace asp_12mth_shop_abvmd= 1 if asp_12mth_shop>asp_12mth_shop_md


* 12mth aspiration gap composite

egen asp_gap_12mth_space_mu = mean(asp_gap_12mth_space)
egen asp_gap_12mth_space_sd = sd(asp_gap_12mth_space)
gen asp_gap_12mth_space_z = (asp_gap_12mth_space - asp_gap_12mth_space_mu)/ asp_gap_12mth_space_sd

egen asp_gap_12mth_employ_mu = mean(asp_gap_12mth_employ)
egen asp_gap_12mth_employ_sd = sd(asp_gap_12mth_employ)
gen asp_gap_12mth_employ_z = (asp_gap_12mth_employ - asp_gap_12mth_employ_mu)/ asp_gap_12mth_employ_sd

egen asp_gap_12mth_custom_mu = mean(asp_gap_12mth_custom)
egen asp_gap_12mth_custom_sd = sd(asp_gap_12mth_custom)
gen asp_gap_12mth_custom_z = (asp_gap_12mth_custom - asp_gap_12mth_custom_mu)/ asp_gap_12mth_custom_sd

gen asp_gap_12mth_shop = (asp_gap_12mth_space_z + asp_gap_12mth_employ_z + asp_gap_12mth_custom_z)/3


*** Weighted aspirations *********************************************************


*** Ideal shop aspirations

egen asp_ideal_yrs_md			= median(asp_ideal_yrs)

gen asp_ideal_shop_yrs			= asp_ideal_shop/asp_ideal_yrs
replace asp_ideal_shop_yrs		= asp_ideal_shop/asp_ideal_yrs_md if asp_ideal_yrs==.

gen asp_gap_ideal_shop_yrs 		= asp_gap_ideal_shop/asp_ideal_yrs
replace asp_gap_ideal_shop_yrs 	= asp_gap_ideal_shop/asp_ideal_yrs_md if asp_ideal_yrs==.

gen asp_ideal_shop_cse 			= asp_ideal_shop_yrs * asp_seff_sales_scaled * asp_loc_sales_scaled
gen asp_ideal_shop_probimp 		= asp_ideal_shop_yrs * asp_prob_sales_scaled * asp_import_sales_scaled
gen asp_gap_ideal_shop_cse 		= asp_gap_ideal_shop_yrs * asp_seff_sales_scaled * asp_loc_sales_scaled
gen asp_gap_ideal_shop_seff 	= asp_gap_ideal_shop_yrs * asp_seff_sales_scaled
gen asp_gap_ideal_shop_imp 		= asp_gap_ideal_shop_yrs * asp_import_sales_scaled
gen asp_gap_ideal_shop_prob 	= asp_gap_ideal_shop_yrs * asp_prob_sales_scaled
gen asp_gap_ideal_shop_cseimp 	= asp_gap_ideal_shop_yrs * asp_seff_sales_scaled * asp_loc_sales_scaled * asp_import_sales_scaled
gen asp_gap_ideal_shop_probimp 	= asp_gap_ideal_shop_yrs * asp_prob_sales_scaled * asp_import_sales_scaled


*** 12 mth shop aspirations

gen asp_12mth_shop_cse 					= asp_12mth_shop * asp_seff_sales_scaled * asp_loc_sales_scaled
gen asp_gap_12mth_shop_cse 				= asp_gap_12mth_shop * asp_seff_sales_scaled * asp_loc_sales_scaled
gen asp_12mth_shop_probimp 				= asp_12mth_shop * asp_import_sales_scaled * asp_prob_sales_scaled
gen asp_gap_12mth_shop_probimp 			= asp_gap_12mth_shop * asp_prob_sales_scaled * asp_import_sales_scaled
gen asp_gap_12mth_shop_seff 			= asp_gap_12mth_shop * asp_seff_sales_scaled
gen asp_gap_12mth_shop_imp 				= asp_gap_12mth_shop * asp_import_sales_scaled
gen asp_gap_12mth_shop_cseimp 			= asp_gap_12mth_shop * asp_seff_sales_scaled * asp_loc_sales_scaled * asp_import_sales_scaled



* 12 mth space aspirations

gen asp_12mth_space_cse 				= asp_12mth_space * asp_seff_sales_scaled * asp_loc_sales_scaled
gen asp_gap_12mth_space_cse 			= asp_gap_12mth_space * asp_seff_sales_scaled * asp_loc_sales_scaled
gen asp_12mth_space_probimp				= asp_12mth_space * asp_prob_sales_scaled * asp_import_sales_scaled
gen asp_gap_12mth_space_probimp			= asp_gap_12mth_space * asp_prob_sales_scaled * asp_import_sales_scaled


* 12 mth employee aspirations

gen asp_12mth_employ_cse 				= asp_12mth_employ * asp_seff_sales_scaled * asp_loc_sales_scaled
gen asp_gap_12mth_employ_cse 			= asp_gap_12mth_employ * asp_seff_sales_scaled * asp_loc_sales_scaled
gen asp_12mth_employ_probimp			= asp_12mth_employ * asp_prob_sales_scaled * asp_import_sales_scaled
gen asp_gap_12mth_employ_probimp		= asp_gap_12mth_employ * asp_prob_sales_scaled * asp_import_sales_scaled


* 12 mth customer aspirations

gen asp_12mth_custom_cse 				= asp_12mth_custom * asp_seff_sales_scaled * asp_loc_sales_scaled
gen asp_gap_12mth_custom_cse 			= asp_gap_12mth_custom * asp_seff_sales_scaled * asp_loc_sales_scaled
gen asp_12mth_custom_probimp			= asp_12mth_custom * asp_prob_sales_scaled * asp_import_sales_scaled
gen asp_gap_12mth_custom_probimp		= asp_gap_12mth_custom * asp_prob_sales_scaled * asp_import_sales_scaled


*** 12 mth sales aspirations

gen asp_12mth_sales_cse 				= asp_12mth_sales * asp_seff_sales_scaled * asp_loc_sales_scaled
gen asp_gap_12mth_sales_cse 			= asp_gap_12mth_sales * asp_seff_sales_scaled * asp_loc_sales_scaled
gen asp_12mth_sales_probimp				= asp_12mth_sales * asp_prob_sales_scaled * asp_import_sales_scaled
gen asp_gap_12mth_sales_probimp			= asp_gap_12mth_sales * asp_prob_sales_scaled * asp_import_sales_scaled


_crcslbl asp_12mth_sales f4_10_3c 
_crcslbl asp_gap_12mth_sales f4_10_3c
_crcslbl asp_import_sales f4_10_3d
_crcslbl asp_prob_sales f4_10_3e
_crcslbl asp_seff_sales f4_10_3e
_crcslbl asp_loc_sales f4_10_3f



***** ASPIRATIONS FOR PROFITS **************************************************


* Due to an error in the survey questions, some questions were asked for profits, some for sales

* Minimum acceptable profits
gen asp_min_prof = f4_10_3b
replace asp_min_prof=. if f4_10_3b>999999999996
replace asp_min_prof = asp_min_prof/xchange
label val asp_min_prof f4_10_3b
//tab asp_min_prof
* Distance from today's to minimum profits normalised by today's profits (%)
gen asp_gap_min_prof = (prof_nday - asp_min_prof)/prof_nday
* IHS
gen asp_gap_min_prof_ihs = ln(asp_gap_min_prof + sqrt(asp_gap_min_prof^2 +1))

* Aspirations (18 mth)
gen asp_18mth_prof = f4_10_3h
replace asp_18mth_prof=. if f4_10_3h>999999999996
replace asp_18mth_prof = asp_18mth_prof/xchange
label val asp_18mth_prof f4_10_3h
//tab asp_18mth_prof

/*
* Backing out sales aspiration at 18mth
gen asp_18mth_sales = asp_18mth_prof * (1+prof_nday_frac)

* Aspiration gaps
gen asp_gap_18mth_prof = (asp_18mth_prof - prof_nday) / asp_18mth_prof

gen asp_gap_18mth_prof_neg = 1 if asp_gap_18mth_prof<0
replace asp_gap_18mth_prof_neg = 0 if asp_gap_18mth_prof_neg ==.

gen asp_gap_18mth_prof_0 = 1 if asp_gap_18mth_prof==0
replace asp_gap_18mth_prof_0 = 0 if asp_gap_18mth_prof_0 ==.

gen asp_gap_18mth_prof_pos = 1 if asp_gap_18mth_prof>0
replace asp_gap_18mth_prof_pos = 0 if asp_gap_18mth_prof_pos ==.

gen asp_gap_18mth_sales = asp_gap_18mth_prof * (1+prof_nday_frac)



_crcslbl asp_min_prof f4_10_3b
_crcslbl asp_18mth_prof f4_10_3h
_crcslbl asp_gap_min_prof f4_10_3b
*/


***** ASPIRATIONS FOR OFFSPRING ************************************************

* Detect missing values in aspiration vars --> XX
mdesc f4_10_4a1_age f4_10_4a2_age f4_10_4a3_age f4_10_4b f4_10_4c f4_10_4c_ot ///
f4_10_5a1_age f4_10_5a1_age f4_10_5a1_age f4_10_5b f4_10_5c f4_10_5c_ot

//tab f4_10_4a1_age
//tab f4_10_4a1_age
//tab f4_10_4a1_age
//tab f4_10_4b
//tab f4_10_4c
//tab f4_10_4c_ot

//tab f4_10_5a1_age
//tab f4_10_5a1_age
//tab f4_10_5a1_age
//tab f4_10_5b
//tab f4_10_5c
//tab f4_10_5c_ot



* Son's other

gen asp_occup_son_oth = 0
replace asp_occup_son_oth = 6 if f4_10_4c_ot=="RETAILERS"
replace asp_occup_son_oth = 7 if f4_10_4c_ot=="MINING"
replace asp_occup_son_oth = 11 if f4_10_4c_ot=="MINI MART SUPERVISOR"
replace asp_occup_son_oth = 14 if f4_10_4c_ot=="HOTEL" | f4_10_4c_ot=="OFFICE MANAGER" | ///
f4_10_4c_ot=="OFFICE SUPERVISOR" | f4_10_4c_ot=="ADMINISTRATION" 
replace asp_occup_son_oth = 19 if f4_10_4c_ot=="ARMY" | f4_10_4c_ot=="NAVY"
replace asp_occup_son_oth = 20 if f4_10_4c_ot=="CS IN PROVINCE AND MINISTERIAL LEVEL"
replace asp_occup_son_oth = 25 if f4_10_4c_ot=="ENGINEER" | f4_10_4c_ot=="ELECTRONIC ENGINEER" | ///
f4_10_4c_ot=="OIL AND GAS ENGINEER" | f4_10_4c_ot=="MECHANICAL ENGINEER"
replace asp_occup_son_oth = 27 if f4_10_4c_ot=="BANKER" | f4_10_4c_ot=="BANK MANAGER"

gen asp_occup_son_employ = 1 if f4_10_4c_ot=="EMPLOYEE"
replace asp_occup_son_employ = 0 if asp_occup_son_employ==.

gen asp_occup_son_entrep = 1 if f4_10_4c_ot=="ENTREPRENEUR"
replace asp_occup_son_entrep = 0 if asp_occup_son_entrep==.

gen asp_occup_son = f4_10_4c
replace asp_occup_son = asp_occup_son_oth if asp_occup_son==.
replace asp_occup_son =. if asp_occup_son>94


* Daughter' other

gen asp_occup_daughter_oth = 0
replace asp_occup_daughter_oth = 6 if f4_10_4c_ot=="RETAILERS"
replace asp_occup_daughter_oth = 7 if f4_10_4c_ot=="MINING"
replace asp_occup_daughter_oth = 11 if f4_10_4c_ot=="MINI MART SUPERVISOR"
replace asp_occup_daughter_oth = 14 if f4_10_4c_ot=="HOTEL" | f4_10_4c_ot=="OFFICE MANAGER" | ///
f4_10_4c_ot=="OFFICE SUPERVISOR" | f4_10_4c_ot=="ADMINISTRATION" 
replace asp_occup_daughter_oth = 19 if f4_10_4c_ot=="ARMY" | f4_10_4c_ot=="NAVY"
replace asp_occup_daughter_oth = 20 if f4_10_4c_ot=="CS IN PROVINCE AND MINISTERIAL LEVEL"
replace asp_occup_daughter_oth = 25 if f4_10_4c_ot=="ENGINEER" | f4_10_4c_ot=="ELECTRONIC ENGINEER" | ///
f4_10_4c_ot=="OIL AND GAS ENGINEER" | f4_10_4c_ot=="MECHANICAL ENGINEER"
replace asp_occup_daughter_oth = 27 if f4_10_4c_ot=="BANKER" | f4_10_4c_ot=="BANK MANAGER"

gen asp_occup_daughter_employ = 1 if f4_10_4c_ot=="EMPLOYEE"
replace asp_occup_daughter_employ = 0 if asp_occup_daughter_employ==.

gen asp_occup_daughter_entrep = 1 if f4_10_4c_ot=="ENTREPRENEUR"
replace asp_occup_daughter_entrep = 0 if asp_occup_daughter_entrep==.

* 771 zeros, though zero was not an answer
gen asp_occup_daughter = f4_10_5c
replace asp_occup_daughter = asp_occup_daughter_oth if asp_occup_daughter==.
replace asp_occup_daughter =. if asp_occup_daughter>94


*** Aspirations for oldest son U18

gen son1_age = f4_10_4a1_age
gen son2_age = f4_10_4a2_age
gen son3_age = f4_10_4a3_age

* Oldest son's age
gen oldestson_age =.
replace oldestson_age =. if son1_age==.
replace oldestson_age = son1_age if (son2_age==. | son2_age>=18) & son1_age<18
replace oldestson_age = son2_age if (son3_age==. | son3_age>=18) & son2_age<18
replace oldestson_age = son3_age if son3_age<18

gen asp_educ_son = f4_10_4b
gen asp_educ_son_ma =.
replace asp_educ_son_ma = 1 if f4_10_4b>=17 & f4_10_4b!=.
replace asp_educ_son_ma = 0 if f4_10_4b<17 & f4_10_4b!=.

egen asp_occup_son_md = median(asp_occup_son)
gen asp_occup_son_high = 1 if asp_occup_son>asp_occup_son_md
gen asp_occup_son_govt = 1 if f4_10_4c==12 | f4_10_4c==15 | f4_10_4c==18 | f4_10_4c==19 | f4_10_4c==20 


//tab son1_age
//tab son2_age
//tab son3_age
//tab oldestson_age
//tab asp_educ_son_ma
//tab asp_occup_son_high
//tab asp_occup_son_govt


_crcslbl son1_age f4_10_4a1_age
_crcslbl son2_age f4_10_4a2_age
_crcslbl son3_age f4_10_4a3_age
_crcslbl asp_educ_son_ma f4_10_4b
_crcslbl asp_occup_son_high f4_10_4c
_crcslbl asp_occup_son_govt f4_10_4c



*** Aspirations for oldest daughter U18

gen daughter1_age = f4_10_5a1_age
gen daughter2_age = f4_10_5a2_age
gen daughter3_age = f4_10_5a3_age


* Oldest daughter's age
gen oldestdaughter_age =.
replace oldestdaughter_age =. if daughter1_age==.
replace oldestdaughter_age = daughter1_age if (daughter2_age==. | daughter2_age>=18) & daughter1_age<18
replace oldestdaughter_age = daughter2_age if (daughter3_age==. | daughter3_age>=18) & daughter2_age<18
replace oldestdaughter_age = daughter3_age if daughter3_age<18

gen asp_educ_daughter = f4_10_5b
gen asp_educ_daughter_ma =.
replace asp_educ_daughter_ma = 1 if f4_10_5b>=17 & f4_10_5b!=.
replace asp_educ_daughter_ma = 0 if f4_10_5b<17 & f4_10_5b!=.

egen asp_occup_daughter_md = median(asp_occup_daughter)
gen asp_occup_daughter_high = 1 if asp_occup_daughter>asp_occup_daughter_md
gen asp_occup_daughter_govt = 1 if f4_10_5c==12 | f4_10_5c==15 | f4_10_5c==18 | f4_10_5c==19 | f4_10_5c==20 

//tab daughter1_age
//tab daughter2_age
//tab daughter3_age
//tab oldestdaughter_age
//tab asp_educ_daughter_ma
//tab asp_occup_daughter_high
//tab asp_occup_daughter_govt

_crcslbl daughter1_age f4_10_4a1_age
_crcslbl daughter2_age f4_10_4a2_age
_crcslbl daughter3_age f4_10_4a3_age
_crcslbl asp_educ_daughter_ma f4_10_4b
_crcslbl asp_occup_daughter_high f4_10_4c
_crcslbl asp_occup_daughter_govt f4_10_4c


*** Kids aspirations

gen asp_educ_kids 		= asp_educ_son
replace asp_educ_kids 	= (asp_educ_son + asp_educ_daughter)/2 if oldestson_age!=. & oldestdaughter_age!=.
replace asp_educ_kids 	= asp_educ_daughter if asp_educ_kids==.

gen asp_occup_kids 		= asp_occup_son
replace asp_occup_kids 	= (asp_occup_son + asp_occup_daughter)/2 if oldestson_age!=. & oldestdaughter_age!=.
replace asp_occup_kids 	= asp_occup_daughter if asp_occup_kids==.

* Dummies
egen asp_educ_kids_md = median(asp_educ_kids)

gen asp_educ_kids_high =.
replace asp_educ_kids_high = 1 if asp_educ_kids>asp_educ_kids_md
replace asp_educ_kids_high = 0 if asp_educ_kids<=asp_educ_kids_md & asp_educ_kids!=.

egen asp_occup_kids_md = median(asp_occup_kids)
gen asp_occup_kids_high = 1 if asp_occup_kids>asp_occup_kids_md & asp_occup_kids!=.
replace asp_occup_kids_high = 0 if asp_occup_kids<=asp_occup_kids_md

gen asp_occup_kids_govt =.
replace asp_occup_kids_govt = 1 if asp_occup_daughter_govt==1 | asp_occup_son_govt==1
replace asp_occup_kids_govt = 0 if asp_occup_daughter_govt!=1 & asp_occup_son_govt!=1 & asp_occup_kids!=.



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


***** Transformations *********************************************************

local asp1				asp_ideal_space asp_ideal_employ asp_ideal_custom asp_ideal_shop ///
						asp_gap_ideal_space asp_gap_ideal_employ asp_gap_ideal_custom asp_gap_ideal_shop ///
						asp_12mth_space asp_12mth_employ asp_12mth_custom asp_12mth_shop ///
						asp_gap_12mth_space asp_gap_12mth_employ asp_gap_12mth_custom asp_gap_12mth_shop ///
						asp_12mth_space_cse asp_12mth_employ_cse asp_12mth_custom_cse asp_12mth_shop_cse /// 	
						asp_12mth_sales asp_gap_12mth_sales asp_12mth_sales_cse

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


*******************************************************************************
***** LABEL VARIABLES
/*
label var shop_ID								"Shop ID"
label var W1_gps_dms_lat						"GPS (deg/min): latitude"
label var W1_gps_dms_long						"GPS (deg/min): longitude"
label var W1_gps_dms_lat_sig					"GPS (deg/min): latitude sign N/S"
label var W1_gps_dms_lat_deg					"GPS (deg/min): latitude degrees"
label var W1_gps_dms_lat_min					"GPS (deg/min): latitude minutes"
label var W1_gps_dms_long_sig					"GPS (deg/min): longitude sign W/E"
label var W1_gps_dms_long_deg					"GPS (deg/min): longitude degrees"
label var W1_gps_dms_long_min					"GPS (deg/min): longitude minutes"
label var W1_gps_dms_latlong					"GPS (deg/min): latitude-longitude"
label var W1_gps_dec_lat						"GPS (decimal): latitude"
label var W1_gps_dec_long						"GPS (decimal): longitude"
label var W1_village							"Village code"
label var W1_gps_elevat							"Elevation with respect to sea-level"
label var W1_xchange							"Exchange rate at BL (USD PPP)"
label var W1_age_manager						"Respondent's age at BL"
label var W1_age_manager_abvmd					"Dummy for respondent's age being above md"
label var W1_male								"Gender (male=1)"
label var W1_kids_1								"Dummy for having children"
label var W1_kids_3								"Dummy for >= 3 children"
label var W1_kids_young_1						"Dummy for >=1 child under 7"
label var W1_educ								"Years of education"
label var W1_educ_second						"Dummy for having sec education"
label var W1_educ_terc							"Dummy for having bachelor deg"
label var W1_motive_entrep						"Dummy for entrepreneurial motive"
label var W1_motive_continue					"Dummy for motive being continuation of shop"
label var W1_motive_hobby						"Dummy for motive being hobby/work-life bal"
label var W1_motive_lowOC						"Dummy for motive being job loss"
label var W1_motive_weak						"Dummy for motive being hobby"
label var W1_motive_fambis						"Dummy for motive being fam business"
label var W1_motive_cont_fam					"Dummy for motive cont fam business"
label var W1_digitspan							"Digitspan (STM)"
label var W1_digitspan_rev						"Digitspan reversed (WM)"
label var W1_digitspan_total					"Digitspan total"
label var W1_trust_employ						"Trust in employees"
label var W1_trust_suppl						"Trust in suppliers"
label var W1_trust_custom						"Trust in customers"
label var W1_trust_othfirm						"Trust in other firms"
label var W1_trust_fam							"Trust in family"
label var W1_trust_neigh						"Trust in neighbours"
label var W1_trust_friend						"Trust in friends"
label var W1_trust_stranger						"Trust in strangers"
label var W1_trust_in							"Trust in ingroup"
label var W1_trust_out							"Trust in outgroup"
label var W1_trust_mean							"Trust in (mean)"
label var W1_trust_out_scaled					"Trust in outgroup (0-1)"
label var W1_trust_in_scaled					"Trust in ingroup (0-1)"
label var W1_trust_stranger_scaled				"Trust in strangers (0-1)"
label var W1_trust_employ_scaled				"Trust in employees (0-1)"
label var W1_trust_neigh_scaled					"Trust in neighbours (0-1)"
label var W1_trust_fam_scaled					"Trust in family (0-1)"
label var W1_cogstyle_system_01					"Working style: plan before action"
label var W1_cogstyle_intuit_02					"Working style: often follow instincts"
label var W1_cogstyle_intuit_03					"Working style: a way of conduct if feels right"
label var W1_cogstyle_system_04					"Working style: gather info before working"
label var W1_cogstyle_system_05					"Working style: follow plan when doing important"
label var W1_cogstyle_intuit_06					"Working style: start working without any idea"
label var W1_cogstyle_system_07					"Working style: system and organized decision making"
label var W1_cogstyle_intuit_08					"Working style: decide based on feelings and emotions"
label var W1_cogstyle_system_09					"Working style: choose best alternatives"
label var W1_cogstyle_intuit_10					"Working style: good decision not knowing how"
label var W1_cogstyle_system_answers			"Systematic working style (answers given)"
label var W1_cogstyle_system					"Systematic working style score at BL"
label var W1_cogstyle_system_perc				"Systematic working style % score at BL"
label var W1_cogstyle_system_abvmd				"Dummy for systematic working style above md at BL"
label var W1_cogstyle_intuit_answers			"Intuitive working style (answers given)"
label var W1_cogstyle_intuit					"Intuitive working style score at BL"
label var W1_cogstyle_intuit_perc				"Intuitive working style % score at BL"
label var W1_cogstyle_rel						"Working style: Rel score system-intuit"
label var W1_cogstyle_rel_abvmd					"Working style: Rel score system (abvmd)"
label var W1_cogstyle_rel_p80					"Working style: Rel score system (p80)"
label var W1_cogstyle_rel_abv80					"Working style: Rel score system (abv80)"
label var W1_time_fin							"Time preferences at BL (financial)"
label var W1_time_bis							"Time preferences at BL (business)"
label var W1_time_gen							"Time preferences at BL (general("
label var W1_time_comp							"Time preferences ay BL (composite)"
label var W1_risk_fin							"Risk preferences at BL (financial)"
label var W1_risk_bis							"Risk preferences at BL (business)"
label var W1_risk_gen							"Risk preferences at BL (general)"
label var W1_risk_comp							"Risk preferences at BL (composite)"
label var W1_formal_reg							"Dummy for having company reg cert"
label var W1_formal_tax							"Dummy for having tax ID"
label var W1_formal_vat							"Dummy for having VAT no"
label var W1_age_firm							"Firm's age"
label var W1_age_firm_manager					"Dummy firm older than manager"
label var W1_age_firm_prior2007					"Dummy firm open before 2007"
label var W1_age_firm_prior2013					"Dummy firm open before 2013"
label var W1_age_firm_abvmd						"Dummy firm's age (abvmd)"
label var W1_space_micro						"Dummy for shop space <= 6 sqm"
label var W1_space_small						"Dummy for shop space > 6 & <= 10 sqm"
label var W1_space_mid							"Dummy for shop space > 10 sqm"
label var W1_space_cont_micro					"Dummy for shop space <= 6 sqm (cont., asp)"
label var W1_space_cont_small					"Dummy for shop space > 6 & <= 10 sqm (cont., asp)"
label var W1_space_cont_mid						"Dummy for shop space > 10 sqm (cont., asp)"
label var W1_space_ord							"Space (ordinal)"
label var W1_space_store						"Prop storage to total area"
label var W1_space_store_yes					"Dummy for having storage space"
label var W1_space_own							"Dummy for owning shop space"
label var W1_space_rent							"Dummy for renting shop space"
label var W1_space_use							"Dummy for shop space used w/out cost"
label var W1_open								"Total opening hours at BL"
label var W1_open_pp							"Total opening hours at BL (pp)"
label var W1_open_break							"Total break time at BL"
label var W1_open_net							"Opening hours net of breaks at BL"
label var W1_open_net_pp						"Opening hours net of breaks at BL (pp)"
label var W1_open_break_blwmd					"Dummy break time below md"
label var W1_open_abvmd							"Dummy for opening hours above md"
label var W1_open_p80							"Opening hours (p80)"
label var W1_open_abv80							"Dummy for opening hours above p80"
label var W1_open_net_abvmd						"Dummy for opening hours net of breaks above md"
label var W1_open_net_p80						"Net opening hours (p80)"
label var W1_open_net_abv80						"Dummy opening hours net of breaks above p80"
label var W1_custom_total						"Total customers (norm day)"
label var W1_custom_loyal						"Loyal customers (norm day)"
label var W1_custom_casual						"Casual customers (norm day)"
label var W1_custom_avgpurch					"Avg purchase per customer"
label var W1_powerout_mthly						"Dummy power outage monthly"
label var W1_powerout_wk						"Dummy power outage weekly"
label var W1_assets_car							"Dummy car"
label var W1_assets_scooter						"Dummy scooter"
label var W1_assets_nofridge					"Dummy no fridge"
label var W1_assets_fridges						"Dummy >= 2 fridges"
label var W1_assets_landline					"Dummy landline"
label var W1_assets_otherfirm					"Other businesses owned"
label var W1_sales_lastmth						"Sales last month"
label var W1_expense_stockup_ln					"Baseline Baseline expenses: Stock-up (ln)"
label var W1_expense_stockup 					"Baseline Baseline expenses: Stock-up"
label var W1_expense_stockup_w1 				"Baseline expenses: Stock-up win 1%"
label var W1_expense_stockup_w25 				"Baseline expenses: Stock-up win 2.5%"
label var W1_expense_wage 						"Baseline expenses: Salaries"
label var W1_expense_wage_ln 					"Baseline expenses: Salaries (ln)"
label var W1_expense_wage_w1 					"Baseline expenses: Salaries win 1%"
label var W1_expense_wage_w25 					"Baseline expenses: Salaries win 2.5%"
label var W1_expense_rent 						"Baseline expenses: Rent and fees"
label var W1_expense_rent_ln 					"Baseline expenses: Rent and fees (ln)"
label var W1_expense_rent_w1 					"Baseline expenses: Rent and fees win 1%"
label var W1_expense_rent_w25 					"Baseline expenses: Rent and fees win 2.5%"
label var W1_expense_electric 					"Baseline expenses: Electricity and utilities"
label var W1_expense_electric_ln 				"Baseline expenses: Electricity and utilities (ln)"
label var W1_expense_electric_w1 				"Baseline expenses: Electricity and utilities win 1%"
label var W1_expense_electric_w25 				"Baseline expenses: Electricity and utilities win 2.5%"
label var W1_expense_transport 					"Baseline expenses: Transport"
label var W1_expense_transport_ln 				"Baseline expenses: Transport (ln)"
label var W1_expense_transport_w1 				"Baseline expenses: Transport win 1%"
label var W1_expense_transport_w25				"Baseline expenses: Transport win 2.5%"
label var W1_expense_tax 						"Baseline expenses: Tax"
label var W1_expense_tax_ln						"Baseline expenses: Tax (ln)"
label var W1_expense_tax_w1 					"Baseline expenses: Tax win 1%"
label var W1_expense_tax_w25 					"Baseline expenses: Tax win 2.5%"
label var W1_expense_phone 						"Baseline expenses: Communication"
label var W1_expense_phone_ln 					"Baseline expenses: Communication (ln)"
label var W1_expense_phone_w1					"Baseline expenses: Communication win 1%"
label var W1_expense_phone_w25 				"Baseline expenses: Communication win 2.5%"
label var W1_expense_advert 					"Baseline expenses: Marketing"
label var W1_expense_advert_ln					"Baseline expenses: Marketing (ln)"
label var W1_expense_advert_w1				"Baseline expenses: Marketing win 1%"
label var W1_expense_advert_w25 				"Baseline expenses: Marketing win 2.5%"
label var W1_expense_preman 					"Baseline expenses: Local thugs"
label var W1_expense_preman_ln 					"Baseline expenses: Local thugs (ln)"
label var W1_expense_preman_w1				"Baseline expenses: Local thugs win 1%"
label var W1_expense_preman_w25 				"Baseline expenses: Local thugs win 2.5%"
label var W1_expense_police 					"Baseline expenses: Police"
label var W1_expense_police_ln 					"Baseline expenses: Police (ln)"
label var W1_expense_police_w1 				"Baseline expenses: Police win 1%"
label var W1_expense_police_w25 				"Baseline expenses: Police win 2.5%"
label var W1_security							"Baseline expenses: Security"
label var W1_expense_other 						"Baseline expenses: Other"
label var W1_expense_other_ln					"Baseline expenses: Other (ln)"
label var W1_expense_other_w1 				"Baseline expenses: Other win 1%"
label var W1_expense_other_w25 				"Baseline expenses: Other win 2.5%"
label var W1_expense_total 						"Baseline expenses: Total"
label var W1_expense_total_ln				"Baseline expenses: Total (ln)"
label var W1_expense_total_w1 				"Baseline expenses: Total win 1%"
label var W1_expense_total_w25 				"Baseline expenses: Total win 2.5%"
label var W1_prof_lastmth						"Profits last month"
label var W1_prod1_split						"Split top 7 prods (1)"	
label var W1_prod2_split						"Split top 7 prods (2)"
label var W1_prod3_split						"Split top 7 prods (3)"
label var W1_prod4_split						"Split top 7 prods (4)"
label var W1_prod5_split						"Split top 7 prods (5)"
label var W1_prod6_split						"Split top 7 prods (6)"
label var W1_prod7_split						"Split top 7 prods (7)"
label var W1_top7_prod1							"Top 7 prods (1)"
label var W1_top7_prod2							"Top 7 prods (2)"
label var W1_top7_prod3							"Top 7 prods (3)"
label var W1_top7_prod4							"Top 7 prods (4)"
label var W1_top7_prod5							"Top 7 prods (5)"
label var W1_top7_prod6							"Top 7 prods (6)"
label var W1_top7_prod7							"Top 7 prods (7)"
label var W1_top7_veg							"Sales top 7 prod: veggies"
label var W1_top7_fruit							"Sales top 7 prod: fruits"
label var W1_top7_nutspeas						"Sales top 7 prod: grains, peas, nuts"
label var W1_top7_rice							"Sales top 7 prod: rice"
label var W1_top7_flour							"Sales top 7 prod: flour"
label var W1_top7_meatfish						"Sales top 7 prod: meat, fish"
label var W1_top7_eggs							"Sales top 7 prod: eggs"
label var W1_top7_noodles						"Sales top 7 prod: noodles"
label var W1_top7_spices						"Sales top 7 prod: spices, leaves"
label var W1_top7_oil							"Sales top 7 prod: cooking oil"
label var W1_top7_saltsugar						"Sales top 7 prod: salt, sugar"
label var W1_top7_bread							"Sales top 7 prod: bread, buns, cakes"
label var W1_top7_coffeetea						"Sales top 7 prod: coffee, tea"
label var W1_top7_homecooked					"Sales top 7 prod: home-made food"
label var W1_top7_readymade						"Sales top 7 prod: ready-made food"
label var W1_top7_deepfrozen					"Sales top 7 prod: deep-frozen food"
label var W1_top7_snacks						"Sales top 7 prod: snacks"
label var W1_top7_freshdrinks					"Sales top 7 prod: fresh drinks"
label var W1_top7_softdrinks					"Sales top 7 prod: soft drinks"
label var W1_top7_sanitary						"Sales top 7 prod: sanitary"
label var W1_top7_cleaning						"Sales top 7 prod: cleaning"
label var W1_top7_baby							"Sales top 7 prod: baby"
label var W1_top7_kids							"Sales top 7 prod: kids"
label var W1_top7_tobacco						"Sales top 7 prod: tobacco"
label var W1_top7_meds							"Sales top 7 prod: meds"
label var W1_top7_household						"Sales top 7 prod: household"
label var W1_top7_stationary					"Sales top 7 prod: stationery"
label var W1_top7_plastic						"Sales top 7 prod: plastic, packaging"
label var W1_top7_gaspetrol						"Sales top 7 prod: gas, petrol"
label var W1_top7_phone							"Sales top 7 prod: telecom"
label var W1_top7_laundry						"Sales top 7 prod: laundry"
label var W1_top7_copying						"Sales top 7 prod: copying"
label var W1_top7_veg_prop						"Prop veggie sales in top 7"
label var W1_top7_fruit_prop					"Prop fruit sales in top 7"
label var W1_top7_nutspeas_prop					"Prop grain, pea, nut sales in top 7"
label var W1_top7_rice_prop						"Prop rice sales in top 7"
label var W1_top7_flour_prop					"Prop flour sales in top 7"
label var W1_top7_meatfish_prop					"Prop meat, fish sales in top 7"
label var W1_top7_eggs_prop						"Prop egg sales in top 7"
label var W1_top7_noodles_prop					"Prop noodle sales in top 7"
label var W1_top7_spices_prop					"Prop spice, leave sales in top 7"
label var W1_top7_oil_prop						"Prop cooking oil sales in top 7"
label var W1_top7_saltsugar_prop				"Prop salt, sugar sales in top 7"
label var W1_top7_bread_prop					"Prop bread, buns, cake sales in top 7"
label var W1_top7_coffeetea_prop				"Prop coffee, tea sales in top 7"
label var W1_top7_homecooked_prop				"Prop home-made food sales in top 7"
label var W1_top7_readymade_prop				"Prop ready-made food sales in top 7"
label var W1_top7_deepfrozen_prop				"Prop deep-frozen food sales in top 7"
label var W1_top7_snacks_prop					"Prop snacks sales in top 7"
label var W1_top7_freshdrinks_prop				"Prop fresh drinks sales in top 7"
label var W1_top7_softdrinks_prop				"Prop soft drinks sales in top 7"
label var W1_top7_sanitary_prop					"Prop sanitary sales in top 7"
label var W1_top7_cleaning_prop					"Prop cleaning prods sales in top 7"
label var W1_top7_baby_prop						"Prop baby prods sales in top 7"
label var W1_top7_kids_prop						"Prop kids prods sales in top 7"
label var W1_top7_tobacco_prop					"Prop tobacco sales in top 7"
label var W1_top7_meds_prop						"Prop meds sales in top 7"
label var W1_top7_household_prop				"Prop household sales in top 7"
label var W1_top7_stationary_prop				"Prop stationery sales in top 7"
label var W1_top7_plastic_prop					"Prop plastic, package in top 7"
label var W1_top7_gaspetrol_prop				"Prop gas, petrol sales in top 7"
label var W1_top7_phone_prop					"Prop telecom sales in top 7"
label var W1_top7_laundry_prop					"Prop laundry sales in top 7"
label var W1_top7_copying_prop					"Prop copying sales in top 7"
label var W1_top7_rice_1						"Dummy top 7: rice"
label var W1_top7_flour_1						"Dummy top 7: flour"
label var W1_top7_eggs_1						"Dummy top 7: eggs"
label var W1_top7_noodles_1						"Dummy top 7: noodles"
label var W1_top7_oil_1							"Dummy top 7: oil"
label var W1_top7_saltsugar_1					"Dummy top 7: salt, sugar"
label var W1_top7_bread_1						"Dummy top 7: bread, buns, cakes"
label var W1_top7_coffeetea_1					"Dummy top 7: coffee and tea"
label var W1_top7_homecooked_1					"Dummy top 7: home made food"
label var W1_top7_snacks_1						"Dummy top 7: snacks"
label var W1_top7_freshdrinks_1					"Dummy top 7: fresh drinks"
label var W1_top7_softdrinks_1					"Dummy top 7: soft drinks"
label var W1_top7_sanitary_1					"Dummy top 7: sanitary"
label var W1_top7_cleaning_1					"Dummy top 7: cleaning"
label var W1_top7_baby_1						"Dummy top 7: baby"
label var W1_top7_tobacco_1						"Dummy top 7: tobacco"
label var W1_top7_meds_1						"Dummy top 7: meds"
label var W1_top7_gaspetrol_1					"Dummy top 7: gas, petrol"
label var W1_top7_phone_1						"Dummy top 7: telecom"
label var W1_sales_nday_top1shr			"Prop top 1 sales in total"
label var W1_sales_nday_top3shr			"Prop top 3 sales in total"
label var W1_dispose_wk							"Dummy weekly disposal"
label var W1_dispose_wk_val						"Avg value weekly disposal"
label var W1_dispose_wk_propsales				"Prop weekly disposal to sales"
label var W1_stockup_top3_fix					"Dummy stock-up fixed all top 3"
label var W1_stockup_top3_fix_any				"Dummy stock-up fixed any top 3"
label var W1_stockup_top3_late_any				"Dummy stock-up late any top 3"
label var W1_stockup_top3_day					"Dummy stock-up >= daily all top 3"
label var W1_stockup_top3_day_any				"Dummy stock-up >= daily any top 3"
label var W1_stockup_top3_wk					"Dummy stock-up <= weekly all top 3"
label var W1_stockout_top3_day_any				"Dummy stock-out >= daily any top 3"
label var W1_stockout_top3_wk					"Dummy stock-out >= weekly all top 3"
label var W1_stockout_top3_wk_any				"Dummy stock-out >= weekly any top 3"
label var W1_bispartner_fam						"Dummy fam bis partner"
label var W1_labour_total						"Labour: total excl owner"
label var W1_labour_total_inclowner				"Labour: total incl owner"
label var W1_labour_fam_full					"Labour: fam full"
label var W1_labour_fam_full_m				"Labour: fam full (miss vals)"
label var W1_labour_fam_part					"Labour: fam part"
label var W1_labour_fam_part_m				"Labour: fam part (miss vals)"
label var W1_labour_fam							"Labour: fam full/part"
label var W1_labour_fam_shr					"Labour: prop fam to total"
label var W1_labour_nonfam_full					"Labour: non-fam full"
label var W1_labour_nonfam_part					"Labour: non-fam part"
label var W1_labour_nonfam						"Labour: non-fam full/part"
label var W1_labour_nonfam_hiredlastyr			"Labour: non-fam hired last 12 mth"
label var W1_LISTING_labour_full				"Labour: total incl owner (from W0)"
label var W1_labour_fam_season					"Labour: fam seasonal"
label var W1_labour_nonfam_season				"Labour: non-fam seasonal"
label var W1_labour_paid_any					"Labour: paid total"
label var W1_labour_paid_perm					"Labour: paid, only permanent"
label var W1_product_lab_sales						"Labour productivity (sales)"
label var W1_product_lab_prof						"Labour productivity (prof)"
label var W1_product_firm							"Firm productivity (opening hours)"
label var W1_product_lab_pplhrs					"Firm productivity (opening hours per person)"
label var W1_rec_pricesuppliers					"Record: prices diff suppl"
label var W1_rec_pricebrands					"Record: prices equiv prods diff brands"
label var W1_rec_stockup						"Record: prod purchases"
label var W1_rec_sales							"Record: prod sales"
label var W1_rec_assetpurch						"Record: asset purchases"
label var W1_rec_stocks							"Record: total stock of prods"
label var W1_rec_accpaysupplier					"Record: credit from supplier"
label var W1_rec_accpayloan						"Record: credit from bank"
label var W1_rec_othercosts						"Record: other costs"
label var W1_rec_accreccustom					"Record: credit to custom"
label var W1_rec_accreccustom_TC				"Record: trade credit to custom"
label var W1_rec_accrecfam						"Record: credit to fam"
label var W1_rec_ledger							"Record: dummy ledger book"
label var W1_rec_receipts						"Record: dummy collect receipts"
label var W1_rec_none							"Record: dummy no records"
label var W1_rec_day							"Record: dummy daily update"
label var W1_rec_twicewk						"Record: dummy update >= twice a week update"
label var W1_rec_ledger_day						"Record: dummy update >= daily ledger prod purch/sales"
label var W1_profcalc_any						"Profit calc: dummy any calc"
label var W1_profcalc_allcosts				"Profit calc: dummy all costs"
label var W1_profcalc_stockup					"Profit calc: dummy stock-up costs"
label var W1_profcalc_nocosts					"Profit calc: dummy no costs"
label var W1_profcalc_any_day					"Profit calc: dummy any calc daily"
label var W1_profcalc_any_wk					"Profit calc: dummy any calc >=weekly"
label var W1_MWM1_visitcompetprice				"McK&W2016: visit competitors prices"
label var W1_MWM2_visitcompetprod				"McK&W2016: visit competitors prods"
label var W1_MWM3_askcustomprod					"McK&W2016: ask custom for new prods"
label var W1_MWM4_askcustomquit					"McK&W2016: talk to former customers"
label var W1_MWM5_asksupplprod					"McK&W2016: ask suppliers for well-sell prods"
label var W1_MWM6_attrcustomdisc				"McK&W2016: attract customers w/ spec offer"
label var W1_MWM7_advert						"McK&W2016: advertise"
label var W1_MWB1_negosupplprice				"McK&W2016: negotiate lower price suppl"
label var W1_MWB2_compsupplprod					"McK&W2016: compare prods between suppliers"
label var W1_MWB3_notOOS						"McK&W2016: no out-of-stocks"
label var W1_MWR1_recwritten					"McK&W2016: written bis rec"
label var W1_MWR2_recpurchsale					"McK&W2016: rec every purch and sale"
label var W1_MWR3_recliquid						"McK&W2016: use rec cash on hand"
label var W1_MWR4_recsalesprods					"McK&W2016: use rec sales of prods"
label var W1_MWR5_costprods						"McK&W2016: calc costs of main prods"
label var W1_MWR6_profprods					"McK&W2016: items highest mark-up"
label var W1_MWR7_recexpensemth					"McK&W2016: mthly expense budget"
label var W1_MWR8_recloan						"McK&W2016: use rec to pay hypo loan"
label var W1_MWF1_finperform					"McK&W2016: review fin perform"
label var W1_MWF2_settargetyr					"McK&W2016: set sales target next yr"
label var W1_MWF3_comptargetmth					"McK&W2016: comp target w sales >= monthly"
label var W1_MWF4_expensenextyr					"McK&W2016: cost budget next yr"
label var W1_MWF5_proflossyr					"McK&W2016: ann profit-loss state"
label var W1_MWF6_cashflowyr					"McK&W2016: ann cash flow state"
label var W1_MWF7_balanceyr						"McK&W2016: ann balance sheet"
label var W1_MWF8_incexpenseyr					"McK&W2016: ann inc and expend"
label var W1_MW_resp_total						"McK&W2016: total answers given"
label var W1_MW_M_resp_total					"McK&W2016: marketing anwers given"
label var W1_MW_B_resp_total					"McK&W2016: stock-up answers given"
label var W1_MW_R_resp_total					"McK&W2016: rec keep answers given"
label var W1_MW_F_resp_total					"McK&W2016: fin planning answers given"
label var W1_MW_resp_m						"McK&W2016: miss vals"
label var W1_MW_score_total						"McK&W2016: total score at BL"
label var W1_MW_M_score_total					"McK&W2016: marketing score at BL"
label var W1_MW_B_score_total					"McK&W2016: stock-up score at BL"
label var W1_MW_R_score_total					"McK&W2016: record-keeping score"
label var W1_MW_F_score_total					"McK&W2016: fin planning sub-score"
label var W1_MW_percscore_total					"McK&W2016: total % score at BL"
label var W1_MW_percscore_total_qtile			"McK&W2016: total % score (qtiles)"
label var W1_MW_M_percscore_total				"McK&W2016: marketing % score at BL"
label var W1_MW_B_percscore_total				"McK&W2016: stock-up % score at BL"
label var W1_MW_R_percscore_total				"McK&W2016: record-keeping % score at BL"
label var W1_MW_F_percscore_total				"McK&W2016: fin planning % score at BL"
label var W1_separatefin						"Dummy sep finances"
label var W1_compsales_compet					"Dummy comp compet sales perform"
label var W1_price_change_comp					"Dummy price change compet"
label var W1_price_change_demand				"Dummy price change demand"
label var W1_discount							"Dummy discount any"
label var W1_discount_bulk						"Dummy discount bulk"
label var W1_discount_loyal						"Dummy discount loyal"
label var W1_inventory_change_demand			"Dummy invent change demand"
label var W1_inventory_change_space				"Dummy invent change shelf"
label var W1_inventory_change_prof			"Dummy invent change profit"
label var W1_inventory_change_price				"Dummy invent change suppl price"
label var W1_prods_new							"New prods last 12 months"
label var W1_prods_new_1						"Dummy any new prod last 12 mth"
label var W1_prods_new_5						"Dummy >= 5 news prods last 12 mth"
label var W1_credit_TC							"Dummy trade cred"
label var W1_credit_TC_int						"Dummy trade cred + int"
label var W1_cutcosts_lastyr					"Prac last yr: cut costs"
label var W1_cutcosts_nextyr					"Prac next yr: cut costs"
label var W1_changesupplier_lastyr				"Prac last yr: new suppl"
label var W1_changesupplier_nextyr				"Prac next yr: new suppl"
label var W1_prodquality_lastyr					"Prac last yr: higher qual prods"
label var W1_prodquality_nextyr					"Prac next yr: higher qual prods"
label var W1_newbrand_lastyr					"Prac last yr: new brand"
label var W1_newbrand_nextyr					"Prac next yr: new brand"
label var W1_newbranch_lastyr					"Prac last yr: new branch"
label var W1_newbranch_nextyr					"Prac next yr: new branch"
label var W1_delegate_lastyr					"Prac last yr: delegate tasks employ"
label var W1_delegate_nextyr					"Prac next yr: delegate tasks employ"
label var W1_bisplan_lastyr						"Prac last yr: bis plan"
label var W1_bisplan_nextyr						"Prac next yr: bis plan"
label var W1_startrec_lastyr					"Prac last yr: improve record-keeping"
label var W1_startrec_nextyr					"Prac next yr: improve record-keeping"
label var W1_loan_lastyr						"Prac last yr: apply for loan"
label var W1_loan_nextyr						"Prac next yr: apply for loan"
label var W1_coopcompet_lastyr					"Prac last yr: coop with compet"
label var W1_coopcompet_nextyr					"Prac next yr: coop with compet"
label var W1_vat_lastyr							"Prac last yr: reg VAT"
label var W1_vat_nextyr							"Prac next yr: reg VAT"
label var W1_practices_lastyr					"Prac last yr: total score"
label var W1_practices_lastyr_abvmd				"Prac last yr: total score above md"
label var W1_practices_nextyr					"Prac next yr: total score"
label var W1_practices_nextyr_abvmd				"Prac next yr: total score above md"
label var W1_practices_nextyr_diff				"Diff score prac next yr/last yr"
label var W1_practices_nextyr_diff_0			"Dummy diff score prac next yr/last yr <=0"
label var W1_socialcomp_super					"Dummy prac social comp superior"
label var W1_socialcomp_infer					"Dummy prac social comp superior"
label var W1_socialcomp_refuse					"Dummy prac social comp refused"
label var W1_discuss_any						"Dummy discuss bis any"
label var W1_practice_discuss_any_daily			"Dummy discuss bis any daily"
label var W1_discuss_sales						"Dummy discuss bis sales"
label var W1_discuss_sales_wk					"Dummy discuss bis sales wkly"
label var W1_discuss_sellprice				"Dummy discuss bis sell price"
label var W1_discuss_sellprice_wk			"Dummy discuss bis sell price wkly"
label var W1_discuss_bestseller					"Dummy discuss bis best sell prod"
label var W1_discuss_bestseller_wk				"Dummy discuss bis best sell prod wkly"
label var W1_discuss_finance					"Dummy discuss bis finance"
label var W1_discuss_buyprice				"Dummy discuss bis purch price"
label var W1_discuss_newprod					"Dummy discuss bis new prod"
label var W1_discuss_newprod_wk					"Dummy discuss bis new prod wkly"
label var W1_discuss_practice					"Dummy discuss bis practices"
label var W1_discuss_practice_wk				"Dummy discuss bis practices wkly"
label var W1_discuss_bisplan					"Dummy discuss bis bis plan"
label var W1_discuss_bisplan_wk					"Dummy discuss bis bis plan wkly"
label var W1_discuss_fam						"Dummy discuss bis fam"
label var W1_discuss_friend						"Dummy discuss bis pers friend"
label var W1_discuss_bisfriend					"Dummy discuss bis bis friend"
label var W1_discuss_supplier					"Dummy discuss bis suppl"
label var W1_jointdec_any						"Dummy joint dec any"
label var W1_jointdec_agree						"Dummy joint dec informal agree"
label var W1_jointdec_any_day					"Dummy joint dec daily"
label var W1_jointdec_sales						"Dummy joint dec sales"
label var W1_jointdec_sales_wk					"Dummy joint dec sales wkly"
label var W1_jointdec_sellprice				"Dummy joint dec sell price"
label var W1_jointdec_sellprice_wk			"Dummy joint dec sell price wkly"
label var W1_jointdec_bestseller				"Dummy joint dec best sell prod"
label var W1_jointdec_bestseller_wk				"Dummy joint dec best sell prod wkly"
label var W1_jointdec_finance					"Dummy joint dec finance"
label var W1_jointdec_buyprice					"Dummy joint dec purch price"
label var W1_jointdec_newprod					"Dummy joint dec new prod"
label var W1_jointdec_newprod_wk				"Dummy joint dec new prod wkly"
label var W1_jointdec_practice					"Dummy joint dec practices"
label var W1_jointdec_practice_wk				"Dummy joint dec practices wkly"
label var W1_jointdec_bisplan					"Dummy joint dec bis plan"
label var W1_jointdec_bisplan_wk				"Dummy joint dec bis plan wkly"
label var W1_jointdec_fam						"Dummy joint dec fam"
label var W1_loans_applied						"No of loans applied for in last 12 mth at BL"
label var W1_loans_obtained						"No of loans obtained in last 12 mth at BL"
label var W1_loans_principal					"Total principal owed at BL"
label var W1_loan_obtained						"Dummy for having obtained any loan in last 12 mth"
label var W1_loans_principal_prop				"Principal owed in prop to profits last month"
label var W1_finlit_int							"Fin literacy: interest"
label var W1_finlit_compoundint					"Fin literacy: compound interest"
label var W1_finlit_score						"Fin literacy: comp score"
label var W1_save_daily							"Dummy for saving daily at BL"
label var W1_save_daily_fix_amt					"Daily savings if saved as fixed amount"
label var W1_save_daily_prop_amt				"Daily savings if saved as % of daily sales"
label var W1_save_daily_amt						"Daily savings at BL"
label var W1_space_cont							"Shop size at BL"
label var W1_asp_ideal_space					"Asp: ideal size"
label var W1_asp_ideal_employ					"Asp: ideal employ"
label var W1_asp_ideal_custom					"Asp: ideal custom"
label var W1_asp_gap_ideal_space				"Asp gap: ideal size"
label var W1_asp_gap_ideal_employ				"Asp gap: ideal employ"
label var W1_asp_gap_ideal_custom				"Asp gap: ideal custom"
label var W1_asp_gap_ideal_space_neg			"Asp gap: dummy ideal size <0"
label var W1_asp_gap_ideal_space_0				"Asp gap: dummy ideal size =0"
label var W1_asp_gap_ideal_space_pos			"Asp gap: dummy ideal size >0"
label var W1_asp_gap_ideal_employ_neg			"Asp gap: dummy ideal employ <0"
label var W1_asp_gap_ideal_employ_0				"Asp gap: dummy ideal employ =0"
label var W1_asp_gap_ideal_employ_pos			"Asp gap: dummy ideal employ >0"
label var W1_asp_gap_ideal_custom_neg			"Asp gap: dummy ideal custom <0"
label var W1_asp_gap_ideal_custom_0				"Asp gap: dummy ideal custom =0"
label var W1_asp_gap_ideal_custom_pos			"Asp gap: dummy ideal custom >0"
label var W1_asp_ideal_yrs						"Aspiration horizon at BL"
label var W1_asp_ideal_yrs_dk					"Aspiration horizon (dk/refused) at BL"
label var W1_asp_fail							"Imagination failure at BL"
label var W1_asp_12mth_space					"12mth shop size aspirations at BL"
label var W1_asp_12mth_employ					"12mth employee aspirations at BL"
label var W1_asp_12mth_custom					"12mth customer aspirations at BL"
label var W1_asp_gap_12mth_space				"12mth shop space aspiration gap at BL"
label var W1_asp_gap_12mth_employ				"12mth employee aspiration gap at BL"
label var W1_asp_gap_12mth_custom				"12mth customer aspiration gap at BL"
label var W1_asp_gap_12mth_space_neg			"Asp gap: dummy 12mth size <0"
label var W1_asp_gap_12mth_space_0				"Asp gap: dummy 12mth size =0"
label var W1_asp_gap_12mth_space_pos			"Asp gap: dummy 12mth size >0"
label var W1_asp_gap_12mth_employ_neg			"Asp gap: dummy 12mth employ <0"
label var W1_asp_gap_12mth_employ_0				"Asp gap: dummy 12mth employ =0"
label var W1_asp_gap_12mth_employ_pos			"Asp gap: dummy 12mth employ >0"
label var W1_asp_gap_12mth_custom_neg			"Asp gap: dummy 12mth custom <0"
label var W1_asp_gap_12mth_custom_0				"Asp gap: dummy 12mth custom =0"
label var W1_asp_gap_12mth_custom_pos			"Asp gap: dummy 12mth custom >0"
label var W1_asp_gap_employ_neg_rebound			"Asp gap: dummy 12mth employ <0 rebound"
label var W1_asp_gap_employ_neg_perm			"Asp gap: dummy 12mth employ <0 perm"
label var W1_asp_12mth_lpred_space				"Asp: Lin predict 12mth size asp"
label var W1_asp_12mth_lpred_employ				"Asp: Lin predict 12mth employ asp"
label var W1_asp_12mth_lpred_custom				"Asp: Lin predict 12mth custom asp"
label var W1_asp_12mth_resid_space				"Asp: Lin predict 12mth size asp residual"
label var W1_asp_12mth_resid_employ				"Asp: Lin predict 12mth employ asp residual"
label var W1_asp_12mth_resid_custom				"Asp: Lin predict 12mth custom asp residual"
label var W1_asp_12mth_fail_space				"Asp: Dummy asp 12mth size < lin predict"
label var W1_asp_12mth_fail_employ				"Asp: Dummy asp 12mth employ < lin predict"
label var W1_asp_12mth_fail_custom				"Asp: Dummy asp 12mth custom < lin predict"
label var W1_asp_12mth_sales					"Asp: 12mth sales"
label var W1_asp_gap_12mth_sales				"Asp gap: 12mth sales"
label var W1_asp_gap_12mth_sales_neg			"Asp gap: dummy 12mth sales <0"
label var W1_asp_gap_12mth_sales_0				"Asp gap: dummy 12mth sales =0"
label var W1_asp_gap_12mth_sales_pos			"Asp gap: dummy 12mth sales >0"
label var W1_asp_import_sales					"Subj. importance to reach 12mth asps"
label var W1_asp_import_sales_highest			"Dummy for highest subj. import to reach 12mth asps"
label var W1_asp_import_sales_scaled			"Subj. importance to reach 12mth asps"
label var W1_asp_prob_sales						"Subj. probability to reach 12mth asps"
label var W1_asp_prob_sales_highest				"Dummy for highest subj. prob to reach 12mth asps"	
label var W1_asp_prob_sales_scaled				"Subj. probability to reach 12mth asps"
label var W1_asp_seff_sales						"Perc. self-efficacy to reach 12mth asps"
label var W1_asp_seff_sales_highest				"Dummy for highest perc. self-eff to reach 12mth asps"
label var W1_asp_seff_sales_scaled				"Perc. self-efficacy to reach 12mth asps"
label var W1_asp_loc_sales						"Perc. LOC to reach 12mth asps"
label var W1_asp_loc_sales_highest				"Dummy for highest perc. LOC to reach 12mth asps"
label var W1_asp_loc_sales_scaled				"Perc. LOC to reach 12mth asps"
label var W1_asp_cse_sales_scaled				"Perc. CSE to reach 12mth asps "
label var W1_asp_ideal_space_mu					"Asp: ideal size (mu)"
label var W1_asp_ideal_space_sd					"Asp: ideal size (sd)"
label var W1_asp_ideal_space_z					"Asp: ideal size (z)"
label var W1_asp_ideal_employ_mu				"Asp: ideal employees (mu)"
label var W1_asp_ideal_employ_sd				"Asp: ideal employees (sd)"
label var W1_asp_ideal_employ_z					"Asp: ideal employees (z)"
label var W1_asp_ideal_custom_mu				"Asp: ideal customers (mu)"
label var W1_asp_ideal_custom_sd				"Asp: ideal customers (sd)"
label var W1_asp_ideal_custom_z					"Asp: ideal customers (z)"
label var W1_asp_ideal_shop						"Ideal shop aspirations composite at BL"
label var W1_asp_gap_ideal_space_mu				"Asp gap: ideal space (mu)"
label var W1_asp_gap_ideal_space_sd				"Asp gap: ideal space (sd)"
label var W1_asp_gap_ideal_space_z				"Asp gap: ideal space (z)"
label var W1_asp_gap_ideal_employ_mu			"Asp gap: ideal employees (mu)"
label var W1_asp_gap_ideal_employ_sd			"Asp gap: ideal employees (sd)"
label var W1_asp_gap_ideal_employ_z				"Asp gap: ideal employee (z)"
label var W1_asp_gap_ideal_custom_mu			"Asp gap: ideal customers (mu)"
label var W1_asp_gap_ideal_custom_sd			"Asp gap: ideal customers (sd)"
label var W1_asp_gap_ideal_custom_z				"Asp gap: ideal customers (z)"
label var W1_asp_gap_ideal_shop					"Asp gap: ideal shop composite"
label var W1_asp_12mth_space_mu					"Asp: 12 months size (mu)"
label var W1_asp_12mth_space_sd					"Asp: 12 months size (sd)"
label var W1_asp_12mth_space_z					"Asp: 12 months size (z)"
label var W1_asp_12mth_employ_mu				"Asp: 12 months employees (mu)"
label var W1_asp_12mth_employ_sd				"Asp: 12 months employees (sd)"
label var W1_asp_12mth_employ_z					"Asp: 12 months employees (z)"
label var W1_asp_12mth_custom_mu				"Asp: 12 months customers (mu)"
label var W1_asp_12mth_custom_sd				"Asp: 12 months customers (sd)"
label var W1_asp_12mth_custom_z					"Asp: 12 months customers (z)"
label var W1_asp_12mth_shop						"12 mth shop aspirations composite at BL"
label var W1_asp_gap_12mth_space_mu				"Asp gap: 12 mth space (mu)"
label var W1_asp_gap_12mth_space_sd				"Asp gap: 12 mth space (sd)"
label var W1_asp_gap_12mth_space_z				"Asp gap: 12 mth space (z)"
label var W1_asp_gap_12mth_employ_mu			"Asp gap: 12 mth employees (mu)"
label var W1_asp_gap_12mth_employ_sd			"Asp gap: 12 mth employee (sd)"
label var W1_asp_gap_12mth_employ_z				"Asp gap: 12 mth employee (z)"
label var W1_asp_gap_12mth_custom_mu			"Asp gap: 12 mth customers (mu)"
label var W1_asp_gap_12mth_custom_sd			"Asp gap: 12 mth customers (sd)"
label var W1_asp_gap_12mth_custom_z				"Asp gap: 12 mth customers (z)"
label var W1_asp_gap_12mth_shop					"Asp gap: 12 mth shop composite"
label var W1_asp_ideal_shop_yrs 				"Asp ideal shop: per year"
label var W1_asp_gap_ideal_shop_yrs				"Asp gap ideal shop: per year"
label var W1_asp_ideal_shop_cse 				"Ideal belief-based aspiration at BL"
label var W1_asp_ideal_shop_probimp 			"Asp ideal shop: weight prob, import"
label var W1_asp_gap_ideal_shop_seff			"Ideal belief-based aspiration gap at BL"
label var W1_asp_gap_ideal_shop_cse				"Ideal belief-based aspiration gap at BL"
label var W1_asp_gap_ideal_shop_imp				"Asp gap ideal shop: weight import"
label var W1_asp_gap_ideal_shop_prob			"Asp gap ideal shop: weight prob"
label var W1_asp_gap_ideal_shop_cseimp			"Asp gap ideal shop: weight self-eff/LOC, import"
label var W1_asp_gap_ideal_shop_probimp			"Asp gap ideal shop: weight prob, import"
label var W1_asp_12mth_shop_cse 				"12 mth belief-based aspiration at BL"
label var W1_asp_12mth_shop_probimp 			"12 mth aspiration weighted by importance"
label var W1_asp_gap_12mth_shop_seff			"12 mth belief-based aspiration gap at BL"
label var W1_asp_gap_12mth_shop_cse				"12 mth belief-based aspiration gap at BL"
label var W1_asp_gap_12mth_shop_imp				"12 mth aspiration gap weighted by importance"
label var W1_asp_gap_12mth_shop_cseimp			"Asp gap 12mth shop: weight self-eff/LOC, import"
label var W1_asp_gap_12mth_shop_probimp			"Asp gap 12mth shop: weight prob-import"
label var W1_asp_12mth_space_cse				"12mth belief-based shop space aspiration at BL"
label var W1_asp_12mth_space_probimp			"12mth shop space aspiration: weight import"
label var W1_asp_gap_12mth_space_cse			"12mth belief-based shop space aspiration gap at BL"
label var W1_asp_gap_12mth_space_probimp		"12mth shop space aspiration gap: weight import"
label var W1_asp_12mth_employ_cse				"12mth belief-based employee aspiration at BL"
label var W1_asp_12mth_employ_probimp			"12mth empoyee aspiration: weight import"
label var W1_asp_gap_12mth_employ_cse			"12mth belief-based employee aspiration gap at BL"
label var W1_asp_gap_12mth_employ_probimp		"12mth employee aspiration gap: weight import"
label var W1_asp_12mth_custom_cse				"12mth belief-based customers aspiration at BL"
label var W1_asp_12mth_custom_probimp			"12mth customers aspiration: weight import"
label var W1_asp_gap_12mth_custom_cse			"12mth belief-based customers aspiration gap at BL"
label var W1_asp_gap_12mth_custom_probimp		"12mth customers aspiration gap: weight import"
label var W1_asp_12mth_sales_cse				"12mth belief-based sales aspiration at BL"
label var W1_asp_12mth_sales_probimp			"12mth sales aspiration: weight import"
label var W1_asp_gap_12mth_sales_cse			"12mth belief-based sales aspiration gap at BL"
label var W1_asp_gap_12mth_sales_probimp		"12mth sales aspiration gap: weight import"
label var W1_asp_min_prof						"Asp: Min profits"
label var W1_asp_gap_min_prof					"Asp gap: Min profits"
label var W1_asp_gap_min_prof_ihs				"Asp gap: Min profits (IHS)"
label var W1_asp_18mth_prof					"Asp: 18 months profits"
label var W1_asp_18mth_sales					"Asp: 18 months sales"
label var W1_asp_gap_18mth_prof				"Asp gap: 18 mth profits"
label var W1_asp_gap_18mth_prof_neg			"Asp gap: dummy 18 mth profits <0"
label var W1_asp_gap_18mth_prof_0				"Asp gap: dummy 18 mth profits =0"
label var W1_asp_gap_18mth_prof_pos			"Asp gap: dummy 18 mth profits >0"
label var W1_asp_gap_18mth_sales				"Asp gap: 18 mth sales (from prof data)"
label var W1_asp_occup_son_oth					"Asp: son's occup other"
label var W1_asp_occup_son_employ				"Asp: son's occup employee"
label var W1_asp_occup_son_entrep				"Asp: son's occup entrepreneur"
label var W1_asp_occup_son						"Asp: son's occup"
label var W1_asp_occup_daughter_oth				"Asp: daughter's occup other"
label var W1_asp_occup_daughter_employ			"Asp: daughter's occup employee"
label var W1_asp_occup_daughter_entrep			"Asp: daughter's occup entrepreneur"
label var W1_asp_occup_daughter					"Asp: daughter's occup"
label var W1_son1_age							"Son's age (1)"
label var W1_son2_age							"Son's age (2)"
label var W1_son3_age							"Son's age (3)"
label var W1_oldestson_age						"Oldest son's age"
label var W1_asp_educ_son						"Asp: son's years of education"
label var W1_asp_educ_son_ma					"Asp: dummy son's educ master's"
label var W1_asp_occup_son_high					"Asp: dummy son's occup (high asp)"
label var W1_asp_occup_son_govt					"Asp: dummy son's occup gov't"
label var W1_daughter1_age						"Daughter age (1)"
label var W1_daughter2_age						"Daughter age (2)"
label var W1_daughter3_age						"Daughter age (3)"
label var W1_oldestdaughter_age					"Oldest daughter's age"
label var W1_asp_educ_daughter					"Asp: daughter's years of education"
label var W1_asp_educ_daughter_ma				"Asp: dummy daughter's educ master's"
label var W1_asp_occup_daughter_high			"Asp: dummy daughter's occup (high asp)"
label var W1_asp_occup_daughter_govt			"Asp: dummy daughter's occup gov't"
label var W1_asp_educ_kids 						"Asp: kids' educ years"
label var W1_asp_occup_kids						"Asp: kids' occup"
label var W1_asp_educ_kids_high 				"Asp: kids' educ (abvmc)"
label var W1_asp_occup_kids_high 				"Asp: kids' occup (abvmd) "
label var W1_asp_occup_kids_govt 				"Asp: kids' occup govt"
label var W1_practices_free_score				"3 most profitable practices (open question)"
label var W1_practices_free_lastyr				"3 most profitable practices: last year"
label var W1_practices_free_nextyr				"3 most profitable practices: next year"
label var W1_MW_M_space_12mth					"McK-W x Asp: marketing, 12 mth space"
label var W1_MW_B_space_12mth					"McK-W x Asp: stock-up, 12 mth space"
label var W1_MW_R_space_12mth					"McK-W x Asp: record-keeping, 12 mth space"
label var W1_MW_F_space_12mth					"McK-W x Asp: fin planning, 12 mth space"
label var W1_MW_M_employ_12mth					"McK-W x Asp: marketing, 12 mth employ"
label var W1_MW_B_employ_12mth					"McK-W x Asp: stock-up, 12 mth employ"
label var W1_MW_R_employ_12mth					"McK-W x Asp: record-keeping, 12 mth employ"
label var W1_MW_F_employ_12mth					"McK-W x Asp: fin planning, 12 mth employ"
label var W1_MW_M_custom_12mth					"McK-W x Asp: marketing, 12 mth custom"
label var W1_MW_B_custom_12mth					"McK-W x Asp: stock-up, 12 mth custom"
label var W1_MW_R_custom_12mth					"McK-W x Asp: record-keeping, 12 mth custom"
label var W1_MW_F_custom_12mth					"McK-W x Asp: fin planning, 12 mth custom"
label var W1_MW_M_sales_12mth					"McK-W x Asp: marketing, 12 mth sales"
label var W1_MW_B_sales_12mth					"McK-W x Asp: stock-up, 12 mth sales"
label var W1_MW_R_sales_12mth					"McK-W x Asp: record-keeping, 12 mth sales"
label var W1_MW_F_sales_12mth					"McK-W x Asp: fin planning, 12 mth sales"
label var W1_MW_M_sales_18mth					"McK-W x Asp: marketing, 18 mth sales"
label var W1_MW_B_sales_18mth					"McK-W x Asp: stock-up, 18 mth sales"
label var W1_MW_R_sales_18mth					"McK-W x Asp: record-keeping, 18 mth sales"
label var W1_MW_F_sales_18mth					"McK-W x Asp: fin planning, 18 mth sales"
label var W1_MW_M_space_ideal					"McK-W x Asp: marketing, ideal space"
label var W1_MW_B_space_ideal					"McK-W x Asp: stock-up, ideal space"
label var W1_MW_R_space_ideal					"McK-W x Asp: record-keeping, ideal space"
label var W1_MW_F_space_ideal					"McK-W x Asp: fin planning, ideal space"
label var W1_MW_M_employ_ideal					"McK-W x Asp: marketing, ideal employ"
label var W1_MW_B_employ_ideal					"McK-W x Asp: stock-up, ideal employ"
label var W1_MW_R_employ_ideal					"McK-W x Asp: record-keeping, ideal employ"
label var W1_MW_F_employ_ideal					"McK-W x Asp: fin planning, ideal employ"
label var W1_MW_M_custom_ideal					"McK-W x Asp: marketing, ideal custom"
label var W1_MW_B_custom_ideal					"McK-W x Asp: stock-up, ideal custom"
label var W1_MW_R_custom_ideal					"McK-W x Asp: record-keeping, ideal custom"
label var W1_MW_F_custom_ideal					"McK-W x Asp: fin planning, ideal custom"
label var W1_MW_M_fail							"McK-W x Asp: marketing, imagination fail"
label var W1_MW_B_fail							"McK-W x Asp: stock-up, imagination fail"
label var W1_MW_R_fail							"McK-W x Asp: record-keeping, imagination fail"
label var W1_MW_F_fail							"McK-W x Asp: fin planning, imagination fail"
label var W1_present_spouse						"Enum comments: dummy spouse present"
label var W1_present_fam						"Enum comments: dummy fam present"
label var W1_present_otheradult					"Enum comments: dummy non-fam present"
label var W1_present_child_under5				"Enum comments: dummy <=5 yo child"
label var W1_present_child_over5				"Enum comments: dummy >5 yo child"
label var W1_present_employee					"Enum comments: dummy employee present"
label var W1_present_sm							"Enum comments: dummy supervisor present"
label var W1_present_jpal						"Enum comments: dummy J-PAL/ TiU present"
label var W1_present_tv							"Enum comments: dummy TV running"
label var W1_present_custom						"Enum comments: dummy any custom present"
label var W1_present_custom_no					"Enum comments: total customers coming"
label var W1_understand_perfect					"Enum comments: dummy perfect comprehension"
label var W1_shop_house_same					"Enum comments: dummy shop loc = home"
label var W1_shop_house_sep						"Enum comments: dummy shop loc != home"
label var W1_shop_sign_bright					"Shop appear: dummy sign bright/new"
label var W1_shop_sign							"Shop appear: dummy sign visible"
label var W1_shop_goods_prices					"Shop appear: dummy display prices"
label var W1_shop_goods_display					"Shop appear: dummy display goods"
label var W1_shop_shelf_full					"Shop appear: dummy shelves full"
label var W1_shop_advert						"Shop appear: dummy adverts"
label var W1_shop_clean							"Shop appear: dummy clean"
label var W1_shop_bright						"Shop appear: dummy well lit"
*/

***** SAVE DATA

save "Data\Baseline Data\W1_clean_data.dta", replace



