<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:w="https://wibarab.acdh.oeaw.ac.at/langDesc"
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:output indent="yes" method="xml"/>
    
    
    <doc xmlns="http://www.oxygenxml.com/ns/doc/xsl">
        <desc>re-orders the content of fvo elements to fit the schema</desc>
    </doc>
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
   <xsl:template match="w:featureValueObservation">
        <xsl:variable name="ordered" select="tei:name, tei:bibl, tei:placeName, tei:lang, tei:date, tei:personGrp, tei:cit, tei:note" as="element()*"/>
        <xsl:variable name="theRest" select="* except $ordered"/>
        <xsl:variable name="outerIndent" select="tokenize(preceding-sibling::text()[1],'&#10;')[last()]"/>
        <xsl:variable name="indent" select="translate(text()[1],'&#10;','')"/>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:text>&#10;</xsl:text>
            <xsl:copy-of select="$indent"/>
            <xsl:for-each select="$ordered, $theRest">
                <xsl:sequence select="."/>
                <xsl:text>&#10;</xsl:text>
                <xsl:if test="not(. is $ordered[last()])">
                     <xsl:copy-of select="$indent"/>
                </xsl:if>
            </xsl:for-each>
            <xsl:value-of select="$outerIndent"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
