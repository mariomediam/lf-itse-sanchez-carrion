-- Amplía actividad de licencias_funcionamiento de varchar(50) a varchar(250).
-- Coincide con LicenciaFuncionamiento.actividad (CharField max_length=250).

ALTER TABLE licencias_funcionamiento
    ALTER COLUMN actividad TYPE varchar(250);
