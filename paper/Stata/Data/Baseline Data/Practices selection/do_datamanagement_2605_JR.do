********************************************************************************
********************************************************************************
************ DATA MANAGEMENT FOR RETAILERS STUDY IN INDONESIA, 2016 ************
* v1.17
* Packages used: 	"winsor" for winsorisation, "mdesc" for missing values, 
* 					"estout" for regs
********************************************************************************



clear
set more off
set scrollbufsize 600000


use "Clean data\smallretail_data.dta", clear



************************************************************************
***** GENERAL INFO *****************************************************

***** UNFINISHED INTERVIEWS

*** Drop all but fully finished interviews --> 1263 obs (919 missing obs)!
tab f4_17_01
mdesc f4_17_01
drop if f4_17_01 != 1


***** EXCHANGE RATE
* All sales/expenses/profits data converted to USD with 13,150 IDR
* (Mid-market rates: 2016-05-02 09:18 UTC)
gen xchange = 13150



/* ************************************************************************
***** OVERVIEW ************************************************

1. General info							~70

2. Owner characteristics				~80
	+ psych scales
	
3. Firm characteristics					~470

4. Sales								~740

5. Expenses								~900

6. Profits								~1060

7. Products & services					~1220

8. Employees							~1590

9. Productivity							~1700

10. Record keeping and profit calcs		~1710

11. McKenzie and Woodruff's practices	~1870

12. Other practices						~2150

13. Discussion and decision-making		~2410

14. Loans & fin							~2700

15. Aspirations							~2810

16. Interviewer impressions				~3020				*/



************************************************************************
***** OWNER CHARACTERISTICS ********************************************

***** AGE

gen age_temp1 = 2016 - f4_2_3b_yr
gen age_temp2 = 2016 - f4_2_4b_yr

* Detect missing values in both age vars --> 234 obs!
tab age_temp1
tab age_temp2
mdesc age_temp1 age_temp2

* Merging existant gender vars
gen owner_age= string(age_temp1)+string(age_temp2)
destring owner_age, replace ignore(".")

* Detect missing values in merged age var --> none!
tab owner_age
mdesc owner_age

* Treating 1 extreme value as missing data --> 1 obs!
replace owner_age =. if owner_age<14
tab owner_age

* Drop temporary vars
drop age_temp1 age_temp2


***** GENDER

gen gender_temp1 = f4_2_3a
gen gender_temp2 = f4_2_4a

* Detect missing values in both gender vars --> 234 obs!
tab gender_temp1
tab gender_temp2
mdesc gender_temp1 gender_temp2

* Recoding "no" answers
replace gender_temp1 = 0 if gender_temp1==3
replace gender_temp2 = 0 if gender_temp2==3

* Merging existant gender vars
gen owner_male= string(gender_temp1)+string(gender_temp2)
destring owner_male, replace ignore(".")

* Detect missing values in merged gender var --> none!
tab owner_male
mdesc owner_male

* Drop temporary vars
drop gender_temp1 gender_temp2


***** OFFSPRING

* Detect missing values in digitspan var --> none!
mdesc f4_10_4a1_age f4_10_4a2_age f4_10_4a3_age f4_10_5a1_age ///
f4_10_5a2_age f4_10_5a3_age

* Dummy for having children
tab f4_10_4a1_age
tab f4_10_5a1_age
gen owner_child1 = 1 if f4_10_4a1_age!=0 | f4_10_5a1_age!=0
replace owner_child1 = 0 if f4_10_4a1_age==. & f4_10_5a1_age==.
mdesc owner_child1

* Dummy for having at least 3 children
gen owner_child3 = 1 if f4_10_4a1_age!=. & f4_10_4a2_age!=. & f4_10_4a3_age!=. ///
| f4_10_4a1_age!=. & f4_10_4a2_age!=. & f4_10_5a1_age!=. ///
| f4_10_4a1_age!=. & f4_10_5a1_age!=. & f4_10_5a2_age!=. ///
| f4_10_5a1_age!=. & f4_10_5a2_age!=. & f4_10_5a3_age!=.
replace owner_child3 = 0 if owner_child3==.
tab owner_child3


***** EDUCATION

* Detect missing values in both education vars --> 234 obs!
tab f4_2_3d
tab f4_2_4d
mdesc f4_2_3d f4_2_4d

* Stacking existant gender vars
gen owner_educ= string(f4_2_3d)+string(f4_2_4d)
destring owner_educ, replace ignore(".")

* Detect missing values in merged gender var --> none!
tab owner_educ
mdesc owner_educ

* Create dummies for finished secondary educ and BA degree
gen owner_educ_second = 1 if owner_educ>=12
replace owner_educ_second = 0 if owner_educ_second==.
gen owner_educ_ba = 1 if owner_educ>=16
replace owner_educ_ba = 0 if owner_educ_ba==.


***** MOTIVATION TO MANAGE FIRM

*** Missing value treatment
* Detect missing values in both education vars --> none!
mdesc f4_3_3_D f4_3_3_P
mdesc f4_3_3_E f4_3_3_F f4_3_3_M
mdesc f4_3_3_C f4_3_3_L f4_3_3_Q f4_3_3_R 
mdesc f4_3_3_H f4_3_3_I
* Dummy for entrepreneurial motivation
tab f4_3_3_D
tab f4_3_3_P
gen owner_motiv_entrep = 1 if f4_3_3_D==1 | f4_3_3_L==1 | f4_3_3_P==1
replace owner_motiv_entrep = 0 if owner_motiv_entrep==.
* Dummy for low barrier to entry as motivation
tab f4_3_3_E
tab f4_3_3_F
tab f4_3_3_M
gen owner_motiv_lowbarrier = 1 if f4_3_3_E==1 | f4_3_3_F==1 | f4_3_3_M==1
replace owner_motiv_lowbarrier = 0 if owner_motiv_lowbarrier==.
* Dummy for retirement, hobby, or spare time engagement or to balance life and work
tab f4_3_3_C
tab f4_3_3_L
tab f4_3_3_Q
tab f4_3_3_R
gen owner_motiv_hobby = 1 if f4_3_3_C==1 | f4_3_3_L==1 | f4_3_3_Q==1 | f4_3_3_R==1
replace owner_motiv_hobby = 0 if owner_motiv_hobby==.
* Dummy for emigration from primary labour market (low opportunity costs)
tab f4_3_3_H
tab f4_3_3_I
gen owner_motiv_lowopport = 1 if f4_3_3_H==1 | f4_3_3_I==1
replace owner_motiv_lowopport = 0 if owner_motiv_lowopport==.

tab owner_motiv_entrep
tab owner_motiv_lowbarrier
tab owner_motiv_hobby
tab owner_motiv_lowopport


***** DIGITSPAN (STM & WM, INTELLIGENCE)

egen owner_digitspan = rowtotal(f4_6_001 f4_6_002 f4_6_003 f4_6_004 ///
f4_6_005 f4_6_006 f4_6_007 f4_6_008)  		
egen owner_digitspan_rev = rowtotal( f4_6_xx1 f4_6_xx2 f4_6_xx3 f4_6_xx4 ///
f4_6_xx5 f4_6_xx6 f4_6_xx7 f4_6_xx8)

* Detect missing values in digitspan var --> none!
tab owner_digitspan
tab owner_digitspan_rev
mdesc owner_digitspan owner_digitspan_rev


***** TRUST

*** Missing variables treatment
* Detect missing values in practices vars --> none!
mdesc f4_11_01 f4_11_02 f4_11_03 f4_11_04 f4_11_05 f4_11_06 f4_11_07 f4_11_08
* Idk's, etc. as missing values
tab f4_11_01 // 5 idk's, 82 N/A
levelsof f4_11_01
tab f4_11_02 // 2 idk's
tab f4_11_03 // 1 idk
tab f4_11_04 // 48 idk's, 3 not answering
levelsof f4_11_04
tab f4_11_05 // 2 idk's, 1 not answering
tab f4_11_06 // 3 idk's, 1 not answering (?)
tab f4_11_07 // 9 idk's, 2 N/A
tab f4_11_08 // 3 idk's

*** Trust in employees
gen owner_trust_employ = f4_11_01

*** Trust in suupliers
gen owner_trust_suppl = f4_11_02

*** Trust in customers
gen owner_trust_custom = f4_11_03

*** Trust in other shop's owners
gen owner_trust_othfirm = f4_11_04

*** Trust in family
gen owner_trust_fam = f4_11_05

*** Trust in neighbours
gen owner_trust_neigh = f4_11_06

*** Trust in friends
gen owner_trust_friend = f4_11_07

*** Trust in strangers (outgroup trust)
gen owner_trust_stranger = f4_11_08

foreach x of varlist owner_trust_* {
   replace `x' =.  if `x'==6 | `x'==7 |`x'==8
   }

*** Standard score
* Ingroup trust
egen owner_trust_ingroup = rmean(owner_trust_fam owner_trust_neigh owner_trust_friend)
* Mean trust
egen owner_trust_mean = rmean(owner_trust_employ owner_trust_suppl ///
owner_trust_custom owner_trust_othfirm owner_trust_fam owner_trust_neigh /// 
owner_trust_friend owner_trust_stranger)

*** Standardisation to 0-1 scale (according to Delhey & Welzel, 2012)
* Ingroup score
gen owner_trust_ingroup_stand = owner_trust_ingroup/3
* Trust in strangers (outgroup score)
gen owner_trust_stranger_stand = owner_trust_stranger/3

*** Own contructions
* Family vs. stranger trust 
gen owner_trust_famstranger = owner_trust_fam/owner_trust_stranger
* Collectivistic composite
gen owner_trust_collect = (owner_trust_stranger + owner_trust_friend ///
+ owner_trust_neigh)/(owner_trust_fam*3)

tab owner_trust_stranger
tab owner_trust_stranger_stand
sum owner_trust_stranger_stand // mean==.348 (Delhey & Welzel, 2012: all Indonesia, 0.39)
tab owner_trust_ingroup
tab owner_trust_ingroup_stand
sum owner_trust_ingroup_stand // mean==.684 (Delhey & Welzel, 2012: all Indonesia, 0.72)
tab owner_trust_mean
tab owner_trust_famstranger
tab owner_trust_collect

_crcslbl owner_trust_employ f4_11_01
_crcslbl owner_trust_suppl f4_11_02
_crcslbl owner_trust_custom f4_11_03
_crcslbl owner_trust_othfirm f4_11_04
_crcslbl owner_trust_fam f4_11_05
_crcslbl owner_trust_neigh f4_11_06
_crcslbl owner_trust_friend f4_11_07
_crcslbl owner_trust_stranger f4_11_08


***** WORKING AND THINKING STYLE SCALE

*** Missing values treatment
* Detect missing values in working and thinking style items --> none!
mdesc f4_12_01 f4_12_02 f4_12_03 f4_12_04 f4_12_05 f4_12_06 f4_12_07 ///
f4_12_08 f4_12_09 f4_12_10
* Detect idk's and refused answers --> none!
tab f4_12_01 
tab f4_12_02
tab f4_12_03
tab f4_12_04
tab f4_12_05
tab f4_12_06
tab f4_12_07
tab f4_12_08
tab f4_12_09
tab f4_12_10

*** Generate scale items
gen owner_cogstyle_system_01 = f4_12_01
gen owner_cogstyle_intuit_02 = f4_12_02
gen owner_cogstyle_intuit_03 = f4_12_03
gen owner_cogstyle_system_04 = f4_12_04
gen owner_cogstyle_system_05 = f4_12_05
gen owner_cogstyle_intuit_06 = f4_12_06
gen owner_cogstyle_system_07 = f4_12_07
gen owner_cogstyle_intuit_08 = f4_12_08
gen owner_cogstyle_system_09 = f4_12_09
gen owner_cogstyle_intuit_10 = f4_12_10

*** Systematic-thinking score
* Create var for total answers given
gen owner_cogstyle_system_answers = 0
foreach x of varlist owner_cogstyle_system_* {
   replace owner_cogstyle_system_answers = owner_cogstyle_system_answers+1  if `x'<.
   }
* Score
egen owner_cogstyle_system = rowtotal(owner_cogstyle_system_01 ///
owner_cogstyle_system_04 owner_cogstyle_system_05 owner_cogstyle_system_07 ///
owner_cogstyle_system_09)
* Percentage score
gen owner_cogstyle_system_perc = owner_cogstyle_system/owner_cogstyle_system_answers

*** Intuitive-thinking score
* Create var for total answers given
gen owner_cogstyle_intuit_answers = 0
foreach x of varlist owner_cogstyle_intuit_* {
   replace owner_cogstyle_intuit_answers = owner_cogstyle_intuit_answers+1  if `x'<.
   }
* Score
egen owner_cogstyle_intuit = rowtotal(owner_cogstyle_intuit_02 ///
owner_cogstyle_intuit_03 owner_cogstyle_intuit_06 owner_cogstyle_intuit_08 ///
owner_cogstyle_intuit_10)
* Percentage score
gen owner_cogstyle_intuit_perc = owner_cogstyle_intuit/owner_cogstyle_intuit_answers

*** Relative systematic-thinking score
* Relative systematic-thinking score
gen owner_cogstyle_rel = owner_cogstyle_system/owner_cogstyle_intuit
* Above-median rel score
egen owner_cogstyle_rel_md = median(owner_cogstyle_rel)
gen owner_cogstyle_rel_abovemd = 1 if owner_cogstyle_rel>owner_cogstyle_rel_md
replace owner_cogstyle_rel_abovemd = 0 if owner_cogstyle_rel_abovemd==.
* Above-p80 rel score
egen owner_cogstyle_rel_p80 = pctile(owner_cogstyle_rel), p(80)
gen owner_cogstyle_rel_abovep80 = 1 if owner_cogstyle_rel>owner_cogstyle_rel_p80
replace owner_cogstyle_rel_abovep80 = 0 if owner_cogstyle_rel_abovep80==.

tab owner_cogstyle_system
tab owner_cogstyle_intuit
tab owner_cogstyle_rel
tab owner_cogstyle_rel_abovemd	// md==1.21
tab owner_cogstyle_rel_abovep80	// p80==1.5

_crcslbl owner_cogstyle_system_01 f4_12_01
_crcslbl owner_cogstyle_intuit_02 f4_12_02
_crcslbl owner_cogstyle_intuit_03 f4_12_03
_crcslbl owner_cogstyle_system_04 f4_12_04
_crcslbl owner_cogstyle_system_05 f4_12_05
_crcslbl owner_cogstyle_intuit_06 f4_12_06
_crcslbl owner_cogstyle_system_07 f4_12_07
_crcslbl owner_cogstyle_intuit_08 f4_12_08
_crcslbl owner_cogstyle_system_09 f4_12_09
_crcslbl owner_cogstyle_intuit_10 f4_12_10


***** TIME PREFERENCES 

*** Missing values treatment
* Detect missing values in both age vars --> none!
mdesc f4_14_01 f4_14_02 f4_14_03
* Idk's, etc. as missing values --> none!
tab f4_14_01
tab f4_14_02
tab f4_14_03

*** Time-preference vars
gen owner_time_fin = f4_14_01
gen owner_time_busi = f4_14_02
gen owner_time_gen = f4_14_03

_crcslbl owner_time_fin f4_14_01
_crcslbl owner_time_busi f4_14_02
_crcslbl owner_time_gen f4_14_03


***** RISK PREFERENCES

*** Missing values treatment
* Detect missing values in both age vars --> none!
mdesc f4_15_01 f4_15_02 f4_15_03
* Idk's, etc. as missing values --> none!
tab f4_15_01
tab f4_15_02
tab f4_15_03

*** Risk-preference vars
gen owner_risk_fin = f4_15_01
gen owner_risk_busi = f4_15_02
gen owner_risk_gen = f4_15_03

*** Combinations
* Rel risk taking in business vs. in general
gen owner_risk_busigen = owner_risk_busi/owner_risk_gen
* More/less rel risk taking in business vs. in general
gen owner_risk_busigen_above1 = 1 if owner_risk_busigen>1
replace owner_risk_busigen_above1 = 0 if owner_risk_busigen_above1==.
gen owner_risk_busigen_below1 = 1 if owner_risk_busigen<1
replace owner_risk_busigen_below1 = 0 if owner_risk_busigen_below1==.
* Rel risk attitude in finance matters vs. in general
gen owner_risk_fingen = owner_risk_fin/owner_risk_gen
* More/less rel risk taking in financial matters vs. in general
gen owner_risk_fingen_above1 = 1 if owner_risk_fingen>1
replace owner_risk_fingen_above1 = 0 if owner_risk_fingen_above1==.
gen owner_risk_fingen_below1 = 1 if owner_risk_fingen<1
replace owner_risk_fingen_below1 = 0 if owner_risk_fingen_below1==.

tab owner_risk_busigen
tab owner_risk_fingen
tab owner_risk_busigen_above1
tab owner_risk_fingen_above1

_crcslbl owner_risk_fin f4_15_01
_crcslbl owner_risk_busi f4_15_02
_crcslbl owner_risk_gen f4_15_03



************************************************************************
***** FIRM CHARACTERISTICS *********************************************

***** FORMALITY

* Detect missing values in licences vars --> none!
mdesc f4_9_12a f4_9_12b f4_9_12c
* Idk's, etc. as missing values
tab f4_9_12a
tab f4_9_12b // 2 idk's
tab f4_9_12c // 1 idk
levelsof f4_9_12b

* Company reg certificate (TDP)
gen firm_formal_reg =  f4_9_12a
label var firm_formal_reg "Have you heard and own company registration certificate"
label val firm_formal_reg f4_9_12a

* Tax identification no
gen firm_formal_tax = f4_9_12b
label val firm_formal_tax f4_9_12b

* VAT collection no
gen firm_formal_vat = f4_9_12c
label val firm_formal_vat f4_9_12c

* Only 17 businesses have all certificates and nos
count if firm_formal_reg==1 & firm_formal_tax==1 & firm_formal_vat==1

* Define idk's ("8") as missing values
foreach x of varlist firm_formal_* {
   replace `x' =.  if `x'==8
   replace `x' = 0 if `x'==3
   }

tab firm_formal_reg
tab firm_formal_tax
tab firm_formal_vat

_crcslbl firm_formal_reg f4_9_12a
_crcslbl firm_formal_tax f4_9_12b
_crcslbl firm_formal_vat f4_9_12c


***** FIRM AGE

* Detect missing values in firm age var --> none!
mdesc f4_3_1 f4_3_2

* Generate firm age var
tab f4_3_1 // 6 idk's
levelsof f4_3_1
gen firm_age = 2017-f4_3_1
replace firm_age =. if firm_age<0

* Generate var for years of respondent being principle manager of the firm
tab f4_3_2
gen firm_age_manager = 2017-f4_3_2

* Dummy for firms older than their manager
gen firm_age_old = 1 if firm_age>firm_age_manager
replace firm_age_old = 0 if firm_age_old==.

tab firm_age
tab firm_age_manager
tab firm_age_old


***** SPACE

*** Total space
* Detect missing values in firm space var --> none!
mdesc f4_3_7a f4_10_01aa

* Dummies for businesses up to 6, between 6 and 10, and above 10 sqm from categorical variable
tab f4_3_7a
gen firm_space_micro = 1 if f4_3_7a==1
replace firm_space_micro = 0 if firm_space_micro==.
gen firm_space_small = 1 if f4_3_7a==2
replace firm_space_small = 0 if firm_space_small==.
gen firm_space_mid = 1 if f4_3_7a==3
replace firm_space_mid = 0 if firm_space_mid==.
tab firm_space_micro
tab firm_space_small
tab firm_space_mid

* Dummies for businesses up to 6, between 6 and 10, and above 10 sqm from continuous variable
tab f4_10_01aa
gen firm_space_cont_micro = 1 if f4_10_01aa>0 & f4_10_01aa<6
replace firm_space_cont_micro = 0 if firm_space_cont_micro==.
gen firm_space_cont_small = 1 if f4_10_01aa>=6 & f4_10_01aa<10
replace firm_space_cont_small = 0 if firm_space_cont_small==.
gen firm_space_cont_mid = 1 if f4_10_01aa>=10
replace firm_space_cont_mid = 0 if firm_space_cont_mid==.

* Consistency between categorical and continuous variables --> 321 inconsistencies
count if firm_space_micro==1 & firm_space_cont_micro!=1 ///
| firm_space_micro==0 & firm_space_cont_micro!=0 ///
| firm_space_small==1 & firm_space_cont_small!=1 ///
| firm_space_small==0 & firm_space_cont_small!=0 ///
| firm_space_mid==1 & firm_space_cont_mid!=1 ///
| firm_space_mid==0 & firm_space_cont_mid!=0 ///


*** Storage space (percentage)

gen firm_store = f4_3_7b
* Detect missing values in storage space var --> none!
tab f4_3_7b
mdesc f4_3_7b

* Dummy for dedicated storage space
gen firm_store_yes = 1 if firm_store>0
replace firm_store_yes = 0 if firm_store_yes==.
tab firm_store_yes


*** Occupany status

* Detect missing values in occupancy status var --> none!
tab f4_3_6
mdesc f4_3_6

* Dummies for space owned, rented, and used without payment
gen firm_space_own = 1 if f4_3_6==1
replace firm_space_own = 0 if firm_space_own==.
gen firm_space_rent = 1 if f4_3_6==2
replace firm_space_rent = 0 if firm_space_rent==.
gen firm_space_use = 1 if f4_3_6==3
replace firm_space_use = 0 if firm_space_use==.
tab firm_space_own
tab firm_space_rent
tab firm_space_use


***** OPENING HOURS (hours opened incl and net of closing time for prayer/food/etc.)

*** Generate vars for opening hours

* Total opening hours
gen firm_open = (f4_3_5_endhr + f4_3_5_endmin/60) - (f4_3_5_beghr + f4_3_5_begmin/60)
* Opening hours per person
gen firm_open_pp = firm_open/(f4_4_3_b3+1)
* Net opening hours
gen firm_open_break = (f4_3_5a_hr + f4_3_5a_min/60)
gen firm_open_net = firm_open - firm_open_break
tab firm_open_break
count if firm_open_net<4
* Net opening hours per person (owner + business partners)
gen firm_open_net_pp = firm_open_net/(f4_4_3_b3+1)

* Detect missing values in opening hours var --> none!
tab firm_open
tab firm_open_net
mdesc firm_open firm_open_net

* Dummy for break time below median
egen firm_open_break_md = median(firm_open_break) // md==2
gen firm_open_break_belowmd = 1 if firm_open_break<firm_open_break_md
replace firm_open_break_belowmd = 0 if firm_open_break_belowmd==.
tab firm_open_break_md

* Dummy for opening hours above median and 80th perc
* Median
egen firm_open_md = median(firm_open) // md==15
gen firm_open_abovemd = 1 if firm_open>firm_open_md
replace firm_open_abovemd = 0 if firm_open_abovemd==.
* p80
egen firm_open_p80 = pctile(firm_open), p(80) // p80==17
gen firm_open_abovep80 = 1 if firm_open>firm_open_p80
replace firm_open_abovep80 = 0 if firm_open_abovep80==.
sum firm_open_p80

* Dummy for opening hours PER PERSON above median/80th pt 
* Median
egen firm_open_pp_md = median(firm_open_pp) // md==8.5
gen firm_open_pp_abovemd = 1 if firm_open_pp>firm_open_pp_md
replace firm_open_pp_abovemd = 0 if firm_open_pp_abovemd==.
tab firm_open_pp_md

* Dummy for NET opening hours above median and in 80th percentile
* Median
egen firm_open_net_md = median(firm_open_net) // md==13
gen firm_open_net_abovemd = 1 if firm_open_net>firm_open_net_md
replace firm_open_net_abovemd = 0 if firm_open_net_abovemd==.
* 80th perc
egen firm_open_net_p80 = pctile(firm_open_net), p(80) // p80==15
gen firm_open_net_abovep80 = 1 if firm_open_net>firm_open_net_p80
replace firm_open_net_abovep80 = 0 if firm_open_net_abovep80==.

* Dummy for net opening hours PER PERSON above median/80th pt 
* Median
egen firm_open_net_pp_md = median(firm_open_net_pp) // md==7.5
gen firm_open_net_pp_abovemd = 1 if firm_open_net_pp>firm_open_net_pp_md
replace firm_open_net_pp_abovemd = 0 if firm_open_net_pp_abovemd==.
*80th perc
egen firm_open_net_pp_p80 = pctile(firm_open_net_pp), p(80) // p80==13
gen firm_open_net_pp_abovep80 = 1 if firm_open_net_pp>firm_open_net_pp_p80
replace firm_open_net_pp_abovep80 = 0 if firm_open_net_pp_abovep80==.

tab firm_open
tab firm_open_break
tab firm_open_abovemd
tab firm_open_net_abovemd
tab firm_open_net_abovep80
tab firm_open_net_pp_abovemd
tab firm_open_net_pp_abovep80


***** CUSTOMERS

*** Total and loyal customers (at least one purchase per week)												// Translation mistake in data "total" not "loyal"	
gen firm_custom_total = f4_3_10b
gen firm_custom_loyal = f4_3_10a
* Detect missing values in firm customers var --> none!
tab firm_custom_total
tab firm_custom_loyal
mdesc firm_custom_total firm_custom_loyal
* Treating extreme values in total customers as missing data --> 4 obs!
replace firm_custom_total =. if firm_custom_total==998
* Treating extreme value in loyal customers as missing data --> 1 obs!
replace firm_custom_loyal =. if firm_custom_loyal==998
tab firm_custom_total
tab firm_custom_loyal


*** Avg purchase value per customer
gen firm_custom_avgpurch = f4_3_11
* Detect missing values in purchase val per customer var --> none!
tab firm_custom_avgpurch
mdesc firm_custom_avgpurch
* Treating extreme value missing data --> 1 obs!
replace firm_custom_avgpurch =. if firm_custom_avgpurch>1500000
tab firm_custom_avgpurch


***** ELECTRICITY

*** All places have electricity (f4_3_8a)

*** Power outage
* Detect missing values in electricity var --> none!
tab f4_3_8b
mdesc f4_3_8b
* Dummies for power outage monthly or more often and weekly or more often
gen firm_powerout_mthly = 1 if f4_3_8b>2
replace firm_powerout_mthly = 0 if firm_powerout_mthly==.
gen firm_powerout_wkly = 1 if f4_3_8b>4
replace firm_powerout_wkly = 0 if firm_powerout_wkly==.
tab firm_powerout_mthly 
tab firm_powerout_wkly


***** ASSETS

*** Only 9 businesses own a pick-up

*** Car dummy
* Detect missing values in asset var --> none!
tab f4_4_1ab
mdesc f4_4_1ab
* Dummy for availability of car
gen firm_car = 1 if f4_4_1ab>0
replace firm_car = 0 if firm_car==.
tab firm_car


*** Scooter dummy
* Detect missing values in asset var --> none!
tab f4_4_1ad
mdesc f4_4_1ad
* Dummy for availability of scooter
gen firm_scooter = 1 if f4_4_1ad>0
replace firm_scooter = 0 if firm_scooter==.
tab firm_scooter

*** Fridge
* Detect missing values in asset var --> none!
tab f4_4_1ba
mdesc f4_4_1ba
* Dummy for no fridge (possible proxy for no perishables) and at least 2 fridges 
* (as investment in basic tech; 1 fridge often provided by large supplier)
gen firm_nofridge = 1 if f4_4_1ba==0
replace firm_nofridge = 0 if firm_nofridge==.
gen firm_fridges = 1 if f4_4_1ba>1
replace firm_fridges = 0 if firm_fridges==.
tab firm_nofridge
tab firm_fridges

*** Only 8 businesses own either a computer or a laptop

*** Landline
gen firm_landline = f4_4_1bg
* Detect missing values in asset var --> none!
tab firm_landline
mdesc firm_landline



************************************************************************
***** SALES ************************************************************

***** SALES LAST MONTH (+log sales, +log sales winsorised at p95)

* Sales converted to USD with 13,150 IDR (Mid-market rates: 2016-05-02 09:18 UTC)
gen sales_lastmth = f4_8_2/xchange

*** Missing vars analysis
* Detect missing values in sales vars --> none!
mdesc sales_lastmth
* Treatment of extreme values as missing --> 15 obs!
tab sales_lastmth
replace sales_lastmth =. if sales_lastmth>999998

*** Median sales
egen sales_lastmth_md = median(sales_lastmth)

*** Norm sales
* Sales, winsorised at p99 (both sides)
winsor sales_lastmth, gen(sales_lastmth_w) p(0.01)

*** Log sales
gen sales_lastmth_log = ln(sales_lastmth)
* Log sales, winsorised at p99 (both sides)
winsor sales_lastmth_log, gen(sales_lastmth_log_w) p(0.01)

* Check for no of obs winsorised --> XX obs!
tab sales_lastmth_log
tab sales_lastmth_log_w


***** SALES ON A NORM DAY (+log sales, +log sales winsorised at p95)

* Sales converted to USD with 13,150 IDR (Mid-market rates: 2016-05-02 09:18 UTC)
gen sales_normday = f4_8_5/xchange

*** Missing vars analysis
* Detect missing values in sales vars --> none!
mdesc sales_normday
* Treatment of extreme values as missing --> 6 obs!
tab sales_normday
replace sales_normday =. if sales_normday>999998

*** Median sales
egen sales_normday_md = median(sales_normday)

*** Norm sales
* Sales, winsorised at p99 (both sides)
winsor sales_normday, gen(sales_normday_w) p(0.01)

*** Log sales
gen sales_normday_log = ln(sales_normday)
* Log sales, winsorised at p99 (both sides)
winsor sales_normday_log, gen(sales_normday_log_w) p(0.01)

*** IHS-transformed sales
gen sales_normday_ihs = ln(sales_normday + sqrt(sales_normday^2 +1))
* IHS-transformed sales, winsorised at p99 (both sides)
winsor sales_normday_ihs, gen(sales_normday_ihs_w) p(0.01)

* Check for no of obs winsorised --> XX obs!
tab sales_normday
tab sales_normday_log
tab sales_normday_log_w


***** SALES FOR 30 NORM DAYS, CALCULATED FROM SALES ON A NORM DAY (+log sales, +log sales winsorised at p95)

gen sales_30normdays = (sales_normday*30)
tab sales_30normdays

*** Median sales
egen sales_30normdays_md = median(sales_30normdays)

*** Log sales
gen sales_30normdays_log = ln(sales_30normdays)
* Log sales, winsorised at p99 (both sides)
winsor sales_30normdays_log, gen(sales_30normdays_log_w) p(0.01)

* Check for no of obs winsorised --> 42 obs!
tab sales_30normdays_log
tab sales_30normdays_log_w


***** SALES ON A NORM DAY, CALCULATED FROM TOP7 PRODUCTS

*** Daily sales for each top7 product 
* Sales converted to USD with 13,150 IDR (Mid-market rates: 2016-05-02 09:18 UTC)
gen sales_normday_prod1 = f4_5_1_b1/xchange
gen sales_normday_prod2 = f4_5_1_b2/xchange
gen sales_normday_prod3 = f4_5_1_b3/xchange
gen sales_normday_prod4 = f4_5_1_b4/xchange
gen sales_normday_prod5 = f4_5_1_b5/xchange
gen sales_normday_prod6 = f4_5_1_b6/xchange
gen sales_normday_prod7 = f4_5_1_b7/xchange
* Treatment of zero and extreme values as missing values
foreach x of varlist sales_normday_prod* {
	replace `x'=.  if `x'==0 | `x'>999998
	}
* Detect missing values in product sales vars --> 1, 24 36, 37, 37, 42, 39 obs!
mdesc sales_normday_prod1 sales_normday_prod2 sales_normday_prod3 ///
sales_normday_prod4 sales_normday_prod5 sales_normday_prod6 sales_normday_prod7

*** Total daily sales from all top7 products
egen sales_normday_topprods = rowtotal(sales_normday_prod1 sales_normday_prod2 ///
sales_normday_prod3 sales_normday_prod4 sales_normday_prod5 /// 
sales_normday_prod6 sales_normday_prod7)
tab sales_normday_topprods
* Median top7 sales
egen sales_normday_topprods_md = median(sales_normday_topprods)

*** Prop of top7 in total sales
gen sales_normday_topprods_prop = sales_normday_topprods/sales_normday
tab sales_normday_topprods_prop
count if sales_normday_topprods>sales_normday

*** Log sales
gen sales_normday_topprods_log = ln(sales_normday_topprods)
* Log sales, winsorised at p99 (both sides)
winsor sales_normday_topprods_log, gen(sales_normday_topprods_log_w) p(0.01)

*** IHS-transformed sales
gen sales_normday_topprods_ihs = ln(sales_normday_topprods)
* IHS-transformed sales, winsorised at p99 (both sides)
winsor sales_normday_topprods_ihs, gen(sales_normday_topprods_ihs_w) p(0.01)

* Check for no of obs affected by winsorisation --> 65, XX obs!
tab sales_normday_topprods_log
tab sales_normday_topprods_log_w
tab sales_normday_topprods_ihs
tab sales_normday_topprods_ihs_w

*** Consistency w self-reported sales data --> 634 obs inconsistent!
gen sales_normday_topprods_excess = 1 if sales_normday_topprods>sales_normday
replace sales_normday_topprods_excess = 0 if sales_normday_topprods_excess==.
tab sales_normday_topprods_excess


***** SALES MTHLY COMPOSITE

*** Comp score w both self-reported and calc vars

gen sales_mthly_comp_all = (sales_lastmth + sales_normday*30 + sales_normday_topprods*30)/3

* Norm sales
* Sales, winsorised at p99 (both sides)
winsor sales_mthly_comp_all, gen(sales_mthly_comp_all_w) p(0.01)

* Log sales
gen sales_mthly_comp_all_log = ln(sales_mthly_comp_all)
* Log sales, winsorised at p99 (both sides)
winsor sales_mthly_comp_all_log, gen(sales_mthly_comp_all_log_w) p(0.01)

* IHS-transformed sales
gen sales_mthly_comp_all_ihs = ln(sales_mthly_comp_all + sqrt(sales_mthly_comp_all^2 +1))
* Log sales, winsorised at p99 (both sides)
winsor sales_mthly_comp_all_ihs, gen(sales_mthly_comp_all_ihs_w) p(0.01)


*** Comp score w self-reported vars only

gen sales_mthly_comp_rep = (sales_lastmth + sales_normday*30)/2

* Norm sales
* Sales, winsorised at p99 (both sides)
winsor sales_mthly_comp_rep, gen(sales_mthly_comp_rep_w) p(0.01)

* Log sales
gen sales_mthly_comp_rep_log = ln(sales_mthly_comp_rep)
* Log sales, winsorised at p99 (both sides)
winsor sales_mthly_comp_rep_log, gen(sales_mthly_comp_rep_log_w) p(0.01)

* IHS-transformation
gen sales_mthly_comp_rep_ihs = ln(sales_mthly_comp_rep + sqrt(sales_mthly_comp_rep^2 +1))
* IHS-transformed profits, winsorised at p99 (both sides)
winsor sales_mthly_comp_rep_ihs, gen(sales_mthly_comp_rep_ihs_w) p(0.01)

tab sales_mthly_comp_all_log
tab sales_mthly_comp_all_log_w
tab sales_mthly_comp_all_ihs
tab sales_mthly_comp_all_ihs_w
tab sales_mthly_comp_rep_ihs
tab sales_mthly_comp_rep_ihs_w



************************************************************************
***** EXPENSES *********************************************************


***** STOCK-UP COSTS
* Expenses converted to USD with 13,150 IDR
gen expense_stockup = f4_8_3a/xchange
* Treatment of extreme values as missing --> 17 obs!
tab expense_stockup
replace expense_stockup =. if expense_stockup>999998


***** SALARIES AND BENEFITS
* Expenses converted to USD with 13,150 IDR
gen expense_wage = f4_8_3b/xchange
* No extreme values detected
tab expense_wage


***** RENT AND FEES
* Expenses converted to USD with 13,150 IDR
gen expense_rent = f4_8_3c/xchange
* Treatment of extreme value as missing --> 1 obs!
tab expense_rent
replace expense_rent =. if expense_rent>999998


***** ELECTRICITY AND UTILITIES
* Expenses converted to USD with 13,150 IDR
gen expense_electric = f4_8_3d/xchange
* Treatment of extreme values as missing --> 20 obs!
tab expense_electric
replace expense_electric =. if expense_electric>999998


***** TRANSPORTATION COSTS
* Expenses converted to USD with 13,150 IDR
gen expense_transport = f4_8_3e/xchange
* Treatment of extreme values as missing --> 39 obs!
tab expense_transport
replace expense_transport =. if expense_transport>999998

***** TAXES
* Expenses converted to USD with 13,150 IDR
gen expense_tax = f4_8_3f/xchange
* Treatment of extreme values as missing --> 42 obs!
tab expense_tax
replace expense_tax =. if expense_tax>999998


***** COMMUNICATION
* Expenses converted to USD with 13,150 IDR
gen expense_phone = f4_8_3g/xchange
* Treatment of extreme values as missing --> 16 obs!
tab expense_phone 
replace expense_phone =. if expense_phone>999998


***** MARKETING
* Expenses converted to USD with 13,150 IDR
gen expense_advert = f4_8_3h/xchange
* No extreme values detected
tab expense_advert


***** SECURITY

*** Preman (organised, local thugs)
* Expenses converted to USD with 13,150 IDR
gen expense_preman = f4_8_3i/xchange
* No extreme values detected
tab expense_preman

*** Police
* Expenses converted to USD with 13,150 IDR
gen expense_police = f4_8_3j/xchange
* Treatment of extreme value as missing --> 1 obs!
tab expense_police
replace expense_police =. if expense_police>999998


*** Missing values analysis
* Detect missing values in expenses vars
mdesc expense_stockup expense_wage expense_rent expense_electric /// 
expense_transport expense_tax expense_phone expense_advert /// 
expense_preman expense_police
tab expense_stockup 	// 17 obs!
tab expense_wage 		// none!
tab expense_rent 		// 1 obs!
tab expense_electric  	// 20 obs!
tab expense_transport 	// 39 obs!
tab expense_tax 		// 42 obs!
tab expense_phone 		// 16 obs!
tab expense_advert 		// none!
tab expense_preman  	// none!
tab expense_police 		// 1 obs!


***** TOTAL EXPENSES

*** Total expenses (without missing data being dealt with)
gen expense_total = expense_stockup + expense_wage + expense_rent ///
+ expense_electric + expense_transport + expense_tax + expense_phone ///
+ expense_advert + expense_preman + expense_police
tab expense_total

gen expense_tot = expense_stockup + expense_wage + expense_rent ///
+ expense_electric + expense_transport + expense_phone ///
+ expense_advert + expense_preman + expense_police
tab expense_total

*** Missing values analysis
* Detect missing values in expense var --> 112 obs!
mdesc expense_total
* Replacing missing values by median when contribution to overall score below 1%
gen expense_tax_prop = expense_tax/expense_total
gen expense_phone_prop = expense_phone/expense_total
gen expense_transport_prop = expense_transport/expense_total
gen expense_stockup_prop = expense_stockup/expense_total
* Replacing missing tax data with md==0
sum expense_tax_prop
egen expense_tax_md = median (expense_tax)
gen expense_tax_nomiss = expense_tax
replace expense_tax_nomiss = expense_tax_md if expense_tax_nomiss==.
* Replacing missing phone data with md==3.80
sum expense_phone_prop
egen expense_phone_md = median (expense_phone)
gen expense_phone_nomiss = expense_phone
replace expense_phone_nomiss = expense_phone_md if expense_phone_nomiss==.
* Replacing missing transport data with md==6.08
sum expense_transport_prop
egen expense_transport_md = median (expense_transport)
gen expense_transport_nomiss = expense_transport
replace expense_transport_nomiss = expense_transport_md if expense_transport_nomiss==.

*** Total expenses (with above replacements of missing data in tax and phone expenses)
gen expense_total_fix = expense_stockup + expense_wage + expense_rent ///
+ expense_electric + expense_transport_nomiss + expense_tax_nomiss ///
+ expense_phone_nomiss + expense_advert + expense_preman + expense_police
* Detect missing values in expense var --> 39 obs!
mdesc expense_total_fix

tab expense_tax
tab expense_tax_nomiss
tab expense_phone
tab expense_phone_nomiss
tab expense_transport
tab expense_transport_nomiss
tab expense_total
tab expense_total_fix



************************************************************************
***** PROFITS ************************************************************


***** PROFITS LAST MONTH, SELF-REPORTED

*** Profits converted to USD with 13,150 IDR (Mid-market rates: 2016-05-02 09:18 UTC)
gen profit_lastmth = f4_8_1/xchange

*** Missing vars analysis
* Detect missing values in profit vars --> none!
mdesc profit_lastmth
* Treatment of extreme values as missing --> 32 obs!
tab profit_lastmth
replace profit_lastmth =. if profit_lastmth>999998
* Treatment of zero profit as missing --> 1 obs!
replace profit_lastmth =. if profit_lastmth==0

*** Treatment of obs that are merely projections from estimations of "last day"
tab f4_8_1a
levelsof f4_8_1a
gen profit_lastmth_clean = profit_lastmth if f4_8_1a!=1 

*** Median profits
egen profit_lastmth_md = median(profit_lastmth)

*** Norm profits
* Profits, winsorised at p99 (both sides)
winsor profit_lastmth, gen(profit_lastmth_w) p(0.01)

*** Log profits
gen profit_lastmth_log = ln(profit_lastmth)
* Log profits, winsorised at p99 (both sides)
winsor profit_lastmth_log, gen(profit_lastmth_log_w) p(0.01)

*** Inverse-hyperbolic-sine-transformed profits
gen profit_lastmth_ihs = ln(profit_lastmth + sqrt(profit_lastmth^2 +1))
* IHS-transformed profits, winsorised at p99 (both sides)
winsor profit_lastmth_ihs, gen(profit_lastmth_ihs_w) p(0.01)

*** Check for no of obs affected by winsorisation --> XX obs (log) and XX obs (ihs)
tab profit_lastmth
tab profit_lastmth_log
tab profit_lastmth_log_w
tab profit_lastmth_ihs
tab profit_lastmth_ihs_w


***** PROFITS ON A NORM DAY, SELF-REPORTED

*** Profits converted to USD with 13,150 IDR (Mid-market rates: 2016-05-02 09:18 UTC)
gen profit_normday = f4_8_4/xchange

*** Missing vars analysis
* Detect missing values in profit vars --> none!
mdesc profit_normday
* Treatment of extreme values as missing --> 33 obs!
tab profit_normday
replace profit_normday =. if profit_normday>999998
* Treatment of zero profit as missing --> 1 obs!
replace profit_normday =. if profit_normday==0

* Checking cases where "last month" is a projection from "last day" 
* and she is unsure even about "normal day" --> 57 obs!
tab f4_8_4a
count if f4_8_1a==1 & f4_8_4a==2

*** Median profits
egen profit_normday_md = median(profit_normday)

*** Norm profits
* Profits, winsorised at p99 (both sides)
winsor profit_normday, gen(profit_normday_w) p(0.01)

*** Log profits
gen profit_normday_log = ln(profit_normday)
* Log profits, winsorised at p99 (both)
winsor profit_normday_log, gen(profit_normday_log_w) p(0.01)

*** Inverse-hyperbolic-sine-transformed profits
gen profit_normday_ihs = ln(profit_normday + sqrt(profit_normday^2 +1))
* IHS-transformed profits, winsorised at p99 (both)
winsor profit_normday_ihs, gen(profit_normday_ihs_w) p(0.01)

*** Check for no of obs affected by winsorisation-->  XX obs (log) and XX obs (ihs)
tab profit_normday
tab profit_normday_log
tab profit_normday_log_w
tab profit_normday_ihs
tab profit_normday_ihs_w


***** PROFITS LAST MONTH, CALCULATED (from sales/expenses)

* Profits calculated from sales and expenses info
gen profit_lastmth_calc = sales_lastmth - expense_total_fix

*** Missing vars analysis
* Detect missing values in profit vars --> 122 obs!
mdesc profit_lastmth_calc
count if sales_lastmth==. | expense_total_fix==.
* Dummy for missing value
gen profit_lastmth_calc_miss = 1 if profit_lastmth_calc==.
replace profit_lastmth_calc_miss = 0 if profit_lastmth_calc_miss==.

*** Check for instances of zero or neg profits --> 0 zero obs, 530 neg obs!
inspect profit_lastmth_calc
* Log profits not feasible due to neg profits

*** Median profits
egen profit_lastmth_calc_md = median(profit_lastmth_calc)

*** Inverse-hyperbolic-sine-transformed profits
gen profit_lastmth_calc_ihs = ln(profit_lastmth_calc + sqrt(profit_lastmth_calc^2 +1))
* IHS-transformed profits, winsorised at p99 (both sides9<
winsor profit_lastmth_calc_ihs, gen(profit_lastmth_calc_ihs_w) p(0.01)

* Check for no of obs affected by winsorisation --> XX obs!
tab profit_lastmth_calc_ihs
tab profit_lastmth_calc_ihs_w


***** PROFITS FOR 30 NORM DAYS, CALCULATED FROM SALES ON 30 NORM DAYS (from 30-day sales and expenses)

gen profit_30normdays = sales_30normdays - expense_total_fix
tab profit_30normdays

*** Missing vars analysis
* Detect missing values in profit vars --> 115 obs!
mdesc profit_30normdays

*** Check for instances of zero or neg profits --> 0 zero obs, 294 neg obs!
inspect profit_30normdays
* Log profits not feasible due to neg profits

*** Median profits
egen profit_30normdays_md = median(profit_30normdays)

*** Inverse-hyperbolic-sine-transformed profits
gen profit_30normdays_ihs = ln(profit_30normdays + sqrt(profit_30normdays^2 +1))
* IHS-transformed profits, winsorised at p99 (both sides)
winsor profit_30normdays_ihs, gen(profit_30normdays_ihs_w) p(0.01)

* Check for no of obs affected by winsorisation --> 59 obs!
tab profit_30normdays_ihs
tab profit_30normdays_ihs_w

tab sales_lastmth_md
tab sales_normday_md
tab profit_lastmth_md
tab profit_normday_md
tab profit_lastmth_calc_md


***** PROFITS MTHLY COMPOSITE

*** Comp score w both self-reported and calc vars

gen profit_mthly_comp_all = (profit_lastmth + profit_lastmth_calc + profit_normday*30)/3

* Norm profits
* Profits, winsorised at p99 (both sides)
winsor profit_mthly_comp_all, gen(profit_mthly_comp_all_w) p(0.01)

* IHS-transformation
gen profit_mthly_comp_all_ihs = ln(profit_mthly_comp_all + sqrt(profit_mthly_comp_all^2 +1))
* IHS-transformed profits, winsorised at p99 (both sides)
winsor profit_mthly_comp_all_ihs, gen(profit_mthly_comp_all_ihs_w) p(0.01)

tab profit_mthly_comp_all_ihs
tab profit_mthly_comp_all_ihs_w


*** Comp score w self-reported vars only

gen profit_mthly_comp_rep = (profit_lastmth + profit_normday*30)/2

* Norm profits
* Profits, winsorised at p99 (both sides)
winsor profit_mthly_comp_rep, gen(profit_mthly_comp_rep_w) p(0.01)

* IHS-transformation
gen profit_mthly_comp_rep_ihs = ln(profit_mthly_comp_rep + sqrt(profit_mthly_comp_rep^2 +1))
* IHS-transformed profits, winsorised at p99 (both sides)
winsor profit_mthly_comp_rep_ihs, gen(profit_mthly_comp_rep_ihs_w) p(0.01)

tab profit_mthly_comp_rep_ihs
tab profit_mthly_comp_rep_ihs_w



************************************************************************
***** PRODUCTS AND SERVICES ********************************************

***** Generate vars

*** Top7 prods

gen prod1_split = strpos(f4_5_1_cd1,". ")
gen prod2_split = strpos(f4_5_1_cd2,". ")
gen prod3_split = strpos(f4_5_1_cd3,". ")
gen prod4_split = strpos(f4_5_1_cd4,". ")
gen prod5_split = strpos(f4_5_1_cd5,". ")
gen prod6_split = strpos(f4_5_1_cd6,". ")
gen prod7_split = strpos(f4_5_1_cd7,". ")

list f4_5_1_cd1 if prod1_split == 0
list f4_5_1_cd2 if prod2_split == 0
list f4_5_1_cd3 if prod3_split == 0
list f4_5_1_cd4 if prod4_split == 0
list f4_5_1_cd5 if prod5_split == 0
list f4_5_1_cd6 if prod6_split == 0
list f4_5_1_cd7 if prod7_split == 0

gen topprods_prod1 = substr(f4_5_1_cd1,1,prod1_split - 1)
gen topprods_prod2 = substr(f4_5_1_cd2,1,prod2_split - 1)
gen topprods_prod3 = substr(f4_5_1_cd3,1,prod3_split - 1)
gen topprods_prod4 = substr(f4_5_1_cd4,1,prod4_split - 1)
gen topprods_prod5 = substr(f4_5_1_cd5,1,prod5_split - 1)
gen topprods_prod6 = substr(f4_5_1_cd6,1,prod6_split - 1)
gen topprods_prod7 = substr(f4_5_1_cd7,1,prod7_split - 1)


***** Missing values treatment
*** Detect missing values in both age vars --> none obs!
mdesc sales_normday_prod1 sales_normday_prod2 sales_normday_prod3 ///
sales_normday_prod4 sales_normday_prod5 sales_normday_prod6 sales_normday_prod7
*** Treating extreme values in total customers as missing data
tab sales_normday_prod1 // 1 extreme obs!
tab sales_normday_prod2 // 2
tab sales_normday_prod3 // 2
tab sales_normday_prod4 // 3
tab sales_normday_prod5 // 3
tab sales_normday_prod6 // 5
tab sales_normday_prod7 // 3
* Define extreme values (>999999998) as missing values
foreach x of varlist sales_normday_prod* {
   replace `x' =.  if `x'>999999998
   }

   
***** Sales numbers by product category if in top7 prods
 
gen topprods_veges = sales_normday_prod1 if topprods_prod1=="01"
replace topprods_veges = sales_normday_prod2 if topprods_prod2=="01"
replace topprods_veges = sales_normday_prod3 if topprods_prod3=="01"
replace topprods_veges = sales_normday_prod4 if topprods_prod4=="01"
replace topprods_veges = sales_normday_prod5 if topprods_prod5=="01"
replace topprods_veges = sales_normday_prod6 if topprods_prod6=="01"
replace topprods_veges = sales_normday_prod7 if topprods_prod7=="01"
replace topprods_veges = 0 if topprods_veges==.

gen topprods_fruits = sales_normday_prod1 if topprods_prod1=="02"
replace topprods_fruits = sales_normday_prod2 if topprods_prod2=="02"
replace topprods_fruits = sales_normday_prod3 if topprods_prod3=="02"
replace topprods_fruits = sales_normday_prod4 if topprods_prod4=="02"
replace topprods_fruits = sales_normday_prod5 if topprods_prod5=="02"
replace topprods_fruits = sales_normday_prod6 if topprods_prod6=="02"
replace topprods_fruits = sales_normday_prod7 if topprods_prod7=="02"
replace topprods_fruits = 0 if topprods_fruits==.

gen topprods_nutspeas = sales_normday_prod1 if topprods_prod1=="03"
replace topprods_nutspeas = sales_normday_prod2 if topprods_prod2=="03"
replace topprods_nutspeas = sales_normday_prod3 if topprods_prod3=="03"
replace topprods_nutspeas = sales_normday_prod4 if topprods_prod4=="03"
replace topprods_nutspeas = sales_normday_prod5 if topprods_prod5=="03"
replace topprods_nutspeas = sales_normday_prod6 if topprods_prod6=="03"
replace topprods_nutspeas = sales_normday_prod7 if topprods_prod7=="03"
replace topprods_nutspeas = 0 if topprods_nutspeas==.

gen topprods_rice = sales_normday_prod1 if topprods_prod1=="04"
replace topprods_rice = sales_normday_prod2 if topprods_prod2=="04"
replace topprods_rice = sales_normday_prod3 if topprods_prod3=="04"
replace topprods_rice = sales_normday_prod4 if topprods_prod4=="04"
replace topprods_rice = sales_normday_prod5 if topprods_prod5=="04"
replace topprods_rice = sales_normday_prod6 if topprods_prod6=="04"
replace topprods_rice = sales_normday_prod7 if topprods_prod7=="04"
replace topprods_rice = 0 if topprods_rice==.

gen topprods_flour = sales_normday_prod1 if topprods_prod1=="05"
replace topprods_flour = sales_normday_prod2 if topprods_prod2=="05"
replace topprods_flour = sales_normday_prod3 if topprods_prod3=="05"
replace topprods_flour = sales_normday_prod4 if topprods_prod4=="05"
replace topprods_flour = sales_normday_prod5 if topprods_prod5=="05"
replace topprods_flour = sales_normday_prod6 if topprods_prod6=="05"
replace topprods_flour = sales_normday_prod7 if topprods_prod7=="05"
replace topprods_flour = 0 if topprods_flour==.

gen topprods_meatfish = sales_normday_prod1 if topprods_prod1=="06"
replace topprods_meatfish = sales_normday_prod2 if topprods_prod2=="06"
replace topprods_meatfish = sales_normday_prod3 if topprods_prod3=="06"
replace topprods_meatfish = sales_normday_prod4 if topprods_prod4=="06"
replace topprods_meatfish = sales_normday_prod5 if topprods_prod5=="06"
replace topprods_meatfish = sales_normday_prod6 if topprods_prod6=="06"
replace topprods_meatfish = sales_normday_prod7 if topprods_prod7=="06"
replace topprods_meatfish = 0 if topprods_meatfish==.

gen topprods_eggs = sales_normday_prod1 if topprods_prod1=="07"
replace topprods_eggs = sales_normday_prod2 if topprods_prod2=="07"
replace topprods_eggs = sales_normday_prod3 if topprods_prod3=="07"
replace topprods_eggs = sales_normday_prod4 if topprods_prod4=="07"
replace topprods_eggs = sales_normday_prod5 if topprods_prod5=="07"
replace topprods_eggs = sales_normday_prod6 if topprods_prod6=="07"
replace topprods_eggs = sales_normday_prod7 if topprods_prod7=="07"
replace topprods_eggs = 0 if topprods_eggs==.

gen topprods_noodles = sales_normday_prod1 if topprods_prod1=="08"
replace topprods_noodles = sales_normday_prod2 if topprods_prod2=="08"
replace topprods_noodles = sales_normday_prod3 if topprods_prod3=="08"
replace topprods_noodles = sales_normday_prod4 if topprods_prod4=="08"
replace topprods_noodles = sales_normday_prod5 if topprods_prod5=="08"
replace topprods_noodles = sales_normday_prod6 if topprods_prod6=="08"
replace topprods_noodles = sales_normday_prod7 if topprods_prod7=="08"
replace topprods_noodles = 0 if topprods_noodles==.

gen topprods_spices = sales_normday_prod1 if topprods_prod1=="09"
replace topprods_spices = sales_normday_prod2 if topprods_prod2=="09"
replace topprods_spices = sales_normday_prod3 if topprods_prod3=="09"
replace topprods_noodles = sales_normday_prod4 if topprods_prod4=="08"
replace topprods_noodles = sales_normday_prod5 if topprods_prod5=="08"
replace topprods_noodles = sales_normday_prod6 if topprods_prod6=="08"
replace topprods_noodles = sales_normday_prod7 if topprods_prod7=="08"
replace topprods_spices = 0 if topprods_spices==.

gen topprods_oil = sales_normday_prod1 if topprods_prod1=="10"
replace topprods_oil = sales_normday_prod2 if topprods_prod2=="10"
replace topprods_oil = sales_normday_prod3 if topprods_prod3=="10"
replace topprods_oil = sales_normday_prod4 if topprods_prod4=="10"
replace topprods_oil = sales_normday_prod5 if topprods_prod5=="10"
replace topprods_oil = sales_normday_prod6 if topprods_prod6=="10"
replace topprods_oil = sales_normday_prod7 if topprods_prod7=="10"
replace topprods_oil = 0 if topprods_oil==.

gen topprods_saltsugar = sales_normday_prod1 if topprods_prod1=="11"
replace topprods_saltsugar = sales_normday_prod2 if topprods_prod2=="11"
replace topprods_saltsugar = sales_normday_prod3 if topprods_prod3=="11"
replace topprods_saltsugar = sales_normday_prod4 if topprods_prod4=="11"
replace topprods_saltsugar = sales_normday_prod5 if topprods_prod5=="11"
replace topprods_saltsugar = sales_normday_prod6 if topprods_prod6=="11"
replace topprods_saltsugar = sales_normday_prod7 if topprods_prod7=="11"
replace topprods_saltsugar = 0 if topprods_saltsugar==.

gen topprods_bread = sales_normday_prod1 if topprods_prod1=="12"
replace topprods_bread = sales_normday_prod2 if topprods_prod2=="12"
replace topprods_bread = sales_normday_prod3 if topprods_prod3=="12"
replace topprods_bread = sales_normday_prod4 if topprods_prod4=="12"
replace topprods_bread = sales_normday_prod5 if topprods_prod5=="12"
replace topprods_bread = sales_normday_prod6 if topprods_prod6=="12"
replace topprods_bread = sales_normday_prod7 if topprods_prod7=="12"
replace topprods_bread = 0 if topprods_bread==.

gen topprods_coffeetea = sales_normday_prod1 if topprods_prod1=="13"
replace topprods_coffeetea = sales_normday_prod2 if topprods_prod2=="13"
replace topprods_coffeetea = sales_normday_prod3 if topprods_prod3=="13"
replace topprods_coffeetea = sales_normday_prod4 if topprods_prod4=="13"
replace topprods_coffeetea = sales_normday_prod5 if topprods_prod5=="13"
replace topprods_coffeetea = sales_normday_prod6 if topprods_prod6=="13"
replace topprods_coffeetea = sales_normday_prod7 if topprods_prod7=="13"
replace topprods_coffeetea = 0 if topprods_coffeetea==.

gen topprods_homecooked = sales_normday_prod1 if topprods_prod1=="14"
replace topprods_homecooked = sales_normday_prod2 if topprods_prod2=="14"
replace topprods_homecooked = sales_normday_prod3 if topprods_prod3=="14"
replace topprods_homecooked = sales_normday_prod4 if topprods_prod4=="14"
replace topprods_homecooked = sales_normday_prod5 if topprods_prod5=="14"
replace topprods_homecooked = sales_normday_prod6 if topprods_prod6=="14"
replace topprods_homecooked = sales_normday_prod7 if topprods_prod7=="14"
replace topprods_homecooked = 0 if topprods_homecooked==.

gen topprods_readymade = sales_normday_prod1 if topprods_prod1=="15"
replace topprods_readymade = sales_normday_prod2 if topprods_prod2=="15"
replace topprods_readymade = sales_normday_prod3 if topprods_prod3=="15"
replace topprods_bread = sales_normday_prod4 if topprods_prod4=="15"
replace topprods_bread = sales_normday_prod5 if topprods_prod5=="15"
replace topprods_bread = sales_normday_prod6 if topprods_prod6=="15"
replace topprods_bread = sales_normday_prod7 if topprods_prod7=="15"
replace topprods_readymade = 0 if topprods_readymade==.

gen topprods_deepfrozen = sales_normday_prod1 if topprods_prod1=="16"
replace topprods_deepfrozen = sales_normday_prod2 if topprods_prod2=="16"
replace topprods_deepfrozen = sales_normday_prod3 if topprods_prod3=="16"
replace topprods_deepfrozen = sales_normday_prod4 if topprods_prod4=="16"
replace topprods_deepfrozen = sales_normday_prod5 if topprods_prod5=="16"
replace topprods_deepfrozen = sales_normday_prod6 if topprods_prod6=="16"
replace topprods_deepfrozen = sales_normday_prod7 if topprods_prod7=="16"
replace topprods_deepfrozen = 0 if topprods_deepfrozen==.

gen topprods_snacks = sales_normday_prod1 if topprods_prod1=="17"
replace topprods_snacks = sales_normday_prod2 if topprods_prod2=="17"
replace topprods_snacks = sales_normday_prod3 if topprods_prod3=="17"
replace topprods_snacks = sales_normday_prod4 if topprods_prod4=="17"
replace topprods_snacks = sales_normday_prod5 if topprods_prod5=="17"
replace topprods_snacks = sales_normday_prod6 if topprods_prod6=="17"
replace topprods_snacks = sales_normday_prod7 if topprods_prod7=="17"
replace topprods_snacks = 0 if topprods_snacks==.

gen topprods_freshdrinks = sales_normday_prod1 if topprods_prod1=="18"
replace topprods_freshdrinks = sales_normday_prod2 if topprods_prod2=="18"
replace topprods_freshdrinks = sales_normday_prod3 if topprods_prod3=="18"
replace topprods_freshdrinks = sales_normday_prod4 if topprods_prod4=="18"
replace topprods_freshdrinks = sales_normday_prod5 if topprods_prod5=="18"
replace topprods_freshdrinks = sales_normday_prod6 if topprods_prod6=="18"
replace topprods_freshdrinks = sales_normday_prod7 if topprods_prod7=="18"
replace topprods_freshdrinks = 0 if topprods_freshdrinks==.

gen topprods_softdrinks = sales_normday_prod1 if topprods_prod1=="19"
replace topprods_softdrinks = sales_normday_prod2 if topprods_prod2=="19"
replace topprods_softdrinks = sales_normday_prod3 if topprods_prod3=="19"
replace topprods_softdrinks = sales_normday_prod4 if topprods_prod4=="19"
replace topprods_softdrinks = sales_normday_prod5 if topprods_prod5=="19"
replace topprods_softdrinks = sales_normday_prod6 if topprods_prod6=="19"
replace topprods_softdrinks = sales_normday_prod7 if topprods_prod7=="19"
replace topprods_softdrinks = 0 if topprods_softdrinks==.

gen topprods_sanitary = sales_normday_prod1 if topprods_prod1=="20"
replace topprods_sanitary = sales_normday_prod2 if topprods_prod2=="20"
replace topprods_sanitary = sales_normday_prod3 if topprods_prod3=="20"
replace topprods_sanitary = sales_normday_prod4 if topprods_prod4=="20"
replace topprods_sanitary = sales_normday_prod5 if topprods_prod5=="20"
replace topprods_sanitary = sales_normday_prod6 if topprods_prod6=="20"
replace topprods_sanitary = sales_normday_prod7 if topprods_prod7=="20"
replace topprods_sanitary = 0 if topprods_sanitary==.

gen topprods_cleaning = sales_normday_prod1 if topprods_prod1=="21"
replace topprods_cleaning = sales_normday_prod2 if topprods_prod2=="21"
replace topprods_cleaning = sales_normday_prod3 if topprods_prod3=="21"
replace topprods_cleaning = sales_normday_prod4 if topprods_prod4=="21"
replace topprods_cleaning = sales_normday_prod5 if topprods_prod5=="21"
replace topprods_cleaning = sales_normday_prod6 if topprods_prod6=="21"
replace topprods_cleaning = sales_normday_prod7 if topprods_prod7=="21"
replace topprods_cleaning = 0 if topprods_cleaning==.

gen topprods_baby = sales_normday_prod1 if topprods_prod1=="22"
replace topprods_baby = sales_normday_prod2 if topprods_prod2=="22"
replace topprods_baby = sales_normday_prod3 if topprods_prod3=="22"
replace topprods_baby = sales_normday_prod4 if topprods_prod4=="22"
replace topprods_baby = sales_normday_prod5 if topprods_prod5=="22"
replace topprods_baby = sales_normday_prod6 if topprods_prod6=="22"
replace topprods_baby = sales_normday_prod7 if topprods_prod7=="22"
replace topprods_baby = 0 if topprods_baby==.

gen topprods_kids = sales_normday_prod1 if topprods_prod1=="23"
replace topprods_kids = sales_normday_prod2 if topprods_prod2=="23"
replace topprods_kids = sales_normday_prod3 if topprods_prod3=="23"
replace topprods_kids = sales_normday_prod4 if topprods_prod4=="23"
replace topprods_kids = sales_normday_prod5 if topprods_prod5=="23"
replace topprods_kids = sales_normday_prod6 if topprods_prod6=="23"
replace topprods_kids = sales_normday_prod7 if topprods_prod7=="23"
replace topprods_kids = 0 if topprods_kids==.

gen topprods_tobacco = sales_normday_prod1 if topprods_prod1=="24"
replace topprods_tobacco = sales_normday_prod2 if topprods_prod2=="24"
replace topprods_tobacco = sales_normday_prod3 if topprods_prod3=="24"
replace topprods_tobacco = sales_normday_prod4 if topprods_prod4=="24"
replace topprods_tobacco = sales_normday_prod5 if topprods_prod5=="24"
replace topprods_tobacco = sales_normday_prod6 if topprods_prod6=="24"
replace topprods_tobacco = sales_normday_prod7 if topprods_prod7=="24"
replace topprods_tobacco = 0 if topprods_tobacco==.

gen topprods_meds = sales_normday_prod1 if topprods_prod1=="25"
replace topprods_meds = sales_normday_prod2 if topprods_prod2=="25"
replace topprods_meds = sales_normday_prod3 if topprods_prod3=="25"
replace topprods_meds = sales_normday_prod4 if topprods_prod4=="25"
replace topprods_meds = sales_normday_prod5 if topprods_prod5=="25"
replace topprods_meds = sales_normday_prod6 if topprods_prod6=="25"
replace topprods_meds = sales_normday_prod7 if topprods_prod7=="25"
replace topprods_meds = 0 if topprods_meds==.

gen topprods_household = sales_normday_prod1 if topprods_prod1=="26"
replace topprods_household = sales_normday_prod2 if topprods_prod2=="26"
replace topprods_household = sales_normday_prod3 if topprods_prod3=="26"
replace topprods_household = sales_normday_prod4 if topprods_prod4=="26"
replace topprods_household = sales_normday_prod5 if topprods_prod5=="26"
replace topprods_household = sales_normday_prod6 if topprods_prod6=="26"
replace topprods_household = sales_normday_prod7 if topprods_prod7=="26"
replace topprods_household = 0 if topprods_household==.

gen topprods_stationary = sales_normday_prod1 if topprods_prod1=="27"
replace topprods_stationary = sales_normday_prod2 if topprods_prod2=="27"
replace topprods_stationary = sales_normday_prod3 if topprods_prod3=="27"
replace topprods_stationary = sales_normday_prod4 if topprods_prod4=="27"
replace topprods_stationary = sales_normday_prod5 if topprods_prod5=="27"
replace topprods_stationary = sales_normday_prod6 if topprods_prod6=="27"
replace topprods_stationary = sales_normday_prod7 if topprods_prod7=="27"
replace topprods_stationary = 0 if topprods_stationary==.

gen topprods_plastic = sales_normday_prod1 if topprods_prod1=="28"
replace topprods_plastic = sales_normday_prod2 if topprods_prod2=="28"
replace topprods_plastic = sales_normday_prod3 if topprods_prod3=="28"
replace topprods_plastic = sales_normday_prod4 if topprods_prod4=="28"
replace topprods_plastic = sales_normday_prod5 if topprods_prod5=="28"
replace topprods_plastic = sales_normday_prod6 if topprods_prod6=="28"
replace topprods_plastic = sales_normday_prod7 if topprods_prod7=="28"
replace topprods_plastic = 0 if topprods_plastic==.

gen topprods_gaspetrol = sales_normday_prod1 if topprods_prod1=="29"
replace topprods_gaspetrol = sales_normday_prod2 if topprods_prod2=="29"
replace topprods_gaspetrol = sales_normday_prod3 if topprods_prod3=="29"
replace topprods_gaspetrol = sales_normday_prod4 if topprods_prod4=="29"
replace topprods_gaspetrol = sales_normday_prod5 if topprods_prod5=="29"
replace topprods_gaspetrol = sales_normday_prod6 if topprods_prod6=="29"
replace topprods_gaspetrol = sales_normday_prod7 if topprods_prod7=="29"
replace topprods_gaspetrol = 0 if topprods_gaspetrol==.

gen topprods_phone = sales_normday_prod1 if topprods_prod1=="30"
replace topprods_phone = sales_normday_prod2 if topprods_prod2=="30"
replace topprods_phone = sales_normday_prod3 if topprods_prod3=="30"
replace topprods_phone = sales_normday_prod4 if topprods_prod4=="30"
replace topprods_phone = sales_normday_prod5 if topprods_prod5=="30"
replace topprods_phone = sales_normday_prod6 if topprods_prod6=="30"
replace topprods_phone = sales_normday_prod7 if topprods_prod7=="30"
replace topprods_phone = 0 if topprods_phone==.

gen topprods_laundry = sales_normday_prod1 if topprods_prod1=="31"
replace topprods_laundry = sales_normday_prod2 if topprods_prod2=="31"
replace topprods_laundry = sales_normday_prod3 if topprods_prod3=="31"
replace topprods_laundry = sales_normday_prod4 if topprods_prod4=="31"
replace topprods_laundry = sales_normday_prod5 if topprods_prod5=="31"
replace topprods_laundry = sales_normday_prod6 if topprods_prod6=="31"
replace topprods_laundry = sales_normday_prod7 if topprods_prod7=="31"
replace topprods_laundry = 0 if topprods_laundry==.

gen topprods_copying = sales_normday_prod1 if topprods_prod1=="32"
replace topprods_copying = sales_normday_prod2 if topprods_prod2=="32"
replace topprods_copying = sales_normday_prod3 if topprods_prod3=="32"
replace topprods_copying = sales_normday_prod4 if topprods_prod4=="32"
replace topprods_copying = sales_normday_prod5 if topprods_prod5=="32"
replace topprods_copying = f4_5_1_b6 if topprods_prod6=="32"
replace topprods_copying = sales_normday_prod7 if topprods_prod7=="32"
replace topprods_copying = 0 if topprods_copying==.


***** Proportion of products sales of total sales

gen topprods_veges_prop = topprods_veges/sales_normday_topprods
gen topprods_fruits_prop = topprods_fruits/sales_normday_topprods
gen topprods_nutspeas_prop = topprods_nutspeas/sales_normday_topprods
gen topprods_rice_prop = topprods_rice/sales_normday_topprods
gen topprods_flour_prop = topprods_flour/sales_normday_topprods
gen topprods_meatfish_prop = topprods_meatfish/sales_normday_topprods
gen topprods_eggs_prop = topprods_eggs/sales_normday_topprods
gen topprods_noodles_prop = topprods_noodles/sales_normday_topprods
gen topprods_spices_prop = topprods_spices/sales_normday_topprods
gen topprods_oil_prop = topprods_oil/sales_normday_topprods
gen topprods_saltsugar_prop = topprods_saltsugar/sales_normday_topprods
gen topprods_bread_prop = topprods_bread/sales_normday_topprods
gen topprods_coffeetea_prop = topprods_coffeetea/sales_normday_topprods
gen topprods_homecooked_prop = topprods_homecooked/sales_normday_topprods
gen topprods_readymade_prop = topprods_readymade/sales_normday_topprods
gen topprods_deepfrozen_prop = topprods_deepfrozen/sales_normday_topprods
gen topprods_snacks_prop = topprods_snacks/sales_normday_topprods
gen topprods_freshdrinks_prop = topprods_freshdrinks/sales_normday_topprods
gen topprods_softdrinks_prop = topprods_softdrinks/sales_normday_topprods
gen topprods_sanitary_prop = topprods_sanitary/sales_normday_topprods
gen topprods_cleaning_prop = topprods_cleaning/sales_normday_topprods
gen topprods_baby_prop = topprods_baby/sales_normday_topprods
gen topprods_kids_prop = topprods_kids/sales_normday_topprods
gen topprods_tobacco_prop = topprods_tobacco/sales_normday_topprods
gen topprods_meds_prop = topprods_meds/sales_normday_topprods
gen topprods_household_prop = topprods_household/sales_normday_topprods
gen topprods_stationary_prop = topprods_stationary/sales_normday_topprods
gen topprods_plastic_prop = topprods_plastic/sales_normday_topprods
gen topprods_gaspetrol_prop = topprods_gaspetrol/sales_normday_topprods
gen topprods_phone_prop = topprods_phone/sales_normday_topprods
gen topprods_laundry_prop = topprods_laundry/sales_normday_topprods
gen topprods_copying_prop = topprods_copying/sales_normday_topprods

tab topprods_veges_prop // <40 businesses w positive sales
tab topprods_fruits_prop // <40 businesses w positive sales
tab topprods_nutspeas_prop // <40 businesses w positive sales
tab topprods_rice_prop
tab topprods_flour_prop
tab topprods_meatfish_prop // <40 businesses w positive sales
tab topprods_eggs_prop
tab topprods_noodles_prop
tab topprods_spices_prop // <40 businesses w positive sales
tab topprods_oil_prop
tab topprods_saltsugar_prop
tab topprods_bread_prop
tab topprods_coffeetea_prop 
tab topprods_homecooked_prop
tab topprods_readymade_pro // <40 businesses w positive sales
tab topprods_deepfrozen_prop // <40 businesses w positive sales
tab topprods_snacks_prop
tab topprods_freshdrinks_prop
tab topprods_softdrinks_prop
tab topprods_sanitary_prop
tab topprods_cleaning_prop
tab topprods_baby_prop
tab topprods_kids_prop // <40 businesses w positive sales
tab topprods_tobacco_prop
tab topprods_meds_prop
tab topprods_household_prop // <40 businesses w positive sales
tab topprods_stationary_prop // <40 businesses w positive sales
tab topprods_plastic_prop // <40 businesses w positive sales
tab topprods_gaspetrol_prop
tab topprods_phone_prop
tab topprods_laundry_prop // <40 businesses w positive sales
tab topprods_copying_prop // <40 businesses w positive sales

/*
gen sales_normday_topprods_prod1 = f4_5_1_b1
gen sales_normday_topprods_prod2 = f4_5_1_b2
gen sales_normday_topprods_prod3 = f4_5_1_b3


foreach x of varlist topprods_* {
	foreach y of varlist sales_normday_topprods_* {
	
	replace topprods_rice = `y'  if `x'=="Rice"
	replace topprods_veges = `y'  if `x'=="XXX"
	replace topprods_fruits = `y'  if `x'=="XXX"
	replace topprods_nutspeas = `y'  if `x'=="XXX"
	replace topprods_rice = `y'  if `x'=="Rice"	
	
	}
}
*/


*** Dummies for having specific prod in top7
gen topprods_rice_1 = 1 if topprods_rice>0
replace topprods_rice_1 = 0 if topprods_rice_1==.

gen topprods_flour_1 = 1 if topprods_flour>0
replace topprods_flour_1 = 0 if topprods_flour_1==.

gen topprods_eggs_1 = 1 if topprods_eggs>0
replace topprods_eggs_1 = 0 if topprods_eggs_1==.

gen topprods_noodles_1 = 1 if topprods_noodles>0
replace topprods_noodles_1 = 0 if topprods_noodles_1==.

gen topprods_oil_1 = 1 if topprods_oil>0
replace topprods_oil_1 = 0 if topprods_oil_1==.

gen topprods_saltsugar_1 = 1 if topprods_saltsugar>0
replace topprods_saltsugar_1 = 0 if topprods_saltsugar_1==.

gen topprods_bread_1 = 1 if topprods_bread>0
replace topprods_bread_1 = 0 if topprods_bread_1==.

gen topprods_coffeetea_1 = 1 if topprods_coffeetea>0
replace topprods_coffeetea_1 = 0 if topprods_coffeetea_1==.

gen topprods_homecooked_1 = 1 if topprods_homecooked>0
replace topprods_homecooked_1 = 0 if topprods_homecooked_1==.

gen topprods_snacks_1 = 1 if topprods_snacks>0
replace topprods_snacks_1 = 0 if topprods_snacks_1==.

gen topprods_freshdrinks_1 = 1 if topprods_freshdrinks>0
replace topprods_freshdrinks_1 = 0 if topprods_freshdrinks_1==.

gen topprods_softdrinks_1 = 1 if topprods_softdrinks>0
replace topprods_softdrinks_1 = 0 if topprods_softdrinks_1==.

gen topprods_sanitary_1 = 1 if topprods_sanitary>0
replace topprods_sanitary_1 = 0 if topprods_sanitary_1==.

gen topprods_cleaning_1 = 1 if topprods_cleaning>0
replace topprods_cleaning_1 = 0 if topprods_cleaning_1==.

gen topprods_baby_1 = 1 if topprods_baby>0
replace topprods_baby_1 = 0 if topprods_baby_1==.

gen topprods_tobacco_1 = 1 if topprods_tobacco>0
replace topprods_tobacco_1 = 0 if topprods_tobacco_1==.

gen topprods_meds_1 = 1 if topprods_meds>0
replace topprods_meds_1 = 0 if topprods_meds_1==.

gen topprods_gaspetrol_1 = 1 if topprods_gaspetrol>0
replace topprods_gaspetrol_1 = 0 if topprods_gaspetrol_1==.

gen topprods_phone_1 = 1 if topprods_phone>0
replace topprods_phone_1 = 0 if topprods_phone_1==.


*** Dummies for prop of total sales being in top 80th perc
egen topprods_rice_p80 = pctile(topprods_rice_prop), p(80)
gen topprods_rice_abovep80 = 1 if topprods_rice_prop>topprods_rice_p80
replace topprods_rice_abovep80 = 0 if topprods_rice_abovep80==.
tab topprods_rice_p80
tab topprods_rice_abovep80

egen topprods_flour_p80 = pctile(topprods_flour_prop), p(80)
gen topprods_flour_abovep80 = 1 if topprods_flour_prop>topprods_flour_p80
replace topprods_flour_abovep80 = 0 if topprods_flour_abovep80==.
tab topprods_flour_p80
tab topprods_flour_abovep80

egen topprods_eggs_p80 = pctile(topprods_eggs_prop), p(80)
gen topprods_eggs_abovep80 = 1 if topprods_eggs_prop>topprods_eggs_p80
replace topprods_eggs_abovep80 = 0 if topprods_eggs_abovep80==.
tab topprods_eggs_p80
tab topprods_eggs_abovep80

egen topprods_noodles_p80 = pctile(topprods_noodles_prop), p(80)
gen topprods_noodles_abovep80 = 1 if topprods_noodles_prop>topprods_noodles_p80
replace topprods_noodles_abovep80 = 0 if topprods_noodles_abovep80==.
tab topprods_noodles_p80
tab topprods_noodles_abovep80

egen topprods_oil_p80 = pctile(topprods_oil_prop), p(80)
gen topprods_oil_abovep80 = 1 if topprods_oil_prop>topprods_oil_p80
replace topprods_oil_abovep80 = 0 if topprods_oil_abovep80==.
tab topprods_oil_p80
tab topprods_oil_abovep80

egen topprods_saltsugar_p80 = pctile(topprods_saltsugar_prop), p(80)
gen topprods_saltsugar_abovep80 = 1 if topprods_saltsugar_prop>topprods_saltsugar_p80
replace topprods_saltsugar_abovep80 = 0 if topprods_saltsugar_abovep80==.
tab topprods_saltsugar_p80
tab topprods_saltsugar_abovep80

egen topprods_bread_p80 = pctile(topprods_bread_prop), p(80)
gen topprods_bread_abovep80 = 1 if topprods_bread_prop>topprods_bread_p80
replace topprods_bread_abovep80 = 0 if topprods_bread_abovep80==.
tab topprods_bread_p80
tab topprods_bread_abovep80

egen topprods_coffeetea_p80 = pctile(topprods_coffeetea_prop), p(80)
gen topprods_coffeetea_abovep80 = 1 if topprods_coffeetea_prop>topprods_coffeetea_p80
replace topprods_coffeetea_abovep80 = 0 if topprods_coffeetea_abovep80==.
tab topprods_coffeetea_p80
tab topprods_coffeetea_abovep80

egen topprods_homecooked_p80 = pctile(topprods_homecooked_prop), p(80)
gen topprods_homecooked_abovep80 = 1 if topprods_homecooked_prop>topprods_homecooked_p80
replace topprods_homecooked_abovep80 = 0 if topprods_homecooked_abovep80==.
tab topprods_homecooked_p80
tab topprods_homecooked_abovep80

egen topprods_snacks_p80 = pctile(topprods_snacks_prop), p(80)
gen topprods_snacks_abovep80 = 1 if topprods_snacks_prop>topprods_snacks_p80
replace topprods_snacks_abovep80 = 0 if topprods_snacks_abovep80==.
tab topprods_snacks_p80
tab topprods_snacks_abovep80

egen topprods_freshdrinks_p80 = pctile(topprods_freshdrinks_prop), p(80)
gen topprods_freshdrinks_abovep80 = 1 if topprods_freshdrinks_prop>topprods_freshdrinks_p80
replace topprods_freshdrinks_abovep80 = 0 if topprods_freshdrinks_abovep80==.
tab topprods_freshdrinks_p80
tab topprods_freshdrinks_abovep80

egen topprods_softdrinks_p80 = pctile(topprods_softdrinks_prop), p(80)
gen topprods_softdrinks_abovep80 = 1 if topprods_softdrinks_prop>topprods_softdrinks_p80
replace topprods_softdrinks_abovep80 = 0 if topprods_softdrinks_abovep80==.
tab topprods_softdrinks_p80
tab topprods_softdrinks_abovep80

egen topprods_sanitary_p80 = pctile(topprods_sanitary_prop), p(80)
gen topprods_sanitary_abovep80 = 1 if topprods_sanitary_prop>topprods_sanitary_p80
replace topprods_sanitary_abovep80 = 0 if topprods_sanitary_abovep80==.
tab topprods_sanitary_p80
tab topprods_sanitary_abovep80

egen topprods_cleaning_p80 = pctile(topprods_cleaning_prop), p(80)
gen topprods_cleaning_abovep80 = 1 if topprods_cleaning_prop>topprods_cleaning_p80
replace topprods_cleaning_abovep80 = 0 if topprods_cleaning_abovep80==.
tab topprods_cleaning_p80
tab topprods_cleaning_abovep80

egen topprods_baby_p80 = pctile(topprods_baby_prop), p(80)
gen topprods_baby_abovep80 = 1 if topprods_baby_prop>topprods_baby_p80
replace topprods_baby_abovep80 = 0 if topprods_baby_abovep80==.
tab topprods_baby_p80
tab topprods_baby_abovep80

egen topprods_tobacco_p80 = pctile(topprods_tobacco_prop), p(80)
gen topprods_tobacco_abovep80 = 1 if topprods_tobacco_prop>topprods_tobacco_p80
replace topprods_tobacco_abovep80 = 0 if topprods_tobacco_abovep80==.
tab topprods_tobacco_p80
tab topprods_tobacco_abovep80

egen topprods_meds_p80 = pctile(topprods_meds_prop), p(80)
gen topprods_meds_abovep80 = 1 if topprods_meds_prop>topprods_meds_p80
replace topprods_meds_abovep80 = 0 if topprods_meds_abovep80==.
tab topprods_meds_p80
tab topprods_meds_abovep80

egen topprods_gaspetrol_p80 = pctile(topprods_gaspetrol_prop), p(80)
gen topprods_gaspetrol_abovep80 = 1 if topprods_gaspetrol_prop>topprods_gaspetrol_p80
replace topprods_gaspetrol_abovep80 = 0 if topprods_gaspetrol_abovep80==.
tab topprods_gaspetrol_p80
tab topprods_gaspetrol_abovep80

egen topprods_phone_p80 = pctile(topprods_phone_prop), p(80)
gen topprods_phone_abovep80 = 1 if topprods_phone_prop>topprods_phone_p80
replace topprods_phone_abovep80 = 0 if topprods_phone_abovep80==.
tab topprods_phone_p80
tab topprods_phone_abovep80


***** TOP7 PRODUCTS

* Total daily sales from all top7 products under "SALES ON A NORM DAY"

*** Proportion of top1 product in sales of top7
* (As possible proxy for diversification)
gen sales_normday_top1share = sales_normday_prod1/sales_normday_topprods
* Treatment of values below 0.1428 (1/7) and above 0.97 as missing values
tab sales_normday_top1share
replace sales_normday_top1share =. if sales_normday_top1share<0.1428 | sales_normday_top1share>0.97
tab sales_normday_top1share
* Detect missing values in total product sales var --> 168 obs!
mdesc sales_normday_top1share


*** Proportion of top3 products in sales of top7
* (For business-practice questions regarding top3 products)
gen sales_normday_top3 = (sales_normday_prod1 + sales_normday_prod2 + sales_normday_prod3)/sales_normday_topprods
* Treatment of values below 0.4285 (3/7)
tab sales_normday_top3
replace sales_normday_top3 =. if sales_normday_top3<0.4285
tab sales_normday_top3
* Detect missing values in total product sales var --> 135 obs!
mdesc sales_normday_top3
* Dummy for top3 prod share above median
egen sales_normday_top3_md = median(sales_normday_top3)
gen sales_normday_top3_abovemd = 1 if sales_normday_top3>sales_normday_top3_md
replace sales_normday_top3_abovemd = 0 if sales_normday_top3_abovemd==.
tab sales_normday_top3_md
tab sales_normday_top3_abovemd
* Dummy for top3 prod share above p80
egen sales_normday_top3_p80 = pctile(sales_normday_top3), p(80)
gen sales_normday_top3_abvp80 = 1 if sales_normday_top3>sales_normday_top3_p80
replace sales_normday_top3_abvp80 = 0 if sales_normday_top3_abvp80==.
tab sales_normday_top3_p80
tab sales_normday_top3_abvp80


***** DISPOSAL OF PRODUCTS

*** Dummy for weekly disposal
gen prods_dispose = f4_5_2a
replace prods_dispose = 0 if prods_dispose==3
* Detect missing values in disposal var --> 0 obs!
tab prods_dispose
mdesc prods_dispose


*** Avg value of weekly disposal
gen prods_dispose_avgval = f4_5_2c
* Treatment of missing values as zero if disposal dummy 0
replace prods_dispose_avgval = 0 if prods_dispose==0
* Treatment of extreme value as missing data -- 1 obs!
tab prods_dispose_avgval
replace prods_dispose_avgval =. if prods_dispose_avgval>999998
* Detect missing values in disposal var --> 10 obs!
mdesc prods_dispose_avgval

*** Proportion of weekly disposal in sales (calculated from 7 norm days)
gen prods_dispose_propsales = prods_dispose_avgval/(sales_normday*7)
tab sales_normday
tab prods_dispose_propsales


***** STOCK-UP BEHAVIOUR FOR TOP3 PRODUCTS

*** Stock-up schedule
tab f4_5_4_1
tab f4_5_4_2
tab f4_5_4_3
* Detect missing values in stockup vars --> none!
mdesc f4_5_4_1 f4_5_4_2 f4_5_4_3
* Dummy for fixed stock-up schedule for ALL top3 prods
gen firm_stockup_fixall = 1 if (f4_5_4_1==3 | f4_5_4_1==4) ///
& (f4_5_4_2==3 | f4_5_4_2==4) & (f4_5_4_3==3 | f4_5_4_3==4)
replace firm_stockup_fixall = 0 if firm_stockup_fixall==.
tab firm_stockup_fixall
* Dummy for fixed stock-up schedule for ANY top3 prod
gen firm_stockup_fixany = 1 if (f4_5_4_1==3 | f4_5_4_1==4) ///
| (f4_5_4_2==3 | f4_5_4_2==4) | (f4_5_4_3==3 | f4_5_4_3==4)
replace firm_stockup_fixany = 0 if firm_stockup_fixany==.
tab firm_stockup_fixany
* Only 20 businesses stock up after oos for ALL top3 prods
* Dummy for stocking-up only when already out of stock for ANY top3 prod
gen firm_stockup_lateany = 1 if f4_5_4_1==1 | f4_5_4_2==1 | f4_5_4_3==1
replace firm_stockup_lateany = 0 if firm_stockup_lateany==.
tab firm_stockup_lateany


*** Stock-up frequency
tab f4_5_6_1
tab f4_5_6_2
tab f4_5_6_3
* Detect missing values in stockup vars --> none!
mdesc f4_5_6_1 f4_5_6_2 f4_5_6_3
* Dummy for stocking up at least daily for ALL top3 prods
gen firm_stockup_dailyall = 1 if (f4_5_6_1==6 | f4_5_6_1==7) ///
& (f4_5_6_2==6 | f4_5_6_2==7) & (f4_5_6_3==6 | f4_5_6_3==7)
replace firm_stockup_dailyall = 0 if firm_stockup_dailyall==.
tab firm_stockup_dailyall
* Dummy for stocking up at least daily for ANY top3 prods
gen firm_stockup_dailyany = 1 if (f4_5_6_1==6 | f4_5_6_1==7) ///
| (f4_5_6_2==6 | f4_5_6_2==7) | (f4_5_6_3==6 | f4_5_6_3==7)
replace firm_stockup_dailyany = 0 if firm_stockup_dailyany==.
tab firm_stockup_dailyany
* Dummy for stocking up at most weekly for ALL top3 prods
gen firm_stockup_wklyall = 1 if (f4_5_6_1==0 | f4_5_6_1==1 | f4_5_6_1==2 ///
| f4_5_6_1==3) & (f4_5_6_2==0 | f4_5_6_2==1 | f4_5_6_2==2 | f4_5_6_2==3) ///
& (f4_5_6_3==0 | f4_5_6_3==1 | f4_5_6_3==2 | f4_5_6_3==3)
replace firm_stockup_wklyall = 0 if firm_stockup_wklyall==.
tab firm_stockup_wklyall


*** Avg value of stock-up 5.5

*** Out-of-stock frequency 5.7
tab f4_5_7_1
tab f4_5_7_2
tab f4_5_7_3
* Detect missing values in stockup vars --> none!
mdesc f4_5_7_1 f4_5_7_2 f4_5_7_3
* Dummy running out of stocks at least daily for ANY top3 prods
gen firm_stockout_dailyany = 1 if f4_5_7_1==7 | f4_5_7_2==7 | f4_5_7_3==7
replace firm_stockout_dailyany = 0 if firm_stockout_dailyany==.
tab firm_stockout_dailyany
* Dummy running out of stocks at least weekly for ALL top3 prods
gen firm_stockout_wklyall = 1 if (f4_5_7_1==5 | f4_5_7_1==6 | f4_5_7_1==7) ///
& (f4_5_7_2==5 | f4_5_7_2==6 | f4_5_7_2==7) & (f4_5_7_3==5 | f4_5_7_3==6 | f4_5_7_3==7)
replace firm_stockout_wklyall = 0 if firm_stockout_wklyall==.
tab firm_stockout_wklyall
* Dummy running out of stocks at least weekly for ANY top3 prods
gen firm_stockout_wklyany = 1 if (f4_5_7_1==5 | f4_5_7_1==6 | f4_5_7_1==7) ///
| (f4_5_7_2==5 | f4_5_7_2==6 | f4_5_7_2==7) | (f4_5_7_3==5 | f4_5_7_3==6 | f4_5_7_3==7)
replace firm_stockout_wklyany = 0 if firm_stockout_wklyany==.
tab firm_stockout_wklyany


* 5.8 and 5.9a: Only 50 businesses claim to do short-term stock ups at shops 
* closer than their usual suppliers, only 11 pay at least a 5% premium 
* on those purchases


*** Product mark-up 5.9b



************************************************************************
***** EMPLOYEES ********************************************************

***** BUSINESS PARTNERS

levelsof f4_4_3_b3
*** Family member
gen busipart_fam = f4_4_3_b3
* Detect missing values in labour vars --> 6!
mdesc busipart_fam
tab busipart_fam

* Only 3 businesses claim to have a business partner from outside the family


***** PERMANENT LABOUR (baseline var, "People working here in the past yr" w/o owner)

*** Permanent family labour, full-time
gen labour_fam_full = f4_4_3_b1
* Detect missing values in labour vars --> 65!
mdesc labour_fam_full
* Dummy for missing vals
gen labour_fam_full_miss = 1 if labour_fam_full==.
replace labour_fam_full_miss=0 if labour_fam_full_miss==.

*** Permanent family labour, part-time
gen labour_fam_part = f4_4_3_b2
* Detect missing values in labour vars --> 65!
mdesc labour_fam_part
* Dummy for missing vals
gen labour_fam_part_miss = 1 if labour_fam_part==.
replace labour_fam_part_miss=0 if labour_fam_part_miss==.

*** Permanent outside labour, full-time
gen labour_nonfam_full = f4_4_3_a1
* Detect missing values in labour vars --> 65!
mdesc labour_nonfam_full
* Only 27 businesses claim to employ permanent outside workers
tab labour_nonfam_full

*** Permanent outside labour, part-time
gen labour_nonfam_part = f4_4_3_a2
* Detect missing values in labour vars --> 65!
mdesc labour_nonfam_part
* Only 29 businesses claim to employ permanent outside workers
tab labour_nonfam_part

*** Permanent outside labour hired w/in last 12 mth
gen labour_permemploy_hired = f4_4_3_d1
* Detect missing values in labour vars --> 65!
mdesc labour_permemploy_hired
* Only 23 businesses claim to have hired permanent outside workers
tab labour_permemploy_hired

*** Total labour last yr
* W / w/o owner
gen labour_total = f4_4_2
gen labour_total_inclowner = labour_total+1
* Detect missing values in labour vars --> none!
mdesc labour_total
* Excluding outliers (>6 people working last yr) --> 9 obs
tab labour_total 
* replace labour_total =. if labour_total>6


***** PERMANENT, FULL-TIME EMPLOYEES (TAKEN FROM LISTING, "Permanent employees")

*** W/ w/o owner
gen labour_nonfam_full_listing = f318

*** Missing vars analysis
* Detect missing values in perm employees var --> none!
mdesc labour_nonfam_full_listing

*** Instances of diff entries between labour_nonfam_full (baseline) and labour_nonfam_full_listing (listing)
* Baseline measure of perm employees only --> 1109 obs!
count if labour_nonfam_full != labour_nonfam_full_listing
tab labour_nonfam_full labour_nonfam_full_listing


***** NON-PERMANENT LABOUR

*** Seasonal family labour
gen labour_fam_season = f4_4_3_b4
* Detect missing values in labour vars --> 65!
mdesc labour_fam_season
* Only 31 businesses claim to have seasonal family workers
tab labour_fam_season

*** Seasonal outside labour
gen labour_nonfam_season = f4_4_3_a4
* Detect missing values in labour vars --> 65!
mdesc labour_nonfam_season
* Only 12 businesses claim to have seasonal outside workers
tab labour_nonfam_season


*** Varify identity of missing obs --> 65 missing values across all vars from identical obs!
count if labour_fam_full==. & labour_fam_part==. & labour_nonfam_full==. ///
& labour_nonfam_part==. & labour_fam_season==. & labour_nonfam_season==. ///
& busipart_fam==.



************************************************************************
***** PRODUCTIVITY *****************************************************


***** LABOUR PRODUCTIVITY (Sales per employee)
gen productiv_labour = sales_lastmth_log_w/labour_total_inclowner

***** TFP
* Value added
gen productiv_valadd = ln(expense_wage) + profit_lastmth_log_w	
* Labour-cost share			//log wages? winsorised?
gen productiv_labcostshare = ln(expense_wage)/productiv_valadd
* gen productiv_TFP = 



************************************************************************
*** BUSINESS RECORDS AND PROFIT CALCS ************************************

***** BUSINESS RECORDS

*** Content of records
* Detect missing values in asset var --> none!
mdesc f4_7_1daa f4_7_1dab f4_7_1dac f4_7_1dad f4_7_1dae f4_7_1daf f4_7_1dag ///
f4_7_1dah f4_7_1dai f4_7_1daj f4_7_1dak f4_7_1dal
* Prices of diff suppliers
tab f4_7_1daa
gen practice_rec_suppl = 1 if f4_7_1daa==1
replace practice_rec_suppl = 0 if practice_rec_suppl==.
* Prices of diff brands
tab f4_7_1dab
gen practice_rec_brands = 1 if f4_7_1dab==1
replace practice_rec_brands = 0 if practice_rec_brands==.
* Product purchases
tab f4_7_1dac
gen practice_rec_prods = 1 if f4_7_1dac==1
replace practice_rec_prods = 0 if practice_rec_prods==.
* Sales
tab f4_7_1dad
gen practice_rec_sales = 1 if f4_7_1dad==1
replace practice_rec_sales = 0 if practice_rec_sales==.
* Asset purchases
tab f4_7_1dae
gen practice_rec_assets = 1 if f4_7_1dae==1
replace practice_rec_assets = 0 if practice_rec_assets==.
* Total stocks
tab f4_7_1daf
gen practice_rec_stock = 1 if f4_7_1daf==1
replace practice_rec_stock = 0 if practice_rec_stock==.
* Outstanding payments to supliers
tab f4_7_1dag
gen practice_rec_accpay_suppl = 1 if f4_7_1dag==1
replace practice_rec_accpay_suppl = 0 if practice_rec_accpay_suppl==.
* Outstanding payments for loans/debts accrued
tab f4_7_1dah
gen practice_rec_accpay_loan = 1 if f4_7_1dah==1
replace practice_rec_accpay_loan = 0 if practice_rec_accpay_loan==.
* Salary and other costs to the business
tab f4_7_1dai // Only 19 businesses note salary payments
tab f4_7_1daj
count if f4_7_1dai==1 & f4_7_1daj==0
gen practice_rec_costs = 1 if f4_7_1daj==1 // Combined var of "any costs excl. new prods"
replace practice_rec_costs = 0 if practice_rec_costs==.
* Outstanding payments of customers
tab f4_7_1dak
gen practice_rec_accrec_cus = 1 if f4_7_1dak==1
replace practice_rec_accrec_cus = 0 if practice_rec_accrec_cus==.
* Outstanding payments of fam members
tab f4_7_1dal
gen practice_rec_accrec_fam = 1 if f4_7_1dal==1
replace practice_rec_accrec_fam = 0 if practice_rec_accrec_fam==.
* "Every purchase and every sale" (Consistency of R2 of McKandW, see below)
gen practice_McKandWcalc_R2 = 1 if practice_rec_prods==1 & practice_rec_assets==1 ///
& practice_rec_sales==1
replace practice_McKandWcalc_R2 = 0 if practice_McKandWcalc_R2==.

*** Kind of records
* Detect missing values in asset var --> none!
mdesc f4_7_1b
* Only 6 businesses keep electronic records
tab f4_7_1b
* Dummy for electronic record-keeping or ledger book
gen practice_rec_ledger = 1 if f4_7_1b==5 | f4_7_1b==6
replace practice_rec_ledger = 0 if practice_rec_ledger==.
* Dummy for receipt collection only
gen practice_rec_receipts = 1 if f4_7_1b==2 | f4_7_1b==3
replace practice_rec_receipts = 0 if practice_rec_receipts==.
* Dummy for no records whatsoever
gen practice_rec_none = 1 if f4_7_1b==0
replace practice_rec_none = 0 if practice_rec_none==.

*** Frequency of updating records
* Detect missing values in asset var --> none!
mdesc f4_7_1c
tab f4_7_1c
* Dummy for daily updating
gen practice_rec_daily = 1 if f4_7_1c==7
replace practice_rec_daily = 0 if practice_rec_daily==.
* Dummy for updating at least twice a week
gen practice_rec_twicewkly = 1 if f4_7_1c==7 | f4_7_1c==6
replace practice_rec_twicewkly = 0 if practice_rec_twicewkly==.

*** Combinations
* Dummy for keeping records in a 1) ledger book and 2) updating daily
gen practice_rec_ledger_daily = 1 if practice_rec_ledger==1 & practice_rec_daily==1
replace practice_rec_ledger_daily = 0 if practice_rec_ledger_daily==.
* Dummy for keeping records in a 1) ledger book of at least the 2) prod purchases
gen practice_rec_ledger_prods = 1 if practice_rec_ledger==1 & practice_rec_prods==1
replace practice_rec_ledger_prods = 0 if practice_rec_ledger_prods==.
* Dummy for a 1) ledger book of at least the 2) prod purchases and 3) updating daily
gen practice_rec_ledger_prods_daily = 1 if practice_rec_ledger==1 ///
& practice_rec_prods==1 & practice_rec_daily==1
replace practice_rec_ledger_prods_daily = 0 if practice_rec_ledger_prods_daily==.

tab practice_rec_suppl 
tab practice_rec_brands
tab practice_rec_prods
tab practice_rec_sales
tab practice_rec_assets
tab practice_rec_stock
tab practice_rec_accpay_suppl
tab practice_rec_accpay_loan
tab practice_rec_costs
tab practice_rec_accrec_cus
tab practice_rec_accrec_fam
tab practice_McKandWcalc_R2

tab practice_rec_ledger
tab practice_rec_receipts
tab practice_rec_none
tab practice_rec_daily
tab practice_rec_twicewkly

tab practice_rec_ledger_daily
tab practice_rec_ledger_prods
tab practice_rec_ledger_prods_daily


***** PROFIT CALCULATIONS

* Detect missing values in asset var --> none, 770, 770!
mdesc f4_7_5a f4_7_5c f4_7_5b

*** Kind of profit calculation
* Dummy for profit calculation with definition up to respondent
tab f4_7_5a
gen practice_profit_any = 1 if f4_7_5a==1
replace practice_profit_any = 0 if practice_profit_any==.
* Dummy for profit calculation accounting for all costs 
* --> only 58 businesses account for all costs!
tab f4_7_5c
gen practice_profit_allcosts = 1 if f4_7_5c==4
replace practice_profit_allcosts = 0 if practice_profit_allcosts==.
* Dummy for profit calculation AT LEAST accounting for costs through stock purchases
gen practice_profit_stock = 1 if f4_7_5c==2 | f4_7_5c==3 | f4_7_5c==4
replace practice_profit_stock = 0 if practice_profit_stock==.
* Dummy for supposed profit calculation accounting  for NO COSTS whatsoever
gen practice_profit_nocosts = 1 if f4_7_5c==1
replace practice_profit_nocosts = 0 if practice_profit_nocosts==.

*** Frequency of profit calculations

* Dummies for profit calculations (whichever way defined) daily/at least weekly
tab f4_7_5b
gen practice_profit_any_daily = 1 if f4_7_5b==7
replace practice_profit_any_daily = 0 if practice_profit_any_daily==.
gen practice_profit_any_wkly = 1 if f4_7_5b==5 | f4_7_5b==6 | f4_7_5b==7
replace practice_profit_any_wkly = 0 if practice_profit_any_wkly==.

*** Combinations
* Dummy for profit calculations accounting for stock costs at least weekly
gen practice_profit_stock_wkly = 1 if practice_profit_stock==1 ///
& practice_profit_any_wkly==1
replace practice_profit_stock_wkly = 0 if practice_profit_stock_wkly==.

tab practice_profit_stock_wkly



************************************************************************
*** MCKENZIE & WOODRUFF (2015) **************************************

***** SINGLE PRACTICES

* M1 -- Visited competitor, see prices
gen practice_McKandW_M1 = f4_7_17
replace practice_McKandW_M1 = 0 if practice_McKandW_M1==3

* M2 -- Visited competitor, see products
gen practice_McKandW_M2 = f4_7_18
replace practice_McKandW_M2 = 0 if practice_McKandW_M2==3

* M3 -- Asked customers, wishes for new products
gen practice_McKandW_M3 = f4_7_28
replace practice_McKandW_M3 = 0 if practice_McKandW_M3==3

* M4 -- Talked to former customer, why quit buying
gen practice_McKandW_M4 = f4_7_29
replace practice_McKandW_M4 = 0 if practice_McKandW_M4==3

* M5 -- Asked supplier, well-selling products
gen practice_McKandW_M5 = f4_7_19
replace practice_McKandW_M5 = 0 if practice_McKandW_M5==3

* M6 -- Attracted customer w special offer
gen practice_McKandW_M6 = f4_7_21
replace practice_McKandW_M6 = 0 if practice_McKandW_M6==3

* M7 -- Advertised
gen practice_McKandW_M7 = f4_7_24
replace practice_McKandW_M7 = 0 if practice_McKandW_M7==3

* B1 -- Negotiated w supplier, lower price
gen practice_McKandW_B1 = f4_7_31
replace practice_McKandW_B1 = 0 if practice_McKandW_B1==3

* B2 -- Compared supplier, quality/quantity of products
gen practice_McKandW_B2 = f4_7_32
replace practice_McKandW_B2 = 0 if practice_McKandW_B2==3

* B3 -- Did not run out of stock
gen practice_McKandW_B3 = f4_7_33
replace practice_McKandW_B3 = 0 if practice_McKandW_B3==3

* R1 -- Kept written business records
gen practice_McKandW_R1 = f4_7_1a
replace practice_McKandW_R1 = 0 if practice_McKandW_R1==3

* R2 -- Recorded every purchase and sale
gen practice_McKandW_R2 = f4_7_1d
replace practice_McKandW_R2 = 0 if practice_McKandW_R2==3

* R3 -- Can use records, see cash on hand
gen practice_McKandW_R3 = f4_7_1g
replace practice_McKandW_R3 = 0 if practice_McKandW_R3==3

* R4 -- Uses records, check sales of part prod
gen practice_McKandW_R4 = f4_7_1h
replace practice_McKandW_R4 = 0 if practice_McKandW_R4==3

* R5 -- Works out cost to business of main prods
gen practice_McKandW_R5 = f4_7_2
replace practice_McKandW_R5 = 0 if practice_McKandW_R5==3

* R6 -- Knows prods w most profit per item selling
gen practice_McKandW_R6 = f4_7_3
replace practice_McKandW_R6 = 0 if practice_McKandW_R6==3

* R7 -- Written monthly expenses budget
gen practice_McKandW_R7 = f4_7_4
replace practice_McKandW_R7 = 0 if practice_McKandW_R7==3

* R8 -- Can use records, pay back hypothetical loan
gen practice_McKandW_R8 = f4_7_1i
replace practice_McKandW_R8 = 0 if practice_McKandW_R8==3

* F1 -- Reviews and analyses fin perform
gen practice_McKandW_F1 = f4_7_7a
replace practice_McKandW_F1 = 0 if practice_McKandW_F1==3

* F2 -- Sets sales target over next year
gen practice_McKandW_F2 = f4_7_8
replace practice_McKandW_F2 = 0 if practice_McKandW_F2==3

* F3 -- Compares target with sales at least monthly
gen practice_McKandW_F3 = f4_7_9a
replace practice_McKandW_F3 = 0 if practice_McKandW_F3==3

* F4 -- Cost budget, next yr
gen practice_McKandW_F4 = f4_7_10
replace practice_McKandW_F4 = 0 if practice_McKandW_F4==3

* F5 -- Annual profit and loss statement
gen practice_McKandW_F5 = f4_7_11
replace practice_McKandW_F5 = 0 if practice_McKandW_F5==3

* F6 -- Annual cash-flow statement
gen practice_McKandW_F6 = f4_7_12
replace practice_McKandW_F6 = 0 if practice_McKandW_F6==3

* F7 -- Annual balance sheet
gen practice_McKandW_F7 = f4_7_13
replace practice_McKandW_F7 = 0 if practice_McKandW_F7==3

* F8 -- Annual income and expenditure sheet
gen practice_McKandW_F8 = f4_7_14
replace practice_McKandW_F8 = 0 if practice_McKandW_F8==3

*** Missing vars analysis
* Detect missing values in practice_McKandW_McKandW vars --> none!
mdesc practice_McKandW_M1 practice_McKandW_M2 practice_McKandW_M3 ///
practice_McKandW_M4 practice_McKandW_M5 practice_McKandW_M6 practice_McKandW_M7 ///
practice_McKandW_B1 practice_McKandW_B2 practice_McKandW_B3 practice_McKandW_R1 ///
practice_McKandW_R2 practice_McKandW_R3 practice_McKandW_R4 practice_McKandW_R5 ///
practice_McKandW_R6 practice_McKandW_R7 practice_McKandW_R8 practice_McKandW_F1 ///
practice_McKandW_F2 practice_McKandW_F3 practice_McKandW_F4 practice_McKandW_F5 ///
practice_McKandW_F6 practice_McKandW_F7 practice_McKandW_F8 
* Define idk's, etc. as missing values
tab practice_McKandW_M1 
tab practice_McKandW_M2 
tab practice_McKandW_M3 
tab practice_McKandW_M4 
tab practice_McKandW_M5 // 2 idk's!
tab practice_McKandW_M6 
tab practice_McKandW_M7 
tab practice_McKandW_B1 // 1 idk!
tab practice_McKandW_B2 // 2 idk's!
tab practice_McKandW_B3 
tab practice_McKandW_R1 
tab practice_McKandW_R2 
tab practice_McKandW_R3 
tab practice_McKandW_R4 // 1 idk!
tab practice_McKandW_R5 // 2 idk's!
tab practice_McKandW_R6 
tab practice_McKandW_R7 // 1 idk!
tab practice_McKandW_R8 // 36 idk's!
tab practice_McKandW_F1 
tab practice_McKandW_F2 // 5 idk's!
tab practice_McKandW_F3 // 2 idk's!
tab practice_McKandW_F4 // 1 idk!
tab practice_McKandW_F5 // 1 idk!
tab practice_McKandW_F6 
tab practice_McKandW_F7 
tab practice_McKandW_F8
* Define idk's ("8") as missing values
foreach x of varlist practice_McKandW_* {
   replace `x' =.  if `x'==8
   }

*** Creating vars for answers given
* Create var for total answers given (for percentage score)
gen practice_McKandWanswers_total = 0
foreach x of varlist practice_McKandW_* {
   replace practice_McKandWanswers_total = practice_McKandWanswers_total+1  if `x'==0 | `x'==1
   }


* Create var for marketing answers given (for percentage score)
gen practice_McKandWanswers_M = 0
foreach x of varlist practice_McKandW_M* {
   replace practice_McKandWanswers_M = practice_McKandWanswers_M+1  if `x'==0 | `x'==1
   }


* Create var for stock answers given (for percentage score)
gen practice_McKandWanswers_B = 0
foreach x of varlist practice_McKandW_B* {
   replace practice_McKandWanswers_B = practice_McKandWanswers_B+1  if `x'==0 | `x'==1
   }


* Create var for record answers given (for percentage score)
gen practice_McKandWanswers_R = 0
foreach x of varlist practice_McKandW_R* {
   replace practice_McKandWanswers_R = practice_McKandWanswers_R+1  if `x'==0 | `x'==1
   }


* Create var for planning answers given (for percentage score)
gen practice_McKandWanswers_F = 0
foreach x of varlist practice_McKandW_F* {
   replace practice_McKandWanswers_F = practice_McKandWanswers_F+1  if `x'==0 | `x'==1
   }

* Create control dummies for non-answer in any of the 26 questions
gen practice_McKandWanswers_miss = 1 if practice_McKandWanswers_total<26
replace practice_McKandWanswers_miss=0 if practice_McKandWanswers_miss==.
tab practice_McKandWanswers_miss
* Least answers given: 20 --> 1 obs!
list practice_McKandWanswers_total if practice_McKandWanswers_total<23


***** COMP SCORE

egen practice_McKandW_score_total = rowtotal(practice_McKandW_M1 ///
practice_McKandW_M2 practice_McKandW_M3 practice_McKandW_M4 practice_McKandW_M5 ///
practice_McKandW_M6 practice_McKandW_M7 practice_McKandW_B1 practice_McKandW_B2 ///
practice_McKandW_B3 practice_McKandW_R1 practice_McKandW_R2 practice_McKandW_R3 ///
practice_McKandW_R4 practice_McKandW_R5 practice_McKandW_R6 practice_McKandW_R7 ///
practice_McKandW_R8 practice_McKandW_F1 practice_McKandW_F2 practice_McKandW_F3 ///
practice_McKandW_F4 practice_McKandW_F5 practice_McKandW_F6 practice_McKandW_F7 ///
practice_McKandW_F8)
tab practice_McKandW_score_total
* Marketing sub-score
egen practice_McKandW_score_M = rowtotal(practice_McKandW_M1 practice_McKandW_M2 practice_McKandW_M3 practice_McKandW_M4 ///
practice_McKandW_M5 practice_McKandW_M6 practice_McKandW_M7)
* Stock sub-score
egen practice_McKandW_score_B = rowtotal(practice_McKandW_B1 practice_McKandW_B2 practice_McKandW_B3)
* Record sub-score
egen practice_McKandW_score_R = rowtotal(practice_McKandW_R1 practice_McKandW_R2 practice_McKandW_R3 ///
practice_McKandW_R4 practice_McKandW_R5 practice_McKandW_R6 practice_McKandW_R7 practice_McKandW_R8)
* Planning sub-score
egen practice_McKandW_score_F = rowtotal(practice_McKandW_F1 practice_McKandW_F2 practice_McKandW_F3 ///
practice_McKandW_F4 practice_McKandW_F5 practice_McKandW_F6 practice_McKandW_F7 practice_McKandW_F8)


***** PERCENTAGE SCORE

*** Perc total score
gen practice_McKandW_perc_total = practice_McKandW_score_total/practice_McKandWanswers_total
egen practice_McKandW_perc_total_md = median(practice_McKandW_perc_total)
* Quantiles of perc total
xtile practice_McKandW_perc_total_qs = practice_McKandW_perc_total, nq(10)

*** Perc sub-scores

* Percentage marketing score
gen practice_McKandW_perc_M = practice_McKandW_score_M/practice_McKandWanswers_M
egen practice_McKandW_perc_M_md = median(practice_McKandW_perc_M)
* Percentage stock score
gen practice_McKandW_perc_B = practice_McKandW_score_B/practice_McKandWanswers_B
egen practice_McKandW_perc_B_md = median(practice_McKandW_perc_B)
* Percentage record score
gen practice_McKandW_perc_R = practice_McKandW_score_R/practice_McKandWanswers_R
egen practice_McKandW_perc_R_md = median(practice_McKandW_perc_R)
* Percentage planning score
gen practice_McKandW_perc_F = practice_McKandW_score_F/practice_McKandWanswers_F
egen practice_McKandW_perc_F_md = median(practice_McKandW_perc_F)

*** Missing answers check

levelsof practice_McKandWanswers_total
list srid practice_McKandW_perc_total if practice_McKandWanswers_total==19 // 1 obs, McKandW perc score==0.105


_crcslbl practice_McKandW_M1 f4_7_17
_crcslbl practice_McKandW_M2 f4_7_18
_crcslbl practice_McKandW_M3 f4_7_28
_crcslbl practice_McKandW_M4 f4_7_29
_crcslbl practice_McKandW_M5 f4_7_19
_crcslbl practice_McKandW_M6 f4_7_21
_crcslbl practice_McKandW_M7 f4_7_24
_crcslbl practice_McKandW_B1 f4_7_31
_crcslbl practice_McKandW_B2 f4_7_32
_crcslbl practice_McKandW_B3 f4_7_33
_crcslbl practice_McKandW_R1 f4_7_1a
_crcslbl practice_McKandW_R2 f4_7_1d
_crcslbl practice_McKandW_R3 f4_7_1g
_crcslbl practice_McKandW_R4 f4_7_1h
_crcslbl practice_McKandW_R5 f4_7_2
_crcslbl practice_McKandW_R6 f4_7_3
_crcslbl practice_McKandW_R7 f4_7_4
_crcslbl practice_McKandW_R8 f4_7_1i
_crcslbl practice_McKandW_F1 f4_7_7a
_crcslbl practice_McKandW_F2 f4_7_8
_crcslbl practice_McKandW_F3 f4_7_9a
_crcslbl practice_McKandW_F4 f4_7_10
_crcslbl practice_McKandW_F5 f4_7_11
_crcslbl practice_McKandW_F6 f4_7_12
_crcslbl practice_McKandW_F7 f4_7_13
_crcslbl practice_McKandW_F8 f4_7_14


***** ROLE-MODEL CANDIDATES

*** Potential record-keeping role-models with good business-practices score
list srid if practice_rec_ledger_prods_daily==1 & practice_McKandW_perc_total>0.70



************************************************************************
*** OTHER BUSINESS PRACTICES **************************************

***** SEPARATION OF PRIVATE AND BUSINESS FIN

* Detect missing values in asset var --> none!
mdesc f4_7_6
* Dummy for having separate finances
tab f4_7_6
gen finances_separate = 1 if f4_7_6==1
replace finances_separate = 0 if finances_separate==.


***** SALES TARGETS

* Dummy for target set for sales over next year
tab practice_McKandW_F2
* Dummy for comparing sales target to sales at least monthly
tab practice_McKandW_F3
* Frequency of comparing sales target to sales --> 823 missing values!
* Var not clearly defined. SM seems to have asked f4_7_9b conditional on 
* f4_7_9a==1, which is wrong considering the answering options 0, 1, and 2. 
* More confusing even still, there are 30 instances of respondents answering 1 or 2.
mdesc f4_7_9b 
count if practice_McKandW_F3==0 & f4_7_9b==.


***** COMPARING SALES PERFORMANCE TO COMPETITORS

* Detect missing values in asset var --> none!
mdesc f4_7_16
* Dummy for comparing sales performance --> 2 idk's!
tab f4_7_16
gen practice_sales_comp = 1 if f4_7_16==1
replace practice_sales_comp = 0 if practice_sales_comp==.


***** PRICE CHANGES

* Detect missing values in asset var --> none!
mdesc f4_7_19a f4_7_19a_A f4_7_19a_B f4_7_19a_C f4_7_19a_D f4_7_19a_E
tab f4_7_19a
* Dummy for price change due to comp's price
tab f4_7_19a_A
gen practice_price_comp = 1 if f4_7_19a_A==1
replace practice_price_comp = 0 if practice_price_comp==.
* Dummy for price change due to demand change
tab f4_7_19a_B
gen practice_price_demand = 1 if f4_7_19a_B==1
replace practice_price_demand = 0 if practice_price_demand==.
* Dummy for discount given (loyal customer, bulk, product in need to be sold)
tab f4_7_19a_C
tab f4_7_19a_D
tab f4_7_19a_E
gen practice_price_discount = 1 if f4_7_19a_C==1 | f4_7_19a_D==1 | f4_7_19a_E==1
replace practice_price_discount = 0 if practice_price_discount==.

tab practice_price_comp
tab practice_price_demand
tab practice_price_discount


***** INVENTORY CHANGES

* Detect missing values in asset var --> none!
mdesc f4_7_26a f4_7_26b f4_7_26c f4_7_26d
* Dummy for inventory change due to demand change
tab f4_7_26a
gen practice_inv_demand = 1 if f4_7_26a==1
replace practice_inv_demand = 0 if practice_inv_demand==.
* Dummy for inventory change according to shelfspace
tab f4_7_26b // 1 idk (as missing value)!
gen practice_inv_space = 1 if f4_7_26b==1
replace practice_inv_space = 0 if practice_inv_space==.
* Dummy for inventory change according to profit earned
tab f4_7_26d
gen practice_inv_profit = 1 if f4_7_26d==1
replace practice_inv_profit = 0 if practice_inv_profit==.
* Dummy for inventory change due to change in supplier price
tab f4_7_26c
gen practice_inv_supplprice = 1 if f4_7_26c==1
replace practice_inv_supplprice = 0 if practice_inv_supplprice==.

tab practice_inv_demand
tab practice_inv_space
tab practice_inv_profit
tab practice_inv_supplprice


***** INTRO OF NEW PRODS

* Detect missing values in asset var --> none!
mdesc f4_7_27
* Product introduction last 12 mth
* (Not clear whether extreme values are mistakes)
tab f4_7_27
list labour_total firm_space_mid firm_space_small firm_space_micro if f4_7_27>15
gen practice_prods_new = f4_7_27
* Dummy for having introduced any new product in the past 12 mth
gen practice_prods_new1 = 1 if f4_7_27>0
replace practice_prods_new1 = 0 if practice_prods_new1==.
* Dummy for having introduced at least 5 new products
gen practice_prods_new5 = 1 if f4_7_27>4
replace practice_prods_new5 = 0 if practice_prods_new5==.


***** TRADE CREDIT

* Detect missing values in asset var --> 0, 188 obs!
mdesc f4_7_30a f4_7_30b
* Dummy for providing trade credit
tab f4_7_30a
gen practice_credit_trade = 1 if f4_7_30a==1
replace practice_credit_trade = 0 if practice_credit_trade==.
* Dummy for demanding interest -> Only 98 buinesses demand interest
tab f4_7_30b
gen practice_credit_trade_int = 1 if f4_7_30b==1
replace practice_credit_trade_int = 0 if practice_credit_trade_int==.

tab practice_credit_trade
tab practice_credit_trade_int



************************************************************************
*** PRACTICES (TO BE) IMPLEMENTED IN LAST/NEXT 12 MTH ********************

***** PRACTICES

* Detect missing values in asset var --> none!
mdesc f4_7_16 f4_7_15a1 f4_7_15b1 f4_7_15a2 f4_7_15b2 f4_7_15a3 f4_7_15b3 ///
f4_7_15a4 f4_7_15b4 f4_7_15a5 f4_7_15b5 f4_7_15a6 f4_7_15b6 f4_7_15a7 ///
f4_7_15b7 f4_7_15a8 f4_7_15b8 f4_7_15a9 f4_7_15b9 f4_7_15a10 f4_7_15b10 ///
f4_7_15a11 f4_7_15b11

*** Cut costs
tab f4_7_15a1
tab f4_7_15b1 // 14 idk's (as missing values)
gen practice_cutcosts_lastyr = 1 if f4_7_15a1==1
replace practice_cutcosts_lastyr = 0 if practice_cutcosts_lastyr==.
gen practice_cutcosts_nextyr = 1 if f4_7_15b1==1
replace practice_cutcosts_lastyr = 0 if practice_cutcosts_lastyr==.

*** Worked with new supplier
tab f4_7_15a2
tab f4_7_15b2 // 58 idk's, 1 rejection (as missing values)
gen practice_newsuppl_lastyr = 1 if f4_7_15a2==1
replace practice_newsuppl_lastyr = 0 if practice_newsuppl_lastyr==.
gen practice_newsuppl_nextyr = 1 if f4_7_15b2==1
replace practice_newsuppl_nextyr = 0 if practice_newsuppl_nextyr==.

*** Bought higher qual prod
tab f4_7_15a3
tab f4_7_15b3 // 37 idk's (as missing values)
gen practice_prodqual_lastyr =1 if f4_7_15a3==1
replace practice_prodqual_lastyr = 0 if practice_prodqual_lastyr==.
gen practice_prodqual_nextyr = 1 if f4_7_15b3==1
replace practice_prodqual_nextyr = 0 if practice_prodqual_nextyr==.

*** Introduced new brand
tab f4_7_15a4 // 2 idk's (as missing values)
tab f4_7_15b4 // 62 idk's (as missing values)
gen practice_newbrand_lastyr = 1 if f4_7_15a4==1
replace practice_newbrand_lastyr = 0 if practice_newbrand_lastyr==.
gen practice_newbrand_nextyr = 1 if f4_7_15b4==1
replace practice_newbrand_nextyr = 0 if practice_newbrand_nextyr==.

*** Opened new business
tab f4_7_15a5 // 76 businesses opened new branch in last 12 mth!
tab f4_7_15b5 // 12 idk's (as missing values)
gen practice_newbranch_lastyr = 1 if f4_7_15a5==1
replace practice_newbranch_lastyr = 0 if practice_newbranch_lastyr==.
gen practice_newbranch_nextyr = 1 if f4_7_15b5==1
replace practice_newbranch_nextyr = 0 if practice_newbranch_nextyr==.

*** Delegated more tasks to employees
tab f4_7_15a6 // 65 "N/A"? (as missing values)
tab f4_7_15b6 // 19 idk's, 53 "N/A"? (as missing values)
gen practice_delegate_lastyr = 1 if f4_7_15a6==1
replace practice_delegate_lastyr = 0 if practice_delegate_lastyr==.
gen practice_delegate_nextyr = 1 if f4_7_15b6==1
replace practice_delegate_nextyr = 0 if practice_delegate_nextyr==.

*** Developped business plan
tab f4_7_15a7
tab f4_7_15b7 // 13 idk's (as missing values)
gen practice_plan_lastyr =1 if f4_7_15a7==1
replace practice_plan_lastyr = 0 if practice_plan_lastyr==.
gen practice_plan_nextyr = 1 if f4_7_15b7==1
replace practice_plan_nextyr = 0 if practice_plan_nextyr==.

*** Started/improved records
tab f4_7_15a8
tab f4_7_15b8 // 17 idk's (as missing values)
gen practice_record_lastyr = 1 if f4_7_15a8==1
replace practice_record_lastyr = 0 if practice_record_lastyr==.
gen practice_record_nextyr = 1 if f4_7_15b8==1
replace practice_record_nextyr = 0 if practice_record_nextyr==.

*** Got loan
tab f4_7_15a9
tab f4_7_15b9 // 35 idk's (as missing values)
gen practice_loan_lastyr = 1 if f4_7_15a9==1
replace practice_loan_lastyr = 0 if practice_loan_lastyr==.
gen practice_loan_nextyr = 1 if f4_7_15b9==1
replace practice_loan_nextyr = 0 if practice_loan_nextyr==.

*** Coop with competitor
tab f4_7_15a10
tab f4_7_15b10 // 12 idk's (as missing values)
gen practice_coopcomp_lastyr = 1 if f4_7_15a10==1
replace practice_coopcomp_lastyr = 0 if practice_coopcomp_lastyr==.
gen practice_coopcomp_nextyr = 1 if f4_7_15b10==1
replace practice_coopcomp_nextyr = 0 if practice_coopcomp_nextyr==.

*** Applied for VAT number
tab f4_7_15a11 // 5 idk's (as missing values)
tab f4_7_15b11 // 53 idk's (as missing values)
gen practice_vat_lastyr = 1 if f4_7_15a11==1
replace practice_vat_lastyr = 0 if practice_vat_lastyr==.
gen practice_vat_nextyr = 1 if f4_7_15b11==1
replace practice_vat_nextyr = 0 if practice_vat_nextyr==.


***** SOCIAL COMPARISON

* Detect missing values in asset var --> none!
mdesc f4_7_34
tab f4_7_34
sum f4_7_34
* Dummy for perceived superiority
gen practice_socialcomp_super = 1 if f4_7_34==3
replace practice_socialcomp_super = 0 if practice_socialcomp_super==.
* Dummy for perceived inferiority
gen practice_socialcomp_infer = 1 if f4_7_34==1
replace practice_socialcomp_infer = 0 if practice_socialcomp_infer==.
* Dummy for refusal (possible proxy for distaste for social comparison)
gen practice_socialcomp_ref = 1 if f4_7_34==8
replace practice_socialcomp_ref = 0 if practice_socialcomp_ref==.

tab practice_socialcomp_super
tab practice_socialcomp_infer
tab practice_socialcomp_ref



************************************************************************
*** DISCUSSION AND DECISION-MAKING **************************************

***** DISCUSSION OF BUSINESS TOPICS W OTHERS

*** Discussing any business topics w others

* Detect missing values in asset var --> 0, 296 obs!
mdesc f4_7_35a f4_7_35bx

* Dummy for discussing any business topics
tab f4_7_35a
gen practice_disc_any = 1 if f4_7_35a==1
replace practice_disc_any = 0 if practice_disc_any==.
tab practice_disc_any


*** Specific topics

* Dummy for specific topics discussed with others and how frequently
tab f4_7_35bx 
tab f4_7_35bxxA 
tab f4_7_35bxxB 
tab f4_7_35bxxC 
tab f4_7_35bxxD // Only 2 businesses answered in the affirmatve
tab f4_7_35bxxE // Only 9 businesses answered in the affirmatve
tab f4_7_35bxxF // 0 businesses answered in the affirmatve
tab f4_7_35bxxG
tab f4_7_35bxxH // 0 businesses answered in the affirmatve
tab f4_7_35bxxI // Only 13 businesses answered in the affirmatve
tab f4_7_35bxxJ
tab f4_7_35bxxK
tab f4_7_35bxxL
tab f4_7_35bxxM
tab f4_7_35bxxN // Only 15 businesses answered in the affirmatve
tab f4_7_35bxxO // Only 7 businesses answered in the affirmatve
tab f4_7_35bxxP // Only 1 business answered in the affirmatve
tab f4_7_35bxxQ // Only 21 businesses answered in the affirmatve
tab f4_7_35bxxR // Only 1 business answered in the affirmatve
tab f4_7_35bxxS // Only 10 businesses answered in the affirmatve

tab f4_7_35dA
tab f4_7_35dB
tab f4_7_35dC
tab f4_7_35dG
tab f4_7_35dJ
tab f4_7_35dK
tab f4_7_35dL
tab f4_7_35dM

* A Sales
gen practice_disc_sales = 1 if f4_7_35bxxA==1
replace practice_disc_sales = 0 if practice_disc_sales==.
gen practice_disc_sales_wkly = 1 if f4_7_35dA==5 | f4_7_35dA==6 | f4_7_35dA==7
replace practice_disc_sales_wkly = 0 if practice_disc_sales_wkly==.
* B Selling price
gen practice_disc_sellprice = 1 if f4_7_35bxxB==1
replace practice_disc_sellprice = 0 if practice_disc_sellprice==.
gen practice_disc_sellprice_wkly = 1 if f4_7_35dB==5 | f4_7_35dB==6 | f4_7_35dB==7
replace practice_disc_sellprice_wkly = 0 if practice_disc_sellprice_wkly==.
* C Best-selling product
gen practice_disc_bestsell = 1 if f4_7_35bxxC==1
replace practice_disc_bestsell = 0 if practice_disc_bestsell==.
gen practice_disc_bestsell_wkly = 1 if f4_7_35dC==5 | f4_7_35dC==6 | f4_7_35dC==7
replace practice_disc_bestsell_wkly = 0 if practice_disc_bestsell_wkly==.
* G Finance opportunities
gen practice_disc_finance = 1 if f4_7_35bxxG==1
replace practice_disc_finance = 0 if practice_disc_finance==.
* J Purchasing price
gen practice_disc_buyprice = 1 if f4_7_35bxxJ==1
replace practice_disc_buyprice = 0 if practice_disc_buyprice==.
* K New brand/product
gen practice_disc_newprod = 1 if f4_7_35bxxK==1
replace practice_disc_newprod = 0 if practice_disc_newprod==.
gen practice_disc_newprod_wkly = 1 if f4_7_35dK==5 | f4_7_35dK==6 | f4_7_35dK==7
replace practice_disc_newprod_wkly = 0 if practice_disc_newprod_wkly==.
* L Common (?) business practice
gen practice_disc_practice = 1 if f4_7_35bxxL==1
replace practice_disc_practice = 0 if practice_disc_practice==.
gen practice_disc_practice_wkly = 1 if f4_7_35dL==5 | f4_7_35dL==6 | f4_7_35dL==7
replace practice_disc_practice_wkly = 0 if practice_disc_practice_wkly==.
* M Business plan
gen practice_disc_plan = 1 if f4_7_35bxxM==1
replace practice_disc_plan = 0 if practice_disc_plan==.
gen practice_disc_plan_wkly = 1 if f4_7_35dM==5 | f4_7_35dM==6 | f4_7_35dM==7
replace practice_disc_plan_wkly = 0 if practice_disc_plan_wkly==.

* Jointly discussing anything on a daily basis
gen practice_disc_any_daily = 0

foreach x of varlist f4_7_35dA f4_7_35dB f4_7_35dC f4_7_35dD f4_7_35dE f4_7_35dF ///
f4_7_35dG f4_7_35dH f4_7_35dI f4_7_35dJ f4_7_35dK f4_7_35dL f4_7_35dM f4_7_35dN ///
f4_7_35dO f4_7_35dP f4_7_35dQ f4_7_35dR f4_7_35dS{
   replace practice_disc_any_daily = practice_disc_any_daily+1  if `x'==7
   }

tab practice_disc_any_daily
   
replace practice_disc_any_daily = 1 if practice_disc_any_daily>0
   
tab practice_disc_any_daily


*** Specific people

* Detect missing values in asset var --> 1115, 1045, 1140, 1218, 1178, 1223, 1152, 1133 obs!
mdesc f4_7_35cA f4_7_35cB f4_7_35cC f4_7_35cG f4_7_35cJ f4_7_35cK ///
f4_7_35cL f4_7_35cM
* Remainder not commonly discussed (see above)

tab f4_7_35cA
tab f4_7_35cB
tab f4_7_35cC
tab f4_7_35cG
tab f4_7_35cJ
tab f4_7_35cK
tab f4_7_35cL
tab f4_7_35cM
levelsof f4_7_35cA 
levelsof f4_7_35cB
levelsof f4_7_35cC
levelsof f4_7_35cG
levelsof f4_7_35cJ
levelsof f4_7_35cK
levelsof f4_7_35cL
levelsof f4_7_35cM

* Dummies for specific persons to discuss business topics w
gen practice_disc_fam = 0
gen practice_disc_friend = 0
gen practice_disc_bisfriend = 0
gen practice_disc_suppl = 0

foreach x of varlist f4_7_35cA f4_7_35cB f4_7_35cC f4_7_35cD f4_7_35cE f4_7_35cF ///
f4_7_35cG f4_7_35cH f4_7_35cI f4_7_35cJ f4_7_35cK f4_7_35cL f4_7_35cM f4_7_35cN ///
f4_7_35cO f4_7_35cP f4_7_35cQ f4_7_35cR f4_7_35cS{
   replace practice_disc_fam = practice_disc_fam+1  if `x'==8
   replace practice_disc_friend = practice_disc_friend+1 if `x'==7
   replace practice_disc_bisfriend = practice_disc_bisfriend+1 if `x'==6 | `x'==5
   replace practice_disc_suppl = practice_disc_suppl+1 if `x'==4
   }

replace practice_disc_fam = 1 if practice_disc_fam>0
replace practice_disc_friend = 1 if practice_disc_friend>0
replace practice_disc_bisfriend = 1 if practice_disc_bisfriend>0
replace practice_disc_suppl = 1 if practice_disc_suppl>0

tab practice_disc_fam
tab practice_disc_friend
tab practice_disc_bisfriend
tab practice_disc_suppl


***** JOINT DECISION-MAKING ABOUT BUSINESS TOPICS W OTHERS

*** Decision-making w others in general

* Detect missing values in asset var --> 0, 745 obs!
mdesc f4_7_36a f4_7_36bx f4_7_36e

* Dummy for making any business decisions jointly with others
tab f4_7_36a
gen practice_decide_any = 1 if f4_7_36a==1
replace practice_decide_any = 0 if practice_decide==.
tab practice_decide_any
* Dummy for joint decision-making w (in-)formal agreement
tab f4_7_36e
gen practice_decide_agreed = 1 if f4_7_36e==1
replace practice_decide_agreed = 0 if practice_decide_agreed==.


*** Specific topics

* Dummy for specific topics decided about jointly with others and how frequently
tab f4_7_36bx
tab f4_7_36bxxA
tab f4_7_36bxxB
tab f4_7_36bxxC
tab f4_7_36bxxD // Only 1 business answered in the affirmatve
tab f4_7_36bxxE // Only 3 businesses answered in the affirmatve
tab f4_7_36bxxF // 0 businesses answered in the affirmatve
tab f4_7_36bxxG
tab f4_7_36bxxH // 0 businesses answered in the affirmatve
tab f4_7_36bxxI // Only 8 businesses answered in the affirmatve
tab f4_7_36bxxJ
tab f4_7_36bxxK
tab f4_7_36bxxL
tab f4_7_36bxxM
tab f4_7_36bxxN // Only 4 businesses answered in the affirmatve
tab f4_7_36bxxO // Only 2 businesses answered in the affirmatve
tab f4_7_36bxxP // Only 2 businesses answered in the affirmatve
tab f4_7_36bxxQ // Only 17 businesses answered in the affirmatve
tab f4_7_36bxxR // Only 8 businesses answered in the affirmatve
tab f4_7_36bxxS // Only 16 businesses answered in the affirmatve

tab f4_7_36dA
tab f4_7_36dB
tab f4_7_36dC
tab f4_7_36dG // Only 17 businesses decide about financing opportunities w others at least weekly
tab f4_7_36dJ // Only 26 businesses decide about purch price w others at least weekly
tab f4_7_36dK
tab f4_7_36dL
tab f4_7_36dM

* A Sales
gen practice_decide_sales = 1 if f4_7_36bxxA==1
replace practice_decide_sales = 0 if practice_decide_sales==.
gen practice_decide_sales_wkly = 1 if f4_7_36dA==5 | f4_7_36dA==6 | f4_7_36dA==7
replace practice_decide_sales_wkly = 0 if practice_decide_sales_wkly==.
* B Selling price
gen practice_decide_sellprice = 1 if f4_7_36bxxB==1
replace practice_decide_sellprice = 0 if practice_decide_sellprice==.
gen practice_decide_sellprice_wkly = 1 if f4_7_36dB==5 | f4_7_36dB==6 | f4_7_36dB==7
replace practice_decide_sellprice_wkly = 0 if practice_decide_sellprice_wkly==.
* C Best-selling product
gen practice_decide_bestsell = 1 if f4_7_36bxxC==1
replace practice_decide_bestsell = 0 if practice_decide_bestsell==.
gen practice_decide_bestsell_wkly = 1 if f4_7_36dC==5 | f4_7_36dC==6 | f4_7_36dC==7
replace practice_decide_bestsell_wkly = 0 if practice_decide_bestsell_wkly==.
* G Finance opportunities
gen practice_decide_finance = 1 if f4_7_36bxxG==1
replace practice_decide_finance = 0 if practice_decide_finance==.
* J Purchasing price
gen practice_decide_buyprice = 1 if f4_7_36bxxJ==1
replace practice_decide_buyprice = 0 if practice_decide_buyprice==.
* K New brand/product
gen practice_decide_newprod = 1 if f4_7_36bxxK==1
replace practice_decide_newprod = 0 if practice_decide_newprod==.
gen practice_decide_newprod_wkly = 1 if f4_7_36dK==5 | f4_7_36dK==6 | f4_7_36dK==7
replace practice_decide_newprod_wkly = 0 if practice_decide_newprod_wkly==.
* L Common (?) business practice
gen practice_decide_practice = 1 if f4_7_36bxxL==1
replace practice_decide_practice = 0 if practice_decide_practice==.
gen practice_decide_practice_wkly = 1 if f4_7_36dL==5 | f4_7_36dL==6 | f4_7_36dL==7
replace practice_decide_practice_wkly = 0 if practice_decide_practice_wkly==.
* M Business plan
gen practice_decide_plan = 1 if f4_7_36bxxM==1
replace practice_decide_plan = 0 if practice_decide_plan==.
gen practice_decide_plan_wkly = 1 if f4_7_36dM==5 | f4_7_36dM==6 | f4_7_36dM==7
replace practice_decide_plan_wkly = 0 if practice_decide_plan_wkly==.

* Jointly deciding on anything on a daily basis
gen practice_decide_any_daily = 0

foreach x of varlist f4_7_36dA f4_7_36dB f4_7_36dC f4_7_36dD f4_7_36dE f4_7_36dF ///
f4_7_36dG f4_7_36dH f4_7_36dI f4_7_36dJ f4_7_36dK f4_7_36dL f4_7_36dM f4_7_36dN ///
f4_7_36dO f4_7_36dP f4_7_36dQ f4_7_36dR f4_7_36dS{
   replace practice_decide_any_daily = practice_decide_any_daily+1  if `x'==7
   }

replace practice_decide_any_daily = 1 if practice_decide_any_daily>0
   
tab practice_decide_any_daily


*** Specific people

* Detect missing values in asset var --> 1115, 1045, 1140, 1218, 1178, 1223, 1152, 1133 obs!
mdesc f4_7_35cA f4_7_35cB f4_7_35cC f4_7_35cG f4_7_35cJ f4_7_35cK ///
f4_7_35cL f4_7_35cM
* Remainder not commonly discussed (see above)

tab f4_7_36cA
tab f4_7_36cB
tab f4_7_36cC
tab f4_7_36cG
tab f4_7_36cJ
tab f4_7_36cK
tab f4_7_36cL
tab f4_7_36cM
levelsof f4_7_36cA 
levelsof f4_7_36cB
levelsof f4_7_36cC
levelsof f4_7_36cG
levelsof f4_7_36cJ
levelsof f4_7_36cK
levelsof f4_7_36cL
levelsof f4_7_36cM

* Dummies for specific persons to decide on business topics w
gen practice_decide_fam = 0
* All other possible partners are being consulted by <10 firms

foreach x of varlist f4_7_36cA f4_7_36cB f4_7_36cC f4_7_36cD f4_7_36cE f4_7_36cF ///
f4_7_36cG f4_7_36cH f4_7_36cI f4_7_36cJ f4_7_36cK f4_7_36cL f4_7_36cM f4_7_36cN ///
f4_7_36cO f4_7_36cP f4_7_36cQ f4_7_36cR f4_7_36cS{
   replace practice_decide_fam = practice_decide_fam+1  if `x'==8
   }

replace practice_decide_fam = 1 if practice_decide_fam>0

tab practice_decide_fam



************************************************************************
***** LOANS AND FINANCES ***********************************************


*** Missing value treatment

* Detect missing values in licences vars --> 0, 1071, 3, 0, 0, 0, 0, 0!
mdesc f4_9_1 f4_9_2 f4_9_8 f4_9_11a f4_9_11b 
* Idk's, etc. as missing values
tab f4_9_1
tab f4_9_2
tab f4_9_8
tab f4_9_11a // 53 idk's, 7 not answering
tab f4_9_11b // 28 idk's, 18 not answering
levelsof f4_9_11a


*** Vars for loan application, uptake, and principle owed 

* Generate loan vars
gen owner_loan_apply = f4_9_1
gen owner_loan_obtain = f4_9_2
replace owner_loan_obtain = 0 if owner_loan_obtain==.
* Converted to USD with 13,150 IDR (Mid-market rates: 2016-05-02 09:18 UTC)
gen owner_loan_owed = f4_9_8/xchange
replace owner_loan_owed = 0 if owner_loan_owed==.
* Dummy for having obtained at least 1 loan
gen owner_loan_obtain_1 = 1 if owner_loan_obtain>0
replace owner_loan_obtain_1 = 0 if owner_loan_obtain_1==.

* Amount owed in months judging by sales and profits
gen owner_loan_owed_salesmth = owner_loan_owed/sales_lastmth if owner_loan_owed<. & sales_lastmth<.
replace owner_loan_owed_salesmth = 0 if owner_loan_owed_salesmth==.
gen owner_loan_owed_profitmth = owner_loan_owed/profit_lastmth if owner_loan_owed<. & profit_lastmth<.
replace owner_loan_owed_profitmth = 0 if owner_loan_owed_profitmth==.

* Winsorisation
* Principal owed and rel. principal owed w sales and profits winsorised at p99 (both sides)
winsor owner_loan_owed, gen(owner_loan_owed_w) p(0.01)
winsor owner_loan_owed_salesmth, gen(owner_loan_owed_salesmth_w) p(0.01)
winsor owner_loan_owed_profitmth, gen(owner_loan_owed_profitmth_w) p(0.01)


*** Vars for financial literacy

* Generate literacy vars
gen owner_finlit_int = 1 if f4_9_11b==2
replace owner_finlit_int = 0 if owner_finlit_int==.
gen owner_finlit_compint = 1 if f4_9_11a==1
replace owner_finlit_compint = 0 if owner_finlit_compint==.
gen owner_finlit_compscore = owner_finlit_int + owner_finlit_compint


tab owner_loan_apply
tab owner_loan_obtain
tab owner_loan_owed
tab owner_loan_owed_w
tab owner_loan_owed_salesmth
tab owner_loan_owed_salesmth_w
tab owner_loan_owed_profitmth
tab owner_loan_owed_profitmth_w



************************************************************************
***** ASPIRATIONS ******************************************************


***** ULTIMATE ASPIRATIONS FOR THE SHOP

* Detect missing values in aspiration vars --> none!
mdesc f4_10_01aa f4_10_01a f4_10_01b f4_10_01c f4_10_01d

*** Current shop space
tab f4_10_01aa
gen firm_space_cont = f4_10_01aa
label val firm_space_cont f4_10_01aa
tab firm_space_cont
_crcslbl firm_space_cont f4_10_01aa



*** Aspired shop space
gen aspire_space_dream = f4_10_01b
label var aspire_space_dream "How big do you imagine your shop to be?" 

*** Aspired no of employees
gen aspire_employ_dream = f4_10_01c
label var aspire_employ_dream "How many people will work there?"

*** Aspired no of customers
gen aspire_custom_dream = f4_10_01d
label var aspire_custom_dream "How many customers will come by on a normal day?"

*** Time horizon for ultimate aspirations
gen aspire_dream_yrs = f4_10_01e
label var aspire_dream_yrs "When do you think you can have achieved this?"

label val aspire_space_dream f4_10_01b
label val aspire_employ_dream f4_10_01c
label val aspire_custom_dream f4_10_01d
label val aspire_dream_yrs f4_10_01e

tab aspire_space_dream
tab aspire_employ_dream
tab aspire_custom_dream
tab aspire_dream_yrs


****** ASPIRATIONS FOR THE SHOP IN 12 MTH and 18 MTH FROM NOW

* Detect missing values in aspiration vars --> none!
mdesc f4_10_02a f4_10_02b f4_10_02c

gen aspire_space_12mth = f4_10_02a
label var aspire_space_12mth
label val aspire_space_12mth f4_10_02a

gen aspire_employ_12mth = f4_10_02b
label var aspire_employ_12mth
label val aspire_employ_12mth f4_10_02b

gen aspire_custom_12mth = f4_10_02c
label var aspire_custom_12mth
label val aspire_custom_12mth f4_10_02c

tab aspire_space_12mth
tab aspire_employ_12mth
tab aspire_custom_12mth

_crcslbl aspire_space_12mth f4_10_02a
_crcslbl aspire_employ_12mth f4_10_02b
_crcslbl aspire_custom_12mth f4_10_02c


**** ASPIRATIONS FOR SALES

* Detect missing values in aspiration vars --> none!
mdesc f4_10_3a f4_10_3b f4_10_3c f4_10_3d f4_10_3e f4_10_3f f4_10_3g f4_10_3h

gen aspire_sales_normday_min = f4_10_3b/xchange
label val aspire_sales_normday_min f4_10_3b
tab aspire_sales_normday_min


gen aspire_sales_normday_12mth = f4_10_3c/xchange
label val aspire_sales_normday_12mth f4_10_3c
tab aspire_sales_normday_12mth

gen aspire_sales_normday_18mth = f4_10_3h/xchange
label val aspire_sales_normday_18mth f4_10_3h
tab aspire_sales_normday_18mth

_crcslbl aspire_sales_normday_min f4_10_3b
_crcslbl aspire_sales_normday_12mth f4_10_3c
_crcslbl aspire_sales_normday_18mth f4_10_3h


***** ASPIRATIONS FOR OFFSPRING

* Detect missing values in aspiration vars --> XX
mdesc f4_10_4a1_age f4_10_4a2_age f4_10_4a3_age f4_10_4b f4_10_4c f4_10_4c_ot ///
f4_10_5a1_age f4_10_5a1_age f4_10_5a1_age f4_10_5b f4_10_5c f4_10_5c_ot

tab f4_10_4a1_age
tab f4_10_4a1_age
tab f4_10_4a1_age
tab f4_10_4b
tab f4_10_4c
tab f4_10_4c_ot

tab f4_10_5a1_age
tab f4_10_5a1_age
tab f4_10_5a1_age
tab f4_10_5b
tab f4_10_5c
tab f4_10_5c_ot

*generate var aspiration for son and daughter
gen owner_son1_age = f4_10_4a1_age
gen owner_son2_age = f4_10_4a2_age
gen owner_son3_age = f4_10_4a3_age
gen owner_selectson_age = f4_10_4a1_age if f4_10_4a1_age<18 ///
& f4_10_4a1_age>f4_10_4a2_age & f4_10_4a1_age>f4_10_4a3_age
replace owner_selectson_age = f4_10_4a2_age if f4_10_4a2_age<18 ///
& f4_10_4a2_age>f4_10_4a1_age & f4_10_4a2>f4_10_4a3_age
replace owner_selectson_age = f4_10_4a3_age if f4_10_4a3_age<18 ///
& f4_10_4a3_age>f4_10_4a1_age & f4_10_4a3>f4_10_4a2_age
gen owner_selectson_educ = f4_10_4b
gen owner_selectson_occup = f4_10_4c

tab owner_son1_age
tab owner_son2_age
tab owner_son3_age

tab owner_selectson_age
tab owner_selectson_educ
tab owner_selectson_occup


gen owner_daughter1_age = f4_10_5a1_age
gen owner_daughter2_age = f4_10_5a2_age
gen owner_daughter3_age = f4_10_5a3_age
gen owner_selectdaughter_age = f4_10_5a1_age if f4_10_5a1_age<18 ///
& f4_10_5a1_age>f4_10_5a2_age & f4_10_5a1_age>f4_10_5a3_age
replace owner_selectdaughter_age = f4_10_5a2_age if f4_10_5a2_age<18 ///
& f4_10_5a2_age>f4_10_5a1_age & f4_10_5a2>f4_10_5a3_age
replace owner_selectdaughter_age = f4_10_5a3_age if f4_10_5a3_age<18 ///
& f4_10_5a3_age>f4_10_5a1_age & f4_10_5a3>f4_10_5a2_age
gen owner_selectdaughter_educ = f4_10_5b
gen owner_selectdaughter_occup = f4_10_5c

tab owner_daughter1_age
tab owner_daughter2_age
tab owner_daughter3_age
tab owner_selectdaughter_age
tab owner_selectdaughter_educ
tab owner_selectdaughter_occup


_crcslbl owner_son1_age f4_10_4a1_age
_crcslbl owner_son2_age f4_10_4a2_age
_crcslbl owner_son3_age f4_10_4a3_age
_crcslbl owner_selectson_educ f4_10_4b
_crcslbl owner_selectson_occup f4_10_4c


_crcslbl owner_daughter1_age f4_10_4a1_age
_crcslbl owner_daughter2_age f4_10_4a2_age
_crcslbl owner_daughter3_age f4_10_4a3_age
_crcslbl owner_selectdaughter_educ f4_10_4b
_crcslbl owner_selectdaughter_occup f4_10_4c

/*

***way to improve business****
* Detect missing values in practices vars --> none!

*records/profits/targets/statements
mdesc f4_10_6a_a01 f4_10_6a_a02 f4_10_6a_a03 f4_10_6a_a04 f4_10_6a_a05 ///
f4_10_6a_a06 f4_10_6a_a07 f4_10_6a_a08 f4_10_6a_a09 f4_10_6a_a10 f4_10_6a_a11

tab f4_10_6a_a01
tab f4_10_6a_a02
tab f4_10_6a_a03
tab f4_10_6a_a04
tab f4_10_6a_a05
tab f4_10_6a_a06
tab f4_10_6a_a07
tab f4_10_6a_a08
tab f4_10_6a_a09
tab f4_10_6a_a10
tab f4_10_6a_a11

*suppliers/products/customers/prices
mdesc f4_10_6a_b01 f4_10_6a_b02 f4_10_6a_b03 f4_10_6a_b04 f4_10_6a_b05 ///
f4_10_6a_b06 f4_10_6a_b07 f4_10_6a_b08 f4_10_6a_b09 f4_10_6a_b10 f4_10_6a_b11 ///
f4_10_6a_b12 f4_10_6a_b13 f4_10_6a_b14 f4_10_6a_b15 f4_10_6a_b16 f4_10_6a_b17 ///
f4_10_6a_b18 f4_10_6a_b19

tab f4_10_6a_b01
tab f4_10_6a_b02
tab f4_10_6a_b03
tab f4_10_6a_b04
tab f4_10_6a_b05
tab f4_10_6a_b06
tab f4_10_6a_b07
tab f4_10_6a_b08
tab f4_10_6a_b09
tab f4_10_6a_b10
tab f4_10_6a_b11
tab f4_10_6a_b12
tab f4_10_6a_b13
tab f4_10_6a_b14
tab f4_10_6a_b15
tab f4_10_6a_b16
tab f4_10_6a_b17
tab f4_10_6a_b18
tab f4_10_6a_b19

*technology/banking/advertisement/licences
mdesc f4_10_6a_c01 f4_10_6a_c02 f4_10_6a_c03 f4_10_6a_c04 f4_10_6a_c05 ///
f4_10_6a_c06 f4_10_6a_c07 f4_10_6a_c08 f4_10_6a_c09 f4_10_6a_c10 f4_10_6a_c11

tab f4_10_6a_c01
tab f4_10_6a_c02
tab f4_10_6a_c03
tab f4_10_6a_c04
tab f4_10_6a_c05
tab f4_10_6a_c06
tab f4_10_6a_c07
tab f4_10_6a_c08
tab f4_10_6a_c09
tab f4_10_6a_c10
tab f4_10_6a_c11

*staff/competitor/shop space
mdesc f4_10_6a_d01 f4_10_6a_d02 f4_10_6a_d03 f4_10_6a_d04 f4_10_6a_d05 ///
f4_10_6a_d06 f4_10_6a_d07 f4_10_6a_d08 f4_10_6a_d09 f4_10_6a_d10 ///
f4_10_6a_d11 f4_10_6a_d12

tab f4_10_6a_d01
tab f4_10_6a_d02
tab f4_10_6a_d03
tab f4_10_6a_d04
tab f4_10_6a_d05
tab f4_10_6a_d06
tab f4_10_6a_d07
tab f4_10_6a_d08
tab f4_10_6a_d09
tab f4_10_6a_d10
tab f4_10_6a_d11
tab f4_10_6a_d12

*have they done and plan to do business practice --> no missing obs
mdesc f4_10_6b f4_10_6c

tab f4_10_6b
tab f4_10_6c

*/

************************************************************************
***** INTERVIEWER IMPRESSIONS *******************************************

*check missing value --> no missing obs
mdesc f4_16_1a f4_16_1b f4_16_1c f4_16_1d f4_16_1e f4_16_1f f4_16_1g ///
f4_16_1h f4_16_1i f4_16_1j f4_16_1fa

tab f4_16_1a
tab f4_16_1b
tab f4_16_1c
tab f4_16_1d
tab f4_16_1e
tab f4_16_1f
tab f4_16_1g
tab f4_16_1h
tab f4_16_1i
tab f4_16_1j
tab f4_16_1fa

gen present_spouse = f4_16_1a
gen present_family = f4_16_1b
gen present_ot_adult = f4_16_1c
gen present_child_un5 = f4_16_1d
gen present_child_ab5 = f4_16_1e
gen present_employee = f4_16_1f
gen present_spv = f4_16_1g
gen present_jpal = f4_16_1h
gen present_tv = f4_16_1i
gen present_cust = f4_16_1j

_crcslbl present_spouse f4_16_1a
_crcslbl present_family f4_16_1b
_crcslbl present_ot_adult f4_16_1c
_crcslbl present_child_un5 f4_16_1d
_crcslbl present_child_ab5 f4_16_1e
_crcslbl present_employee f4_16_1f
_crcslbl present_spv f4_16_1g
_crcslbl present_jpal f4_16_1h
_crcslbl present_tv f4_16_1i
_crcslbl present_cust f4_16_1j


**interviewer observation --> missing 778 obs in f4_16_05: because only for a shop with Sign
*missing 99 obs in f4_16_02: because no customer coming during the interview
mdesc f4_16_02 f4_16_03 f4_16_03a f4_16_04 f4_16_05 f4_16_06 f4_16_07 ///
f4_16_08 f4_16_09 f4_16_10 f4_16_11 f4_16_12ot f4_16_13

tab f4_16_02
tab f4_16_03
tab f4_16_03a
tab f4_16_04
tab f4_16_05
tab f4_16_06
tab f4_16_07
tab f4_16_08
tab f4_16_09
tab f4_16_10
tab f4_16_11
tab f4_16_12ot
tab f4_16_13

gen total_cust = f4_16_02
gen resp_underst = f4_16_03
gen shop_house = f4_16_03a
gen shop_sign = f4_16_04
gen shop_sign2 = f4_16_05
gen price_clear = f4_16_06
gen goods_display = f4_16_07
gen shelves_full = f4_16_08
gen poster_sign = f4_16_09
gen shop_clean = f4_16_10
gen shop_lit = f4_16_11
gen add_comment = f4_16_12


_crcslbl total_cust f4_16_02
_crcslbl resp_underst f4_16_03
_crcslbl shop_house f4_16_03a
_crcslbl shop_sign f4_16_04
_crcslbl shop_sign2 f4_16_05
_crcslbl price_clear f4_16_06
_crcslbl goods_display f4_16_07
_crcslbl shelves_full f4_16_08
_crcslbl poster_sign f4_16_09
_crcslbl shop_clean f4_16_10
_crcslbl shop_lit f4_16_11
_crcslbl add_comment f4_16_12


/*
************************************************************************
***** SUM STATS ********************************************************

tabstat owner_male owner_age owner_educ owner_digitspan owner_digitspan_rev ///
firm_age firm_formal_tax labour_total ///
sales_lastmth sales_lastmth_log_w ///
sales_mthly_comp_all sales_mthly_comp_all_log_w ///
profit_lastmth profit_lastmth_log_w profit_lastmth_ihs_w ///
profit_mthly_comp_all profit_mthly_comp_all_ihs_w ///
practice_McKandW_perc_total practice_McKandW_perc_M ///
practice_McKandW_perc_B practice_McKandW_perc_R practice_McKandW_perc_F ///
, stat(n mean sd min max median) col(stat) long format(%8.2g) varwidth (16)

*lpoly sales_lastmth_log_w practice_McKandW_perc_total, noscatter ci degree(1) bwidth(0.05)
*lpoly sales_normday_log_w practice_McKandW_perc_total, noscatter ci degree(1) bwidth(0.05)
*lpoly profit_lastmth_log_w practice_McKandW_perc_total, noscatter ci degree(1) bwidth(0.05)
*lpoly profit_normday_log_w practice_McKandW_perc_total, noscatter ci degree(1) bwidth(0.05)

*histogram practice_McKandW_perc_total, frequency normal
tab practice_McKandW_perc_total_qs

* Need to think about excluding 3 obs with McKandW perc score >.76

cor practice_McKandW_perc_M practice_McKandW_perc_B practice_McKandW_perc_R practice_McKandW_perc_F ///
firm_open_abovemd ///
firm_formal_reg sales_normday_top3 prods_dispose firm_stockout_wklyall ///
firm_stockup_fixall firm_stockup_lateany firm_stockup_wklyall firm_stockup_dailyall ///
practice_rec_suppl practice_rec_brands practice_rec_prods practice_rec_sales ///
practice_rec_assets practice_rec_stock practice_rec_accpay_suppl ///
practice_rec_accpay_loan practice_rec_costs practice_rec_accrec_cus ///
practice_rec_accrec_fam practice_rec_ledger practice_rec_receipts practice_rec_twicewkly ///
practice_profit_nocosts practice_profit_allcosts practice_profit_any_daily ///
practice_inv_demand practice_inv_space practice_inv_profit practice_inv_supplprice /// 
practice_price_comp practice_price_demand practice_price_discount ///
practice_credit_trade practice_credit_trade_int owner_loan_apply /*owner_loan_obtain*/ ///
/*owner_finlit_compscore*/ practice_sales_comp practice_prods_new5 /// 
practice_disc_sales practice_disc_sellprice practice_disc_bestsell ///
practice_disc_finance practice_disc_buyprice practice_disc_newprod ///
practice_disc_practice practice_disc_plan ///
practice_decide_sales practice_decide_sellprice practice_decide_bestsell ///
practice_decide_finance practice_decide_buyprice practice_decide_newprod ///
practice_decide_practice practice_decide_plan ///
practice_decide_agreed finances_separate

* Answer distribution of vars --> 24, 24, 21, 14, 22, 11, 2%
sum practice_McKandW_M1 practice_McKandW_M2 practice_McKandW_M3 ///
practice_McKandW_M4 practice_McKandW_M5 practice_McKandW_M6 practice_McKandW_M7, detail

* Answer distribution of vars --> 21, 28, 6, 2, 13, 36%
sum practice_price_comp practice_sales_comp practice_disc_newprod ///
practice_disc_suppl practice_disc_bestsell practice_price_discount, detail

* Answer distribution of vars --> 16, 55, 67%
sum practice_McKandW_B1 practice_McKandW_B2 practice_McKandW_B3, detail

* Answer distribution of vars --> 19, 16, 4, 10, 5%
sum firm_stockout_wklyall firm_stockup_lateany firm_stockup_fixall ///
firm_stockup_wklyall firm_stockup_dailyall, detail

* Answer distribution of vars --> 87, 9, 22, 38, 80, 82, 19, 21%
sum practice_McKandW_R1 practice_McKandW_R2 practice_McKandW_R3 ///
practice_McKandW_R4 practice_McKandW_R5 practice_McKandW_R6 practice_McKandW_R7 ///
practice_McKandW_R8, detail

* Answer distribution of vars --> 36, 27, 50, 35, 30, 59, 7, 10, 6, 22, 16, 52, 77, 10%
sum practice_rec_ledger practice_rec_receipts practice_rec_twicewkly ///
practice_rec_suppl practice_rec_brands practice_rec_prods practice_rec_sales ///
practice_rec_assets practice_rec_stock practice_rec_accpay_suppl ///
practice_rec_accpay_loan practice_rec_costs practice_rec_accrec_cus ///
practice_rec_accrec_fam, detail

* Answer distribution of vars --> 10, 4, 20, 41, 45%
sum practice_profit_nocosts practice_profit_allcosts practice_profit_any_daily ///
practice_inv_profit practice_inv_supplprice , detail

* Answer distribution of vars -- > 69, 34, 37, 15, 3, 3, 1, 4%
sum practice_McKandW_F1 practice_McKandW_F2 practice_McKandW_F3 ///
practice_McKandW_F4 practice_McKandW_F5 practice_McKandW_F6 practice_McKandW_F7 ///
practice_McKandW_F8, detail

* Answer distribution of vars --> 28, 16, 11, 58, 64,10, 55%
sum sales_normday_top3_abvp80 practice_prods_new5 prods_dispose ///
practice_inv_demand practice_inv_space practice_price_demand ///
sales_normday_top3_abovemd, detail

* Answer distribution of p80 vars --> 44, 16, 44, 66, 35, 33, 15, 34, 8, 52, 21, 80, 29, 57, 7, 81, 8, 34, 5%
sum topprods_rice_1 topprods_flour_1 topprods_eggs_1 topprods_noodles_1 topprods_oil_1 ///
topprods_saltsugar_1 topprods_bread_1 topprods_coffeetea_1 topprods_homecooked_1 ///
topprods_snacks_1 topprods_freshdrinks_1 topprods_softdrinks_1 topprods_sanitary_1 ///
topprods_cleaning_1 topprods_baby_1 topprods_tobacco_1 topprods_meds_1 ///
topprods_gaspetrol_1 topprods_phone_1, detail

* Answer distribution of median-split vars --> 20, 16, 20, 21, 20, 20, 15, 20, 8, 20, 20, 20, 20, 20, 7, 20, 8, 20, 5%
sum topprods_rice_abovep80 topprods_flour_abovep80 topprods_eggs_abovep80 topprods_noodles_abovep80 topprods_oil_abovep80 ///
topprods_saltsugar_abovep80 topprods_bread_abovep80 topprods_coffeetea_abovep80 topprods_homecooked_abovep80 ///
topprods_snacks_abovep80 topprods_freshdrinks_abovep80 topprods_softdrinks_abovep80 topprods_sanitary_abovep80 ///
topprods_cleaning_abovep80 topprods_baby_abovep80 topprods_tobacco_abovep80 topprods_meds_abovep80 ///
topprods_gaspetrol_abovep80 topprods_phone_abovep80, detail

* Answer distribution of vars --> 15, 20, 13, 7, 10, 12, 13%
sum practice_disc_sales practice_disc_sellprice practice_disc_bestsell ///
practice_disc_finance practice_disc_buyprice practice_disc_practice ///
practice_disc_plan, detail

* Answer distribution of vars --> 4, 12, 6, 3, 3, 4, 6., 8%
sum practice_decide_sales practice_decide_sellprice practice_decide_bestsell ///
practice_decide_finance practice_decide_buyprice practice_decide_newprod ///
practice_decide_practice practice_decide_plan, detail

* Answer distribution of vars --> 67, 6, 43%
sum practice_disc_fam practice_disc_bisfriend practice_decide_any, detail

* Answer distribution of vars --> 86, 7, 43, 16%
sum practice_credit_trade practice_credit_trade_int ///
finances_separate owner_loan_obtain_1, detail
*/



***** SAVE DATA **************************************************************

***** Save data of wave 1
saveold "Final data/data_final_practices_regs_1709.dta", replace


