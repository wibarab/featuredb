<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="tei">
    
    <!-- Output method set to XML with indentation -->
    <xsl:output method="xml" indent="yes" />
    
    <!-- Identity template to copy everything by default -->
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Template to process <bibl status="CHECKED"> elements, excluding comments -->
    <xsl:template match="tei:bibl[@status='CHECKED']">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()[not(self::comment())]"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
