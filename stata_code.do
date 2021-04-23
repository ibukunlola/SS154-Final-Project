* Import the data from the Github repo
insheet using "https://raw.githubusercontent.com/asmaaalaa99/SS154-Final-Project/main/clean_data.csv", clear
save clean_data.dta, replace
* Generate the log population
gen log_population = ln(population_2019)
* Clear est to save results 
est clear  

* Generate summary stats 
estpost tabstat md_earn_wne_p6 log_population grad_debt_mdn first_gen married adm_rate sat_avg poverty_rate ln_median_hh_inc costt4_a ugds_white , c(stat) stat(sum mean sd min max n)
esttab, ///
 cells("sum(fmt(%13.0fc)) mean(fmt(%13.2fc)) sd(fmt(%13.2fc)) min max count") nonumber ///
  nomtitle nonote noobs label collabels("Sum" "Mean" "SD" "Min" "Max" "N")
esttab using "summary_stats.tex", replace ////
 cells("sum(fmt(%13.0fc)) mean(fmt(%13.2fc)) sd(fmt(%13.2fc)) min max count") nonumber ///
  nomtitle nonote noobs label booktabs f ///
  collabels("Sum" "Mean" "SD" "Min" "Max" "N")

  
* Build the regression model and save the results 

est clear
eststo: regress md_earn_wne_p6 log_population ln_median_hh_inc costt4_a ugds_white first_gen, robust
esttab using "regression_1.tex", replace  ///
 b(3) se(3) nomtitle label star(* 0.10 ** 0.05 *** 0.01) ///
 booktabs alignment(D{.}{.}{-1}) ///
 title(My very first basic regression table \label{reg1})   ///
 addnotes("Dependent variable: Deaths (norm.). A lot of endogeneity in this specification." "Data source: Our World in Data COVID-19 database.")
 esttab
 
* Create the residuals plot
rvfplot, yline(0)


* Generate the vif table 

est clear  
regress md_earn_wne_p6 log_population ln_median_hh_inc costt4_a ugds_white first_gen, robust
eststo: vif

mat A = `r(vif_1)', 1/`r(vif_1)' \ `r(vif_2)', 1/`r(vif_2)' \ `r(vif_3)', 1/`r(vif_3)' \ `r(vif_4)', 1/`r(vif_4)' \ `r(vif_5)', 1/`r(vif_5)'
mat B = A[1...,1]               // extract first column in order to compute mean
mat sm = J(rowsof(B),1,1)'*B    // sum of column elements
mat vifmean = sm/rowsof(B)      // compute VIF mean
mat A = A\ vifmean, .           // append A by vifmean
mat rownames A = `r(name_1)' `r(name_2)' `r(name_3)' `r(name_4)' `r(name_5)' "Mean VIF"
mat colnames A = VIF 1/VIF

frmttable using "vif_test.tex", statmat(A) sdec(2) varlabels tex fragment nocenter replace
