<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:w="https://wibarab.acdh.oeaw.ac.at/langDesc"
    exclude-result-prefixes="#all"
    version="2.0">
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>re-orders the content of fvo elements to fit the schema</desc>
    </doc>
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="w:featureValueObservation">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:copy-of select="tei:name"/>
            <xsl:copy-of select="tei:bibl"/>
            <xsl:copy-of select="tei:placeName"/>
            <xsl:copy-of select="tei:lang"/>
            <xsl:copy-of select="tei:date"/>
            <xsl:copy-of select="tei:personGrp"/>
            <xsl:copy-of select="tei:cit"/>
            <xsl:copy-of select="tei:note"/>
            <xsl:copy-of select="*[not(self::tei:name|self::tei:bibl|self::tei:placeName|self::tei:lang|self::tei:date|self::personGrp|self::note)]"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>