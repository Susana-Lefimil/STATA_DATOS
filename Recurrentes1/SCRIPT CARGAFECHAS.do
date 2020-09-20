/// Descargar REPORTE FECHAS

****Furop_mix
* keep if fecha_visita<= date("17/04/2017","DMY") & fecha_visita>= date("17/04/2017","DMY")
//keep if fecha_visita<= date("17/04/2017","DMY") 

replace est_date9=est_date8  if folio!=.
replace est_date9=est_date6 if est_date9==.
format est_date9 %dM_d,_CY

format %tdDD/NN/CCYY fecha_visita est_date6 est_date8 est_date9


*****Fecha probables


gen min10=70 if folio!=.
gen max13=104 if folio!=.
gen min18=123 if folio!=.
gen max18=129 if folio!=.
gen min24=168 if folio!=.
gen max28=196 if folio!=.
gen min32=221 if folio!=.
gen max32=227 if folio!=.
gen min35=245 if folio!=.
gen max37=259 if folio!=.

///por semanas

gen est_date12=est_date9 + min10 if folio!=.
gen est_date13=est_date9 + max13 if folio!=.
gen est_date14=est_date9 + min18 if folio!=.
gen est_date15=est_date9 + max18 if folio!=.
gen est_date16=est_date9 + min24 if folio!=.
gen est_date17=est_date9 + max28 if folio!=.
gen est_dates18=est_date9 + min32 if folio!=.
gen est_date19=est_date9 + max32 if folio!=.
gen est_date20=est_date9 + min35 if folio!=.
gen est_date21=est_date9 + max37 if folio!=.



format %tdDD/NN/CCYY est_date12 est_date13 est_date14 est_date15 est_date16 est_date17 est_dates18 est_date19 est_date20 est_date21 est_date9

keep folio redcap_event_name est_date9 est_date12 est_date13 est_date14 est_date15 est_date16 est_date17 est_dates18 est_date19 est_date20 est_date21 


