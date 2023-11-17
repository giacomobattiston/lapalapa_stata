/*******************************************************************************
*
*   PROJET     :    INFORMING RISK MIGRATION 
*                   (G.Battiston, L. Corno, E. La Ferrara)
*                   ____________________________________________________________
*                   ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
*   TITRE      :    00 - RUN ALL : NOT WORKING FROM NOW
*                   ____________________________________________________________
*                   ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ
*
********************************************************************************/

clear all
set more off
*ssc install cleanchars

*global main = "C:\Users\cloes_000\Dropbox\Lapa-Lapa\LuciaElianaGiacomo"
*global main = "/Users/giacomobattiston/Dropbox/Lapa-Lapa/LuciaElianaGiacomo"
*global main = "C:\Users\BattistonG\Dropbox\Lapa-Lapa\LuciaElianaGiacomo"
global main "C:\Users\BattistonG\Dropbox\ricerca_dropbox\Lapa-Lapa\LuciaElianaGiacomo"

global baseline = "${main}/do_files/00_baseline/"
global midline = "${main}/do_files/01_follow_up1/"
*global data = "${main}/data/"

*ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ*
*							 	01   CLEANING	- BASELINE							   *
*______________________________________________________________________________* 

do ${baseline}01_import_guinea_baseline_questionnaire.do
do ${baseline}02_cleaning_with_rigourous_cleaning.do
cleanchars , in("è")  out("") vname
cleanchars , in("é") out("") vname
do ${baseline}03_admin_data.do

*ØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØØ*
*							 	02    CLEANING	- MIDINE						   *
*______________________________________________________________________________* 

do ${midline}01_import_guinea_midline_questionnaire.do
do ${midline}02_cleaning_midline.do
do ${midline}03_id_correction.do
do ${midline}04_merge.do
