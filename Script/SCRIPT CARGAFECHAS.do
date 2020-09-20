///FECHAS

replace dateA=dateB  if id!=.
replace dateA=dateC if dateA==.
format dateA %dM_d,_CY

format %tdDD/NN/CCYY datePartida dateC dateB dateA


*****Fecha probables


gen min10=70 if id!=.
gen max13=104 if id!=.
gen min18=123 if id!=.
gen max18=129 if id!=.
gen min24=168 if id!=.
gen max28=196 if id!=.
gen min32=221 if id!=.
gen max32=227 if id!=.
gen min35=245 if id!=.
gen max37=259 if id!=.

///por semanas

gen semana12=dateA + min10 if id!=.
gen semana13=dateA + max13 if id!=.
gen semana14=dateA + min18 if id!=.
gen semana15=dateA + max18 if id!=.
gen semana16=dateA + min24 if id!=.
gen semana17=dateA + max28 if id!=.
gen semanas18=dateA + min32 if id!=.
gen semana19=dateA + max32 if id!=.
gen semana20=dateA + min35 if id!=.
gen semana21=dateA + max37 if id!=.



format %tdDD/NN/CCYY semana12 semana13 semana14 semana15 semana16 semana17 semanas18 semana19 semana20 semana21 dateA

keep id redcap_event_name dateA semana12 semana13 semana14 semana15 semana16 semana17 semanas18 semana19 semana20 semana21 


