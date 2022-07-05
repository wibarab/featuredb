<xsl:stylesheet xml:space="preserve" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0" exclude-result-prefixes="xsl tei">
   <xsl:output method="html" indent="no" encoding="UTF-8"/>

   <xsl:variable name="basePath">{basePath}</xsl:variable>
   <xsl:variable name="title">
      <xsl:value-of select="//tei:titleStmt/tei:title[1]"/>
   </xsl:variable>

   <xsl:template match="/">
      <html>
         <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
            <link rel="stylesheet" href="../650_css/basic__001.css"></link>
         </head>
         <body>
            <p>basePath: <xsl:value-of select="$basePath"/></p>
            <h3>Feature Values</h3>
            <table>
               <xsl:for-each select="//tei:fvLib/tei:fs">
                  <tr>
                     <td><xsl:value-of select="@xml:id"/></td>
                     <td><xsl:value-of select="tei:f[@name='explanation']"/></td>
                  </tr>
               </xsl:for-each>
            </table>
            <h3>Description</h3>
            <xsl:apply-templates select="//tei:div[@type='description']"/>
            <h3>Feature realisations (currently <xsl:value-of select="count(//tei:fs[@type='featureRealisation'])"/>)</h3>

            <xsl:for-each select="//tei:fs[@type='featureRealisation']">
               <!--
               <xsl:sort select="tei:f[@name='dialect']/@fVal"/>
               <xsl:sort select="tei:f[@name='realisationType']/@fVal"/>
                -->
               <xsl:apply-templates select="."/>
            </xsl:for-each>
         </body>
      </html>
   </xsl:template>

   <xsl:template match="tei:foreign"><i><xsl:apply-templates/></i></xsl:template>

   <xsl:template match="tei:seg">
      <xsl:param name="feVal"/><xsl:apply-templates/>(<xsl:value-of select="$feVal"/>)
   </xsl:template>

   <xsl:template match="tei:fs[@type='featureRealisation']">
         <table class="frTable">
            <xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute>
            <tr>
               <td colspan="2"><a href="goto:{@xml:id}" class="spHiddenLink"><span class="spArrow">⇒</span><span><xsl:text>   </xsl:text> <xsl:value-of select="@xml:id"/></span></a></td>
            </tr>
            <tr>
               <td class="tdHead">Dialect</td>
               <td>
                  <xsl:variable name="dia_id"><xsl:value-of select="substring(tei:f[@name='dialect']/@fVal,5)"/></xsl:variable>
                  <xsl:variable name="fp"><xsl:value-of select="$basePath"/>/vicav_dialects.xml</xsl:variable>
                  <xsl:value-of select="document($fp)//tei:fs[@type='dialect'][@xml:id=$dia_id]/tei:f[@name='dialectName']/tei:string"/>
                  <xsl:text>   (</xsl:text><xsl:value-of select="substring(tei:f[@name='dialect']/@fVal,5)"/><xsl:text>)</xsl:text>
               </td>
            </tr>

            <tr>
               <td class="tdHead">Source</td>
               <td>
                  <xsl:variable name="id"><xsl:value-of select="substring(@source,5)"/></xsl:variable>
                  <xsl:variable name="fp"><xsl:value-of select="$basePath"/>/vicav_biblio_tei_zotero.xml</xsl:variable>
                  <xsl:value-of select="$id"/><xsl:text>: </xsl:text>
                  <xsl:value-of select="document($fp)//tei:biblStruct[@xml:id=$id]/*/tei:title"/>
               </td>
            </tr>

            <xsl:if test="tei:f[@name='attestedPlace']">
               <xsl:for-each select="tei:f[@name='attestedPlace']">
                  <xsl:variable name="locID"><xsl:value-of select="substring(@fVal,5)"/></xsl:variable>
                  <xsl:variable name="fp"><xsl:value-of select="$basePath"/>/vicav_geodata.xml</xsl:variable>
                  <tr>
                     <td class="tdHead">Place</td>
                     <td><xsl:value-of select="document($fp)//tei:place[@xml:id=$locID]/tei:placeName"/><xsl:text> (</xsl:text><xsl:value-of select="$locID"/><xsl:text>)</xsl:text></td>
                  </tr>
               </xsl:for-each>
            </xsl:if>

            <tr>
               <xsl:variable name="rTypeID"><xsl:value-of select="substring(tei:f[@name='realisationType']/@fVal,2)"/></xsl:variable>
               <xsl:variable name="rTypeExpl"><xsl:value-of select="//tei:fs[@xml:id=$rTypeID]/tei:f[@name='explanation']"/></xsl:variable>
               <td class="tdHead">Type</td>
               <td><xsl:value-of select="$rTypeExpl"/></td>
            </tr>

            <xsl:if test="tei:f[@name='note']">
               <xsl:for-each select="tei:f[@name='note']">
                  <tr>
                     <td class="tdHead">Note <xsl:value-of select="position()"/></td>
                     <td><xsl:apply-templates/></td>
                  </tr>
               </xsl:for-each>
            </xsl:if>

            <!--*************************************************************-->
            <!--** EXAMPLE **************************************************-->
            <!--*************************************************************-->
            <xsl:for-each select="tei:f[@name='example']">
              <tr>
                  <td class="tdHead">Example <xsl:value-of select="position()"/></td>
                  <td>
                     <xsl:variable name="feVal" select="substring(@fVal,2)"></xsl:variable>
                     <xsl:apply-templates select="//tei:cit[@xml:id=$feVal]">
                        <xsl:with-param name="feVal" select="$feVal"/>
                     </xsl:apply-templates>
                     <xsl:text>    (</xsl:text><a href="goto:{$feVal}" class="spHiddenLink"><span class="spArrow">⇒ </span><xsl:value-of select="$feVal"/></a><xsl:text>)</xsl:text>
                  </td>
              </tr>
            </xsl:for-each>

            <!--*************************************************************-->
            <!--** original source ******************************************-->
            <!--*************************************************************-->
            <xsl:for-each select="tei:f[@name='originalSource']">
              <tr>
                  <td class="tdHead">Original source <xsl:value-of select="position()"/></td>
                  <td>
                     <xsl:variable name="feVal" select="substring(@fVal,2)"></xsl:variable>
                     <xsl:apply-templates select="//tei:cit[@xml:id=$feVal]">
                        <xsl:with-param name="feVal" select="$feVal"/>
                     </xsl:apply-templates>
                     <xsl:text>    (</xsl:text><a href="goto:{$feVal}" class="spHiddenLink"><span class="spArrow">⇒ </span><xsl:value-of select="$feVal"/></a><xsl:text>)</xsl:text>
                  </td>
              </tr>
            </xsl:for-each>

            <tr>
               <td class="tdHead">lexicalDomain</td>
               <td><xsl:value-of select="tei:f[@name='lexicalDomain']/tei:string"/></td>
            </tr>
         </table>

   </xsl:template>

   <xsl:template match="tei:cit">
      <xsl:choose>
         <xsl:when test="@type='translation'"><span class="spTranslation"><xsl:apply-templates/></span></xsl:when>
         <xsl:otherwise><span><xsl:apply-templates/></span></xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="tei:note"><div class="spExampleNote"><xsl:apply-templates/></div></xsl:template>

   <xsl:template match="tei:quote"><span><xsl:apply-templates/></span></xsl:template>

   <xsl:template match="tei:string"><span><xsl:apply-templates/></span></xsl:template>
   <xsl:template match="tei:seg"><span style="color:blue"><xsl:apply-templates/></span></xsl:template>

   <xsl:template match="tei:change"/>
   <xsl:template match="tei:desc"/>
   <xsl:template match="tei:fsDescr"/>
   <xsl:template match="tei:header"/>
   <xsl:template match="tei:label"/>
   <xsl:template match="tei:particDesc"/>
   <xsl:template match="tei:prefixDef/tei:p"/>
   <xsl:template match="tei:title"/>
   <xsl:template match="tei:titleStmt"/>
   <xsl:template match="tei:fileDesc"/>
   <xsl:template match="tei:revisionDesc"/>
   <xsl:template match="tei:sourceDesc"/>
   <xsl:template match="tei:sourceDesc/tei:bibl"/>
   <xsl:template match="tei:teiHeader/tei:fileDesc/tei:author"/>
   <xsl:template match="tei:titleStmt/tei:title"/>
   <xsl:template match="tei:publicationStmt/tei:pubPlace"/>
   <xsl:template match="tei:publicationStmt/tei:date"/>
   <xsl:template match="tei:editionStmt/tei:edition"/>
</xsl:stylesheet>
