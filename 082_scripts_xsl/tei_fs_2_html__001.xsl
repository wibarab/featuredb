<xsl:stylesheet xml:space="preserve" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:wib="https://wibarab.acdh.oeaw.ac.at/langDesc" version="2.0" exclude-result-prefixes="xsl tei">
   <xsl:output method="html" indent="no" encoding="UTF-8"/>
   <xsl:strip-space elements="tei:body tei:TEI tei:row tei:cell tei:teiHeader tei:text tei:u tei:hi tei:ref tei:p tei:fileDesc tei:titleStmt tei:publicationStmt tei:editionStmt tei:revisionDesc tei:sourceDesc tei:div"/>

   <xsl:variable name="basePath">{basePath}</xsl:variable>
   <xsl:param name="dialectsPath">../010_manannot/vicav_dialects.xml</xsl:param>
   <xsl:param name="zoteroPath">../010_manannot/vicav_biblio_tei_zotero.xml</xsl:param>
   <xsl:param name="geoDataPath">../010_manannot/vicav_geodata.xml</xsl:param>


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
            <link rel="stylesheet" href="../../650_css/basic__001.css"></link>
         </head>

         <body>
            <h3>Feature Values</h3>
            <table>
               <xsl:for-each select="//tei:list[@type='featureValues']/tei:item">
                  <tr>
                     <td><xsl:value-of select="@xml:id"/></td>
                     <td><xsl:value-of select="tei:label"/></td>
                  </tr>
               </xsl:for-each>
             </table>

            <h3>Open issues</h3>
            <xsl:for-each select="//tei:div[@type='tbd']/tei:list/tei:item">
               <div><xsl:value-of select="."/></div>
            </xsl:for-each>

            <h3>Description</h3>
            <xsl:apply-templates select="//tei:div[@type='description']"/>

            <h3>Instances (<xsl:value-of select="count(//wib:featureValueObservation)"/>)</h3>
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
            <tr><td colspan="2" class="tdObservation">Observation <xsl:value-of select="position()"/> (<xsl:value-of select="@xml:id"/>)<xsl:text> </xsl:text><a class="aReturnLink" href="goto:{$xmlid}">==˃ (Go to XML)</a></td></tr>

            <tr>
               <td class="tdLeft">Type</td>
               <td class="tdRight">
                  <xsl:variable name="refVal"><xsl:value-of select="substring(tei:name[@type='featureValue']/@ref,2)"/></xsl:variable>
                  <xsl:variable name="typeLabel"><xsl:value-of select="//tei:item[@xml:id=$refVal]/tei:label"/></xsl:variable>

                  <xsl:choose>
                     <xsl:when test="$typeLabel=''"><span class="spError">Missing value</span></xsl:when>
                     <xsl:otherwise><xsl:value-of select="$typeLabel"/></xsl:otherwise>
                  </xsl:choose>
               </td>
            </tr>

            <xsl:if test="tei:language">
              <tr>
                <td class="tdLeft">Ling. cat.</td>
                <td class="tdRight">
                  <xsl:variable name="ana"><xsl:value-of select="substring(tei:language/@ana,2)"/></xsl:variable>
                  <xsl:variable name="catDesc"><xsl:value-of select="//tei:category[@xml:id=$ana]/tei:catDesc"/></xsl:variable>

                  <xsl:choose>
                     <xsl:when test="$catDesc=''"><span class="spError">Missing value</span></xsl:when>
                     <xsl:otherwise><xsl:value-of select="$catDesc"/></xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
            </xsl:if>

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
                   <xsl:for-each select="tei:placeName">
                      <xsl:variable name="id"><xsl:value-of select="substring(@ref,5)"/></xsl:variable>
                      <xsl:value-of select="$geoDoc//tei:place[@xml:id=$id]/tei:placeName"/>

                      <xsl:if test="($id = '')"><span class="spError">Missing place!!! (<xsl:value-of select="."/>)</span></xsl:if>
                   </xsl:for-each>

                   <!--
                  <xsl:variable name="id"><xsl:value-of select="substring(tei:placeName/@ref,5)"/></xsl:variable>
                  <xsl:value-of select="$geoDoc//tei:place[@xml:id=$id]/tei:placeName"/>

                  <xsl:if test="($id = '')"><span class="spError">Missing place!!!</span></xsl:if>
                  -->
               </td>
            </tr>

            <xsl:if test="tei:personGrp">
              <tr>
                 <td class="tdLeft">personGrp</td>
                 <td class="tdRight">
                    <xsl:for-each select="tei:personGrp">
                       <div><xsl:value-of select="tei:name"/> (<xsl:value-of select="@type"/>)</div>
                    </xsl:for-each>
                 </td>
              </tr>
            </xsl:if>

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

            <xsl:if test="tei:lang">
              <tr>
                 <td class="tdLeft">Profiles</td>
                 <td class="tdRight">
                    <xsl:for-each select="tei:lang">
                    <p><xsl:value-of select="@target"/></p>
                    </xsl:for-each>
                 </td>
              </tr>
            </xsl:if>

            <xsl:if test="tei:cit[@type='example']">
              <tr>
                 <td class="tdLeft">Examples</td>
                 <td class="tdRight">
                    <xsl:for-each select="tei:cit[@type='example']">
                      <div class="dvExample">
                         <xsl:choose>
                            <xsl:when test="(tei:quote='') and (tei:cit/tei:quote='')">
                               <span class="spError">Example element has no data!!!</span>
                            </xsl:when>
                            <xsl:otherwise>
                               <xsl:value-of select="tei:quote"/>
                               <xsl:text> </xsl:text>
                               <i class="iTrans"><xsl:value-of select="tei:cit/tei:quote"/></i>
                            </xsl:otherwise>
                         </xsl:choose>
                      </div>
                    </xsl:for-each>
                 </td>
              </tr>
            </xsl:if>

            <xsl:if test="tei:cit[@type='orCit']">
              <tr>
                 <td class="tdLeft">Orig. sources</td>
                 <td class="tdRight">
                    <xsl:for-each select="tei:cit[@type='orCit']">
                      <div class="dvExample">
                         <xsl:choose>
                            <xsl:when test="(tei:quote='')">
                               <span class="spError">OrCit element has no data!!!</span>
                            </xsl:when>
                            <xsl:otherwise>
                               <xsl:value-of select="tei:quote"/>
                            </xsl:otherwise>
                         </xsl:choose>
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
