/*** In Europe irregularly at the moment:
*in Europe, did not take a plane (student)
replace irregular_mig_eu_3=1 if mig_1_p=="EUROPE" & mig_6_p!=1 & missing(irregular_mig_eu_3)
replace source_info_mig_3=2 if mig_1_p=="EUROPE" & mig_6_p!=1 & missing(source_info_mig_3)
*Not in Europe (student)
replace irregular_mig_eu_3=0 if mig_1_p!="EUROPE" & missing(irregular_mig_eu_3)
replace source_info_mig_3=2 if mig_1_p!="EUROPE"  & missing(source_info_mig_3)
*in Europe by plane (student)
replace irregular_mig_eu_3=0 if mig_1_p=="EUROPE" & mig_6_p==1 & missing(irregular_mig_eu_3)
replace source_info_mig_3=2 if mig_1_p=="EUROPE" & mig_6_p==1 & missing(source_info_mig_3)

*in Europe, did not take a plane (contact)
replace irregular_mig_eu_3=1 if mig_1_contact_p=="EUROPE" & mig_6_contact_p!=1 & missing(irregular_mig_eu_3)
replace source_info_mig_3=3 if mig_1_contact_p=="EUROPE" & mig_6_contact_p!=1 & missing(source_info_mig_3)
*Not in Europe (contact)
replace irregular_mig_eu_3=0 if mig_1_contact_p!="EUROPE" & missing(irregular_mig_eu_3)
replace source_info_mig_3=3 if mig_1_contact_p!="EUROPE"  & missing(source_info_mig_3)
*in Europe by plane (contact)
replace irregular_mig_eu_3=0 if mig_1_contact_p=="EUROPE" & mig_6_contact_p==1 & missing(irregular_mig_eu_3)
replace source_info_mig_3=3 if mig_1_contact_p=="EUROPE" & mig_6_contact_p==1 & missing(source_info_mig_3)

*in Europe irregularly (comment phone files)
replace irregular_mig_eu_3=1 if continent_pf=="EUROPE" & irregular_mig_pf==1 & missing(irregular_mig_eu_3)
replace source_info_mig_3=5 if continent_pf=="EUROPE" & irregular_mig_pf==1 & missing(source_info_mig_3)


*** Abroad planning to reach Europe irregularly:
*Abroad, planning to reach Europe by boat (student)
replace irregular_mig_eu_3=1 if mig_14_p=="EUROPE" & mig_23_p==1 | mig_24_p==1 | mig_25_p==1 & missing(irregular_mig_eu_3)
replace source_info_mig_3=2 if mig_14_p=="EUROPE" & mig_23_p==1 | mig_24_p==1 | mig_25_p==1 & missing(source_info_mig_3)
*Not abroad on the way to Europe (student)
replace irregular_mig_eu_3=0 if mig_14_p!="EUROPE" & missing(irregular_mig_eu_3)
replace source_info_mig_3=2 if mig_14_p!="EUROPE" & missing(source_info_mig_3)

*Abroad, planning to reach Europe by boat (contact)
replace irregular_mig_eu_3=1 if mig_14_contact_p=="EUROPE" & mig_23_contact_p==1 | mig_24_contact_p==1 | mig_25_contact_p==1& missing(irregular_mig_eu_3)
replace source_info_mig_3=3 if mig_14_contact_p=="EUROPE" & mig_23_contact_p==1 | mig_24_contact_p==1 | mig_25_contact_p==1 & missing(source_info_mig_3)
*Not abroad on the way to Europe (contact)
replace irregular_mig_eu_3=0 if mig_14_contact_p!="EUROPE" & missing(irregular_mig_eu_3)
replace source_info_mig_3=3 if mig_14_contact_p!="EUROPE" & missing(source_info_mig_3)

*Not in Europe but planning to go irregularly (comment phone files)
replace irregular_mig_eu_3=1 if continent_pf!="EUROPE" & irregular_mig_pf==1 & missing(irregular_mig_eu_3)
replace source_info_mig_3=5 if continent_pf!="EUROPE" & irregular_mig_pf==1 & missing(source_info_mig_3)


*** In Guinea, planning to reach Europe without asking for a visa 
*In Guinea, planning to go to Europe, did not/will not ask for a visa (student)
replace irregular_mig_eu_3=1 if sec2_q5a_p=="EUROPE" & sec2_q10_a_p==2 & sec2_q10_c_p==2 & missing(irregular_mig_eu_3)
replace source_info_mig_3=2 if sec2_q5a_p=="EUROPE" & sec2_q10_a_p==2 & sec2_q10_c_p==2 & missing(source_info_mig_3)
*In Guinea, planning to go to Europe, did not/will not ask for a visa (student)
replace irregular_mig_eu_3=1 if sec2_q5a_contact_p=="EUROPE" & sec2_q10_a_contact_p==2 & sec2_q10_c_contact_p==2 & missing(irregular_mig_eu_3)
replace source_info_mig_3=3 if sec2_q5a_contact_p=="EUROPE" & sec2_q10_a_contact_p==2 & sec2_q10_c_contact_p==2 & missing(source_info_mig_3)
*/















