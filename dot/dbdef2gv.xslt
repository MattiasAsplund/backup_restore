<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="text" omit-xml-declaration="yes" indent="no"/>
    <xsl:template match="/">
digraph G {
    page="8.5,11";
        <xsl:for-each select="//Table">
            <xsl:variable name="schema" select="@schema"/>
            <xsl:variable name="tableName" select="@name"/>
            <xsl:for-each select="./ForeignKeys/ForeignKey">
  "[<xsl:value-of select="$schema"/>].[<xsl:value-of select="$tableName"/>]" -> "[<xsl:value-of select="@referencedSchema"/>].[<xsl:value-of select="@referencedTable"/>]"
            </xsl:for-each>
        </xsl:for-each>
}
    </xsl:template>
</xsl:stylesheet>
