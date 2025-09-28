/*
2. CREACIÓN DE BASE DE DATOS 
Desarrollar un script para crear las tablas y las restricciones necesarias según el 
diagrama entregado en el punto anterior. 
El script debe poder ejecutarse en PostgreSQL. 
Se debe entregar un fichero con el código solicitado y extensión .sql 
*/
CREATE TABLE keepcoding.bootcamp (
  bootcamp_id INT64, -- Identificador único del bootcamp
  nombre_bootcamp STRING,
  edicion STRING,
  fecha_inicio DATE,
  fecha_fin DATE
);



CREATE TABLE keepcoding.alumnos (
    alumno_id INT64, -- Identificador único del alumno
    nombre_alumno STRING,
    apellido_alumno STRING,
    tipo_facturacion STRING,
    email_alumno STRING,
    telefono_alumno STRING,
    discord_alumno STRING,
    curso STRING,
    pais_id STRING, -- Identificador del país del alumno (clave foránea)
    bootcamp_id INT64, -- Identificador del bootcamp al que pertenece el alumno (clave foránea)
    notas_id INT64 -- Identificador de notas del alumno (clave foránea
) 
;
CREATE TABLE keepcoding.paises (
    pais_id INT64, -- Identificador único del país
    nombre_pais STRING,
    huso_horario STRING
);


CREATE TABLE keepcoding.notas (
    notas_id INT64, -- Identificador único de las notas
    is_passed BOOL, -- Nota del alumno
    asignaturas_id INT64, -- Fecha en que se registró la nota
    alumno_id INT64 -- Identificador del alumno al que pertenecen las notas (clave foránea)
);
CREATE TABLE keepcoding.asignaturas (
    asignaturas_id INT64, -- Identificador único de la asignatura
    nombre_asignatura STRING,
    bootcamp_id INT64,
    transversal BOOL,
    mes DATE,
    horas_lectivas INT64,
    profesor_id INT64 -- Identificador del profesor que imparte la asignatura (clave foránea)
);

CREATE TABLE keepcoding.profesores (
    profesor_id INT64, -- Identificador único del profesor
    nombre_profesor STRING,
    apellido_profesor STRING,
    email_profesor STRING,
    sueldo_profesor FLOAT64,
    asignaturas_id INT64 -- Identificador de la asignatura que imparte el profesor (clave foránea)
);

CREATE TABLE keepcoding.personal_no_docente (
    trabajador_id INT64, -- Identificador único del personal no docente
    nombre_trabajador STRING,
    apellidos_trabajador STRING,
    email_trabajador STRING,
    sueldo_personal FLOAT64,
    país_id INT64 -- Identificador del país donde trabaja el personal no docente (clave foránea)
);