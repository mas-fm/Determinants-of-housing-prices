/*define variables*/

generate traficpr=0
replace traficpr=1 if region==6
replace traficpr=1 if region==11
replace traficpr=1 if region==12

generate big_house=0
replace big_house=1 if sqrft>80

generate new_house=1 if age<5 | age==5
replace  new_house=0 if age >5

generate middle_age_house=1 if age>5 | age<15 | age==15
replace middle_age_house=0 if  age<5 | age>15 | age==5

generate old_house=1 if age>15
replace old_house=0 if age<15 | age==15

/*summarize variables*/

summarize sqrft price price_prsm age ipollution


/*we show that we have Heteroskedasticity in the model so we use robust*/

/*general model's regression.1*/

reg lprice sqrft traficpr ipollution houseframe age,robust

test sqrft traficpr ipollution houseframe age

/*general model's regression.2*/

reg lprice traficpr ipollution houseframe age big_house,robust

/*general model's regression.3*/

reg lprice sqrft traficpr ipollution houseframe age new_house old_house,robust


/*Heteroskedasticity.white_test*/

reg lprice sqrft traficpr ipollution houseframe age
predict lpricehat
predict uhat,res
gen lprice2=lpricehat*lpricehat
gen uhat2=uhat*uhat
reg uhat2 lpricehat lprice2



reg lprice sqrft traficpr ipollution houseframe age,robust


/*Heteroskedasticity.wls*/
reg lprice sqrft traficpr ipollution houseframe age
predict lpricehat
predict uhat,res
gen lprice2=lpricehat*lpricehat
gen uhat2=uhat*uhat

reg uhat2 lpricehat lprice2
predict h

count if h<=0

gen weight=1/h
reg lprice sqrft traficpr ipollution houseframe age [aweight=weight]

/*Endogeneity.RESET*/

reg lprice sqrft traficpr ipollution houseframe age,robust
predict yhat
generate yh2=yhat^2
generate yh3=yhat^3
reg lprice sqrft traficpr ipollution houseframe age yh2 yh3,robust
test (yh2=0) (yh3=0)





