//////////////////////////////////////ANTROPOMETRIA////////////////////////////////////
**Descarga REPORTE ANTRO MEDICIONES(SL)


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

keep folio redcap_event_name antro_talla_calc antro_promtalla antro_imc
keep if antro_talla_calc!=. & antro_promtalla!=. & antro_imc!=.
