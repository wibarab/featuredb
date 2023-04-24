<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:utils="https://id.acdh.oeaw.ac.at/ns/xslt-utils"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:wib="https://wibarab.acdh.oeaw.ac.at/langDesc"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:include href="https://gist.githubusercontent.com/dasch124/07b5c3bbfb0d79f531b2942304fd07f2/raw/9215fd3b7a67cd7b43652ed5f8f2650a49957995/expandPrivateURIScheme.xsl"/>
    
    <xsl:variable name="listPrefixDef" select="//tei:listPrefixDef"/>
    
    <xsl:template match="/" mode="#default">
        <xsl:apply-templates mode="#current"/>
    </xsl:template>
    
    <xsl:template match="node() | @*" mode="#all">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="wib:featureValueObservation" mode="#default">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="expand"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:function name="utils:getReferencedContent">
        <xsl:param name="idRef"/>
        <xsl:variable name="target" select="utils:expandPrivatePrefix($idRef, $listPrefixDef)"/>
        <xsl:variable name="isLocalID" select="matches($idRef,'^#')"/>
        <xsl:variable name="targetResolves" select="if ($isLocalID) then exists(root($idRef)//*[@xml:id = substring-after($idRef,'#')]) else if (matches($idRef,'^(http|https)')) then true() else doc-available(resolve-uri($target, base-uri($idRef)))"/>
        <xsl:choose>
            <xsl:when test="not($targetResolves)">
                <xsl:message>cannot resolve pointer "<xsl:value-of select="$target"/>"</xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="referencedNode" select="if ($isLocalID) then root($idRef)//*[@xml:id = substring-after($idRef,'#')] else if (matches($idRef,'^(http|https)')) then $idRef else doc(resolve-uri($target, base-uri($idRef)))" as="node()+"/>
                <xsl:sequence select="$referencedNode"/>
            </xsl:otherwise>
        </xsl:choose>
                
    </xsl:function>
    
    <xsl:template match="tei:name[@type = 'featureValue']" mode="expand">
        <xsl:variable name="content" select="utils:getReferencedContent(@ref)"/>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:sequence select="$content/*"/>
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="tei:bibl[@corresp]" mode="expand">
        <xsl:variable name="content" select="utils:getReferencedContent(@corresp)"/>
        <xsl:choose>
            <xsl:when test="exists($content)">
                <xsl:sequence select="$content"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:comment>ZOTERO ITEM NOT FOUND</xsl:comment>
                <xsl:sequence select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
    