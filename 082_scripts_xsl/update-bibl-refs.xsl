<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:utils="https://id.acdh.oeaw.ac.at/ns/xslt-utils"
    xmlns="http://www.tei-c.org/ns/1.0"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:w="https://wibarab.acdh.oeaw.ac.at/langDesc"
    exclude-result-prefixes="w tei utils xs xsl"
    version="2.0">
    <!--<xsl:include href="https://gist.githubusercontent.com/dasch124/07b5c3bbfb0d79f531b2942304fd07f2/raw/9215fd3b7a67cd7b43652ed5f8f2650a49957995/expandPrivateURIScheme.xsl"/>
    <xsl:function name="utils:getReferencedContent">
        <xsl:param name="idRef"/>
        <xsl:param name="listPrefixDef"/>
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
    -->
    <xsl:param name="pathToBibliography">file:/home/dschopper/data/WIBARAB/featuredb/010_manannot/vicav_biblio_tei_zotero.xml</xsl:param>
    <xsl:variable name="bibliography" select="document($pathToBibliography)"/>
    
    <!--<xsl:variable name="listPrefixDef" select="//tei:listPrefixDef"/>-->
    <xsl:template match="tei:revisionDesc">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates/>
            <change when="{current-date()}" who="dmp:DS">updating references to Zotero IDs via update-bibl-refs.xsl</change>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:bibl[@type='publication'][parent::w:featureValueObservation]/@corresp[. != '' or . != 'zot:']">
        <xsl:variable name="ref" select="substring-after(.,':')"/>
        <xsl:variable name="entry" select="$bibliography//tei:biblStruct[@n = $ref]"/>
        <xsl:variable name="newID" select="$entry/@xml:id"/>
        <xsl:if test="$newID = ''">
            <xsl:message terminate="yes">Could not determine new ID for entry <xsl:value-of select="$entry/@corresp"/></xsl:message>
        </xsl:if>
        <xsl:attribute name="{name(current())}">
            <xsl:value-of select="concat('zot:',$newID)"/>
        </xsl:attribute>
    </xsl:template>
    
    
</xsl:stylesheet>