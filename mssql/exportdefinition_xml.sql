set nocount on;

select
  x.dbname '@name',
  (
    select
      t.name '@name',
      s.name '@schema',
      (
        select
          c.COLUMN_NAME '@name',
          (
            select
              top 1 case
                when ty.name = 'varchar' then 'varchar'
                when ty.name = 'nvarchar' then 'nvarchar'
                when ty.name = 'bit' then 'bit'
                when ty.name = 'numeric' then 'decimal'
                when ty.name = 'decimal' then 'decimal'
                when ty.name = 'int' then 'int'
                when ty.name = 'bigint' then 'bigint'
                when ty.name = 'date' then 'date'
                when ty.name = 'datetime' then 'datetime'
                when ty.name = 'datetime2' then 'datetime2'
                when ty.name = 'float' then 'float'
                when ty.name = 'time' then 'time'
                when ty.name = 'char' then 'char'
                when ty.name = 'nchar' then 'nchar'
                when ty.name = 'tinyint' then 'tinyint'
                when ty.name = 'smallint' then 'smallint'
                when ty.name = 'money' then 'money'
                when ty.name = 'xml' then 'xml'
                when ty.name = 'uniqueidentifier' then 'uniqueidentifier'
                when ty.name = 'hierarchyid' then 'hierarchyid'
                when ty.name = 'varbinary' then 'varbinary'
                when ty.name = 'smallmoney' then 'smallmoney'
                when ty.name = 'image' then 'image'
                when ty.name = 'text' then 'text'
                when ty.name = 'ntext' then 'ntext'
              end
            from
              sys.types ty
              inner join sys.columns co on co.system_type_id = ty.system_type_id
              inner join sys.tables t on t.name = c.table_name
              and t.object_id = co.object_id
              inner join sys.schemas s on s.name = c.table_schema
              and s.schema_id = t.schema_id
            where
              co.name = c.column_name
          ) '@type'
      )
  ),
  lower(c.is_nullable) '@nullable',
  CAST(c.character_maximum_length AS NVARCHAR(10)) '@length',
  CAST(c.numeric_precision AS NVARCHAR(10)) '@precision',
  CAST(c.numeric_scale AS NVARCHAR(10)) '@scale'
from
  INFORMATION_SCHEMA.COLUMNS c
  left outer join INFORMATION_SCHEMA.VIEWS b on c.TABLE_CATALOG = b.TABLE_CATALOG
  and c.TABLE_SCHEMA = b.TABLE_SCHEMA
  and c.TABLE_NAME = b.TABLE_NAME
where
  b.TABLE_CATALOG is null
order by
  c.TABLE_SCHEMA,
  c.TABLE_NAME,
  c.ORDINAL_POSITION for xml path('Field'),
  root('Fields'),
  type
) --,
-- (
--   select
--     ku.column_name '@name',
--     CAST(ku.ordinal_position AS char(1)) '@pos'
--   from
--     sys.tables t
--     inner join information_schema.table_constraints tc on tc.table_name = t.name
--     inner join information_schema.key_column_usage ku on tc.constraint_type = 'PRIMARY KEY'
--     and tc.constraint_name = ku.constraint_name
--     and ku.table_name = t.name
--     inner JOIN sys.schemas s on s.schema_id = t.schema_id for xml path('Field'),
--     root('PrimaryKey'),
--     type
-- ),
-- (
--   SELECT
--     f.name '@name',
--     COL_NAME(fc.parent_object_id, fc.parent_column_id) '@column',
--     SCHEMA_NAME(
--       (
--         SELECT
--           TOP 1 schema_id
--         FROM
--           sys.tables
--         WHERE
--           object_id = f.referenced_object_id
--       )
--     ) '@referencedSchema',
--     OBJECT_NAME (f.referenced_object_id) '@referencedTable',
--     COL_NAME(fc.referenced_object_id, fc.referenced_column_id) '@referencedColumn'
--   FROM
--     sys.foreign_keys AS f
--     INNER JOIN sys.foreign_key_columns AS fc ON f.OBJECT_ID = fc.constraint_object_id FOR XML PATH('ForeignKey'),
--     ROOT('ForeignKeys'),
--     type
-- ),
-- (
--   select
--     i.name '@name',
--     IIF(i.is_unique = 0, 'no', 'yes') '@unique',
--     IIF(i.[type] = 3, 'yes', 'no') '@xml'
--   from
--     sys.tables t
--     inner join sys.indexes i on i.object_id = t.object_id
--     inner JOIN sys.schemas s on s.schema_id = t.schema_id
--   where
--     i.is_primary_key = 0
--     and i.name is not null
--   order by
--     t.name for xml path('Index'),
--     root('Indexes'),
--     type
-- )
-- from
--   sys.tables t
--   inner join sys.schemas s on s.schema_id = t.schema_id for xml path('Table'),
--   type
-- )
from
  (
    select
      db_name() dbname
  ) x for xml path('Database'),
  type