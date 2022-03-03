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
        <xsl:variable name="pass1">
            <xsl:apply-templates select="//tei:table[tei:head = '_Dialects']"/>
        </xsl:variable>
        <xsl:variable name="pass2">
            <xsl:apply-templates select="$pass1" mode="pass2"/>
        </xsl:variable>
        <xsl:sequence select="$pass2"/>
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
        <xsl:copy>WIBARAB list of dialects</xsl:copy>
    </xsl:template>
    
    <xsl:template match="node() | @*" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="tei:table[not(tei:head = '_Dialects')]"/>
    
    <xsl:template match="tei:table[tei:head = '_Dialects']">
        <xsl:variable name="headingRow" select="tei:row[1]" as="element(tei:row)"/>
       <TEI>
            <xsl:apply-templates select="root()//tei:teiHeader"/>
            <text>
                <body>
                    <head>WIBARAB list of dialects</head>
                    <p>This is a list of all dialects investigated in the WIBARAB project.</p>
                    <fvLib xml:id="dialects">
                        <xsl:apply-templates select="tei:row[position() gt 1]">
                            <xsl:with-param name="headingRow" select="$headingRow" tunnel="yes"/>
                            <xsl:with-param name="tableName" select="tei:head" tunnel="yes"/>
                        </xsl:apply-templates>
                    </fvLib>
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
        
        <xsl:if test="not(every $string in $f//tei:string satisfies $string = '')">
            <fs type="dialect"><xsl:sequence select="$f[tei:string !='']"/></fs>
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
    
    
    <xsl:template match="tei:fs[every $f in tei:f[@name = ('dialectID','sourceID')] satisfies $f = ('', 'ERROR NO ID')]" mode="pass2" priority="1"/>
    
    <xsl:template match="tei:fs[some $f in tei:f[@name = ('dialectID','sourceID')] satisfies not($f = ('', 'ERROR NO ID'))]" mode="pass2" priority="1">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="xml:id" select="tei:f[@name = ('dialectID','sourceID')][. != '']"/>
            <xsl:apply-templates mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:f[@name = ('dialectID', 'country', 'typeofLocus', 'sourceID')]" mode="pass2"/>
        
     
    <xsl:template match="tei:f[@name = 'place']" mode="pass2">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="fVal" select="concat('geo:',tei:string)"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:f[@name = 'typeOfCommunity']/tei:string" mode="pass2">
        <symbol value="{replace(.,'\s+','_')}"/>
    </xsl:template>
    
    
    <xsl:template match="tei:f[@name = 'typeofLocus']/tei:string" mode="pass2">
        <symbol value="{_:lcc(replace(.,'\s+','_'))}"/>
    </xsl:template>
    
    <xsl:template match="tei:f[@name = 'personInCharge']" mode="pass2">
        <xsl:variable name="dmp" select="doc($pdu||'/102_derived_tei/wibarab_dmp.xml')"/>
        <xsl:variable name="person-in-dmp" select="$dmp//tei:person[contains(tei:persName,current())]"/>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="fVal" select="'dmp:'||$person-in-dmp/@xml:id"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:function name="_:lcc">
        <xsl:param name="s" as="xs:string"/>
        <xsl:value-of select="lower-case(substring($s,1,1))||substring($s,2)"/>
    </xsl:function>
    
</xsl:stylesheet>