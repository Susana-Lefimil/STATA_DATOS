
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                   Analisis de contenido de publicidad de TV sobre alimentos (2016)                                      //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

*FICHA CODIGO 1
keep f_idspot f_nombre f_marca0 f_marca1 f_marca2
keep f_idspot f_marca3 f_marca4 

foreach v of varlist especificar_otro - obs_llamada{
    tostring `v', replace force
}
foreach v of varlist especificar_otro - obs_llamada {
    replace `v'="" if `v'=="."
}

foreach v of varlist comt_comentario {
    replace `v' = subinstr(`v', "ñ", "n", .)
	replace `v' = subinstr(`v', "á", "a", .)
	replace `v' = subinstr(`v', "é", "e", .)
	replace `v' = subinstr(`v', "í", "i", .)
	replace `v' = subinstr(`v', "ó", "o", .)	
	replace `v' = subinstr(`v', "ú", "u", .)
	replace `v' = subinstr(`v', "à", "a", .)
	replace `v' = subinstr(`v', "è", "e", .)
	replace `v' = subinstr(`v', "ì", "i", .)
	replace `v' = subinstr(`v', "ò", "o", .)	
	replace `v' = subinstr(`v', "ù", "u", .)
	replace `v' = subinstr(`v', "Ñ", "N", .)
	replace `v' = subinstr(`v', "Á", "A", .)
	replace `v' = subinstr(`v', "É", "E", .)
	replace `v' = subinstr(`v', "Í", "I", .)
	replace `v' = subinstr(`v', "Ó", "O", .)	
	replace `v' = subinstr(`v', "Ú", "U", .)
	replace `v' = subinstr(`v', "À", "A", .)
	replace `v' = subinstr(`v', "È", "E", .)
	replace `v' = subinstr(`v', "Ì", "I", .)
	replace `v' = subinstr(`v', "Ò", "O", .)	
	replace `v' = subinstr(`v', "Ù", "U", .)
	replace `v' = subinstr(`v', "ü", "u", .)
	
	}
	foreach v of varlist comt_comentario {
	replace `v' = subinstr(`v', "Ã‰", "E", .)
	replace `v' = subinstr(`v', "Ã“", "O", .)
	replace `v' = subinstr(`v', "Ãš", "U", .)
	replace `v' = subinstr(`v', "Ã¡", "a", .)
	replace `v' = subinstr(`v', "Ã©", "e", .)
	replace `v' = subinstr(`v', "Ã­", "i", .)
    replace `v' = subinstr(`v', "Ã³", "o", .)
	replace `v' = subinstr(`v', "Ãº", "u", .)
	replace `v' = subinstr(`v', "Ã€", "A", .)
	replace `v' = subinstr(`v', "Ãˆ", "E", .)
	replace `v' = subinstr(`v', "ÃŒ", "I", .)
	replace `v' = subinstr(`v', "Ã™", "U", .)
	replace `v' = subinstr(`v', "Ã‘", "N", .)
	replace `v' = subinstr(`v', "Ã±", "n", .)
    replace `v' = subinstr(`v', "Ã¨", "e", .)
	replace `v' = subinstr(`v', "Ã¬", "i", .)
	
	replace `v' = subinstr(`v', "Ã²", "o", .)
	replace `v' = subinstr(`v', "Ã¹", "u", .)
	
	}
	foreach v of varlist comt_comentario {
	replace `v' = subinstr(`v', "Ã", "A", .)
	replace `v' = subinstr(`v', "Ã", "I", .)
	replace `v' = subinstr(`v', "Ã ", "a", .)
	replace `v' = subinstr(`v', "Ã", "i", .)
	replace `v' = subinstr(`v', "ï¿½", "", .)
	replace `v' = subinstr(`v', "Âª", "", .)
	replace `v' = subinstr(`v', "Â°", "", .)
	replace `v' = subinstr(`v', "Â´", "", .)
	replace `v' = subinstr(`v', "Â¡", "", .)
	replace `v' = subinstr(`v', "Â¿", "", .)
	
	replace `v' = subinstr(`v', "¡", "", .)
	replace `v' = subinstr(`v', "¿", "", .)
	replace `v' = subinstr(`v', "±", "", .)
	replace `v' = subinstr(`v', "‘", "", .)
	replace `v' = subinstr(`v', "€", "", .)
	replace `v' = subinstr(`v', "ˆ", "", .)
	replace `v' = subinstr(`v', "“", "", .)
	replace `v' = subinstr(`v', "´", "", .)
	replace `v' = subinstr(`v', "³", "", .)
	replace `v' = subinstr(`v', "'", "", .)
	replace `v' = subinstr(`v', "‰", "", .)
	replace `v' = subinstr(`v', "©", "", .)
	replace `v' = subinstr(`v', "", "", .)
	replace `v' = subinstr(`v', "", "", .)
	
	}

	foreach v of varlist comt_comentario {
	replace `v' = upper(`v')

	}

