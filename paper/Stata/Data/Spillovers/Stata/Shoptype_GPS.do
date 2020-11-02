
set matsize 11000
clear all

cd "C:\Users\Julius\Dropbox\Indonesia\Multidim aspirations\Stata\"

do Data\merging_data.do

use Data\Analysis_data.dta, clear

set more off

local rn


* GPS and shoptype data for distances calculation in QGIS

export delimited shop_ID W1_gps_dec_long W1_gps_dec_lat W1_shoptype W1_tuksayur2 W1_rokok2 W1_gas2 W1_warung2 B BM BC BMC BT BMT BCT BMCT control treatgroup using "Data\Spillovers\Stata\W1_tuksayur_T.csv" if W1_tuksayur2==1 & control==0, replace
export delimited shop_ID W1_gps_dec_long W1_gps_dec_lat W1_shoptype W1_tuksayur2 W1_rokok2 W1_gas2 W1_warung2 B BM BC BMC BT BMT BCT BMCT control treatgroup using "Data\Spillovers\Stata\W1_rokok_T.csv" if W1_rokok2==1 & control==0, replace
export delimited shop_ID W1_gps_dec_long W1_gps_dec_lat W1_shoptype W1_tuksayur2 W1_rokok2 W1_gas2 W1_warung2 B BM BC BMC BT BMT BCT BMCT control treatgroup using "Data\Spillovers\Stata\W1_gas_T.csv" if W1_gas2==1 & control==0, replace
export delimited shop_ID W1_gps_dec_long W1_gps_dec_lat W1_shoptype W1_tuksayur2 W1_rokok2 W1_gas2 W1_warung2 B BM BC BMC BT BMT BCT BMCT control treatgroup using "Data\Spillovers\Stata\W1_warung_T.csv" if W1_warung2==1 & control==0, replace

export delimited shop_ID W1_gps_dec_long W1_gps_dec_lat W1_shoptype W1_tuksayur2 W1_rokok2 W1_gas2 W1_warung2 B BM BC BMC BT BMT BCT BMCT control treatgroup using "Data\Spillovers\Stata\W1_all_T.csv" if W1_gps_dec_long!=. & control==0, replace

export delimited shop_ID W1_gps_dec_long W1_gps_dec_lat W1_shoptype W1_tuksayur2 W1_rokok2 W1_gas2 W1_warung2 B BM BC BMC BT BMT BCT BMCT control treatgroup using "Data\Spillovers\Stata\W1_tuksayur_C.csv" if W1_tuksayur2==1 & control==1, replace
export delimited shop_ID W1_gps_dec_long W1_gps_dec_lat W1_shoptype W1_tuksayur2 W1_rokok2 W1_gas2 W1_warung2 B BM BC BMC BT BMT BCT BMCT control treatgroup using "Data\Spillovers\Stata\W1_rokok_C.csv" if W1_rokok2==1 & control==1, replace
export delimited shop_ID W1_gps_dec_long W1_gps_dec_lat W1_shoptype W1_tuksayur2 W1_rokok2 W1_gas2 W1_warung2 B BM BC BMC BT BMT BCT BMCT control treatgroup using "Data\Spillovers\Stata\W1_gas_C.csv" if W1_gas2==1 & control==1, replace
export delimited shop_ID W1_gps_dec_long W1_gps_dec_lat W1_shoptype W1_tuksayur2 W1_rokok2 W1_gas2 W1_warung2 B BM BC BMC BT BMT BCT BMCT control treatgroup using "Data\Spillovers\Stata\W1_warung_C.csv" if W1_warung2==1 & control==1, replace

export delimited shop_ID W1_gps_dec_long W1_gps_dec_lat W1_shoptype W1_tuksayur2 W1_rokok2 W1_gas2 W1_warung2 B BM BC BMC BT BMT BCT BMCT control treatgroup using "Data\Spillovers\Stata\W1_all_C.csv" if W1_gps_dec_long!=. & control==1, replace
