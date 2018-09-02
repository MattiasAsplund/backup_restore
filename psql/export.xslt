<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text"/>
    <xsl:template match="/">
        <xsl:apply-templates select="//Table"/>
    </xsl:template>
    <xsl:template match="Table">
\copy <xsl:value-of select="@name"/> to '<xsl:value-of select="$tempFolder"/><xsl:value-of select="@name"/>.csv' delimiter E'\t' null as 'NULL';
    </xsl:template>
</xsl:stylesheet>
