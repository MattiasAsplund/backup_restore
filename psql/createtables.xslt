<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text"/>
    <xsl:template match="/">
        <xsl:apply-templates select="//Table"/>
    </xsl:template>
    <xsl:template match="Table">
        CREATE TABLE <xsl:value-of select="@schema"/>.<xsl:value-of select="@name"/> (
            <xsl:for-each select="Fields/Field">
                <xsl:value-of select="@name"/><xsl:text> </xsl:text><xsl:apply-templates select="."/><xsl:if test="position() != last()">,</xsl:if>
            </xsl:for-each>
        );
    </xsl:template>
    <xsl:template match="Field">
<xsl:value-of select="@type"/> <xsl:if test="@length">(<xsl:value-of select="@length"/>)</xsl:if>
<xsl:if test="@nullable='no'"> NOT NULL</xsl:if><xsl:text>&#xa;</xsl:text>
    </xsl:template>
</xsl:stylesheet>
