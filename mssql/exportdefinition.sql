set nocount on

select db.content --, sort, tbl, innerSort
from
(
    select 0 sort, '' tbl, 0 innerSort, 0 col, '<?xml version="1.0"?>' content
    union
    select 1, '', 0, 0, CONCAT('<Database name="', db_name(), '">')
    union
    select 2, t.name, 0, 0, CONCAT('<Table name="', t.name, '">')
    from
        sys.tables t
    union
    select 3, t.name, 0, 0, '<Fields>'
    from
        sys.tables t
    union

    select top 100 percent 4, t.name, 0, c.ordinal_position, CONCAT('<Field name="', co.name, '" type="', 
        case
            when ty.name='varchar' then CONCAT(ty.name, '(255)')
            when ty.name='int' then 'int'
            when ty.name='date' then 'date'
            when ty.name='float' then 'float'
            when ty.name='time' then 'time'
            when ty.name='char' then CONCAT('char', '(66)')
        end, '" nullable="', lower(c.is_nullable), '"/>')
    from
        sys.tables t
    inner join
        INFORMATION_SCHEMA.COLUMNS c on c.table_name = t.name
    inner join
        sys.columns co on co.name = c.column_name
    inner join
        sys.types ty on ty.system_type_id=co.system_type_id
    order by
        c.ordinal_position

    union

    select 5, t.name, 0, 0, '</Fields>'
    from
        sys.tables t
    union
    select 6, t.name, 0, 0, '<PrimaryKey>'
    from
        sys.tables t
    union

    select 7, t.name, 0, ku.ordinal_position, CONCAT('<Field name="', ku.column_name, '" pos="', CAST(ku.ordinal_position AS char(1)), '"/>')
    from
        sys.tables t
    inner join
        information_schema.table_constraints tc on tc.table_name=t.name
    inner join
        information_schema.key_column_usage ku
            on tc.constraint_type = 'PRIMARY KEY'
            and tc.constraint_name = ku.constraint_name
            and ku.table_name=t.name

    union

    select 8, t.name, 0, 0, '</PrimaryKey>'
    from
        sys.tables t

    union

    select 9, t.name, 0, 0, '<Indexes>'
    from
        sys.tables t

    union

    select top 100 percent 10, t.name, (ROW_NUMBER() OVER (PARTITION BY t.name ORDER BY t.name)) * 10, 0, CONCAT('<Index name="', i.name, '">')
    from
        sys.tables t
    inner join
        sys.indexes i on i.object_id=t.object_id
    where
        i.is_primary_key = 0
	order by t.name

    union

    select top 100 percent 10, object_name(o.object_id), (ROW_NUMBER() OVER (PARTITION BY i.object_id ORDER BY i.object_id)) + (ROW_NUMBER() OVER (PARTITION BY object_name(o.object_id) ORDER BY object_name(o.object_id))) * 10, ic.key_ordinal, CONCAT('<Field name="', co.[name], '" pos="', CAST(ic.key_ordinal AS char(1)), '"/>')
    from
        sys.indexes i 
    inner join 
        sys.objects o on i.object_id = o.object_id
    join sys.index_columns ic on ic.object_id = i.object_id 
        and ic.index_id = i.index_id
    join sys.columns co on co.object_id = i.object_id 
        and co.column_id = ic.column_id
    where i.[type] = 2 
        and i.is_unique = 0 
        and i.is_primary_key = 0
        and o.[type] = 'U'
        --and ic.is_included_column = 0
	order by object_name(o.object_id)

    union

    select top 100 percent 10, t.name, (ROW_NUMBER() OVER (PARTITION BY t.name ORDER BY t.name)) * 10 + 9, 0, '</Index>'
    from
        sys.tables t
    inner join
        sys.indexes i on i.object_id=t.object_id
    where
        i.is_primary_key = 0
	order by t.name

    union

    select 13, t.name, 0, 0, '</Indexes>'
    from
        sys.tables t

    union

    select 14, t.name, 0, 0, '</Table>'
    from
        sys.tables t
    union
    select 999, 'xxx', 0, 0, '</Database>'
) db
order by db.tbl, db.sort, db.innerSort, db.col


