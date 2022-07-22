// make sure you change to wherever the aux_cpi repo is stored in your machine
// In profile.do I set the global wb_dir in my computer for general use
global auxout c:\Users\wb327173\OneDrive - WBG\Downloads\ECA\GPWG\PIP_repo\
cd "${auxout}\aux_shp\"
*global dlw_dir "\\wbgfscifs01\GPWG-GMD\Datalib\GMD-DLW\Support\Support_2005_CPI\"
global path \\wbgfscifs01\GTSD\03.projects_corp\04.GPWG\04.GPWG_SM22\04.GPWG_SM22_QA\

// Calling the input

global auxout c:\Users\wb327173\OneDrive - WBG\Downloads\ECA\GPWG\PIP_repo\

tempfile data1                                     
import excel using "${path}\02.input\All Previous SP metadata@12.xlsx", first clear sheet("All_SP@1")
replace Countrycode = upper(trim(Countrycode))
replace Region = upper(trim(Region))
replace Type = upper(trim(Type))
drop if Countrycode=="CHN"

isid Countrycode Spell Type Release

duplicates drop Countrycode Spell Type, force //drop duplicates
drop Surveyname PPPyear lines1 lines2 lines3 CPIT1 CPIT0

drop if Countrycode=="BRA" & (Release=="AM2015" |Release=="AM2016" | Release=="AM2017" | Release=="AM2018" |Release=="SM2018")
drop if YearT0==.

//reset the mix update, welfshprosperity is not available anymore, use welfare
replace WelfareT0variable = "welfare" if WelfareT0variable=="welfshprosperity"
replace WelfareT1variable = "welfare" if WelfareT1variable=="welfshprosperity"
drop check- AG

cap noi datasignature confirm using "shp", strict
if (_rc) {
	datasignature set, reset saving("shp", replace)
	export delimited  "shp.csv" , replace
}