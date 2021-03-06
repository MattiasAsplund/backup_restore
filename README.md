# Overview of backup_restore

My goal in writing backup_restore is to learn about different database servers and to make it simple to transfer data between them.

One aspect that I like about backup_restore, is that most of it is written
in declarative languages (XML/XSLT/SQL) which makes it easy to inspect
and modify without having to load up a complex development environment.

backup_restore will work at least on MSSQL/Sqlite/MySQL/MariaDB/PostgreSQL with possibly more to follow.

## Dependencies

Each database server comes with a set of client tools. Those tools
are needed by the scripts that are generated by __backup-restore__.

__xsltproc__ is needed for transforming the configuration files
into SQL/shell scripts. It can be a bit challenging to get it working on
Windows. Not so on Linux or Mac I presume.

## Backing up and restoring between any of MSSQL/Sqlite/MySQL/PostgreSQL

- Create a configuration file (see samples folder)

- xsltproc --xincludestyle copydb.xslt configfile.xml > \copydb.cmd

- output\copydb.cmd

## Example: Backup/Restore Chinook between MSSQL and Sqlite from Windows

- Install Chinook on MSSQL (https://github.com/lerocha/chinook-database/tree/master/ChinookDatabase/DataSources)

- Generate a Windows shell script that performs the copy: __xsltproc --xincludestyle copydb.xslt samples/cmd_chinook_mssql_sqlite.xml > c:\Dev\Temp\copydb.cmd__

- Execute the Script: __c:\Dev\Temp\copydb.cmd__

## Congratulations, you have migrated a database between two RDBMS:es!
