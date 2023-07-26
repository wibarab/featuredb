<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs math t" version="3.0">
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:template match="t:monogr">
        <monogr>
            <xsl:apply-templates select="(./text())[1]"/>
            <xsl:for-each select="t:author">
                <author>
                    <xsl:apply-templates/>
                </author>
                <xsl:apply-templates select="(./following-sibling::text())[1]"/>
            </xsl:for-each>
            <xsl:for-each select="t:title">
                <title>
                    <xsl:apply-templates/>
                </title>
                <xsl:apply-templates select="(./following-sibling::text())[1]"/>
            </xsl:for-each>
            <xsl:for-each select="t:idno">
                <idno>
                    <xsl:apply-templates/>
                </idno>
                <xsl:apply-templates select="(./following-sibling::text())[1]"/>
            </xsl:for-each>
            <xsl:for-each select="t:imprint">
                <imprint>
                    <xsl:apply-templates/>
                </imprint>
                <xsl:apply-templates select="(./following-sibling::text())[1]"/>
            </xsl:for-each>
            <xsl:for-each select="t:extent">
                <extent>
                    <xsl:apply-templates/>
                </extent>
                <xsl:apply-templates select="(./following-sibling::text())[1]"/>
            </xsl:for-each>
        </monogr>
    </xsl:template>
</xsl:stylesheet>