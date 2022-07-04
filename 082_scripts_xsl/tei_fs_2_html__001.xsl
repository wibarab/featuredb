<xsl:stylesheet xml:space="preserve" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:wib="https://wibarab.acdh.oeaw.ac.at/langDesc" version="2.0" exclude-result-prefixes="xsl tei">
   <xsl:output method="html" indent="no" encoding="UTF-8"/>
   <xsl:strip-space elements="tei:body tei:TEI tei:row tei:cell tei:teiHeader tei:text tei:u tei:hi tei:ref tei:p tei:fileDesc tei:titleStmt tei:publicationStmt tei:editionStmt tei:revisionDesc tei:sourceDesc tei:div"/>

   <xsl:variable name="basePath">{basePath}</xsl:variable>
   <xsl:param name="dialectsPath">../102_derived_tei/vicav_dialects.xml</xsl:param>
   <xsl:param name="zoteroPath">../102_derived_tei/vicav_biblio_tei_zotero.xml</xsl:param>
   <xsl:param name="geoDataPath">../102_derived_tei/vicav_geodata.xml</xsl:param>


   <xsl:variable name="diaDoc" select="document($dialectsPath)"/>
   <xsl:variable name="zotDoc" select="document($zoteroPath)"/>
   <xsl:variable name="geoDoc" select="document($geoDataPath)"/>

   <xsl:variable name="title">
      <xsl:value-of select="//tei:titleStmt/tei:title"/>
   </xsl:variable>

   <xsl:template match="/">
      <html>
         <xsl:comment>This is a generated page, do not edit!</xsl:comment>
         <xsl:comment>XSLT: tei_2_html__simple_text.xsl</xsl:comment>
         <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
            <link rel="stylesheet" href="../650_css/basic__001.css"></link>
         </head>

         <body>
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

            <h3>Instances</h3>
            <xsl:apply-templates select="//wib:featureValueObservation"/>
         </body>

      </html>
   </xsl:template>

   <xsl:template match="tei:foreign"><i><xsl:apply-templates/></i></xsl:template>

   <xsl:template match="tei:seg">
   <xsl:param name="feVal"/><xsl:apply-templates/>(<xsl:value-of select="$feVal"/>)</xsl:template>

   <xsl:template match="wib:featureValueObservation">
      <xsl:variable name="xmlid"><xsl:value-of select="@xml:id"/></xsl:variable>
      <div class="featureRealisation" id="{$xmlid}">
         <table>
            <tr><td colspan="2"><a class="aReturnLink" href="goto:{$xmlid}">==˃ (Go to XML)</a></td></tr>
            <tr>
               <td class="tdLeft">Variety</td>
               <td class="tdRight">
                  <xsl:variable name="dia_id"><xsl:value-of select="substring(tei:lang/@corresp,5)"/></xsl:variable>
                  <xsl:value-of select="$diaDoc//tei:fs[@type='dialect'][@xml:id=$dia_id]/tei:f[@name='dialectName']/tei:string"/>
               </td>
            </tr>

            <tr>
               <td class="tdLeft">Source</td>
               <td class="tdRight">
                  <xsl:variable name="id"><xsl:value-of select="substring(tei:bibl/@corresp,5)"/></xsl:variable>
                  <xsl:choose>
                     <xsl:when test="$id=''"><span class="spError">Could not find source</span></xsl:when>
                     <xsl:otherwise>
                       <xsl:value-of select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:analytic/tei:author/tei:surname"/>
                       <xsl:value-of select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:author/tei:surname"/>

                       <xsl:text>: </xsl:text>

                       <xsl:value-of select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:analytic/tei:title"/>
                       <xsl:value-of select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:title"/>
                      </xsl:otherwise>
                  </xsl:choose>


               </td>
            </tr>

            <tr>
               <td class="tdLeft">Place</td>
               <td class="tdRight">
                  <xsl:variable name="regId"><xsl:value-of select="substring(tei:region/@ref,5)"/></xsl:variable>
                  <xsl:variable name="setId"><xsl:value-of select="substring(tei:settlement/@ref,5)"/></xsl:variable>
                  <xsl:value-of select="$geoDoc//tei:place[@xml:id=$regId]/tei:placeName"/>
                  <xsl:value-of select="$geoDoc//tei:place[@xml:id=$setId]/tei:placeName"/>

                  <xsl:if test="($regId = '') and ($setId = '')"><span class="spError">Missing place!!!</span></xsl:if>
               </td>
            </tr>

            <xsl:if test="tei:note">
              <tr>
                 <td class="tdLeft">Notes</td>
                 <td class="tdRight">
                    <xsl:for-each select="tei:note">
                       <p><xsl:apply-templates/></p>
                    </xsl:for-each>
                 </td>
              </tr>
            </xsl:if>

            <xsl:if test="tei:cit[@type='example']">
              <tr>
                 <td class="tdLeft">Examples</td>
                 <td class="tdRight">
                    <xsl:for-each select="tei:cit[@type='example']">
                      <div>
                         <xsl:value-of select="tei:quote"/>
                         <xsl:text> </xsl:text>
                         <i><xsl:value-of select="tei:cit/tei:quote"/></i>
                      </div>
                    </xsl:for-each>
                 </td>
              </tr>
            </xsl:if>
         </table>
      </div>
   </xsl:template>

   <xsl:template match="tei:change"/>
   <xsl:template match="tei:desc"/>
   <xsl:template match="tei:fsDescr"/>
   <xsl:template match="tei:cit"/>
   <xsl:template match="tei:header"/>
   <xsl:template match="tei:note"/>
   <xsl:template match="tei:label"/>
   <xsl:template match="tei:particDesc"/>
   <xsl:template match="tei:prefixDef/tei:p"/>
   <xsl:template match="tei:string"/>
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
