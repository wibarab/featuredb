<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:_="urn:wibarab"
    exclude-result-prefixes="#all"
    version="2.0">
    <xsl:output indent="yes"/>
    
    <xsl:param name="pdu"/>
    <xsl:function name="_:heading-by-position" as="xs:string">
        <xsl:param name="headingRow" as="element(tei:row)"/>
        <xsl:param name="position" as="xs:integer"/>
        <xsl:value-of select="$headingRow/replace(tei:cell[$position],'(^\s+|\s+$|&#xa0;)','')"/>
    </xsl:function>
    
    <xsl:template match="/">
        <xsl:apply-templates select="//tei:table[tei:head = 'Sources']"/>
    </xsl:template>
    
    <xsl:template match="tei:fileDesc">
        <xsl:next-match/>
        <encodingDesc>
            <listPrefixDef>
                <prefixDef ident="dmp" matchPattern="^(.+)$" replacementPattern="wibarab-dmp.xml#$1"/>
                <prefixDef ident="zotid" matchPattern="^(.+)$" replacementPattern="vicav_biblio_tei_zotero.xml#$1"/>
                <prefixDef ident="dia" matchPattern="^(.+)$" replacementPattern="vicav_dialects.xml#$1"/>
                <prefixDef ident="geo" matchPattern="^(.+)$" replacementPattern="vicav_geodata.xml#$1"/>
            </listPrefixDef>
        </encodingDesc>
    </xsl:template>
    <xsl:template match="tei:sourceDesc/tei:p">
        <xsl:copy>See https://gitlab.com/acdh-oeaw/shawibarab/wibarab-featuredb/-/blob/main/001_src/001_01_dialect_list/README.md</xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:publicationStmt/tei:p">
        <xsl:copy>Yet unpublished working copy</xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:titleStmt">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
            <author><persName>Maria Rebecca Zarb</persName></author>
            <author><persName>Veronika Engler</persName></author>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:titleStmt/tei:author">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <persName><xsl:apply-templates/></persName>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:titleStmt/tei:title">
        <xsl:copy>WIBARAB list of sources</xsl:copy>
    </xsl:template>
    
    <xsl:template match="node() | @*" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    
    
    <xsl:template match="tei:table[tei:head = 'Sources']">
        <xsl:variable name="headingRow" select="tei:row[1]" as="element(tei:row)"/>
        <TEI>
            <xsl:apply-templates select="root()//tei:teiHeader"/>
            <text>
                <body>
                    <head>WIBARAB list of sources</head>
                    <p>This is a list of all sources used in the WIBARAB feature db.</p>
                    <list xml:id="sources">
                        <xsl:apply-templates select="tei:row[position() gt 1]">
                            <xsl:with-param name="headingRow" select="$headingRow" tunnel="yes"/>
                            <xsl:with-param name="tableName" select="tei:head" tunnel="yes"/>
                        </xsl:apply-templates>
                    </list>
                </body>
            </text>                    
        </TEI>
    </xsl:template>
    
    <xsl:template match="tei:row">
        <xsl:param name="headingRow" tunnel="yes" as="element(tei:row)"/>
        <xsl:param name="tableName" tunnel="yes"/>
        <xsl:variable name="f" as="element(tei:f)*">
            <xsl:apply-templates/>
        </xsl:variable>
        
        <xsl:if test="not(every $string in $f//tei:string satisfies $string = ('','ERROR NO ID'))">
            <item xml:id="{$f/self::tei:f[@name='sourceID']}">
                <xsl:if test="$f/self::tei:f[@name='sourceType'] = 'Publication'">
                    <bibl><xsl:value-of select="."/></bibl>
                </xsl:if>
                <xsl:sequence select="$f"></xsl:sequence>
            </item>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:cell">
        <xsl:param name="headingRow" tunnel="yes" as="element(tei:row)"/>
        <xsl:variable name="p" select="count(preceding-sibling::tei:cell)+1"/>
        <xsl:variable name="h" select="_:heading-by-position($headingRow, $p)"/> 
        <xsl:variable name="name">
            <xsl:choose>
                <xsl:when test="normalize-space($h) != ''">
                    <xsl:value-of select="_:lcc(replace($h,'[\s+&#160;]',''))"/>
                </xsl:when>
                <xsl:otherwise>note</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <f name="{$name}"><string><xsl:value-of select="replace(normalize-space(.),'&#160;','')"/></string></f>
    </xsl:template>
    <xsl:function name="_:lcc">
        <xsl:param name="s" as="xs:string"/>
        <xsl:value-of select="lower-case(substring($s,1,1))||substring($s,2)"/>
    </xsl:function>
    
</xsl:stylesheet>