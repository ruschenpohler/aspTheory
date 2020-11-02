
********************************************************************************
************** 		RETAILERS INDONESIA PROJECT, 2016-2018 		****************
*
*				            Spillover analyses
*		
********************************************************************************


set matsize 11000
clear all

cd "`c(pwd)'\"

set more off

local rn


***** Prepare spillover datasets

foreach x in 	gas rokok sayur warung {

				insheet using "Nearest N\Spillover_`x'Only.csv", clear

				rename inputid shop_ID
				rename distance dist_`x'
				label var dist_`x' "Distance to next `x' business (Kilometer)"
				
				* Simple "degrees to meters" work-around w/o loc-spec projection 
				replace dist_`x' = dist_`x' * 111.32
				
				drop targetid
				save	"Nearest N\Spillover_`x'Only_mod.dta", replace

				clear all

}

insheet using "Nearest N\Spillover_all.csv", clear

rename inputid shop_ID
rename distance dist_all
label var dist_all "Distance to next business of any type (Kilometer)"
replace dist_all = dist_all * 111.32
drop targetid
save	"Nearest N\Spillover_all_mod.dta", replace



***** Merge datasets

use	"Nearest N\Spillover_gasOnly_mod.dta"

foreach x in 	rokok sayur warung {

				merge 1:1 shop_ID using "Nearest N\Spillover_`x'Only_mod.dta"
				tab _m
				drop _m

}

merge 1:1 shop_ID using "Nearest N\Spillover_all_mod.dta"
tab _m
drop _m



***** Prepare variables

egen dist_types = rowmean(dist_gas dist_rokok dist_sayur dist_warung)


/***** Graphs


*** Distance of Control to Treated of Same Type

* Composite
sum dist_gas
histogram dist_gas, freq graphreg(color(white)) color(gs7) name(gas) width(0.05) nodraw ///
xaxis(1) ///
ylabel(0(5)30, grid) ///
xlabel(0(0.2)2.3, axis(1) grid gmax) ///
xtitle("Linear Distance to Next Gas Vendor (Kilometers)", axis(1))

sum dist_rokok
histogram dist_rokok, freq graphreg(color(white)) color(gs7) name(rokok) width(0.02) nodraw ///
xaxis(1) ///
ylabel(0(5)30, grid) ///
xlabel(0(0.2)0.8 /*6.39381 "6.4"*/, axis(1) grid gmax) ///
xtitle("Linear Distance to Next Tobacco Vendor (Kilometers)", axis(1))

sum dist_sayur
histogram dist_sayur, freq graphreg(color(white)) color(gs7) name(sayur) width(0.01) nodraw ///
xaxis(1) ///
ylabel(0(5)30, grid) ///
xlabel(0(0.2)0.5 /*8.19266 "8.2"*/, axis(1) grid gmax) ///
xtitle("Linear Distance to Next Fruit/Veg. Vendor (Kilometers)", axis(1))

sum dist_warung
histogram dist_warung, freq graphreg(color(white)) color(gs7) name(warung) width(0.02) nodraw ///
xaxis(1) ///
ylabel(0(5)30, grid) ///
xlabel(0(0.2)0.8 /*8.19266 "8.2"*/, axis(1) grid gmax) ///
xtitle("Linear Distance to Next Mom-and-Pop Store (Kilometers)", axis(1))

* Combine graphs
graph combine gas rokok sayur warung all, graphreg(color(white)) name(combined) ///
note("Linear Distance of Control Businesses to Next Treated Business of Same Type (Ordered by Type)")
graph export "figure_1.pdf", name(combined) replace

*/


/*** Overlaid histograms

twoway(histogram dist_gas, frac graphreg(color(white)) color(gs7) width(0.015) ///
xaxis(1) ///
ylabel(0(0.05)0.15, grid) ///
xlabel(0(0.2)2.3, axis(1) grid gmax)) ///
(histogram dist_rokok, frac graphreg(color(white)) color(gs7) width(0.015) ///
xaxis(1) ///
ylabel(0(0.05)0.15, grid) ///
xlabel(0(0.2)2.3 /*6.39381 "6.4"*/, axis(1) grid gmax)) ///
(histogram dist_sayur, frac graphreg(color(white)) color(gs7) width(0.015) ///
xaxis(1) ///
ylabel(0(0.05)0.15, grid) ///
xlabel(0(0.2)2.3 /*8.19266 "8.2"*/, axis(1) grid gmax)) ///
(histogram dist_warung, frac graphreg(color(white)) color(gs7) width(0.015) ///
xaxis(1) ///
ylabel(0(0.05)0.15, grid) ///
xlabel(0(0.2)2.3 /*8.19266 "8.2"*/, axis(1) grid gmax)) ///
(histogram dist_all, frac graphreg(color(white)) fcolor(none) lcolor(black) width(0.015) ///
xaxis(1) ///
ylabel(0(0.05)0.15, grid) ///
xlabel(0(0.2)2.3 /*8.19266 "8.2"*/, axis(1) grid gmax)) , legend(order(1 "Only Gas Sellers" 2 "Only Tobacco Sellers" 3 "Only Fruits/Veg" 4 "Only Mom-and-Pop" 5 "All Businesses" ))

*/


*** Distance of Control to Treated of Any Type

* Mean dist: all 85.52 meters, types 136.38 meters
sum dist_all dist_types
* Under 30 meters lin dist: all 48, types, 15
count if dist_all<0.03
count if dist_types<0.03
twoway(histogram dist_all, frac graphreg(color(white)) color(gs7) width(0.02) ///
xaxis(1) ///
ylabel(0(0.05)0.25, grid) ///
xlabel(0(0.1)1, axis(1) grid gmax)) ///
(histogram dist_types, frac graphreg(color(white)) fcolor(none) lcolor(black) width(0.02) ///
xaxis(1) subtitle("Linear Distance of Control Businesses to Next Treated Business") ///
ylabel(0(0.05)0.25, grid) ///
xlabel(0(0.1)1, axis(1) grid gmax) ///
xtitle("Linear Distance in Kilometers", axis(1))) , legend(order(1 "Next Treated" 2 "Next Treated of Same Type"))



/*

 Composite
sum dist_gas
histogram dist_gas if dist_gas<2300, freq graphreg(color(white)) color(gs7) name(gas) width(50) nodraw ///
xaxis(1) ///
ylabel(0(20)100, grid) ///
xlabel(0 "0" 200 "0.2" 400 "0.4" 600 "0.6" 800 "0.8" 1000 "1" 1200 "1.2" 1400 "1.4" 1600 "1.6" /*20 "20" 2270.766 "2270"*/, axis(1) grid gmax) ///
xtitle("Linear Distance to Next Gas Vendor (in 1,000 Meters)", axis(1))

sum dist_rokok
histogram dist_rokok if dist_rokok!=0, frac graphreg(color(white)) color(gs7) name(rokok) width(20) nodraw ///
xaxis(1) ///
ylabel(0(0.1).2, grid) ///
xlabel(0(100)800 /*6.39381 "6.4"*/, axis(1) grid gmax) ///
xtitle("Linear Distance to Next Tobacco Vendor (Meters)", axis(1))

sum dist_sayur
histogram dist_sayur, frac graphreg(color(white)) color(gs7) name(sayur) width(10) nodraw ///
xaxis(1) ///
ylabel(0(0.1).1, grid) ///
xlabel(0(100)500 /*8.19266 "8.2"*/, axis(1) grid gmax) ///
xtitle("Linear Distance to Next Fruit/Veg. Vendor (Meters)", axis(1))

sum dist_warung
histogram dist_warung, frac graphreg(color(white)) color(gs7) name(warung) width(20) nodraw ///
xaxis(1) ///
ylabel(0(0.1).1, grid) ///
xlabel(0(100)800 /*8.19266 "8.2"*/, axis(1) grid gmax) ///
xtitle("Linear Distance to Next Mom-and-Pop Store (Meters)", axis(1))

* Combine graphs
graph combine gas rokok sayur warung, graphreg(color(white)) name(alltypes) ///
note("")
graph export "figure_1.pdf", name(alltypes) replace










*** Save dataset
save "Nearest N\Spillover_sameOnly.dta", replace



