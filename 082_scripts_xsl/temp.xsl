<xsl:stylesheet xml:space="preserve" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:wib="https://wibarab.acdh.oeaw.ac.at/langDesc" version="2.0" exclude-result-prefixes="xsl tei">
   <xsl:output method="xml" indent="no" encoding="UTF-8"/>
   <xsl:strip-space elements="*"/>

   <xsl:variable name="basePath">feature_form_VII_VIII_ipfv.xml</xsl:variable>
   <xsl:param name="dialectsPath">../010_manannot/vicav_dialects.xml</xsl:param>
   <xsl:param name="zoteroPath">../010_manannot/vicav_biblio_tei_zotero.xml</xsl:param>
   <xsl:param name="geoDataPath">../010_manannot/vicav_geodata.xml</xsl:param>
   <xsl:param name="prgDataPath">../010_manannot/wibarab_PersonGroup.xml</xsl:param>
   <xsl:param name="srcDataPath">../010_manannot/wibarab_sources.xml</xsl:param>

   <xsl:variable name="diaDoc" select="document($dialectsPath)"/>
   <xsl:variable name="zotDoc" select="document($zoteroPath)"/>
   <xsl:variable name="geoDoc" select="document($geoDataPath)"/>
   <xsl:variable name="prgDoc" select="document($prgDataPath)"/>
   <xsl:variable name="srcDoc" select="document($srcDataPath)"/>

   <xsl:variable name="title">
      <xsl:value-of select="//tei:titleStmt/tei:title"/>
   </xsl:variable>

   <xsl:template match="/"><list>
         <xsl:for-each select="//wib:featureValueObservation[@status='done']" xml:space="default">
<xsl:text>&#10;</xsl:text>
<item><xsl:for-each select="tei:placeName">
<xsl:variable name="id"><xsl:value-of select="substring(@ref,5)"/></xsl:variable>
<xsl:variable name="placeName"><xsl:value-of select="$geoDoc//tei:place[@xml:id=$id]/tei:placeName"/></xsl:variable>
<xsl:variable name="latlng"><xsl:value-of select="normalize-space($geoDoc//tei:place[@xml:id=$id]/tei:location/tei:geo[@decls='#dd'])"/></xsl:variable>
<xsl:variable name="lat"><xsl:value-of select="substring-before($latlng,' ')"/></xsl:variable>
<xsl:variable name="lng"><xsl:value-of select="substring-after($latlng,' ')"/></xsl:variable>
<fs>
   <f name="lat"><string><xsl:value-of select="$lat"/></string></f>
   <f name="lng"><string><xsl:value-of select="$lng"/></string></f>
   <f name="placeNameID"><string><xsl:value-of select="$id"/></string></f>
   <f name="placeName"><string><xsl:value-of select="$placeName"/></string></f>
   <f name="featureType"><string><xsl:value-of select="parent::node()/tei:name/@ref"/></string></f>
   <f name="fileName"><string><xsl:value-of select="$basePath"/></string></f>
   <f name="obsID"><string><xsl:value-of select="parent::node()/@xml:id"/></string></f>
</fs>    
         </xsl:for-each>
            </item>
         </xsl:for-each>      
         </list>

   </xsl:template>
<xsl:template match="text()"/>
</xsl:stylesheet>
