select db.xcontent
from
(
    select 0 sort, '' "schema", '' tbl, 0 innerSort, 0 col, '<?xml version="1.0"?>' xcontent
    union
    select 1, '', '', 0, 0, CONCAT('<Database name="', current_database(), '">')
    union
    select 2, t.table_schema, t.table_name, 0, 0, CONCAT('<Table schema="', t.table_schema, '" name="', t.table_name, '">')
    from
        information_schema.tables t
    where 
        t.table_type='BASE TABLE'  and t.table_schema not in ('pg_catalog', 'information_schema')
    union
    select 3, t.table_schema, t.table_name, 0, 0, '<Fields>'
    from
        information_schema.tables t
    where 
        t.table_type='BASE TABLE'  and t.table_schema not in ('pg_catalog', 'information_schema')
    union

    select 4, t.table_schema, t.table_name, 0, c.ordinal_position, CONCAT('<Field name="', c.column_name, '" type="', 
        case
            when c.data_type='character varying' then CONCAT('varchar', '(', c.character_maximum_length, ')')
            when c.data_type='integer' then 'int'
            when c.data_type='date' then 'date'
            when c.data_type='float' then 'float'
            when c.data_type='time' then 'time'
            when c.data_type='character' then CONCAT('char', '(', c.character_maximum_length, ')')
        end, '" nullable="', lower(c.is_nullable), '"/>')
    from
        information_schema.tables t
    inner join
        information_schema.columns c on t.table_schema=c.table_schema AND t.table_name=c.table_name
    where 
        t.table_type='BASE TABLE'  and t.table_schema not in ('pg_catalog', 'information_schema')

    union

    select 5, t.table_schema, t.table_name, 0, 0, '</Fields>'
    from
        information_schema.tables t
    where 
        t.table_type='BASE TABLE' and t.table_schema not in ('pg_catalog', 'information_schema')

    union

    select 6, t.table_schema, t.table_name, 0, 0, '<PrimaryKey>'
    from
        information_schema.tables t
    where 
        t.table_type='BASE TABLE' and t.table_schema not in ('pg_catalog', 'information_schema')

    union

    select 7, t.table_schema, t.table_name, 0, kcu.ordinal_position, CONCAT('<Field name="', kcu.column_name, '" pos="', CAST(kcu.ordinal_position AS char(1)), '"/>')
    from
        information_schema.tables t 
    inner join
        information_schema.key_column_usage kcu on kcu.table_name=t.table_name
    where 
        t.table_type='BASE TABLE' and t.table_schema not in ('pg_catalog', 'information_schema')

    union

    select 8, t.table_schema, t.table_name, 0, 0, '</PrimaryKey>'
    from
        information_schema.tables t
    where 
        t.table_type='BASE TABLE' and t.table_schema not in ('pg_catalog', 'information_schema')

    union

    select 9, t.table_schema, t.table_name, 0, 0, '<ForeignKeys>'
    from
        information_schema.tables t
    where 
        t.table_type='BASE TABLE' and t.table_schema not in ('pg_catalog', 'information_schema')

    union

	select 10, tc.table_schema, tc.table_name, 0, 0, CONCAT('<ForeignKey name="', tc.constraint_name, '" column="', kcu.column_name, '" referencedSchema="', ccu.table_schema, '" referencedTable="', ccu.table_name, '" referencedColumn="', ccu.column_name, '"/>')
	FROM 
	    information_schema.table_constraints AS tc 
	    JOIN information_schema.key_column_usage AS kcu
	      ON tc.constraint_name = kcu.constraint_name
	      AND tc.table_schema = kcu.table_schema
	    JOIN information_schema.constraint_column_usage AS ccu
	      ON ccu.constraint_name = tc.constraint_name
	      AND ccu.table_schema = tc.table_schema
	    join information_schema.tables as t
	      on t.table_schema = tc.table_schema and t.table_name = tc.table_name
	WHERE constraint_type = 'FOREIGN KEY' and tc.table_schema not in ('pg_catalog', 'information_schema')
	
    union

    select 11, t.table_schema, t.table_name, 0, 0, '</ForeignKeys>'
    from
        information_schema.tables t
    where 
        t.table_type='BASE TABLE' and t.table_schema not in ('pg_catalog', 'information_schema')

    union

    select 12, t.table_schema, t.table_name, 0, 0, '<Indexes>'
    from
        information_schema.tables t
    where 
        t.table_type='BASE TABLE' and t.table_schema not in ('pg_catalog', 'information_schema')

    union

    select 14, t.table_schema, t.table_name, (ROW_NUMBER() OVER (PARTITION BY t.table_name ORDER BY t.table_name)) * 10, i.indrelid, CONCAT('<Index name="', c2.relname, '">')
    from
        information_schema.tables t
	inner join
		pg_catalog.pg_class c on c.relname = t.table_name
	inner join 
		pg_catalog.pg_index i on i.indrelid = c.oid
	inner join 
		pg_catalog.pg_class c2 on c2.oid = i.indexrelid
    where 
        t.table_type='BASE TABLE'  and t.table_schema not in ('pg_catalog', 'information_schema')
        and i.indisprimary=false

    union

    select 14, t.table_schema, t.table_name, (ROW_NUMBER() OVER (PARTITION BY c.oid::oid ORDER BY c.oid::oid)) + (ROW_NUMBER() OVER (PARTITION BY t.table_name ORDER BY t.table_name)) * 10, i.indrelid, CONCAT('<Field name="', x.colname, '" pos="0"/>')
--		t.table_name, c.oid::oid oid, c2.relname, x.colname 
    from
        information_schema.tables t
	inner join
		pg_catalog.pg_class c on c.relname = t.table_name
	inner join 
		pg_catalog.pg_index i on i.indrelid = c.oid
	inner join 
		pg_catalog.pg_class c2 on c2.oid = i.indexrelid
  	left join 
  		pg_catalog.pg_constraint con ON conrelid = i.indrelid AND conindid = i.indexrelid AND contype IN ('x')
        
    inner join    
    (
		select xc.oid::oid, xc2.relname, regexp_split_to_table(substring(pg_catalog.pg_get_indexdef(xi.indexrelid, 0, true) 
			from position('(' in pg_catalog.pg_get_indexdef(xi.indexrelid, 0, true))+1
			for char_length(pg_catalog.pg_get_indexdef(xi.indexrelid, 0, true))-
			position('(' in pg_catalog.pg_get_indexdef(xi.indexrelid, 0, true))-1),',') colname
	    from
	        information_schema.tables xt
		inner join
			pg_catalog.pg_class xc on xc.relname = xt.table_name
		inner join 
			pg_catalog.pg_index xi on xi.indrelid = xc.oid
		inner join 
			pg_catalog.pg_class xc2 on xc2.oid = xi.indexrelid
	  	left join 
	  		pg_catalog.pg_constraint xcon ON conrelid = xi.indrelid AND conindid = xi.indexrelid AND contype IN ('x')
	    where 
	        xt.table_type='BASE TABLE' and xt.table_schema not in ('pg_catalog', 'information_schema')
            and xi.indisprimary=false
	) x on x.oid = c.oid and x.relname=c2.relname

    where 
	    t.table_type='BASE TABLE' and t.table_schema not in ('pg_catalog', 'information_schema')
        and i.indisprimary=false

    union

    select 14, t.table_schema, t.table_name, (ROW_NUMBER() OVER (PARTITION BY t.table_name ORDER BY t.table_name)) * 10 + 9, i.indrelid, '</Index>'
    from
        information_schema.tables t
	inner join
		pg_catalog.pg_class c on c.relname = t.table_name
	inner join 
		pg_catalog.pg_index i on i.indrelid = c.oid
	inner join 
		pg_catalog.pg_class c2 on c2.oid = i.indexrelid
    where 
        t.table_type='BASE TABLE' and t.table_schema not in ('pg_catalog', 'information_schema')
        and i.indisprimary=false

    union

    select 15, t.table_schema, t.table_name, 0, 0, '</Indexes>'
    from
        information_schema.tables t
    where 
        t.table_type='BASE TABLE' and t.table_schema not in ('pg_catalog', 'information_schema')

    union

    select 16, t.table_schema, t.table_name, 0, 0, CONCAT('</Table>')
    from
        information_schema.tables t
    where 
        t.table_type='BASE TABLE'  and t.table_schema not in ('pg_catalog', 'information_schema')

    union

    select 999, 'xxx', 'xxx', 0, 0, '</Database>'

) db
order by db."schema", db.tbl, db.sort, db.innerSort, db.col
