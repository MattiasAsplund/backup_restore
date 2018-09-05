<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:param name="shell" select="//settings/@shell"/>
    <xsl:param name="tempFolder" select="//settings/@tempFolder"/>
    <xsl:param name="sP" select="//settings/copySettings/source/provider/text()"/>
    <xsl:param name="sD" select="//settings/copySettings/source/database/text()"/>
    <xsl:param name="sI" select="//settings/copySettings/source/integratedSecurity/text()"/>
    <xsl:param name="su" select="//settings/copySettings/source/user/text()"/>
    <xsl:param name="sp" select="//settings/copySettings/source/password/text()"/>
    <xsl:param name="sDir" select="//settings/copySettings/source/directory/text()"/>
    <xsl:param name="dP" select="//settings/copySettings/destination/provider/text()"/>
    <xsl:param name="dD" select="//settings/copySettings/destination/database/text()"/>
    <xsl:param name="dI" select="//settings/copySettings/destination/integratedSecurity/text()"/>
    <xsl:param name="du" select="//settings/copySettings/destination/user/text()"/>
    <xsl:param name="dp" select="//settings/copySettings/destination/password/text()"/>
    <xsl:param name="dDir" select="//settings/copySettings/destination/directory/text()"/>
    <xsl:param name="bcpPath" select="//settings/bcp/@path"/>
    <xsl:param name="sqlitePath" select="//settings/sqlite/@path"/>
    <xsl:variable name="varMysqlPath" select="//settings/mysql/@path"/>
    <xsl:variable name="bashTempFolder">
        <xsl:call-template name="string-replace-all">
            <xsl:with-param name="text" select="$tempFolder" />
            <xsl:with-param name="replace" select="'\'" />
            <xsl:with-param name="by" select="'/'" />
        </xsl:call-template>
    </xsl:variable>
    <xsl:output method="text"/>
    <xsl:template match="/">
        <xsl:if test="$shell='bash'">
#!/bin/sh
        </xsl:if>

        <xsl:if test="$sP='psql'">
&quot;<xsl:value-of select="//psql/@path"/>&quot; -U <xsl:value-of select="$su"/> -d <xsl:value-of select="$dbname"/> -t &lt; psql/exportdefinition.sql &gt;<xsl:value-of select="$tempFolder"/><xsl:value-of select="$dbname"/>_temp.xml
            <xsl:if test="$shell='cmd'">
removetrailingspaces.cmd <xsl:value-of select="$tempFolder"/><xsl:value-of select="$sD"/>_temp.xml <xsl:value-of select="$tempFolder"/><xsl:value-of select="$dbname"/>.xml
            </xsl:if>
            <xsl:if test="$shell='bash'">
. ./removetrailingspaces.sh <xsl:value-of select="$tempFolder"/><xsl:value-of select="$sD"/>_temp.xml <xsl:value-of select="$tempFolder"/><xsl:value-of select="$dbname"/>.xml
            </xsl:if>
xsltproc --stringparam tempFolder <xsl:value-of select="$tempFolder"/> --stringparam u <xsl:value-of select="$su"/> --stringparam p $'<xsl:value-of select="$sp"/>' psql/export.xslt <xsl:value-of select="$tempFolder"/><xsl:value-of select="$dbname"/>.xml &gt; <xsl:value-of select="$tempFolder"/>export.sql
&quot;<xsl:value-of select="//psql/@path"/>&quot; -U <xsl:value-of select="$su"/> &lt; <xsl:value-of select="$tempFolder"/>export.sql
        </xsl:if>

        <xsl:if test="$sP='mysql'">
&quot;<xsl:value-of select="//mysql/@path"/>&quot; -u <xsl:value-of select="$su"/> -p'<xsl:value-of select="$sp"/>' -D <xsl:value-of select="$sD"/> -N &lt; mysql/exportdefinition.sql &gt;<xsl:value-of select="$tempFolder"/><xsl:value-of select="$sD"/>.xml
                <xsl:if test="$shell='bash'">
xsltproc --stringparam tempFolder '<xsl:value-of select="$tempFolder"/>' --stringparam u '<xsl:value-of select="$su"/>' --stringparam p '<xsl:value-of select="$sp"/>' --stringparam d '<xsl:value-of select="$sD"/>' --stringparam mysqlPath '<xsl:value-of select="$varMysqlPath"/>' --stringparam sedPath '<xsl:value-of select="//sed/@path"/>' mysql/export.xslt <xsl:value-of select="$tempFolder"/><xsl:value-of select="$sD"/>.xml &gt; <xsl:value-of select="$tempFolder"/>export.sh
. <xsl:value-of select="$tempFolder"/>export.sh
                </xsl:if>
                <xsl:if test="$shell='cmd'">
xsltproc --stringparam tempFolder "<xsl:value-of select="$tempFolder"/>" --stringparam u "<xsl:value-of select="$su"/>" --stringparam p "<xsl:value-of select="$sp"/>" --stringparam d '<xsl:value-of select="$sD"/>' --stringparam mysqlPath "<xsl:value-of select="$varMysqlPath"/>" --stringparam sedPath "<xsl:value-of select="//sed/@path"/>" mysql/export.xslt <xsl:value-of select="$tempFolder"/><xsl:value-of select="$sD"/>.xml &gt; <xsl:value-of select="$tempFolder"/>export.cmd
@CALL <xsl:value-of select="$tempFolder"/>export.cmd
                </xsl:if>
        </xsl:if>

        <xsl:if test="$sP='mssql'">
            <xsl:choose>
                <xsl:when test="$sI='yes'">
&quot;<xsl:value-of select="//sqlcmd/@path"/>&quot; -d <xsl:value-of select="$sD"/> -E -h -1 -i mssql/exportdefinition.sql &gt;<xsl:value-of select="$tempFolder"/><xsl:value-of select="$sD"/>.xml
                </xsl:when>
                <xsl:otherwise>
&quot;<xsl:value-of select="//sqlcmd/@path"/>&quot; -d <xsl:value-of select="$sD"/> -U <xsl:value-of select="$su"/> -P <xsl:value-of select="$sp"/> -h -1 -i mssql/exportdefinition.sql &gt;<xsl:value-of select="$tempFolder"/><xsl:value-of select="$dbname"/>.xml
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="$shell='cmd'">
xsltproc --stringparam bcpPath "<xsl:value-of select="$bcpPath"/>" --stringparam tempFolder "<xsl:value-of select="$tempFolder"/>" --stringparam i <xsl:value-of select="$sI"/> --stringparam u "<xsl:value-of select="$su"/>" --stringparam p "<xsl:value-of select="$sp"/>" --stringparam d "<xsl:value-of select="$sD"/>" mssql/export.xslt <xsl:value-of select="$tempFolder"/><xsl:value-of select="$sD"/>.xml &gt; <xsl:value-of select="$tempFolder"/>export.cmd
@CALL <xsl:value-of select="$tempFolder"/>export.cmd
            </xsl:if>
            <xsl:if test="$shell='bash'">
xsltproc --stringparam bcpPath "<xsl:value-of select="$bcpPath"/>" --stringparam i "<xsl:value-of select="$sI"/>" --stringparam u <xsl:value-of select="$su"/> --stringparam p $'<xsl:value-of select="$sp"/>' --stringparam d $'<xsl:value-of select="$sD"/>' mssql/export.xslt <xsl:value-of select="$tempFolder"/><xsl:value-of select="$sD"/>.xml &gt; <xsl:value-of select="$tempFolder"/>export.sh
. <xsl:value-of select="$tempFolder"/>export.sh
            </xsl:if>
        </xsl:if>

        <xsl:if test="$sP='sqlite'">
&quot;<xsl:value-of select="//sqlite/@path"/>&quot; <xsl:value-of select="$sDir"/><xsl:value-of select="$sD"/> &lt; sqlite/exportdefinition.sql &gt; <xsl:value-of select="$tempFolder"/><xsl:value-of select="$sD"/>.xml
            <xsl:if test="$shell='cmd'">
xsltproc --stringparam tempFolder <xsl:value-of select="$bashTempFolder"/> --path <xsl:value-of select="$tempFolder"/> sqlite\export.xslt <xsl:value-of select="$sD"/>.xml &gt; <xsl:value-of select="$tempFolder"/>export.sql
&quot;<xsl:value-of select="//sqlite/@path"/>&quot; <xsl:value-of select="$sDir"/><xsl:value-of select="$sD"/> &lt; <xsl:value-of select="$tempFolder"/>export.sql
            </xsl:if>
            <xsl:if test="$shell='bash'">
xsltproc --path <xsl:value-of select="$tempFolder"/> --stringparam tempFolder "<xsl:value-of select="$tempFolder"/>" --stringparam sqlitePath "<xsl:value-of select="$sqlitePath"/>" --stringparam i "<xsl:value-of select="$sI"/>" --stringparam u <xsl:value-of select="$su"/> --stringparam p $'<xsl:value-of select="$sp"/>' --stringparam d $'<xsl:value-of select="$sD"/>' mssql/export.xslt <xsl:value-of select="$tempFolder"/><xsl:value-of select="$sD"/>.xml &gt; <xsl:value-of select="$tempFolder"/>export.sh
&quot;<xsl:value-of select="//sqlite/@path"/>&quot; <xsl:value-of select="$sDir"/><xsl:value-of select="$sD"/> &lt; <xsl:value-of select="$tempFolder"/>export.sql
            </xsl:if>
        </xsl:if>

        <xsl:if test="$dP='psql'">
xsltproc psql/createtables.xslt <xsl:value-of select="$tempFolder"/><xsl:value-of select="$sD"/>.xml &gt; <xsl:value-of select="$tempFolder"/>createtables.sql
&quot;<xsl:value-of select="//psql/@path"/>&quot; -a -b -U postgres -W -d <xsl:value-of select="$dD"/> &lt; <xsl:value-of select="$tempFolder"/>createtables.sql
xsltproc --stringparam tempFolder <xsl:value-of select="$tempFolder"/> --stringparam dD <xsl:value-of select="$dD"/> --stringparam -u <xsl:value-of select="$du"/> --stringparam p $'<xsl:value-of select="$dp"/>' psql/import.xslt <xsl:value-of select="$tempFolder"/><xsl:value-of select="$sD"/>.xml &gt; <xsl:value-of select="$tempFolder"/>import.sh
. <xsl:value-of select="$tempFolder"/>import.sh
xsltproc psql/applyconstraints.xslt <xsl:value-of select="$tempFolder"/><xsl:value-of select="$sD"/>.xml &gt; <xsl:value-of select="$tempFolder"/>applyconstraints.sql
&quot;<xsl:value-of select="//psql/@path"/>&quot; -a -b -U postgres -W -d <xsl:value-of select="$dD"/> &lt; <xsl:value-of select="$tempFolder"/>applyconstraints.sql
        </xsl:if>

        <xsl:if test="$dP='sqlite'">
                <xsl:if test="$shell='bash'">
xsltproc psql/createtables.xslt <xsl:value-of select="$tempFolder"/><xsl:value-of select="$sD"/>.xml &gt; <xsl:value-of select="$tempFolder"/>createtables.sql
&quot;<xsl:value-of select="//sqlite/@path"/>&quot;  <xsl:value-of select="$dDir"/><xsl:value-of select="$dD"/> &lt; <xsl:value-of select="$tempFolder"/>createtables.sql
xsltproc --stringparam tempFolder <xsl:value-of select="$tempFolder"/> sqlite/import.xslt <xsl:value-of select="$tempFolder"/><xsl:value-of select="$sD"/>.xml &gt; <xsl:value-of select="$tempFolder"/>import.sql
&quot;<xsl:value-of select="//sqlite/@path"/>&quot;  <xsl:value-of select="$dDir"/><xsl:value-of select="$dD"/> &lt; <xsl:value-of select="$tempFolder"/>import.sql
xsltproc --stringparam tempFolder "<xsl:value-of select="$tempFolder"/>" sqlite/applyconstraints.xslt <xsl:value-of select="$tempFolder"/><xsl:value-of select="$sD"/>.xml &gt; <xsl:value-of select="$tempFolder"/>applyconstraints.sql
&quot;<xsl:value-of select="//sqlite/@path"/>&quot;  <xsl:value-of select="$dDir"/><xsl:value-of select="$dD"/> &lt; <xsl:value-of select="$tempFolder"/>applyconstraints.sql
                </xsl:if>
                <xsl:if test="$shell='cmd'">
xsltproc psql/createtables.xslt <xsl:value-of select="$tempFolder"/><xsl:value-of select="$sD"/>.xml &gt; <xsl:value-of select="$tempFolder"/>createtables.sql
&quot;<xsl:value-of select="//sqlite/@path"/>&quot;  <xsl:value-of select="$dDir"/><xsl:value-of select="$dD"/> &lt; <xsl:value-of select="$tempFolder"/>createtables.sql
xsltproc --stringparam tempFolder <xsl:value-of select="$bashTempFolder"/> sqlite/import.xslt <xsl:value-of select="$tempFolder"/><xsl:value-of select="$sD"/>.xml &gt; <xsl:value-of select="$tempFolder"/>import.sql
&quot;<xsl:value-of select="//sqlite/@path"/>&quot;  <xsl:value-of select="$dDir"/><xsl:value-of select="$dD"/> &lt; <xsl:value-of select="$tempFolder"/>import.sql
xsltproc --stringparam tempFolder "<xsl:value-of select="$tempFolder"/>" sqlite/applyconstraints.xslt <xsl:value-of select="$tempFolder"/><xsl:value-of select="$sD"/>.xml &gt; <xsl:value-of select="$tempFolder"/>applyconstraints.sql
&quot;<xsl:value-of select="//sqlite/@path"/>&quot;  <xsl:value-of select="$dDir"/><xsl:value-of select="$dD"/> &lt; <xsl:value-of select="$tempFolder"/>applyconstraints.sql
                </xsl:if>
        </xsl:if>

        <xsl:if test="$dP='mssql'">
                <xsl:choose>
                        <xsl:when test="$dI='yes'">
sqlcmd -E <xsl:value-of select="$dp"/> -q "create database <xsl:value-of select="$dD"/>"
xsltproc psql/createtables.xslt <xsl:value-of select="$tempFolder"/><xsl:value-of select="$dD"/>.xml &gt; <xsl:value-of select="$tempFolder"/>createtables.sql
sqlcmd -d <xsl:value-of select="$dD"/> -E -i <xsl:value-of select="$tempFolder"/>createtables.sql
xsltproc mssql/import.xslt <xsl:value-of select="$tempFolder"/><xsl:value-of select="$dD"/>.xml &gt; <xsl:value-of select="$tempFolder"/>import.sh
. <xsl:value-of select="$tempFolder"/>import.sh
xsltproc psql/applyconstraints.xslt <xsl:value-of select="$tempFolder"/><xsl:value-of select="$dD"/>.xml &gt; <xsl:value-of select="$tempFolder"/>applyconstraints.sql
sqlcmd -d <xsl:value-of select="$dD"/> -E -i <xsl:value-of select="$tempFolder"/>applyconstraints.sql
                        </xsl:when>
                        <xsl:otherwise>
sqlcmd -U <xsl:value-of select="$du"/> -P <xsl:value-of select="$dp"/> -q "create database <xsl:value-of select="$dbname"/>"
xsltproc psql/createtables.xslt <xsl:value-of select="$tempFolder"/><xsl:value-of select="$dD"/>.xml &gt; <xsl:value-of select="$tempFolder"/>createtables.sql
sqlcmd -d <xsl:value-of select="$dD"/> -U <xsl:value-of select="$du"/> -P <xsl:value-of select="$dp"/> -i <xsl:value-of select="$tempFolder"/>createtables.sql
xsltproc mssql/import.xslt <xsl:value-of select="$tempFolder"/><xsl:value-of select="$dD"/>.xml &gt; <xsl:value-of select="$tempFolder"/>import.sh
. <xsl:value-of select="$tempFolder"/>import.sh
xsltproc psql/applyconstraints.xslt <xsl:value-of select="$tempFolder"/><xsl:value-of select="$dD"/>.xml &gt; <xsl:value-of select="$tempFolder"/>applyconstraints.sql
sqlcmd -d <xsl:value-of select="$dD"/> -U <xsl:value-of select="$du"/> -P <xsl:value-of select="$dp"/> -i <xsl:value-of select="$tempFolder"/>applyconstraints.sql
                        </xsl:otherwise>
                </xsl:choose>
        </xsl:if>

      <xsl:if test="$dP='mysql'">
xsltproc psql/createtables.xslt <xsl:value-of select="$tempFolder"/><xsl:value-of select="$sD"/>.xml &gt; <xsl:value-of select="$tempFolder"/>createtables.sql
&quot;<xsl:value-of select="//mysql/@path"/>&quot; -u <xsl:value-of select="$su"/> -p'<xsl:value-of select="$sp"/>' -D <xsl:value-of select="$dD"/> &lt; <xsl:value-of select="$tempFolder"/>createtables.sql
xsltproc --stringparam tempFolder <xsl:value-of select="$tempFolder"/> --stringparam mysqlPath '"<xsl:value-of select="$varMysqlPath"/>"' mysql/import.xslt <xsl:value-of select="$tempFolder"/><xsl:value-of select="$sD"/>.xml &gt; <xsl:value-of select="$tempFolder"/>import.sql
&quot;<xsl:value-of select="//mysql/@path"/>&quot; -u <xsl:value-of select="$su"/> -p'<xsl:value-of select="$sp"/>' -D <xsl:value-of select="$dD"/> &lt; <xsl:value-of select="$tempFolder"/>import.sql
xsltproc mysql/applyconstraints.xslt <xsl:value-of select="$tempFolder"/><xsl:value-of select="$sD"/>.xml &gt; <xsl:value-of select="$tempFolder"/>applyconstraints.sql
&quot;<xsl:value-of select="//mysql/@path"/>&quot; -u <xsl:value-of select="$su"/> -p'<xsl:value-of select="$sp"/>' -D <xsl:value-of select="$dD"/> &lt; <xsl:value-of select="$tempFolder"/>applyconstraints.sql
        </xsl:if>
    </xsl:template>

        <xsl:template name="string-replace-all">
        <xsl:param name="text" />
        <xsl:param name="replace" />
        <xsl:param name="by" />
        <xsl:choose>
        <xsl:when test="contains($text, $replace)">
        <xsl:value-of select="substring-before($text,$replace)" />
        <xsl:value-of select="$by" />
        <xsl:call-template name="string-replace-all">
                <xsl:with-param name="text" select="substring-after($text,$replace)" />
                <xsl:with-param name="replace" select="$replace" />
                <xsl:with-param name="by" select="$by" />
        </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
        <xsl:value-of select="$text" />
        </xsl:otherwise>
        </xsl:choose>
        </xsl:template>
</xsl:stylesheet>
