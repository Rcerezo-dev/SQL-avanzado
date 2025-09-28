/*
5. Generar los campos document_type y 
document_identification 
En ocasiones es posible identificar al cliente en alguno de los pasos de detail 
obteniendo su tipo de documento y su identificación. 
 
Como en el ejercicio anterior queremos tener un registro por cada llamada y un 
sólo cliente identificado para la misma. 
Entregar el código en un fichero .sql 


*/
-- En este ejercicio, usamos la función ROW_NUMBER para quedarnos con el primer valor no nulo de document_type y document_identification por cada llamada. 

--como Consulta
SELECT
  calls_ivr_id,
  document_type,
  document_identification
FROM keepcoding.ivr_detail
WHERE document_type NOT IN ('UNKNOWN','DESCONOCIDO')
  AND document_identification NOT IN ('UNKNOWN','DESCONOCIDO')
QUALIFY ROW_NUMBER() OVER (
  PARTITION BY calls_ivr_id
  ORDER BY step_sequence
) = 1;