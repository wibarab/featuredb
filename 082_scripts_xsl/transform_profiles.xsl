<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs" version="3.0">
    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="profiles" as="document-node()+"
        select="collection('../profiles/?select=*.xml')"/>

    <xsl:variable name="geolist" select="document('../010_manannot/vicav_geodata.xml')"/>
    <xsl:variable name="persGrpList" select="document('../010_manannot/wibarab_PersonGroup.xml')"/>
    <xsl:variable name="fileId"
        select="replace(tokenize(document-uri(/), '/')[last()], '\.xml$', '')"/>
    <xsl:variable name="varietyCode"
        select="lower-case(replace(substring-after($fileId, 'vicav_profile_'), '-', ''))"/>
    <!-- Identity transform -->
    <xsl:mode on-no-match="shallow-copy"/>

    <xsl:template match="TEI/@xml:id">
        <xsl:attribute name="xml:id">
            <xsl:value-of select="$fileId"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template match="teiHeader">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates select="fileDesc"/>
            <xsl:apply-templates select="encodingDesc"/>

            <!-- Insert profileDesc after all existing content -->
            <profileDesc>
                <langUsage>
                    <language ident="{concat('ar-x-', $varietyCode)}">
                        <name type="languageVariety">
                            <xsl:variable name="title"
                                select="/TEI/teiHeader/fileDesc/titleStmt/title"/>
                            <xsl:value-of
                                select="normalize-space(replace($title, '.*profile of', ''))"/>
                        </name>
                        <xsl:variable name="placeOrTribeName"
                            select="//body/div/head/name[@type = 'place']"/>
                        <xsl:variable name="geoEntry" select="
                                ($geolist//listPlace/place[@type = 'geo'][some $n in placeName
                                    satisfies normalize-space($n) = normalize-space($placeOrTribeName)],
                                $geolist//listPlace/place[some $n in placeName
                                    satisfies normalize-space($n) = normalize-space($placeOrTribeName)])[1]"/>
                        <xsl:variable name="tribeEntryByName"
                            select="$persGrpList//personGrp[@role = 'tribe'][normalize-space(name) = normalize-space($placeOrTribeName)]"/>
                        <xsl:variable name="geoRef" select="
                                if ($geoEntry) then
                                    concat('geo:', $geoEntry[1]/@xml:id)
                                else
                                    $tribeEntryByName/residence/placeName/@ref"/>
                        <xsl:variable name="tribeEntry" select="
                                if ($tribeEntryByName) then
                                    $tribeEntryByName
                                else
                                    $persGrpList//personGrp[@role = 'tribe'][residence/placeName/@ref = $geoRef]"/>
                        <place sameAs="{$geoRef}"/>
                        <date type="languagePeriod">
                            <note>Contemporary</note>
                        </date>
                        <xsl:if test="$tribeEntry">
                            <personGrp role="tribe" corresp="pgr:{$tribeEntry/@xml:id}"/>
                        </xsl:if>
                        <channel mode="spoken"/>
                        <xsl:if test="not($geoEntry) and not($tribeEntry)">
                            <xsl:comment>No match for place or tribe: <xsl:value-of select="$placeOrTribeName"/></xsl:comment>
                        </xsl:if>
                    </language>
                </langUsage>
            </profileDesc>
            <xsl:apply-templates select="revisionDesc"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="revisionDesc">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
            <change when="{current-date()}" who="dmp:KS">Transformed to Lex-0</change>
        </xsl:copy>
    </xsl:template>
    <!-- Remove empty divs coming from templates -->
    <xsl:template match="div[not(node()[normalize-space()])]"/>
    <xsl:template match="div/head">
        <xsl:copy>
            <xsl:apply-templates select="figure"/>
        </xsl:copy>
    </xsl:template>
</xsl:stylesheet>
