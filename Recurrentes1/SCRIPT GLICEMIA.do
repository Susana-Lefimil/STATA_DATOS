////////////DESCARGAR REPORTE DIABETES GESTACIONAL 
///Borrar variables que no necesito
drop  parto_dx___2 parto_dx___3 parto_dx___4 parto_dx___5 parto_dx___6 parto_dx___7 parto_dx___8 parto_dx___9 parto_dx___10 parto_dx___11 parto_dx___12 parto_dx___13 parto_dx___14 parto_dx___15 parto_dx___16 parto_dx___17


/////DIABETES GESTACIONAL////////
********Determinar diabetes gestacional con dxa_parto y morbilidad(Form parto)******************

///Usar checkbox de var dx_parto=1. Comando extiende la var en todos los eventos por folios
bysort folio: egen dx=max( parto_dx___1)
///Codificar var morbilidad a valor numerico, solo para chequeo ya que es una var escrita
encode parto_morb, generate(a)
order a, after(parto_morb)
drop parto_morb
rename a parto_morb
/// Comando extiende la var en todos los eventos por folios
bysort folio: egen obmorb=max(parto_morb)
/// Se asigna valor a morbilidad
label values obmorb a
*Si tiene missing value en dx_parto se verifica valores en registro examenes*

********Checkear y determinar diabetes gestacional con registro exam control 2**************

///Generar variables

gen ptgo1max11=ptgo_glicemia_1 if redcap_event_name=="control_2_arm_2"
gen ptgo1max21=ptgo_glicemia_2 if redcap_event_name=="control_2_arm_2"

gen ptgo1max12=ptgo_glicemia_1 if redcap_event_name=="control_3_arm_2"
gen ptgo1max22=ptgo_glicemia_2 if redcap_event_name=="control_3_arm_2"

///Comando extiende la var en todos los eventos por folios

bysort folio: egen ptgo1max1= max(ptgo1max11) 
bysort folio: egen ptgo2max1= max(ptgo1max21)

bysort folio: egen ptgo1max2= max(ptgo1max12) 
bysort folio: egen ptgo2max2= max(ptgo1max22)


/////DIABETES PREGESTACIONAL////////
********Determinar glicemia por folio considerando solo control 1************

///Generar variables
gen diabpreges1=glicemia if redcap_event_name=="control_1_arm_2"
///Comando extiende la var en todos los eventos por folios
bysort folio: egen glicemax= max( diabpreges1)



/////UNIFICACION DE FOLIOS/////

///Dejar solo evento 1
keep if redcap_event_name=="evaluacion1_arm_1"


/////ECUACIONES/////////

///DIABETES GESTACIONAL
*****Deterninar si tiene diabetes gestacional por parto
gen est_diabparto=.
replace est_diabparto=1 if dx==1
replace est_diabparto=0 if dx==0
*****Deterninar si tiene diabetes gestacional por registro exam(solo se usa control 2)
gen est_diabcontrol=.
replace  est_diabcontrol=1 if [ptgo1max1>=100 & ptgo1max1!=.]| [ptgo2max1>=140 & ptgo2max1!=.]
replace  est_diabcontrol=0 if [ptgo1max1<100 & ptgo1max1!=. & ptgo2max1<140 & ptgo2max1!=.]
*replace  est_diabcontrol=1 if [ptgo1max2>=100 | ptgo2max2>=140]
////DEJAR VACIO SI NO ESTA ACTUALIZADO
*replace  est_gesta=. if dx!=1 & [ptgo1max1==0 | ptgo2max1==0]

///DIABETES PREGESTACIONAL
*****Determinar si tiene diabetes pregestacional por glicemia
replace  est_pregesta_v2=1 if glicemax>=100 & glicemax!=.
replace  est_pregesta_v2=0 if glicemax<100 & glicemax!=.



********Si existe otro exam de glicemia en control 3 (por cualquier eventualidad)listar en pantalla de comandos****
*list folio if glicemia3!=.

/////Chequeo final (Mirar base y verificar si hay errores)///////////////
keep folio redcap_event_name  est_pregesta_v2 ptgo1max1 ptgo2max1 ptgo1max2 ptgo2max2 glicemax  dx estados_2 est_diabparto est_diabcontrol


////Dejar reclutados
*keep if estados_2==1

//////Carga final
label values est_pregesta_v2 .
*label values est_gesta .
keep folio redcap_event_name est_diabparto est_diabcontrol  est_pregesta_v2


*export delimited folio redcap_event_name est_diabparto est_diabcontrol  est_pregesta_v2 using "carga.csv"
