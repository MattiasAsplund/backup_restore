<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:param name="u"/>
    <xsl:param name="p"/>
    <xsl:param name="tempFolder"/>
    <xsl:param name="dD"/>
    <xsl:output method="text"/>
    <xsl:template match="/">
        <xsl:apply-templates select="//Table"/>
    </xsl:template>
    <xsl:template match="Table">
\copy <xsl:value-of select="@schema"/>.<xsl:value-of select="@name"/> from '<xsl:value-of select="$tempFolder"/><xsl:value-of select="@schema"/>.<xsl:value-of select="@name"/>.csv' with encoding 'iso88591' delimiter E'\t' null as ''
    </xsl:template>
</xsl:stylesheet>
