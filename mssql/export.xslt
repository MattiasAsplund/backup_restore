<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:param name="u"/>
    <xsl:param name="p"/>
    <xsl:output method="text"/>
    <xsl:template match="/">
        <xsl:apply-templates select="//Table"/>
    </xsl:template>
    <xsl:template match="Table">
bcp <xsl:value-of select="@name"/> out csvexport/<xsl:value-of select="@name"/>.csv -S localhost -U sa -P 'Pa$$w0rd' -d employees -c -t "\t"
    </xsl:template>
</xsl:stylesheet>
