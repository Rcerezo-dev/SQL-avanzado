/* 9. Generar el campo info_by_phone_lg 
Como en el ejercicio anterior queremos tener un registro por cada llamada y un 
flag que indique si la llamada pasa por el step de nombre 
CUSTOMERINFOBYPHONE.TX y su step_result es OK, quiere decir que hemos 
podido identificar al cliente a través de su número de teléfono. En ese caso 
pondremos un 1 en este flag, de lo contrario llevará un 0. 
 
Entregar el código en un fichero .sql 
*/

-- En este caso, usamos la función MAX de manera que solo nos devuelva el valor en el que la llamada ha sido identificada (1) por teléfono. 
-- En caso de no ser identificada, nos devolverá otro valor de 0
-- ejercicio 9 como consulta
SELECT
    calls_ivr_id,
    customer_phone,
    MAX(CASE 
            WHEN step_name = 'CUSTOMERINFOBYPHONE.TX' AND step_result = 'OK' THEN 1
            ELSE 0
        END) AS info_by_phone_lg
FROM keepcoding.ivr_detail
GROUP BY calls_ivr_id, customer_phone;