<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text"/>
    <xsl:template match="/">
        <xsl:apply-templates select="//Table"/>
    </xsl:template>
    <xsl:template match="Table">
psql -h localhost -p 5432 -d employees -U postgres -W -c "\copy <xsl:value-of select="@name"/> from csvexport/<xsl:value-of select="@name"/>.csv with delimiter E'\t' null as 'NULL'" 
    </xsl:template>
</xsl:stylesheet>
