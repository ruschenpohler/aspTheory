********************************************************************************
********************************************************************************
******** BUSINESS-PRACTICE REGS FOR RETAILERS STUDY IN INDONESIA, 2016 *********
* v1.07
* Packages used: 	"estout" for regs

* Run latest datamanagement_smallretailers do-fiel before running 
* the sum stats and regs
********************************************************************************



clear
set more off
set scrollbufsize 600000

use "C:\Users\jruschen\Dropbox\Indonesia\Info-Nudge\Data\Baseline\Final data\data_final_W1_noprefix_0831", clear



************************************************************************
***** SUM STATS ********************************************************

tabstat male age_manager educ digitspan digitspan_rev ///
age_firm formal_tax labour_total ///
sales_lastmth sales_lastmth_win1_ln ///
sales_mth_comp_all sales_mth_comp_all_win1_ln ///
prof_lastmth prof_lastmth_win1_ihs prof_lastmth_win1_ihs ///
prof_mth_comp_all prof_mth_comp_all_win1_ihs ///
MW_percscore_total MW_M_percscore_total ///
MW_B_percscore_total MW_R_percscore_total MW_F_percscore_total ///
, stat(n mean sd min max median) col(stat) long format(%8.2g) varwidth (16)

*lpoly sales_lastmth_win1_ln MW_percscore_total, noscatter ci degree(1) bwidth(0.05)
*lpoly sales_normday_win1_ln MW_percscore_total, noscatter ci degree(1) bwidth(0.05)
*lpoly prof_lastmth_win1_ihs MW_percscore_total, noscatter ci degree(1) bwidth(0.05)
*lpoly prof_normday_win1_ihs MW_percscore_total, noscatter ci degree(1) bwidth(0.05)

*histogram MW_percscore_total, frequency normal
tab MW_percscore_total_qtile

cor MW_M_percscore_total MW_B_percscore_total MW_R_percscore_total MW_F_percscore_total ///
open_abvmd ///
formal_reg sales_normday_top3share dispose_wk stockup_top3_wk ///
stockup_top3_fix stockup_top3_late_any stockup_top3_wk stockup_top3_day ///
rec_pricesuppliers rec_pricebrands rec_stockup rec_sales ///
rec_assetpurch rec_stocks rec_accpaysupplier ///
rec_accpayloan rec_othercosts rec_accreccustom ///
rec_accrecfam rec_ledger rec_receipts rec_twicewk ///
profcalc_nocosts profcalc_allcosts profcalc_any_day ///
inventory_change_demand inventory_change_space inventory_change_prof inventory_change_price /// 
price_change_comp price_change_demand discount ///
credit_TC credit_TC_int loans_applied /*loans_obtained*/ ///
/*finlit_score*/ compsales_compet prods_new_5 /// 
discuss_sales discuss_sellprice discuss_bestseller ///
discuss_finance discuss_buyprice discuss_newprod ///
discuss_practice discuss_bisplan ///
jointdec_sales jointdec_sellprice jointdec_bestseller ///
jointdec_finance jointdec_buyprice jointdec_newprod ///
jointdec_practice jointdec_bisplan ///
jointdec_agree separatefin

* Answer distribution of vars --> 24, 24, 21, 14, 22, 11, 2%
sum MWM1_visitcompetprice MWM2_visitcompetprod MWM3_askcustomprod ///
MWM4_askcustomquit MWM5_asksupplprod MWM6_attrcustomdisc MWM7_advert, detail

* Answer distribution of vars --> 21, 28, 6, 2, 13, 36%
sum price_change_comp compsales_compet discuss_newprod ///
discuss_supplier discuss_bestseller discount, detail

* Answer distribution of vars --> 16, 55, 67%
sum MWB1_negosupplprice MWB2_compsupplprod MWB3_notOOS, detail

* Answer distribution of vars --> 19, 16, 4, 10, 5%
sum stockup_top3_wk stockup_top3_late_any stockup_top3_fix ///
stockup_top3_wk stockup_top3_day, detail

* Answer distribution of vars --> 87, 9, 22, 38, 80, 82, 19, 21%
sum MWR1_recwritten MWR2_recpurchsale MWR3_recliquid ///
MWR4_recsalesprods MWR5_costprods MWR6_profprods MWR7_recexpensemth ///
MWR8_recloan, detail

* Answer distribution of vars --> 36, 27, 50, 35, 30, 59, 7, 10, 6, 22, 16, 52, 77, 10%
sum rec_ledger rec_receipts rec_twicewk ///
rec_pricesuppliers rec_pricebrands rec_stockup rec_sales ///
rec_assetpurch rec_stocks rec_accpaysupplier ///
rec_accpayloan rec_othercosts rec_accreccustom ///
rec_accrecfam, detail

* Answer distribution of vars --> 10, 4, 20, 41, 45%
sum profcalc_nocosts profcalc_allcosts profcalc_any_day ///
inventory_change_prof inventory_change_price , detail

* Answer distribution of vars -- > 69, 34, 37, 15, 3, 3, 1, 4%
sum MWF1_finperform MWF2_settargetyr MWF3_comptargetmth ///
MWF4_expensenextyr MWF5_proflossyr MWF6_cashflowyr MWF7_balancey ///
MWF8_incexpenseyr, detail

* Answer distribution of vars --> 28, 16, 11, 58, 64,10, 55%
sum sales_normday_top3share_abv80 prods_new_5 dispose_wk ///
inventory_change_demand inventory_change_space price_change_demand ///
sales_normday_top3share_abvmd, detail

/*
* Answer distribution of p80 vars --> 44, 16, 44, 66, 35, 33, 15, 34, 8, 52, 21, 80, 29, 57, 7, 81, 8, 34, 5%
sum topprods_rice_1 topprods_flour_1 topprods_eggs_1 topprods_noodles_1 topprods_oil_1 ///
topprods_saltsugar_1 topprods_bread_1 topprods_coffeetea_1 topprods_homecooked_1 ///
topprods_snacks_1 topprods_freshdrinks_1 topprods_softdrinks_1 topprods_sanitary_1 ///
topprods_cleaning_1 topprods_baby_1 topprods_tobacco_1 topprods_meds_1 ///
topprods_gaspetrol_1 topprods_phone_1, detail

* Answer distribution of median-split vars --> 20, 16, 20, 21, 20, 20, 15, 20, 8, 20, 20, 20, 20, 20, 7, 20, 8, 20, 5%
sum topprods_rice_abv80 topprods_flour_abv80 topprods_eggs_abv80 topprods_noodles_abv80 topprods_oil_abv80 ///
topprods_saltsugar_abv80 topprods_bread_abv80 topprods_coffeetea_abv80 topprods_homecooked_abv80 ///
topprods_snacks_abv80 topprods_freshdrinks_abv80 topprods_softdrinks_abv80 topprods_sanitary_abv80 ///
topprods_cleaning_abv80 topprods_baby_abv80 topprods_tobacco_abv80 topprods_meds_abv80 ///
topprods_gaspetrol_abv80 topprods_phone_abv80, detail
*/

* Answer distribution of vars --> 15, 20, 13, 7, 10, 12, 13%
sum discuss_sales discuss_sellprice discuss_bestseller ///
discuss_finance discuss_buyprice discuss_practice ///
discuss_bisplan, detail

* Answer distribution of vars --> 4, 12, 6, 3, 3, 4, 6., 8%
sum jointdec_sales jointdec_sellprice jointdec_bestseller ///
jointdec_finance jointdec_buyprice jointdec_newprod ///
jointdec_practice jointdec_bisplan, detail

* Answer distribution of vars --> 67, 6, 43%
sum discuss_fam discuss_bisfriend jointdec_any, detail

* Answer distribution of vars --> 86, 7, 43, 16%
sum credit_TC credit_TC_int ///
separatefin loan_obtained, detail



************************************************************************
***** MCK AND W REGS *****************************************************

***** SALES AND PROFITS, COMP SCORE (calc and self-rep vars)

*** Total perc score (control for labour, firm size)

* Sig and pos
reg sales_mth_comp_all_win1_ln MW_percscore_total ///
labour_total space_cont, vce(robust)
estimates store tot_Scompall

* Sig and pos
reg prof_mth_comp_all_win1_ihs MW_percscore_total ///
labour_total space_cont, vce(robust)
estimates store tot_Pcompall


*** Sub-scores (control for labour, firm size)

* M sig and neg, B, R, F sig and pos
reg sales_mth_comp_all_win1_ln MW_M_percscore_total MW_B_percscore_total ///
MW_R_percscore_total MW_F_percscore_total ///
labour_total space_cont, vce(robust)
estimates store sub_Scompall

* R sig and pos
reg prof_mth_comp_all_win1_ihs MW_M_percscore_total MW_B_percscore_total ///
MW_R_percscore_total MW_F_percscore_total ///
labour_total space_cont, vce(robust)
estimates store sub_Pcompall


*** Single practices (control for labour, firm size)

* M2, M5 sig and neg, M4, B2, R1, R2, R5, R8, F4 sig and pos
reg sales_mth_comp_all_win1_ln i.MWM1_visitcompetprice i.MWM2_visitcompetprod ///
i.MWM3_askcustomprod i.MWM4_askcustomquit i.MWM5_asksupplprod i.MWM6_attrcustomdisc ///
i.MWM7_advert i.MWB1_negosupplprice i.MWB2_compsupplprod i.MWB3_notOOS ///
i.MWR1_recwritten i.MWR2_recpurchsale i.MWR3_recliquid i.MWR4_recsalesprods ///
i.MWR5_costprods i.MWR6_profprods i.MWR7_recexpensemth i.MWR8_recloan ///
i.MWF1_finperform i.MWF2_settargetyr i.MWF3_comptargetmth i.MWF4_expensenextyr ///
i.MWF5_proflossyr i.MWF6_cashflowyr i.MWF7_balancey i.MWF8_incexpenseyr ///
labour_total c.space_cont, vce(robust)
estimates store sin_Scompall

* M2 sig and neg, R6 sig and pos
reg prof_mth_comp_all_win1_ihs i.MWM1_visitcompetprice i.MWM2_visitcompetprod ///
i.MWM3_askcustomprod i.MWM4_askcustomquit i.MWM5_asksupplprod i.MWM6_attrcustomdisc ///
i.MWM7_advert i.MWB1_negosupplprice i.MWB2_compsupplprod i.MWB3_notOOS ///
i.MWR1_recwritten i.MWR2_recpurchsale i.MWR3_recliquid i.MWR4_recsalesprods ///
i.MWR5_costprods i.MWR6_profprods i.MWR7_recexpensemth i.MWR8_recloan ///
i.MWF1_finperform i.MWF2_settargetyr i.MWF3_comptargetmth i.MWF4_expensenextyr ///
i.MWF5_proflossyr i.MWF6_cashflowyr i.MWF7_balancey i.MWF8_incexpenseyr ///
labour_total c.space_cont, vce(robust)
estimates store sin_Pcompall


***** COMP SCORES, SALES AND PROFITS (only self-rep vars)

*** Total perc score (control for labour, firm size)

* Sig and pos
reg sales_mth_comp_rep_win1_ln MW_percscore_total ///
labour_total space_cont, vce(robust)
estimates store tot_Scomprep

* Sig and pos
reg prof_mth_comp_rep_win1_ihs MW_percscore_total ///
labour_total space_cont, vce(robust)
estimates store tot_Pcomprep


*** Sub-scores (control for labour, firm size)

* M sig and neg, B, R, F sig and pos
reg sales_mth_comp_rep_win1_ln MW_M_percscore_total MW_B_percscore_total ///
MW_R_percscore_total MW_F_percscore_total ///
labour_total space_cont, vce(robust)
estimates store sub_Scomprep

* M sig and neg, B, R, F sig and pos
reg prof_mth_comp_rep_win1_ihs MW_M_percscore_total MW_B_percscore_total ///
MW_R_percscore_total MW_F_percscore_total ///
labour_total space_cont, vce(robust)
estimates store sub_Pcomprep


*** Single practices (control for labour, firm size)

* M1, M2, M5 sig and neg, M4, B2, R1, R5, R8, F4 sig and pos
reg sales_mth_comp_rep_win1_ln i.MWM1_visitcompetprice i.MWM2_visitcompetprod ///
i.MWM3_askcustomprod i.MWM4_askcustomquit i.MWM5_asksupplprod i.MWM6_attrcustomdisc ///
i.MWM7_advert i.MWB1_negosupplprice i.MWB2_compsupplprod i.MWB3_notOOS ///
i.MWR1_recwritten i.MWR2_recpurchsale i.MWR3_recliquid i.MWR4_recsalesprods ///
i.MWR5_costprods i.MWR6_profprods i.MWR7_recexpensemth i.MWR8_recloan ///
i.MWF1_finperform i.MWF2_settargetyr i.MWF3_comptargetmth i.MWF4_expensenextyr ///
i.MWF5_proflossyr i.MWF6_cashflowyr i.MWF7_balancey i.MWF8_incexpenseyr ///
labour_total c.space_cont, vce(robust)
estimates store sin_Scomprep

* M1 sig and neg, M4, R1, R5, R8, F3, F4 sig and pos
reg prof_mth_comp_rep_win1_ihs i.MWM1_visitcompetprice i.MWM2_visitcompetprod ///
i.MWM3_askcustomprod i.MWM4_askcustomquit i.MWM5_asksupplprod i.MWM6_attrcustomdisc ///
i.MWM7_advert i.MWB1_negosupplprice i.MWB2_compsupplprod i.MWB3_notOOS ///
i.MWR1_recwritten i.MWR2_recpurchsale i.MWR3_recliquid i.MWR4_recsalesprods ///
i.MWR5_costprods i.MWR6_profprods i.MWR7_recexpensemth i.MWR8_recloan ///
i.MWF1_finperform i.MWF2_settargetyr i.MWF3_comptargetmth i.MWF4_expensenextyr ///
i.MWF5_proflossyr i.MWF6_cashflowyr i.MWF7_balancey i.MWF8_incexpenseyr ///
labour_total c.space_cont, vce(robust)
estimates store sin_Pcomprep



***** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

*** Total perc score (control for labour, firm size)

* Sig and pos
reg sales_normday_win1_ln MW_percscore_total ///
labour_total space_cont, vce(robust)
estimates store tot_Sday

* Sig and pos
reg prof_normday_win1_ihs MW_percscore_total ///
labour_total space_cont, vce(robust)
estimates store tot_Pday


*** Sub-scores (control for labour, firm size)

* M sig and neg, B, R, F sig and pos
reg sales_normday_win1_ln MW_M_percscore_total MW_B_percscore_total ///
MW_R_percscore_total MW_F_percscore_total ///
labour_total space_cont, vce(robust)
estimates store sub_Sday

* B, R, F sig and pos
reg prof_normday_win1_ihs MW_M_percscore_total MW_B_percscore_total ///
MW_R_percscore_total MW_F_percscore_total ///
labour_total space_cont, vce(robust)
estimates store sub_Pday


*** Single practices (control for labour, firm size)

* M1, M5 sig and neg, M4, B2, R1, R5, R8, F4 sig and pos
reg sales_normday_win1_ln i.MWM1_visitcompetprice i.MWM2_visitcompetprod ///
i.MWM3_askcustomprod i.MWM4_askcustomquit i.MWM5_asksupplprod i.MWM6_attrcustomdisc ///
i.MWM7_advert i.MWB1_negosupplprice i.MWB2_compsupplprod i.MWB3_notOOS ///
i.MWR1_recwritten i.MWR2_recpurchsale i.MWR3_recliquid i.MWR4_recsalesprods ///
i.MWR5_costprods i.MWR6_profprods i.MWR7_recexpensemth i.MWR8_recloan ///
i.MWF1_finperform i.MWF2_settargetyr i.MWF3_comptargetmth i.MWF4_expensenextyr ///
i.MWF5_proflossyr i.MWF6_cashflowyr i.MWF7_balancey i.MWF8_incexpenseyr ///
labour_total c.space_cont, vce(robust)
estimates store sin_Sday

* M1 sig and neg, R1, R8, F3, F4 sig and pos
reg prof_normday_win1_ihs i.MWM1_visitcompetprice i.MWM2_visitcompetprod ///
i.MWM3_askcustomprod i.MWM4_askcustomquit i.MWM5_asksupplprod i.MWM6_attrcustomdisc ///
i.MWM7_advert i.MWB1_negosupplprice i.MWB2_compsupplprod i.MWB3_notOOS ///
i.MWR1_recwritten i.MWR2_recpurchsale i.MWR3_recliquid i.MWR4_recsalesprods ///
i.MWR5_costprods i.MWR6_profprods i.MWR7_recexpensemth i.MWR8_recloan ///
i.MWF1_finperform i.MWF2_settargetyr i.MWF3_comptargetmth i.MWF4_expensenextyr ///
i.MWF5_proflossyr i.MWF6_cashflowyr i.MWF7_balancey i.MWF8_incexpenseyr ///
labour_total c.space_cont, vce(robust)
estimates store sin_Pday

/*
***** LAB PRODUCTIVITY

*** Total perc score (control for labour, firm size)

* Sig and pos
reg productiv_labour MW_percscore_total ///
labour_total space_cont, vce(robust)
estimates store tot_prodlab


*** Sub-scores (control for labour, firm size)

* M sig and neg, R sig and pos
reg productiv_labour MW_M_percscore_total MW_B_percscore_total ///
MW_R_percscore_total MW_F_percscore_total ///
labour_total space_cont, vce(robust)
estimates store sub_prodlab


*** Single practices (control for labour, firm size)

* B2, R5, R8 sig and pos
reg productiv_labour i.MWM1_visitcompetprice i.MWM2_visitcompetprod ///
i.MWM3_askcustomprod i.MWM4_askcustomquit i.MWM5_asksupplprod i.MWM6_attrcustomdisc ///
i.MWM7_advert i.MWB1_negosupplprice i.MWB2_compsupplprod i.MWB3_notOOS ///
i.MWR1_recwritten i.MWR2_recpurchsale i.MWR3_recliquid i.MWR4_recsalesprods ///
i.MWR5_costprods i.MWR6_profprods i.MWR7_recexpensemth i.MWR8_recloan ///
i.MWF1_finperform i.MWF2_settargetyr i.MWF3_comptargetmth i.MWF4_expensenextyr ///
i.MWF5_proflossyr i.MWF6_cashflowyr i.MWF7_balancey i.MWF8_incexpenseyr ///
labour_total c.space_cont, vce(robust)
estimates store sin_prodlab
*/

***** CUSTOMERS

*** Total perc score (control for labour, firm size)

* Sig and pos
reg custom_total MW_percscore_total ///
labour_total space_cont, vce(robust)
estimates store tot_custot

* Sig and pos
reg custom_loyal MW_percscore_total ///
labour_total space_cont, vce(robust)
estimates store tot_cusloy


*** Sub-scores (control for labour, firm size)

* R and F sig and pos
reg custom_total MW_M_percscore_total MW_B_percscore_total ///
MW_R_percscore_total MW_F_percscore_total ///
labour_total space_cont, vce(robust)
estimates store sub_custot

* None sig
reg custom_loyal MW_M_percscore_total MW_B_percscore_total ///
MW_R_percscore_total MW_F_percscore_total ///
labour_total space_cont, vce(robust)
estimates store sub_cusloy


*** Single practices (control for labour, firm size)

* M6, B2, R8, F4 sig and pos
reg custom_total i.MWM1_visitcompetprice i.MWM2_visitcompetprod ///
i.MWM3_askcustomprod i.MWM4_askcustomquit i.MWM5_asksupplprod i.MWM6_attrcustomdisc ///
i.MWM7_advert i.MWB1_negosupplprice i.MWB2_compsupplprod i.MWB3_notOOS ///
i.MWR1_recwritten i.MWR2_recpurchsale i.MWR3_recliquid i.MWR4_recsalesprods ///
i.MWR5_costprods i.MWR6_profprods i.MWR7_recexpensemth i.MWR8_recloan ///
i.MWF1_finperform i.MWF2_settargetyr i.MWF3_comptargetmth i.MWF4_expensenextyr ///
i.MWF5_proflossyr i.MWF6_cashflowyr i.MWF7_balancey i.MWF8_incexpenseyr ///
labour_total c.space_cont, vce(robust)
estimates store sin_custot

* M1 sig and neg
reg custom_loyal i.MWM1_visitcompetprice i.MWM2_visitcompetprod ///
i.MWM3_askcustomprod i.MWM4_askcustomquit i.MWM5_asksupplprod i.MWM6_attrcustomdisc ///
i.MWM7_advert i.MWB1_negosupplprice i.MWB2_compsupplprod i.MWB3_notOOS ///
i.MWR1_recwritten i.MWR2_recpurchsale i.MWR3_recliquid i.MWR4_recsalesprods ///
i.MWR5_costprods i.MWR6_profprods i.MWR7_recexpensemth i.MWR8_recloan ///
i.MWF1_finperform i.MWF2_settargetyr i.MWF3_comptargetmth i.MWF4_expensenextyr ///
i.MWF5_proflossyr i.MWF6_cashflowyr i.MWF7_balancey i.MWF8_incexpenseyr ///
labour_total c.space_cont, vce(robust)
estimates store sin_cusloy


***** TABLES

*** Sales and profits comp scores
estimates table tot_Scompall tot_Pcompall tot_Scomprep tot_Pcomprep, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse) 
estimates table sub_Scompall sub_Pcompall sub_Scomprep sub_Pcomprep, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse) 
estimates table sin_Scompall sin_Pcompall sin_Scomprep sin_Pcomprep, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse)


*** Sales snd profits on a norm day
estimates table tot_Sday tot_Pday, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse) 
estimates table sub_Sday sub_Pday, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse) 
estimates table sin_Sday sin_Pday, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse)


*** Lab prod, customers (total and loyal)
estimates table /*tot_prodlab*/ tot_custot tot_cusloy, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse) 
estimates table /*sub_prodlab*/ sub_custot sub_cusloy, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse) 
estimates table /*sin_prodlab */ sin_custot sin_cusloy, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse)



************************************************************************
***** "OTHER PRACTICES" REGS ************************************************


***** FIRM CHARS (assets, opening time, formality), PRODUCTS, STOCK-UP/-OUTS AND DISPOSAL

*** Sales and profits, comp scores (self-rep and calc for sales, only self-rep for profits)

*
reg sales_mth_comp_all_win1_ln i.scooter i.car i.open_net_abvmd i.open_net_abv80 ///
i.formal_reg sales_normday_top3share i.dispose_wk i.stockup_top3_wk ///
i.stockup_top3_fix i.stockup_top3_late_any i.stockup_top3_wk i.stockup_top3_day ///
labour_total space_cont, vce(robust)
estimates store char_Scompall

*
reg prof_mth_comp_rep_win1_ihs i.scooter i.car i.open_net_abvmd i.open_net_abv80 ///
i.formal_reg sales_normday_top3share i.dispose_wk i.stockup_top3_wk ///
i.stockup_top3_fix i.stockup_top3_late_any i.stockup_top3_wk i.stockup_top3_day ///
labour_total space_cont, vce(robust)
estimates store char_Pcomprep


*** Labour prod

/*
reg productiv_labour i.scooter i.car i.open_net_abvmd i.open_net_abv80 ///
i.formal_reg sales_normday_top3share i.dispose_wk i.stockup_top3_wk ///
i.stockup_top3_fix i.stockup_top3_late_any i.stockup_top3_wk i.stockup_top3_day ///
labour_total space_cont, vce(robust)
estimates store char_prodlab
*/

*** Customers

*
reg custom_total i.scooter i.car i.open_net_abvmd i.open_net_abv80 ///
i.formal_reg c.sales_normday_top3share i.dispose_wk i.stockup_top3_wk ///
i.stockup_top3_fix i.stockup_top3_late_any i.stockup_top3_wk i.stockup_top3_day ///
labour_total space_cont, vce(robust)
estimates store char_custot

*
reg custom_loyal i.scooter i.car i.open_net_abvmd i.open_net_abv80 ///
i.formal_reg sales_normday_top3share i.dispose_wk i.stockup_top3_wk ///
i.stockup_top3_fix i.stockup_top3_late_any i.stockup_top3_wk i.stockup_top3_day ///
labour_total space_cont, vce(robust)
estimates store char_cusloy


*** Tables

* Sales and profits comp scores
estimates table char_Scompall char_Pcomprep, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse) 

* Lab prod, customers (total and loyal)
estimates table /*char_prodlab*/ char_custot char_cusloy, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse)



***** RECORD-KEEPING AND PROFIT CALC

*** Sales and profits, comp scores (self-rep and calc for sales, only self-rep for profits)

*
reg sales_mth_comp_all_win1_ln i.rec_pricesuppliers i.rec_pricebrands ///
i.rec_stockup i.rec_sales i.rec_assetpurch ///
i.rec_stocks i.rec_accpaysupplier i.rec_accpayloan ///
i.rec_othercosts i.rec_accreccustom i.rec_accrecfam ///
i.rec_ledger i.rec_receipts i.rec_twicewk ///
i.profcalc_nocosts i.profcalc_allcosts i.profcalc_any_day ///
labour_total space_cont, vce(robust)
estimates store rec_Scompall


*
reg prof_mth_comp_rep_win1_ihs i.rec_pricesuppliers i.rec_pricebrands ///
i.rec_stockup i.rec_sales i.rec_assetpurch ///
i.rec_stocks i.rec_accpaysupplier i.rec_accpayloan ///
i.rec_othercosts i.rec_accreccustom i.rec_accrecfam ///
i.rec_ledger i.rec_receipts i.rec_twicewk ///
i.profcalc_nocosts i.profcalc_allcosts i.profcalc_any_day ///
labour_total space_cont, vce(robust)
estimates store rec_Pcomprep


*** Labour prod

/*
reg productiv_labour rec_pricesuppliers i.rec_pricesuppliers i.rec_pricebrands ///
i.rec_stockup i.rec_sales i.rec_assetpurch ///
i.rec_stocks i.rec_accpaysupplier i.rec_accpayloan ///
i.rec_othercosts i.rec_accreccustom i.rec_accrecfam ///
i.rec_ledger i.rec_receipts i.rec_twicewk ///
i.profcalc_nocosts i.profcalc_allcosts i.profcalc_any_day ///
labour_total space_cont, vce(robust)
estimates store rec_prodlab

*
reg productiv_labour rec_pricesuppliers i.rec_pricesuppliers i.rec_pricebrands ///
i.rec_stockup i.rec_sales i.rec_assetpurch ///
i.rec_stocks i.rec_accpaysupplier i.rec_accpayloan ///
i.rec_othercosts i.rec_accreccustom i.rec_accrecfam ///
i.rec_ledger i.rec_receipts i.rec_twicewk ///
i.profcalc_nocosts i.profcalc_allcosts i.profcalc_any_day ///
labour_total space_cont, vce(robust)
estimates store rec_prodlab
*/

*** Customers

*
reg custom_total i.rec_pricesuppliers i.rec_pricebrands ///
i.rec_stockup i.rec_sales i.rec_assetpurch ///
i.rec_stocks i.rec_accpaysupplier i.rec_accpayloan ///
i.rec_othercosts i.rec_accreccustom i.rec_accrecfam ///
i.rec_ledger i.rec_receipts i.rec_twicewk ///
i.profcalc_nocosts i.profcalc_allcosts i.profcalc_any_day ///
labour_total space_cont, vce(robust)
estimates store rec_custot

*
reg custom_loyal i.rec_pricesuppliers i.rec_pricebrands ///
i.rec_stockup i.rec_sales i.rec_assetpurch ///
i.rec_stocks i.rec_accpaysupplier i.rec_accpayloan ///
i.rec_othercosts i.rec_accreccustom i.rec_accrecfam ///
i.rec_ledger i.rec_receipts i.rec_twicewk ///
i.profcalc_nocosts i.profcalc_allcosts i.profcalc_any_day ///
labour_total space_cont, vce(robust)
estimates store rec_cusloy


*** Tables

* Sales and profits comp scores
estimates table rec_Scompall rec_Pcomprep, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse) 

* Lab prod, customers (total and loyal)
estimates table /*rec_prodlab*/ rec_custot rec_cusloy, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse)



***** PRICES AND INVENTORY, CREDIT, LOAN AND LITERACY, DISCUSSION AND JOINT DECISION-MAKING

*** Sales and profits, comp scores (self-rep and calc for sales, only self-rep for profits)

*
reg sales_mth_comp_all_win1_ln i.inventory_change_demand ///
i.inventory_change_space i.inventory_change_prof i.inventory_change_price ///
i.price_change_comp i.price_change_demand i.discount ///
i.credit_TC i.credit_TC_int c.loans_applied c.loans_obtained ///
c.finlit_score i.compsales_compet i.prods_new_5 ///
i.jointdec_any i.discuss_any ///
labour_total space_cont, vce(robust)
estimates store oth_Scompall

*
reg prof_mth_comp_rep_win1_ihs i.inventory_change_demand ///
i.inventory_change_space i.inventory_change_prof i.inventory_change_price ///
i.price_change_comp i.price_change_demand i.discount ///
i.credit_TC i.credit_TC_int c.loans_applied c.loans_obtained ///
c.finlit_score i.compsales_compet i.prods_new_5 ///
i.jointdec_any i.discuss_any ///
labour_total space_cont, vce(robust)
estimates store oth_Pcomprep


*** Labour prod

/*
reg productiv_labour i.inventory_change_demand ///
i.inventory_change_space i.inventory_change_prof i.inventory_change_price ///
i.price_change_comp i.price_change_demand i.discount ///
i.credit_TC i.credit_TC_int c.loans_applied c.loans_obtained ///
c.finlit_score i.compsales_compet i.prods_new_5 ///
i.jointdec_any i.discuss_any ///
labour_total space_cont, vce(robust)
estimates store oth_prodlab
*/

*** Customers

*
reg custom_total i.inventory_change_demand ///
i.inventory_change_space i.inventory_change_prof i.inventory_change_price ///
i.price_change_comp i.price_change_demand i.discount ///
i.credit_TC i.credit_TC_int c.loans_applied c.loans_obtained ///
c.finlit_score i.compsales_compet i.prods_new_5 ///
i.jointdec_any i.discuss_any ///
labour_total space_cont, vce(robust)
estimates store oth_custot

*
reg custom_loyal i.inventory_change_demand ///
i.inventory_change_space i.inventory_change_prof i.inventory_change_price ///
i.price_change_comp i.price_change_demand i.discount ///
i.credit_TC i.credit_TC_int c.loans_applied c.loans_obtained ///
c.finlit_score i.compsales_compet i.prods_new_5 ///
i.jointdec_any i.discuss_any ///
labour_total space_cont, vce(robust)
estimates store oth_cusloy


*** Tables

* Sales and profits comp scores
estimates table oth_Scompall oth_Pcomprep, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse) 

* Lab prod, customers (total and loyal)
estimates table /*oth_prodlab*/ oth_custot oth_cusloy, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse)



************************************************************************
***** ALL COMBINED ************************************************

***** SALES AND PROFITS, COMP SCORE (calc and self-rep vars)

* 3 sig and neg, 17 sig and pos
reg sales_mth_comp_all_win1_ln i.MWM1_visitcompetprice i.MWM2_visitcompetprod ///
i.MWM3_askcustomprod i.MWM4_askcustomquit i.MWM5_asksupplprod i.MWM6_attrcustomdisc ///
i.MWM7_advert i.MWB1_negosupplprice i.MWB2_compsupplprod i.MWB3_notOOS ///
i.MWR1_recwritten i.MWR2_recpurchsale i.MWR3_recliquid i.MWR4_recsalesprods ///
i.MWR5_costprods i.MWR6_profprods i.MWR7_recexpensemth i.MWR8_recloan ///
i.MWF1_finperform i.MWF2_settargetyr i.MWF3_comptargetmth i.MWF4_expensenextyr ///
i.MWF5_proflossyr i.MWF6_cashflowyr i.MWF7_balancey i.MWF8_incexpenseyr ///
i.scooter i.car i.open_net_abvmd i.open_net_abv80 ///
i.formal_reg sales_normday_top3share i.dispose_wk i.stockup_top3_wk ///
i.stockup_top3_fix i.stockup_top3_late_any i.stockup_top3_wk i.stockup_top3_day ///
i.rec_pricesuppliers i.rec_pricebrands ///
i.rec_stockup i.rec_sales i.rec_assetpurch ///
i.rec_stocks i.rec_accpaysupplier i.rec_accpayloan ///
i.rec_othercosts i.rec_accreccustom i.rec_accrecfam ///
i.rec_ledger i.rec_receipts i.rec_twicewk ///
i.profcalc_nocosts i.profcalc_allcosts i.profcalc_any_day ///
i.inventory_change_demand ///
i.inventory_change_space i.inventory_change_prof i.inventory_change_price ///
i.price_change_comp i.price_change_demand i.discount ///
i.credit_TC i.credit_TC_int c.loans_applied c.loans_obtained ///
c.finlit_score i.compsales_compet i.prods_new_5 ///
i.jointdec_any i.discuss_any ///
labour_total c.space_cont, vce(robust)
estimates store all_Scompall

* 2 sig and neg, 6 sig and pos
reg prof_mth_comp_rep_win1_ihs i.MWM1_visitcompetprice i.MWM2_visitcompetprod ///
i.MWM3_askcustomprod i.MWM4_askcustomquit i.MWM5_asksupplprod i.MWM6_attrcustomdisc ///
i.MWM7_advert i.MWB1_negosupplprice i.MWB2_compsupplprod i.MWB3_notOOS ///
i.MWR1_recwritten i.MWR2_recpurchsale i.MWR3_recliquid i.MWR4_recsalesprods ///
i.MWR5_costprods i.MWR6_profprods i.MWR7_recexpensemth i.MWR8_recloan ///
i.MWF1_finperform i.MWF2_settargetyr i.MWF3_comptargetmth i.MWF4_expensenextyr ///
i.MWF5_proflossyr i.MWF6_cashflowyr i.MWF7_balancey i.MWF8_incexpenseyr ///
i.scooter i.car i.open_net_abvmd i.open_net_abv80 ///
i.formal_reg sales_normday_top3share i.dispose_wk i.stockup_top3_wk ///
i.stockup_top3_fix i.stockup_top3_late_any i.stockup_top3_wk i.stockup_top3_day ///
rec_pricesuppliers rec_pricebrands ///
rec_stockup rec_sales rec_assetpurch ///
rec_stocks rec_accpaysupplier rec_accpayloan ///
rec_othercosts rec_accreccustom rec_accrecfam ///
rec_ledger rec_receipts rec_twicewk ///
profcalc_nocosts profcalc_allcosts profcalc_any_day ///
i.inventory_change_demand ///
i.inventory_change_space i.inventory_change_prof i.inventory_change_price ///
i.price_change_comp i.price_change_demand i.discount ///
i.credit_TC i.credit_TC_int c.loans_applied c.loans_obtained ///
c.finlit_score i.compsales_compet i.prods_new_5 ///
i.jointdec_any i.discuss_any ///
labour_total c.space_cont, vce(robust)
estimates store all_Pcomprep

/*
*** Labour prod

reg productiv_labour i.MWM1_visitcompetprice i.MWM2_visitcompetprod ///
i.MWM3_askcustomprod i.MWM4_askcustomquit i.MWM5_asksupplprod i.MWM6_attrcustomdisc ///
i.MWM7_advert i.MWB1_negosupplprice i.MWB2_compsupplprod i.MWB3_notOOS ///
i.MWR1_recwritten i.MWR2_recpurchsale i.MWR3_recliquid i.MWR4_recsalesprods ///
i.MWR5_costprods i.MWR6_profprods i.MWR7_recexpensemth i.MWR8_recloan ///
i.MWF1_finperform i.MWF2_settargetyr i.MWF3_comptargetmth i.MWF4_expensenextyr ///
i.MWF5_proflossyr i.MWF6_cashflowyr i.MWF7_balancey i.MWF8_incexpenseyr ///
i.scooter i.car i.open_net_abvmd i.open_net_abv80 ///
i.formal_reg sales_normday_top3share i.dispose_wk i.stockup_top3_wk ///
i.stockup_top3_fix i.stockup_top3_late_any i.stockup_top3_wk i.stockup_top3_day ///
rec_pricesuppliers rec_pricebrands ///
rec_stockup rec_sales rec_assetpurch ///
rec_stocks rec_accpaysupplier rec_accpayloan ///
rec_othercosts rec_accreccustom rec_accrecfam ///
rec_ledger rec_receipts rec_twicewk ///
profcalc_nocosts profcalc_allcosts profcalc_any_day ///
i.inventory_change_demand ///
i.inventory_change_space i.inventory_change_prof i.inventory_change_price ///
i.price_change_comp i.price_change_demand i.discount ///
i.credit_TC i.credit_TC_int c.loans_applied c.loans_obtained ///
c.finlit_score i.compsales_compet i.prods_new_5 ///
i.jointdec_any i.discuss_any ///
labour_total c.space_cont, vce(robust)
estimates store all_prodlab
*/

*** Customers

reg custom_total i.MWM1_visitcompetprice i.MWM2_visitcompetprod ///
i.MWM3_askcustomprod i.MWM4_askcustomquit i.MWM5_asksupplprod i.MWM6_attrcustomdisc ///
i.MWM7_advert i.MWB1_negosupplprice i.MWB2_compsupplprod i.MWB3_notOOS ///
i.MWR1_recwritten i.MWR2_recpurchsale i.MWR3_recliquid i.MWR4_recsalesprods ///
i.MWR5_costprods i.MWR6_profprods i.MWR7_recexpensemth i.MWR8_recloan ///
i.MWF1_finperform i.MWF2_settargetyr i.MWF3_comptargetmth i.MWF4_expensenextyr ///
i.MWF5_proflossyr i.MWF6_cashflowyr i.MWF7_balancey i.MWF8_incexpenseyr ///
i.scooter i.car i.open_net_abvmd i.open_net_abv80 ///
i.formal_reg sales_normday_top3share i.dispose_wk i.stockup_top3_wk ///
i.stockup_top3_fix i.stockup_top3_late_any i.stockup_top3_wk i.stockup_top3_day ///
rec_pricesuppliers rec_pricebrands ///
rec_stockup rec_sales rec_assetpurch ///
rec_stocks rec_accpaysupplier rec_accpayloan ///
rec_othercosts rec_accreccustom rec_accrecfam ///
rec_ledger rec_receipts rec_twicewk ///
profcalc_nocosts profcalc_allcosts profcalc_any_day ///
i.inventory_change_demand ///
i.inventory_change_space i.inventory_change_prof i.inventory_change_price ///
i.price_change_comp i.price_change_demand i.discount ///
i.credit_TC i.credit_TC_int c.loans_applied c.loans_obtained ///
c.finlit_score i.compsales_compet i.prods_new_5 ///
i.jointdec_any i.discuss_any ///
labour_total c.space_cont, vce(robust)
estimates store all_custot

reg custom_loyal i.MWM1_visitcompetprice i.MWM2_visitcompetprod ///
i.MWM3_askcustomprod i.MWM4_askcustomquit i.MWM5_asksupplprod i.MWM6_attrcustomdisc ///
i.MWM7_advert i.MWB1_negosupplprice i.MWB2_compsupplprod i.MWB3_notOOS ///
i.MWR1_recwritten i.MWR2_recpurchsale i.MWR3_recliquid i.MWR4_recsalesprods ///
i.MWR5_costprods i.MWR6_profprods i.MWR7_recexpensemth i.MWR8_recloan ///
i.MWF1_finperform i.MWF2_settargetyr i.MWF3_comptargetmth i.MWF4_expensenextyr ///
i.MWF5_proflossyr i.MWF6_cashflowyr i.MWF7_balancey i.MWF8_incexpenseyr ///
i.scooter i.car i.open_net_abvmd i.open_net_abv80 ///
i.formal_reg sales_normday_top3share i.dispose_wk i.stockup_top3_wk ///
i.stockup_top3_fix i.stockup_top3_late_any i.stockup_top3_wk i.stockup_top3_day ///
rec_pricesuppliers rec_pricebrands ///
rec_stockup rec_sales rec_assetpurch ///
rec_stocks rec_accpaysupplier rec_accpayloan ///
rec_othercosts rec_accreccustom rec_accrecfam ///
rec_ledger rec_receipts rec_twicewk ///
profcalc_nocosts profcalc_allcosts profcalc_any_day ///
i.inventory_change_demand ///
i.inventory_change_space i.inventory_change_prof i.inventory_change_price ///
i.price_change_comp i.price_change_demand i.discount ///
i.credit_TC i.credit_TC_int c.loans_applied c.loans_obtained ///
c.finlit_score i.compsales_compet i.prods_new_5 ///
i.jointdec_any i.discuss_any ///
labour_total c.space_cont, vce(robust)
estimates store all_cusloy


*** Tables

* Sales and profits comp scores
estimates table all_Scompall all_Pcomprep, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse) 

* Lab prod, customers (total and loyal)
estimates table /*all_prodlab*/ all_custot all_cusloy, ///
b(%7.2f) se(%7.2f) stfmt(%7.4g) stats(N r2 r2_a rmse)



* regress yvar xvarlist, vce(robust) // level(#)
* reg wage c.age##i.male c.age#c.age c.age#c.age#i.male, vce(robust) // Regress wage on age, male,age×male, age2, and age2×male with age being continuous (c) and male a binary (i)

* dprobit survival bscore b_lnworkers b_paidworkers_miss b_paidworkers_zero b_manuf b_trade b_services  kenya nigeria srilanka if (country=="Kenya" & round==2)|(country=="Nigeria" & round==2)|(country=="Sri Lanka" & round==3), r
* probit yvar xvarlist, vce(robust) 


* dprobit survival bscore b_lnworkers b_paidworkers_miss b_paidworkers_zero b_manuf b_trade b_services  kenya nigeria srilanka if (country=="Kenya" & round==2)|(country=="Nigeria" & round==2)|(country=="Sri Lanka" & round==3), r
* probit yvar xvarlist, vce(robust) 



*** Heteroscedasticity
* estat imtest, white

*** Fitted value and residual for each obs
* predict yhatvar
* predict rvar, residuals

*** Table
* esttab est1 est2 using regs, rtf b(a3) se(a3) star(+ 0.10 * 0.05 ** 0.01 *** 0.001) r2(3) ar2(3) scalars(F) nogaps


*** Graph
* twoway function y=_b[_cons]+_b[age]*x +_b[age2]*x^2 +_b[female]*1+_b[black]*1, range(0 30)

* probit survival bscore b_lnworkers b_paidworkers_miss b_paidworkers_zero b_manuf b_trade b_services  kenya nigeria srilanka if (country=="Kenya" & round==2)|(country=="Nigeria" & round==2)|(country=="Sri Lanka" & round==3), r
* probit yvar xvarlist, vce(robust)



************************************************************************
***** FACTOR ANALYSIS ************************************************


* Factors structure of McKandW vars
factor MWM1_visitcompetprice MWM2_visitcompetprod MWM3_askcustomprod ///
MWM4_askcustomquit MWM5_asksupplprod MWM6_attrcustomdisc MWM7_advert ///
MWB1_negosupplprice MWB2_compsupplprod MWB3_notOOS MWR1_recwritten ///
MWR2_recpurchsale MWR3_recliquid MWR4_recsalesprods MWR5_costprods ///
MWR6_profprods MWR7_recexpensemth MWR8_recloan MWF1_finperform ///
MWF2_settargetyr MWF3_comptargetmth MWF4_expensenextyr MWF5_proflossyr ///
MWF6_cashflowyr MWF7_balancey MWF8_incexpenseyr, ml blanks(0.2) factors(4)


* Factor structur of var set
factor MWM1_visitcompetprice MWM2_visitcompetprod MWM3_askcustomprod ///
MWM4_askcustomquit MWM5_asksupplprod MWM6_attrcustomdisc MWM7_advert ///
MWB1_negosupplprice MWB2_compsupplprod MWB3_notOOS MWR1_recwritten ///
MWR2_recpurchsale MWR3_recliquid MWR4_recsalesprods MWR5_costprods ///
MWR6_profprods MWR7_recexpensemth MWR8_recloan MWF1_finperform ///
MWF2_settargetyr MWF3_comptargetmth MWF4_expensenextyr MWF5_proflossyr ///
MWF6_cashflowyr MWF7_balancey MWF8_incexpenseyr ///
/*scooter car*/ open_net_abvmd ///
formal_reg sales_normday_top3share dispose_wk stockup_top3_wk ///
stockup_top3_fix stockup_top3_late_any stockup_top3_wk stockup_top3_day ///
rec_pricesuppliers rec_pricebrands rec_stockup rec_sales ///
rec_assetpurch rec_stocks rec_accpaysupplier ///
rec_accpayloan rec_othercosts rec_accreccustom ///
rec_accrecfam rec_ledger rec_receipts rec_twicewk ///
profcalc_nocosts profcalc_allcosts profcalc_any_day ///
inventory_change_demand inventory_change_space inventory_change_prof inventory_change_price /// 
price_change_comp price_change_demand discount ///
credit_TC credit_TC_int loans_applied /*loans_obtained*/ ///
/*finlit_score*/ compsales_compet prods_new_5 /// 
discuss_sales discuss_sellprice discuss_bestseller ///
discuss_finance discuss_buyprice discuss_newprod ///
discuss_practice discuss_bisplan ///
jointdec_sales jointdec_sellprice jointdec_bestseller ///
jointdec_finance jointdec_buyprice jointdec_newprod ///
jointdec_practice jointdec_bisplan ///
jointdec_agree separatefin, ml blanks(0.3) factors(6)



************************************************************************
***** M Marketing regs ************************************************


***** SALES AND PROFITS, COMP SCORE (calc and self-rep for sales, self-rep only for profits)

*** Sales, IHS-transformed and w/out transformation (both win at p99)
reg sales_mth_comp_all_win1_ln ///
i.MWM1_visitcompetprice i.MWM2_visitcompetprod i.MWM3_askcustomprod ///
i.MWM4_askcustomquit i.MWM5_asksupplprod i.MWM6_attrcustomdisc i.MWM7_advert ///
labour_total space_cont, vce(robust)

reg sales_mth_comp_all_win1 ///
i.MWM1_visitcompetprice i.MWM2_visitcompetprod i.MWM3_askcustomprod ///
i.MWM4_askcustomquit i.MWM5_asksupplprod i.MWM6_attrcustomdisc i.MWM7_advert ///
labour_total space_cont, vce(robust)

*** Profits, IHS-transformed and w/out transformation (both win at p99)
reg prof_mth_comp_rep_win1_ihs ///
i.MWM1_visitcompetprice i.MWM2_visitcompetprod i.MWM3_askcustomprod ///
i.MWM4_askcustomquit i.MWM5_asksupplprod i.MWM6_attrcustomdisc i.MWM7_advert ///
labour_total space_cont, vce(robust)

reg prof_mth_comp_rep_win1 ///
i.MWM1_visitcompetprice i.MWM2_visitcompetprod i.MWM3_askcustomprod ///
i.MWM4_askcustomquit i.MWM5_asksupplprod i.MWM6_attrcustomdisc i.MWM7_advert ///
labour_total space_cont, vce(robust)


***** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

reg sales_normday_win1_ln ///
i.MWM1_visitcompetprice i.MWM2_visitcompetprod i.MWM3_askcustomprod ///
i.MWM4_askcustomquit i.MWM5_asksupplprod i.MWM6_attrcustomdisc i.MWM7_advert ///
labour_total space_cont, vce(robust)

reg sales_normday_top7_win1_ln ///
i.MWM1_visitcompetprice i.MWM2_visitcompetprod i.MWM3_askcustomprod ///
i.MWM4_askcustomquit i.MWM5_asksupplprod i.MWM6_attrcustomdisc i.MWM7_advert ///
labour_total space_cont, vce(robust)

reg prof_normday_win1_ihs ///
i.MWM1_visitcompetprice i.MWM2_visitcompetprod i.MWM3_askcustomprod ///
i.MWM4_askcustomquit i.MWM5_asksupplprod i.MWM6_attrcustomdisc i.MWM7_advert ///
labour_total space_cont, vce(robust)


***** CUSTOMERS

reg custom_total ///
i.MWM1_visitcompetprice i.MWM2_visitcompetprod i.MWM3_askcustomprod ///
i.MWM4_askcustomquit i.MWM5_asksupplprod i.MWM6_attrcustomdisc i.MWM7_advert ///
labour_total space_cont, vce(robust)



************************************************************************
***** M+ Additional marketing regs ************************************************


***** SALES AND PROFITS, COMP SCORE (calc and self-rep for sales, self-rep only for profits)

*** Sales, IHS-transformed and w/out transformation (both win at p99)
reg sales_mth_comp_all_win1_ln ///
i.price_change_comp i.compsales_compet ///
i.discuss_newprod ///
i.discuss_supplier i.discuss_bestseller ///
i.discount ///
labour_total space_cont, vce(robust)

reg sales_mth_comp_all_win1 ///
i.price_change_comp i.compsales_compet ///
i.discuss_newprod ///
i.discuss_supplier i.discuss_bestseller ///
i.discount ///
labour_total space_cont, vce(robust)

*** Profits, IHS-transformed and w/out transformation (both win at p99)
reg prof_mth_comp_rep_win1_ihs ///
i.price_change_comp i.compsales_compet ///
i.discuss_newprod ///
i.discuss_supplier i.discuss_bestseller ///
i.discount ///
labour_total space_cont, vce(robust)

reg prof_mth_comp_rep_win1 ///
i.price_change_comp i.compsales_compet ///
i.discuss_newprod ///
i.discuss_supplier i.discuss_bestseller ///
i.discount ///
labour_total space_cont, vce(robust)


***** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

reg sales_normday_win1_ln ///
i.price_change_comp i.compsales_compet ///
i.discuss_newprod ///
i.discuss_supplier i.discuss_bestseller ///
i.discount ///
labour_total space_cont, vce(robust)

reg sales_normday_top7_win1_ln ///
i.price_change_comp i.compsales_compet ///
i.discuss_newprod ///
i.discuss_supplier i.discuss_bestseller ///
i.discount ///
labour_total space_cont, vce(robust)

reg prof_normday_win1_ihs ///
i.price_change_comp i.compsales_compet ///
i.discuss_newprod ///
i.discuss_supplier i.discuss_bestseller ///
i.discount ///
labour_total space_cont, vce(robust)


***** CUSTOMERS

reg custom_total ///
i.price_change_comp i.compsales_compet ///
i.discuss_newprod ///
i.discuss_supplier i.discuss_bestseller ///
i.discount ///
labour_total space_cont, vce(robust)



************************************************************************
***** B Stocking-up regs ************************************************


***** SALES AND PROFITS, COMP SCORE (calc and self-rep for sales, self-rep only for profits)

*** Sales, IHS-transformed and w/out transformation (both win at p99)
reg sales_mth_comp_all_win1_ln ///
i.MWB1_negosupplprice i.MWB2_compsupplprod i.MWB3_notOOS ///
labour_total space_cont, vce(robust)

reg sales_mth_comp_all_win1 ///
i.MWB1_negosupplprice i.MWB2_compsupplprod i.MWB3_notOOS ///
labour_total space_cont, vce(robust)

*** Profits, IHS-transformed and w/out transformation (both win at p99)
reg prof_mth_comp_rep_win1_ihs ///
i.MWB1_negosupplprice i.MWB2_compsupplprod i.MWB3_notOOS ///
labour_total space_cont, vce(robust)

reg prof_mth_comp_rep_win1 ///
i.MWB1_negosupplprice i.MWB2_compsupplprod i.MWB3_notOOS ///
labour_total space_cont, vce(robust)


***** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

reg sales_normday_win1_ln ///
i.MWB1_negosupplprice i.MWB2_compsupplprod i.MWB3_notOOS ///
labour_total space_cont, vce(robust)

reg sales_normday_top7_win1_ln ///
i.MWB1_negosupplprice i.MWB2_compsupplprod i.MWB3_notOOS ///
labour_total space_cont, vce(robust)

reg prof_normday_win1_ihs ///
i.MWB1_negosupplprice i.MWB2_compsupplprod i.MWB3_notOOS ///
labour_total space_cont, vce(robust)


***** CUSTOMERS

reg custom_total ///
i.MWB1_negosupplprice i.MWB2_compsupplprod i.MWB3_notOOS ///
labour_total space_cont, vce(robust)



************************************************************************
***** B+ Additional stocking-up regs ************************************************


***** SALES AND PROFITS, COMP SCORE (calc and self-rep for sales, self-rep only for profits)

*** Sales, IHS-transformed and w/out transformation (both win at p99)
reg sales_mth_comp_all_win1_ln ///
i.stockup_top3_wk i.stockup_top3_late_any ///
i.stockup_top3_fix i.stockup_top3_wk i.stockup_top3_day ///
labour_total space_cont, vce(robust)

reg sales_mth_comp_all_win1 ///
i.stockup_top3_wk i.stockup_top3_late_any ///
i.stockup_top3_fix i.stockup_top3_wk i.stockup_top3_day ///
labour_total space_cont, vce(robust)

*** Profits, IHS-transformed and w/out transformation (both win at p99)
reg prof_mth_comp_rep_win1_ihs ///
i.stockup_top3_wk i.stockup_top3_late_any ///
i.stockup_top3_fix i.stockup_top3_wk i.stockup_top3_day ///
labour_total space_cont, vce(robust)

reg prof_mth_comp_rep_win1 ///
i.stockup_top3_wk i.stockup_top3_late_any ///
i.stockup_top3_fix i.stockup_top3_wk i.stockup_top3_day ///
labour_total space_cont, vce(robust)


***** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

reg sales_normday_win1_ln ///
i.stockup_top3_wk i.stockup_top3_late_any ///
i.stockup_top3_fix i.stockup_top3_wk i.stockup_top3_day ///
labour_total space_cont, vce(robust)

reg sales_normday_top7_win1_ln ///
i.stockup_top3_wk i.stockup_top3_late_any ///
i.stockup_top3_fix i.stockup_top3_wk i.stockup_top3_day ///
labour_total space_cont, vce(robust)

reg prof_normday_win1_ihs ///
i.stockup_top3_wk i.stockup_top3_late_any ///
i.stockup_top3_fix i.stockup_top3_wk i.stockup_top3_day ///
labour_total space_cont, vce(robust)


***** CUSTOMERS

reg custom_total ///
i.stockup_top3_wk i.stockup_top3_late_any ///
i.stockup_top3_fix i.stockup_top3_wk i.stockup_top3_day ///
labour_total space_cont, vce(robust)



***********************************************************************
***** R Record-keeping regs *****************************************


***** SALES AND PROFITS, COMP SCORE (calc and self-rep for sales, self-rep only for profits)

*** Sales, IHS-transformed and w/out transformation (both win at p99)
reg sales_mth_comp_all_win1_ln ///
i.MWR1_recwritten i.MWR2_recpurchsale i.MWR3_recliquid i.MWR4_recsalesprods ///
i.MWR5_costprods i.MWR6_profprods i.MWR7_recexpensemth i.MWR8_recloan ///
labour_total space_cont, vce(robust)

reg sales_mth_comp_all_win1 ///
i.MWR1_recwritten i.MWR2_recpurchsale i.MWR3_recliquid i.MWR4_recsalesprods ///
i.MWR5_costprods i.MWR6_profprods i.MWR7_recexpensemth i.MWR8_recloan ///
labour_total space_cont, vce(robust)

*** Profits, IHS-transformed and w/out transformation (both win at p99)
reg prof_mth_comp_rep_win1_ihs ///
i.MWR1_recwritten i.MWR2_recpurchsale i.MWR3_recliquid i.MWR4_recsalesprods ///
i.MWR5_costprods i.MWR6_profprods i.MWR7_recexpensemth i.MWR8_recloan ///
labour_total space_cont, vce(robust)

reg prof_mth_comp_rep_win1 ///
i.MWR1_recwritten i.MWR2_recpurchsale i.MWR3_recliquid i.MWR4_recsalesprods ///
i.MWR5_costprods i.MWR6_profprods i.MWR7_recexpensemth i.MWR8_recloan ///
labour_total space_cont, vce(robust)


***** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

reg sales_normday_win1_ln ///
i.MWR1_recwritten i.MWR2_recpurchsale i.MWR3_recliquid i.MWR4_recsalesprods ///
i.MWR5_costprods i.MWR6_profprods i.MWR7_recexpensemth i.MWR8_recloan ///
labour_total space_cont, vce(robust)

reg sales_normday_top7_win1_ln ///
i.MWR1_recwritten i.MWR2_recpurchsale i.MWR3_recliquid i.MWR4_recsalesprods ///
i.MWR5_costprods i.MWR6_profprods i.MWR7_recexpensemth i.MWR8_recloan ///
labour_total space_cont, vce(robust)

reg prof_normday_win1_ihs ///
i.MWR1_recwritten i.MWR2_recpurchsale i.MWR3_recliquid i.MWR4_recsalesprods ///
i.MWR5_costprods i.MWR6_profprods i.MWR7_recexpensemth i.MWR8_recloan ///
labour_total space_cont, vce(robust)


***** CUSTOMERS

reg custom_total ///
i.MWR1_recwritten i.MWR2_recpurchsale i.MWR3_recliquid i.MWR4_recsalesprods ///
i.MWR5_costprods i.MWR6_profprods i.MWR7_recexpensemth i.MWR8_recloan ///
labour_total space_cont, vce(robust)



************************************************************************
***** R+ Additional: record-keeping *************************************


***** SALES AND PROFITS, COMP SCORE (calc and self-rep for sales, self-rep only for profits)

*** Sales, IHS-transformed and w/out transformation (both win at p99)
reg sales_mth_comp_all_win1_ln ///
i.rec_ledger i.rec_receipts i.rec_twicewk ///
i.rec_pricesuppliers i.rec_pricebrands i.rec_stockup i.rec_sales ///
i.rec_assetpurch i.rec_stocks i.rec_accpaysupplier ///
i.rec_accpayloan i.rec_othercosts i.rec_accreccustom i.rec_accrecfam ///
labour_total space_cont, vce(robust)

reg sales_mth_comp_all_win1 ///
i.rec_ledger i.rec_receipts i.rec_twicewk ///
i.rec_pricesuppliers i.rec_pricebrands i.rec_stockup i.rec_sales ///
i.rec_assetpurch i.rec_stocks i.rec_accpaysupplier ///
i.rec_accpayloan i.rec_othercosts i.rec_accreccustom i.rec_accrecfam ///
labour_total space_cont, vce(robust)

*** Profits, IHS-transformed and w/out transformation (both win at p99)
reg prof_mth_comp_rep_win1_ihs ///
i.rec_ledger i.rec_receipts i.rec_twicewk ///
i.rec_pricesuppliers i.rec_pricebrands i.rec_stockup i.rec_sales ///
i.rec_assetpurch i.rec_stocks i.rec_accpaysupplier ///
i.rec_accpayloan i.rec_othercosts i.rec_accreccustom i.rec_accrecfam ///
labour_total space_cont, vce(robust)

reg prof_mth_comp_rep_win1 ///
i.rec_ledger i.rec_receipts i.rec_twicewk ///
i.rec_pricesuppliers i.rec_pricebrands i.rec_stockup i.rec_sales ///
i.rec_assetpurch i.rec_stocks i.rec_accpaysupplier ///
i.rec_accpayloan i.rec_othercosts i.rec_accreccustom i.rec_accrecfam ///
labour_total space_cont, vce(robust)


***** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

reg sales_normday_win1_ln ///
i.rec_ledger i.rec_receipts i.rec_twicewk ///
i.rec_pricesuppliers i.rec_pricebrands i.rec_stockup i.rec_sales ///
i.rec_assetpurch i.rec_stocks i.rec_accpaysupplier ///
i.rec_accpayloan i.rec_othercosts i.rec_accreccustom i.rec_accrecfam ///
labour_total space_cont, vce(robust)

reg sales_normday_top7_win1_ln ///
i.rec_ledger i.rec_receipts i.rec_twicewk ///
i.rec_pricesuppliers i.rec_pricebrands i.rec_stockup i.rec_sales ///
i.rec_assetpurch i.rec_stocks i.rec_accpaysupplier ///
i.rec_accpayloan i.rec_othercosts i.rec_accreccustom i.rec_accrecfam ///
labour_total space_cont, vce(robust)

reg prof_normday_win1_ihs ///
i.rec_ledger i.rec_receipts i.rec_twicewk ///
i.rec_pricesuppliers i.rec_pricebrands i.rec_stockup i.rec_sales ///
i.rec_assetpurch i.rec_stocks i.rec_accpaysupplier ///
i.rec_accpayloan i.rec_othercosts i.rec_accreccustom i.rec_accrecfam ///
labour_total space_cont, vce(robust)


***** CUSTOMERS

reg custom_total ///
i.rec_ledger i.rec_receipts i.rec_twicewk ///
i.rec_pricesuppliers i.rec_pricebrands i.rec_stockup i.rec_sales ///
i.rec_assetpurch i.rec_stocks i.rec_accpaysupplier ///
i.rec_accpayloan i.rec_othercosts i.rec_accreccustom i.rec_accrecfam ///
labour_total space_cont, vce(robust)


************************************************************************
***** R+ Additional: profit calcs ********************************************


***** SALES AND PROFITS, COMP SCORE (calc and self-rep for sales, self-rep only for profits)

*** Sales, IHS-transformed and w/out transformation (both win at p99)
reg sales_mth_comp_all_win1_ln ///
i.profcalc_nocosts i.profcalc_allcosts i.profcalc_any_day ///
i.inventory_change_prof i.inventory_change_price ///
labour_total space_cont, vce(robust)

reg sales_mth_comp_all_win1 ///
i.profcalc_nocosts i.profcalc_allcosts i.profcalc_any_day ///
i.inventory_change_prof i.inventory_change_price ///
labour_total space_cont, vce(robust)

*** Profits, IHS-transformed and w/out transformation (both win at p99)
reg prof_mth_comp_rep_win1_ihs ///
i.profcalc_nocosts i.profcalc_allcosts i.profcalc_any_day ///
i.inventory_change_prof i.inventory_change_price ///
labour_total space_cont, vce(robust)

reg prof_mth_comp_rep_win1 ///
i.profcalc_nocosts i.profcalc_allcosts i.profcalc_any_day ///
i.inventory_change_prof i.inventory_change_price ///
labour_total space_cont, vce(robust)


***** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

reg sales_normday_win1_ln ///
i.profcalc_nocosts i.profcalc_allcosts i.profcalc_any_day ///
i.inventory_change_prof i.inventory_change_price ///
labour_total space_cont, vce(robust)

reg sales_normday_top7_win1_ln ///
i.profcalc_nocosts i.profcalc_allcosts i.profcalc_any_day ///
i.inventory_change_prof i.inventory_change_price ///
labour_total space_cont, vce(robust)

reg prof_normday_win1_ihs ///
i.profcalc_nocosts i.profcalc_allcosts i.profcalc_any_day ///
i.inventory_change_prof i.inventory_change_price ///
labour_total space_cont, vce(robust)


***** CUSTOMERS

reg custom_total ///
i.profcalc_nocosts i.profcalc_allcosts i.profcalc_any_day ///
i.inventory_change_prof i.inventory_change_price ///
labour_total space_cont, vce(robust)



************************************************************************
***** F Planning regs ************************************************


***** SALES AND PROFITS, COMP SCORE (calc and self-rep for sales, self-rep only for profits)

*** Sales, IHS-transformed and w/out transformation (both win at p99)
reg sales_mth_comp_all_win1_ln ///
i.MWF1_finperform i.MWF2_settargetyr i.MWF3_comptargetmth i.MWF4_expensenextyr ///
i.MWF5_proflossyr i.MWF6_cashflowyr i.MWF7_balancey i.MWF8_incexpenseyr ///
labour_total space_cont, vce(robust)

reg sales_mth_comp_all_win1 ///
i.MWF1_finperform i.MWF2_settargetyr i.MWF3_comptargetmth i.MWF4_expensenextyr ///
i.MWF5_proflossyr i.MWF6_cashflowyr i.MWF7_balancey i.MWF8_incexpenseyr ///
labour_total space_cont, vce(robust)

*** Profits, IHS-transformed and w/out transformation (both win at p99)
reg prof_mth_comp_rep_win1_ihs ///
i.MWF1_finperform i.MWF2_settargetyr i.MWF3_comptargetmth i.MWF4_expensenextyr ///
i.MWF5_proflossyr i.MWF6_cashflowyr i.MWF7_balancey i.MWF8_incexpenseyr ///
labour_total space_cont, vce(robust)

reg prof_mth_comp_rep_win1 ///
i.MWF1_finperform i.MWF2_settargetyr i.MWF3_comptargetmth i.MWF4_expensenextyr ///
i.MWF5_proflossyr i.MWF6_cashflowyr i.MWF7_balancey i.MWF8_incexpenseyr ///
labour_total space_cont, vce(robust)


***** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

reg sales_normday_win1_ln ///
i.MWF1_finperform i.MWF2_settargetyr i.MWF3_comptargetmth i.MWF4_expensenextyr ///
i.MWF5_proflossyr i.MWF6_cashflowyr i.MWF7_balancey i.MWF8_incexpenseyr ///
labour_total space_cont, vce(robust)

reg sales_normday_top7_win1_ln ///
i.MWF1_finperform i.MWF2_settargetyr i.MWF3_comptargetmth i.MWF4_expensenextyr ///
i.MWF5_proflossyr i.MWF6_cashflowyr i.MWF7_balancey i.MWF8_incexpenseyr ///
labour_total space_cont, vce(robust)

reg prof_normday_win1_ihs ///
i.MWF1_finperform i.MWF2_settargetyr i.MWF3_comptargetmth i.MWF4_expensenextyr ///
i.MWF5_proflossyr i.MWF6_cashflowyr i.MWF7_balancey i.MWF8_incexpenseyr ///
labour_total space_cont, vce(robust)


***** CUSTOMERS

reg custom_total ///
i.MWF1_finperform i.MWF2_settargetyr i.MWF3_comptargetmth i.MWF4_expensenextyr ///
i.MWF5_proflossyr i.MWF6_cashflowyr i.MWF7_balancey i.MWF8_incexpenseyr ///
labour_total space_cont, vce(robust)



************************************************************************
***** F+ Additional planning regs ************************************************



************************************************************************
***** Product management (inventory, pricing) and firm characteristics ************


***** W  TOP3 SHARE ABOVE P80

*** SALES AND PROFITS, COMP SCORE (calc and self-rep for sales, self-rep only for profits)

* Sales, IHS-transformed and w/out transformation (both win at p99)
reg sales_mth_comp_all_win1_ln ///
i.sales_normday_top3share_abv80 i.prods_new_5 dispose_wk ///
i.inventory_change_demand i.inventory_change_space ///
i.price_change_demand ///
labour_total space_cont, vce(robust)

reg sales_mth_comp_all_win1 ///
i.sales_normday_top3share_abv80 i.prods_new_5 dispose_wk ///
i.inventory_change_demand i.inventory_change_space ///
i.price_change_demand ///
labour_total space_cont, vce(robust)

* Profits, IHS-transformed and w/out transformation (both win at p99)
reg prof_mth_comp_rep_win1_ihs ///
i.sales_normday_top3share_abv80 i.prods_new_5 dispose_wk ///
i.inventory_change_demand i.inventory_change_space ///
i.price_change_demand ///
labour_total space_cont, vce(robust)

reg prof_mth_comp_rep_win1 ///
i.sales_normday_top3share_abv80 i.prods_new_5 dispose_wk ///
i.inventory_change_demand i.inventory_change_space ///
i.price_change_demand ///
labour_total space_cont, vce(robust)


*** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

reg sales_normday_win1_ln ///
i.sales_normday_top3share_abv80 i.prods_new_5 dispose_wk ///
i.inventory_change_demand i.inventory_change_space ///
i.price_change_demand ///
labour_total space_cont, vce(robust)

reg sales_normday_top7_win1_ln ///
i.sales_normday_top3share_abv80 i.prods_new_5 dispose_wk ///
i.inventory_change_demand i.inventory_change_space ///
i.price_change_demand ///
labour_total space_cont, vce(robust)

reg prof_normday_win1_ihs ///
i.sales_normday_top3share_abv80 i.prods_new_5 dispose_wk ///
i.inventory_change_demand i.inventory_change_space ///
i.price_change_demand ///
labour_total space_cont, vce(robust)


*** CUSTOMERS

reg custom_total ///
i.sales_normday_top3share_abv80 i.prods_new_5 dispose_wk ///
i.inventory_change_demand i.inventory_change_space ///
i.price_change_demand ///
labour_total space_cont, vce(robust)



***** W  TOP3 SHARE ABOVE MEDIAN


*** SALES AND PROFITS, COMP SCORE (calc and self-rep for sales, self-rep only for profits)

* Sales, IHS-transformed and w/out transformation (both win at p99)
reg sales_mth_comp_all_win1_ln ///
i.sales_normday_top3share_abvmd i.prods_new_5 dispose_wk ///
i.inventory_change_demand i.inventory_change_space ///
i.price_change_demand ///
labour_total space_cont, vce(robust)

reg sales_mth_comp_all_win1 ///
i.sales_normday_top3share_abvmd i.prods_new_5 dispose_wk ///
i.inventory_change_demand i.inventory_change_space ///
i.price_change_demand ///
labour_total space_cont, vce(robust)

* Profits, IHS-transformed and w/out transformation (both win at p99)
reg prof_mth_comp_rep_win1_ihs ///
i.sales_normday_top3share_abvmd i.prods_new_5 dispose_wk ///
i.inventory_change_demand i.inventory_change_space ///
i.price_change_demand ///
labour_total space_cont, vce(robust)

reg prof_mth_comp_rep_win1 ///
i.sales_normday_top3share_abvmd i.prods_new_5 dispose_wk ///
i.inventory_change_demand i.inventory_change_space ///
i.price_change_demand ///
labour_total space_cont, vce(robust)


*** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

reg sales_normday_win1_ln ///
i.sales_normday_top3share_abvmd i.prods_new_5 dispose_wk ///
i.inventory_change_demand i.inventory_change_space ///
i.price_change_demand ///
labour_total space_cont, vce(robust)

reg sales_normday_top7_win1_ln ///
i.sales_normday_top3share_abvmd i.prods_new_5 dispose_wk ///
i.inventory_change_demand i.inventory_change_space ///
i.price_change_demand ///
labour_total space_cont, vce(robust)

reg prof_normday_win1_ihs ///
i.sales_normday_top3share_abvmd i.prods_new_5 dispose_wk ///
i.inventory_change_demand i.inventory_change_space ///
i.price_change_demand ///
labour_total space_cont, vce(robust)


*** CUSTOMERS

reg custom_total ///
i.sales_normday_top3share_abvmd i.prods_new_5 dispose_wk ///
i.inventory_change_demand i.inventory_change_space ///
i.price_change_demand ///
labour_total space_cont, vce(robust)


/*
************************************************************************
***** Assortment *******************************************


***** SPECIFIC PROD AMONG TOP7 W POS DAILY SALES

*** PROFITS, COMP SCORE (calc and self-rep for sales, self-rep only for profits)

* Sales, IHS-transformed and w/out transformation (both win at p99)
reg sales_mth_comp_all_win1_ln ///
i.topprods_rice_1 i.topprods_flour_1 i.topprods_eggs_1 i.topprods_noodles_1 i.topprods_oil_1 ///
i.topprods_saltsugar_1 i.topprods_bread_1 i.topprods_coffeetea_1 i.topprods_homecooked_1 ///
i.topprods_snacks_1 i.topprods_freshdrinks_1 i.topprods_softdrinks_1 i.topprods_sanitary_1 ///
i.topprods_cleaning_1 i.topprods_baby_1 i.topprods_tobacco_1 i.topprods_meds_1 ///
i.topprods_gaspetrol_1 i.topprods_phone_1 ///
labour_total space_cont, vce(robust)

reg sales_mth_comp_all_win1 ///
i.topprods_rice_1 i.topprods_flour_1 i.topprods_eggs_1 i.topprods_noodles_1 i.topprods_oil_1 ///
i.topprods_saltsugar_1 i.topprods_bread_1 i.topprods_coffeetea_1 i.topprods_homecooked_1 ///
i.topprods_snacks_1 i.topprods_freshdrinks_1 i.topprods_softdrinks_1 i.topprods_sanitary_1 ///
i.topprods_cleaning_1 i.topprods_baby_1 i.topprods_tobacco_1 i.topprods_meds_1 ///
i.topprods_gaspetrol_1 i.topprods_phone_1 ///
labour_total space_cont, vce(robust)

* Profits, IHS-transformed and w/out transformation (both win at p99)
reg prof_mth_comp_rep_win1_ihs ///
i.topprods_rice_1 i.topprods_flour_1 i.topprods_eggs_1 i.topprods_noodles_1 i.topprods_oil_1 ///
i.topprods_saltsugar_1 i.topprods_bread_1 i.topprods_coffeetea_1 i.topprods_homecooked_1 ///
i.topprods_snacks_1 i.topprods_freshdrinks_1 i.topprods_softdrinks_1 i.topprods_sanitary_1 ///
i.topprods_cleaning_1 i.topprods_baby_1 i.topprods_tobacco_1 i.topprods_meds_1 ///
i.topprods_gaspetrol_1 i.topprods_phone_1 ///
labour_total space_cont, vce(robust)

reg prof_mth_comp_rep_win1 ///
i.topprods_rice_1 i.topprods_flour_1 i.topprods_eggs_1 i.topprods_noodles_1 i.topprods_oil_1 ///
i.topprods_saltsugar_1 i.topprods_bread_1 i.topprods_coffeetea_1 i.topprods_homecooked_1 ///
i.topprods_snacks_1 i.topprods_freshdrinks_1 i.topprods_softdrinks_1 i.topprods_sanitary_1 ///
i.topprods_cleaning_1 i.topprods_baby_1 i.topprods_tobacco_1 i.topprods_meds_1 ///
i.topprods_gaspetrol_1 i.topprods_phone_1 ///
labour_total space_cont, vce(robust)


*** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

reg sales_normday_win1_ln ///
i.topprods_rice_1 i.topprods_flour_1 i.topprods_eggs_1 i.topprods_noodles_1 i.topprods_oil_1 ///
i.topprods_saltsugar_1 i.topprods_bread_1 i.topprods_coffeetea_1 i.topprods_homecooked_1 ///
i.topprods_snacks_1 i.topprods_freshdrinks_1 i.topprods_softdrinks_1 i.topprods_sanitary_1 ///
i.topprods_cleaning_1 i.topprods_baby_1 i.topprods_tobacco_1 i.topprods_meds_1 ///
i.topprods_gaspetrol_1 i.topprods_phone_1 ///
labour_total space_cont, vce(robust)

reg sales_normday_top7_win1_ln ///
i.topprods_rice_1 i.topprods_flour_1 i.topprods_eggs_1 i.topprods_noodles_1 i.topprods_oil_1 ///
i.topprods_saltsugar_1 i.topprods_bread_1 i.topprods_coffeetea_1 i.topprods_homecooked_1 ///
i.topprods_snacks_1 i.topprods_freshdrinks_1 i.topprods_softdrinks_1 i.topprods_sanitary_1 ///
i.topprods_cleaning_1 i.topprods_baby_1 i.topprods_tobacco_1 i.topprods_meds_1 ///
i.topprods_gaspetrol_1 i.topprods_phone_1 ///
labour_total space_cont, vce(robust)

reg prof_normday_win1_ihs ///
i.topprods_rice_1 i.topprods_flour_1 i.topprods_eggs_1 i.topprods_noodles_1 i.topprods_oil_1 ///
i.topprods_saltsugar_1 i.topprods_bread_1 i.topprods_coffeetea_1 i.topprods_homecooked_1 ///
i.topprods_snacks_1 i.topprods_freshdrinks_1 i.topprods_softdrinks_1 i.topprods_sanitary_1 ///
i.topprods_cleaning_1 i.topprods_baby_1 i.topprods_tobacco_1 i.topprods_meds_1 ///
i.topprods_gaspetrol_1 i.topprods_phone_1 ///
labour_total space_cont, vce(robust)


*** CUSTOMERS

reg custom_total ///
i.topprods_rice_1 i.topprods_flour_1 i.topprods_eggs_1 i.topprods_noodles_1 i.topprods_oil_1 ///
i.topprods_saltsugar_1 i.topprods_bread_1 i.topprods_coffeetea_1 i.topprods_homecooked_1 ///
i.topprods_snacks_1 i.topprods_freshdrinks_1 i.topprods_softdrinks_1 i.topprods_sanitary_1 ///
i.topprods_cleaning_1 i.topprods_baby_1 i.topprods_tobacco_1 i.topprods_meds_1 ///
i.topprods_gaspetrol_1 i.topprods_phone_1 ///
labour_total space_cont, vce(robust)



***** TOP7 PROD W DAILY SALES IN P80 OF SAMPLE


*** PROFITS, COMP SCORE (calc and self-rep for sales, self-rep only for profits)

* Sales, IHS-transformed and w/out transformation (both win at p99)
reg sales_mth_comp_all_win1_ln ///
i.topprods_rice_abv80 i.topprods_flour_abv80 i.topprods_eggs_abv80 i.topprods_noodles_abv80 i.topprods_oil_abv80 ///
i.topprods_saltsugar_abv80 i.topprods_bread_abv80 i.topprods_coffeetea_abv80 i.topprods_homecooked_abv80 ///
i.topprods_snacks_abv80 i.topprods_freshdrinks_abv80 i.topprods_softdrinks_abv80 i.topprods_sanitary_abv80 ///
i.topprods_cleaning_abv80 i.topprods_baby_abv80 i.topprods_tobacco_abv80 i.topprods_meds_abv80 ///
i.topprods_gaspetrol_abv80 i.topprods_phone_abv80 ///
labour_total space_cont, vce(robust)

reg sales_mth_comp_all_win1 ///
i.topprods_rice_abv80 i.topprods_flour_abv80 i.topprods_eggs_abv80 i.topprods_noodles_abv80 i.topprods_oil_abv80 ///
i.topprods_saltsugar_abv80 i.topprods_bread_abv80 i.topprods_coffeetea_abv80 i.topprods_homecooked_abv80 ///
i.topprods_snacks_abv80 i.topprods_freshdrinks_abv80 i.topprods_softdrinks_abv80 i.topprods_sanitary_abv80 ///
i.topprods_cleaning_abv80 i.topprods_baby_abv80 i.topprods_tobacco_abv80 i.topprods_meds_abv80 ///
i.topprods_gaspetrol_abv80 i.topprods_phone_abv80 ///
labour_total space_cont, vce(robust)

* Profits, IHS-transformed and w/out transformation (both win at p99)
reg prof_mth_comp_rep_win1_ihs ///
i.topprods_rice_abv80 i.topprods_flour_abv80 i.topprods_eggs_abv80 i.topprods_noodles_abv80 i.topprods_oil_abv80 ///
i.topprods_saltsugar_abv80 i.topprods_bread_abv80 i.topprods_coffeetea_abv80 i.topprods_homecooked_abv80 ///
i.topprods_snacks_abv80 i.topprods_freshdrinks_abv80 i.topprods_softdrinks_abv80 i.topprods_sanitary_abv80 ///
i.topprods_cleaning_abv80 i.topprods_baby_abv80 i.topprods_tobacco_abv80 i.topprods_meds_abv80 ///
i.topprods_gaspetrol_abv80 i.topprods_phone_abv80 ///
labour_total space_cont, vce(robust)

reg prof_mth_comp_rep_win1 ///
i.topprods_rice_abv80 i.topprods_flour_abv80 i.topprods_eggs_abv80 i.topprods_noodles_abv80 i.topprods_oil_abv80 ///
i.topprods_saltsugar_abv80 i.topprods_bread_abv80 i.topprods_coffeetea_abv80 i.topprods_homecooked_abv80 ///
i.topprods_snacks_abv80 i.topprods_freshdrinks_abv80 i.topprods_softdrinks_abv80 i.topprods_sanitary_abv80 ///
i.topprods_cleaning_abv80 i.topprods_baby_abv80 i.topprods_tobacco_abv80 i.topprods_meds_abv80 ///
i.topprods_gaspetrol_abv80 i.topprods_phone_abv80 ///
labour_total space_cont, vce(robust)


*** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

reg sales_normday_win1_ln ///
i.topprods_rice_abv80 i.topprods_flour_abv80 i.topprods_eggs_abv80 i.topprods_noodles_abv80 i.topprods_oil_abv80 ///
i.topprods_saltsugar_abv80 i.topprods_bread_abv80 i.topprods_coffeetea_abv80 i.topprods_homecooked_abv80 ///
i.topprods_snacks_abv80 i.topprods_freshdrinks_abv80 i.topprods_softdrinks_abv80 i.topprods_sanitary_abv80 ///
i.topprods_cleaning_abv80 i.topprods_baby_abv80 i.topprods_tobacco_abv80 i.topprods_meds_abv80 ///
i.topprods_gaspetrol_abv80 i.topprods_phone_abv80 ///
labour_total space_cont, vce(robust)

reg sales_normday_top7_win1_ln ///
i.topprods_rice_abv80 i.topprods_flour_abv80 i.topprods_eggs_abv80 i.topprods_noodles_abv80 i.topprods_oil_abv80 ///
i.topprods_saltsugar_abv80 i.topprods_bread_abv80 i.topprods_coffeetea_abv80 i.topprods_homecooked_abv80 ///
i.topprods_snacks_abv80 i.topprods_freshdrinks_abv80 i.topprods_softdrinks_abv80 i.topprods_sanitary_abv80 ///
i.topprods_cleaning_abv80 i.topprods_baby_abv80 i.topprods_tobacco_abv80 i.topprods_meds_abv80 ///
i.topprods_gaspetrol_abv80 i.topprods_phone_abv80 ///
labour_total space_cont, vce(robust)

reg prof_normday_win1_ihs ///
i.topprods_rice_abv80 i.topprods_flour_abv80 i.topprods_eggs_abv80 i.topprods_noodles_abv80 i.topprods_oil_abv80 ///
i.topprods_saltsugar_abv80 i.topprods_bread_abv80 i.topprods_coffeetea_abv80 i.topprods_homecooked_abv80 ///
i.topprods_snacks_abv80 i.topprods_freshdrinks_abv80 i.topprods_softdrinks_abv80 i.topprods_sanitary_abv80 ///
i.topprods_cleaning_abv80 i.topprods_baby_abv80 i.topprods_tobacco_abv80 i.topprods_meds_abv80 ///
i.topprods_gaspetrol_abv80 i.topprods_phone_abv80 ///
labour_total space_cont, vce(robust)


*** CUSTOMERS

reg custom_total ///
i.topprods_rice_abv80 i.topprods_flour_abv80 i.topprods_eggs_abv80 i.topprods_noodles_abv80 i.topprods_oil_abv80 ///
i.topprods_saltsugar_abv80 i.topprods_bread_abv80 i.topprods_coffeetea_abv80 i.topprods_homecooked_abv80 ///
i.topprods_snacks_abv80 i.topprods_freshdrinks_abv80 i.topprods_softdrinks_abv80 i.topprods_sanitary_abv80 ///
i.topprods_cleaning_abv80 i.topprods_baby_abv80 i.topprods_tobacco_abv80 i.topprods_meds_abv80 ///
i.topprods_gaspetrol_abv80 i.topprods_phone_abv80 ///
labour_total space_cont, vce(robust)
*/

************************************************************************
***** Discussion topics ************************************************


***** Sales and profits, comp scores (calc and self-rep for sales, self-rep only for profits)

*** Sales, IHS-transformed and w/out transformation (both win at p99)

reg sales_mth_comp_all_win1_ln ///
i.discuss_sales i.discuss_sellprice i.discuss_bestseller ///
i.discuss_finance i.discuss_buyprice i.discuss_practice ///
i.discuss_bisplan ///
labour_total space_cont, vce(robust)

reg sales_mth_comp_all_win1 ///
i.discuss_sales i.discuss_sellprice i.discuss_bestseller ///
i.discuss_finance i.discuss_buyprice i.discuss_practice ///
i.discuss_bisplan ///
labour_total space_cont, vce(robust)


*** Profits, IHS-transformed and w/out transformation (both win at p99)

reg prof_mth_comp_rep_win1_ihs ///
i.discuss_sales i.discuss_sellprice i.discuss_bestseller ///
i.discuss_finance i.discuss_buyprice i.discuss_practice ///
i.discuss_bisplan ///
labour_total space_cont, vce(robust)

reg prof_mth_comp_rep_win1 ///
i.discuss_sales i.discuss_sellprice i.discuss_bestseller ///
i.discuss_finance i.discuss_buyprice i.discuss_practice ///
i.discuss_bisplan ///
labour_total space_cont, vce(robust)


***** Sales and profits, self-reported, on a normal day

reg sales_normday_win1_ln ///
i.discuss_sales i.discuss_sellprice i.discuss_bestseller ///
i.discuss_finance i.discuss_buyprice i.discuss_practice ///
i.discuss_bisplan ///
labour_total space_cont, vce(robust)

reg sales_normday_top7_win1_ln ///
i.discuss_sales i.discuss_sellprice i.discuss_bestseller ///
i.discuss_finance i.discuss_buyprice i.discuss_practice ///
i.discuss_bisplan ///
labour_total space_cont, vce(robust)

reg prof_normday_win1_ihs ///
i.discuss_sales i.discuss_sellprice i.discuss_bestseller ///
i.discuss_finance i.discuss_buyprice i.discuss_practice ///
i.discuss_bisplan ///
labour_total space_cont, vce(robust)


***** Customers

reg custom_total ///
i.discuss_sales i.discuss_sellprice i.discuss_bestseller ///
i.discuss_finance i.discuss_buyprice i.discuss_practice ///
i.discuss_bisplan ///
labour_total space_cont, vce(robust)



************************************************************************
***** Decision making topics ************************************************


***** Sales and profits, comp scores (calc and self-rep for sales, self-rep only for profits)

*** Sales, IHS-transformed and w/out transformation (both win at p99)

reg sales_mth_comp_all_win1_ln ///
i.jointdec_sales i.jointdec_sellprice i.jointdec_bestseller ///
i.jointdec_finance i.jointdec_buyprice i.jointdec_newprod ///
i.jointdec_practice i.jointdec_bisplan ///
labour_total space_cont, vce(robust)

reg sales_mth_comp_all_win1 ///
i.jointdec_sales i.jointdec_sellprice i.jointdec_bestseller ///
i.jointdec_finance i.jointdec_buyprice i.jointdec_newprod ///
i.jointdec_practice i.jointdec_bisplan ///
labour_total space_cont, vce(robust)


*** Profits, IHS-transformed and w/out transformation (both win at p99)

reg prof_mth_comp_rep_win1_ihs ///
i.jointdec_sales i.jointdec_sellprice i.jointdec_bestseller ///
i.jointdec_finance i.jointdec_buyprice i.jointdec_newprod ///
i.jointdec_practice i.jointdec_bisplan ///
labour_total space_cont, vce(robust)

reg prof_mth_comp_rep_win1 ///
i.jointdec_sales i.jointdec_sellprice i.jointdec_bestseller ///
i.jointdec_finance i.jointdec_buyprice i.jointdec_newprod ///
i.jointdec_practice i.jointdec_bisplan ///
labour_total space_cont, vce(robust)


***** Sales and profits, self-reported, on a normal day
reg sales_normday_win1_ln ///
i.jointdec_sales i.jointdec_sellprice i.jointdec_bestseller ///
i.jointdec_finance i.jointdec_buyprice i.jointdec_newprod ///
i.jointdec_practice i.jointdec_bisplan ///
labour_total space_cont, vce(robust)

reg sales_normday_top7_win1_ln ///
i.jointdec_sales i.jointdec_sellprice i.jointdec_bestseller ///
i.jointdec_finance i.jointdec_buyprice i.jointdec_newprod ///
i.jointdec_practice i.jointdec_bisplan ///
labour_total space_cont, vce(robust)

reg prof_normday_win1_ihs ///
i.jointdec_sales i.jointdec_sellprice i.jointdec_bestseller ///
i.jointdec_finance i.jointdec_buyprice i.jointdec_newprod ///
i.jointdec_practice i.jointdec_bisplan ///
labour_total space_cont, vce(robust)


***** Customers

reg custom_total ///
i.jointdec_sales i.jointdec_sellprice i.jointdec_bestseller ///
i.jointdec_finance i.jointdec_buyprice i.jointdec_newprod ///
i.jointdec_practice i.jointdec_bisplan ///
labour_total space_cont, vce(robust)


************************************************************************
***** Discussion and decision-making partners ***************************


***** Sales and profits, comp scores (calc and self-rep for sales, self-rep only for profits)

*** Sales, IHS-transformed and w/out transformation (both win at p99)

reg sales_mth_comp_all_win1_ln ///
i.discuss_fam i.discuss_bisfriend ///
i.jointdec_any ///
labour_total space_cont, vce(robust)

reg sales_mth_comp_all_win1 ///
i.discuss_fam i.discuss_bisfriend ///
i.jointdec_any ///
labour_total space_cont, vce(robust)


* Profits, IHS-transformed and w/out transformation (both win at p99)

reg prof_mth_comp_rep_win1_ihs ///
i.discuss_fam i.discuss_bisfriend ///
i.jointdec_any ///
labour_total space_cont, vce(robust)

reg prof_mth_comp_rep_win1 ///
i.discuss_fam i.discuss_bisfriend ///
i.jointdec_any ///
labour_total space_cont, vce(robust)


***** Sales and profits, self-reported, on a normal day

reg sales_normday_win1_ln ///
i.discuss_fam i.discuss_bisfriend ///
i.jointdec_any ///
labour_total space_cont, vce(robust)

reg sales_normday_top7_win1_ln ///
i.discuss_fam i.discuss_bisfriend ///
i.jointdec_any ///
labour_total space_cont, vce(robust)

reg prof_normday_win1_ihs ///
i.discuss_fam i.discuss_bisfriend ///
i.jointdec_any ///
labour_total space_cont, vce(robust)


***** Customers

reg custom_total ///
i.discuss_fam i.discuss_bisfriend ///
i.jointdec_any ///
labour_total space_cont, vce(robust)



************************************************************************
***** Finances ************************************************


***** SALES AND PROFITS, COMP SCORE (calc and self-rep for sales, self-rep only for profits)

*** Sales, IHS-transformed and w/out transformation (both win at p99)

reg sales_mth_comp_all_win1_ln ///
i.credit_TC i.credit_TC_int ///
i.separatefin i.loan_obtained ///
labour_total space_cont, vce(robust)

reg sales_mth_comp_all_win1 ///
i.credit_TC i.credit_TC_int ///
i.separatefin i.loan_obtained ///
labour_total space_cont, vce(robust)


*** Profits, IHS-transformed and w/out transformation (both win at p99)

reg prof_mth_comp_rep_win1_ihs ///
i.credit_TC i.credit_TC_int ///
i.separatefin i.loan_obtained ///
labour_total space_cont, vce(robust)

reg prof_mth_comp_rep_win1 ///
i.credit_TC i.credit_TC_int ///
i.separatefin i.loan_obtained ///
labour_total space_cont, vce(robust)


***** SALES AND PROFITS, SELF-REPORTED, ON A NORMAL DAY

reg sales_normday_win1_ln ///
i.credit_TC i.credit_TC_int ///
i.separatefin i.loan_obtained ///
labour_total space_cont, vce(robust)

reg sales_normday_top7_win1_ln ///
i.credit_TC i.credit_TC_int ///
i.separatefin i.loan_obtained ///
labour_total space_cont, vce(robust)

reg prof_normday_win1_ihs ///
i.credit_TC i.credit_TC_int ///
i.separatefin i.loan_obtained ///
labour_total space_cont, vce(robust)


***** CUSTOMERS

reg custom_total ///
i.credit_TC i.credit_TC_int ///
i.separatefin i.loan_obtained ///
labour_total space_cont, vce(robust)

