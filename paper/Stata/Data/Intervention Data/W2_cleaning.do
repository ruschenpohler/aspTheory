

clear all
set more off

* cd "`c(pwd)'\"


use "Data\Intervention Data\W2_clean_data"


***** TREATMENT VARS


*** Treatment groups

* Group 1			Handbook (gains)		movie		counseling
* Group 2			Handbook (gains)		movie 
* Group 3			Handbook (gains) 					counseling																																																					  
* Group 4			Handbook (gains)

* Group 5			Handbook (losses)		movie		counseling
* Group 6			Handbook (losses)		movie
* Group 7			Handbook (losses) 					counseling
* Group 8			Handbook (losses)

* Every treatment cell consists of 130 obs (the control consists of 261 obs)
* 3 sub-groups in each group: treated, refusals, and shops that are closed or have moved to an unknown loc


* Add control group to treatgroup var
replace treatgroup = 0 if treatgroup==. 

* B for Book
gen 			B = 1 					if inlist(treatgroup, 4,8)
replace 		B = 0 					if missing(B)
label var 		B 						"Assigned Handbook"

* BM for Book and Movie
gen 			BM = 1 					if inlist(treatgroup, 2,6)
replace 		BM = 0 					if missing(BM)
label var 		BM 						"Assigned Handbook & Movie"

* BC for Book and Counseling
gen 			BC = 1 					if inlist(treatgroup, 3,7)
replace 		BC = 0 					if missing(BC)
label var 		BC 						"Assigned Handbook & Counseling"

* BMC for Book, Movie, and Counseling
gen 			BMC = 1 				if inlist(treatgroup, 1,5)
replace 		BMC = 0 				if missing(BMC)
label var 		BMC 					"Assigned All Three"

gen 			anytreat = 1 			if inlist(treatgroup, 1,2,3,4,5,6,7,8)
replace 		anytreat = 0 			if missing(anytreat)
label var 		anytreat 				"Assigned Any Treatment"

gen 			control = 1 			if inlist(treatgroup, 0)
replace 		control = 0 			if missing(control)
label var 		control 				"Assigned Pure Control"


***** TREATMENT ADOPTION VARS

* T for takeup

gen BT = (W2_book_distrib_any==1) & (B==1)
label var BT "Received Handbook"

gen BMT = (W2_mov_attend==1) & (BM==1)
label var BMT "Received Handbook & Movie"

gen BCT = ((W2_ast_2_ast==1) | (W2_ast_1_ast==1)) & (BC==1)
*replace BCT = 0.5 if W2_ast_1_ast==1 & BCT==0 & BC==1
label var BCT "Received Handbook & Counseling (At Least 1 Session)"

gen BCT2 = (W2_ast_2_ast==1) & (W2_ast_1_ast==1) & (BC==1)
*replace BCT = 0.5 if W2_ast_1_ast==1 & BCT==0 & BC==1
label var BCT "Received Handbook & Counseling (Both Session)"

gen BMCT = ((W2_ast_2_ast==1) | (W2_ast_1_ast==1)) & (W2_mov_attend==1) & (BMC==1)
label var BMCT "Received All Three (At Least 1 Session)"

gen BMCT2 = (W2_ast_2_ast==1) & (W2_ast_1_ast==1) & (W2_mov_attend==1) & (BMC==1)
label var BMCT "Received All Three (Both Sessions)"


*** Treatment dummies for invited and treated treated and invited only

* Dummy for respondent being invited to viewing (=n by default)
	gen 					mov_group = 1			if inlist(treatgroup, 1,2,5,6)
	replace 				mov_group = 0 			if missing(mov_group)
	//replace					W2_mov_group =.			if inlist(treatgroup, 3,4,7,8)
	label var 				mov_group				"Shop assigned to film treatment"

* Dummy for EITHER respondent OR business partner attending the viewing
	gen 					mov_attend_any = 1		if W2_mov_attend==1
	replace					mov_attend_any= 0		if missing(mov_attend_any)
	label var				mov_attend_any			"Anyone in shop attended film screening"

* Dummy for RESPONDENT attending the viewing
	gen 					mov_attend_resp = 1		if W2_mov_name==1									
	replace					mov_attend_resp= 0		if missing(mov_attend_resp)
	label var				mov_attend_resp			"Baseline respondent attended film screening"
	
* Dummy for BUSINESS PARTNER ATTENDING the viewing (n = 22)
	gen						mov_attend_bispart = 1		if W2_mov_bispart==1					
	replace					mov_attend_bispart = 0		if missing(mov_attend_bispart)
	label var				mov_attend_bispart			"Business partner/spouse attended film screening"


*dummy for counseling
	gen					W2_ast_group=1						if inlist(treatgroup, 1,3,5,7)
	replace				W2_ast_group=0						if missing(W2_ast_group)
	order				W2_ast_group,						a(W2_mov_facnote_3)
	label var			W2_ast_group						"Shop assigned to counseling treatment"

*dummy for receiving counseling1 
	gen 				ast_1_accept_any=1				if W2_ast_1_ast==1
	replace				ast_1_accept_any=0				if missing(ast_1_accept)
	order				ast_1_accept_any,				a(W2_ast_group)
	label var			ast_1_accept_any				"Anyone in shop received 1st counseling session"
	
*dummy for var respondent treated
	gen					ast_1_accept_resp=1				if W2_ast_1_name==1
	replace				ast_1_accept_resp=0				if missing(ast_1_accept_resp)
	order				ast_1_accept_resp,				a(ast_1_accept_any)
	label var			ast_1_accept_resp				"Baseline respondent received 1st counseling session"
	
*dummy for var partner treated
	gen					ast_1_accept_bispart=1			if W2_ast_1_bispart==1
	replace				ast_1_accept_bispart=0			if missing(ast_1_accept_bispart)
	order				ast_1_accept_bispart,			a(ast_1_accept_resp)
	label var			ast_1_accept_bispart			"Business partner/spouse received 1st counseling session"

*dummy for receiving the counseling2 
	gen					ast_2_accept_any=1				if W2_ast_2_ast==1
	replace				ast_2_accept_any=0				if missing(ast_2_accept_any)
	order				ast_2_accept_any,				a(W2_ast_1_facnote_2)
	label var 			ast_2_accept_any				"Anyone in the shop received 2nd counseling session"	
	
*dummy for var respondent treated2
	gen					ast_2_accept_resp=1				if W2_ast_2_name==1
	replace				ast_2_accept_resp=0				if missing(ast_2_accept_resp)
	order				ast_2_accept_resp,				a(W2_ast_2_phone_match)
	label var			ast_2_accept_resp				"Baseline respondent received 2nd counseling session"
	
*dummy for var partner treated2
	gen					ast_2_accept_bispart=1			if W2_ast_2_bispart==1
	replace				ast_2_accept_bispart=0			if missing(ast_2_accept_bispart)
	order				ast_2_accept_bispart,			a(ast_2_accept_resp)
	label var			ast_2_accept_bispart			"Business partner/spouse received 2nd counseling session"

***** Movie feedback

gen mov_eval_real 			= W2_mov_eval_real
replace	mov_eval_real		=. if mov_eval_real > 4			// 5 obs 
_crcslbl mov_eval_real W2_mov_eval_real
drop W2_mov_eval_real

gen mov_eval_comprehend 	= W2_mov_eval_comprehend 
replace	mov_eval_comprehend	=. if mov_eval_comprehend > 4	// 0 obs
_crcslbl mov_eval_comprehend W2_mov_eval_comprehend
drop W2_mov_eval_comprehend

gen mov_eval_bored 			= W2_mov_eval_bored 
replace	mov_eval_bored		=. if mov_eval_bored > 4		// 1 obs
_crcslbl mov_eval_bored W2_mov_eval_bored
drop W2_mov_eval_bored

gen mov_eval_inspire 		= W2_mov_eval_inspire 
replace	mov_eval_inspire	=. if mov_eval_inspire > 4		// 0 obs
_crcslbl mov_eval_inspire W2_mov_eval_inspire
drop W2_mov_eval_inspire

gen mov_eval_hope 			= W2_mov_eval_hope 
replace	mov_eval_hope		=. if mov_eval_hope > 4		// 5 obs
_crcslbl mov_eval_hope W2_mov_eval_hope
drop W2_mov_eval_hope

gen mov_eval_connect 		= W2_mov_eval_connect
replace	mov_eval_connect	=. if mov_eval_connect > 4		// 3 obs
_crcslbl mov_eval_connect W2_mov_eval_connect
drop W2_mov_eval_connect

***** Counseling feedback

gen ast_2_eval_motiv 			= W2_ast_2_eval_motiv
replace	ast_2_eval_motiv		=. if ast_2_eval_motiv > 4		// 8 obs
_crcslbl ast_2_eval_motiv W2_ast_2_eval_motiv
drop W2_ast_2_eval_motiv

gen ast_2_eval_comprehend 		= W2_ast_2_eval_comprehend 
replace	ast_2_eval_comprehend	=. if ast_2_eval_comprehend > 4	// 6 obs
_crcslbl ast_2_eval_comprehend W2_ast_2_eval_comprehend
drop W2_ast_2_eval_comprehend

gen ast_2_eval_bored 			= W2_ast_2_eval_bored 			
replace	ast_2_eval_bored		=. if ast_2_eval_bored > 4		// 7 obs
_crcslbl ast_2_eval_bored W2_ast_2_eval_bored
drop W2_ast_2_eval_bored

gen ast_2_eval_inspire 			= W2_ast_2_eval_inspire 		// 7 obs
replace	ast_2_eval_inspire		=. if ast_2_eval_inspire > 4
_crcslbl ast_2_eval_inspire W2_ast_2_eval_inspire
drop W2_ast_2_eval_inspire

gen ast_2_eval_hope 			= W2_ast_2_eval_hope 
replace	ast_2_eval_hope			=. if ast_2_eval_hope > 4		// 8 obs
_crcslbl ast_2_eval_hope W2_ast_2_eval_hope
drop W2_ast_2_eval_hope

gen ast_2_eval_connect 			= W2_ast_2_eval_connect			// 6 obs
replace	ast_2_eval_connect		=. if ast_2_eval_connect > 4
_crcslbl ast_2_eval_connect 	W2_ast_2_eval_connect
drop W2_ast_2_eval_connect


***** SAVE FINAL ANALYSIS DATA **************************************************************

***** Save file
save "Data\Intervention Data\W2_clean_data_mod.dta", replace

