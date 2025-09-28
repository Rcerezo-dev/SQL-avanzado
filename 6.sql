/*
6. Generar el campo customer_phone 
En ocasiones es posible identificar al cliente en alguno de los pasos de detail 
obteniendo su número de teléfono. 
Como en el ejercicio anterior queremos tener un registro por cada llamada y un 
sólo cliente identificado para la misma. 
Entregar el código en un fichero .sql 

*/
-- En este ejercicio, usamos la función ROW_NUMBER para quedarnos con el primer valor no nulo de calls_phone_number por cada llamada. 


--Como Consulta

SELECT
    calls_ivr_id,
    step_sequence,
    calls_phone_number AS customer_phone
FROM keepcoding.ivr_detail
QUALIFY row_number() over(partition by CAST(calls_ivr_id AS STRING) order by step_sequence) = 1
WHERE calls_phone_number IS NOT NULL
  AND calls_phone_number <> 'UNKNOWN'