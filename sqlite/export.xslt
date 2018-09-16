<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text"/>
    <xsl:param name="tempFolder"/>
    <xsl:template match="/">
.mode tabs
        <xsl:apply-templates select="//Table"/>
    </xsl:template>
    <xsl:template match="Table">
.output <xsl:value-of select="$tempFolder"/><xsl:value-of select="@schema"/>.<xsl:value-of select="@name"/>.csv
SELECT 
        <xsl:for-each select="Fields/Field">
            <xsl:if test="@nullable = 'yes'">
                IFNULL(
            </xsl:if>
            <xsl:choose>
                <xsl:when test="@type = 'float'">
                    REPLACE(CAST(<xsl:value-of select="@name"/> AS text), '.', ',')
                </xsl:when>
                <xsl:otherwise>
                    CAST(<xsl:value-of select="@name"/> AS text)
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="@nullable = 'yes'">
                , '')
            </xsl:if>
            <xsl:if test="position() != last()">, </xsl:if>
        </xsl:for-each>
FROM  <xsl:value-of select="./@name"/>;
    </xsl:template>
</xsl:stylesheet>
