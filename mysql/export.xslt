<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:param name="u"/>
    <xsl:param name="p"/>
    <xsl:param name="d"/>
    <xsl:param name="mysqlPath"/>
    <xsl:param name="sedPath"/>
    <xsl:output method="text"/>
    <xsl:variable name="varMysqlPath" select="$mysqlPath"/>
    <xsl:template match="/">
        <xsl:apply-templates select="//Table"/>
    </xsl:template>
    <xsl:template match="Table">
&quot;<xsl:value-of select="$varMysqlPath"/>&quot; -B -u <xsl:value-of select="$u"/> -p'<xsl:value-of select="$p"/>' -D <xsl:value-of select="$d"/> <xsl:value-of select="//source/database/text()"/> -N -e "SELECT * FROM <xsl:value-of select="@name"/>;" > <xsl:value-of select="$tempFolder"/><xsl:value-of select="@name"/>.csv | &quot;<xsl:value-of select="$sedPath"/>&quot; "s/'/\'/;s/\t/\",\"/g;s/^/\"/;s/$/\"/;s/\n//g"
    </xsl:template>
</xsl:stylesheet>
