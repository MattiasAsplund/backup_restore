<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text"/>
    <xsl:template match="/">
        <xsl:for-each select="//Table[not(@schema=preceding::Table/@schema)]">
            <xsl:if test="@schema != 'dbo'">
                CREATE SCHEMA [<xsl:value-of select="@schema" />]
                GO
            </xsl:if>
        </xsl:for-each>
        <xsl:apply-templates select="//Table"/>
    </xsl:template>
    <xsl:template match="Table">
        CREATE TABLE [<xsl:value-of select="@schema"/>].[<xsl:value-of select="@name"/>] (
            <xsl:for-each select="Fields/Field">
                [<xsl:value-of select="@name"/>]<xsl:text> </xsl:text><xsl:apply-templates select="."/><xsl:if test="position() != last()">,</xsl:if>
            </xsl:for-each>
        );
    </xsl:template>
    <xsl:template match="Field">
<xsl:value-of select="@type"/> 
    <!-- <xsl:choose>
        <xsl:when test="@type='varchar'"> (255)</xsl:when>
        <xsl:when test="@type='nvarchar'"> (255)</xsl:when>
        <xsl:when test="@type='numeric'"> (10,2)</xsl:when>
        <xsl:when test="@type='decimal'"> (10,2)</xsl:when>
        <xsl:when test="@type='char'"> (10)</xsl:when>
        <xsl:when test="@type='nchar'"> (10)</xsl:when>
    </xsl:choose> -->
    <xsl:choose>
        <xsl:when test="@type = 'hierarchyid'"></xsl:when>
        <xsl:when test="@type = 'xml'"></xsl:when>
        <xsl:when test="@type = 'int'"></xsl:when>
        <xsl:when test="@type = 'smallint'"></xsl:when>
        <xsl:when test="@type = 'tinyint'"></xsl:when>
        <xsl:when test="@type = 'bigint'"></xsl:when>
        <xsl:when test="@type = 'image'"></xsl:when>
        <xsl:when test="@type = 'text'"></xsl:when>
        <xsl:when test="@type = 'ntext'"></xsl:when>
        <xsl:when test="@type = 'money'"></xsl:when>
        <xsl:when test="@type = 'smallmoney'"></xsl:when>
        <xsl:when test="@length = -1"> (max)</xsl:when>
        <xsl:when test="@precision != ''">(<xsl:value-of select="@precision"/>,<xsl:value-of select="@scale"/>)</xsl:when>
        <xsl:when test="@length != ''">(<xsl:value-of select="@length"/>)</xsl:when>
    </xsl:choose>
<xsl:if test="@nullable='no'"> NOT NULL</xsl:if><xsl:text>&#xa;</xsl:text>
    </xsl:template>
</xsl:stylesheet>
