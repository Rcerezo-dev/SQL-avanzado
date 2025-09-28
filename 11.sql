/* 
1. Generar los campos repeated_phone_24H, 
cause_recall_phone_24H 
Como en el ejercicio anterior queremos tener un registro por cada llamada y dos 
flags que indiquen si el calls_phone_number tiene una llamada las anteriores 24 
horas o en las siguientes 24 horas. En caso afirmativo pondremos un 1 en estos 
flag, de lo contrario llevará un 0. 
 
Entregar el código en un fichero .sql
*/

-- En esta consulta, usamos dos subconsultas para verificar si existen llamadas
-- del mismo número de teléfono en las 24 horas anteriores y posteriores a la
-- llamada actual. 
SELECT 
*,
  -- flag: llamada repetida en las 24 horas anteriores
  CASE 
    WHEN EXISTS (
      SELECT 1
      FROM keepcoding.ivr_calls 
        WHERE phone_number = calls_phone_number
        AND start_date < calls_start_date
        AND start_date >= TIMESTAMP_SUB(calls_start_date, INTERVAL 24 HOUR)
    ) THEN 1 ELSE 0
  END AS repeated_phone_24H,

  -- flag: llamada repetida en las 24 horas siguientes
  CASE 
    WHEN EXISTS (
      SELECT 1
      FROM keepcoding.ivr_calls 
      WHERE phone_number = calls_phone_number
        AND start_date > calls_start_date
        AND start_date <= TIMESTAMP_ADD(calls_start_date, INTERVAL 24 HOUR)
    ) THEN 1 ELSE 0
  END AS cause_recall_phone_24H

FROM keepcoding.ivr_detail
;