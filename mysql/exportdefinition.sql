select db.content
from
(
    select 0 sort, '' tbl, 0 col, '<?xml version="1.0"?>' content
    union
    select 1, '', 0, CONCAT('<Database name="', database(), '">')
    union
    select 2, t.table_name, 0, CONCAT('<Table name="', t.table_name, '">')
    from
        information_schema.tables t
    where 
        t.table_schema = database() and t.table_type='BASE TABLE'
    union
    select 3, t.table_name, 0, '<Fields>'
    from
        information_schema.tables t
    where 
        t.table_schema = database() and t.table_type='BASE TABLE'
    union
    select 4, t.table_name, c.ordinal_position, CONCAT('<Field name="', c.column_name, '" type="', 
        case
            when c.data_type='varchar' then CONCAT(c.data_type, '(', c.character_maximum_length, ')')
            when c.data_type='int' then 'int'
            when c.data_type='date' then 'date'
            when c.data_type='float' then 'float'
            when c.data_type='time' then 'time'
            when c.data_type='enum' then CONCAT('varchar', '(', c.character_maximum_length, ')')
            when c.data_type='char' then CONCAT('char', '(', c.character_maximum_length, ')')
        end, '" nullable="', lower(c.is_nullable), '"/>')
    from
        information_schema.tables t
    inner join
        information_schema.columns c on t.table_schema=c.table_schema AND t.table_name=c.table_name
    where 
        t.table_schema = database() and t.table_type='BASE TABLE'
    union
    select 5, t.table_name, 0, '</Fields>'
    from
        information_schema.tables t
    where 
        t.table_schema = database() and t.table_type='BASE TABLE'
    union
    select 6, t.table_name, 0, '<PrimaryKey>'
    from
        information_schema.tables t
    where 
        t.table_schema = database() and t.table_type='BASE TABLE'
    union
    select 7, t.table_name, kcu.ordinal_position, CONCAT('<Field name="', kcu.column_name, '" pos="', CAST(kcu.ordinal_position AS char(1)), '"/>')
    from
        information_schema.tables t 
    inner join
        information_schema.key_column_usage kcu on kcu.table_name=t.table_name
    where 
        t.table_schema = database() and t.table_type='BASE TABLE' and kcu.constraint_name='PRIMARY'
    union
    select 8, t.table_name, 0, '</PrimaryKey>'
    from
        information_schema.tables t
    where 
        t.table_schema = database() and t.table_type='BASE TABLE'
    union

    select 9, t.table_name, 0, '<Indexes>'
    from
        information_schema.tables t
    where 
        t.table_schema = database() and t.table_type='BASE TABLE'
    union
    select 10, t.table_name, 0, CONCAT('<Index name="', s.index_name, '">')
    from
        information_schema.tables t
    inner join
        information_schema.statistics s on t.table_name=s.table_name
    where 
        t.table_schema = database() and t.table_type='BASE TABLE' and s.index_name<>'PRIMARY'
    union
    select 11, t.table_name, s.seq_in_index, CONCAT('<Field name="', s.column_name, '" pos="', CAST(s.seq_in_index AS char(1)), '"/>')
    from
        information_schema.tables t 
    inner join
        information_schema.statistics s on t.table_name=s.table_name
    where 
        t.table_schema = database() and t.table_type='BASE TABLE' and s.index_name<>'PRIMARY'
    union
    select 12, t.table_name, 0, '</Index>'
    from
        information_schema.tables t
    inner join
        information_schema.statistics s on t.table_name=s.table_name
    where 
        t.table_schema = database() and t.table_type='BASE TABLE' and s.index_name<>'PRIMARY'

    union
    select 13, t.table_name, 0, '</Indexes>'
    from
        information_schema.tables t
    where 
        t.table_schema = database() and t.table_type='BASE TABLE'

    union

    select 14, t.table_name, 0, CONCAT('</Table>')
    from
        information_schema.tables t
    where 
        t.table_schema = database() and t.table_type='BASE TABLE'
    union
    select 999, 'xxx', 0, '</Database>'
) db
order by db.tbl, db.sort, db.col


