set nocount on

select db.content --, sort, tbl, innerSort
from
(
    select 0 sort, '' [schema], '' tbl, 0 innerSort, 0 col, '<?xml version="1.0"?>' content
    union
    select 1, '', '', 0, 0, CONCAT('<Database name="', db_name(), '">')
    union
    select 2, s.name, t.name, 0, 0, CONCAT('<Table name="', t.name, '" schema="', s.name, '">')
    from
        sys.tables t
    inner join
        sys.schemas s on s.schema_id=t.schema_id    
    union
    select 3, s.name, t.name, 0, 0, '<Fields>'
    from
        sys.tables t
    inner JOIN
        sys.schemas s on s.schema_id = t.schema_id
    union

    select top 100 percent 4, c.table_schema, c.table_name, 0, c.ordinal_position /*, c.character_maximum_length, c.numeric_precision, c.numeric_scale */, CONCAT('<Field name="', c.column_name, '" type="', 
        (select top 1 concat(
		case
            when ty.name='varchar' then 'varchar'
            when ty.name='nvarchar' then 'nvarchar'
            when ty.name='bit' then 'bit'
            when ty.name='numeric' then 'decimal'
            when ty.name='decimal' then 'decimal'
            when ty.name='int' then 'int'
            when ty.name='bigint' then 'bigint'
            when ty.name='date' then 'date'
            when ty.name='datetime' then 'datetime'
            when ty.name='datetime2' then 'datetime2'
            when ty.name='float' then 'float'
            when ty.name='time' then 'time'
            when ty.name='char' then 'char'
            when ty.name='nchar' then 'nchar'
            when ty.name='tinyint' then 'tinyint'
            when ty.name='smallint' then 'smallint'
            when ty.name='money' then 'money'
            when ty.name='xml' then 'xml'
            when ty.name='uniqueidentifier' then 'uniqueidentifier'
            when ty.name='hierarchyid' then 'hierarchyid'
            when ty.name='varbinary' then 'varbinary'
            when ty.name='smallmoney' then 'smallmoney'
            when ty.name='image' then 'image'
            when ty.name='text' then 'text'
            when ty.name='ntext' then 'ntext'
        end, '" nullable="', lower(c.is_nullable), '" length="', CAST(c.character_maximum_length AS NVARCHAR(10)), '"', ' precision="', CAST(c.numeric_precision AS NVARCHAR(10)), '" scale="', CAST(c.numeric_scale AS NVARCHAR(10)), '"/>')
		from 
			sys.types ty
		inner join
			sys.columns co on co.system_type_id=ty.system_type_id
		inner join
			sys.tables t on t.name = c.table_name
			and t.object_id=co.object_id
		inner join
			sys.schemas s on s.name = c.table_schema
			and s.schema_id = t.schema_id
		where co.name = c.column_name
		))
    from
        INFORMATION_SCHEMA.COLUMNS c
	LEFT OUTER JOIN INFORMATION_SCHEMA.VIEWS b ON c.TABLE_CATALOG = b.TABLE_CATALOG
		AND c.TABLE_SCHEMA = b.TABLE_SCHEMA
		AND c.TABLE_NAME = b.TABLE_NAME
	where b.table_catalog is null
    order by
        c.table_schema, c.table_name, c.ordinal_position

    union

    select 5, s.name, t.name, 0, 0, '</Fields>'
    from
        sys.tables t
    inner JOIN
        sys.schemas s on s.schema_id = t.schema_id
    union
    select 6, s.name, t.name, 0, 0, '<PrimaryKey>'
    from
        sys.tables t
    inner JOIN
        sys.schemas s on s.schema_id=t.schema_id
    union

    select 7, s.name, t.name, 0, ku.ordinal_position, CONCAT('<Field name="', ku.column_name, '" pos="', CAST(ku.ordinal_position AS char(1)), '"/>')
    from
        sys.tables t
    inner join
        information_schema.table_constraints tc on tc.table_name=t.name
    inner join
        information_schema.key_column_usage ku
            on tc.constraint_type = 'PRIMARY KEY'
            and tc.constraint_name = ku.constraint_name
            and ku.table_name=t.name
    inner JOIN
        sys.schemas s on s.schema_id = t.schema_id

    union

    select 8, s.name, t.name, 0, 0, '</PrimaryKey>'
    from
        sys.tables t
    inner JOIN
        sys.schemas s on s.schema_id = t.schema_id

    union

	    select 10, s.name, t.name, 0, 0, '<ForeignKeys>'
    from
        sys.tables t
    inner JOIN
        sys.schemas s on s.schema_id = t.schema_id

	union

SELECT 11, SCHEMA_NAME(f.schema_id), OBJECT_NAME(f.parent_object_id), 0, 0,
	'<ForeignKey name="' + f.name + '" column="' + COL_NAME(fc.parent_object_id, fc.parent_column_id) + '" referencedSchema="' + SCHEMA_NAME((SELECT TOP 1 schema_id FROM sys.tables WHERE object_id=f.referenced_object_id)) + '" referencedTable="' + OBJECT_NAME (f.referenced_object_id) + '" referencedColumn="' + COL_NAME(fc.referenced_object_id, fc.referenced_column_id) + '"/>'
FROM sys.foreign_keys AS f
INNER JOIN sys.foreign_key_columns AS fc
   ON f.OBJECT_ID = fc.constraint_object_id

	union

    select 12, s.name, t.name, 0, 0, '</ForeignKeys>'
    from
        sys.tables t
    inner JOIN
        sys.schemas s on s.schema_id = t.schema_id

	union

    select 13, s.name, t.name, 0, 0, '<Indexes>'
    from
        sys.tables t
    inner JOIN
        sys.schemas s on s.schema_id = t.schema_id

    union

    select top 100 percent 14, s.name, t.name, (ROW_NUMBER() OVER (PARTITION BY s.name,t.name ORDER BY s.name,t.name,i.index_id)) * 10, 0, CONCAT('<Index name="', i.name, '" unique="' + IIF(i.is_unique=0, 'no', 'yes') + '">')
    from
        sys.tables t
    inner join
        sys.indexes i on i.object_id=t.object_id
    inner JOIN
        sys.schemas s on s.schema_id = t.schema_id
    where
        i.is_primary_key = 0
        and i.name is not null
	order by t.name

    union
    select top 100 percent 14, s.name, t.name, (RANK() OVER (PARTITION BY s.name,t.name ORDER BY s.name,t.name,i.index_id)) * 10 + (ROW_NUMBER() OVER (PARTITION BY s.name,t.name,i.index_id ORDER BY s.name,t.name,i.index_id,ic.key_ordinal)), ic.key_ordinal, CONCAT('<Field name="', co.[name], '" pos="', CAST(ic.key_ordinal AS char(1)), '"/>')
    from
        sys.indexes i 
    inner join 
        sys.objects o on i.object_id = o.object_id
    inner join sys.index_columns ic on ic.object_id = i.object_id 
        and ic.index_id = i.index_id
    inner join sys.columns co on co.object_id = i.object_id 
        and co.column_id = ic.column_id
    inner join sys.tables t on t.object_id = o.object_id
    inner join sys.schemas s on s.schema_id = t.schema_id
    where i.[type] = 2 
        -- and i.is_unique = 0 
        and i.is_primary_key = 0
        and o.[type] = 'U'
        --and ic.is_included_column = 0
	order by object_name(i.object_id)

    union

    select top 100 percent 14, s.name, t.name, (ROW_NUMBER() OVER (PARTITION BY s.name,t.name ORDER BY s.name,t.name)) * 10 + 9, 0, '</Index>'
    from
        sys.tables t
    inner join
        sys.indexes i on i.object_id=t.object_id
    inner JOIN
        sys.schemas s on s.schema_id = t.schema_id
    where
        i.is_primary_key = 0
        and i.name is not null
	order by t.name

    union

    select 15, s.name, t.name, 0, 0, '</Indexes>'
    from
        sys.tables t
    inner JOIN
        sys.schemas s on s.schema_id = t.schema_id

    union

    select 16, s.name, t.name, 0, 0, '</Table>'
    from
        sys.tables t
    inner JOIN
        sys.schemas s on s.schema_id = t.schema_id
    union
    select 999, 'xxx', 'xxx', 0, 0, '</Database>'
) db
order by db.[schema], db.tbl, db.sort, db.innerSort, db.col
