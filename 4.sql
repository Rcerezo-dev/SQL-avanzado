/*
4. Generar el campo vdn_aggregation 
Generar el campo para cada llamada, es decir, queremos tener el campo 
calls_ivr_id y el campo vdn_aggregation con la siguiente lógica: 
 
es una generalización del campo vdn_label. Si vdn_label empieza por ATC 
pondremos FRONT, si empieza por TECH pondremos TECH si es ABSORPTION 
dejaremos ABSORPTION y si no es ninguna de las anteriores pondremos RESTO. 
 
Entregar el código en un fichero .sql
*/
-- . Actualizar el campo vdn_aggregation según la lógica
CREATE OR REPLACE TABLE keepcoding.ivr_detail AS -- Crea o reemplaza la tabla ivr_detail en el esquema keepcoding
SELECT
    *, -- Selecciona todas las columnas existentes
    CASE -- Inicia una expresión condicional para crear el campo vdn_aggregation
        WHEN calls_vdn_label LIKE 'ATC%' THEN 'FRONT' -- Si calls_vdn_label empieza por 'ATC', asigna 'FRONT'
        WHEN calls_vdn_label LIKE 'TECH%' THEN 'TECH' -- Si calls_vdn_label empieza por 'TECH', asigna 'TECH'
        WHEN calls_vdn_label = 'ABSORPTION' THEN 'ABSORPTION' -- Si calls_vdn_label es 'ABSORPTION', asigna 'ABSORPTION'
        ELSE 'RESTO' -- En cualquier otro caso, asigna 'RESTO'
    END AS vdn_aggregation -- El resultado se guarda en la nueva columna vdn_aggregation
FROM keepcoding.ivr_detail 
;

-- . Verificar los cambios
SELECT calls_ivr_id, calls_vdn_label, vdn_aggregation 
FROM keepcoding.ivr_detail 