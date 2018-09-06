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

        <x xmlns:xi="http://www.w3.org/2001/XInclude">
            <xi:include href="psql/copydb_export.xml"/>
            <xi:include href="mysql/copydb_export.xml"/>
            <xi:include href="mssql/copydb_export.xml"/>
            <xi:include href="sqlite/copydb_export.xml"/>
            <xi:include href="psql/copydb_import.xml"/>
            <xi:include href="mysql/copydb_import.xml"/>
            <xi:include href="mssql/copydb_import.xml"/>
            <xi:include href="sqlite/copydb_import.xml"/>
        </x>
    </xsl:template>
    <xsl:template xmlns:xsl="http://www.w3.org/1999/XSL/Transform" name="string-replace-all">
        <xsl:param name="text" />
        <xsl:param name="replace" />
        <xsl:param name="by" />
        <x xmlns:xi="http://www.w3.org/2001/XInclude">
            <xi:include href="string-replace-all.xml"/>
        </x>
    </xsl:template>
</xsl:stylesheet>
