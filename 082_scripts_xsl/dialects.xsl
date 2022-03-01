<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:_="urn:wibarab"
    exclude-result-prefixes="#all"
    version="2.0">
    <xsl:output indent="yes"/>
    <xsl:function name="_:heading-by-position" as="xs:string">
        <xsl:param name="headingRow" as="element(tei:row)"/>
        <xsl:param name="position" as="xs:integer"/>
        <xsl:value-of select="$headingRow/replace(tei:cell[$position],'(^\s+|\s+$|&#xa0;)','')"/>
    </xsl:function>
    
    <xsl:template match="/">
        <xsl:variable name="pass1">
            <xsl:apply-templates/>
        </xsl:variable>
        <xsl:apply-templates select="$pass1" mode="pass2"/>
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
        <xsl:copy>WIBARAB dialects + sources</xsl:copy>
    </xsl:template>
    
    <xsl:template match="node() | @*" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="tei:table[not(tei:head = ('_Dialects', 'Sources'))]"/>
    
    <xsl:template match="tei:table[tei:head = ('_Dialects', 'Sources')]">
        <xsl:variable name="headingRow" select="tei:row[1]" as="element(tei:row)"/>
        <div>
            <head>WIBARAB <xsl:value-of select="tei:head"/></head>
            <p>This fvLib contains a list of all <xsl:value-of select="lower-case(tei:head)"/>s investigated in the WIBARAB project.</p>
            <fvLib><xsl:apply-templates select="tei:row[position() gt 1]">
                <xsl:with-param name="headingRow" select="$headingRow" tunnel="yes"/>
                <xsl:with-param name="tableName" select="tei:head" tunnel="yes"/>
            </xsl:apply-templates></fvLib>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:row">
        <xsl:param name="headingRow" tunnel="yes" as="element(tei:row)"/>
        <xsl:param name="tableName" tunnel="yes"/>
        <xsl:variable name="f" as="element(tei:f)*">
            <xsl:apply-templates/>
        </xsl:variable>
        <xsl:variable name="type" select="if ($tableName = '_Dialects') then 'dialect' else if ($tableName = 'Sources') then 'source' else '???'"/>
        <xsl:if test="not(every $string in $f//tei:string satisfies $string = '')">
            <fs type="{$type}"><xsl:sequence select="$f[tei:string !='']"></xsl:sequence></fs>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:cell">
        <xsl:param name="headingRow" tunnel="yes" as="element(tei:row)"/>
        <xsl:variable name="p" select="count(preceding-sibling::tei:cell)+1"/>
        <xsl:variable name="h" select="_:heading-by-position($headingRow, $p)"/>
        <xsl:variable name="name">
            <xsl:choose>
                <xsl:when test="normalize-space($h) != ''">
                    <xsl:value-of select="replace($h,'\s+','')"/>
                </xsl:when>
                <xsl:otherwise>note</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <f name="{$name}"><string><xsl:value-of select="normalize-space(.)"/></string></f>
    </xsl:template>
    
    
    <xsl:template match="tei:fs[every $f in tei:f[@name = ('DialectID','SourceID')] satisfies $f = ('', 'ERROR NO ID')]" mode="pass2"/>
    
    <xsl:template match="tei:fs[some $f in tei:f[@name = ('DialectID','SourceID')] satisfies not($f = ('', 'ERROR NO ID'))]" mode="pass2">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="xml:id" select="tei:f[@name = ('DialectID','SourceID')][. != '']"/>
            <xsl:apply-templates mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:f[@name = ('DialectID', 'Country', 'TypeofLocus', 'SourceID')]" mode="pass2"/>
        
    <xsl:template match="tei:f[@name = 'ZoteroID']" mode="pass2">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="fVal" select="concat('zot:',tei:string)"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="tei:f[@name = 'Place']" mode="pass2">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="fVal" select="concat('geo:',tei:string)"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:f[@name = ('TypeOfCommunity', 'PersonInCharge')]/tei:string" mode="pass2">
        <symbol value="{replace(.,'\s+','_')}"/>
    </xsl:template>
    
</xsl:stylesheet>