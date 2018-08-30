<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:param name="dbname" select="'f1db'"/>
    <xsl:param name="sP" select="'psql'"/>
    <xsl:param name="su" select="'postgres'"/>
    <xsl:param name="sp" select="'Pa$$w0rd'"/>
    <xsl:param name="dP" select="'sqlite'"/>
    <xsl:param name="du" select="'postgres'"/>
    <xsl:param name="dp" select="'Pa$$w0rd'"/>
    <xsl:output method="text"/>
    <xsl:template match="/">
#!/bin/sh

        <xsl:if test="$sP='psql'">
psql -U <xsl:value-of select="$su"/> -t &lt; psql/exportdefinition.sql &gt;output/<xsl:value-of select="$dbname"/>_temp.xml
. ./removetrailingspaces.sh output/<xsl:value-of select="$dbname"/>_temp.xml output/<xsl:value-of select="$dbname"/>.xml
xsltproc --stringparam u <xsl:value-of select="$su"/> --stringparam p $'<xsl:value-of select="$sp"/>' psql/export.xslt output/<xsl:value-of select="$dbname"/>.xml &gt; output/export.sql
psql -U <xsl:value-of select="$su"/> &lt; output/export.sql
        </xsl:if>

        <xsl:if test="$sP='mysql'">
mysql -u <xsl:value-of select="$su"/> -p'<xsl:value-of select="$sp"/>' -D <xsl:value-of select="$dbname"/> -N &lt; mysql/exportdefinition.sql &gt;output/<xsl:value-of select="$dbname"/>
xsltproc --stringparam u <xsl:value-of select="$su"/> --stringparam p $'<xsl:value-of select="$sp"/>' mysql/export.xslt output/<xsl:value-of select="$dbname"/>.xml &gt; output/export.sh
. output/export.sh
        </xsl:if>

        <xsl:if test="$sP='mssql'">
sqlcmd -d <xsl:value-of select="$dbname"/> -U <xsl:value-of select="$su"/> -P <xsl:value-of select="$sp"/> -h -1 -i mssql/exportdefinition.sql &gt;output/<xsl:value-of select="$dbname"/>.xml
xsltproc --stringparam u <xsl:value-of select="$su"/> --stringparam p $'<xsl:value-of select="$sp"/>' mssql/export.xslt output/<xsl:value-of select="$dbname"/>.xml &gt; output/export.sh
. output/export.sh
        </xsl:if>

        <xsl:if test="$dP='psql'">
psql -a -b -U postgres -W -c 'create database <xsl:value-of select="$dbname"/>'
xsltproc psql/createtables.xslt output/<xsl:value-of select="$dbname"/>.xml &gt; output/createtables.sql
psql -a -b -U postgres -W -d <xsl:value-of select="$dbname"/> &lt; output/createtables.sql
xsltproc --stringparam -u postgres --stringparam p $'Pa$$w0rd' psql/import.xslt output/<xsl:value-of select="$dbname"/>.xml &gt; output/import.sh
. output/import.sh
xsltproc psql/applyconstraints.xslt output/<xsl:value-of select="$dbname"/>.xml &gt; output/applyconstraints.sql
psql -a -b -U postgres -W -d <xsl:value-of select="$dbname"/> &lt; output/applyconstraints.sql
        </xsl:if>

        <xsl:if test="$dP='sqlite'">
xsltproc psql/createtables.xslt output/<xsl:value-of select="$dbname"/>.xml &gt; output/createtables.sql
sqlite3 output/<xsl:value-of select="$dbname"/>.db &lt; output/createtables.sql
xsltproc sqlite/import.xslt output/<xsl:value-of select="$dbname"/>.xml &gt; output/import.sql
sqlite3 output/<xsl:value-of select="$dbname"/>.db &lt; output/import.sql
xsltproc sqlite/applyconstraints.xslt output/<xsl:value-of select="$dbname"/>.xml &gt; output/applyconstraints.sql
sqlite3 output/<xsl:value-of select="$dbname"/>.db &lt; output/applyconstraints.sql
        </xsl:if>

        <xsl:if test="$dP='mssql'">
sqlcmd -U <xsl:value-of select="$du"/> -P <xsl:value-of select="$dp"/> -q "create database <xsl:value-of select="$dbname"/>"
xsltproc psql/createtables.xslt output/<xsl:value-of select="$dbname"/>.xml &gt; output/createtables.sql
sqlcmd -d <xsl:value-of select="$dbname"/> -U <xsl:value-of select="$du"/> -P <xsl:value-of select="$dp"/> -i output/createtables.sql
xsltproc mssql/import.xslt output/<xsl:value-of select="$dbname"/>.xml &gt; output/import.sh
. output/import.sh
xsltproc psql/applyconstraints.xslt output/<xsl:value-of select="$dbname"/>.xml &gt; output/applyconstraints.sql
sqlcmd -d <xsl:value-of select="$dbname"/> -U <xsl:value-of select="$du"/> -P <xsl:value-of select="$dp"/> -i output/applyconstraints.sql
        </xsl:if>

    </xsl:template>
</xsl:stylesheet>
