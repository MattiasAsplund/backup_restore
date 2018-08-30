select db.content
from
(
    select 0 sort, '' tbl, 0 col, '<?xml version="1.0"?>' content
    union
    select 1, '', 0, '<Database name="testing">'
    union
    select 2, m.name, 0, '<Table name="' || m.name || '">'
    from
        sqlite_master m
    where 
        m.type='table'
    union
    select 3, m.name, 0, '<Fields>'
    from
        sqlite_master m
    where 
        m.type='table'

    union
    select 4, m.name, c.cid, '<Field name="' || c.name || '" type="' || 
        case
            when c.type like 'varchar%' then c.type
            when c.type='int' then 'int'
            when c.type='date' then 'date'
            when c.type='float' then 'float'
            when c.type='time' then 'time'
            when c.type like 'char%' then c.type
        end || '" nullable="' || (CASE WHEN c."notnull"=1 THEN 'yes' ELSE 'no' END) || '"/>'
    from
        sqlite_master m inner join pragma_table_info(m.name) c
    where 
        m.type='table'

    union
    select 5, m.name, 0, '</Fields>'
    from
        sqlite_master m
    inner join pragma_table_info(m.name)
    where 
        m.type='table'
    union
    select 6,  m.name, 0, '</Table>'
    from
        sqlite_master m
    where 
        m.type='table'
    union
    select 999, 'xxx', 0, '</Database>'
) db
order by db.tbl, db.sort, db.col


