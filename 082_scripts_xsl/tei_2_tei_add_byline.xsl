<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="tei">

    <!-- Output method set to XML with indentation -->
    <xsl:output method="xml" indent="yes"/>
    
    <!-- Identity template: This template copies everything (elements, attributes, text, etc.) as-is -->
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Template to match <tei:div> with type="description" and add @resp and <byline> -->
    <xsl:template match="tei:div[@type='description']">
        <!-- Copy the <div> element -->
        <xsl:copy>
            <!-- Copy existing attributes -->
            <xsl:apply-templates select="@*"/>
            
            <!-- Add a new @resp attribute -->
            <xsl:attribute name="resp"></xsl:attribute>

            <!-- Add a <byline> element directly under the <div> -->
            <byline>Edited by [Name]</byline>
            
              <!-- Copy the contents of the <div> -->
            <xsl:apply-templates/>
            
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>

