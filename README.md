#Overview of backup_restore

backup_restore works between supported RDBMS:es (at least in theory :-)

## Backing up a MySQL and restoring it to PostgreSQL!

- . /copydb.sh mysql://root.Pa$$w0rd/f1db psql://postgres.Pa$$w0rd/f1db

### Extract a database definition from a MySQL database:

- mysql -u root -p'Pa$$w0rd' -D f1db -N < mysql/exportdefinition.sql > output/f1db.xml

### Generate a database creation script for PostgreSQL:

- xsltproc createtables.xslt test.xml > test.psql

### Create an empty destination database in PostgreSQL

- psql -U postgres -p Pa$$w0rd -e "CREATE DATABASE f1db"

### Run the database creation script

- psql -U postgres -p Pass$w0rd -d f1db < test.psql

### Create a shell script that exports the MySQL tables:

- xsltproc --stringparam u root --stringparam p 'Pa$$w0rd' mysql/export.xslt output/employees.xml > output/export.sh

### Run the shell script

- . ./export.sh

### Create a SQL script that imports all tables at once:

- xsltproc psql/import.xslt output/test.xml > output/import.psql

### Perform the import:

- psql -U postgres -d thedb < import.psql

### Apply all contraints

## Congratulations, you have migrated a MySQL database to PostgreSQL!

