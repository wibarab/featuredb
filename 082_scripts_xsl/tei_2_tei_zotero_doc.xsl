<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="tei xs">
    
    <!-- Identity template to copy everything by default -->
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Template to transform note[type='tag'] elements with content starting with 'doc:' -->
    <xsl:template match="tei:note[@type='tag'][starts-with(normalize-space(.), 'doc:')]">
        <xsl:variable name="docContent" select="substring-after(normalize-space(.), 'doc:')"/>
        <xsl:variable name="decade" select="substring-before($docContent, 's')"/>
        <xsl:variable name="decadeInt" select="xs:integer($decade)"/>
        <xsl:variable name="notBefore" select="concat($decade, '-01-01')"/>
        <xsl:variable name="notAfter" select="concat($decadeInt + 9, '-12-31')"/>
        <xsl:variable name="parent" select="parent::*"/>
        <xsl:variable name="certContent" select="$parent/tei:note[@type='tag'][starts-with(normalize-space(.), 'dcert:')][1]/text()"/>
        
        <note type="dataCollection">
            <date type="dataCollection">
                <xsl:attribute name="cert">
                    <xsl:value-of select="substring-after(normalize-space($certContent), 'dcert:')"/>
                </xsl:attribute>
                <xsl:attribute name="notBefore-iso">
                    <xsl:value-of select="$notBefore"/>
                </xsl:attribute>
                <xsl:attribute name="notAfter-iso">
                    <xsl:value-of select="$notAfter"/>
                </xsl:attribute>
                <xsl:value-of select="$docContent"/>
            </date>
        </note>
    </xsl:template>
    
    <!-- Template to remove note[type='tag'][starts-with(normalize-space(.), 'dcert:')] elements -->
    <xsl:template match="tei:note[@type='tag'][starts-with(normalize-space(.), 'dcert:')]"/>
    
</xsl:stylesheet>
