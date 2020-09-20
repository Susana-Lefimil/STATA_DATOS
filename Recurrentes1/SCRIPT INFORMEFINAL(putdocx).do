////DESCARGA REPORTE ESTADO///////
////////////////////////////////////////////////////////////////////INFORME WORD////////////////////////////////////////////////////////////////////////////////////////
////Base
keep if redcap_event_name=="evaluacion1_arm_1"|redcap_event_name=="evaluacion2__llama_arm_1"| redcap_event_name=="evaluacion3_arm_1" | redcap_event_name=="evaluacion4_llamad_arm_1" | redcap_event_name=="evaluacion5_arm_1"
format %tdDD/NN/CCYY fecha_primera_visita est_date1 fecha_visita fecha_llamada
drop if folio==9999
//////////////////////////////////////////////////////TABLAS SE DEBEN PEGAR EN INFORME SEGUN CORRESPONDA///////////////////////////////////////////////////////////

**** 1. Actualización a la fecha.
**** Numero de folios totales en DHA.
sum folio if redcap_event_name=="evaluacion1_arm_1"
save "data1", replace
putdocx begin
putdocx paragraph, spacing(after, 0)
putdocx text ("A. Actualización a la fecha") , font(Arial, 11, black  ) bold 
putdocx paragraph, spacing(after, 0)
putdocx text ("Número de folios totales en DHA"), font(Arial, 11, black  ) underline 
statsby Total=r(N) Primer_folio=r(min) Ultimo_folio=r(max), by(redcap_event_name) :summarize folio 
putdocx table tabla1 = data(Total Primer_folio Ultimo_folio) if redcap_event_name=="evaluacion1_arm_1" ,varnames  halign(center) layout(autofitcontents) 
clear
use "data1.dta"

****A.	Estado 1
****Frecuencias del estado 1 con respecto a la primera evaluación (brazo).
tab estados_1 if redcap_event_name=="evaluacion1_arm_1"
save "data1", replace
*putdocx begin
putdocx paragraph, spacing(after, 0)
putdocx text ("B. Estado 1"), font(Arial, 11, black  ) bold
putdocx paragraph, spacing(after, 0)
putdocx text ("Frecuencias del estado 1 con respecto a la primera evaluación (brazo)"), font(Arial, 11, black  ) underline 
statsby Frecuencia=r(N), by(estados_1 redcap_event_name) basepop(redcap_event_name=="evaluacion1_arm_1"):sum folio
gen var=1
bysort var:egen sumbmi = sum(Frecuencia)
gen Porcentaje=(Frecuencia/sumbmi)*100
format %6.0g Porcentaje
*putdocx begin
putdocx table tabla2 = data(estados_1 Frecuencia Porcentaje)  if redcap_event_name=="evaluacion1_arm_1", varnames  halign(center) layout(autofitcontents) 
clear
use "data1.dta"

****Listado de folios sin ingreso de estado 1 en DHA.
list folio if estados_1==. & redcap_event_name=="evaluacion1_arm_1"
gen foliosin=1 if estados_1==. & redcap_event_name=="evaluacion1_arm_1"
replace foliosin=0 if foliosin==.
save "data1", replace
putdocx paragraph, spacing(after, 0)
putdocx text ("Listado de folios sin ingreso y sin estado 1 en DHA"), font(Arial, 11, black  ) underline 
statsby Total=r(N) prom =r(mean) , by(folio) :summarize foliosin
*putdocx begin
putdocx table tabla3 = data(folio) if prom==1  ,varnames  halign(center) layout(autofitcontents) 
*putdocx save myreport.docx, replace

****Número de contactadas con primera visita.
clear
use "data1.dta"

tab estados_1 if visita_tipo==1
save "data1", replace
putdocx paragraph, spacing(after, 0 )
putdocx text ("Número de contactadas con primera visita"), font(Arial, 11, black  ) underline 
statsby Frecuencia=r(N), by(estados_1 visita_tipo) basepop(visita_tipo==1):sum folio
gen var2=1
bysort var2:egen sumbmi2 = sum(Frecuencia)
gen Porcentaje=(Frecuencia/sumbmi2)*100
format %6.0g Porcentaje
*putdocx begin
putdocx table tabla4 = data(estados_1 Frecuencia Porcentaje) if visita_tipo==1 , varnames  halign(center) layout(autofitcontents) 
clear
use "data1.dta"

****B.	Estado 2
****Frecuencias de folios con estado 2 y con  primera visita. 
tab estados_2 if visita_tipo==1
save "data1", replace
putdocx paragraph, spacing(after, 0 pt)
putdocx text ("C. Estado 2"), font(Arial, 11, black  ) bold
putdocx paragraph, spacing(after, 0)
putdocx text ("Frecuencias de folios con estado 2 y con primera visita"), font(Arial, 11, black  ) underline 
statsby Frecuencia=r(N), by(estados_2 visita_tipo) basepop(visita_tipo==1):sum folio
gen var3=1
bysort var3:egen sumbmi3 = sum(Frecuencia)
gen Porcentaje=(Frecuencia/sumbmi3)*100
format %6.0g Porcentaje
*putdocx begin
putdocx table tabla5 = data(estados_2 Frecuencia Porcentaje) if visita_tipo==1 , varnames  halign(center) layout(autofitcontents) 
clear
use "data1.dta"


****Listado de folios con fechas de llamado si estado 2 esta pendiente, citada en espera o no asiste en la primera visita.
/*list folio estados_2 fecha_llamada est_date1 if estados_2>=3 & estados_2<=5 , noobs
gen list_est2=1 if estados_2>=3 & estados_2<=5
replace list_est2=0 if list_est2==.
save "data1", replace
putdocx paragraph, spacing(after, 0 pt)
putdocx text ("Listado de folios con fechas de llamado si estado 2 está pendiente, citada en espera o no asiste en la primera visita"), font(Arial, 11, black  ) underline 
statsby Total=r(N) prom =r(mean) , by(folio estados_2 fecha_llamada est_date1) :summarize list_est2
format %tdDD/NN/CCYY fecha_llamada est_date1
*putdocx begin
putdocx table tabla6 = data(folio estados_2 fecha_llamada est_date1) if prom==1 ,varnames  halign(center) layout(autofitcontents) 
clear
use "data1.dta"*/


****C.	Estado 3 
****Frecuencias de estado 3 con primera visita. 
tab estados_3 if visita_tipo== 1
save "data1", replace
putdocx paragraph, spacing(after, 0 pt)
putdocx text ("D. Estado 3"), font(Arial, 11, black  ) bold
putdocx paragraph, spacing(after, 0)
putdocx text ("Frecuencias de estado 3 con primera visita"), font(Arial, 11, black  ) underline 
statsby Frecuencia=r(N), by(estados_3) basepop(visita_tipo==1):sum folio
gen var4=1
bysort var4:egen sumbmi4 = sum(Frecuencia)
gen Porcentaje=(Frecuencia/sumbmi4)*100
format %6.0g Porcentaje
*putdocx begin
putdocx table tabla7 = data(estados_3 Frecuencia Porcentaje) , varnames  halign(center) layout(autofitcontents) 
clear
use "data1.dta"



****Listado de folios con estado 4 y primera visita. (Se supone que no deberían existir folios con primera visita si no fueron reclutados.  Esto sucedería solo si en la visita quedó como no reclutada.).

/*list folio fecha_llamada est_date1 if visita_tipo==1 & estados_3==.& estados_4==. & estados_2==. 
gen list_est3=1 if visita_tipo==1 & estados_3==.& estados_4==. & estados_2==.
replace list_est3=0 if list_est3==.
save "data1", replace
putdocx paragraph, spacing(after, 0 pt)
putdocx text ("Listado de folios no reclutados, sin estado 3 y con primera visita. (Se supone que, si no se reclutó en estado 2 no debe tener completado más allá del formulario de estado, por ello no debería tener primera visita. Estos folios se deben revisar. "), font(Arial, 11, black  ) underline 
statsby Total=r(N) prom =r(mean) , by(folio fecha_llamada est_date1) :summarize list_est3
*putdocx begin
format %tdDD/NN/CCYY fecha_llamada est_date1
putdocx table tabla8 = data(folio fecha_llamada est_date1) if prom==1 ,varnames  halign(center) layout(autofitcontents) 
clear
use "data1.dta"*/



****D.  Estado 5
****Frecuencia de estado 5 con primera visita
tab estado_5 if visita_tipo== 1
save "data1", replace
putdocx paragraph, spacing(after, 0 pt)
putdocx text ("E. Estado 5"), font(Arial, 11, black  ) bold
putdocx paragraph, spacing(after, 0)
putdocx text ("Frecuencia de estado 5 con primera visita"), font(Arial, 11, black  ) underline 
statsby Frecuencia=r(N), by(estado_5) basepop(visita_tipo==1):sum folio
gen var5=1
bysort var5:egen sumbmi5 = sum(Frecuencia)
gen Porcentaje=(Frecuencia/sumbmi5)*100
format %6.0g Porcentaje
*putdocx begin
putdocx table tabla9 = data(estado_5 Frecuencia Porcentaje) , varnames  halign(center) layout(autofitcontents) 
clear
use "data1.dta"

****E.	Estado 4
****Frecuencia de no reclutados. 
tab estados_4 if redcap_event_name=="evaluacion1_arm_1"
save "data1", replace
putdocx paragraph, spacing(after, 0 pt)
putdocx text ("F. Estado 4"), font(Arial, 11, black  ) bold
putdocx paragraph, spacing(after, 0)
putdocx text ("Frecuencia de no reclutados"), font(Arial, 11, black  ) underline 
statsby Frecuencia=r(N), by(estados_4) basepop(redcap_event_name=="evaluacion1_arm_1"):sum folio
gen var6=1
bysort var6:egen sumbmi6 = sum(Frecuencia)
gen Porcentaje=(Frecuencia/sumbmi6)*100
format %6.0g Porcentaje
*putdocx begin
putdocx table tabla10 = data(estados_4 Frecuencia Porcentaje) , varnames  halign(center) layout(autofitcontents) 
clear
use "data1.dta"

****Frecuencia de estado 4 que tengan primera visita. 
tab estados_4 if visita_tipo==1
save "data1", replace
putdocx paragraph, spacing(after, 0 pt)
putdocx text ("Frecuencia de estado 4 que tengan primera visita"), font(Arial, 11, black  ) underline 
statsby Frecuencia=r(N), by(estados_4 visita_tipo) basepop(visita_tipo==1):sum folio
gen var7=1
bysort var7:egen sumbmi7 = sum(Frecuencia)
gen Porcentaje=(Frecuencia/sumbmi7)*100
format %6.0g Porcentaje
*putdocx begin
putdocx table tabla11 = data(estados_4 Frecuencia Porcentaje) if visita_tipo==1 , varnames  halign(center) layout(autofitcontents) 
clear
use "data1.dta"

****Listado de folios con estado 4 y primera visita. (Se supone que no deberían existir folios con primera visita si no fueron reclutados.  Esto sucedería solo si en la visita quedó como no reclutada.).
list folio if estados_4!=. & visita_tipo==1
gen list_est4=1 if visita_tipo==1 & estados_4!=.
replace list_est4=0 if list_est4==.
save "data1", replace
putdocx paragraph, spacing(after, 0 pt)
putdocx text ("Listado de folios con estado 4 y primera visita. (Estos folios quedaron como No reclutados al tener la primera visita)."), font(Arial, 11, black  ) underline 
statsby Total=r(N) prom =r(mean) , by(folio) :summarize list_est4
*putdocx begin
putdocx table tabla12 = data(folio) if prom==1 ,varnames  halign(center) layout(autofitcontents) 
clear
use "data1.dta"


///////////////////////////////////////////////////////////////////////// RESUMEN Estado final///////////////////////////////////////////////////////

****estado final reclutadas***
replace estados_2=7 if estados_2==5
replace estados_2=8 if estados_2==4
replace estados_2=9 if estados_2==3
replace estados_2=10 if estados_2==2
replace estados_2=11 if estados_2==1
replace estados_1=12 if estados_1==1
replace estados_1=13 if estados_1==2
replace estados_1=14 if estados_1==3
replace estados_3=15 if estados_3==1
replace estados_3=16 if estados_3==2
replace estados_3=17 if estados_3==3
replace estados_3=18 if estados_3==4

gen estado_final= estado_5 if visita_tipo==1
by folio, sort: replace estado_final = estados_3 if estado_final== . 
replace estado_final = estados_2 if estado_final== .
replace estado_final = estados_1 if estado_final== .
label define estado_final2_ 1 "Abandona" 2 "Extraviada" 3 "Aborto" 4 "Parto" 5 "Parto sin adherencia" 7"Pendiente por Citar" 8 "Citada No asiste" 9 "Citada en espera" 10 "No reclutada" 11 "Reclutada" 12 " Contactada" 13"No Contactada" 14 "Pendiente" 15"Activa" 16"Egreso"  17"En busqueda" 18"Activa sin adherencia"
label values estado_final estado_final2_
save "data1", replace
****Resumen.
****Estado final de folios DHA.
tab estado_final if redcap_event_name=="evaluacion1_arm_1"
save "data1", replace
putdocx paragraph, spacing(after, 0 pt)
putdocx text ("Resumen"), font(Arial, 11, black  ) bold
putdocx paragraph, spacing(after, 0)
putdocx text ("Estado final de folios DHA"), font(Arial, 11, black  ) underline 
statsby Frecuencia=r(N), by(estado_final) basepop(redcap_event_name=="evaluacion1_arm_1"):sum folio
gen var8=1
bysort var8:egen sumbmi8 = sum(Frecuencia)
gen Porcentaje=(Frecuencia/sumbmi8)*100
format %6.0g Porcentaje
*putdocx begin
putdocx table tabla13 = data(estado_final Frecuencia Porcentaje) , varnames  halign(center) layout(autofitcontents) 
clear
use "data1.dta"

****Numero de reclutados con sus randomizaciones
tab randomizacion if estados_2==11
save "data1", replace
putdocx paragraph, spacing(after, 0 pt)
putdocx text ("Randomización"), font(Arial, 11, black  ) underline 
statsby Frecuencia=r(N), by(randomizacion estados_2) basepop(estados_2==11):sum folio
gen var9=1
bysort var9:egen sumbmi9 = sum(Frecuencia)
gen Porcentaje=(Frecuencia/sumbmi9)*100
format %6.0g Porcentaje
*putdocx begin
putdocx table tabla14 = data(randomizacion Frecuencia Porcentaje) if estados_2==11 ,   varnames  halign(center) layout(autofitcontents) 
clear
use "data1.dta"


****Folios sin estado ni fecha de visita. 
list folio if estado_final==. & fecha_visita==. & redcap_event_name=="evaluacion1_arm_1"
gen list_est5=1 if estado_final==. & fecha_visita==. & redcap_event_name=="evaluacion1_arm_1"
replace list_est5=0 if list_est5==.
save "data1", replace
putdocx paragraph, spacing(after, 0 pt)
putdocx text ("Folios sin estado ni fecha de visita"), font(Arial, 11, black  ) underline 
statsby Total=r(N) prom =r(mean) , by(folio) :summarize list_est5
*putdocx begin
putdocx table tabla15 = data(folio) if prom==1 ,varnames  halign(center) layout(autofitcontents) 
clear
use "data1.dta"



****Numero de folios activos: Suma de folios activos, activos sin adherencia y parto
gen Activos=1 if estado_final==15 | estado_final==18 |estado_final==4 |estado_final==5
by Activos, sort : count if estados_2==11
save "data1", replace
putdocx paragraph, spacing(after, 0 pt)
putdocx text ("Número de folios activos: Suma de folios activos, activos sin adherencia, parto y parto sin adherencia"), font(Arial, 11, black  ) underline 
statsby Frecuencia=r(N), by(Activos) basepop(estados_2==11):sum folio
gen var10=1
bysort var10:egen sumbmi10 = sum(Frecuencia)
gen Porcentaje=(Frecuencia/sumbmi10)*100
format %6.0g Porcentaje
*putdocx begin
putdocx table tabla16 = data(Activos Frecuencia) , varnames  halign(center) layout(autofitcontents) 
clear
use "data1.dta"


***Numero de folios con parto
gen Parto=1 if estado_final==4 | estado_final==5
by Parto, sort : count if estados_2==11
save "data1", replace
putdocx paragraph, spacing(after, 0 pt)
putdocx text ("Número de folios con partos: Suma de folios con parto/parto sin adherencia en formulario estados"), font(Arial, 11, black  ) underline 
statsby Frecuencia=r(N), by(Parto) basepop(estados_2==11):sum folio
gen var11=1
bysort var11:egen sumbmi11 = sum(Frecuencia)
gen Porcentaje=(Frecuencia/sumbmi11)*100
format %6.0g Porcentaje
*putdocx begin
putdocx table tabla17 = data(Parto Frecuencia) , varnames  halign(center) layout(autofitcontents) 
clear
use "data1.dta"



****Folios con visitas incompletas. Estos folios tienen alguna visita incompleta y la siguiente a esta si está ingresada.
////Listado de fechas de cambio estado y llamado de folios pendientes y ausentes si la fecha de llamada es menor a fecha de estado. 
encode redcap_event_name, generate(a)
order a, after(redcap_event_name)
drop redcap_event_name
rename a redcap_event_name

/// Solo si se descarga como string
* encode visita_tipo, generate(b)
* order b, after(visita_tipo)
* drop visita_tipo
* rename b visita_tipo

bysort folio:egen numvisita=max(redcap_event_name)
bysort folio:egen viscunt=count(redcap_event_name)
gen visitacompleta=1 if numvisita==viscunt & estados_2==11
replace visitacompleta=. if estado_5==4 & numvisita!=5 & numvisita!=.
list folio if visitacompleta==.& estados_2==11
gen Incompleto=1 if visitacompleta==. & estados_2==11
replace Incompleto=. if estado_5==1 | estado_5==3 | estado_5==2
by Incompleto, sort : count if estados_2==11
save "data1", replace
putdocx paragraph, spacing(after, 0 pt)
putdocx text ("Número de folios con visitas incompletas: Estos folios tienen alguna visita incompleta, considerando solo estado Parto"), font(Arial, 11, black  ) underline 
statsby Frecuencia=r(N), by(Incompleto ) basepop(estados_2==11):sum folio
gen var10=1
bysort var10:egen sumbmi10 = sum(Frecuencia)
gen Porcentaje=(Frecuencia/sumbmi10)*100
format %6.0g Porcentaje
*putdocx begin
putdocx table tabla18 = data(Incompleto Frecuencia) , varnames  halign(center) layout(autofitcontents) 
clear
use "data1.dta"



putdocx save Informe_estado_del_participante.docx, replace
////////////////////////////////////////////////////////////////FIN DE INFORME WORD////////////////////////////////////////////////////////////////////


///////////////////////////////////////////////////////////////////////EXCEL///////////////////////////////////////////////////////////////////////////
*Determinar último tipo de visita y su fecha
sort folio
by folio: egen visitatipo= max(visita_tipo)
label values visitatipo visita_tipo_
by folio: egen fechavisita = max(fecha_visita)
format %tdDD/NN/CCYY fechavisita
replace visita_tipo=visitatipo if folio!=.
replace fecha_visita=fechavisita if folio!=.

*Dejar solo evaluacion 1
keep if redcap_event_name==1
keep if estado_final>=15 | estado_final<=5

*Generacion de variables 
*Fechas
gen fecha_hoy= c(current_date)
gen _date_ = date(fecha_hoy,"DMY")
drop fecha_hoy
rename _date_ fecha_hoy
format %tdDD/NN/CCYY fecha_hoy

*Sentencias con furop_mix
gen furop=trunc(est_date9-fecha_hoy)*-1
label define cumple 1"Si" 2"No" 3 "Sin furop" 4"Si, pero no actualizado en Redcap" 5"Aun en rango de parto" 6 "Abandona estudio" 7 "Aborto" 8 " Extraviada"
gen cumplemix=1 if visitacompleta==1
replace cumplemix=2 if visitacompleta==.
replace cumplemix=3 if furop==.
replace cumplemix=6 if estado_5==1
replace cumplemix=7 if estado_5==3
replace cumplemix=8 if estado_5==2

*Por estado
*Parto
gen partocumple=1 if estado_5==4 & furop>224 | estado_5==5 & furop>224
replace partocumple=2 if furop<=224
replace partocumple=4 if furop>294 & estado_5!=4 & estado_5!=5 & estado_5!=2
replace partocumple=3 if furop==.
replace partocumple=5 if partocumple==.
replace partocumple=6 if estado_5==1 
replace partocumple=7 if estado_5==3
replace partocumple=8 if estado_5==2
label values cumplemix partocumple cumple 
sort folio

save "estado" , replace
*Parto
*DESCARGA REPORTE PARTO SL Y PC
drop redcap_event_name
drop if parto_date==.
merge 1:1 folio using "estado" 
gen parto_si="Si" if _merge==3
replace parto_si="No" if _merge==2







order  randomizacion cumple_con_los_criterios acepta_participar estado_final estados_4 est_date1  fecha_primera_visita  visita_tipo fecha_visita, after(folio)
keep   folio   randomizacion nombre_embarazada apellido_paterno rut_tel  digito_verificador cumple_con_los_criterios acepta_participar estado_final estado_5 fecha_primera_visita est_date1 visita_tipo fecha_visita  furop cumplemix partocumple parto_si
keep if cumplemix!=.
order  nombre_embarazada apellido_paterno rut_tel digito_verificador, after(randomizacion)
drop if randomizacion==. & nombre_embarazada=="" & apellido_paterno=="" & rut_tel==. & digito_verificador=="" &  cumple_con_los_criterios==. & acepta_participar==. & estado_final==. & est_date1==. & fecha_primera_visita==. & visita_tipo==. & fecha_visita==. & estado_5==.


////////////////COPIAR Y PEGAR BASE EN HOJA EXCEL"fOLIOS DHA ULTIMA VISITA", DEL INFORME "BASE INFORME ESTADO DEL PARTICIPANTE"




////////////////DESPUES DE REALIZAR EL PASO ANTERIOR

****Dejar folios que no cumplen 
keep if  cumplemix==2 | partocumple==2
drop  cumple_con_los_criterios acepta_participar est_date1  

*save
save "cruceestado", replace
clear
////////////////Guardar listado dha en formato dta (stata)


///////////////Llamadas citaciones
////////////Bajar reporte LLAMADACITACION2 (SL)
format %tdDD/NN/CCYY  llam_fech_date
*Eliminar vacios
drop if llam_nomb_tel==. & llam_fech_date==. & llam_razon_con==. & llam_esp_otro=="" & llam_situacion==. & llam_obs1=="" & llam_obs2==""
*Codificar variables descriptivas y dejar ultima llamada
encode redcap_event_name, generate(a)
order a, after(redcap_event_name)
drop redcap_event_name
rename a redcap_event_name
sort folio
by folio: egen numerollamada= max(redcap_event_name)
label value  numerollamada a
keep if redcap_event_name == numerollamada
replace redcap_event_name=numerollamada if folio!=.
*Fechas
gen fecha_hoy= c(current_date)
gen _date_ = date(fecha_hoy,"DMY")
drop fecha_hoy
rename _date_ fecha_hoy
format %tdDD/NN/CCYY fecha_hoy

merge 1:1 folio using "cruceestado"
///////////////////////////////////////////////////////////////////Merge base listado dha no cumple//////////////////////////////////////////////////////////////////////
keep if _merge==3 
keep if estado_final!=10 
drop  llam_ini_time llam_fin_time llam_agen_vis llam_confirma llam_adverso llam_adheren llam_nopartic  numerollamada randomizacion _merge fecha_primera_visita visita_tipo cumplemix partocumple estado_5


// Generar variable que indique si fecha de llamada es menor a fecha de ultima visita
gen se_llamo =1 if  llam_fech_date< fecha_visita
replace se_llamo=1 if  llam_fech_date==fecha_visita
replace se_llamo=2 if se_llamo==. & llam_fech_date> fecha_visita
label values se_llamo cumple
//dejar solo folios con visitas de los ultimos 90 dias
gen fechamax=trunc(fecha_visita -fecha_hoy)*-1
keep if fechamax<=90 & fechamax>=3


order  estado_final  llam_nomb_tel llam_fech_date  llam_razon_con  llam_esp_otro , after(folio)

drop redcap_event_name furop fecha_hoy
drop nombre_embarazada	apellido_paterno	rut_tel	digito_verificador fechamax

///////////////COPIAR Y PEGAR EN LA HOJA "FOLIOS LLAMADAS VISITAS", DEL INFORME "BASE INFORME ESTADO DEL PARTICIPANTE"
