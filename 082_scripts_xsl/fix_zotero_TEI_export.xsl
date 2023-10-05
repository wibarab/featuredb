<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:imprint">
        <xsl:copy-of select="."/>
        <xsl:copy-of select="../tei:extent"/>
    </xsl:template>
    <xsl:template match="tei:extent"/>
    
    <xsl:template match="tei:i|tei:b|tei:h2">
        <tei:hi rend="{local-name(.)}"><xsl:apply-templates/></tei:hi>
    </xsl:template>
    
    <xsl:template match="tei:span">
        <tei:hi>
            <xsl:apply-templates select="@*|node()"/>
        </tei:hi>
    </xsl:template>
    
    <xsl:template match="tei:span/@class">
        <xsl:attribute name="style" select="."/>
    </xsl:template>
    
    
</xsl:stylesheet>