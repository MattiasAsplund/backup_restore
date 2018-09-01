<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:param name="d"/>
    <xsl:param name="i"/>
    <xsl:param name="u"/>
    <xsl:param name="p"/>
    <xsl:output method="text"/>
    <xsl:template match="/">
        <xsl:apply-templates select="//Table"/>
    </xsl:template>
    <xsl:template match="Table">
        <xsl:choose>
            <xsl:when test="i='yes'">
bcp <xsl:value-of select="@name"/> out csvexport/<xsl:value-of select="@name"/>.csv -E -d <xsl:value-of select="$d"/> -c -t "\t"
            </xsl:when>
            <xsl:otherwise>
bcp <xsl:value-of select="@name"/> out csvexport/<xsl:value-of select="@name"/>.csv -U sa -P 'Pa$$w0rd' -d <xsl:value-of select="$d"/> -c -t "\t"
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
