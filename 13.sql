/*13. 
CREAR FUNCIÓN DE LIMPIEZA DE ENTEROS 
Crear una función de limpieza de enteros por la que si entra un null la función 
devuelva el valor -999999. 
Entregar el código SQL que generaría la función clean_integer dentro del dataset 
keepcoding. 

*/ 

CREATE FUNCTION keepcoding.clean_integer(input INT64)
RETURNS INT64
AS (
CASE 
    WHEN input IS NULL THEN -999999
    ELSE input
    END
);