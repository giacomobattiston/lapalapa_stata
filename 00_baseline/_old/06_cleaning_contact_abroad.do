
clear all

set more off
pause on

***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   0 - Parameters                                               
***_____________________________________________________________________________

*Lucia User
*global main "C:\Users\CornoL\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Data"

*Giacomo User
*global main "/Users/giacomobattiston/Dropbox/Lapa-Lapa/LuciaElianaGiacomo/Data"
*global main "C:\Users\BattistonG\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Data"

*Cloe User
global main "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo\Data"


***¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
***   1 - Importing the data                                               
***_____________________________________________________________________________

use "$main/output/baseline/identification", clear
merge 1:1 key using "$main/output/baseline/questionnaire_baseline_clean_rigourous_cleaning"

sort id_number
order id_number 

gen wrong_name1=.


foreach x in sec10_q1_1 sec10_q1_2{
replace `x'=lower(`x')

replace `x'= subinstr(`x',"ï","�",.)
replace `x'= subinstr(`x',"é","�",.)
replace `x'= subinstr(`x',"ç","�",.)
replace `x'= subinstr(`x',"ć","�",.)
replace `x'= subinstr(`x',"ö","�",.)
replace `x'= subinstr(`x',"É","�",.)
replace `x'= subinstr(`x',"è","�",.)
replace `x'= subinstr(`x',"ë","�",.)
replace `x'= subinstr(`x',"oî","�i",.)
replace `x'= subinstr(`x',"ė","�",.)
replace `x'=trim(`x')
}



order sec10_q1_1 sec10_q1_2 id_number
keep if sec10_q1_1!=""


// FIRST CONTACT 
#delimit ;

gen wrong_name==0 if 
gen wrong_name=0 if
id_number=="91101417" |
id_number=="91101435" |
id_number=="91102836" |
id_number=="91301948" |
id_number=="91400738" |
id_number=="91407922" |
id_number=="91410119" |
id_number=="9141018" |
id_number=="91411623" |
id_number=="91412020" |
id_number=="91412524" |
id_number=="91412529" |
id_number=="91425120" |
id_number=="91426536" |
id_number=="9142686" |
id_number=="9142844" |
id_number=="91430239" |
id_number=="91430629" |
id_number=="9149923" |
id_number=="9149928" |
id_number=="91505822" |
id_number=="9150584" |
id_number=="91506338" |
id_number=="91511214" |
id_number=="91526710" |
id_number=="91536315"|
id_number=="91546035"|
id_number=="91546039"|
id_number=="91548239"|
id_number=="91102022" |
id_number=="91421812" |
id_number=="91450216" |
id_number=="9149958" |
id_number=="91508621"
 ;


#delimit cr

replace sec10_q1_1="ousmane" if id_number=="91102513"
replace sec10_q1_2="mory tache" if id_number=="91102513"

replace sec10_q1_1="sow bouba" if id_number=="91104712"

replace sec10_q1_1="dorcas moweni" if id_number=="91104742"
replace sec10_q1_2="danielle moweni" if id_number=="91104742"

replace sec10_q1_1="aichal alasardi" if id_number=="91301015"

replace sec10_q1_1="bountouraby" if id_number=="91301026"

replace sec10_q1_1="marie sylla" if id_number=="91402628"
replace sec10_q1_2="youssouf" if id_number=="91402628"



replace sec10_q1_1="mayeni" if id_number=="91402634"
replace sec10_q1_2="mohamed" if id_number=="91402634"



replace sec10_q1_1="sonassa" if id_number=="91403934"

replace sec10_q1_1="mohamed" if id_number=="91405214"



replace sec10_q1_1="tasana camara" if id_number=="91405228"
replace sec10_q1_2="moussa camara" if id_number=="91405228"


replace sec10_q1_1="ma lamine ciss�" if id_number=="91406524"
replace sec10_q1_2="mali hawa" if id_number=="91406524"



replace sec10_q1_1="mohamed sacko" if id_number=="91407920"
replace sec10_q1_2="fatoumata bojan" if id_number=="91407920"


replace sec10_q1_1="oumar camara" if id_number=="91407941"
replace sec10_q1_2="ibrahim camara" if id_number=="91407941"


replace sec10_q1_1="oumar camara" if id_number=="9141201"
replace sec10_q1_2="oumar keita" if id_number=="9141201"


replace sec10_q1_1="abdoulaye" if id_number=="91415622"

replace sec10_q1_1="alpha bintou diallo" if id_number=="9141671"


replace sec10_q1_1="salematou bah" if id_number=="9142181"
replace sec10_q1_2="hawa diallo" if id_number=="9142181"

replace sec10_q1_1="amed wissoumo" if id_number=="91421814"

replace sec10_q1_1="adrien paulinho" if id_number=="91424838"

replace sec10_q1_1="manssa diallo" if id_number=="9142485"


replace sec10_q1_1="mohamed ayman" if id_number=="91425615"
replace sec10_q1_2="" if id_number=="91425615"

replace sec10_q1_1="sadialiou" if id_number=="91430237"
replace sec10_q1_2="alpha" if id_number=="91430237"


replace sec10_q1_1="bakoutoubo kader" if id_number=="9143243"
replace sec10_q1_1="karamba" if id_number=="9143243"

replace sec10_q1_2="" if id_number=="9143244"

replace sec10_q1_1="diakhouma" if id_number=="9144067"

replace sec10_q1_1="mamadou" if id_number=="91447634"

replace sec10_q1_1="mamoudou" if id_number=="91447637"
replace sec10_q1_2="mamady" if id_number=="91447637"


replace sec10_q1_1="oulematou ouley" if id_number=="91499234"
replace sec10_q1_2="" if id_number=="91499234"


replace sec10_q1_1="mimix" if id_number=="91499438"
replace sec10_q1_2="kourouma ouma" if id_number=="91499438"

replace sec10_q1_1="sally diallo" if id_number=="91500232"

replace sec10_q1_1="a�ssatou dalanda diallo" if id_number=="9150637"
replace sec10_q1_2="katy loos" if id_number=="9150637"



replace sec10_q1_1="aicha tata" if id_number=="91522039"

replace sec10_q1_1="" if id_number=="91522117"

replace sec10_q1_1="amara kaba" if id_number=="91526746"
replace sec10_q1_2="aminata drame" if id_number=="91526746"

replace sec10_q1_1="sadjo bah" if id_number=="91536317"
replace sec10_q1_2="mamadou falldou diallo" if id_number=="91536317"


replace sec10_q1_1="abdoulaye barry" if id_number=="91551314"
replace sec10_q1_2="hamidou barry" if id_number=="91551314"

replace sec10_q1_2="aboubacar kalissa" if id_number=="9141873"

replace sec10_q1_1="mohamed kadiatou" if id_number=="9149929"


replace sec10_q1_1="mohamed traor�" if id_number=="91505738"

replace sec10_q1_1="ibrahima diallo" if id_number=="9153636"
replace sec10_q1_2="zaid" if id_number=="9153636"




// SECOND CONTACT 
gen wrong_name2=


#delimit ;
replace wrong_name2=1 if
id_number=="9110363" |
id_number=="91106422" |
id_number=="91514832" |
id_number=="91516730" |
id_number=="91516922" |
id_number=="91106427" |
id_number=="91302627" |
id_number=="91302629" |
id_number=="91400743" |
id_number=="91402549" |
id_number=="91403937" |
id_number=="9140521" |
id_number=="91406634" |
id_number=="91407922" |
id_number=="91410119" |
id_number=="9141018" |
id_number=="91411623" |
id_number=="9141169";

replace wrong_name2=1 if
id_number=="91412524" |
id_number=="91414317" |
id_number=="9141672" |
id_number=="9142185" |
id_number=="91424224" |
id_number=="91424229" |
id_number=="91425145" |
id_number=="91425622" |
id_number=="91425641" |
id_number=="91425646" |
id_number=="91426531" |
id_number=="91426536" |
id_number=="91428422" |
id_number=="9142844" |
id_number=="91428447" |
id_number=="9143061" |
id_number=="91431927" | 
id_number=="91431938" |
id_number=="9143243" |
id_number=="91433045" |
id_number=="91433433" |
id_number=="91443317" |
id_number=="91443323" |
id_number=="91443336" |
id_number=="91450216" |
id_number=="91498948" |
id_number=="91498949" |
id_number=="91499029" |
id_number=="91499030" |
id_number=="91499134" |
id_number=="9149923" |
id_number=="9149929";

replace wrong_name2=1 if
id_number=="91499327" |
id_number=="91499910" |
id_number=="91504641" |
id_number=="91504828" |
id_number=="9150584" |
id_number=="91506338" |
id_number=="9150662" |
id_number=="91506620" |
id_number=="91508621" |
id_number=="91510028" |
id_number=="91513630" |
id_number=="91513643" |
id_number=="91514832" |
id_number=="91515019" |
id_number=="9152352" |
id_number=="91526749" |
id_number=="91537738" |
id_number=="91540432" |
id_number=="91540441" |
id_number=="91546035" |
id_number=="91548227" |
id_number=="91548229" |
id_number=="98603144" ;



rename sec10_q1_1 sec10_q1_1_baseline
rename sec10_q2_1 sec10_q1_1_baseline


gen good_outside1=. 
;

replace good_outside1=1 if
outside_contact_no==1 & wrong_name1==1 &
sec10_q5_1!="LE GUIUEE" & sec10_q5_1!="LA GUINNE" &
sec10_q5_1!="LA GUINEE" &
sec10_q5_1!="IA GUINEE" &
sec10_q5_1!="GUINE GGGUI"
;




sec10_q1_1
boro  mâarî
id_number
91418918


sec10_q1_1
mìsta sow

sec10_q1_2
sang😉ne

sec10_q1_2
rîch gaîng barrii

