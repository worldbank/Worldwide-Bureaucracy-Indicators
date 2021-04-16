***********************************
*WORLD WIDE BUREAUCRACY INDICATORS VERSION 1.1, 2000-2018
*3c_export
*Called by 0_master.do
*Created by: Camilo Bohorquez-Penuela&Rong Shi(based on Pablo Suarez's do-files)
*Last Edit by: Turkan Mukhtarova
*First version: December 2016
*Latest version: November 2020
********************************************************************************


**** transforms the output indicators to wide format from long for publication
set more off

use "${Output}WWBI_v2.0_clean.dta",clear

* generate a encoded country ID variable for country codes
encode ccode, gen(cid)

duplicates drop ccode year, force
tsset cid year
	tsfill, full

* Transform all indicator names to indicator 1-indicator98 to allow for transformation from wide to long
rename pub_obs 					indicator1
rename pemp_obs 				indicator2
rename emp_obs 					indicator3
rename fullsample_obs 			indicator4
rename ps1 						indicator5
rename ps1_mal 					indicator6
rename ps1_fem 					indicator7
rename ps1_urb 					indicator8
rename ps1_rur 					indicator9
rename ps2 						indicator10
rename ps2_mal 					indicator11
rename ps2_fem 					indicator12
rename ps2_urb 					indicator13
rename ps2_rur 					indicator14
rename ps3 						indicator15
rename coefreg 					indicator16
rename coefreg_f 				indicator17
rename WPedu1 					indicator18
rename WPedu2 					indicator19
rename WPedu3 					indicator20
rename WPedu4 					indicator21
rename WPocup1 					indicator22
rename WPocup2 					indicator23
rename WPocup3 					indicator24
rename WPocup4 					indicator25
rename WPocup9 					indicator26
rename WPmale 					indicator27
rename WPfemale 				indicator28
rename diff_mean_0 				indicator29
rename diff_median_0 			indicator30
rename diff_mean_1 				indicator31
rename diff_median_1 			indicator32
rename cont_pub 				indicator33
rename cont_prv 				indicator34
rename hins_pub 				indicator35
rename hins_prv 				indicator36
rename ssec_pub 				indicator37
rename ssec_prv 				indicator38
rename union_pub 				indicator39
rename union_prv 				indicator40
rename female_0 				indicator41
rename age_mean_0 				indicator42
rename age_med_0 				indicator43
rename ed0_0 					indicator44
rename ed1_0 					indicator45
rename ed2_0 					indicator46
rename ed3_0 					indicator47
rename rur_0 					indicator48
rename female_1 				indicator49
rename age_mean_1 				indicator50
rename age_med_1 				indicator51
rename ed0_1 					indicator52
rename ed1_1 					indicator53
rename ed2_1 					indicator54
rename ed3_1 					indicator55
rename rur_1 					indicator56
rename psedu3 					indicator57
rename occup_1_pu 				indicator58
rename occup_2_pu 				indicator59
rename occup_3_pu 				indicator60
rename occup_4_pu 				indicator61
rename occup_9_pu 				indicator62
rename occup_1_pr		 		indicator63
rename occup_2_pr 				indicator64
rename occup_3_pr 				indicator65
rename occup_4_pr 				indicator66
rename occup_9_pr				indicator67
rename quintile_1_pu 			indicator68
rename quintile_2_pu 			indicator69
rename quintile_3_pu 			indicator70
rename quintile_4_pu 			indicator71
rename quintile_5_pu 			indicator72
rename quintile_1_pr 			indicator73
rename quintile_2_pr 			indicator74
rename quintile_3_pr 			indicator75
rename quintile_4_pr 			indicator76
rename quintile_5_pr 			indicator77
rename rwoccup_0_1 				indicator78
rename rwoccup_0_2 				indicator79
rename rwoccup_0_3 				indicator80
rename rwoccup_0_5 				indicator81
rename rwoccup_0_6 				indicator82
rename rwoccup_1_1 				indicator83
rename rwoccup_1_2 				indicator84
rename rwoccup_1_3 				indicator85
rename rwoccup_1_5 				indicator86
rename rwoccup_1_6 				indicator87
rename sample1 					indicator88
rename compratio_0 				indicator89
rename compratio_1 				indicator90
rename wage_gdp 				indicator91
rename wage_x 					indicator92
rename p 						indicator93
rename p_f 						indicator94
rename p_edu 					indicator95
rename p_occ 					indicator96
rename p_gender 				indicator97
rename	total_edu				indicator98
rename	paid_edu				indicator99
rename	formal_edu				indicator100
rename	edu_total				indicator101
rename	edu_paid				indicator102
rename	edu_formal				indicator103
rename	fem_edu					indicator104
rename	edu_fem					indicator105
rename	rur_edu					indicator106
rename	ed3_public_edu			indicator107
rename	ed3_private_edu			indicator108
rename	mean_age_public_edu		indicator109
rename	mean_age_private_edu	indicator110
rename	median_age_public_edu	indicator111
rename	median_age_private_edu	indicator112
rename	obs_emp_edu				indicator113
rename	obs_paid_edu			indicator114
rename	obs_pub_edu				indicator115
rename	total_hlt				indicator116
rename	paid_hlt				indicator117
rename	formal_hlt				indicator118
rename	hlt_total				indicator119
rename	hlt_paid				indicator120
rename	hlt_formal				indicator121
rename	fem_hlt					indicator122
rename	hlt_fem					indicator123
rename	rur_hlt					indicator124
rename	ed3_public_hlt			indicator125
rename	ed3_private_hlt			indicator126
rename	mean_age_public_hlt		indicator127
rename	mean_age_private_hlt	indicator128
rename	median_age_public_hlt	indicator129
rename	median_age_private_hlt	indicator130
rename	obs_emp_hlt				indicator131
rename	obs_paid_hlt			indicator132
rename	obs_pub_hlt				indicator133
rename	total_adm				indicator134
rename	paid_adm				indicator135
rename	formal_adm				indicator136
rename	fem_adm					indicator137
rename	rur_adm					indicator138
rename	ed3_public_adm			indicator139
rename	mean_age_public_adm		indicator140
rename	median_age_public_adm	indicator141
rename	obs_emp_adm				indicator142
rename	obs_paid_adm			indicator143
rename	obs_pub_adm				indicator144
rename	coefreg_cont_edu		indicator145
rename	p_cont_edu				indicator146
rename	coefreg_cont_hlt		indicator147
rename	p_cont_hlt				indicator148
rename	coefreg_f_edu			indicator149
rename	p_f_edu					indicator150
rename	coefreg_f_hlt			indicator151
rename	p_f_hlt					indicator152
rename	coefreg_fem_edu			indicator153
rename	p_fem_edu				indicator154
rename	coefreg_fem_hlt			indicator155
rename	p_fem_hlt				indicator156
rename	coefreg_mal_edu			indicator157
rename	p_mal_edu				indicator158
rename	coefreg_mal_hlt			indicator159
rename	p_mal_hlt				indicator160
rename	coefreg_gen_private_edu	indicator161
rename	p_gen_private_edu		indicator162
rename	coefreg_gen_private_hlt	indicator163
rename	p_gen_private_hlt		indicator164
rename	coefreg_gen_edu			indicator165
rename	p_gen_edu				indicator166
rename	coefreg_gen_hlt			indicator167
rename	p_gen_hlt				indicator168
rename	coefreg_gen_adm			indicator169
rename	p_gen_adm				indicator170
rename	cross_median_sengov		indicator171
rename	cross_median_judge		indicator172
rename	cross_median_doctor		indicator173
rename	cross_median_nurse		indicator174
rename	cross_median_economist	indicator175
rename	cross_median_university	indicator176
rename	cross_median_second		indicator177
rename	cross_median_primary	indicator178
rename	cross_median_police		indicator179
rename	comp_sengov				indicator180
rename	comp_judge				indicator181
rename	comp_doctor				indicator182
rename	comp_nurse				indicator183
rename	comp_economist			indicator184
rename	comp_university			indicator185
rename	comp_second				indicator186
rename	comp_primary			indicator187
rename	comp_police				indicator188
rename	cross_mean_sengov		indicator189
rename	cross_mean_judge		indicator190
rename	cross_mean_doctor		indicator191
rename	cross_mean_nurse		indicator192
rename	cross_mean_economist	indicator193
rename	cross_mean_university	indicator194
rename	cross_mean_second		indicator195
rename	cross_mean_primary		indicator196
rename	cross_mean_police		indicator197

gen ij = year*1000+cid

reshape long indicator, i(ij)

format %15s countryname sample world_region
format %12.0g _j

gen ik = cid*1000+_j

drop countryname ccode source source_exp sample world_region ij incgroup

* Transform from long to wide
reshape wide indicator, i(ik) j(year)

gen indicator = ""
	replace indicator = "pub_obs"					if _j==1
	replace indicator = "pemp_obs" 					if _j==2
	replace indicator = "emp_obs" 					if _j==3
	replace indicator = "fullsample_obs" 			if _j==4
	replace indicator = "ps1" 						if _j==5
	replace indicator = "ps1_mal" 					if _j==6
	replace indicator = "ps1_fem" 					if _j==7
	replace indicator = "ps1_urb" 					if _j==8
	replace indicator = "ps1_rur" 					if _j==9
	replace indicator = "ps2" 						if _j==10
	replace indicator = "ps2_mal" 					if _j==11
	replace indicator = "ps2_fem" 					if _j==12
	replace indicator = "ps2_urb" 					if _j==13
	replace indicator = "ps2_rur" 					if _j==14
	replace indicator = "ps3" 						if _j==15
	replace indicator = "coefreg" 					if _j==16
	replace indicator = "coefreg_f" 				if _j==17
	replace indicator = "WPedu1" 					if _j==18
	replace indicator = "WPedu2" 					if _j==19
	replace indicator = "WPedu3" 					if _j==20
	replace indicator = "WPedu4" 					if _j==21
	replace indicator = "WPocup1" 					if _j==22
	replace indicator = "WPocup2" 					if _j==23
	replace indicator = "WPocup3" 					if _j==24
	replace indicator = "WPocup4" 					if _j==25
	replace indicator = "WPocup9" 					if _j==26
	replace indicator = "WPmale" 					if _j==27
	replace indicator = "WPfemale" 					if _j==28
	replace indicator = "diff_mean_0" 				if _j==29
	replace indicator = "diff_median_0" 			if _j==30
	replace indicator = "diff_mean_1" 				if _j==31
	replace indicator = "diff_median_1" 			if _j==32
	replace indicator = "cont_pub" 					if _j==33
	replace indicator = "cont_prv" 					if _j==34
	replace indicator = "hins_pub" 					if _j==35
	replace indicator = "hins_prv" 					if _j==36
	replace indicator = "ssec_pub" 					if _j==37
	replace indicator = "ssec_prv" 					if _j==38
	replace indicator = "union_pub" 				if _j==39
	replace indicator = "union_prv" 				if _j==40
	replace indicator = "female_0" 					if _j==41
	replace indicator = "age_mean_0" 				if _j==42
	replace indicator = "age_med_0" 				if _j==43
	replace indicator = "ed0_0" 					if _j==44
	replace indicator = "ed1_0" 					if _j==45
	replace indicator = "ed2_0" 					if _j==46
	replace indicator = "ed3_0" 					if _j==47
	replace indicator = "rur_0" 					if _j==48
	replace indicator = "female_1" 					if _j==49
	replace indicator = "age_mean_1" 				if _j==50
	replace indicator = "age_med_1" 				if _j==51
	replace indicator = "ed0_1" 					if _j==52
	replace indicator = "ed1_1" 					if _j==53
	replace indicator = "ed2_1" 					if _j==54
	replace indicator = "ed3_1" 					if _j==55
	replace indicator = "rur_1" 					if _j==56
	replace indicator = "psedu3" 					if _j==57
	replace indicator = "occup_1_pu" 				if _j==58
	replace indicator = "occup_2_pu" 				if _j==59
	replace indicator = "occup_3_pu" 				if _j==60
	replace indicator = "occup_4_pu" 				if _j==61
	replace indicator = "occup_9_pu" 				if _j==62
	replace indicator = "occup_1_pr" 				if _j==63
	replace indicator = "occup_2_pr" 				if _j==64
	replace indicator = "occup_3_pr" 				if _j==65
	replace indicator = "occup_4_pr" 				if _j==66
	replace indicator = "occup_9_pr" 				if _j==67
	replace indicator = "quintile_1_pu" 			if _j==68
	replace indicator = "quintile_2_pu" 			if _j==69
	replace indicator = "quintile_3_pu" 			if _j==70
	replace indicator = "quintile_4_pu" 			if _j==71
	replace indicator = "quintile_5_pu" 			if _j==72
	replace indicator = "quintile_1_pr" 			if _j==73
	replace indicator = "quintile_2_pr" 			if _j==74
	replace indicator = "quintile_3_pr" 			if _j==75
	replace indicator = "quintile_4_pr"				if _j==76
	replace indicator = "quintile_5_pr" 			if _j==77
	replace indicator = "rwoccup_0_1" 				if _j==78
	replace indicator = "rwoccup_0_2" 				if _j==79
	replace indicator = "rwoccup_0_3"				if _j==80
	replace indicator = "rwoccup_0_5"				if _j==81
	replace indicator = "rwoccup_0_6" 				if _j==82
	replace indicator = "rwoccup_1_1" 				if _j==83
	replace indicator = "rwoccup_1_2" 				if _j==84
	replace indicator = "rwoccup_1_3" 				if _j==85
	replace indicator = "rwoccup_1_5" 				if _j==86
	replace indicator = "rwoccup_1_6" 				if _j==87
	replace indicator = "sample1" 					if _j==88
	replace indicator = "compratio_0" 				if _j==89
	replace indicator = "compratio_1" 				if _j==90
	replace indicator = "wage_gdp" 					if _j==91
	replace indicator = "wage_x" 					if _j==92
	replace indicator = "p" 						if _j==93
	replace indicator = "p_f" 						if _j==94
	replace indicator = "p_edu" 					if _j==95
	replace indicator = "p_occ" 					if _j==96
	replace indicator = "p_gender" 					if _j==97
	replace indicator = "total_edu" 				if _j==98
	replace indicator = "paid_edu" 					if _j==99
	replace indicator = "formal_edu" 				if _j==100
	replace indicator = "edu_total" 				if _j==101
	replace indicator = "edu_paid" 					if _j==102
	replace indicator = "edu_formal" 				if _j==103
	replace indicator = "fem_edu" 					if _j==104
	replace indicator = "edu_fem" 					if _j==105
	replace indicator = "rur_edu" 					if _j==106
	replace indicator = "ed3_public_edu"			if _j==107
	replace indicator = "ed3_private_edu" 			if _j==108
	replace indicator = "mean_age_public_edu" 		if _j==109
	replace indicator = "mean_age_private_edu" 		if _j==110
	replace indicator = "median_age_public_edu" 	if _j==111
	replace indicator = "median_age_private_edu" 	if _j==112
	replace indicator = "obs_emp_edu" 				if _j==113
	replace indicator = "obs_paid_edu" 				if _j==114
	replace indicator = "obs_pub_edu" 				if _j==115
	replace indicator = "total_hlt" 				if _j==116
	replace indicator = "paid_hlt" 					if _j==117
	replace indicator = "formal_hlt" 				if _j==118
	replace indicator = "hlt_total" 				if _j==119
	replace indicator = "hlt_paid" 					if _j==120
	replace indicator = "hlt_formal" 				if _j==121
	replace indicator = "fem_hlt" 					if _j==122
	replace indicator = "hlt_fem" 					if _j==123
	replace indicator = "rur_hlt" 					if _j==124
	replace indicator = "ed3_public_hlt" 			if _j==125
	replace indicator = "ed3_private_hlt" 			if _j==126
	replace indicator = "mean_age_public_hlt" 		if _j==127
	replace indicator = "mean_age_private_hlt" 		if _j==128
	replace indicator = "median_age_public_hlt" 	if _j==129
	replace indicator = "median_age_private_hlt" 	if _j==130
	replace indicator = "obs_emp_hlt" 				if _j==131
	replace indicator = "obs_paid_hlt" 				if _j==132
	replace indicator = "obs_pub_hlt"				if _j==133
	replace indicator = "total_adm" 				if _j==134
	replace indicator = "paid_adm" 					if _j==135
	replace indicator = "formal_adm" 				if _j==136
	replace indicator = "fem_adm" 					if _j==137
	replace indicator = "rur_adm" 					if _j==138
	replace indicator = "ed3_public_adm" 			if _j==139
	replace indicator = "mean_age_public_adm" 		if _j==140
	replace indicator = "median_age_public_adm" 	if _j==141
	replace indicator = "obs_emp_adm" 				if _j==142
	replace indicator = "obs_paid_adm" 				if _j==143
	replace indicator = "obs_pub_adm" 				if _j==144
	replace indicator = "coefreg_cont_edu" 			if _j==145
	replace indicator = "p_cont_edu" 				if _j==146
	replace indicator = "coefreg_cont_hlt" 			if _j==147
	replace indicator = "p_cont_hlt" 				if _j==148
	replace indicator = "coefreg_f_edu" 			if _j==149
	replace indicator = "p_f_edu" 					if _j==150
	replace indicator = "coefreg_f_hlt" 			if _j==151
	replace indicator = "p_f_hlt" 					if _j==152
	replace indicator = "coefreg_fem_edu" 			if _j==153
	replace indicator = "p_fem_edu" 				if _j==154
	replace indicator = "coefreg_fem_hlt" 			if _j==155
	replace indicator = "p_fem_hlt" 				if _j==156
	replace indicator = "coefreg_mal_edu" 			if _j==157
	replace indicator = "p_mal_edu" 				if _j==158
	replace indicator = "coefreg_mal_hlt" 			if _j==159
	replace indicator = "p_mal_hlt" 				if _j==160
	replace indicator = "coefreg_gen_private_edu" 	if _j==161
	replace indicator = "p_gen_private_edu" 		if _j==162
	replace indicator = "coefreg_gen_private_hlt" 	if _j==163
	replace indicator = "p_gen_private_hlt" 		if _j==164
	replace indicator = "coefreg_gen_edu" 			if _j==165
	replace indicator = "p_gen_edu" 				if _j==166
	replace indicator = "coefreg_gen_hlt" 			if _j==167
	replace indicator = "p_gen_hlt" 				if _j==168
	replace indicator = "coefreg_gen_adm" 			if _j==169
	replace indicator = "p_gen_adm" 				if _j==170
	replace indicator = "cross_median_sengov" 		if _j==171
	replace indicator = "cross_median_judge" 		if _j==172
	replace indicator = "cross_median_doctor" 		if _j==173
	replace indicator = "cross_median_nurse" 		if _j==174
	replace indicator = "cross_median_economist" 	if _j==175
	replace indicator = "cross_median_university" 	if _j==176
	replace indicator = "cross_median_second" 		if _j==177
	replace indicator = "cross_median_primary" 		if _j==178
	replace indicator = "cross_median_police" 		if _j==179
	replace indicator = "comp_sengov" 				if _j==180
	replace indicator = "comp_judge" 				if _j==181
	replace indicator = "comp_doctor" 				if _j==182
	replace indicator = "comp_nurse" 				if _j==183
	replace indicator = "comp_economist" 			if _j==184
	replace indicator = "comp_university" 			if _j==185
	replace indicator = "comp_second" 				if _j==186
	replace indicator = "comp_primary" 				if _j==187
	replace indicator = "comp_police" 				if _j==188
	replace indicator = "cross_mean_sengov" 		if _j==189
	replace indicator = "cross_mean_judge" 			if _j==190
	replace indicator = "cross_mean_doctor" 		if _j==191
	replace indicator = "cross_mean_nurse" 			if _j==192
	replace indicator = "cross_mean_economist" 		if _j==193
	replace indicator = "cross_mean_university" 	if _j==194
	replace indicator = "cross_mean_second" 		if _j==195
	replace indicator = "cross_mean_primary" 		if _j==196
	replace indicator = "cross_mean_police" 		if _j==197

**** Add indicator titles for final version
replace indicator = "Cross-country public sector pay comparison ratio, by occupation: Government economist (using mean)" if indicator == "cross_mean_economist"
replace indicator = "Cross-country public sector pay comparison ratio, by occupation: Government economist (using median)" if indicator == "cross_median_economist"
replace indicator = "Cross-country public sector pay comparison ratio, by occupation: Hospital doctor (using mean)" if indicator == "cross_mean_doctor"
replace indicator = "Cross-country public sector pay comparison ratio, by occupation: Hospital doctor (using median)" if indicator == "cross_median_doctor"
replace indicator = "Cross-country public sector pay comparison ratio, by occupation: Hospital nurse (using mean)" if indicator == "cross_mean_nurse"
replace indicator = "Cross-country public sector pay comparison ratio, by occupation: Hospital nurse (using median)" if indicator == "cross_median_nurse"
replace indicator = "Cross-country public sector pay comparison ratio, by occupation: Judge (using mean)" if indicator == "cross_mean_judge"
replace indicator = "Cross-country public sector pay comparison ratio, by occupation: Judge (using median)" if indicator == "cross_median_judge"
replace indicator = "Cross-country public sector pay comparison ratio, by occupation: Police officer (using mean)" if indicator == "cross_mean_police"
replace indicator = "Cross-country public sector pay comparison ratio, by occupation: Police officer (using median)" if indicator == "cross_median_police"
replace indicator = "Cross-country public sector pay comparison ratio, by occupation: Primary school teacher (using mean)" if indicator == "cross_mean_primary"
replace indicator = "Cross-country public sector pay comparison ratio, by occupation: Primary school teacher (using median)" if indicator == "cross_median_primary"
replace indicator = "Cross-country public sector pay comparison ratio, by occupation: Secondary school teacher (using mean)" if indicator == "cross_mean_second"
replace indicator = "Cross-country public sector pay comparison ratio, by occupation: Secondary school teacher (using median)" if indicator == "cross_median_second"
replace indicator = "Cross-country public sector pay comparison ratio, by occupation: Senior official (using mean)" if indicator == "cross_mean_sengov"
replace indicator = "Cross-country public sector pay comparison ratio, by occupation: Senior official (using median)" if indicator == "cross_median_sengov"
replace indicator = "Cross-country public sector pay comparison ratio, by occupation: University teacher (using mean)" if indicator == "cross_mean_university"
replace indicator = "Cross-country public sector pay comparison ratio, by occupation: University teacher (using median)" if indicator == "cross_median_university"
replace indicator = "Education workers, as a share of public formal employees" if indicator == "formal_edu"
replace indicator = "Education workers, as a share of public paid employees" if indicator == "paid_edu"
replace indicator = "Education workers, as a share of public total employees" if indicator == "total_edu"
replace indicator = "Female to male wage ratio in the private sector (using mean)" if indicator == "diff_mean_0"
replace indicator = "Female to male wage ratio in the private sector (using median)" if indicator == "diff_median_0"
replace indicator = "Female to male wage ratio in the public sector (using mean)" if indicator == "diff_mean_1"
replace indicator = "Female to male wage ratio in the public sector (using median)" if indicator == "diff_median_1"
replace indicator = "Females, as a share of private paid employees" if indicator == "female_0"
replace indicator = "Females, as a share of private paid employees by occupation: Clerks" if indicator == "occup_4_pr"
replace indicator = "Females, as a share of private paid employees by occupation: Elementary occupation" if indicator == "occup_9_pr"
replace indicator = "Females, as a share of private paid employees by occupation: Professionals" if indicator == "occup_2_pr"
replace indicator = "Females, as a share of private paid employees by occupation: Senior officials" if indicator == "occup_1_pr"
replace indicator = "Females, as a share of private paid employees by occupation: Technicians" if indicator == "occup_3_pr"
replace indicator = "Females, as a share of private paid employees by wage quintile: Quintile 1" if indicator == "quintile_1_pr"
replace indicator = "Females, as a share of private paid employees by wage quintile: Quintile 2" if indicator == "quintile_2_pr"
replace indicator = "Females, as a share of private paid employees by wage quintile: Quintile 3" if indicator == "quintile_3_pr"
replace indicator = "Females, as a share of private paid employees by wage quintile: Quintile 4" if indicator == "quintile_4_pr"
replace indicator = "Females, as a share of private paid employees by wage quintile: Quintile 5" if indicator == "quintile_5_pr"
replace indicator = "Females, as a share of public paid employees" if indicator == "female_1"
replace indicator = "Females, as a share of public paid employees by industry: Education" if indicator == "fem_edu"
replace indicator = "Females, as a share of public paid employees by industry: Health" if indicator == "fem_hlt"
replace indicator = "Females, as a share of public paid employees by industry: Public Administration" if indicator == "fem_adm"
replace indicator = "Females, as a share of public paid employees by occupation: Clerks" if indicator == "occup_4_pu"
replace indicator = "Females, as a share of public paid employees by occupation: Elementary occupation" if indicator == "occup_9_pu"
replace indicator = "Females, as a share of public paid employees by occupation: Professionals" if indicator == "occup_2_pu"
replace indicator = "Females, as a share of public paid employees by occupation: Senior officials" if indicator == "occup_1_pu"
replace indicator = "Females, as a share of public paid employees by occupation: Technicians" if indicator == "occup_3_pu"
replace indicator = "Females, as a share of public paid employees by wage quintile: Quintile 1" if indicator == "quintile_1_pu"
replace indicator = "Females, as a share of public paid employees by wage quintile: Quintile 2" if indicator == "quintile_2_pu"
replace indicator = "Females, as a share of public paid employees by wage quintile: Quintile 3" if indicator == "quintile_3_pu"
replace indicator = "Females, as a share of public paid employees by wage quintile: Quintile 4" if indicator == "quintile_4_pu"
replace indicator = "Females, as a share of public paid employees by wage quintile: Quintile 5" if indicator == "quintile_5_pu"
replace indicator = "Gender wage premium in the private sector, by industry: Education (compared to male paid employees)" if indicator == "coefreg_gen_private_edu"
replace indicator = "Gender wage premium in the private sector, by industry: Health (compared to male paid employees)" if indicator == "coefreg_gen_private_hlt"
replace indicator = "Gender wage premium in the public sector, by industry: Education (compared to male paid employees)" if indicator == "coefreg_gen_edu"
replace indicator = "Gender wage premium in the public sector, by industry: Health (compared to male paid employees)" if indicator == "coefreg_gen_hlt"
replace indicator = "Gender wage premium in the public sector, by industry: Public Administration (compared to male paid employees)" if indicator == "coefreg_gen_adm"
replace indicator = "Health workers, as a share of public formal employees" if indicator == "formal_hlt"
replace indicator = "Health workers, as a share of public paid employees" if indicator == "paid_hlt"
replace indicator = "Health workers, as a share of public total employees" if indicator == "total_hlt"
replace indicator = "Individuals with no Education as a share of private paid employees" if indicator == "ed0_0"
replace indicator = "Individuals with no Education as a share of public paid employees" if indicator == "ed0_1"
replace indicator = "Individuals with primary Education as a share of private paid employees" if indicator == "ed1_0"
replace indicator = "Individuals with primary Education as a share of public paid employees" if indicator == "ed1_1"
replace indicator = "Individuals with secondary Education as a share of private paid employees" if indicator == "ed2_0"
replace indicator = "Individuals with secondary Education as a share of public paid employees" if indicator == "ed2_1"
replace indicator = "Individuals with tertiary Education as a share of private paid employees" if indicator == "ed3_0"
replace indicator = "Individuals with tertiary Education as a share of private paid employees, by industry: Education" if indicator == "ed3_private_edu"
replace indicator = "Individuals with tertiary Education as a share of private paid employees, by industry: Health" if indicator == "ed3_private_hlt"
replace indicator = "Individuals with tertiary Education as a share of public paid employees" if indicator == "ed3_1"
replace indicator = "Individuals with tertiary Education as a share of public paid employees, by industry: Education" if indicator == "ed3_public_edu"
replace indicator = "Individuals with tertiary Education as a share of public paid employees, by industry: Health" if indicator == "ed3_public_hlt"
replace indicator = "Individuals with tertiary Education as a share of public paid employees, by industry: Public Administration" if indicator == "ed3_public_adm"
replace indicator = "Input dataset file name" if indicator == "sample1"
replace indicator = "Mean age of private paid employees" if indicator == "age_mean_0"
replace indicator = "Mean age of private paid employees, by industry: Education" if indicator == "mean_age_private_edu"
replace indicator = "Mean age of private paid employees, by industry: Health" if indicator == "mean_age_private_hlt"
replace indicator = "Mean age of public paid employees" if indicator == "age_mean_1"
replace indicator = "Mean age of public paid employees, by industry: Education" if indicator == "mean_age_public_edu"
replace indicator = "Mean age of public paid employees, by industry: Health" if indicator == "mean_age_public_hlt"
replace indicator = "Mean age of public paid employees, by industry: Public Administration" if indicator == "mean_age_public_adm"
replace indicator = "Median age of private paid employees" if indicator == "age_med_0"
replace indicator = "Median age of private paid employees, by industry: Education" if indicator == "median_age_private_edu"
replace indicator = "Median age of private paid employees, by industry: Health" if indicator == "median_age_private_hlt"
replace indicator = "Median age of public paid employees" if indicator == "age_med_1"
replace indicator = "Median age of public paid employees, by industry: Education" if indicator == "median_age_public_edu"
replace indicator = "Median age of public paid employees, by industry: Health" if indicator == "median_age_public_hlt"
replace indicator = "Median age of public paid employees, by industry: Public Administration" if indicator == "median_age_public_adm"
replace indicator = "Number of employed employees, by industry: Education" if indicator == "obs_emp_edu"
replace indicator = "Number of employed employees, by industry: Health" if indicator == "obs_emp_hlt"
replace indicator = "Number of employed employees, by industry: Public Administration" if indicator == "obs_emp_adm"
replace indicator = "Number of employed individuals" if indicator == "emp_obs"
replace indicator = "Number of paid employees" if indicator == "pemp_obs"
replace indicator = "Number of paid employees, by industry: Administration" if indicator == "obs_paid_adm"
replace indicator = "Number of paid employees, by industry: Education" if indicator == "obs_paid_edu"
replace indicator = "Number of paid employees, by industry: Health" if indicator == "obs_paid_hlt"
replace indicator = "Number of public paid employees" if indicator == "pub_obs"
replace indicator = "Number of public paid employees, by industry: Education" if indicator == "obs_pub_edu"
replace indicator = "Number of public paid employees, by industry: Health" if indicator == "obs_pub_hlt"
replace indicator = "Number of public paid employees, by industry: Public Administration" if indicator == "obs_pub_adm"
replace indicator = "Pay compression ratio in private sector (ratio of 90th/10th percentile earners)" if indicator == "compratio_0"
replace indicator = "Pay compression ratio in public sector (ratio of 90th/10th percentile earners)" if indicator == "compratio_1"
replace indicator = "Pay compression ratio in public sector, by occupation: Government economist (clerk as reference)" if indicator == "comp_economist"
replace indicator = "Pay compression ratio in public sector, by occupation: Hospital doctor (clerk as reference)" if indicator == "comp_doctor"
replace indicator = "Pay compression ratio in public sector, by occupation: Hospital nurse (clerk as reference)" if indicator == "comp_nurse"
replace indicator = "Pay compression ratio in public sector, by occupation: Judge (clerk as reference)" if indicator == "comp_judge"
replace indicator = "Pay compression ratio in public sector, by occupation: Police officer (clerk as reference)" if indicator == "comp_police"
replace indicator = "Pay compression ratio in public sector, by occupation: Primary school teacher (clerk as reference)" if indicator == "comp_primary"
replace indicator = "Pay compression ratio in public sector, by occupation: Secondary school teacher (clerk as reference)" if indicator == "comp_second"
replace indicator = "Pay compression ratio in public sector, by occupation: Senior officials (clerk as reference)" if indicator == "comp_sengov"
replace indicator = "Pay compression ratio in public sector, by occupation: University teacher (clerk as reference)" if indicator == "comp_university"
replace indicator = "Proportion of total employees with tertiary Education working in public sector" if indicator == "psedu3"
replace indicator = "Public Administration workers, as a share of public formal employees" if indicator == "formal_adm"
replace indicator = "Public Administration workers, as a share of public paid employees" if indicator == "paid_adm"
replace indicator = "Public Administration workers, as a share of public total employees" if indicator == "total_adm"
replace indicator = "Public sector employment, as a share of formal employment" if indicator == "ps3"
replace indicator = "Public sector employment, as a share of formal employment, by industry: Education" if indicator == "edu_formal"
replace indicator = "Public sector employment, as a share of formal employment, by industry: Health" if indicator == "hlt_formal"
replace indicator = "Public sector employment, as a share of paid employment" if indicator == "ps1"
replace indicator = "Public sector employment, as a share of paid employment by gender: Female" if indicator == "ps1_fem"
replace indicator = "Public sector employment, as a share of paid employment by gender: male" if indicator == "ps1_mal"
replace indicator = "Public sector employment, as a share of paid employment by location: rural" if indicator == "ps1_rur"
replace indicator = "Public sector employment, as a share of paid employment by location: urban" if indicator == "ps1_urb"
replace indicator = "Public sector employment, as a share of paid employment, by industry: Education" if indicator == "edu_paid"
replace indicator = "Public sector employment, as a share of paid employment, by industry: Health" if indicator == "hlt_paid"
replace indicator = "Public sector employment, as a share of total employment" if indicator == "ps2"
replace indicator = "Public sector employment, as a share of total employment by gender: Female" if indicator == "ps2_fem"
replace indicator = "Public sector employment, as a share of total employment by gender: male" if indicator == "ps2_mal"
replace indicator = "Public sector employment, as a share of total employment by location: rural" if indicator == "ps2_rur"
replace indicator = "Public sector employment, as a share of total employment by location: urban" if indicator == "ps2_urb"
replace indicator = "Public sector employment, as a share of total employment, by industry: Education" if indicator == "edu_total"
replace indicator = "Public sector employment, as a share of total employment, by industry: Health" if indicator == "hlt_total"
replace indicator = "Public sector female employment, as a share of paid employment by industry: Education" if indicator == "edu_fem"
replace indicator = "Public sector female employment, as a share of paid employment by industry: Health" if indicator == "hlt_fem"
replace indicator = "Public sector wage premium (compared to all private employees)" if indicator == "coefreg"
replace indicator = "Public sector wage premium (compared to formal wage employees)" if indicator == "coefreg_f"
replace indicator = "Public sector wage premium for females, by industry: Education (compared to paid wage employees)" if indicator == "coefreg_fem_edu"
replace indicator = "Public sector wage premium for females, by industry: Health (compared to paid wage employees)" if indicator == "coefreg_fem_hlt"
replace indicator = "Public sector wage premium for males, by industry: Education (compared to paid wage employees)" if indicator == "coefreg_mal_edu"
replace indicator = "Public sector wage premium for males, by industry: Health (compared to paid wage employees)" if indicator == "coefreg_mal_hlt"
replace indicator = "Public sector wage premium, by education level: No Education (compared to formal wage employees)" if indicator == "WPedu1"
replace indicator = "Public sector wage premium, by education level: Primary Education (compared to formal wage employees)" if indicator == "WPedu2"
replace indicator = "Public sector wage premium, by education level: Secondary Education (compared to formal wage employees)" if indicator == "WPedu3"
replace indicator = "Public sector wage premium, by education level: Tertiary Education (compared to formal wage employees)" if indicator == "WPedu4"
replace indicator = "Public sector wage premium, by gender: Female (compared to all private employees)" if indicator == "WPfemale"
replace indicator = "Public sector wage premium, by gender: Male (compared to all private employees)" if indicator == "WPmale"
replace indicator = "Public sector wage premium, by industry: Education (compared to all private employees)" if indicator == "coefreg_cont_edu"
replace indicator = "Public sector wage premium, by industry: Education (compared to formal wage employees)" if indicator == "coefreg_f_edu"
replace indicator = "Public sector wage premium, by industry: Health (compared to all private employees)" if indicator == "coefreg_cont_hlt"
replace indicator = "Public sector wage premium, by industry: Health (compared to formal wage employees)" if indicator == "coefreg_f_hlt"
replace indicator = "Public sector wage premium, by occupation: Clerks (compared to formal wage employees)" if indicator == "WPocup4"
replace indicator = "Public sector wage premium, by occupation: Elementary occupation (compared to formal wage employees)" if indicator == "WPocup9"
replace indicator = "Public sector wage premium, by occupation: Professionals (compared to formal wage employees)" if indicator == "WPocup2"
replace indicator = "Public sector wage premium, by occupation: Senior officials (compared to formal wage employees)" if indicator == "WPocup1"
replace indicator = "Public sector wage premium, by occupation: Technicians (compared to formal wage employees)" if indicator == "WPocup3"
replace indicator = "P-Value: Gender wage premium in the private sector, by industry: Education (compared to male paid employees)" if indicator == "p_gen_private_edu"
replace indicator = "P-Value: Gender wage premium in the private sector, by industry: Health (compared to male paid employees)" if indicator == "p_gen_private_hlt"
replace indicator = "P-Value: Gender wage premium in the public sector, by industry: Education (compared to male paid employees)" if indicator == "p_gen_edu"
replace indicator = "P-Value: Gender wage premium in the public sector, by industry: Health (compared to male paid employees)" if indicator == "p_gen_hlt"
replace indicator = "P-Value: Gender wage premium in the public sector, by industry: Public Administration (compared to male paid employees)" if indicator == "p_gen_adm"
replace indicator = "P-Value: Public sector wage premium (compared to all private employees)" if indicator == "p"
replace indicator = "P-Value: Public sector wage premium (compared to formal wage employees)" if indicator == "p_f"
replace indicator = "P-Value: Public sector wage premium for females, by industry: Education (compared to paid wage employees)" if indicator == "p_fem_edu"
replace indicator = "P-Value: Public sector wage premium for females, by industry: Health (compared to paid wage employees)" if indicator == "p_fem_hlt"
replace indicator = "P-Value: Public sector wage premium for males, by industry: Education (compared to paid wage employees)" if indicator == "p_mal_edu"
replace indicator = "P-Value: Public sector wage premium for males, by industry: Health (compared to paid wage employees)" if indicator == "p_mal_hlt"
replace indicator = "P-Value: Public sector wage premium, by education level (compared to formal wage employees)" if indicator == "p_edu"
replace indicator = "P-Value: Public sector wage premium, by gender (compared to all private employees)" if indicator == "p_gender"
replace indicator = "P-Value: Public sector wage premium, by industry: Education (compared to all private employees)" if indicator == "p_cont_edu"
replace indicator = "P-Value: Public sector wage premium, by industry: Education (compared to formal wage employees)" if indicator == "p_f_edu"
replace indicator = "P-Value: Public sector wage premium, by industry: Health (compared to all private employees)" if indicator == "p_cont_hlt"
replace indicator = "P-Value: Public sector wage premium, by industry: Health (compared to formal wage employees)" if indicator == "p_f_hlt"
replace indicator = "P-Value: Public sector wage premium, by occupation (compared to formal wage employees)" if indicator == "p_occ"
replace indicator = "Relative wage of Professionals (using clerk as reference) in private sector" if indicator == "rwoccup_0_2"
replace indicator = "Relative wage of Professionals (using clerk as reference) in public sector" if indicator == "rwoccup_1_2"
replace indicator = "Relative wage of Senior officials (using clerk as reference) in private sector" if indicator == "rwoccup_0_1"
replace indicator = "Relative wage of Senior officials (using clerk as reference) in public sector" if indicator == "rwoccup_1_1"
replace indicator = "Relative wage of Technicians (using clerk as reference) in private sector" if indicator == "rwoccup_0_3"
replace indicator = "Relative wage of Technicians (using clerk as reference) in public sector" if indicator == "rwoccup_1_3"
replace indicator = "Rural residents, as a share of private paid employees" if indicator == "rur_0"
replace indicator = "Rural residents, as a share of public paid employees" if indicator == "rur_1"
replace indicator = "Rural residents, as a share of public paid employees, by industry: Education" if indicator == "rur_edu"
replace indicator = "Rural residents, as a share of public paid employees, by industry: Health" if indicator == "rur_hlt"
replace indicator = "Rural residents, as a share of public paid employees, by industry: Public Administration" if indicator == "rur_adm"
replace indicator = "rwoccup_0_5" if indicator == "rwoccup_0_5"
replace indicator = "rwoccup_0_6" if indicator == "rwoccup_0_6"
replace indicator = "rwoccup_1_5" if indicator == "rwoccup_1_5"
replace indicator = "rwoccup_1_6" if indicator == "rwoccup_1_6"
replace indicator = "Sample size" if indicator == "fullsample_obs"
replace indicator = "Share of private paid employees with a contract" if indicator == "cont_prv"
replace indicator = "Share of private paid employees with Health insurance" if indicator == "hins_prv"
replace indicator = "Share of private paid employees with social security" if indicator == "ssec_prv"
replace indicator = "Share of private paid employees with union membership" if indicator == "union_prv"
replace indicator = "Share of public paid employees with a contract" if indicator == "cont_pub"
replace indicator = "Share of public paid employees with Health insurance" if indicator == "hins_pub"
replace indicator = "Share of public paid employees with social security" if indicator == "ssec_pub"
replace indicator = "Share of public paid employees with union membership" if indicator == "union_pub"
replace indicator = "Wage bill as a percentage of GDP" if indicator == "wage_gdp"
replace indicator = "Wage bill as a percentage of Public Expenditure" if indicator == "wage_x"


rename cid ccode
label var ccode "Country Code"
label var indicator "Indicator Name"

order ccode indicator, first

drop ik _j

rename ccode cid

decode cid, gen(ccode)

merge m:1 ccode using "${Input}country_codes.dta", assert(2 3) keep(3) nogen

order countryname ccode world_region incomegroup incgroup lending eu oecd indicator, first
drop cid

drop if indicator == "rwoccup_0_5"
drop if indicator == "rwoccup_0_6"
drop if indicator == "rwoccup_1_5"
drop if indicator == "rwoccup_1_6"
drop if indicator == "Input dataset file name"
drop if indicator == "lngdppc"

label var world_region "WB Region"
label var incgroup "WB Income Classifications"
label var lending "WB Lending Category"
label var eu "EU-27 Member State"
label var oecd "OECD-37 Member State"
label var indicator2000 "2000"
label var indicator2001 "2001"
label var indicator2002 "2002"
label var indicator2003 "2003"
label var indicator2004 "2004"
label var indicator2005 "2005"
label var indicator2006 "2006"
label var indicator2007 "2007"
label var indicator2008 "2008"
label var indicator2009 "2009"
label var indicator2010 "2010"
label var indicator2011 "2011"
label var indicator2012 "2012"
label var indicator2013 "2013"
label var indicator2014 "2014"
label var indicator2015 "2015"
label var indicator2016 "2016"
label var indicator2017 "2017"
cap label var indicator2018 "2018"

* tarnsform country code s that are different from WB approved nomanclature

	replace ccode = "COD" if countryname == "Congo, Dem. Rep."
	replace ccode = "ROU" if countryname == "Romania"
	replace ccode = "XKX" if countryname == "Kosovo"
	replace ccode = "TLS" if countryname == "Timor-Leste"
	replace ccode = "PSE" if countryname == "West Bank and Gaza"

	replace countryname = "São Tomé and Principe" if ccode == "STP"
	replace countryname = "Eswatini" if ccode == "SWZ"
	replace countryname = "Egypt, Arab Rep." if ccode == "EGY"


save "${Do}WWBI_V2.0_final.dta",replace

**** export the dataset to Excel
export excel countryname ccode world_region incgroup lending eu oecd indicator indicator2000 indicator2001 indicator2002 indicator2003 indicator2004 indicator2005 indicator2006 indicator2007 indicator2008 indicator2009 indicator2010 indicator2011 indicator2012 indicator2013 indicator2014 indicator2015 indicator2016 indicator2017 indicator2018 using "${Do}WWBI_v2.0.xlsx", firstrow(varlabels) sheet("WWBI Version 2.0") replace

**************************************************END*************************************************