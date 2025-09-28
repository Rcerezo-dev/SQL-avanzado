/*
. Generar el campo masiva_lg 
Como en el ejercicio anterior queremos tener un registro por cada llamada y un 
flag que indique si la llamada ha pasado por el módulo AVERIA_MASIVA. Si es 
así indicarlo con un 1 de lo contrario con un 0. 
Entregar el código en un fichero .sql 
*/

-- En este ejercicio, usamos la función MAX de manera que solo nos devuelva el valor en el que la llamada ha pasado por el módulo AVERIA_MASIVA (1). 
-- En caso de no haber pasado por dicho módulo, nos devolverá otro valor de 0

SELECT
    calls_ivr_id,
    customer_phone,
    MAX(CASE WHEN module_name = 'AVERIA_MASIVA' THEN 1 
    ELSE 0 
    END) AS masiva_lg
FROM keepcoding.ivr_detail
GROUP BY calls_ivr_id, customer_phone;