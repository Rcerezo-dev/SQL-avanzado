/*
12. CREAR TABLA DE ivr_summary (Para nota) 
Con la base de la tabla ivr_detail y el código de todos los ejercicios anteriores 
vamos a crear la tabla ivr_sumary . Ésta será un resumen de la llamada donde 
se incluyen los indicadores más importantes de la llamada. Por tanto, sólo tendrá 
un registro por llamada. 
Queremos que tengan los siguientes campos: 
 
ivr_id: identificador de la llamada (viene de detail). 
phone_number: número llamante (viene de detail). 
ivr_result: resultado de la llamada (viene de detail). 
vdn_aggregation: calculado anteriormente. 
start_date: fecha inicio de la llamada (viene de detail). 
end_date: fecha fin de la llamada (viene de detail). 
total_duration: duración de la llamada (viene de detail). 
customer_segment: segmento del cliente (viene de detail). 
ivr_language: idioma de la IVR (viene de detail). 
steps_module: número de módulos por los que pasa la llamada (viene de 
detail). 
module_aggregation: lista de módulos por los que pasa la llamada (viene 
de detail. 
document_type: calculado anteriormente. 
document_identification: calculado anteriormente. 
customer_phone: calculado anteriormente. 
billing_account_id: calculado anteriormente. 
masiva_lg: calculado anteriormente. 
info_by_phone_lg: calculado anteriormente. 
info_by_dni_lg: calculado anteriormente. 
repeated_phone_24H: calculado anteriormente. 
cause_recall_phone_24H: calculado anteriormente. 
Entregar el código SQL que generaría la tabla ivr_summary dentro del dataset 
keepcoding.
*/ 





-- En este caso, he utilizado las columnas generadas por las consultas de los anteriores ejercicios para
--usarlos como CTEs y luego hacer un SELECT final con todos los campos pedidos.
-- Añadimos document type e identification  como CTE 
-- Documentos válidos
CREATE OR REPLACE TABLE keepcoding.ivr_summary AS (

WITH document AS (
SELECT calls_ivr_id, document_type, document_identification FROM keepcoding.ivr_detail WHERE document_type NOT IN ('UNKNOWN','DESCONOCIDO') AND document_identification NOT IN ('UNKNOWN','DESCONOCIDO') QUALIFY ROW_NUMBER() OVER ( PARTITION BY CAST(calls_ivr_id AS STRING) ORDER BY step_sequence ) = 1 ),


phone AS (
  SELECT
    calls_ivr_id,
    calls_phone_number AS customer_phone
  FROM keepcoding.ivr_detail
  WHERE calls_phone_number IS NOT NULL
    AND calls_phone_number <> 'UNKNOWN'
  QUALIFY ROW_NUMBER() OVER ( PARTITION BY CAST(calls_ivr_id AS STRING) ORDER BY step_sequence ) = 1
),

billing AS (
  SELECT
    calls_ivr_id,
    billing_account_id
  FROM keepcoding.ivr_detail
  WHERE billing_account_id IS NOT NULL
  QUALIFY ROW_NUMBER() OVER ( PARTITION BY CAST(calls_ivr_id AS STRING) ORDER BY step_sequence ) = 1
),

masiva AS (
  SELECT
    calls_ivr_id,
    MAX(CASE WHEN module_name = 'AVERIA_MASIVA' THEN 1 ELSE 0 END) AS masiva_lg
  FROM keepcoding.ivr_detail
  GROUP BY calls_ivr_id
),

info_by_phone AS (
  SELECT
    calls_ivr_id,
    MAX(CASE WHEN step_name = 'CUSTOMERINFOBYPHONE.TX' AND step_result = 'OK' THEN 1 ELSE 0 END) AS info_by_phone_lg
  FROM keepcoding.ivr_detail
  GROUP BY calls_ivr_id
),

info_by_dni AS (
  SELECT
    calls_ivr_id,
    MAX(CASE WHEN step_name = 'CUSTOMERINFOBYDNI.TX' AND step_result = 'OK' THEN 1 ELSE 0 END) AS info_by_dni_lg
  FROM keepcoding.ivr_detail
  GROUP BY calls_ivr_id
),

repeated_phone AS (
  SELECT 
    ivr_id AS calls_ivr_id,
    CASE 
      WHEN EXISTS (
        SELECT 1
        FROM keepcoding.ivr_calls 
        WHERE phone_number = phone_number
          AND start_date < start_date
          AND start_date >= TIMESTAMP_SUB(start_date, INTERVAL 24 HOUR)
      ) THEN 1 ELSE 0
    END AS repeated_phone_24H,
    CASE 
      WHEN EXISTS (
        SELECT 1
        FROM keepcoding.ivr_calls 
        WHERE phone_number = phone_number
          AND start_date > start_date
          AND start_date <= TIMESTAMP_ADD(start_date, INTERVAL 24 HOUR)
      ) THEN 1 ELSE 0
    END AS cause_recall_phone_24H
  FROM keepcoding.ivr_calls 
)

SELECT 
    det.calls_ivr_id AS ivr_id,
    det.calls_phone_number AS phone_number,
    det.calls_ivr_result AS ivr_result,
    det.calls_vdn_label AS vdn_label,  -- corregido
    det.calls_start_date AS start_date,
    det.calls_end_date AS end_date,
    det.calls_total_duration AS total_duration,
    det.calls_customer_segment AS customer_segment,
    det.calls_ivr_language AS ivr_language,
    det.step_sequence AS steps_module,
    det.module_name AS module_aggregation,
    doc.document_type,
    doc.document_identification,
    ph.customer_phone,
    ba.billing_account_id,
    ma.masiva_lg,
    ip.info_by_phone_lg,
    id.info_by_dni_lg,
    rp.repeated_phone_24H,
    rp.cause_recall_phone_24H 

FROM keepcoding.ivr_detail AS det
LEFT JOIN document AS doc 
ON det.calls_ivr_id = doc.calls_ivr_id
LEFT JOIN phone AS ph 
ON det.calls_ivr_id = ph.calls_ivr_id
LEFT JOIN billing AS ba 
ON det.calls_ivr_id = ba.calls_ivr_id
LEFT JOIN masiva AS ma 
ON det.calls_ivr_id = ma.calls_ivr_id
LEFT JOIN info_by_phone AS ip
 ON det.calls_ivr_id = ip.calls_ivr_id
LEFT JOIN info_by_dni AS id
 ON det.calls_ivr_id = id.calls_ivr_id
LEFT JOIN repeated_phone AS rp 
ON det.calls_ivr_id = rp.calls_ivr_id
);