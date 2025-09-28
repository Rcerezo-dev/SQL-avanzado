/*
7. Generar el campo billing_account_id 
En ocasiones es posible identificar al cliente en alguno de los pasos de detail 
obteniendo su número de cliente. 
Como en el ejercicio anterior queremos tener un registro por cada llamada y un 
sólo cliente identificado para la misma. 
Entregar el código en un fichero .sql
*/


-- En este ejercicio, usamos la función ROW_NUMBER para quedarnos con el primer valor no nulo de billing_account_id por cada llamada. 
 --Ejercicio 7 como consulta
 SELECT
    calls_ivr_id,
    step_sequence,
    billing_account_id
FROM keepcoding.ivr_detail
QUALIFY row_number() over(partition by CAST(calls_ivr_id AS STRING) order by step_sequence) = 1