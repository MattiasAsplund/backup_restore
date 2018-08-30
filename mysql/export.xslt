<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:param name="u"/>
    <xsl:param name="p"/>
    <xsl:output method="text"/>
    <xsl:template match="/">
        <xsl:apply-templates select="//Table"/>
    </xsl:template>
    <xsl:template match="Table">
mysql -B -u <xsl:value-of select="$u"/> -p'<xsl:value-of select="$p"/>' <xsl:value-of select="//Database/@name"/> -N -e "SELECT * FROM <xsl:value-of select="@name"/>;" > csvexport/<xsl:value-of select="@name"/>.csv \
 | sed "s/'/\'/;s/\t/\",\"/g;s/^/\"/;s/$/\"/;s/\n//g"
    </xsl:template>
</xsl:stylesheet>
