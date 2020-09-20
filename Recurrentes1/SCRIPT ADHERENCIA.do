*SCRIPT ADHERENCIA 13_12_2018
* DESCARA REPORTE CARGA ADHERENCIA (SL)

*Borrar variables cargadas 
foreach b of varlist adh_entrega - adh_porcen{
replace `b'=. 
}




///////////SE TRABAJARA SOLO CON PARTICIPANTES RECLUTADOS
egen y = group(redcap_event_name), missing
sort folio redcap_event_name
**Extender estado 2
foreach v of var estados_2 {

   by folio:replace `v' = `v'[_n-1] if `v' >= .
   foreach v of var estados_2 {

   by folio:replace `v' = `v'[_N] if `v' >= .
}
     }
	 foreach v of var estados_2 {
	 replace `v'=0 if `v'==.
	 
	 }
	 **Extender estado 3
foreach v of var estados_3 {

   by folio:replace `v' = `v'[_n-1] if `v' >= .
   foreach v of var estados_3 {

   by folio:replace `v' = `v'[_N] if `v' >= .
}
     }
	 foreach v of var estados_3 {
	 replace `v'=0 if `v'==.
	 
	 }

keep if  estados_2==1

//////VACIOS
replace reg_past4=. if reg_past4==0 & reg_frasco1==0 & reg_past1==0 & reg_frasco2==0 & reg_frasco3==0
replace est_pas4=. if est_frasc3==0 & est_pas2==0 & est_frasc4==0  & est_pas3==0 & est_frasc5==0 & est_pas4==0


////////////////DETERNINACION DE ENTREGAS Y DEVOLUCIONES
///ENTREGAS

*Entrega visita 1
gen ent1=reg_calc2 if redcap_event_name=="evaluacion1_arm_1"
bysort folio : egen entrega1=max(ent1)

*Entrega visita 3
gen ent3=reg_calc2 if redcap_event_name=="evaluacion3_arm_1"
bysort folio : egen entrega3=max(ent3)

*Entrega visita 5
gen ent5=reg_calc2 if redcap_event_name=="evaluacion5_arm_1"
bysort folio : egen entrega5=max(ent5)

///DEVOLUCION

*Devolucion 1
gen devol1=est_pas4
replace devol1=est_pas3 if devol1==.
bysort folio : egen devol_1=max(devol1)

*Devolucion 3
gen devol3=reg_past4 if redcap_event_name=="evaluacion3_arm_1"
replace devol3=reg_past3 if devol3==. & redcap_event_name=="evaluacion3_arm_1"
bysort folio : egen devol_3=max(devol3)

*Devolucion 5
gen devol5=reg_past4 if redcap_event_name=="evaluacion5_arm_1"
replace devol5=reg_past3 if devol5==. & redcap_event_name=="evaluacion5_arm_1"
bysort folio : egen devol_5=max(devol5)


///////////////////FOLIOS COMPLETOS
gen COMPLETE_OK=1 if entrega1!=. & entrega3!=. & entrega5!=. & devol_3!=. & devol_1!=. & devol_5!=.


///////////////////FOLIOS CON DEVOLUCION
gen DEVOL_OK=1 if COMPLETE_OK!=1 & devol_1!=. 
replace DEVOL_OK=5 if devol_3!=.  & devol_5!=.  & devol_1==. 
replace DEVOL_OK=5 if devol_3==.  & devol_5!=.  & devol_1==.
replace DEVOL_OK=3 if devol_3!=.  & devol_5==.  & devol_1==. 
replace DEVOL_OK=4 if devol_3==.  & devol_5==.  & devol_1==.

///////////////////FOLIOS MISSING

gen MISSING_OK=1 if entrega1!=. & devol_3==. & entrega3==. & devol_5==. & entrega5==.  & devol_1==. 

gen REV=1 if DEVOL_OK==4 & MISSING_OK!=1 | DEVOL_OK!=4 & MISSING_OK==1


///////////CALCULAR PASTILLAS TOTALES ENTREGADAS POR PARTICIPANTES

destring frasco_antiguo, replace force
foreach v of varlist frasco_antiguo frascos_entregados_visita reg_pasabierto {
                 replace `v'=0 if `v'==.
				 }
gen pastotal=(frasco_antiguo+frascos_entregados_visita)*135 + reg_pasabierto

separate pastotal, by(y) veryshortlabel

foreach v of varlist pastotal1-pastotal3 {

   by folio:replace `v' = `v'[_n-1] if `v' >= .
   foreach v of varlist pastotal1-pastotal3 {

   by folio:replace `v' = `v'[_N] if `v' >= .
}
     }
	 foreach v of varlist pastotal1-pastotal3 {
	 replace `v'=0 if `v'==.	 
	 }
	
gen ent_parcial=pastotal1 + pastotal3 + pastotal2 if DEVOL_OK==1 | COMPLETE_OK==1
replace  ent_parcial=pastotal1 + pastotal2 if DEVOL_OK==5
replace  ent_parcial=pastotal1 if DEVOL_OK==3

gen ENTREGADAS=pastotal1 + pastotal3 + pastotal2


////////////CALCULAR PASTILLAS TOTALES CONSUMIDAS POR PARTICIPANTE
**Sum pastillas registro
***Calculo de pastillas en los frascos devueltos
foreach g of varlist reg_frasco1 - reg_past2 {
    replace `g'=0 if `g'==.
	}
***Calculo devolucion de pastillas
gen p_devol_r= reg_past1 + (reg_frasco2*135) 

**Sumatoria de la devolucion de estados

**Cambio de missing a cero
foreach g of varlist est_frasc3 - est_frasc5 {
    replace `g'=0 if `g'==.
	}
**Calculo de pastillas devueltas
gen p_dvol_e=est_pas2 +(est_frasc4*135)
replace p_dvol_e=0 if p_dvol_e==.


**Extender pastillas y frascos devueltos

gen frascos=reg_frasco1 + reg_frasco2 +reg_frasco3
replace frascos=est_frasc3 + est_frasc4 + est_frasc5 if redcap_event_name=="evaluacion1_arm_1"
gen pastillas=p_devol_r
replace pastillas=p_dvol_e if redcap_event_name=="evaluacion1_arm_1"

separate pastillas, by(y) veryshortlabel
separate frascos, by(y) veryshortlabel

foreach v of varlist pastillas1- frascos3 {

   by folio:replace `v' = `v'[_n-1] if `v' >= .
   foreach v of varlist pastillas1- frascos3 {

   by folio:replace `v' = `v'[_N] if `v' >= .
}
     }
	 foreach v of varlist pastillas1- frascos3 {
	 replace `v'=0 if `v'==.
	 
	 }
**Calculo pastillas y frascos devueltos por participante
gen past_devol=pastillas1 + pastillas2 + pastillas3 if DEVOL_OK==1 | COMPLETE_OK==1
replace  past_devol=pastillas2 + pastillas3 if DEVOL_OK==5
replace  past_devol=pastillas2 if DEVOL_OK==3

gen DEVUELTAS=pastillas1 + pastillas2 +pastillas3

gen chech_devol=1 if past_devol==DEVUELTAS
*gen fras_devol=frascos1 + frascos2 + frascos3

**Calculo ingesta
gen ingesta=ent_parcial-past_devol
replace ingesta=0 if ingesta==.

gen porcent=(ingesta/ent_parcial)*100
*replace porcent=. if ingesta/ent_parcial




/////////////////////////////////////FECHA PARTO


////////////CALCULO PARA INGESTA IDEAL, (4 CAPSULAS POR DIA DE PARTICIPACION EN EL ESTUDIO).
/*Para determinar esto, se considerará aquellos con devoluciones completas hasta la 5 visita, como tambien estado
tomando como tope del maximo de consumo estimado el numero efectivamente entregado de pastillas (entregadas)*/

**Extender fecha de parto y furop y calcular diferencia
bysort folio:egen F_ingreso=max(fecha_visita) if redcap_event_name=="evaluacion1_arm_1"
bysort folio:egen fecha_parto=max(parto_date1)
gen F_egreso=est_date1 if estado_5==1
replace  F_egreso=est_date2 if estado_5==3
replace  F_egreso=fecha_parto if estado_5==4 | estado_5==5
replace  F_egreso=est_date1 if estado_5==2

gen diasestudio=F_egreso-F_ingreso 

**Calculo de pastillas posiblemente consumidAS
gen inges_ideal=diasestudio*4

**DETERMINAR SI EL PARTICIPANTE TIENE FECHA DE EGRESO PARA CALCULAR CONSUMO ESTIMADO
gen complete=1 if diasestudio!=. 
**DETERINAR ADHERENCIA POR  DIAS DE ESTUDIOS
gen ADH_DATE=(ingesta/diasestudio)*100
replace ADH_DATE=. if past_devol==.


***Dejar solo evento 1
keep if redcap_event_name=="evaluacion1_arm_1"





////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////CALCULO DE ADHERENCIAS Y  VARIABLES DEL FORM ADHERENCIA /////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////
*PASTILLAS ENTREGADAS AL PARTICIPANTE
replace adh_entrega=ENTREGADAS
*PASTILLAS ENTREGADAS CON DEVOLUCION POSTERIOR A LA ENTREGA
rename  ent_parcial adh_entre_parcial
*PASTILLAS DEVUELTAS POR EL PARTICIPANTE
replace adh_devol=past_devol
*PASTILLAS CONSUMIDAS POR PARTICIPANTE
replace adh_consum=ingesta
*PORCENTAJE DE ADHERENCIA DEL PARTICIPANTE
replace adh_porcen= porcent
*Numero de pastillas que debiese consumir por dias de estudios
rename diasestudio adh_ideal
*PORCENTAJE DE ADHERENCIA DEL PARTICIPANTE POR DIAS DE PARTICIPACION
gen adh_porcen2=ADH_DATE
gen porcentaje_adherencia_complete=2
keep folio redcap_event_name estados_3 estado_5 adh_entrega adh_entre_parcial   adh_devol  adh_consum adh_porcen complete adh_ideal adh_porcen2  porcentaje_adherencia_complete
replace adh_porcen2=. if complete==.
drop complete

order  redcap_event_name  estados_3 estado_5  adh_entrega adh_entre_parcial   adh_devol  adh_consum adh_porcen adh_ideal adh_porcen2  porcentaje_adherencia_complete, after (folio)
compare adh_porcen adh_porcen2 if adh_porcen2!=.

regres adh_porcen adh_porcen2

*PENDIENTES

*DEJAR COMO MAXIMO LAS PASTILLAS ENTREGADAS EN ADHERENCIA IDEAL EN CASO QUE ESTA SEA INFERIOR AL CONSUMO.
*VER CASOS EN QUE LA ADHERENCIA NORMAL ES MAYOS A 100%


*export delimited folio redcap_event_name adh_entrega adh_devol adh_total adh_consum adh_porcen porcentaje_adherencia_complete adh_f_devol adh_porcen2 adh_ideal using "carga.csv"



*keep if adh_entre_parcial  < adh_devol
drop estados_3 estado_5

***Duplicados

drop if adh_porcen<0 & adh_porcen!=.

*drop if  folio ==7731 | folio ==8091 | folio ==9024 | folio ==8221 | folio ==8539 | folio==8380 |folio==7018 | folio==7060  | folio==7147   | folio==7566 | folio==7572  | folio==7608 | folio==7663  | folio==7919 | folio==7931 |folio==8172 | folio==8215
























