
********************************************************************************
************** 		RETAILERS INDONESIA PROJECT, 2016-2017 		****************
*
*
*						Master do file for baseline data
*
*
* Last edit: 31 08 2017, Julius
********************************************************************************


clear all
cls
set more off

cd "`c(pwd)'"




***** GENERATE AND LABEL VARS ***********************************************************

* Data management
do "do_datamanagement_2605_JR"


* Analysis
do "do_practices_regs_2605_JR"
