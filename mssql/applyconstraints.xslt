<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text"/>
    <xsl:template match="/">
        set quoted_identifier on
        go

        <xsl:for-each select="//Table">
            alter table [<xsl:value-of select="@schema"/>].[<xsl:value-of select="@name"/>] add primary key (
                <xsl:for-each select="PrimaryKey/Field">
                    [<xsl:value-of select="@name"/>]<xsl:if test="position() != last()">,</xsl:if>
                </xsl:for-each>
            )
            go
        </xsl:for-each>
        <xsl:for-each select="//Table">
            <xsl:for-each select="./Indexes/Index">
                <xsl:choose>
                    <xsl:when test="@xml = 'yes'">
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO

                create primary xml index <xsl:value-of select="@name"/> on [<xsl:value-of select="../../@schema"/>].[<xsl:value-of select="../../@name"/>](
                    </xsl:when>
                    <xsl:otherwise>
                create <xsl:if test="@unique = 'yes'">unique</xsl:if> index <xsl:value-of select="@name"/> on [<xsl:value-of select="../../@schema"/>].[<xsl:value-of select="../../@name"/>](
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:for-each select="./Field[@included != 'yes']">
                    [<xsl:value-of select="@name"/>]<xsl:if test="position() != last()">,</xsl:if>
                </xsl:for-each>
                )
                go
            </xsl:for-each>
        </xsl:for-each>
        <xsl:for-each select="//Table">
            <xsl:variable name="pkSchema" select="@schema"/>
            <xsl:variable name="pkTable" select="@name"/>
            <xsl:for-each select=".//ForeignKey">
        ALTER TABLE [<xsl:value-of select="$pkSchema"/>].[<xsl:value-of select="$pkTable"/>]  WITH CHECK ADD  CONSTRAINT [<xsl:value-of select="@name"/>] FOREIGN KEY([<xsl:value-of select="@column"/>])
REFERENCES [<xsl:value-of select="@referencedSchema"/>].[<xsl:value-of select="@referencedTable"/>] ([<xsl:value-of select="@referencedColumn"/>])
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
