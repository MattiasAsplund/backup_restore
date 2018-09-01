<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:param name="shell" select="//settings/@shell"/>
    <xsl:param name="sP" select="//settings/copySettings/source/provider/text()"/>
    <xsl:param name="sD" select="//settings/copySettings/source/database/text()"/>
    <xsl:param name="sI" select="//settings/copySettings/source/integratedSecurity/text()"/>
    <xsl:param name="su" select="//settings/copySettings/source/user/text()"/>
    <xsl:param name="sp" select="//settings/copySettings/source/password/text()"/>
    <xsl:param name="dP" select="//settings/copySettings/destination/provider/text()"/>
    <xsl:param name="dD" select="//settings/copySettings/destination/database/text()"/>
    <xsl:param name="dI" select="//settings/copySettings/destination/integratedSecurity/text()"/>
    <xsl:param name="du" select="//settings/copySettings/destination/user/text()"/>
    <xsl:param name="dp" select="//settings/copySettings/destination/password/text()"/>
    <xsl:param name="bcpPath" select="//settings/bcp/@path"/>
    <xsl:output method="text"/>
    <xsl:template match="/">
        <xsl:if test="$shell='bash'">
#!/bin/sh
        </xsl:if>

        <xsl:if test="$sP='psql'">
&quot;<xsl:value-of select="//psql/@path"/>&quot; -U <xsl:value-of select="$su"/> -d <xsl:value-of select="$dbname"/> -t &lt; psql/exportdefinition.sql &gt;output/<xsl:value-of select="$dbname"/>_temp.xml
            <xsl:if test="$shell='cmd'">
removetrailingspaces.cmd output\<xsl:value-of select="$sD"/>_temp.xml output\<xsl:value-of select="$dbname"/>.xml
            </xsl:if>
            <xsl:if test="$shell='bash'">
. ./removetrailingspaces.sh output/<xsl:value-of select="$sD"/>_temp.xml output/<xsl:value-of select="$dbname"/>.xml
            </xsl:if>
xsltproc --stringparam u <xsl:value-of select="$su"/> --stringparam p $'<xsl:value-of select="$sp"/>' psql/export.xslt output/<xsl:value-of select="$dbname"/>.xml &gt; output/export.sql
&quot;<xsl:value-of select="//psql/@path"/>&quot; -U <xsl:value-of select="$su"/> &lt; output/export.sql
        </xsl:if>

        <xsl:if test="$sP='mysql'">
&quot;<xsl:value-of select="//mysql/@path"/>&quot; -u <xsl:value-of select="$su"/> -p<xsl:value-of select="$sp"/> -D <xsl:value-of select="$sD"/> -N &lt; mysql/exportdefinition.sql &gt;output/<xsl:value-of select="$sD"/>.xml
                <xsl:if test="$shell='bash'">
xsltproc --stringparam i <xsl:value-of select="$sI"/> --stringparam u <xsl:value-of select="$su"/> --stringparam p '<xsl:value-of select="$sp"/>' --stringparam mysqlPath '<xsl:value-of select="//mysql/@path"/>' --stringparam sedPath '<xsl:value-of select="//sed/@path"/>' mysql/export.xslt output/<xsl:value-of select="$sD"/>.xml &gt; output/export.sh
. output/export.sh
                </xsl:if>
                <xsl:if test="$shell='cmd'">
xsltproc --stringparam i <xsl:value-of select="$sI"/> --stringparam u <xsl:value-of select="$su"/> --stringparam p "<xsl:value-of select="$sp"/>" --stringparam mysqlPath "<xsl:value-of select="//mysql/@path"/>" --stringparam sedPath "<xsl:value-of select="//sed/@path"/>" mysql/export.xslt output/<xsl:value-of select="$sD"/>.xml &gt; output/export.cmd
@CALL output\export.cmd
                </xsl:if>
        </xsl:if>

        <xsl:if test="$sP='mssql'">
            <xsl:choose>
                <xsl:when test="$sI='yes'">
&quot;<xsl:value-of select="//sqlcmd/@path"/>&quot; -d <xsl:value-of select="$sD"/> -E -h -1 -i mssql/exportdefinition.sql &gt;output/<xsl:value-of select="$sD"/>.xml
                </xsl:when>
                <xsl:otherwise>
&quot;<xsl:value-of select="//sqlcmd/@path"/>&quot; -d <xsl:value-of select="$sD"/> -U <xsl:value-of select="$su"/> -P <xsl:value-of select="$sp"/> -h -1 -i mssql/exportdefinition.sql &gt;output/<xsl:value-of select="$dbname"/>.xml
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="$shell='cmd'">
xsltproc --stringparam bcpPath "<xsl:value-of select="$bcpPath"/>" --stringparam i <xsl:value-of select="$sI"/> --stringparam u "<xsl:value-of select="$su"/>" --stringparam p "<xsl:value-of select="$sp"/>" --stringparam d "<xsl:value-of select="$sD"/>" mssql/export.xslt output/<xsl:value-of select="$sD"/>.xml &gt; output/export.cmd
@CALL output\export.cmd
            </xsl:if>
            <xsl:if test="$shell='bash'">
xsltproc --stringparam bcpPath "<xsl:value-of select="$bcpPath"/>" --stringparam i "<xsl:value-of select="$sI"/>" --stringparam u <xsl:value-of select="$su"/> --stringparam p $'<xsl:value-of select="$sp"/>' --stringparam d $'<xsl:value-of select="$sD"/>' mssql/export.xslt output/<xsl:value-of select="$sD"/>.xml &gt; output/export.sh
. output/export.sh
            </xsl:if>
        </xsl:if>

        <xsl:if test="$dP='psql'">
&quot;<xsl:value-of select="//psql/@path"/>&quot; -a -b -U postgres -W -c 'create database <xsl:value-of select="$dbname"/>'
xsltproc psql/createtables.xslt output/<xsl:value-of select="$dbname"/>.xml &gt; output/createtables.sql
&quot;<xsl:value-of select="//psql/@path"/>&quot; -a -b -U postgres -W -d <xsl:value-of select="$dbname"/> &lt; output/createtables.sql
xsltproc --stringparam -u postgres --stringparam p $'Pa$$w0rd' psql/import.xslt output/<xsl:value-of select="$dbname"/>.xml &gt; output/import.sh
. output/import.sh
xsltproc psql/applyconstraints.xslt output/<xsl:value-of select="$sD"/>.xml &gt; output/applyconstraints.sql
&quot;<xsl:value-of select="//psql/@path"/>&quot; -a -b -U postgres -W -d <xsl:value-of select="$dbname"/> &lt; output/applyconstraints.sql
        </xsl:if>

        <xsl:if test="$dP='sqlite'">
xsltproc psql/createtables.xslt output/<xsl:value-of select="$sD"/>.xml &gt; output/createtables.sql
sqlite3 <xsl:value-of select="$dD"/> &lt; output/createtables.sql
xsltproc sqlite/import.xslt output/<xsl:value-of select="$sD"/>.xml &gt; output/import.sql
sqlite3 <xsl:value-of select="$dD"/> &lt; output/import.sql
xsltproc sqlite/applyconstraints.xslt output/<xsl:value-of select="$sD"/>.xml &gt; output/applyconstraints.sql
sqlite3 <xsl:value-of select="$dD"/> &lt; output/applyconstraints.sql
        </xsl:if>

        <xsl:if test="$dP='mssql'">
                <xsl:choose>
                        <xsl:when test="$dI='yes'">
sqlcmd -E <xsl:value-of select="$dp"/> -q "create database <xsl:value-of select="$dD"/>"
xsltproc psql/createtables.xslt output/<xsl:value-of select="$dD"/>.xml &gt; output/createtables.sql
sqlcmd -d <xsl:value-of select="$dD"/> -E -i output/createtables.sql
xsltproc mssql/import.xslt output/<xsl:value-of select="$dD"/>.xml &gt; output/import.sh
. output/import.sh
xsltproc psql/applyconstraints.xslt output/<xsl:value-of select="$dD"/>.xml &gt; output/applyconstraints.sql
sqlcmd -d <xsl:value-of select="$dD"/> -E -i output/applyconstraints.sql
                        </xsl:when>
                        <xsl:otherwise>
sqlcmd -U <xsl:value-of select="$du"/> -P <xsl:value-of select="$dp"/> -q "create database <xsl:value-of select="$dbname"/>"
xsltproc psql/createtables.xslt output/<xsl:value-of select="$dD"/>.xml &gt; output/createtables.sql
sqlcmd -d <xsl:value-of select="$dD"/> -U <xsl:value-of select="$du"/> -P <xsl:value-of select="$dp"/> -i output/createtables.sql
xsltproc mssql/import.xslt output/<xsl:value-of select="$dD"/>.xml &gt; output/import.sh
. output/import.sh
xsltproc psql/applyconstraints.xslt output/<xsl:value-of select="$dD"/>.xml &gt; output/applyconstraints.sql
sqlcmd -d <xsl:value-of select="$dD"/> -U <xsl:value-of select="$du"/> -P <xsl:value-of select="$dp"/> -i output/applyconstraints.sql
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:if>

    </xsl:template>
</xsl:stylesheet>
