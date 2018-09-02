<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:param name="u"/>
    <xsl:param name="p"/>
    <xsl:param name="mysqlPath"/>
    <xsl:param name="sedPath"/>
    <xsl:param name="tempFolder"/>
    <xsl:param name="tableName"/>
    <xsl:output method="text"/>
    <xsl:template match="/">
        <xsl:for-each select="//Table">
LOAD DATA INFILE '<xsl:value-of select="$tempFolder"/><xsl:value-of select="./@name"/>.csv'. INTO TABLE <xsl:value-of select="./@name"/> FIELDS TERMINATED BY '\t';
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
