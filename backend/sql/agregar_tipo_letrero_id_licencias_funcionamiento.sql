-- Agrega tipo_letrero_id a licencias_funcionamiento.
-- Coincide con el ForeignKey del modelo LicenciaFuncionamiento
-- (db_column = tipo_letrero_id, on_delete = PROTECT) hacia tipos_letrero(id).

ALTER TABLE licencias_funcionamiento
    ADD COLUMN IF NOT EXISTS tipo_letrero_id bigint;

-- Si la tabla ya tiene filas, asigne un tipo existente antes de exigir NOT NULL.
-- UPDATE licencias_funcionamiento
-- SET tipo_letrero_id = 1
-- WHERE tipo_letrero_id IS NULL;

ALTER TABLE licencias_funcionamiento
    ALTER COLUMN tipo_letrero_id SET NOT NULL;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conname = 'licencias_funcionamiento_tipo_letrero_id_fkey'
    ) THEN
        ALTER TABLE licencias_funcionamiento
            ADD CONSTRAINT licencias_funcionamiento_tipo_letrero_id_fkey
            FOREIGN KEY (tipo_letrero_id)
            REFERENCES tipos_letrero (id)
            DEFERRABLE INITIALLY DEFERRED;
    END IF;
END $$;

CREATE INDEX IF NOT EXISTS licencias_funcionamiento_tipo_letrero_id_idx
    ON licencias_funcionamiento (tipo_letrero_id);
