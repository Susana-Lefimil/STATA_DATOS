///Descarga reporte llamado "CARGAS VISITAS (SL)"

///Generacion visitas realizadas 
gen visitah1=1 if redcap_event_name=="evaluacion1_arm_1" & fecha_visita!=.
gen visitah2=1 if redcap_event_name=="evaluacion2__llama_arm_1" & fecha_visita!=.
gen visitah3=1 if redcap_event_name=="evaluacion3_arm_1" & fecha_visita!=.
gen visitah4=1 if redcap_event_name=="evaluacion4_llamad_arm_1" & fecha_visita!=.
gen visitah5=1 if redcap_event_name=="evaluacion5_arm_1" & fecha_visita!=.

bysort folio:egen vistalista1=max(visitah1) if folio!=.
bysort folio:egen vistalista2=max(visitah2) if folio!=.
bysort folio:egen vistalista3=max(visitah3) if folio!=.
bysort folio:egen vistalista4=max(visitah4) if folio!=.
bysort folio:egen vistalista5=max(visitah5) if folio!=.

keep if redcap_event_name=="evaluacion1_arm_1"

// Descarte estados no activos
format %tdDD/NN/CCYY  fecha_visita est_date9 est_date12 est_date13 est_date14 est_date15 est_date16 est_date17 est_dates18 est_date19 est_date20 est_date21
drop  visitah1 visitah2 visitah3 visitah4 visitah5 redcap_event_name
drop if  estados_2>=2 




***Generar fecha
gen fecha1=c(current_date) if folio!=.
gen fechamin=date(fecha1,"DMY") if folio!=.

gen fecha2=c(current_date) if folio!=.
gen fechamax=date(fecha2,"DMY") if folio!=.

format %tdDD/NN/CCYY  fecha_visita est_date9 est_date12 est_date13 est_date14 est_date15 est_date16 est_date17 est_dates18 est_date19 est_date20 est_date21

***************Correr script hasta aca*******************************

//// Actualizar fechas dentro de una semana (Min el dia maximo anterior y maximo tomar una semana en adelante solo para verificar que no se quede alguna visita afuera)
****Ingresar fechas hasta aca
replace fechamin = date("01/02/2019","DMY") if folio!=.
replace fechamax = date("15/02/2019","DMY") if folio!=.

////Generar si tiene visita
****Primera visita
gen primeravisita=1 if est_date12>=fechamin & est_date12<=fechamax
replace primeravisita=1 if est_date13>=fechamin & est_date13<=fechamax
****llamada2/visita2 para random
gen llamada2=1 if est_date14>=fechamin & est_date14<=fechamax
replace llamada2=1 if est_date15>=fechamin & est_date15<=fechamax
****Tercera visita
gen tervisita=1 if est_date16>=fechamin & est_date16<=fechamax
replace tervisita=1 if est_date17>=fechamin & est_date17<=fechamax
****llamada4
gen llamada4=1 if est_dates18>=fechamin & est_dates18<=fechamax
replace llamada4=1 if est_date19>=fechamin & est_date19<=fechamax
****Quinta visita
gen quintavisita=1  if est_date20 >=fechamin & est_date20 <=fechamax
replace quintavisita=1  if est_date21 >=fechamin & est_date21 <=fechamax

////Valores a la variable
label define visita 1 "Si" 
label values primeravisita llamada2 llamada4 tervisita quintavisita visita
keep  folio  estados_3  fecha_visita est_date9 est_date12 est_date13 est_date14 est_date15 est_date16 est_date17 est_dates18 est_date19 est_date20 est_date21 primeravisita llamada2 llamada4 tervisita quintavisita  randomizacion cesfam   vistalista1 vistalista2 vistalista3 vistalista4 vistalista5 cont_v
///Solo activas
keep if estados_3==1 | estados_3==4  
keep if  primeravisita==1| llamada2==1 | tervisita==1 | llamada4==1 | quintavisita==1

////orden Visita No se considera esta seccion en la carga final de visitas

gen visita=1 if primeravisita==1
replace visita=2 if  llamada2==1
replace visita=3 if  tervisita==1
replace visita=4 if  llamada4==1
replace visita=5 if  quintavisita==1
/// orden fecha
gen fechaminima= est_date12 if primeravisita==1
replace fechaminima=  est_date14 if llamada2==1
replace fechaminima=  est_date16 if tervisita==1
replace fechaminima= est_dates18 if llamada4==1
replace fechaminima=  est_date20 if quintavisita==1

gen fechamaxima=  est_date13 if primeravisita==1
replace fechamaxima=   est_date15 if llamada2==1
replace fechamaxima=   est_date17 if tervisita==1
replace fechamaxima=  est_date19 if llamada4==1
replace fechamaxima=   est_date21 if quintavisita==1
format %tdDD/NN/CCYY fechaminima fechamaxima 



///Descarte visitas realizadas No se considera esta seccion en la carga final de visitas


gen descarte=1 if visita==1 & vistalista1==1
replace descarte=1 if visita==2 & vistalista2==1
replace descarte=1 if visita==3 & vistalista3==1
replace descarte=1 if visita==4 & vistalista4==1
replace descarte=1 if visita==5 & vistalista5==1

drop if descarte==1 




///Orden drive
order  fechaminima fechamaxima, after( randomizacion)
order   visita, after( fechamaxima)
gen nutricionista=1 if folio!=.
order   nutricionista, after( visita)
order estados_3, before(cesfam)

label define vista_ 1"Ingreso" 2"visita2" 3" Tercera visita" 4 "Llamado 4" 5" Quinta visita"
label values visita vista_

drop  fecha_visita est_date9 est_date12 est_date13 est_date14 est_date15 est_date16 est_date17 est_dates18 est_date19 est_date20 est_date21 primeravisita llamada2 tervisita llamada4 quintavisita  vistalista1 vistalista2 vistalista3 vistalista4 vistalista5 
*descarte

///// vulnerabilidad
gen lugar=1 if cont_v==0
replace lugar=2 if cont_v==1
label define lugar_ 1 "Domicilio" 2 " INTA"
label values lugar lugar_



***Sacar randomizacion 12/13 en segunda visita
drop if visita==2 & [randomizacion==1 | randomizacion==2] 
drop if visita==4
rename lugar lugar_r
save "Prelista", replace

****Guardar base como pre lista

**merge con folios y visitas anteriores, para ello se seleciona la base guardada en la carpeta llamada "basedrivexx_xx_xxxx" con la fecha mas reciente
**Si es 1 significa que solo esta en la pre base (No esta en el drive)
**Si es 2 significa que solo esta en la base que se cargo la semana pasada (Esta en el drive)
**Si es 3 significa que esta en la pre base y en la base pasada (Esta en el drive)
**Finalmente se deja solo _merge 1
keep if _merge==1
format %tdDD/NN/CCYY fechaminima fechamaxima
drop _merge cont_v CARGA fecha 
drop lugar
save "Basefinal", replace

////////////////////////////////////////////////////////////////////
/////////////////////////////Copiar y pegar en drive de visitas
////////////////////////////////////////////////////////////////////




/////////////////////////////SECCION BASE CARGADA VISITAS/////////////////////
*keep if lugar==1
gen fecha_hoy= c(current_date)
gen _date_ = date(fecha_hoy,"DMY")
format %tdDD/NN/CCYY _date_
drop fecha_hoy
rename  _date_ fecha
replace fecha =date("25/05/1900","DMY") 





*****Generacion de quincena
gen CARGA=. 
replace CARGA=1 if fecha>=date("15/05/2018","DMY") & fecha<=date("31/05/2018","DMY") & fechaminima<=date("31/05/2018","DMY")
replace CARGA=2 if fecha>=date("01/06/2018","DMY") & fecha<=date("15/06/2018","DMY") & fechaminima<=date("15/06/2018","DMY")
*cambio en procesar las metas de info rendimiento
replace CARGA=3 if fecha>=date("15/06/2018","DMY") & fecha<=date("30/06/2018","DMY") & fechaminima<=date("30/06/2018","DMY")
replace CARGA=4 if fecha>=date("15/06/2018","DMY") & fecha<=date("30/06/2018","DMY") & fechaminima>date("30/06/2018","DMY") 

replace CARGA=4 if fecha>=date("01/07/2018","DMY") & fecha<=date("15/07/2018","DMY") & fechaminima<=date("15/07/2018","DMY")
replace CARGA=5 if fecha>=date("01/07/2018","DMY") & fecha<=date("15/07/2018","DMY") & fechaminima>date("15/07/2018","DMY")

replace CARGA=5 if fecha>=date("16/07/2018","DMY") & fecha<=date("31/07/2018","DMY") & fechaminima<=date("31/07/2018","DMY")
replace CARGA=6 if fecha>=date("16/07/2018","DMY") & fecha<=date("31/07/2018","DMY") & fechaminima>date("31/07/2018","DMY")

replace CARGA=6 if fecha>=date("01/08/2018","DMY") & fecha<=date("15/08/2018","DMY") & fechaminima<=date("15/08/2018","DMY")
replace CARGA=7 if fecha>=date("01/08/2018","DMY") & fecha<=date("15/08/2018","DMY") & fechaminima>date("15/08/2018","DMY")

replace CARGA=7 if fecha>=date("16/08/2018","DMY") & fecha<=date("31/08/2018","DMY") & fechaminima<=date("31/08/2018","DMY")
replace CARGA=8 if fecha>=date("16/08/2018","DMY") & fecha<=date("31/08/2018","DMY") & fechaminima>date("31/08/2018","DMY")

replace CARGA=8 if fecha>=date("01/09/2018","DMY") & fecha<=date("15/09/2018","DMY") & fechaminima<=date("15/09/2018","DMY")
replace CARGA=9 if fecha>=date("01/09/2018","DMY") & fecha<=date("15/09/2018","DMY") & fechaminima>date("15/09/2018","DMY")

replace CARGA=9 if fecha>=date("16/09/2018","DMY") & fecha<=date("31/09/2018","DMY") & fechaminima<=date("31/09/2018","DMY")
replace CARGA=10 if fecha>=date("16/09/2018","DMY") & fecha<=date("31/09/2018","DMY") & fechaminima>date("31/09/2018","DMY")

replace CARGA=10 if fecha>=date("01/10/2018","DMY") & fecha<=date("15/10/2018","DMY") & fechaminima<=date("15/10/2018","DMY")
replace CARGA=11 if fecha>=date("01/10/2018","DMY") & fecha<=date("15/10/2018","DMY") & fechaminima>date("15/10/2018","DMY")

replace CARGA=11 if fecha>=date("16/10/2018","DMY") & fecha<=date("31/10/2018","DMY") & fechaminima<=date("31/10/2018","DMY")
replace CARGA=12 if fecha>=date("16/10/2018","DMY") & fecha<=date("31/10/2018","DMY") & fechaminima>date("31/10/2018","DMY")

replace CARGA=12 if fecha>=date("01/11/2018","DMY") & fecha<=date("15/11/2018","DMY") & fechaminima<=date("15/11/2018","DMY")
replace CARGA=13 if fecha>=date("01/11/2018","DMY") & fecha<=date("15/11/2018","DMY") & fechaminima>date("15/11/2018","DMY")

replace CARGA=13 if fecha>=date("16/11/2018","DMY") & fecha<=date("31/11/2018","DMY") & fechaminima<=date("31/11/2018","DMY")
replace CARGA=14 if fecha>=date("16/11/2018","DMY") & fecha<=date("31/11/2018","DMY") & fechaminima>date("31/11/2018","DMY")

replace CARGA=14 if fecha>=date("01/12/2018","DMY") & fecha<=date("15/12/2018","DMY") & fechaminima<=date("15/12/2018","DMY")
replace CARGA=15 if fecha>=date("01/12/2018","DMY") & fecha<=date("15/12/2018","DMY") & fechaminima>date("15/12/2018","DMY")

replace CARGA=15 if fecha>=date("16/12/2018","DMY") & fecha<=date("31/12/2018","DMY") & fechaminima<=date("31/12/2018","DMY")
replace CARGA=16 if fecha>=date("16/12/2018","DMY") & fecha<=date("31/12/2018","DMY") & fechaminima>date("31/12/2018","DMY")

replace CARGA=16 if fecha>=date("01/01/2019","DMY") & fecha<=date("15/01/2019","DMY") & fechaminima<=date("15/01/2019","DMY")
replace CARGA=17 if fecha>=date("01/01/2019","DMY") & fecha<=date("15/01/2019","DMY") & fechaminima>date("15/01/2019","DMY")

replace CARGA=17 if fecha>=date("16/01/2019","DMY") & fecha<=date("31/01/2019","DMY") & fechaminima<=date("31/01/2019","DMY")
replace CARGA=18 if fecha>=date("16/01/2019","DMY") & fecha<=date("31/01/2019","DMY") & fechaminima>date("31/01/2019","DMY")

replace CARGA=18 if fecha>=date("01/02/2019","DMY") & fecha<=date("15/02/2019","DMY") & fechaminima<=date("15/02/2019","DMY")
replace CARGA=19 if fecha>=date("01/02/2019","DMY") & fecha<=date("15/02/2019","DMY") & fechaminima>date("15/02/2019","DMY")

replace CARGA=19 if fecha>=date("16/02/2019","DMY") & fecha<=date("31/02/2019","DMY") & fechaminima<=date("31/02/2019","DMY")
replace CARGA=20 if fecha>=date("16/02/2019","DMY") & fecha<=date("31/02/2019","DMY") & fechaminima>date("31/02/2019","DMY")




keep folio visita fecha CARGA lugar_r
rename lugar_r lugar
save "Cargas", replace 
******************************Retroalimentar la base visitas "basedrivexx_xx_xxxx" con las visitas cargadas en drive.

*_merge
sort CARGA
drop  _merge

