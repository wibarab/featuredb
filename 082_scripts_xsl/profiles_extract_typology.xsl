<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="#all"
    version="2.0">
    <xsl:param name="path-to-profiles-dir"/>
    <xsl:output method="text"/>
    <xsl:template match="/">
        <xsl:variable name="xml" as="element()">
            <profiles>
                <xsl:for-each select="collection($path-to-profiles-dir)">
                    <xsl:sort select="document-uri()"/>
                    <xsl:variable name="fn" select="tokenize(document-uri(.),'/')[last()]"/>
                    <xsl:variable name="typology" select="//tei:p[@rend = 'typology']"/>
                    <xsl:variable name="classification" select="$typology/@ana"/>
                    <profile>
                        <filename><xsl:value-of select="$fn"/></filename>
                        <classification>
                            <xsl:choose>
                                <xsl:when test="$classification != ''">
                                    <xsl:value-of select="$classification"/>
                                </xsl:when>
                                <xsl:when test="matches($typology,'[bB]edouin')">bedouin</xsl:when>
                                <xsl:when test="matches($typology,'[sS]edentary')">sedentary</xsl:when>
                                <xsl:when test="matches($typology,'[mM]ixed')">mixed</xsl:when>
                                <xsl:otherwise/>
                            </xsl:choose>
                        </classification>
                        <typology><xsl:value-of select="$typology"/></typology>
                    </profile>
                </xsl:for-each>
            </profiles>
        </xsl:variable>
        
        <xsl:call-template name="xml2csv">
            <xsl:with-param name="xml" select="$xml/profile" as="element()+"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="xml2csv">
        <xsl:param name="xml" as="element()+"/>
        <xsl:variable name="noOfColumns" select="count($xml[1]/*)"/>
        <xsl:for-each select="1 to $noOfColumns">
            <xsl:variable name="columnNo" select="xs:integer(.)"/>
            <xsl:text>"</xsl:text>
            <xsl:value-of select="local-name($xml[1]/*[position() eq $columnNo])"/>
            <xsl:text>"</xsl:text>
            <xsl:choose>
                <xsl:when test=". eq $noOfColumns">
                    <xsl:text>&#10;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#9;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:for-each select="$xml">
            <xsl:variable name="line" select="."/>
            <xsl:for-each select="1 to $noOfColumns">
                <xsl:variable name="columnNo" select="xs:integer(.)"/>
                <xsl:text>"</xsl:text>
                <xsl:value-of select="$line/*[position() eq $columnNo]"/>
                <xsl:text>"</xsl:text>
                <xsl:choose>
                    <xsl:when test=". eq $noOfColumns">
                        <xsl:text>&#10;</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>&#9;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>