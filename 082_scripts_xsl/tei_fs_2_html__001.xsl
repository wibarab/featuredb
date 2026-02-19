<xsl:stylesheet xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:wib="https://wibarab.acdh.oeaw.ac.at/langDesc" version="2.0" exclude-result-prefixes="xsl tei">
   <xsl:output method="html" indent="no" encoding="UTF-8"/>
   <xsl:strip-space elements="tei:body tei:TEI tei:row tei:cell tei:teiHeader tei:text tei:u tei:hi tei:ref tei:p tei:fileDesc tei:titleStmt tei:publicationStmt tei:editionStmt tei:revisionDesc tei:sourceDesc tei:div"/>

   <xsl:variable name="basePath">{basePath}</xsl:variable>
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

   <xsl:template match="/">
      <html>
         <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
            <link rel="stylesheet" href="../../650_css/basic__001.css"></link>
         </head>

         <body>
            <h3>ERRORS</h3>
            <table>
               <xsl:for-each select="//wib:featureValueObservation[@status='done'][tei:name[string-length(@ref)=0]]">
                  <tr>
                     <td>done + tei:name[@ref='']</td>
                     <td><a class="aReturnLink" href="goto:{@xml:id}">==˃ <xsl:value-of select="@xml:id"/></a></td>
                  </tr>
               </xsl:for-each>

               <xsl:for-each select="//wib:featureValueObservation[@status='done'][tei:bibl[string-length(@corresp)=0]]">
                  <tr>
                     <td>done + tei:bibl[@corresp='']</td>
                     <td><a class="aReturnLink" href="goto:{@xml:id}">==˃ <xsl:value-of select="@xml:id"/></a></td>
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

   <xsl:template match="tei:head">
      <xsl:variable name="depth" select="count(ancestor::tei:div)"/>
         <xsl:choose>
            <xsl:when test="$depth=2"><h4><xsl:apply-templates/></h4></xsl:when>
            <xsl:when test="$depth=3"><h5><xsl:apply-templates/></h5></xsl:when>
            <xsl:when test="$depth=4"><h6><xsl:apply-templates/></h6></xsl:when>
         </xsl:choose>
      </xsl:template>
   <xsl:template match="tei:p"><p><xsl:apply-templates/></p></xsl:template>
   <xsl:template match="tei:table"><table><xsl:apply-templates/></table></xsl:template>
   <xsl:template match="tei:row"><tr><xsl:apply-templates/></tr></xsl:template>
   <xsl:template match="tei:cell"><td><xsl:apply-templates/></td></xsl:template>
   <xsl:template match="tei:list"><ol><xsl:apply-templates/></ol></xsl:template>
   <xsl:template match="tei:item"><li><xsl:apply-templates/></li></xsl:template>
   <xsl:template match="tei:label"><xsl:apply-templates/></xsl:template>

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
                  <xsl:variable name="id"><xsl:value-of select="substring-after(tei:bibl/@corresp,'#$1')"/></xsl:variable>
                  <xsl:variable name="pre_bibtype">
                     <xsl:value-of>
                      <xsl:choose>
                        <xsl:when test="$zotDoc//tei:biblStruct[@xml:id=$id][not(tei:analytic)][tei:monogr]">mo</xsl:when>
                        <xsl:when test="$zotDoc//tei:biblStruct[@xml:id=$id][tei:analytic][tei:monogr]">ana_mo</xsl:when>
                        <xsl:when test="$zotDoc//tei:biblStruct[@xml:id=$id][tei:series][tei:monogr]">ser_mo</xsl:when>
                        <xsl:otherwise>other</xsl:otherwise>
                      </xsl:choose>
                     </xsl:value-of>
                  </xsl:variable>
                  <xsl:variable name="bibtype"><xsl:value-of select="normalize-space($pre_bibtype)"/></xsl:variable>

                  <xsl:choose>
                     <xsl:when test="starts-with(tei:bibl/@corresp,'src')">
                        <xsl:value-of select="$srcDoc//tei:event[@xml:id=$id]/tei:head"/>
                     </xsl:when>

                     <xsl:otherwise>
                        <xsl:choose>
                           <xsl:when test="$id=''"><span class="spError">bibl/@corresp is empty</span></xsl:when>
                           <xsl:when test="not($zotDoc//tei:biblStruct[@xml:id=$id])"><span class="spError">Could not find source <xsl:value-of select="$id"/></span></xsl:when>
                           <xsl:otherwise>
                              <xsl:choose>
                                 <xsl:when test="$bibtype='mo'">
                                    <!-- DEBUG: <div>Type: mo</div>-->
                                    <!--**** Authors monograph****-->
                                    <xsl:if test="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:author">
                                      <xsl:for-each select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:author/tei:surname">
                                         <xsl:if test="position()&gt;1">, </xsl:if>
                                         <xsl:value-of select="."/>
                                      </xsl:for-each>
                                      <xsl:text>: </xsl:text>
                                    </xsl:if>

                                    <!--**** Title monograph****-->
                                    <xsl:choose>
                                      <xsl:when test="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:title[@type='short']">
                                         <xsl:value-of select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:title[@type='short']"/>
                                      </xsl:when>
                                      <xsl:otherwise>
                                         <xsl:value-of select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:title[1]"/>
                                      </xsl:otherwise>
                                    </xsl:choose>
                                      <xsl:text>. </xsl:text>

                                    <xsl:if test="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:imprint/tei:date">
                                       <xsl:text> </xsl:text>
                                       <xsl:value-of select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:imprint/tei:date"/>
                                       <xsl:text>.</xsl:text>
                                    </xsl:if>

                                 </xsl:when>

                                 <xsl:when test="$bibtype='ana_mo'">
                                    <!-- DEBUG: <div>Type: ana_mo</div>-->
                                    <!--**** Authors analytic****-->
                                    <xsl:for-each select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:analytic/tei:author/tei:surname">
                                       <xsl:if test="position()&gt;1">, </xsl:if>
                                       <xsl:value-of select="."/>
                                    </xsl:for-each>
                                    <xsl:text>: </xsl:text>

                                    <!--**** Title analytic****-->
                                    <xsl:choose>
                                      <xsl:when test="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:analytic/tei:title[@type='short']">
                                         <xsl:value-of select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:analytic/tei:title[@type='short']"/>
                                      </xsl:when>
                                      <xsl:otherwise>
                                         <xsl:value-of select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:analytic/tei:title[1]"/>
                                      </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:text>. In: </xsl:text>

                                    <!--**** Authors monograph/journal****-->
                                    <xsl:if test="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:author">
                                      <xsl:for-each select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:author/tei:surname">
                                         <xsl:if test="position()&gt;1">, </xsl:if>
                                         <xsl:value-of select="."/>
                                      </xsl:for-each>
                                      <xsl:text>: </xsl:text>
                                    </xsl:if>

                                    <!--**** Title monograph/journal****-->
                                    <xsl:choose>
                                      <xsl:when test="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:title[@type='short']">
                                         <xsl:value-of select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:title[@type='short']"/>
                                      </xsl:when>
                                      <xsl:otherwise>
                                         <xsl:value-of select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:title[1]"/>
                                      </xsl:otherwise>
                                    </xsl:choose>

                                    <!--**** Title monograph/journal number etc****-->
                                    <xsl:if test="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:imprint/tei:biblScope">
                                       <xsl:for-each select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:imprint/tei:biblScope">
                                          <xsl:if test="position()&gt;1">, </xsl:if>
                                          <xsl:text> </xsl:text>
                                          <xsl:value-of select="."/>
                                       </xsl:for-each>
                                       <xsl:text>.</xsl:text>
                                    </xsl:if>
                                    <xsl:if test="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:imprint/tei:date">
                                       <xsl:text> </xsl:text>
                                       <xsl:value-of select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:imprint/tei:date"/>
                                       <xsl:text>.</xsl:text>
                                    </xsl:if>

                                 </xsl:when>

                                 <xsl:when test="$bibtype='ser_mo'">
                                   <!-- DEBUG: <div>Type: ser_mo</div>-->
                                    <!--**** Authors ****-->
                                    <xsl:for-each select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:author/tei:surname">
                                       <xsl:if test="position()&gt;1">, </xsl:if>
                                       <xsl:value-of select="."/>
                                    </xsl:for-each>
                                    <xsl:text>: </xsl:text>

                                    <!--**** Title ****-->
                                    <xsl:choose>
                                      <xsl:when test="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:title[@type='short']">
                                         <xsl:value-of select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:title[@type='short']"/>
                                      </xsl:when>
                                      <xsl:otherwise>
                                         <xsl:value-of select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:title[1]"/>
                                      </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:text>. In: </xsl:text>

                                    <!--**** Series ****-->
                                    <xsl:value-of select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:series/tei:title[1]"/>
                                    <xsl:text>.</xsl:text>
                                    <xsl:if test="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:series/tei:biblScope">
                                       <xsl:for-each select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:series/tei:biblScope">
                                          <xsl:if test="position()&gt;1">, </xsl:if>
                                          <xsl:value-of select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:series/tei:biblScope"/>
                                       </xsl:for-each>
                                       <xsl:text>.</xsl:text>
                                    </xsl:if>
                                 </xsl:when>

                                 <xsl:otherwise><span style="color:red">unidentified bibl-rec type: </span> <xsl:value-of select="$bibtype"/> <xsl:value-of select="string-length($bibtype)"/> </xsl:otherwise>
                              </xsl:choose>

<!--                             <xsl:value-of select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:analytic/tei:author/tei:surname"/>
                             <xsl:value-of select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:author/tei:surname"/>

                             <xsl:text>: </xsl:text>

                             <xsl:choose>
                                <xsl:when test="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:analytic/tei:title[@type='short']">
                                   <xsl:value-of select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:analytic/tei:title"/>
                                   <xsl:text>.</xsl:text>
                                </xsl:when>
                                <xsl:when test="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr">
                                   <xsl:value-of select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:title[1]"/>
                                   <xsl:text>.</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                   <xsl:value-of select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:analytic/tei:title[1]"/>
                                   <xsl:text>.</xsl:text>
                                </xsl:otherwise>
                             </xsl:choose>


                             <xsl:if test="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr">
                                <xsl:if test="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:analytic">
                                   <xsl:text> In: </xsl:text>
                                </xsl:if>
                                <xsl:value-of select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:title"/>
                                <xsl:if test="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:imprint/tei:biblScope[@unit='volume']">
                                   <xsl:value-of select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:imprint/tei:biblScope[@unit='volume']"/>
                                   <xsl:text>.</xsl:text>
                                </xsl:if>
                                <xsl:if test="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:imprint/tei:biblScope[@unit='issue']">
                                   <xsl:value-of select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:imprint/tei:biblScope[@unit='issue']"/>
                                   <xsl:text>.</xsl:text>
                                </xsl:if>
                                <xsl:if test="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:imprint/tei:biblScope[@unit='page']">
                                   <xsl:value-of select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:imprint/tei:biblScope[@unit='page']"/>
                                   <xsl:text>.</xsl:text>
                                </xsl:if>
                                <xsl:if test="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:date">
                                   <xsl:value-of select="$zotDoc//tei:biblStruct[@xml:id=$id]/tei:monogr/tei:date"/>
                                   <xsl:text>.</xsl:text>
                                </xsl:if>
                             </xsl:if>
                             -->
                            </xsl:otherwise>
                        </xsl:choose>
                     </xsl:otherwise>
                  </xsl:choose>


               </td>
            </tr>

            <xsl:if test="tei:cit[@type='sourceRepresentation']">
              <tr>
                 <td class="tdLeft">Or. src.</td>
                 <td class="tdRight">
                    <xsl:for-each select="tei:cit[@type='sourceRepresentation']">
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

            <tr>
               <td class="tdLeft">Place</td>
               <td class="tdRight">
                   <xsl:for-each select="tei:placeName">
                      <xsl:variable name="id"><xsl:value-of select="substring(@ref,5)"/></xsl:variable>
                      <xsl:if test="position()&gt;1">, </xsl:if>
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
                 <td class="tdLeft">Persongrp.</td>
                 <td class="tdRight">
                    <xsl:for-each select="tei:personGrp">
                       <div>
                          <xsl:variable name="id"><xsl:value-of select="substring(@corresp,5)"/></xsl:variable>
                          <xsl:value-of select="$prgDoc//tei:personGrp[@xml:id=$id]/tei:name"/>
                            (<xsl:value-of select="@role"/>:
                               <xsl:for-each select="$prgDoc//tei:personGrp[@xml:id=$id]/tei:residence/tei:placeName">
                                  <xsl:if test="position()&gt;1">, </xsl:if>
                                  <xsl:variable name="placeID"><xsl:value-of select="substring(@ref,5)"/></xsl:variable>
                                  <xsl:value-of select="$geoDoc//tei:place[@xml:id=$placeID]/tei:placeName"/>
                               </xsl:for-each>)

                       </div>
                    </xsl:for-each>
                 </td>
              </tr>
            </xsl:if>

            <xsl:if test="tei:note">
              <tr>
                 <td class="tdLeft">Notes</td>
                 <td class="tdRight">
                    <xsl:for-each select="tei:note">
                       <div class="dvNoteHead">
                          <xsl:value-of select="@type"/>
                       </div>

                       <div class="dvNote"><xsl:apply-templates/></div>
                    </xsl:for-each>
                 </td>
              </tr>
            </xsl:if>

            <xsl:if test="tei:lang">
              <tr>
                 <td class="tdLeft">Profiles</td>
                 <td class="tdRight">
                    <xsl:for-each select="tei:lang">
                    <div><xsl:value-of select="@target"/></div>
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

         </table>
      </div>
   </xsl:template>

   <xsl:template match="tei:divGen[@type='featureValues']">
      <div>
         <table>
            <xsl:for-each select="//tei:list[@type='featureValues']/tei:item">
                <tr>
                   <td><xsl:value-of select="@xml:id"/></td>
                   <td><xsl:value-of select="tei:label"/></td>
                   <td><xsl:value-of select="tei:desc"/></td>
                </tr>
             </xsl:for-each>
           </table>
      </div>
   </xsl:template>

   <xsl:template match="tei:change"/>
   <xsl:template match="tei:desc"/>
   <xsl:template match="tei:fsDescr"/>
   <xsl:template match="tei:cit"/>
   <xsl:template match="tei:header"/>
   <xsl:template match="tei:note"/>
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
