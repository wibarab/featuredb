<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xs="http://www.w3.org/2001/XMLSchema"
xmlns="http://www.w3.org/1999/xhtml"
xmlns:saxon="http://saxon.sf.net/"
xmlns:h="http://www.w3.org/1999/xhtml"
xmlns:svg='http://www.w3.org/2000/svg'
exclude-result-prefixes="#all"
version="3.0">
<xsl:param name="imgFilnamePattern" as="xs:string"/>
<!-- either
* "reference" to just ingest the image via file reference
* "embed" to embedd a base64-encoded version of the image
-->
<xsl:param name="mode">embed</xsl:param>
<xsl:param name="pathToImageDataXML" as="xs:string"/>
<xsl:param name="listingsXPathExpr"/>

<xsl:template match="node() | @*">
<xsl:copy>
<xsl:apply-templates select="node() | @*"/>
</xsl:copy>
</xsl:template>

<xsl:template match="/">
<xsl:if test="$mode = 'embed'">
<xsl:message select="concat('$pathToImageDataXML=',$pathToImageDataXML)"/>
<xsl:message select="concat('$pathToImageDataXML exists?',doc-available($pathToImageDataXML))"/>
<xsl:message select="concat('$pathToImageDataXML no of images?',count(doc($pathToImageDataXML)//img))"/>
</xsl:if>
<xsl:apply-templates/>
</xsl:template>

<!-- $listingXPathExpr will be replaced dynamically by the runner script-->
<xsl:template match="h:pre[h:code[@data-type='listing']]">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="h:img[@src]">
<xsl:choose>
<xsl:when test="$mode = 'reference'">
<xsl:sequence select="."/>
</xsl:when>
<xsl:otherwise>
<xsl:variable name="imgDataEncoded" select="doc($pathToImageDataXML)//img[@src = current()/@src]"/>
<img src="data:{$imgDataEncoded/@format};charset=utf-8;base64,{normalize-space($imgDataEncoded)}">
<xsl:copy-of select="@* except @src"/>
</img>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- $listingXPathExpr will be replaced dynamically by the runner script-->
<xsl:template match="h:code[@data-type='listing']">
<xsl:variable name="position" select="count(preceding::h:code[@data-type='listing'])+1"/>
<xsl:variable name="xmlfn" select="concat('listing_',$position,'.html')"/>
<xsl:variable name="xml" select="doc($xmlfn)"/>
<xsl:variable name="imgFilename" select="replace($imgFilnamePattern,'#',xs:string($position))"/>
<xsl:message select="concat('injectListing.xsl: $imgFilename=',$imgFilename)"/>
<figure>
<xsl:choose>
<xsl:when test="$mode = 'reference'">
<img src="{$imgFilename}" alt="Listing {$position}"/>
</xsl:when>
<xsl:otherwise>
<xsl:variable name="imgDataEncoded" select="doc($pathToImageDataXML)//img[$position]"/>
<xsl:choose>
<xsl:when test="$imgDataEncoded/@format = 'image/svg'">
<img alt="Listing {$position}">
<xsl:sequence select="$imgDataEncoded/svg:svg"/>
</img>
</xsl:when>
<xsl:otherwise>
<img src="data:{$imgDataEncoded/@format};charset=utf-8;base64,{normalize-space($imgDataEncoded)}" alt="Listing {$position}"/>
</xsl:otherwise>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
<figcaption>Listing <xsl:value-of select="$position"/></figcaption>
</figure>
</xsl:template>
</xsl:stylesheet>

