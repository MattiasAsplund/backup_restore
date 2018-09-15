<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text"/>
    <xsl:template match="/">
        <xsl:apply-templates select="//Table"/>
    </xsl:template>
    <xsl:template match="Table">
        CREATE TABLE "<xsl:value-of select="@schema"/>"."<xsl:value-of select="@name"/>" (
            <xsl:for-each select="Fields/Field">
                "<xsl:value-of select="@name"/>"<xsl:text> </xsl:text><xsl:apply-templates select="."/><xsl:if test="position() != last()">,</xsl:if>
            </xsl:for-each>
        );
    </xsl:template>
    <xsl:template match="Field">
        <xsl:choose>
            <xsl:when test="(@type='nvarchar' or @type='varchar') and @length='-1'">text</xsl:when>
            <xsl:when test="@type='nvarchar'">varchar</xsl:when>
            <xsl:when test="@type='datetime'">timestamp</xsl:when>
            <xsl:when test="@type='tinyint'">int</xsl:when>
            <xsl:when test="@type='uniqueidentifier'">uuid</xsl:when>
            <xsl:when test="@type='hierarchyid'">varchar</xsl:when>
            <xsl:when test="@type='smallmoney'">money</xsl:when>
            <xsl:when test="@type='varbinary'">bytea</xsl:when>
            <xsl:otherwise><xsl:value-of select="@type"/></xsl:otherwise>
        </xsl:choose>
        <xsl:if test="@length != '' and @length != '-1'">
            (
                <xsl:value-of select="@length"/>
            )
        </xsl:if>
        <xsl:if test="@nullable='no'"> NOT NULL</xsl:if><xsl:text>&#xa;</xsl:text>
    </xsl:template>
</xsl:stylesheet>
