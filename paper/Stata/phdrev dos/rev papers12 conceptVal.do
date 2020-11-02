
set matsize 11000
clear all

cd "`c(pwd)'\"

do Data\merging_data.do

use Data\Analysis_data.dta, clear

set more off

local rn


/*matrix accum R = 	W1_asp12_shop_z W1_asp12_size W1_asp12_employee W1_asp12_customer W1_asp12_sales ///
					W1_asp_shop_z W1_asp_size W1_asp_employee W1_asp_customer ///
					W1_asp_prob W1_asp12_shop_z_prob W1_asp12_sales_prob ///
					W1_asp_cse W1_asp_seff W1_asp_loc W1_asp12_shop_z_cse W1_asp12_sales_cse, nocons dev
matrix R = corr(R)*/


corr(W1_asp12_shop_z W1_asp12_size W1_asp12_employee W1_asp12_customer W1_asp12_sales ///
	W1_asp_shop_z W1_asp_size W1_asp_employee W1_asp_customer ///
	W1_asp_prob  ///
	W1_asp_cse W1_asp_seff W1_asp_loc)
	

polychoric(W1_asp12_shop_z W1_asp12_size W1_asp12_employee W1_asp12_customer W1_asp12_sales ///
	W1_asp_shop_z W1_asp_size W1_asp_employee W1_asp_customer ///
	W1_imagine_fail W1_asp_yrs_fail ///
	W1_asp_cse W1_asp_seff W1_asp_loc)

*W1_asp12_shop_z_prob W1_asp12_sales_prob
*W1_asp12_shop_z_cse W1_asp12_sales_cse
