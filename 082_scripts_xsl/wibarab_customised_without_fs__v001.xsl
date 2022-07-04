<?xml version="1.0"?>
<xsl:stylesheet 
   version="2.0" 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:tei="http://www.tei-c.org/ns/1.0" 
   xmlns="http://www.tei-c.org/ns/1.0"
   xmlns:wib="https://wibarab.acdh.oeaw.ac.at/langDesc"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
   exclude-result-prefixes="tei xsl wib xsi xs">

   <xsl:output method="xml" indent="yes" encoding="UTF-8" omit-xml-declaration="no"/>

   <xsl:param name="MAX_AUTHORS" select="3"/>

   <xsl:param name="path-to-dmp">../102_derived_tei/wibarab_dmp.xml</xsl:param>
   <xsl:variable name="dmp" select="document($path-to-dmp)"/>
   <xsl:variable name="listPrefixDef" select="$dmp//tei:listPrefixDef"/>
   <xsl:variable name="doc" select="."/>
   
   <xsl:strip-space elements="*"/>
<!--   <xsl:preserve-space elements="wib:featureValueObservation"/>-->
   
   <xsl:template match="@* | node()">
      <xsl:copy>
         <xsl:apply-templates select="@* | node()"/>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="tei:TEI">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <xsl:namespace name="wib">https://wibarab.acdh.oeaw.ac.at/langDesc</xsl:namespace>
         <xsl:attribute name="xsi:schemaLocation">http://www.tei-c.org/ns/1.0 ../802_tei_odd/out/featuredb.xsd</xsl:attribute>
         <xsl:apply-templates/>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="tei:revisionDesc">
      <xsl:copy>
         <xsl:copy-of select="@*|node()"/>
         <change when="{current-date()}" who="dmp:DS">converted data to new schema version</change>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="tei:encodingDesc[not(tei:listPrefixDef)]">
      <xsl:copy>
         <!-- <xsl:copy-of select="@*|node()"/> -->
         <xsl:sequence select="$listPrefixDef"/>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="tei:fvLib">
      <list type="featureValues" xml:id="{@xml:id}">
         <head><xsl:value-of select="@n"/></head>
         <xsl:apply-templates/>
      </list>
   </xsl:template>
   
   <xsl:template match="tei:fvLib/tei:fs">
      <item xml:id="{@xml:id}">
         <label><xsl:value-of select="tei:f[@name = 'explanation']"/></label>
         <xsl:apply-templates select="tei:f[@name = 'note']"/>
      </item>
   </xsl:template>
   
   
   <xsl:template match="tei:body">
      <xsl:copy>
         <xsl:attribute name="xml:base">
            <xsl:value-of select="@xml:base"/>
         </xsl:attribute>
         <div type="featureDescription">
            <head>Feature Values</head>
            <list type="featureValues">
               <xsl:for-each select="//tei:fvLib/tei:fs">
                  <item xml:id="{@xml:id}">
                     <label><xsl:value-of select="tei:f[@name = 'explanation']"/></label>
                  </item>
               </xsl:for-each>
            </list>
         </div>
         <xsl:apply-templates select="node()"/>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="tei:p[not(node())]"/>
   
   <xsl:template match="tei:p">
      <xsl:copy>
         <xsl:attribute name="xml:space">preserve</xsl:attribute>
         <xsl:copy-of select="node()"/>
      </xsl:copy>
   </xsl:template>
   
   <xsl:template match="tei:div[@type = 'featureRealisations']">
      <div type="featureValueObservations">
         <xsl:apply-templates/>
      </div>
   </xsl:template>
   
   <xsl:strip-space elements="*"/>
   <xsl:template match="tei:fs[@type='featureRealisation']">
      <wib:featureValueObservation cert="unknown" status="draft" xml:id="{@xml:id}" resp="dmp:???">
         <xsl:apply-templates select="tei:f[@name='realisationType']"/>
         <xsl:apply-templates select="@source"/>
         <xsl:apply-templates select="tei:f[@name = 'attestedPlace']"/>
         <xsl:apply-templates select="tei:f[@name = 'attestedDate']"/>
         <xsl:apply-templates select="tei:f[@name = 'dialect']"/>
         <xsl:apply-templates select="*[not(@name = ('realisationType','attestedPlace','attestedDate','dialect'))]"/>
      </wib:featureValueObservation>
   </xsl:template>
   
   <xsl:function name="wib:replacePattern">
      <xsl:param name="string"/>
      <xsl:param name="regexGroups" as="item()*"/>
      <xsl:choose>
         <xsl:when test="matches($string,'\$\d+')">
            <xsl:variable name="groupNumbers" as="xs:integer*">
               <xsl:analyze-string select="$string" regex="\$(\d+)">
                  <xsl:matching-substring>
                     <xsl:sequence select="xs:integer(regex-group(1))"/>
                  </xsl:matching-substring>
               </xsl:analyze-string>
            </xsl:variable>
            <xsl:variable name="replacedString" select="replace($string,concat('\$',xs:string($groupNumbers[1])),$regexGroups[@group=$groupNumbers[1]])"/>
            <xsl:sequence select="wib:replacePattern($replacedString,$regexGroups)"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$string"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:function>
   
   <xsl:function name="wib:resolveReference">
      <xsl:param name="reference"/>
      <xsl:variable name="listPrefixDef" select="if ($reference instance of item() and exists(root($reference)//tei:listPrefixDef)) then root($reference)//tei:listPrefixDef else $listPrefixDef" as="element(tei:listPrefixDef)"/>
      <xsl:variable name="prefix" select="substring-before($reference,':')"/>
      
      <xsl:choose>
         <!-- This might actually already be a resolvable URI -->
         <xsl:when test="doc-available($reference)">
            <xsl:sequence select="doc($reference)"/>
         </xsl:when>
         <xsl:when test="$prefix != ''">
            <xsl:variable name="prefixDef" select="$listPrefixDef//tei:prefixDef[@ident = $prefix]"/>
            <xsl:variable name="fullURI">
               <xsl:analyze-string select="substring-after($reference,concat($prefix,':'))" regex="{$prefixDef/@matchPattern}">
                  <xsl:matching-substring>
                     <xsl:variable name="regexGroups" as="item()+">
                        <xsl:for-each select="1 to 100" xmlns="">
                           <value group="{.}"><xsl:value-of select="regex-group(.)"/></value>
                        </xsl:for-each>
                     </xsl:variable>
                     <xsl:value-of select="wib:replacePattern($prefixDef/@replacementPattern, $regexGroups)"/>
                  </xsl:matching-substring>
               </xsl:analyze-string>
            </xsl:variable>
            <xsl:choose>
               <xsl:when test="doc-available($fullURI)">
                  <xsl:sequence select="doc($fullURI)"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:message>Failed to load document <xsl:value-of select="$fullURI"/></xsl:message>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:when>
         <xsl:otherwise>
            <xsl:message>Could not resolve reference <xsl:value-of select="$reference"/></xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      
   </xsl:function>
     
   <xsl:template match="tei:f[@name = 'dialect']">
      <!-- 
      <xsl:variable name="diaRef" select="@fVal"/>
      <xsl:variable name="dialect" select="wib:resolveReference($diaRef)"/>
      <xsl:choose>
         <xsl:when test="count($dialect) eq 0">
            <xsl:comment>CHECKME dialect w/ id <xsl:value-of select="$diaRef"/> not found</xsl:comment>
         </xsl:when>
         <xsl:when test="count($dialect) gt 1">
            <xsl:comment>CHECKME found several dialects w/ id <xsl:value-of select="$diaRef"/> not found</xsl:comment>
         </xsl:when>
         <xsl:otherwise/>
      </xsl:choose>
      <lang corresp="{@fVal}"><xsl:value-of select="$dialect/tei:f[@name = 'dialectName']/tei:string"/></lang>
       -->
      <lang corresp="{@fVal}"></lang>
   </xsl:template>
   
   <xsl:template match="tei:div[@type= 'examples']"/>
   
   <xsl:template match="tei:f[@name = 'example']">
      <xsl:for-each select="tokenize(current()/@fVal,' ')">
         <xsl:variable name="exampleID" select="substring-after(.,'#')"/>
         <xsl:variable name="example" select="$doc//*[@xml:id=$exampleID]"/>
         <xsl:if test="$exampleID != '' and not(exists($example))">
            <xsl:message terminate="yes">Could not find example with id <xsl:value-of select="$exampleID"/></xsl:message>
         </xsl:if>
         <xsl:sequence select="$example"/>
      </xsl:for-each>
   </xsl:template>
   
   <xsl:template match="tei:f[@name='realisationType']">
      <name type="featureValue" ref="{@fVal}"/>         
   </xsl:template>
   
   
   <xsl:template match="tei:fs/@source">
      <xsl:variable name="biblRef" select="."/>
      <xsl:variable name="bibliography" as="document-node()">
         <xsl:document/>
      </xsl:variable>
      <xsl:variable name="bibl" select="wib:resolveReference($biblRef)"/>
      <!-- 
      <xsl:variable name="authors" as="element()*">
         <xsl:choose>
            <xsl:when test="count($bibl//tei:author) lt $MAX_AUTHORS">
               <xsl:for-each select="$bibl//tei:author">
                  <xsl:sort select="tei:surname"/>
                  <xsl:sequence select="."/>
               </xsl:for-each>
            </xsl:when>
            <xsl:when test="count($bibl//tei:author) gt $MAX_AUTHORS">
               <xsl:for-each select="$bibl//tei:author">
                  <xsl:sort select="tei:surname"/>
                  <xsl:if test="position() lt $MAX_AUTHORS">
                     <xsl:sequence select="."/>
                  </xsl:if>
               </xsl:for-each>
            </xsl:when>
         </xsl:choose>  
      </xsl:variable>
      <xsl:variable name="editors" as="element()*">
         <xsl:choose>
            <xsl:when test="count($bibl//tei:editor) lt $MAX_AUTHORS">
               <xsl:for-each select="$bibl//tei:editor">
                  <xsl:sort select="tei:surname"/>
                  <xsl:sequence select="."/>
               </xsl:for-each>
            </xsl:when>
            <xsl:when test="count($bibl//tei:editor) gt $MAX_AUTHORS">
               <xsl:for-each select="$bibl//tei:editor">
                  <xsl:sort select="tei:surname"/>
                  <xsl:if test="position() lt $MAX_AUTHORS">
                     <xsl:sequence select="."/>
                  </xsl:if>
               </xsl:for-each>
            </xsl:when>
         </xsl:choose>  
      </xsl:variable>
      <xsl:variable name="creators" select="if ($authors) then $authors else $editors"/>
      <xsl:variable name="year" select="$bibl//tei:imprint/tei:date"/>
      <xsl:variable name="shortTitle">
         <xsl:for-each select="$creators">
            <xsl:choose>
               <xsl:when test="position() eq 1 or position() eq $MAX_AUTHORS">
                  <xsl:value-of select="tei:surname"/>
               </xsl:when>
               -->
               <!-- last name without "et alt." -->
      <!--
               <xsl:when test="position() eq count($creators) and count($creators) lt $MAX_AUTHORS">
                  <xsl:text> and </xsl:text>
                  <xsl:value-of select="tei:surname"/>
               </xsl:when>
               <xsl:otherwise>et alt.</xsl:otherwise>
            </xsl:choose>
         </xsl:for-each>
         <xsl:text> </xsl:text>
         <xsl:value-of select="$year"/>
         <xsl:if test="matches($bibl/@xml:id,'[a-z]$')">
            <xsl:value-of select="substring($bibl/@xml:id,string-length($bibl/@xml:id),1)"/>
         </xsl:if>
         </xsl:variable> -->
      <xsl:choose>
         <xsl:when test="not(exists($bibl))">
            <xsl:comment>CHECKME Zotero Reference missing</xsl:comment>
         </xsl:when>
         <xsl:otherwise>
            <bibl corresp="{.}" type="publication" subtype="{$bibl/@type}">
               <!--   <title type="short"><xsl:value-of select="$shortTitle"/></title> -->      
               <!--<biblScope unit="page"><xsl:comment>provide page numbers here</xsl:comment></biblScope>-->
            </bibl>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template match="tei:sourceDesc">
      <xsl:copy>
         <xsl:copy-of select="@*"/>
         <p>This is a born digital document. All sources used in compiling and collected the data are cated in the bibliographic sections of the respective entry / element.</p>
         <!-- CHECKME DS 2022-06-23 
            Should we generate a list of all referenced sources into the header at the end?-->
      </xsl:copy>
   </xsl:template>
   <xsl:template match="tei:f[@name = 'attestedDate']">
      <xsl:choose>
         <xsl:when test=".//tei:symbol/@value != ''">
            <date><xsl:value-of select=".//tei:symbol/@value"/></date>
         </xsl:when>
         <xsl:otherwise>
            <xsl:comment>CHECKME Missing date of data collection.</xsl:comment>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template match="tei:f[@name = 'note']">
      <note><xsl:value-of select="."/></note>
   </xsl:template>
   
   <xsl:template match="tei:f[@name = 'attestedPlace']">
      <xsl:variable name="geoRef" select="@fVal"/>
      <xsl:variable name="geoID" select="substring-after($geoRef,':')"/>
      <xsl:variable name="geo" select="wib:resolveReference($geoRef)"/>
      <xsl:variable name="geoType" select="$geo/@type"/>
      <xsl:variable name="geoElementName">
         <xsl:choose>
            <xsl:when test="$geoType = 'reg'">region</xsl:when>
            <xsl:otherwise>settlement</xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      
      <xsl:choose>
         <xsl:when test="$geoID =('geo:','','#')">
            <xsl:comment>CHECKME invalid geo reference "<xsl:value-of select="$geoRef"/>"</xsl:comment>
         </xsl:when>
         <xsl:when test="not(exists($geo))">
            <xsl:comment>CHECKME unknown place with id "<xsl:value-of select="$geoRef"/>"</xsl:comment>
         </xsl:when>
         <xsl:otherwise>
            <xsl:element name="{$geoElementName}">
               <xsl:attribute name="ref" select="$geoRef"/>
               <!-- <xsl:value-of select="$geo/tei:placeName"/> -->
            </xsl:element>   
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>   
   
</xsl:stylesheet>
