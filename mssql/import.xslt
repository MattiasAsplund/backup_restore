<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:param name="s"/>
    <xsl:param name="d"/>
    <xsl:param name="i"/>
    <xsl:param name="u"/>
    <xsl:param name="p"/>
    <xsl:param name="shell" select="'cmd'"/>
    <xsl:param name="bcpPath"/>
    <xsl:param name="tempFolder"/>
    <xsl:output method="text"/>
    <xsl:template match="/">
        <xsl:apply-templates select="//Table"/>
    </xsl:template>
    <xsl:template match="Table">
        <xsl:choose>
            <xsl:when test="$i='yes'">
&quot;<xsl:value-of select="$bcpPath"/>&quot; <xsl:value-of select="@schema"/>.<xsl:value-of select="@name"/> in <xsl:value-of select="$tempFolder"/><xsl:value-of select="@schema"/>.<xsl:value-of select="@name"/>.csv -T -d <xsl:value-of select="$d"/> -c -t "\t" -r 0x0A
            </xsl:when>
            <xsl:otherwise>
&quot;<xsl:value-of select="$bcpPath"/>&quot; <xsl:value-of select="@schema"/>.<xsl:value-of select="@name"/> in <xsl:value-of select="$tempFolder"/><xsl:value-of select="@schema"/>.<xsl:value-of select="@name"/>.csv -U sa -P 'Pa$$w0rd' -d <xsl:value-of select="$d"/> -S <xsl:value-of select="$s"/> -c -t "\t" -r 0x0A
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
