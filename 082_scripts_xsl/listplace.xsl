<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xpath-default-namespace="http://www.tei-c.org/ns/1.0"
                xmlns="http://www.tei-c.org/ns/1.0"
                exclude-result-prefixes="xs"
                version="3.0">
    <xsl:output method="xml"
                indent="yes" />
    <xsl:output method="xml"
                indent="yes" />
    <xsl:mode on-no-match="shallow-copy" />
    <!-- Template to wrap place elements in listPlace -->
    <xsl:template match="language">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each select="node()">
                <xsl:choose>
                    <xsl:when test="self::place and not(preceding-sibling::place)">
                        <listPlace>
                            <xsl:apply-templates select="../place" />
                        </listPlace>
                    </xsl:when>
                    <xsl:when test="self::place">
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="." />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>