/*10. Generar el campo info_by_dni_lg 
Como en el ejercicio anterior queremos tener un registro por cada llamada y un 
flag que indique si la llamada pasa por el step de nombre 
CUSTOMERINFOBYDNI.TX y su step_result es OK, quiere decir que hemos 
podido identificar al cliente a través de su número de dni. En ese caso pondremos 
un 1 en este flag, de lo contrario llevará un 0. 
 
Entregar el código en un fichero .sql 
*/

-- ejercicio 10 como consulta
-- En este ejercicio, usamos la función MAX de manera que solo nos devuelva el valor en el que la llamada ha sido identificada (1) por DNI. 
-- En caso de no ser identificada, nos devolverá otro valor de 0
SELECT DISTINCT 
    calls_ivr_id, 
    max(
    CASE 
        WHEN step_name = 'CUSTOMERINFOBYDNI.TX' THEN 1 
        ELSE 0 
    END) AS info_by_phone_lg 
WHERE step_result = 'OK'