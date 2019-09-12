<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="text"/>
    <xsl:template match="/">
        <xsl:for-each select="//Table">
            <xsl:variable name="pkSchema" select="@schema"/>
            <xsl:variable name="pkTable" select="@name"/>
        alter table "<xsl:value-of select="$pkSchema"/>"."<xsl:value-of select="$pkTable"/>" add primary key (
                <xsl:for-each select="PrimaryKey/Field">
                    "<xsl:value-of select="@name"/>"<xsl:if test="position() != last()">,</xsl:if>
                </xsl:for-each>
            );
        </xsl:for-each>
        <xsl:for-each select="//Table">
            <xsl:for-each select="./Indexes/Index">
                create index <xsl:value-of select="@name"/> on <xsl:value-of select="../../@name"/>(
                <xsl:for-each select="./Field">
                    <xsl:value-of select="@name"/><xsl:if test="position() != last()">,</xsl:if>
                </xsl:for-each>
                );
            </xsl:for-each>
        </xsl:for-each>
        <xsl:for-each select="//Table">
            <xsl:variable name="pkSchema" select="@schema"/>
            <xsl:variable name="pkTable" select="@name"/>
            <xsl:for-each select=".//ForeignKey">
        alter table "<xsl:value-of select="$pkSchema"/>"."<xsl:value-of select="$pkTable"/>" add constraint "<xsl:value-of select="@name"/>" foreign key("<xsl:value-of select="@column"/>")
references "<xsl:value-of select="@referencedSchema"/>"."<xsl:value-of select="@referencedTable"/>" ("<xsl:value-of select="@referencedColumn"/>");
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
