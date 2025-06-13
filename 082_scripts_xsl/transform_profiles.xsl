<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                exclude-result-prefixes="tei xs"
                xmlns="http://www.tei-c.org/ns/1.0"
                version="3.0">
    <xsl:output method="xml"
                indent="yes" />
    <xsl:variable name="geolist"
                  select="document('../010_manannot/vicav_geodata.xml')" />
    <xsl:variable name="persGrpList"
                  select="document('../010_manannot/wibarab_PersonGroup.xml')" />
    <!-- Remove empty divs coming from templates -->
    <xsl:template match="tei:div[not(node()[normalize-space()])]" />
    <!-- Identity transform -->
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" />
        </xsl:copy>
    </xsl:template>
    <xsl:template match="tei:teiHeader">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each select="node()">
                <xsl:choose>
                    <xsl:when test="self::tei:encodingDesc">
                        <xsl:apply-templates select="." />
                        <!-- Insert profileDesc after encodingDesc -->
                        <profileDesc>
                            <langUsage>
                                <language>
                                    <name type="languageVariety">
                                        <xsl:variable name="title"
                                                      select="/tei:TEI/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title" />
                                        <xsl:value-of select="normalize-space(replace($title, '.*profile of', ''))" />
                                    </name>
                                    <!-- even though it says name type="place", it can be a tribe name -->
                                    <xsl:variable name="placeOrTribeName"
                                                  select="//tei:body/tei:div/tei:head/tei:name[@type = 'place']" />
                                    <!-- Try to match a place in the geolist -->
                                    <xsl:variable name="geoEntry"
                                                  select="$geolist//tei:listPlace/tei:place[some $n in tei:placeName satisfies normalize-space($n) = normalize-space($placeOrTribeName)]" />
                                    <!-- Try to match a tribe in the personGrpList -->
                                    <xsl:variable name="tribeEntryByName"
                                                  select="$persGrpList//tei:personGrp[@role='tribe'][normalize-space(tei:name) = normalize-space($placeOrTribeName)]" />
                                    <!-- If place found, get geoRef and try to find tribe by residence -->
                                    <xsl:variable name="geoRef"
                                                  select="if ($geoEntry) then concat('geo:', $geoEntry/@xml:id) else $tribeEntryByName/tei:residence/tei:placeName/@ref" />
                                    <xsl:variable name="tribeEntry"
                                                  select="if ($tribeEntryByName) then $tribeEntryByName else $persGrpList//tei:personGrp[@role='tribe'][tei:residence/tei:placeName/@ref = $geoRef]" />
                                    <place sameAs="{$geoRef}" />
                                    <date type="languagePeriod">
                                        <note>Contemporary</note>
                                    </date>
                                    <xsl:if test="$tribeEntry">
                                        <personGrp role="tribe"
                                                   corresp="pgr:{$tribeEntry/@xml:id}" />
                                    </xsl:if>
                                    <channel mode="spoken" />
                                    <xsl:if test="not($geoEntry) and not($tribeEntry)">
                                        <xsl:comment>No match for place or tribe: <xsl:value-of select="$placeOrTribeName" />
                                    </xsl:comment>
                                </xsl:if>
                            </language>
                        </langUsage>
                    </profileDesc>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="." />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:copy>
</xsl:template>
<xsl:template match="tei:revisionDesc">
    <xsl:copy>
        <xsl:apply-templates select="node() | @*" />
        <change when="{current-date()}"
                who="dmp:KS">Transformed to Lex-0</change>
    </xsl:copy>
</xsl:template>
<xsl:template match="tei:div/tei:head">
    <xsl:copy>
        <xsl:apply-templates select="tei:figure" />
    </xsl:copy>
</xsl:template>
</xsl:stylesheet>