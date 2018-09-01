#Overview of backup_restore

My goal in writing backup_restore is to learn more about database servers
and to make it simple to transfer data between different servers.

One aspect that I like about backup_restore, is that most of it is written
in declarative languages (XML/XSLT/SQL) which makes it easy to inspect
and modify without having to load up a complex development environment.

backup_restore will work at least on MSSQL/Sqlite/MySQL/MariaDB/PostgreSQL with possibly more to follow.

## Backing up and restoring between any of MSSQL/Sqlite/MySQL/PostgreSQL

- Create a configuration file (see samples folder)

- xsltproc copydb.xslt configfile.xml > \copydb.cmd

- output\copydb.cmd

## Congratulations, you have migrated a database between two RDBMS:es!
