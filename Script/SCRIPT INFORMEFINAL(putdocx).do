
////////////////////////////////////////////////////////////////////INFORME WORD////////////////////////////////////////////////////////////////////////////////////////

**** 1. Actualización a la fecha.
save "data1", replace
putdocx begin
putdocx paragraph, spacing(after, 0)
putdocx text ("A. Actualización a la fecha") , font(Arial, 11, black  ) bold 
putdocx paragraph, spacing(after, 0)
putdocx text ("Número de ids totales"), font(Arial, 11, black  ) underline 
statsby Total=r(N) Primer_id=r(min) Ultimo_id=r(max), by(instancia) :summarize id 
putdocx table tabla1 = data(Total Primer_id Ultimo_id) if instancia=="instancia1" ,varnames  halign(center) layout(autofitcontents) 
clear
use "data1.dta"


****Frecuencias 
tab variableA if instancia=="instancia1"
save "data1", replace
*putdocx begin
putdocx paragraph, spacing(after, 0)
putdocx text ("B. VariableA"), font(Arial, 11, black  ) bold
putdocx paragraph, spacing(after, 0)
putdocx text ("Frecuencias del VariableA con respecto a instancia1"), font(Arial, 11, black  ) underline 
statsby Frecuencia=r(N), by(variableA instancia) basepop(instancia=="instancia1"):sum id
gen var=1
bysort var:egen sumbmi = sum(Frecuencia)
gen Porcentaje=(Frecuencia/sumbmi)*100
format %6.0g Porcentaje
*putdocx begin
putdocx table tabla2 = data(variableA Frecuencia Porcentaje)  if instancia=="instancia1", varnames  halign(center) layout(autofitcontents) 
clear
use "data1.dta"

****Listado de ids sin   VariableA .
list id if variableA==. & instancia=="instancia1"
gen idsin=1 if variableA==. & instancia=="instancia1"
replace idsin=0 if idsin==.
save "data1", replace
putdocx paragraph, spacing(after, 0)
putdocx text ("Listado de ids  sin VariableA "), font(Arial, 11, black  ) underline 
statsby Total=r(N) prom =r(mean) , by(id) :summarize idsin
*putdocx begin
putdocx table tabla3 = data(id) if prom==1  ,varnames  halign(center) layout(autofitcontents) 
*putdocx save myreport.docx, replace




putdocx save Informe_estado_del_participante.docx, replace
////////////////////////////////////////////////////////////////FIN DE INFORME WORD////////////////////////////////////////////////////////////////////
