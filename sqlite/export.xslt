<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text"/>
    <xsl:param name="tempFolder"/>
    <xsl:template match="/">
.mode tabs
        <xsl:apply-templates select="//Table"/>
    </xsl:template>
    <xsl:template match="Table">
.output <xsl:value-of select="$tempFolder"/><xsl:value-of select="@name"/>.csv
SELECT * FROM  <xsl:value-of select="./@name"/>;
    </xsl:template>
</xsl:stylesheet>
