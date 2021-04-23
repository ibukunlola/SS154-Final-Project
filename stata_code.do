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

