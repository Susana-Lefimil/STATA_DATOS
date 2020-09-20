///////////////////////////////////////////////////////////////////////////////////REVISION DIARIA/////////////////////////////////////////////////////////////////////////
replace  contacto_y_reclutami_v_0=1 if contacto_y_reclutami_v_0==2
replace estado_de_la_madre_complete=1 if estado_de_la_madre_complete==2
replace   visita_dha_complete=1 if visita_dha_complete==2
replace dha_ingreso_complete=1 if dha_ingreso_complete==2
replace antecedentes_sociode_v_1=1 if antecedentes_sociode_v_1==2
replace  antecedentes_persona_v_2=1 if antecedentes_persona_v_2==2
replace  antecedentes_obstetr_v_3=1 if antecedentes_obstetr_v_3==2
replace  antropometria_dha_complete=1 if antropometria_dha_complete==2
replace  ffq_complete=1 if ffq_complete==2
replace  intervencion_complete=1 if intervencion_complete==2
replace  registro_pastilla_complete=1 if registro_pastilla_complete==2
replace  checklist_complete=1 if checklist_complete==2
*replace   supervision_complete=1 if supervision_complete==2


*******************************Descargar base entera*************************************
////////////////Fecha revision visita
drop if estados_2==2
keep if redcap_event_name=="evaluacion1_arm_1" | redcap_event_name=="evaluacion2__llama_arm_1" | redcap_event_name=="evaluacion3_arm_1" | redcap_event_name=="evaluacion4_llamad_arm_1" | redcap_event_name=="evaluacion5_arm_1" 
*keep if fecha_visita==date("27/12/2017","DMY") 
////Modificaciones para revisar al pasado
drop if folio==7489 | folio==7549 | folio==7845 | folio==7563
drop if folio==7000 & redcap_event_name=="evaluacion2__llama_arm_1"
order contacto_y_reclutami_v_0 estado_de_la_madre_complete visita_dha_complete  dha_ingreso_complete antecedentes_sociode_v_1 antecedentes_persona_v_2 antecedentes_obstetr_v_3 antropometria_dha_complete ffq_complete intervencion_complete registro_pastilla_complete checklist_complete, before (supervision_complete)
foreach v of varlist contacto_y_reclutami_v_0 - checklist_complete {
     replace `v'=1 
	 }
*******************************Actualizar rango de fechas
keep if fecha_visita>=date("01/01/2015","DMY") & fecha_visita<=date("30/09/2017","DMY") 
format %tdDD/NN/CCYY fecha_visita 
*keep if vis_nutri==2015 | vis_nutri==2003 | vis_nutri==2007 & fecha_visita<=date("02/09/2017","DMY")

///////////////////////////////////////////////////////////////////////////////CONTACTO Y RECLUTAMIENTO/////////////////////////////////////////////////////////////////// 
//Replace por fechas

replace cont_chimincs=99 if fecha_llamada<=date("23/10/2017","DMY") & cont_chimincs==.
replace cont_desorden=99 if fecha_llamada<=date("23/10/2017","DMY") & cont_desorden==.
replace cont_abort=99    if fecha_llamada<=date("23/10/2017","DMY") & cont_aborto==.
replace cont_comuna=99   if fecha_llamada<=date("23/10/2017","DMY") & cont_comuna==.
replace sobrepeso=99     if fecha_llamada<=date("13/05/2017","DMY") & sobrepeso==.
replace cont_rutina=99   if fecha_llamada<=date("08/08/2017","DMY") & cont_rutina==.
replace cont_comuna=99   if fecha_llamada<=date("01/01/2018","DMY") & cont_comuna==.
replace hora_inicio_1="99" if fecha_llamada<=date("01/01/2018","DMY") & hora_inicio_1==""
replace hora_fin_1="99"  if fecha_llamada<=date("01/01/2018","DMY") & hora_fin_1==""

****VAR obligatorio
gen cobligatorio=1       if fecha_foliado!=. &  nombre_embarazada!="" & apellido_paterno!="" & apellido_materno!="" & rut_tel!=. & digito_verificador!="" & fecha_de_nac!=.  & comuna!=. & cesfam!=. 
****VAR Filtros diabetes
gen diabetescheck=1      if  diag_diabetes==0 
****VAR Otros
gen otrocheck=1          
****VAR Gestion
gen gestion=1            
****VAR Criterios y participante
gen criteriocheck=1      if cumple_con_los_criterios==1 & acepta_participar==1
*replace criteriocheck=2  if cumple_con_los_criterios==1 & acepta_participar==0 & no_quiere_participar!=""
****VAR Randomizacion sin considerar fur_contactos
gen randomcheck=1        
****VAR Direccion
gen direccioncheck=1     if acepta_participar==1 & direccion!="" & numero_direccion!="" 
**** VAR Telefono
gen telf2check=1         
gen telf3check=1         
replace telf2check=1     
replace telf3check=1     
gen telefonocheck=1      


****VAR Redes sociales 
gen facecheck=1           
gen wspcheck=1           
gen mailcheck=1          

replace facecheck=1      
replace wspcheck=1       
replace mailcheck=1      
gen redescheck=1         

****VAR Visita
gen vistacheck=1         
replace vistacheck=1    
replace vistacheck=1     
****VAR Incidencias por seccion
list folio cobligatorio diabetescheck  otrocheck criteriocheck  randomcheck  direccioncheck telefonocheck redescheck vistacheck gestion if contacto_y_reclutami_v_0!=. & redcap_event_name=="evaluacion1_arm_1"
////Complete
gen complete=1           if cobligatorio==1 & diabetescheck==1 & otrocheck==1 & criteriocheck!=. & randomcheck==1 & direccioncheck==1 & telefonocheck!=. & redescheck!=. & vistacheck!=.& gestion==1 
replace  contacto_y_reclutami_v_0=2 if complete==1
****VAR Incidencias por seccion
list folio cobligatorio diabetescheck  otrocheck criteriocheck  randomcheck  direccioncheck telefonocheck redescheck vistacheck gestion if contacto_y_reclutami_v_0!=2 & redcap_event_name=="evaluacion1_arm_1"

////Calidad
gen calidad_cont=1       if diag_diabetes==1 | cumple_con_los_criterios==0 | acepta_participar==0
list folio redcap_event_name diag_diabetes cumple_con_los_criterios acepta_participar if calidad_cont==1 


////////////////////////////////////////////////////////////////////////////////////ESTADO DE LA MADRE/////////////////////////////////////////////////////////////////////////*****1 VISITA
////Seccion estado
gen estado=1             if est_date1!=. & estados_1==1 & [[estados_4==2 &  [est_criterio>=7 | est_criterio==9 |  [est_criterio==8 & est_otro1!=""]]] | [estados_2==1 & [estados_3==1 | estados_3==4]]]
replace estado=1         if est_date1!=. & estados_1==1 & [estados_4==1 & [est_rechazo1!=. & est_rechazo1!=4 | [est_rechazo1==4 & est_otro2!=""]]]
replace estado=1         if est_date1!=. & estados_1==1 & estado_5!=. & estados_3==2 & estados_2==1 
*aborto
gen aborto=1             if estado_5==3  & est_obs1!=""
replace aborto=1         if estado_5!=3
*abandono
gen abandono=1           if estado_5==1 & [est_abadono1!="" | est_abandono2!=. ]
replace abandono=1       if estado_5!=1
*aherencia
gen adherencia=1         if estados_3==4 & est_sinadh!="" | estado_5==5 & est_sinadh!=""
replace adherencia=1     if estado_5!=5
*replace estado=1         if estado==. & [aborto==1 | abandono==1 | adherencia==1 | estado_5==4 | estado_5==5 | estado_5==2] 
*replace estado=.         if [estado_5==3 & aborto==.] | [estado_5==1 & abandono==.] | [estados_3==4 & adherencia==.] & [estado_5==5 & adherencia==.]
*devolucion pastilla
*gen pastillas=1          if [[estado_5==1 | estado_5==3] & [est_date4!=. &  est_consum==2]] | [estado_5!=3 &  est_consum==1 &  est_date3!=.]
*replace pastillas=1      if pastillas==. & [estado_5==2 | estado_5==4 | estados_3==1 | estados_3==4]
gen estadofinal=1        if estado==1 & aborto==1 & abandono==1 & adherencia==1 
replace estadofinal=.    if [estado_5==3 & aborto==.] | [estado_5==1 & abandono==.] | [estados_3==4 & adherencia==.] & [estado_5==5 & adherencia==.]
*& pastillas==1
////Seccion fur/furop/fpp////
gen furr=1               
gen furop=1              
gen fpp=1                
gen fechas=1             
replace fechas=1 if redcap_event_name=="evaluacion1_arm_1"
////Seccion ultimo contacto//
gen contacto=1           if estados_3==3 &  est_cont==0
replace contacto=.       if est_date24==. & est_date25==. & est_date27==. & est_cont==1
replace contacto=1       if estados_3==1 | estados_3==2 | estados_3==4
////Seccion devolucion pastillas final///
gen devolucion=1         if est_devol==0 | [est_devol==1 & est_frasc4!=. &  est_frasc5!=. & [est_frasc3==0 | est_frasc3>0 &  est_pas2!=.]]
replace devolucion=1     if estados_3==1 | estados_3==4
*Aun se esta completando la devolucion de pastillas
replace devolucion=1     if est_devol==.
////Seccion devolucion parto
*gen devolparto=1         if est_frasco==0 | [est_frasco==1 & est_frasc1!=. &   est_pas1!=.]
///////////Complete////////
replace estado_de_la_madre_complete=2 if estadofinal==1 & fechas==1 & contacto==1 & devolucion==1 
replace estado_de_la_madre_complete=2 if estados_2==2

/// Incidencias//
list folio estados_3 estadofinal estado_5 fechas contacto devolucion est_obs2 if estado_de_la_madre_complete!=2 & redcap_event_name=="evaluacion1_arm_1" 

///
////////////////////////////////////////////////////////////////////////////////////////VISITA//////////////////////////////////////////////////////////////////////////////////*******1 2 3 4 5 VISITAS
*****Generar ultima visita y complete
**bysort folio:egen ultimavisita=max(visita_tipo) if folio!=.
gen cumplevis1=1         if visita_tipo!=. & fecha_visita!=.  
         
replace visita_dha_complete=2 if cumplevis1==1

list folio redcap_event_name  visita_obs if visita_dha_complete!=2
*Borrar no visitas
*drop if redcap_event_name=="evaluacion1_arm_1" & estado_2>=2



/////////////////////////////////////////////////////////////////////////////////////DHA INGRESO////////////////////////////////////////////////////////////////////////////////********1 VISITA
****VAR fur furop
 gen dhafurop=1      if semanas_gestacional_ingres!=. & dias_gestacional_ingre!=. & semanas_gestacional_furop!=. & dias_gestacional_furop!=. 
 gen dha_fur=1       if semanas_gestacional_ingres==. & dias_gestacional_ingre==. & est_date6==. | semanas_gestacional_ingres!=. & dias_gestacional_ingre!=. & est_date6!=.
 gen dha_furop=1     if semanas_gestacional_furop==. & dias_gestacional_furop==. &  est_date8==. | semanas_gestacional_furop!=. & dias_gestacional_furop!=. &  est_date8!=.
 replace dhafurop=1  if dha_fur==1 & semanas_gestacional_furop!=. & dias_gestacional_furop!=. & es_embarazo_unico!=. & edad_de_embarazada!=.
 replace dhafurop=1  if dha_furop==1 & semanas_gestacional_ingres!=. & dias_gestacional_ingre!=. & es_embarazo_unico!=. & edad_de_embarazada!=.


 *list folio redcap_event_name   dhaingreso_obs if dhafurop==. 
 
****VAR Preguntas y consentimientos (filtros)
gen preguntas=1     if  es_embarazo_unico!=. & edad_de_embarazada!=.    
*replace preguntas=.  if [semanas_gestacional_ingres <= 13 & semanas_gestacional_ingres >= 5 & semanas_gestacional_ingres != 11] & es_embarazo_unico==1 & edad_de_embarazada >= 18  & aplicacion_consentimiento==.
gen consent=1       if   aplicacion_consentimiento==1 &  desea_participar==1 & fecha_aplicacion_ingreso!=. & estados_2==1
replace consent=1   if   aplicacion_consentimiento==1 &  desea_participar==0 & porque_no_desea_participar!="" & estados_2==2
  

replace dha_ingreso_complete=2 if dhafurop==1 & preguntas==1 & consent==1 & dha_fur==1 & dha_furop==1
*replace dha_ingreso_complete=2 if estados_2==2
list folio redcap_event_name  dhafurop preguntas consent dha_fur dha_furop if dha_ingreso_complete!=2 & redcap_event_name=="evaluacion1_arm_1"

****randomizacion folios**********
bysort folio: egen random=max(randomizacion)
 
 
 
///////////////////////////////////////////////////////////////////////////////ANTECEDENTES SOCIODEMOGRAFICOS DHA////////////////////////////////////////////////////////////////*******1 VISITA
****VAR obligatorio
tostring ob_niveleduc, replace force
replace ob_niveleduc="" if ob_niveleduc=="."
gen socioobligatorio=1  if estado_civil!=. & [nivel_de_esudios_de_la_emb>=3 | nivel_de_esudios_de_la_emb<=0] & nivel_de_esudios_de_la_emb!=.
replace socioobligatorio=1 if estado_civil!=. &  [nivel_de_esudios_de_la_emb==1 | nivel_de_esudios_de_la_emb==2] & nivel_de_esudios_de_la_emb!=.
****VAR Checklist
gen scheck = 0 
foreach v of varlist con_quien_vive___1 - con_quien_vive___11  { 
	replace scheck = scheck + `v' 
}
	replace scheck=.    if scheck==0 
****VAR final	
gen  sociofinal=1       if relacion_jefe_hogar!=. & numero_de_personas_en_el_h!=. &  ingreso_mensual_total_del!=. & [actividad_que_realiz== 1 &  detalle_de_actividad!=""  | actividad_que_realiz>=2 & actividad_que_realiz!=.]
replace antecedentes_sociode_v_1=2 if socioobligatorio==1 & scheck>=1 & scheck!=. & sociofinal==1 & redcap_event_name=="evaluacion1_arm_1"
replace antecedentes_sociode_v_1=2 if estados_2==2

list folio redcap_event_name if antecedentes_sociode_v_1!=2 & redcap_event_name=="evaluacion1_arm_1"



/////////////////////////////////////////////////////////////////////////////ANTECEDENTES PERSONALES Y FAMILIARES//////////////////////////////////////////////////////////////////****1 VISITA

gen diabetes=1          if ant_diabetes==1 | ant_diabetes==3 | [ant_diabetes==2 & [familiar_diabetes_quienes___1==1 | familiar_diabetes_quienes___2==1 | familiar_diabetes_quienes___3==1 | familiar_diabetes_quienes___4==1]]
****VAR hipertension
gen hipertension1=1     if  ant_familiar_hipertension==2 & [antec_fam_hipertension_qui___1==1 | antec_fam_hipertension_qui___2==1 | antec_fam_hipertension_qui___3==1 | antec_fam_hipertension_qui___4==1]
replace hipertension1=1 if ant_familiar_hipertension==1 | ant_familiar_hipertension==3
gen hipertension2=1     if  ant_morbido_de_hipertensio!=.
gen hipertension=1      if hipertension1==1 & hipertension2==1
****VAR cancer
gen cancer1=1           if ant_familiar_cancer==1 | ant_familiar_cancer==3 | [ant_familiar_cancer==2 & [ant_fam_de_cancer_quien___1==1 | ant_fam_de_cancer_quien___2==1 | ant_fam_de_cancer_quien___3==1 | ant_fam_de_cancer_quien___4==1]]
gen cancer2=1           if ant_morbido_cancer==1 | ant_morbido_cancer==3 | [ant_morbido_cancer==2 & cancer_localizaci_n!=""]
gen cancer=1            if cancer1==1 & cancer2==1
****Var Depresion
gen depresion1=1        if ant_familiar_depresion==1 | ant_familiar_depresion==3 | [ant_familiar_depresion==2 & [antec_fam_depresion_quien___1==1| antec_fam_depresion_quien___2==1 | antec_fam_depresion_quien___3==1 | antec_fam_depresion_quien___4==1]]
gen depresion2=1        if tuvo_depresion_antes_del_e==1 |  tuvo_depresion_antes_del_e==99 | [ tuvo_depresion_antes_del_e==2 & tom_tratamiento_para_la_de!=.]
gen depresion=1         if depresion1==1 & depresion2==1
****VAR salud_mental
gen saludmental=1       if tiene_problema_saludmental==1 | tiene_problema_saludmental==3 | [tiene_problema_saludmental==2 & cual_problema_de_salud_men!="" &  toma_tratamiento_por_el_pr!=""] 
****VAR consumo
**fuma
gen fuma1=1             if fumaba_antes_del_embarazo==1 | [fumaba_antes_del_embarazo==2 & cuantos_cigarros_al_d_a!=.]
gen fuma2=1             if fuma==0 | [fuma==1 & cuantos_cigarros_consume_a!=.]
gen fuma_1=1            if fuma1==1 & fuma2==1
**alcohol
gen alcohol=1           if consume_alcohol==0 | [consume_alcohol==1 & consume_alcohol_diar!=.]
**Drogas y medicamentos
gen drogas=1            if consume_droga==0 | consume_droga==1 & que_tipo_de_droga!=""
gen medicamento=1       if consumo_algun_medicamento==0 | consumo_algun_medicamento==1 & tipo_de_medicamento!=""

replace antecedentes_persona_v_2=2 if diabetes==1 & hipertension==1 & cancer==1 & depresion==1 & fuma_1==1 & drogas==1 & medicamento==1 & redcap_event_name=="evaluacion1_arm_1"
replace antecedentes_persona_v_2=2 if estados_2==2

list folio redcap_event_name diabetes hipertension cancer depresion fuma_1 drogas medicamento if antecedentes_persona_v_2!=2 & redcap_event_name=="evaluacion1_arm_1"



///////////////////////////////////////////////////////////////////////////////////ANTECEDENTES OBSTETRICOS /////////////////////////////////////////////////////////////////////****1 VISITA
***VAR  Obligatorias***
gen obstetrico=1        if diabetes_gest_anterior!=. &  numero_de_embarazos!=. & numero_de_hijos_vivos!=. &  ud_hipertension_emb!=. & uso_de_forceps!=. 
***VAR Filtros***
gen diabgest=1          if ant_familiar_diabeteges==1 | ant_familiar_diabeteges==3 | ant_familiar_diabeteges==2 & [familiar_diab_gest___1==1 | familiar_diab_gest___2==1 | familiar_diab_gest___3==1]
gen hipert=1         
gen abort=1             if aborto_perdida==1 | aborto_perdida==2 & n_de_abortos_que_ha_tendi!=.
gen prem=1              if ud_tuvo_partos_prematuros==1 | ud_tuvo_partos_prematuros==2 &  n_partos_prematuros!=. 
gen mortinato=1         if ha_tenido_mortinatos==1 | ha_tenido_mortinatos==2 &  n_mortinatos!=.
gen mortineo=1          if ha_tenido_mortineonatos==1 |  ha_tenido_mortineonatos==2 & n_mortineonatos!=.
gen cesarea=1           if ha_tenido_cesarias==1 | ha_tenido_cesarias==2 &  n_de_cesareas!=.
////VAR Complete
gen checkobs=1          if obstetrico==1 &  diabgest==1 & hipert==1 & abort==1 & prem==1 & mortinato==1 & mortineo==1 & cesarea==1 
replace  antecedentes_obstetr_v_3=2 if checkobs==1
replace antecedentes_obstetr_v_3=2  if estados_2==2
list folio obstetrico  diabgest hipert abort prem mortinato  mortineo cesarea if antecedentes_obstetr_v_3!=2 & redcap_event_name=="evaluacion1_arm_1"
*SE SACA GESTA Y PARA


////////////////////////////////////////////////////////////////////////////////////////ANTROPOMETRIA ///////////////////////////////////////////////////////////////////////////////// *********1 3 5 VISITAS
*keep if redcap_event_name=="evaluacion1_arm_1"
****VAR  todas las visitas obligatorio (Presion)
gen obpresion=1         if presion_alterial_sistolica!=. & presion_arterial_diastolic!=. &  pulso_presion_arterial_1!=. & presion_ar_sistolica2!=. &  presion_ar_diastolic2!=. &  peso_embarazada!=.
****VAR Filtros
gen diagbetes=1         if diagnosticado_diabeges==0 | diagnosticado_diabeges==1 &  fecha_de_diagnostico_diab!=.
gen medic=1             if meds==2 | meds==1 &  nombre_meds!="" &  fecha_meds!=.
replace medic=1         if fecha_visita<date("12/01/2016","DMY") 
***VAR  talla (Solo primera visita)
destring peso_pregestacional, replace force
gen talla=1             if peso_pregestacional!=. &  [talla_embarazada!=. |  talla_embarazada2!=. ] 
replace talla=1         if obpresion!=. & diagbetes!=. &  medic!=. & talla==. & redcap_event_name!="evaluacion1_arm_1"
****VAR Complete antro
gen checkantro=1        if obpresion==1 & diagbetes==1 & medic==1  & talla==1 
replace antropometria_dha_complete=2 if checkantro==1
replace antropometria_dha_complete=2 if estados_2==2
 
list   folio obpresion  diagbetes  medic talla  if  antropometria_dha_complete!=2 & [ redcap_event_name=="evaluacion1_arm_1" | redcap_event_name=="evaluacion3_arm_1" | redcap_event_name=="evaluacion5_arm_1"]


/////////////////////////////////////////////////////////////////////////////////////////FFQ////////////////////////////////////////////////////////////////////////////////////////// ************1 Y 5  VISITAS
////VAR inicio
gen inicio=1            if  hora_inicio!="" &  nutri_ffq!=.
////observaciones en un solo lado par foreach

order observaciones_101 observaciones_102 observaciones_103 observaciones_104 observaciones_105 observaciones_201 observaciones_202 observaciones_203 observaciones_301 observaciones_302 observaciones_303 observaciones_304 observaciones_305 observaciones_306 observaciones_307 observaciones_308 observaciones_309 observaciones_401 observaciones_402 observaciones_403 observaciones_404 observaciones_501 observaciones_502 observaciones_503 observaciones_504 observaciones_601 observaciones_602 observaciones_603 observaciones_604 observaciones_605 observaciones_606 observaciones_607 observaciones_608 observaciones_609 observaciones_610 observaciones_611 observaciones_612 observaciones_701 observaciones_702 observaciones_801 observaciones_802 observaciones_803 observaciones_804 observaciones_901 observaciones_902 observaciones_903 observaciones_904 observaciones_905 observaciones_906 observaciones_1001 observaciones_1002 observaciones_1003 observaciones_1004 observaciones_1005 observaciones_1006 observaciones_1007 observaciones_1008 observaciones_1009 observaciones_1010 observaciones_1011 observaciones_1012 observaciones_1013 observaciones_1101 observaciones_1102 observaciones_1103 observaciones_1104 observaciones_1201 observaciones_1202 observaciones_1301 observaciones_1302 observaciones_1303 observaciones_1304 observaciones_1305 observaciones_1306 observaciones_1307 observaciones_1308 observaciones_1401 observaciones_1402 observaciones_1403 observaciones_1404 observaciones_1405 observaciones_1406 observaciones_1501 observaciones_1502 observaciones_1503 observaciones_1504 observaciones_1505 observaciones_1506 observaciones_1507 observaciones_1508 observaciones_1509 observaciones_1510 observaciones_1511 observaciones_1601 observaciones_1602 observaciones_1603 observaciones_1604 observaciones_1605 observaciones_1606 observaciones_1607 observaciones_1608 observaciones_1701 observaciones_1702 observaciones_1703 observaciones_1704 observaciones_1801, after(hora_termino)
foreach v of varlist observaciones_101-observaciones_1801{
tostring `v', replace
replace `v'="" if `v'=="."
}
////VAR Cereales
gen arroz=1      if  a_101<19 | a_101==19 & observaciones_101!=""
gen fideos=1     if  a_102<19 | a_102==19 & observaciones_102!=""
gen cereal=1     if  a_103<19 | a_103==19 & observaciones_103!=""
gen avena=1      if  a_104<19 | a_104==19 & observaciones_104!=""
gen choclo=1     if  a_105<19 | a_105==19 & observaciones_105!=""
gen seccereal=1  if arroz==1 & fideos==1 & cereal==1 & avena==1 & choclo==1
////Var Tuberculos
gen papa=1       if  a_201<19 | a_201==19 & observaciones_201!=""
gen pure=1       if  a_202<19 | a_202==19 & observaciones_202!=""
gen fritas=1     if  a_203<19 | a_203==19 & observaciones_203!=""
gen sectuber=1   if  papa==1 & pure==1 & fritas==1
//// VAR Panaderia
gen marraqueta=1 if  a_301==10 | a_301==11 | a_301>11 & a_301<19 & a_301_miga!=. | a_301==19 & a_301_miga!=. & observaciones_301!=""
gen hallulla=1   if  a_302<19 | a_302==19 & observaciones_302!=""
gen molde=1      if  a_303<19 | a_303==19 & observaciones_303!=""
gen amasado=1    if  a_304<19 | a_304==19 & observaciones_304!=""
gen frica=1      if  a_305<19 | a_305==19 & observaciones_305!=""
gen pascua=1     if  a_306<19 | a_306==19 & observaciones_306!=""
gen sopaipilla=1 if  a_307<19 | a_307==19 & observaciones_307!=""
gen queque=1     if  a_308<19 | a_308==19 & observaciones_308!=""
gen torta=1      if  a_309<19 | a_309==19 & observaciones_309!=""
gen secpan=1     if  marraqueta==1 & hallulla==1 & molde==1 & amasado==1 & frica==1 & pascua==1 & sopaipilla==1 & queque==1 & torta==1 
////VAR Galletas
gen sinrelleno=1 if  a_401<19 | a_401==19 & observaciones_401!=""
gen conrelleno=1 if  a_402<19 | a_402==19 & observaciones_402!=""
gen soda=1       if  a_403<19 | a_403==19 & observaciones_403!=""
gen craket=1     if  a_404<19 | a_404==19 & observaciones_404!=""
gen secgallet=1 if sinrelleno==1 & conrelleno==1 & soda==1 & craket==1
////VAR Snack
gen cheetoos=1   if  a_501<19 | a_501==19 & observaciones_501!=""
gen barras=1     if  a_502<19 | a_502==19 & observaciones_502!=""
gen alfajor=1    if  a_503<19 | a_503==19 & observaciones_503!=""
gen oblea=1      if  a_504<19 | a_504==19 & observaciones_504!=""
gen secsnack=1   if  cheetoos==1 & barras==1 & alfajor==1 & oblea==1
///VAR azucar
gen miel=1       if  a_601<19 | a_601==19 & observaciones_601!=""
gen saborizant=1 if  a_602<19 | a_602==19 & observaciones_602!=""
gen caramelo=1   if  a_603<19 | a_603==19 & observaciones_603!=""
gen koyack=1     if  a_604<19 | a_604==19 & observaciones_604!="" 
gen cbarra=1     if  a_605<19 | a_605==19 & observaciones_605!=""
gen crelleno=1   if  a_606<19 | a_606==19 & observaciones_606!=""
gen manjar=1     if  a_607<19 | a_607==19 & observaciones_607!=""
gen jalea=1      if  a_608<19 | a_608==19 & observaciones_608!=""
gen semola=1     if  a_609<19 | a_609==19 & observaciones_609!=""
gen mermelada=1  if  a_610<19 | a_610==19 & observaciones_610!=""
gen compota=1    if  a_611<19 | a_611==19 & observaciones_611!=""
gen cafe=1       if  a_612<19 | a_612==19 & observaciones_612!=""
gen secazucar=1  if miel==1 & saborizant==1 & caramelo==1 & koyack==1 & cbarra==1 & crelleno==1 & manjar==1 & jalea==1 & semola==1 & compota==1 & cafe==1 
////VAR helado
gen cassata=1    if  a_701<19 | a_701==19 & observaciones_701!=""
gen cono=1       if  a_702<19 | a_702==19 & observaciones_702!=""
gen sechelado=1  if cassata==1 & cono==1
////VAR Bebidad y jugos
gen bebida=1     if  a_801<19 | a_801==19 & observaciones_801!=""
gen pulpa=1      if  a_802<19 | a_802==19 & observaciones_802!=""
gen polvo=1      if  a_803<19 | a_803==19 & observaciones_803!=""
gen nectar=1     if  a_804<19 | a_804==19 & observaciones_804!=""
gen secbebida=1  if bebida==1 & pulpa==1 & polvo==1 & nectar==1
////Var frutas
gen platano=1    if  a_901<19 | a_901==19 & observaciones_901!=""
gen manzana=1    if  a_902<19 | a_902==19 & observaciones_902!=""
gen naranja=1    if  a_903<19 | a_903==19 & observaciones_903!=""
gen limon=1      if  a_904<19 | a_904==19 & observaciones_904!=""
gen pera=1       if  a_905<19 | a_905==19 & observaciones_905!=""
gen kiwi=1       if  a_906<19 | a_906==19 & observaciones_906!=""
gen secfruta=1   if platano==1 & manzana==1 & naranja==1 & limon==1 & pera==1 & kiwi==1
////VAR frutas temporadas
gen membrillo=1  if a_1001<19 | a_1001==19 & observaciones_1001!=""
gen mandarina=1  if a_1002<19 | a_1002==19 & observaciones_1002!=""
gen frutilla=1   if a_1003<19 | a_1003==19 & observaciones_1003!=""
gen chirimoya=1  if a_1004<19 | a_1004==19 & observaciones_1004!=""
gen melon=1      if a_1005<19 | a_1005==19 & observaciones_1005!=""
gen sandia=1     if a_1006<19 | a_1006==19 & observaciones_1006!=""
gen damasco=1    if a_1007<19 | a_1007==19 & observaciones_1007!=""
gen durazno=1    if a_1008<19 | a_1008==19 & observaciones_1008!="" 
gen uva=1        if a_1009<19 | a_1009==19 & observaciones_1009!="" 
gen arandano=1   if a_1010<19 | a_1010==19 & observaciones_1010!="" 
gen higo=1       if a_1011<19 | a_1011==19 & observaciones_1011!=""
gen cereza=1     if a_1012<19 | a_1012==19 & observaciones_1012!=""
gen season1=1    if estacion==1 &  membrillo==1 & mandarina==1 
gen season2=1      if estacion==2 & frutilla==1   & chirimoya==1 & melon==1 & sandia==1 & damasco==1 & durazno==1  & uva==1 & arandano==1 & higo==1  & cereza==1 
gen secfruttem=1 if season1==1 | season2==1
////VAR jugos naturales 
gen secjugonat=1 if a_1013<19 | a_1013==19 & observaciones_1013!=""
////VAR Verduras y hortalizas
gen tomate=1     if a_1101<19 | a_1101==19 & observaciones_1101!="" 
gen zanahoria=1  if a_1102<19 | a_1102==19 & observaciones_1102!=""
gen lechuga=1    if a_1103<19 | a_1103==19 & observaciones_1103!=""
gen repollo=1    if a_1104<19 | a_1104==19 & observaciones_1104!=""
gen secverdura=1 if tomate==1 & zanahoria==1 & lechuga==1 & repollo==1
////VAR legumbres 
gen lentejas=1   if a_1201<19 | a_1201==19 & observaciones_1201!=""
gen porotos=1    if a_1202<19 | a_1202==19 & observaciones_1202!=""
gen seclegumbr=1 if lenteja==1 & porotos==1
////VAR carne
gen vacuno=1     if a_1301<19 | a_1301==19 & observaciones_1301!=""
gen pollo=1      if a_1302<19 | a_1302==19 & observaciones_1302!=""
gen cerdo=1      if a_1303<19 | a_1303==19 & observaciones_1303!=""
gen pez=1        if a_1304<19 | a_1304==19 & observaciones_1304!=""
gen pescado=1    if a_1305<19 | a_1305==19 & observaciones_1305!="" 
gen hamburgesa=1 if a_1306<19 | a_1306==19 & observaciones_1306!="" 
gen nugget=1     if a_1307<19 | a_1307==19 & observaciones_1307!=""
gen huevo=1      if a_1308<19 | a_1308==19 & observaciones_1308!=""
gen seccarne=1   if vacuno==1 & pollo==1 & cerdo==1 & pez==1 & pescado==1 & hamburgesa==1 & nugget==1 & huevo==1 
////VAR embutidos
gen vienessas=1  if a_1401<19 | a_1401==19 & observaciones_1401!="" 
gen jamons=1     if a_1402<19 | a_1402==19 & observaciones_1402!="" 
gen jamonp=1     if a_1403<19 | a_1403==19 & observaciones_1403!=""
gen salame=1	 if a_1404<19 | a_1404==19 & observaciones_1404!=""
gen chorizo=1    if a_1405<19 | a_1405==19 & observaciones_1405!=""
gen pate=1       if a_1406<19 | a_1406==19 & observaciones_1406!=""
gen secembutid=1 if vienessas==1 & jamons==1 & jamonp==1 & salame==1 & chorizo==1 & pate==1
///VAR lacteos
gen ranco=1      if a_1501<19 | a_1501==19 & observaciones_1501!=""
gen quesillo=1   if a_1502<19 | a_1502==19 & observaciones_1502!="" 
gen purita=1     if a_1503<19 | a_1503==19 & observaciones_1503!="" 
gen entera=1     if a_1504<19 | a_1504==19 & observaciones_1504!="" 
gen descremada=1 if a_1505<19 | a_1505==19 & observaciones_1505!="" 
gen chocolate =1 if a_1506<19 | a_1506==19 & observaciones_1506!=""
gen polentera=1  if a_1507<19 | a_1507==19 & observaciones_1507!="" 
gen polentdes=1  if a_1508<19 | a_1508==19 & observaciones_1508!="" 
gen yogurt=1     if a_1509<19 | a_1509==19 & observaciones_1509!="" 
gen yogdes=1     if a_1510<19 | a_1510==19 & observaciones_1510!="" 
gen cultivada=1  if a_1511<19 | a_1511==19 & observaciones_1511!="" 
gen seclacteo=1  if ranco==1 & quesillo==1 & purita==1 & entera==1 & descremada==1 & chocolate==1 & polentera==1 & polentdes==1 & yogurt==1 & yogdes==1 & cultivada==1 
////VAR preparacionea
gen pastelcho=1  if a_1601<19 | a_1601==19 & observaciones_1601!="" 
gen pantruca=1   if a_1602<19 | a_1602==19 & observaciones_1602!="" 
gen lasagna=1    if a_1603<19 | a_1603==19 & observaciones_1603!="" 
gen bolonesa=1   if a_1604<19 | a_1604==19 & observaciones_1604!="" 
gen stomate=1    if a_1605<19 | a_1605==19 & observaciones_1605!="" 
gen pizza=1      if a_1606<19 | a_1606==19 & observaciones_1606!="" 
gen emphorno=1   if a_1607<19 | a_1607==19 & observaciones_1607!="" 
gen empfrita=1   if a_1608<19 | a_1608==19 & observaciones_1608!=""
gen secpreparacion=1 if pastelcho==1 & pantruca==1 & lasagna==1 & bolonesa==1 & stomate==1 & pizza==1 & emphorno==1 & empfrita==1 
////VAR aceites
gen palta=1      if a_1701<19 | a_1701==19 & observaciones_1701!="" 
gen mayonesa=1   if a_1702<19 | a_1702==19 & observaciones_1702!="" 
gen mantequill=1 if a_1703<19 | a_1703==19 & observaciones_1703!=""
gen aceite=1     if a_1704<19 | a_1704==19 & observaciones_1704!="" 
gen secaceite=1  if palta==1 & mayonesa==1 & mantequill==1 & aceite==1 
////VAR sal
gen secsal=1        if a_1801<19 | a_1801==19 & observaciones_1801!=""
////VAR Agua
gen secagua=1       if a_1901!=.
////VAR alimentos
tostring a_2003, replace force
order a_2003 a_2007 a_2011, before(ffq_complete)
foreach v of varlist a_2003-a_2011 {
 tostring `v', replace force
  replace `v'="" if `v'=="." 
  }
 order a_2002_a a_2006_a a_2010_a ,before(ffq_complete)
 foreach v of varlist a_2002_a-a_2010_a{
 tostring `v', replace force
  replace `v'="" if `v'=="."
  }
gen alim1=1     if a_2001=="" | a_2001!="" & [a_2002<9  & a_2003!="" & a_2004!=. | a_2002==9 & a_2002_a!="" & a_2003!="" & a_2004!=.]
gen alim2=1     if a_2005=="" | a_2005!="" & [a_2006<9  & a_2007!="" & a_2008!=. | a_2006==9 & a_2006_a!="" & a_2007!="" & a_2008!=.]
gen alim3=1     if a_2009=="" | a_2009!="" & [a_2010<9  & a_2011!="" & a_2012!=. | a_2010==9 & a_2010_a!="" & a_2011!="" & a_2012!=.]
gen secalim=1   if alim1==1 & alim2==1 & alim3==1

////VAR endulzante
gen endcheck = 0 
foreach v of varlist a_2102___1 - a_2102___4  { 
	replace endcheck = endcheck + `v' 
}
 gen secendulz=1 if     a_2101==0 & endcheck==0 & a_2108==. & a_2109==. & a_2110=="" & a_2111==.
 replace secendulz=1 if a_2101==1 & endcheck>0 & a_2102___1==1 & a_2107!=.
 replace secendulz=1 if a_2101==1 & endcheck>0 & a_2102___2==1 & a_2108!=.
 replace secendulz=1 if a_2101==1 & endcheck>0 & a_2102___3==1 & a_2109!=.
 replace secendulz=1 if a_2101==1 & endcheck>0 & a_2102___4==1 & a_2110!="" & a_2111!=.
////VAR cambios en la dieta
 gen seccamb=1 if a_2201!=. &  a_2202!=. & a_2203!=. & a_2204!=. &  a_2205!=. & a_2206!=. & a_2207!=. & hora_termino!="" & ffq!=.
 //////VAR complete////////////////////////////
 replace ffq_complete=2 if inicio==1 & seccereal==1 & sectuber==1 & secpan==1 & secgallet==1 & secsnack==1 & secazucar==1 & sechelado==1 & secbebida==1 & secfruta==1 & secfruttem==1 & secjugonat==1 & secverdura==1 & seclegumbr==1 & seccarne==1 & secembutid==1 & seclacteo==1 & secpreparacion==1 & secaceite==1 & secsal==1 & secagua==1 & secalim==1 & secendulz==1 & seccamb==1 & [redcap_event_name=="evaluacion1_arm_1" | redcap_event_name=="evaluacion5_arm_1"]
 replace ffq_complete=. if redcap_event_name=="evaluacion2__llama_arm_1"  | redcap_event_name=="evaluacion4_llamad_arm_1" | redcap_event_name=="evaluacion3_arm_1"
 replace ffq_complete=2 if estados_2==2
 replace ffq_complete=. if inicio==. & seccereal==. & sectuber==. & secpan==. & secgallet==. & secsnack==. & secazucar==. & sechelado==. & secbebida==. & secfruta==. & secfruttem==. & secjugonat==. & secverdura==. & seclegumbr==. & seccarne==. & secembutid==. & seclacteo==. & secpreparacion==. & secaceite==. & secsal==. & secagua==. & secendulz==. & seccamb==. & [redcap_event_name=="evaluacion1_arm_1" | redcap_event_name=="evaluacion5_arm_1"]
 gen ffq_vacio=1 if inicio==. & seccereal==. & sectuber==. & secpan==. & secgallet==. & secsnack==. & secazucar==. & sechelado==. & secbebida==. & secfruta==. & secfruttem==. & secjugonat==. & secverdura==. & seclegumbr==. & seccarne==. & secembutid==. & seclacteo==. & secpreparacion==. & secaceite==. & secsal==. & secagua==. & secendulz==. & seccamb==. & [redcap_event_name=="evaluacion1_arm_1" | redcap_event_name=="evaluacion5_arm_1"]

//////////Incidencias FFQ/////////////////
 list folio redcap_event_name inicio  seccereal sectuber secpan secgallet secsnack secazucar sechelado secbebida secfruta secfruttem secjugonat secverdura seclegumbr seccarne secembutid seclacteo secpreparacion secaceite secsal secagua secalim secendulz seccamb ffq_obs if ffq_complete==1 & [redcap_event_name=="evaluacion1_arm_1" | redcap_event_name=="evaluacion5_arm_1"]
 

 
/////////////////////////////////////////////////////////////////////////////////////////INTERVENCION/////////////////////////////////////////////////////////////////////////////////////////////////*****1 2 3 VISITAS
gen inobligatorio=1      if fecha_intervenci_n!=. & semana_gestaci_n_consejeri!=. & dias_gestacion_consejeria!=. & [se_realiza_consejeria==1 | se_realiza_consejeria==2 & porque_no_se_realiza!="" ]
replace intervencion_complete=2 if  inobligatorio==1 & randomiz_visita>=3 & [redcap_event_name=="evaluacion1_arm_1" |  redcap_event_name=="evaluacion2__llama_arm_1" | redcap_event_name=="evaluacion3_arm_1"]
replace intervencion_complete=1 if  inobligatorio!=1 & [randomiz_visita>=3 & randomiz_visita!=.]
replace intervencion_complete=. if [randomiz_visita<3 & randomiz_visita!=.]
replace intervencion_complete=2 if estados_2==2

list folio redcap_event_name randomiz_visita fecha_intervenci_n semana_gestaci_n_consejeri dias_gestacion_consejeria se_realiza_consejeria  porque_no_se_realiza  intervencion_obs if intervencion_complete==1  & [redcap_event_name=="evaluacion1_arm_1" |  redcap_event_name=="evaluacion2__llama_arm_1" | redcap_event_name=="evaluacion3_arm_1"]


///////////////////////////////////////////////////////////////////////////////////////REGISTRO DE PASTILLAS//////////////////////////////////////////////////////////////////////////////////////////********1 2 3 4 5 VISITAS 
***VAR seccion Registro de entrega de pastilla (MEDICIONES)////////////*/


////VAR Adherencia (MEDICIONES)
gen checkadh1=0
foreach v of varlist consume_pastilla_no___1 - consume_pastilla_no___5{
 
	replace checkadh1 = checkadh1 + `v' 
}   
gen adher=1 if  consume_pastilla==1 | consume_pastilla==2 & checkadh1>0


gen checkadh2=0
foreach v of  varlist sintoma_dha___1 - sintoma_dha___5{
 
	replace checkadh2 = checkadh2 + `v' 
} 
replace adher=.        if  consume_pastilla_no___2==1 & checkadh2==0 | consume_pastilla_no___2==1 &  sintoma_dha___5==1 &  otro_sintoma_dha==""
replace adher=.        if  consume_pastilla_no___4==1 & consume_pastilla_no_otro=="" |  consume_pastilla_no___3==1 & olvido==.
replace adher=1        if  redcap_event_name=="evaluacion1_arm_1"
***no considerar visita 1
gen checknovist1=0
foreach v of varlist reg_noserio___1 - reg_noserio___99{
 
	replace checknovist1 = checknovist1 + `v' 
}   
 gen efectos=1         if ha_sentido_molestias_al_to==2 | ha_sentido_molestias_al_to==1 & checknovist1>0 | consume_pastilla==2 & ha_sentido_molestias_al_to==.
 replace efectos=.     if reg_noserio___99==1 & reg_otros1==""
 replace efectos=1     if redcap_event_name=="evaluacion1_arm_1"
gen checkeval=0
foreach v of varlist ea_gravedad_eval___1 - ea_gravedad_eval___6{
 
	replace checkeval = checkeval + `v' 
}  
gen eventoadv=1        if ea_eval==0 | ea_eval==1 &  ea_descripcion_eval!="" & [ea_grave_eval==0 | [ea_grave_eval==1 & checkeval>0]]
replace eventoadv=1    if redcap_event_name=="evaluacion1_arm_1"
***Resolucion evento adverso, no es diario
*gen res=1 if resolucion_ea_eval!="" & solucion_ea_eval!="" & fecha_ea_eval!=.
 
////VAR seccion Registro de devolucion de pastillas (MEDICIONES) solo visitas  3 y 5

gen devol=1             
////VAR Pastillas consumidas (MEDICIONES)
***Solo visita 3 y 5 o estado abandono o aborto ([visita_tipo] = '3' or [visita_tipo] = '5' or [estado_3] = '4' or [estado_3] = '2')***antiguo***
gen pasconsum=.        if  ultima_pastilla==. & [visita_tipo==3 | visita_tipo==5]
replace pasconsum=1    if  ultima_pastilla!=. & [visita_tipo==3 | visita_tipo==5]
replace pasconsum=1    if  visita_tipo==1 | visita_tipo==2 | visita_tipo==4
////VAR participa
gen participa=1        if  [sigue_participando==1 | sigue_participando==2 & no_sigue_participando!=""] 
replace participa=1    if  redcap_event_name=="evaluacion1_arm_1"

////VAR complete
replace registro_pastilla_complete=2 if adher==1  & efectos==1 & participa==1 & pasconsum==1 
replace registro_pastilla_complete=2 if adher==1  & efectos==1 & participa==1 &  pasconsum==. & [[visita_tipo==1 & [ estados_3!=4 & estados_3!=2]] | [ visita_tipo== 2 | visita_tipo== 4]]
replace registro_pastilla_complete=1 if adher==1  & efectos==1 & participa==1 &  pasconsum==. & [visita_tipo==3 | visita_tipo== 5 | estados_3==4 | estados_3==2]
replace registro_pastilla_complete=2 if vis_entrega==1 & adher==1  & efectos==1 & participa==1 & pasconsum==1 
replace registro_pastilla_complete=2 if estados_2==2

///////////INCIDENCIAS///////////////////////////////////////
list  folio  redcap_event_name adher efectos eventoadv participa  pasconsum eventoadv if registro_pastilla_complete!=2
count if registro_pastilla_complete!=2


//////////////////////////////////////////////////////////////////////////////////////////////CHECKLIST//////////////////////////////////////////////////////////////////////////////////////////////////*******1 VISITA
gen checkchek=1   if       firma_cc!=. & random_folio!=. & agenda_mujer!=. &  orden_examen!=. &  foto_agenda_mujer!=. &  foto_ci!=. & i_dieta!=.
replace checklist_complete=2 if checkchek==1
replace checklist_complete=2 if estados_2==2
replace checklist_complete=. if   firma_cc==. & random_folio==. & agenda_mujer==. & orden_examen==. & foto_agenda_mujer==. & foto_ci==. & i_dieta==.
//////////Incidencia////////////////
sort fecha_visita
list folio fecha_visita  firma_cc random_folio agenda_mujer orden_examen foto_agenda_mujer foto_ci i_dieta if checklist_complete!=2 & redcap_event_name=="evaluacion1_arm_1" & foto_ci!=. & i_dieta ==.



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////COMPLETE/////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////CONTACTO////////////////////****1 VISITA
///
replace contacto_y_reclutami_v_0=.    if redcap_event_name=="evaluacion2__llama_arm_1" | redcap_event_name=="evaluacion3_arm_1" | redcap_event_name=="evaluacion4_llamad_arm_1" | redcap_event_name=="evaluacion5_arm_1" 
///////////////////////ESTADO DE LA MADRE/////////////////////////////////////////****1 VISITA
/// 
replace estado_de_la_madre_complete=. if redcap_event_name=="evaluacion2__llama_arm_1" | redcap_event_name=="evaluacion3_arm_1" | redcap_event_name=="evaluacion4_llamad_arm_1" | redcap_event_name=="evaluacion5_arm_1" 
///////////////////////////////////////VISITA/////////////////////////////////////////////****1 2 3 4 5 VISITA
/// 
replace visita_dha_complete=.         if estados_2==2 & visita_dha_complete==9 & redcap_event_name=="evaluacion1_arm_1"

//////////////////////////////////DHA INGRESO/////////////////////////////////////////////////////****1 VISITA
/// 
replace dha_ingreso_complete=.        if [estados_2==2 & visita_dha_complete==9 & redcap_event_name=="evaluacion1_arm_1"] | redcap_event_name=="evaluacion2__llama_arm_1" | redcap_event_name=="evaluacion3_arm_1" | redcap_event_name=="evaluacion4_llamad_arm_1" | redcap_event_name=="evaluacion5_arm_1" 
////////////////////////////////////////////////////////ANTECEDENTES SOCIODEMOGRAFICOS DHA/////////////****1 VISITA
///
replace antecedentes_sociode_v_1=.    if [estados_2==2  & redcap_event_name=="evaluacion1_arm_1"] | redcap_event_name=="evaluacion2__llama_arm_1" | redcap_event_name=="evaluacion3_arm_1" | redcap_event_name=="evaluacion4_llamad_arm_1" | redcap_event_name=="evaluacion5_arm_1" 
/////////////////////////////////////ANTECEDENTES PERSONALES Y FAMILIARES/////////****1 VISITA
/// 
replace antecedentes_persona_v_2=.    if [estados_2==2 & redcap_event_name=="evaluacion1_arm_1"] | redcap_event_name=="evaluacion2__llama_arm_1" | redcap_event_name=="evaluacion3_arm_1" | redcap_event_name=="evaluacion4_llamad_arm_1" | redcap_event_name=="evaluacion5_arm_1" 
////////////////////////////////////////ANTECEDENTES OBSTETRICOS ////////////****1 VISITA
/// 
replace  antecedentes_obstetr_v_3=.   if [estados_2==2  & redcap_event_name=="evaluacion1_arm_1"] | redcap_event_name=="evaluacion2__llama_arm_1" | redcap_event_name=="evaluacion3_arm_1" | redcap_event_name=="evaluacion4_llamad_arm_1" | redcap_event_name=="evaluacion5_arm_1" 
////////////////////////////////////////ANTROPOMETRIA ////////////****1 2 3 VISITA
/// 
replace antropometria_dha_complete=.  if [estados_2==2 & redcap_event_name=="evaluacion1_arm_1"] | redcap_event_name=="evaluacion2__llama_arm_1" | redcap_event_name=="evaluacion4_llamad_arm_1" | vis_entrega==1

////////////////////////////////////////FFQ////////////****1  5 VISITA
/// 
replace ffq_complete=.                if [estados_2==2 & redcap_event_name=="evaluacion1_arm_1"] |  redcap_event_name=="evaluacion2__llama_arm_1" | redcap_event_name=="evaluacion3_arm_1" | redcap_event_name=="evaluacion4_llamad_arm_1" 
 
////////////////////////////////////////INTERVENCION////////////****1 2 3 VISITA
/// 
replace intervencion_complete=.       if  estados_2==2 & redcap_event_name=="evaluacion1_arm_1" |  randomiz_visita<=2 & [redcap_event_name!="evaluacion4_llamad_arm_1" | redcap_event_name!="evaluacion5_arm_1" ] | [redcap_event_name=="evaluacion4_llamad_arm_1" | redcap_event_name=="evaluacion5_arm_1" ]
////////////////////////////////////////REGISTRO DE PASTILLAS////////////****1 2 3 4 5 VISITA
/// 
replace registro_pastilla_complete=.  if [estados_2==2 & redcap_event_name=="evaluacion1_arm_1"] 
///////////////////////////////////////////CHECKLIST////////////////////*******1 VISITA
///
replace checklist_complete=.          if [estados_2==2 & redcap_event_name=="evaluacion1_arm_1"] | redcap_event_name=="evaluacion2__llama_arm_1" | redcap_event_name=="evaluacion3_arm_1" | redcap_event_name=="evaluacion4_llamad_arm_1" | redcap_event_name=="evaluacion5_arm_1" 





///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////INCIDENCIAS///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////CONTACTO///////////////////////////////////////
 ///Incidencias 
list folio fecha_visita fecha_llamada telef_reclut redcap_event_name cobligatorio diabetescheck  otrocheck criteriocheck  randomcheck  direccioncheck telefonocheck redescheck vistacheck gestion contacto_obs if contacto_y_reclutami_v_0!=2 & redcap_event_name=="evaluacion1_arm_1"
*replace contacto_y_reclutami_v_0=2 if  
*Calidad
list folio fecha_visita fecha_llamada telef_reclut redcap_event_name usa_insulina cumple_con_los_criterios acepta_participar if calidad_cont==1

//////////////////////////////////////ESTADO DE LA MADRE//////////////////////////////////
/// Incidencias//

list folio fecha_visita vis_nutri estados_3 redcap_event_name estadofinal fechas contacto devolucion estado_obs est_obs2 if estado_de_la_madre_complete!=2 & redcap_event_name=="evaluacion1_arm_1" & devolucion==1
list folio fecha_visita vis_nutri est_date6 furr est_date8 furop est_date9 est_date11 fpp if fechas==. & estado_de_la_madre_complete!=2 & redcap_event_name=="evaluacion1_arm_1"
replace estado_de_la_madre_complete=2  if folio==7052 & redcap_event_name=="evaluacion1_arm_1" 



/////////////////////////////////////////VISITA///////////////////////////////////////////
/// Incidencias//
list folio fecha_visita vis_nutri redcap_event_name  visita_obs if visita_dha_complete!=2
*replace visita_dha_complete=2 if folio==7705
***Si visitas tienen misma fecha
duplicates  list folio fecha_visita 
****Error en el tipo de visita
gen     errorvis=1 if redcap_event_name=="evaluacion1_arm_1" & visita_tipo!=1
replace errorvis=1 if redcap_event_name=="evaluacion2__llama_arm_1" & visita_tipo!=2
replace errorvis=1 if redcap_event_name=="evaluacion3_arm_1" & visita_tipo!=3
replace errorvis=1 if redcap_event_name=="evaluacion4_llamad_arm_1" & visita_tipo!=4
replace errorvis=1 if redcap_event_name=="evaluacion5_arm_1" & visita_tipo!=5

////Incidencias calidad
list folio fecha_visita vis_nutri redcap_event_name  visita_obs if errorvis==1
*replace visita_dha_complete=1 if errorvis==1

//////////////////////////////////////DHA INGRESO/////////////////////////////////////////
/// Incidencias//
replace dha_ingreso_complete=2 if   preguntas==1 & consent==1 
list folio fecha_visita vis_nutri redcap_event_name  dhafurop preguntas consent  dha_fur est_date6 dha_furop est_date8 dhaingreso_obs if dha_ingreso_complete!=2 & redcap_event_name=="evaluacion1_arm_1" 
***Incidencias si aplicacion de consentimiento esta mal ingresado///
////Incidencias calidad
*list folio fecha_visita vis_nutri redcap_event_name consent checkcons  if checkcons==. & redcap_event_name=="evaluacion1_arm_1" & dha_ingreso_complete!=2
*replace dha_ingreso_complete=2 if folio==15210 | folio==15223 


//////////////////////////////////////RANDOMIZACION/////////////

//Si randomizacion de contacto y dha ingreso no coinciden. En caso de que no coincida por incompletitud de contacto dejar como incidencia solo de contacto y reclutamiento

////Incidencias calidad
gen  randomizok=1 if randomizacion_contac==1 & redcap_event_name=="evaluacion1_arm_1" & [randomizacion==1 | randomizacion==2] | randomizacion_contac==2 & [randomizacion==3 | randomizacion==4]
replace randomizok=1 if randomizacion_contac==. 
replace randomizok=1 if estados_2==2
*replace randomizok=1 if folio==7489 | folio==7549 | folio==7845
list folio fecha_visita vis_nutri redcap_event_name if randomizok!=1 & redcap_event_name=="evaluacion1_arm_1"

/////////////////////////////////ANTECEDENTES SOCIODEMOGRAFICOS DHA///////////////////////
/// Incidencias//
list folio fecha_visita vis_nutri redcap_event_name ant_socio_obs if antecedentes_sociode_v_1!=2 & redcap_event_name=="evaluacion1_arm_1" 
**Estas incidencias no se consideran y que tiene un comentario en el globito de cada variable vacia
replace antecedentes_sociode_v_1=2 if folio==7328 & redcap_event_name=="evaluacion1_arm_1"
replace antecedentes_sociode_v_1=2 if folio==7915 & redcap_event_name=="evaluacion1_arm_1"

 ////////////////////////////////ANTECEDENTES PERSONALES Y FAMILIARES/////////////////////****1 VISITA
/// Incidencias//
list folio fecha_visita vis_nutri redcap_event_name diabetes hipertension cancer depresion fuma_1 drogas medicamento ant_fami_obs if antecedentes_persona_v_2!=2 & redcap_event_name=="evaluacion1_arm_1"
replace antecedentes_persona_v_2=2 if folio==7325 & redcap_event_name=="evaluacion1_arm_1"
replace antecedentes_persona_v_2=2 if folio==7432 & redcap_event_name=="evaluacion1_arm_1"
replace antecedentes_persona_v_2=2 if folio==7317 & redcap_event_name=="evaluacion1_arm_1"
replace antecedentes_persona_v_2=2 if folio==7322 & redcap_event_name=="evaluacion1_arm_1"
replace antecedentes_persona_v_2=2 if folio==7361 & redcap_event_name=="evaluacion1_arm_1"
replace antecedentes_persona_v_2=2 if folio==7435 & redcap_event_name=="evaluacion1_arm_1"
replace antecedentes_persona_v_2=2 if folio==7472 & redcap_event_name=="evaluacion1_arm_1"
replace antecedentes_persona_v_2=2 if folio==7526 & redcap_event_name=="evaluacion1_arm_1"
replace antecedentes_persona_v_2=2 if folio==7436 & redcap_event_name=="evaluacion1_arm_1"

*replace antecedentes_persona_v_2=2 if folio==

/////////////////////////////////ANTECEDENTES OBSTETRICOS ////////////////////////////////****1 VISITA
/// Incidencias//
list folio fecha_visita vis_nutri redcap_event_name obstetrico  diabgest hipert abort prem mortinato  mortineo cesarea ant_histo_obs if antecedentes_obstetr_v_3!=2 & redcap_event_name=="evaluacion1_arm_1"
*replace antecedentes_obstetr_v_3=2 if folio==

/////////////////////////////////////ANTROPOMETRIA ///////////////////////////////////////****1 2 3 VISITA
/// Incidencias//
list  folio fecha_visita vis_nutri redcap_event_name talla obpresion  diagbetes  medic  antro_obs if  checkantro!=1 & antropometria_dha_complete!=2 & vis_entrega!=1 & [redcap_event_name=="evaluacion1_arm_1" | redcap_event_name=="evaluacion3_arm_1" | redcap_event_name=="evaluacion5_arm_1"]
*replace 2017
replace antropometria_dha_complete=2 if folio==7692 & redcap_event_name=="evaluacion1_arm_1"
* | folio==7692 & redcap_event_name=="evaluacion1_arm_1" | folio==7846 & redcap_event_name=="evaluacion1_arm_1" | | folio==7848 & redcap_event_name=="evaluacion1_arm_1"

////////////////////////////////////////FFQ///////////////////////////////////////////////****1  5 VISITA
/// Incidencias///
 list folio fecha_visita vis_nutri redcap_event_name inicio  seccereal sectuber secpan secgallet secsnack secazucar sechelado secbebida secfruta secfruttem secjugonat secverdura seclegumbr seccarne secembutid seclacteo secpreparacion secaceite secsal secagua secalim secendulz seccamb ffq_obs if ffq_complete!=2 & vis_entrega!=1 & ffq_vacio!=1 & [redcap_event_name=="evaluacion1_arm_1" | redcap_event_name=="evaluacion5_arm_1"]
*replace ffq_complete=2 if folio==7388 | folio==7421 | folio==7426 | folio==7450 | folio==7461
*replace 2017
*replace ffq_complete=2 if folio==7388  & redcap_event_name=="evaluacion5_arm_1"| folio==7421 & redcap_event_name=="evaluacion5_arm_1" | folio==7426 & redcap_event_name=="evaluacion5_arm_1"| folio==7450 & redcap_event_name=="evaluacion5_arm_1" | folio==7461 & redcap_event_name=="evaluacion5_arm_1" | folio==8076 & redcap_event_name=="evaluacion1_arm_1"

//////////////////////////////////////INTERVENCION///////////////////////////////////////****1 2 3 VISITA
/// Incidencias//
list folio fecha_visita vis_nutri redcap_event_name randomiz_visita fecha_intervenci_n semana_gestaci_n_consejeri dias_gestacion_consejeria se_realiza_consejeria  porque_no_se_realiza intervencion_obs if intervencion_complete!=2  & vis_entrega!=1 &  [redcap_event_name=="evaluacion1_arm_1" |  redcap_event_name=="evaluacion2__llama_arm_1" | redcap_event_name=="evaluacion3_arm_1"] & [randomiz_visita==3 | randomiz_visita==4]
*replace 2017
*replace intervencion_complete=2 if folio==7170 & redcap_event_name=="evaluacion3_arm_1"
gen error_inter=1 if redcap_event_name=="evaluacion2__llama_arm_1" & randomiz_visita>=3 & randomiz_visita!=. & lugar_visita==3
list folio fecha_visita vis_nutri redcap_event_name randomiz_visita lugar_visita fecha_intervenci_n semana_gestaci_n_consejeri dias_gestacion_consejeria se_realiza_consejeria  porque_no_se_realiza intervencion_obs if error_inter==1

replace intervencion_complete=2 if folio==7663 & redcap_event_name=="evaluacion1_arm_1"
replace intervencion_complete=2 if folio==7321 & redcap_event_name=="evaluacion1_arm_1"

////////////////////////////////////REGISTRO DE PASTILLAS////////////////////////////////****1 2 3 4 5 VISITA
/// Incidencias//
list folio fecha_visita vis_nutri redcap_event_name    adher efectos eventoadv participa reg_devol2  eventoadv pasconsum pastillas_obs if registro_pastilla_complete!=2  
count if registro_pastilla_complete!=2
*list folio redcap_event_name pasconsum pastillas_obs if registro_pastilla_complete==1 & pasconsum==. & [visita_tipo==3 | visita_tipo== 5 | estados_3==4 | estados_3==2] 
*list folio fecha_visita vis_nutri redcap_event_name reg_frasco4 if reg_frasco4>4 & reg_frasco4!=.
*replace 2017
replace registro_pastilla_complete=2  if folio==7018 & redcap_event_name=="evaluacion5_arm_1" | folio==7041 & redcap_event_name=="evaluacion3_arm_1" | folio==7101 & redcap_event_name=="evaluacion3_arm_1" | folio==7101 & redcap_event_name=="evaluacion3_arm_1" | folio==7173 & redcap_event_name=="evaluacion3_arm_1" | folio==7216 & redcap_event_name=="evaluacion3_arm_1" | folio==7249 & redcap_event_name=="evaluacion3_arm_1" | folio==7391 & redcap_event_name=="evaluacion3_arm_1" | folio==7432 & redcap_event_name=="evaluacion4_llamad_arm_1" | folio==7450 & redcap_event_name=="evaluacion3_arm_1" 
replace registro_pastilla_complete=2  if folio==7459 & redcap_event_name=="evaluacion3_arm_1" | folio==7529 & redcap_event_name=="evaluacion3_arm_1" | folio==7562 & redcap_event_name=="evaluacion5_arm_1" | folio==7729 & redcap_event_name=="evaluacion3_arm_1" | folio==8221 & redcap_event_name=="evaluacion3_arm_1"
replace registro_pastilla_complete=2  if folio==7101 & redcap_event_name=="evaluacion5_arm_1" | folio==7147 & redcap_event_name=="evaluacion3_arm_1" | folio==7018 & redcap_event_name=="evaluacion3_arm_1" | folio==7085 & redcap_event_name=="evaluacion3_arm_1" | folio==7088 & redcap_event_name=="evaluacion4_llamad_arm_1" | folio==7168 & redcap_event_name=="evaluacion2__llama_arm_1" | folio==7249 & redcap_event_name=="evaluacion2__llama_arm_1"
replace registro_pastilla_complete=2  if folio==7277 & redcap_event_name=="evaluacion5_arm_1" | folio==7331 & redcap_event_name=="evaluacion3_arm_1" | folio==7450 & redcap_event_name=="evaluacion5_arm_1" 
replace registro_pastilla_complete=2  if folio==7081 & redcap_event_name=="evaluacion2__llama_arm_1" 
**Replace 2018
replace registro_pastilla_complete=2  if folio==8207 & redcap_event_name=="evaluacion3_arm_1"| folio==8221 & redcap_event_name=="evaluacion5_arm_1" | folio==9369 & redcap_event_name=="evaluacion3_arm_1" | folio==9082 & redcap_event_name=="evaluacion3_arm_1" | folio==8975 & redcap_event_name=="evaluacion5_arm_1" | folio==8702 & redcap_event_name=="evaluacion3_arm_1" | folio==8665 & redcap_event_name=="evaluacion3_arm_1" | folio==9024 & redcap_event_name=="evaluacion5_arm_1"

*replace registro_pastilla_complete=1  if folio==9747 | folio==9082 	| folio==7485 | folio== 7508 | folio== 7562 | folio==7636 | folio==7681 | folio==7904 | folio==7986 | folio==8155 | folio==8240 | folio==8241 | folio==9310 | folio==9082 | folio==8817 | folio==8797 | folio==8243
///////////////////////////////////////////CHECKLIST////////////////////////////////////*******1 VISITA
//////////Incidencia////////////////
list folio fecha_visita vis_nutri redcap_event_name firma_cc random_folio agenda_mujer orden_examen foto_agenda_mujer foto_ci i_dieta if checklist_complete!=2 & redcap_event_name=="evaluacion1_arm_1" & foto_ci!=. & i_dieta ==.
*replace checklist_complete=2  if folio==

/////////////////////////////////Lista de folios no reclutados con//////////////////////////////////////
*list folio fecha_visita vis_nutri redcap_event_name  contacto_y_reclutami_v_0 estado_de_la_madre_complete visita_dha_complete dha_ingreso_complete antecedentes_sociode_v_1 antecedentes_persona_v_2 antecedentes_obstetr_v_3 antropometria_dha_complete ffq_complete intervencion_complete registro_pastilla_complete checklist_complete if redcap_event_name=="evaluacion1_arm_1" &  fecha_visita!=.  & estados_2==2
*list folio fecha_visita vis_nutri redcap_event_name  visita_dha_complete intervencion_complete registro_pastilla_complete if redcap_event_name=="evaluacion2__llama_arm_1" &  fecha_visita!=.  &  [intervencion_complete==. | registro_pastilla_complete==. ]
*list folio fecha_visita vis_nutri redcap_event_name  visita_dha_complete antropometria_dha_complete  intervencion_complete registro_pastilla_complete  if redcap_event_name=="evaluacion3_arm_1" &  fecha_visita!=.  & [ intervencion_complete==0 | registro_pastilla_complete==0 | antropometria_dha_complete==0]
*list folio fecha_visita vis_nutri redcap_event_name  visita_dha_complete  registro_pastilla_complete if redcap_event_name=="evaluacion4_llamad_arm_1" & fecha_visita!=.  & registro_pastilla_complete==0
*list folio fecha_visita vis_nutri redcap_event_name  visita_dha_complete  ffq_complete  registro_pastilla_complete antropometria_dha_complete if redcap_event_name=="evaluacion5_arm_1" &  fecha_visita!=. & [ffq_complete==0 | registro_pastilla_complete==0 | antropometria_dha_complete==0]

////////////////////////INCIDENCIA LLAMADOS MEDICIONES /////////////////////////////////
*list folio redcap_event_name fecha_visita vis_nutri if redcap_event_name=="evaluacion3_arm_1" & reg_date0==.




///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////SECCION DE CARGAS///////////////////////////
///////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////ANTROPOMETRIA////////////////////////////////////



*talla DHA*
gen DIF1=abs(talla_embarazada-talla_embarazada2)
gen DIF2=abs(talla_embarazada2-talla_embarazada3)
gen DIF3=abs(talla_embarazada-talla_embarazada3)
replace antro_talla_calc=1 if DIF1<DIF2 & DIF1<DIF3
replace antro_talla_calc=2 if DIF2<DIF1 & DIF2<DIF3
replace antro_talla_calc=3 if DIF3<DIF1 & DIF3<DIF2
replace antro_talla_calc=5 if DIF1==DIF2 & DIF2==DIF3 & DIF1!=. & DIF2!=. & DIF3!=.
replace antro_talla_calc=6 if [talla_embarazada==. & talla_embarazada2==. & talla_embarazada3!=.]|[talla_embarazada==. & talla_embarazada3==. & talla_embarazada2!=.]|[talla_embarazada3==. & talla_embarazada2==. & talla_embarazada!=.]

replace  antro_promtalla=(talla_embarazada+talla_embarazada2)/2 if antro_talla_calc==1
replace  antro_promtalla=(talla_embarazada2+talla_embarazada3)/2 if antro_talla_calc==2
replace  antro_promtalla=(talla_embarazada+talla_embarazada3)/2 if antro_talla_calc==3
replace  antro_promtalla=(talla_embarazada+talla_embarazada2+talla_embarazada3)/3 if antro_talla_calc==5
replace  antro_promtalla=talla_embarazada if antro_talla_calc==6 & talla_embarazada3==. & talla_embarazada2==. & talla_embarazada!=.
replace  antro_promtalla=talla_embarazada2 if antro_talla_calc==6 &[talla_embarazada==. & talla_embarazada3==. & talla_embarazada2!=.]
replace  antro_promtalla=talla_embarazada3 if antro_talla_calc==6 & [talla_embarazada==. & talla_embarazada2==. & talla_embarazada3!=.]
drop DIF1 DIF2 DIF3

label values antro_talla_calc .
*IMC DHA*
replace  antro_imc= peso_embarazada /[antro_promtalla * antro_promtalla]

////////////////////////////////////FECHAS ESTADO//////////////////////////////////////////
replace est_date9=est_date8 if folio!=.
replace est_date9=est_date6 if est_date9==.
format  est_date9 %dM_d,_CY

format %tdDD/NN/CCYY fecha_visita est_date6 est_date8 est_date9

*****Fecha probables

gen min10=70  if folio!=.
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

replace est_date12=est_date9 + min10 if folio!=.
replace est_date13=est_date9 + max13 if folio!=.
replace est_date14=est_date9 + min18 if folio!=.
replace est_date15=est_date9 + max18 if folio!=.
replace est_date16=est_date9 + min24 if folio!=.
replace est_date17=est_date9 + max28 if folio!=.
replace est_dates18=est_date9 + min32 if folio!=.
replace est_date19=est_date9 + max32 if folio!=.
replace est_date20=est_date9 + min35 if folio!=.
replace est_date21=est_date9 + max37 if folio!=.



format %tdDD/NN/CCYY est_date12 est_date13 est_date14 est_date15 est_date16 est_date17 est_dates18 est_date19 est_date20 est_date21 est_date9


*Borrar*
drop  talla_embarazada talla_embarazada2 prom_talla_embarazada dif_talla_embarazada talla_embarazada3 imc_embarazada  peso_embarazada

 
 ///////////////////////////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////VARIABLES SUPERVISION///////////////////////////////////
 ///////////////////////////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////////////////////////////
 ///////////////////////////////////////////////////////////////////////////////////////////////
 

 ///////////////////////////////////////////CONTACTO///////////////////////////////////////
 ///Incidencias 
gen contac=1 if contacto_y_reclutami_v_0!=2 & redcap_event_name=="evaluacion1_arm_1"
gen contac_cal=1 if calidad_cont==1 & redcap_event_name=="evaluacion1_arm_1"


//////////////////////////////////////ESTADO DE LA MADRE//////////////////////////////////
/// Incidencias//
gen esta=1 if estado_de_la_madre_complete!=2 & redcap_event_name=="evaluacion1_arm_1"

/////////////////////////////////////////VISITA///////////////////////////////////////////
/// Incidencias//
gen vis=1  if visita_dha_complete!=2

***Si visitas tienen misma fecha
duplicates  list folio fecha_visita 
duplicates tag folio fecha_visita, generate(vis_dup)

***Error visita
gen vis_error=1 if errorvis==1


//////////////////////////////////////DHA INGRESO/////////////////////////////////////////
/// Incidencias//
gen dha=1 if dha_ingreso_complete!=2 & redcap_event_name=="evaluacion1_arm_1"

***Incidencias si aplicacion de consentimiento esta mal ingresado///
*gen dha_cons=1 if checkcons==. & redcap_event_name=="evaluacion1_arm_1"


//////////////////////////////////////RANDOMIZACION/////////////
/// Incidencia//

gen randomm=1 if randomizok!=1 & redcap_event_name=="evaluacion1_arm_1"

/////////////////////////////////ANTECEDENTES SOCIODEMOGRAFICOS DHA///////////////////////
/// Incidencias//
gen socio=1 if antecedentes_sociode_v_1!=2 & redcap_event_name=="evaluacion1_arm_1" 


 ////////////////////////////////ANTECEDENTES PERSONALES Y FAMILIARES/////////////////////****1 VISITA
/// Incidencias//
gen perso=1 if antecedentes_persona_v_2!=2 & redcap_event_name=="evaluacion1_arm_1"


/////////////////////////////////ANTECEDENTES OBSTETRICOS ////////////////////////////////****1 VISITA
/// Incidencias//
gen obste=1 if antecedentes_obstetr_v_3!=2 & redcap_event_name=="evaluacion1_arm_1"

/////////////////////////////////////ANTROPOMETRIA ///////////////////////////////////////****1 2 3 VISITA
/// Incidencias//
gen antrop=1 if  antropometria_dha_complete!=2 & vis_entrega!=1 & [redcap_event_name=="evaluacion1_arm_1" | redcap_event_name=="evaluacion3_arm_1" | redcap_event_name=="evaluacion5_arm_1"]

////////////////////////////////////////FFQ///////////////////////////////////////////////****1  5 VISITA
/// Incidencias//7
gen ffqs=1 if ffq_complete!=2  & [redcap_event_name=="evaluacion1_arm_1" | redcap_event_name=="evaluacion5_arm_1"] & vis_entrega!=1 & ffq_vacio!=1

//////////////////////////////////////INTERVENCION///////////////////////////////////////****1 2 3 VISITA
/// Incidencias//
gen inter=1 if intervencion_complete!=2  &  [redcap_event_name=="evaluacion1_arm_1" |  redcap_event_name=="evaluacion2__llama_arm_1" | redcap_event_name=="evaluacion3_arm_1"] & [randomiz_visita==3 | randomiz_visita==4] & vis_entrega!=1 & error_inter!=1

gen inter_err=1 if intervencion_complete!=2   & error_inter==1

////////////////////////////////////REGISTRO DE PASTILLAS////////////////////////////////****1 2 3 4 5 VISITA
/// Incidencias//
gen regis=1 if registro_pastilla_complete!=2  


///////////////////////////////////////////CHECKLIST////////////////////////////////////*******1 VISITA
//////////Incidencia////////////////
gen checking=1 if checklist_complete!=2 & redcap_event_name=="evaluacion1_arm_1" & foto_ci!=. & i_dieta ==.

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 ***************************Duplicar y crear opciones
 gen numinc=0
 foreach v of varlist  contac-checking {
    replace numinc=numinc +`v' 
	}
    
*drop spv_tiene
*replace spv_tiene=.
replace spv_tiene=1  if [contac==1 | esta==1 | vis==1 | vis_dup>=1 | vis_error==1 | dha==1  | socio==1 | perso==1 | obste==1 | antrop==1  | ffqs==1 | inter==1 | checking==1 | randomm==1 | regis==1] 
*replace spv_tiene=1  if [ vis==1 | vis_dup>=1 | vis_error==1 | dha==1  | socio==1 | perso==1 | obste==1 | antrop==1  | ffqs==1 | inter==1  | checking==1 | randomm==1] & spv_tiene==.

 /////Formulario
  ///////////////////////////////////////////CONTACTO///////////////////////////////////////
 ///Incidencias 
gen contac_f="CONTACTO" if contac==1 & contacto_y_reclutami_v_0!=2 & redcap_event_name=="evaluacion1_arm_1"
gen contac_cal_f="Error.insulina.criterios.o.acepta_participar" if contac_cal==1 & redcap_event_name=="evaluacion1_arm_1"


//////////////////////////////////////ESTADO DE LA MADRE//////////////////////////////////
/// Incidencias//
gen esta_f="ESTADO" if esta==1 & estado_de_la_madre_complete!=2 & redcap_event_name=="evaluacion1_arm_1"

/////////////////////////////////////////VISITA///////////////////////////////////////////
/// Incidencias//
gen vis_f1="VISITA"  if visita_dha_complete!=2 & vis==1

***Si visitas tienen misma fecha
*duplicates tag folio fecha_visita, generate(vis_dup)
gen vis_f2="Visitas.con.misma.fecha" if vis_dup>=1
***Error visita
gen vis_f3="Error.tipo.visita" if errorvis==1


//////////////////////////////////////DHA INGRESO/////////////////////////////////////////
/// Incidencias//
gen dha_f1="DHA.ingreso.incompleto" if dha_ingreso_complete!=2 & redcap_event_name=="evaluacion1_arm_1" & dha==1

***Incidencias si aplicacion de consentimiento esta mal ingresado///INCIDENCIA SE INGRESA A MANO
*gen dha_f2="Error.aplicacion.de.cons.DHA.ingreso" if checkcons==. & redcap_event_name=="evaluacion1_arm_1" & dha_cons==1


//////////////////////////////////////RANDOMIZACION/////////////
/// Incidencia//

gen randomm_f="Error.randomizacion" if randomizok!=1 & redcap_event_name=="evaluacion1_arm_1"

/////////////////////////////////ANTECEDENTES SOCIODEMOGRAFICOS DHA///////////////////////
/// Incidencias//
gen socio_f="ANT.SOCIO" if antecedentes_sociode_v_1!=2 & redcap_event_name=="evaluacion1_arm_1" & socio==1


 ////////////////////////////////ANTECEDENTES PERSONALES Y FAMILIARES/////////////////////****1 VISITA
/// Incidencias//
gen perso_f="ANT.PERSONALES" if antecedentes_persona_v_2!=2 & redcap_event_name=="evaluacion1_arm_1" & perso==1


/////////////////////////////////ANTECEDENTES OBSTETRICOS ////////////////////////////////****1 VISITA
/// Incidencias//
gen obste_f="ANT.OBST" if antecedentes_obstetr_v_3!=2 & redcap_event_name=="evaluacion1_arm_1" & obste==1 

/////////////////////////////////////ANTROPOMETRIA ///////////////////////////////////////****1 2 3 VISITA
/// Incidencias//
gen antrop_f="ANTROPOMETRIA" if antrop==1 & antropometria_dha_complete!=2 & vis_entrega!=1 & [redcap_event_name=="evaluacion1_arm_1" | redcap_event_name=="evaluacion3_arm_1" | redcap_event_name=="evaluacion5_arm_1"]

////////////////////////////////////////FFQ///////////////////////////////////////////////****1  5 VISITA
/// Incidencias//7
gen ffqs_f="FFQ" if ffq_complete!=2  & ffqs==1 & [redcap_event_name=="evaluacion1_arm_1" | redcap_event_name=="evaluacion5_arm_1"] & vis_entrega!=1

//////////////////////////////////////INTERVENCION///////////////////////////////////////****1 2 3 VISITA
/// Incidencias//
gen inter_f="INTERVENCION" if intervencion_complete!=2  & inter==1 & [redcap_event_name=="evaluacion1_arm_1" |  redcap_event_name=="evaluacion2__llama_arm_1" | redcap_event_name=="evaluacion3_arm_1"] & vis_entrega!=1

gen inter_error_f="SIN.INTERVENCION.POR.REALIZAR.LLAMADO" if inter_err==1

////////////////////////////////////REGISTRO DE PASTILLAS////////////////////////////////****1 2 3 4 5 VISITA
/// Incidencias//
gen regis_f="R.D.PASTILLAS" if registro_pastilla_complete!=2  & regis==1


///////////////////////////////////////////CHECKLIST////////////////////////////////////*******1 VISITA
//////////Incidencia////////////////
gen checking_f="CHECKLIST" if checklist_complete!=2 & redcap_event_name=="evaluacion1_arm_1" & checking==1 & foto_ci!=. & i_dieta ==.


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////COMPLETE/////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////CONTACTO////////////////////****1 VISITA
///
replace contacto_y_reclutami_v_0=.    if redcap_event_name=="evaluacion2__llama_arm_1" | redcap_event_name=="evaluacion3_arm_1" | redcap_event_name=="evaluacion4_llamad_arm_1" | redcap_event_name=="evaluacion5_arm_1" 
///////////////////////ESTADO DE LA MADRE/////////////////////////////////////////****1 VISITA
/// 
replace estado_de_la_madre_complete=. if redcap_event_name=="evaluacion2__llama_arm_1" | redcap_event_name=="evaluacion3_arm_1" | redcap_event_name=="evaluacion4_llamad_arm_1" | redcap_event_name=="evaluacion5_arm_1" 
///////////////////////////////////////VISITA/////////////////////////////////////////////****1 2 3 4 5 VISITA
/// 
replace visita_dha_complete=.         if estados_2==2 & visita_dha_complete==9 & redcap_event_name=="evaluacion1_arm_1"

//////////////////////////////////DHA INGRESO/////////////////////////////////////////////////////****1 VISITA
/// 
replace dha_ingreso_complete=.        if [estados_2==2 & visita_dha_complete==9 & redcap_event_name=="evaluacion1_arm_1"] | redcap_event_name=="evaluacion2__llama_arm_1" | redcap_event_name=="evaluacion3_arm_1" | redcap_event_name=="evaluacion4_llamad_arm_1" | redcap_event_name=="evaluacion5_arm_1" 
////////////////////////////////////////////////////////ANTECEDENTES SOCIODEMOGRAFICOS DHA/////////////****1 VISITA
///
replace antecedentes_sociode_v_1=.    if [estados_2==2  & redcap_event_name=="evaluacion1_arm_1"] | redcap_event_name=="evaluacion2__llama_arm_1" | redcap_event_name=="evaluacion3_arm_1" | redcap_event_name=="evaluacion4_llamad_arm_1" | redcap_event_name=="evaluacion5_arm_1" 
/////////////////////////////////////ANTECEDENTES PERSONALES Y FAMILIARES/////////****1 VISITA
/// 
replace antecedentes_persona_v_2=.    if [estados_2==2 & redcap_event_name=="evaluacion1_arm_1"] | redcap_event_name=="evaluacion2__llama_arm_1" | redcap_event_name=="evaluacion3_arm_1" | redcap_event_name=="evaluacion4_llamad_arm_1" | redcap_event_name=="evaluacion5_arm_1" 
////////////////////////////////////////ANTECEDENTES OBSTETRICOS ////////////****1 VISITA
/// 
replace  antecedentes_obstetr_v_3=.   if [estados_2==2  & redcap_event_name=="evaluacion1_arm_1"] | redcap_event_name=="evaluacion2__llama_arm_1" | redcap_event_name=="evaluacion3_arm_1" | redcap_event_name=="evaluacion4_llamad_arm_1" | redcap_event_name=="evaluacion5_arm_1" 
////////////////////////////////////////ANTROPOMETRIA ////////////****1 2 3 VISITA
/// 
replace antropometria_dha_complete=.  if [estados_2==2 & redcap_event_name=="evaluacion1_arm_1"] | redcap_event_name=="evaluacion2__llama_arm_1" | redcap_event_name=="evaluacion4_llamad_arm_1" | vis_entrega==1

////////////////////////////////////////FFQ////////////****1  5 VISITA
/// 
replace ffq_complete=.                if [estados_2==2 & redcap_event_name=="evaluacion1_arm_1"] |  redcap_event_name=="evaluacion2__llama_arm_1" | redcap_event_name=="evaluacion3_arm_1" | redcap_event_name=="evaluacion4_llamad_arm_1" 
 
////////////////////////////////////////INTERVENCION////////////****1 2 3 VISITA
/// 
replace intervencion_complete=.       if  estados_2==2 & redcap_event_name=="evaluacion1_arm_1" |  randomiz_visita<=2 & [redcap_event_name!="evaluacion4_llamad_arm_1" | redcap_event_name!="evaluacion5_arm_1" ] | [redcap_event_name=="evaluacion4_llamad_arm_1" | redcap_event_name=="evaluacion5_arm_1" ]
////////////////////////////////////////REGISTRO DE PASTILLAS////////////****1 2 3 4 5 VISITA
/// 
replace registro_pastilla_complete=.  if [estados_2==2 & redcap_event_name=="evaluacion1_arm_1"] 
///////////////////////////////////////////CHECKLIST////////////////////*******1 VISITA
///
replace checklist_complete=.          if [estados_2==2 & redcap_event_name=="evaluacion1_arm_1"] | redcap_event_name=="evaluacion2__llama_arm_1" | redcap_event_name=="evaluacion3_arm_1" | redcap_event_name=="evaluacion4_llamad_arm_1" | redcap_event_name=="evaluacion5_arm_1" 


///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////

/////Unidades
replace spv_unid___2=1 if contac_f=="CONTACTO" & contac==1 & redcap_event_name=="evaluacion1_arm_1" | contac_cal_f=="Error.insulina.criterios.o.acepta_participar" & redcap_event_name=="evaluacion1_arm_1" 
replace spv_unid___1=1 if [redcap_event_name=="evaluacion1_arm_1" | redcap_event_name=="evaluacion2__llama_arm_1" & randomiz_visita>=3 | redcap_event_name=="evaluacion3_arm_1" | redcap_event_name=="evaluacion5_arm_1"] & [  vis==1 |  vis_error==1 | dha==1  | randomm==1 | socio==1 |  perso==1 |  obste==1 |  antrop==1  | ffqs==1 |  inter==1  |  checking==1 | regis==1]
replace spv_unid___1=1 if [redcap_event_name=="evaluacion1_arm_1" | redcap_event_name=="evaluacion2__llama_arm_1" & randomiz_visita>=3 | redcap_event_name=="evaluacion3_arm_1" | redcap_event_name=="evaluacion5_arm_1"] & [  vis==1 |  vis_error==1 | dha==1  | randomm==1 | socio==1 |  perso==1 |  obste==1 |  antrop==1  | ffqs==1 |  inter==1  |  checking==1 | regis==1] & [vis_nutri==. & lugar_visita==2]
replace spv_unid___1=0 if [vis_nutri==2003 | vis_nutri==2015 | [lugar_visita==1 & vis_nutri!=2003 & vis_nutri!=2015]] 
replace spv_unid___3=1 if [ vis==1  |  vis_error==1  | regis==1 |  inter==1 ] & [redcap_event_name=="evaluacion2__llama_arm_1" & randomiz_visita<=2 | redcap_event_name=="evaluacion4_llamad_arm_1"]
replace spv_unid___3=1 if  esta==1 & redcap_event_name=="evaluacion1_arm_1"
replace spv_unid___4=1 if [vis_nutri==2003 | vis_nutri==2015] & [redcap_event_name=="evaluacion1_arm_1" | redcap_event_name=="evaluacion2__llama_arm_1" & randomiz_visita>=3 | redcap_event_name=="evaluacion3_arm_1" | redcap_event_name=="evaluacion5_arm_1"] & [  vis==1 |  vis_error==1 | dha==1  | randomm==1 | socio==1 |  perso==1 |  obste==1 |  antrop==1 | ffqs==1 |  inter==1 | regis==1 |  checking==1]
replace spv_unid___4=1 if [vis_nutri==. & lugar_visita==1] & [redcap_event_name=="evaluacion1_arm_1" | redcap_event_name=="evaluacion2__llama_arm_1" & randomiz_visita>=3 | redcap_event_name=="evaluacion3_arm_1" | redcap_event_name=="evaluacion5_arm_1"] & [  vis==1 |   vis_error==1 | dha==1  | randomm==1 | socio==1 |  perso==1 |  obste==1 |  antrop==1 | ffqs==1 |  inter==1 | regis==1 |  checking==1]
replace spv_unid___7=1 if inter_error_f=="SIN.INTERVENCION.POR.REALIZAR.LLAMADO" | vis_f2=="Visitas.con.misma.fecha"


*******************CONCATENAR
drop spv_en
egen spv_en=concat(contac_f contac_cal_f esta_f vis_f1 vis_f2 vis_f3 dha_f1 randomm_f socio_f perso_f obste_f antrop_f  ffqs_f inter_f inter_error_f regis_f checking_f ) , punct("  ")

replace spv_tiene=0 if spv_tiene==.
replace spv_tiene=1 if spv_en!="" 
* //------------->2017
*replace spv_en="" if spv_tiene==0 ------------->2017
replace supervision_complete=2 if spv_tiene==0 
replace supervision_complete=1 if spv_tiene==1 & spv_datos1==. & spv_datos2==. & spv_datos3==. & spv_datos4==. & spv_datos5==.

 
 
* DEJAR 
//////////////////*****************Carga redcap************************///////////////
keep folio fecha_visita  redcap_event_name contacto_y_reclutami_v_0 estado_de_la_madre_complete vis_nutri visita_dha_complete vis_entrega dha_ingreso_complete antecedentes_sociode_v_1 antecedentes_persona_v_2 antecedentes_obstetr_v_3 antropometria_dha_complete ffq_complete intervencion_complete registro_pastilla_complete checklist_complete antro_promtalla antro_talla_calc antro_imc est_date9 est_date12 est_date13 est_date14 est_date15 est_date16 est_date17 est_dates18 est_date19 est_date20 est_date21 spv_unid___1 spv_unid___2 spv_unid___3 spv_unid___4 spv_unid___5 spv_unid___6 spv_unid___7 spv_en spv_tiene supervision_complete
*************************Cambio de nombres**********************************
label drop _all

///Modificacion para cambiar medicion externa a medicion interna y dejar todo junto

replace spv_unid___1=1 if spv_unid___4==1
replace spv_unid___4=0






////////ARREGLO PARA INCIDENCIAS CALIDAD



*******************************CAMBIAR NOMBRES DE VARIABLES EN EXCEL VARIABLES

*contacto_y_reclutami_v_0 a contacto_y_reclutamiento_complete
*antecedentes_sociode_v_1 a antecedentes_sociodemograficos_dha_complete
*antecedentes_persona_v_2 a antecedentes_personales_y_familiares_dha_complete
*antecedentes_obstetr_v_3 a antecedentes_obstetrcos_histricos_y_actuales_dha_complete


///SOLO QUEDA COMPARAR CON VARIABLES DE MLG
*MANDAR VARIABLES DE REGISTRO PASTILLAS Y ESTADO































