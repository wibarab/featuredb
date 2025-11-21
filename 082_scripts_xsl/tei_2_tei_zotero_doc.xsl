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
    
    <!-- Template for elements that contain note[@type='tags'] with doc: notes -->
    <xsl:template match="*[tei:note[@type='tags'][tei:note[@type='tag'][starts-with(normalize-space(.), 'doc:')]]]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="node()"/>
            
            <!-- Add transformed doc: notes after all other content -->
            <xsl:for-each select="tei:note[@type='tags']/tei:note[@type='tag'][starts-with(normalize-space(.), 'doc:')]">
                <xsl:variable name="docContent" select="substring-after(normalize-space(.), 'doc:')"/>
                <xsl:variable name="decade" select="substring-before($docContent, 's')"/>
                <xsl:variable name="decadeInt" select="xs:integer($decade)"/>
                <xsl:variable name="notBefore" select="concat($decade, '-01-01')"/>
                <xsl:variable name="notAfter" select="concat($decadeInt + 9, '-12-31')"/>
                <xsl:variable name="certContent" select="../tei:note[@type='tag'][starts-with(normalize-space(.), 'dcert:')][1]/text()"/>
                
                <note type="dataCollection">
                    <date type="dataCollection">
                        <xsl:attribute name="cert">
                            <xsl:choose>
                                <xsl:when test="normalize-space(substring-after($certContent, 'dcert:')) != ''">
                                    <xsl:value-of select="normalize-space(substring-after($certContent, 'dcert:'))"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>unknown</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
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
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    
    <!-- Remove doc: and dcert: notes (and nothing remains note type="tags" itself) -->
    <xsl:template match="tei:note[@type='tags'][tei:note[@type='tag'][starts-with(normalize-space(.), 'doc:')]]">
        <xsl:variable name="otherTags" select="node()[not(self::tei:note[@type='tag'][starts-with(normalize-space(.), 'doc:') or starts-with(normalize-space(.), 'dcert:')])]"/>
        <xsl:if test="$otherTags">
            <xsl:copy>
                <xsl:apply-templates select="@*"/>
                <xsl:apply-templates select="$otherTags"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>