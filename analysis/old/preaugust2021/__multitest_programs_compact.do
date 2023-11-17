/*********************************
	FOR FWER COMPUTATIONS
*********************************/
/*------------------------------------------------------------------------------
program: 		fwer
			
description:

Required:

dep_vars() - This is the list of dependent variables that 
			 compose the family of variables being considered. 
			 Each variable represents a seperate regression to be estimated.
			 Multiple variable names (varlist) should be input.
			 
treatvar() - This is the name of the treatment dummy in the dataset.
			 This variable is common to all regression specifications 
			 in the family. 
             This option can be abbreviated as t().
			 One variable name (varname) should be input.
			 
Optional:

controls() - is a minimal list of controls, those which are common to all
             regression specifications. 
			 One or more variable names can be input (varlist).
			 IMPORTANT: If the regression specification is written
			 out manually, the controls can be introduced there and 
			 the controls argument can be left empty.

fisher     - If specified, a bootstrap approximation of 
             Fisher's exact p-values will be computed and
			 shown as well. Using this option is a good indicator 
			 that your fwer program is running correctly because the 
			 fisher p-values estimated by the program should approach 
			 the p-values estimated in stata as the number of permutations 
			 tends to infinity.

num_rep()  - the number of permutations, default is 100000.
------------------------------------------------------------------------------*/

cap program drop fwer

/* "Program define" creates a new program. In this case, the program's name is "fwer".
Think of this as similar to defining a new variable. Only if statements can be 
specified before the comma of the program. For example, fwer if female==1, etc. 
Nothing else should be specified before the comma. The syntax is described above. */

program define fwer
syntax 	[if], DEP_vars(varlist) Treatvar(varname) /*
		  */ [CONTROLS(varlist)  FISHER  NUM_rep(integer 100000)]   

	quietly {		

	**	REAL DATA
	*************
	/* 	calculate the real p-values */
	
		cap xtset trtmnt round

	/* Generate four empty columns to be filled in by the 
	_pval_table_get program (see next program). One row for each variable
	in the 'family'. */

		gen variable = ""
		gen coeff    = .
		gen std_err  = .
		gen p_values = .

		local line = 0
		foreach var of varlist `dep_vars' {
			local ++line
	    	_pval_table_get `controls' `if', real_values d(`var') t(`treatvar') p(p_values) line(`line')
       	}
		
		/*
		1. Sort outcomes y1,...,yM in order of decreasing significance
           (increasing p value), that is, such that p1 < p2 < ··· < pM .
        */
		tempvar base_order
		gen `base_order' = _n in 1/`: word count `dep_vars''
		gsort p_values

	** 	SIMULATED DATA
	******************

		tempvar 	treat_r 	/// synthetic treatment (independent on anything by construction)
					p_values_r	/// p-values on synthetic data
					p_min 		/// p-values_r sorted to match the ranking of real ones  
					p_fewer   	//  empirical p-values

		gen S = 0 // variable that will be used to get FWER corrected p-values
		if "`fisher'"!="" {
			gen S2 = 0 // variable used to get approx of Fisher exact p-values, **not** FWER corrected
		}
		*
		
		di as err "loop running (`num_rep')"

		
		forvalues i=1(1)`num_rep'{ // here starts the simulation
			
		/* 	simulate the data under the null of no treatment effect */
			perm_rand `treatvar', gen(`treat_r')	
		
			
			
		/* 	calculate p-values on synthetic data */
			sort `base_order'
			gen `p_values_r' = .
			
			
			local line = 0
			foreach var of varlist `dep_vars' {
				local ++line
		    	_pval_table_get `controls' `if', d(`var') t(`treat_r') p(`p_values_r') line(`line')
			}	
			*
			
			if "`fisher'"!="" {
				replace S2 = S2 + 1 if `p_values_r' < p_values // this will be **not** FWER corrected
			}

		/* 	keep track of # times the simulated p-values are smaller than the corresponding observed ones */			
			sort p_values			
			local countdown = `: word count `dep_vars''
			quietly gen `p_min' = `p_values_r'
			while `countdown' >= 1 {
				quietly replace `p_min' = min(`p_min',`p_min'[_n+1]) in `countdown'
				local --countdown
			}
			replace S = S + 1 if `p_min' < p_values
			
			
			drop	`treat_r'		///
					`p_values_r' 	///
					`p_min'
			
		} // end of the simulation
		*
		keep 	if variable != ""

	/*	get the simulated Fisher exact p-values, **not** FWER corrected */
		if "`fisher'"!="" {
			gen p_Fisher  = S2/`num_rep'
			local p_Fisher "p_Fisher"
		}
	/* 	compute empirical p-values */
		gen `p_fewer' = S/`num_rep'

*	/* 	get the FWER adjusted p-values, matching according to rank again */
		sort p_values
		gen p_FWER = `p_fewer'
		forvalues line = 1/`: word count `dep_vars'' {
			quietly replace p_FWER = max(p_FWER, p_FWER[`line'-1]) in `line'
		}
		*
		sort `base_order'

		keep 	variable   coeff   std_err   p_values   `p_Fisher'   p_FWER 
		order 	variable   coeff   std_err   p_values   `p_Fisher'   p_FWER

} //quietly

end

*==================================================================================
*==================================================================================

/*------------------------------------------------------------------------------
program: 		_pval_table_get

notes:			- for internal use. 
				- prefix "_" indicates that it affects the dataset one is using 
				  when it is invoked.
				
description:	
					it runs a regression of the 
					dependent variable specified in depvar() on a treatment variable
					specified in treatvar() and other control variables specified in
					varlist (default regression type is linear, ologit is used if the 
					dependent variable specifies so in a characteristic named _spec 
					associated with it).
					It uses the results from this regression to fill the values 
					in the line indicated in option line() of variables "variable", 
					"var_label", "coeff", "se", "`p_var'", which have to be created 
					before calling the program.
					
------------------------------------------------------------------------------*/

cap program drop _pval_table_get
program _pval_table_get // hardcoded vars: "coeff" "variable"
syntax [varlist (ts fv)] [if],      ///
				Depvar(varname) 	///
				Treatvar(varname)	///
				P_var(varname)		///
				line(integer) 		///
				[real_values]
				
/* locally save the _spec that is associated with the `depvar'
is the local _spec. Use 'help spec' to understand how char works. 
In this case the _spec in our model specification and if we want 
to assign a model specification to a dependent variable is would
be done like this:
char define `dep'[_spec] areg `dep' \`treatvar' `dep'_base $post_acquim_base $xbase $crparea_controls if round==2, a(did) clus(sid)
a backslash (\) can be used in front of ` to stop STATA 
from confusing it as a local
*/
	local _spec:	char `depvar'[_spec]
	
/* locally save the controls into a controls local. 
Recall the syntax: _pval_table_get `controls' `if', real_values d(`var') t(`treatvar') p(p_values) line(`line').
The controls compose the varlist i.e. what comes before the comma for the command. */

	local controls `varlist'

	quietly {
		cap xtset /* checks data are panel and sorts by panelvar timevar */	
				
		/* go for the requested regression type if a particular form is specified ,i.e., the char is not empty. 
		In most cases, setting the spec as described in the earlier step is advisable. */
		if "`_spec'" != "" {
			`_spec'
		}
		/* otherwise use linear regression. Not usually advisable! */
		else {
			reg `depvar' `treatvar' `controls' `if', robust
		}
		
		/* Creates a k*4 matrix where each row represents 
		one of the dependent variables considered in the 'family' of regressors. 
		See example below. Recall the 'line' local starts at 0 and increases by 
		one for each loop through one of the dependent variable in the 'family'.*/

		if "`real_values'"!="" {
			replace variable = "`depvar'" in `line'
       		replace coeff    = _b[`treatvar'] 	in `line'
       		replace std_err  = _se[`treatvar'] 	in `line'
			replace `p_var' = (2 * ttail(e(df_r), abs(_b[`treatvar']/_se[`treatvar']))) in `line'
		}
		else {
			replace `p_var' = (2 * ttail(e(df_r), abs(_b[`treatvar']/_se[`treatvar']))) in `line'
		}
	}
	*
end

/*------------------------------------------------------------------------------
program: 		perm_rand

notes:			- for internal use. 
				
description:
------------------------------------------------------------------------------*/

cap program drop perm_rand
program perm_rand, sortpreserve
syntax varname [, gen(name) replace]

	if "`gen'"=="" & "`replace'"=="" {
		di as error `"either option "gen(newvarname)" or "replace" must be specified."'
		exit 197	
	}
	*
	local x `varlist'
	local new `gen'

	quietly {
		tempname q r w y first
		
		bysort sid: gen `first' = 1 if _n == 1
		sort `first'
		g `q'=_n if `first'==1
		gen double `r' = uniform() if `first'==1
		gen double `w' = uniform() if `first'==1
		
		sort `r' `w'
		gen `y' = `x'[`q'] if `first'==1
		
		sort sid `first'
		bysort sid: replace `y' = `y'[1]
		
		if "`gen'"!="" {
			rename `y' `gen'
		}
		else if "`replace'" == "replace" {
			order `y', after(`x')
			drop `x'
			rename `y' `x'
		}
	}
	*
end


