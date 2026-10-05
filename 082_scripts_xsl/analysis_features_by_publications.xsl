<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:wib="https://wibarab.acdh.oeaw.ac.at/langDesc" 
    xmlns:tei="http://www.tei-c.org/ns/1.0" 
    exclude-result-prefixes="xs math"
    version="3.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:param name="path-to-featuredb">file:/home/danielschopper/data/WIBARAB/featuredb/010_manannot/features/</xsl:param>
    <xsl:template match="/">
        <xsl:comment select="current-dateTime()"/>
        <biblSources>
            <xsl:variable name="bibls" as="element(bibl)+">
                <xsl:for-each-group select="collection($path-to-featuredb||'?format=xml')//wib:featureValueObservation[tei:bibl/@type='publication']" group-by="tei:bibl/@corresp">
                    <xsl:variable name="fvos" select="current-group()" as="element(wib:featureValueObservation)+"/>
                    <bibl>
                        <xsl:variable name="features" as="item()*">
                            <xsl:for-each-group select="current-group()" group-by="base-uri(.)">
                                <feature doc="{current-grouping-key()}" cnt="{count(current-group())}"/>
                            </xsl:for-each-group>
                        </xsl:variable>
                        <xsl:attribute name="id" select="current-grouping-key()"/>
                        <xsl:attribute name="features" select="count($features)"/>
                        <xsl:attribute name="fvos" select="count($fvos)"/>
                    </bibl>
                </xsl:for-each-group>
            </xsl:variable>
            <xsl:for-each select="$bibls">
                <xsl:sort select="@features" order="descending" data-type="number"/>
                <xsl:sequence select="."/>
            </xsl:for-each>
        </biblSources>
    </xsl:template>
</xsl:stylesheet>