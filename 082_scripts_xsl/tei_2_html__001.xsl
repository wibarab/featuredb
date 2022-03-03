<xsl:stylesheet xml:space="preserve" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0" exclude-result-prefixes="xsl tei">
   <xsl:output method="html" indent="no" encoding="UTF-8"/>
   <xsl:strip-space elements="tei:body tei:TEI tei:row tei:cell tei:teiHeader tei:text tei:u tei:hi tei:ref tei:p tei:fileDesc tei:titleStmt tei:publicationStmt tei:editionStmt tei:revisionDesc tei:sourceDesc tei:div"/>

   <xsl:variable name="basePath">{basePath}</xsl:variable>

   <xsl:variable name="title">
      <xsl:value-of select="//tei:titleStmt/tei:title"/>
   </xsl:variable>

   <xsl:template match="/">
      <html>
         <xsl:comment>This is a generated page, do not edit!</xsl:comment>
         <xsl:comment>XSLT: tei_2_html__simple_text.xsl</xsl:comment>
         <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
            <link rel="stylesheet" href="../css/basic__001.css"></link>
         </head>

         <body>
            <xsl:apply-templates select="@*|node()"/>
         </body>

      </html>
   </xsl:template>


   <xsl:template match="tei:annotationBlock[@who='Transcription']">
      <div class="pTranscription"><xsl:apply-templates/></div>
   </xsl:template>

   <xsl:template match="tei:annotationBlock[@who='Translation']">
      <div class="pTranslation"><xsl:apply-templates/></div>
   </xsl:template>

   <xsl:template match="tei:ab">
      <p class="pSimple"><xsl:apply-templates/></p>
   </xsl:template>

   <xsl:template match="tei:cell">
      <td><xsl:apply-templates/></td>
   </xsl:template>

   <xsl:template match="tei:div"><p><xsl:apply-templates/></p></xsl:template>

   <xsl:template match="tei:figure">
      <img src="{tei:graphic/@url}" alt="{tei:graphic/@url}"/>
      <div>
         <a href="{tei:head/tei:ref/@target}"><xsl:value-of select="tei:head/tei:ref"/></a>
      </div>
   </xsl:template>

   <xsl:template match="tei:head">
      <xsl:variable name="depth" select="count(ancestor::tei:div)"/>
      <xsl:variable name="sid" select="parent::tei:div/@xml:id"/>
      <xsl:choose>
         <xsl:when test="$depth=1"><h1><xsl:apply-templates/></h1></xsl:when>
         <xsl:when test="$depth=2"><h2><xsl:apply-templates/></h2></xsl:when>
         <xsl:when test="$depth=3"><h3><xsl:apply-templates/></h3></xsl:when>
         <xsl:when test="$depth=4"><h4><xsl:apply-templates/></h4></xsl:when>
         <xsl:when test="$depth=5"><h5><xsl:apply-templates/></h5></xsl:when>
         <xsl:when test="$depth=6"><h6><xsl:apply-templates/></h6></xsl:when>
         <xsl:otherwise><h1><xsl:apply-templates/></h1></xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="tei:hi[@rend = 'contrast']">
      <span class="contrast"><xsl:apply-templates/></span>
   </xsl:template>

   <xsl:template match="tei:hi[@rend = 'red']">
      <span style="color:red"><xsl:apply-templates/></span>
   </xsl:template>
   <xsl:template match="tei:hi[@rend = 'blue']">
      <span style="color:blue"><xsl:apply-templates/></span>
   </xsl:template>
   <xsl:template match="tei:hi[@rend = 'green']">
      <span style="color:green"><xsl:apply-templates/></span>
   </xsl:template>
   <xsl:template match="tei:hi[@rend = 'white_green']">
      <span style="color:white;background:rgb(17, 132, 78); border:0.5px solid black"><b><xsl:apply-templates/></b></span>
   </xsl:template>
   <xsl:template match="tei:hi[@rend = 'bold_green']">
      <span style="color:rgb(255,144,33);background:white; border:0.5px solid black"><b><xsl:apply-templates/></b></span>
   </xsl:template>
   <xsl:template match="tei:hi[@rend = 'red_white']">
      <span style="color:white;background:rgb(255, 136, 136); border:0.5px solid black"><b><xsl:apply-templates/></b></span>
   </xsl:template>
   <xsl:template match="tei:hi[@rend = 'bold']">
      <b><xsl:apply-templates/></b>
   </xsl:template>
   <xsl:template match="tei:hi[@rend = 'italics']">
      <i><xsl:apply-templates/></i>
   </xsl:template>
   <xsl:template match="tei:foreign">
      <i><xsl:apply-templates/></i>
   </xsl:template>

   <xsl:template match="tei:item[tei:biblStruct]">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="tei:item">
      <li><xsl:apply-templates/></li>
   </xsl:template>

   <xsl:template match="tei:l">
      <xsl:apply-templates/><br/>
   </xsl:template>

   <xsl:template match="tei:lb">
      <br/>
   </xsl:template>

   <xsl:template match="tei:lg">
      <p><xsl:apply-templates/></p>
   </xsl:template>

   <xsl:template match="tei:list[@type = 'ul']">
      <ul>
         <xsl:apply-templates/>
      </ul>
   </xsl:template>

   <xsl:template match="tei:list[@type = 'ol']">
      <ol>
         <xsl:apply-templates/>
      </ol>
   </xsl:template>

   <xsl:template match="tei:list[@type = 'tocItems' or @type = 'tocItems_sec' or @type = 'tocItems_exercises' ]">
      <table class="{@type}">
         <xsl:for-each select="tei:item">
            <tr>
               <td>
                  <xsl:apply-templates/>
               </td>
            </tr>
         </xsl:for-each>
      </table>
   </xsl:template>

   <xsl:template match="tei:list[@type = 'links']">
      <table class="tbLinkItem">
         <xsl:for-each select="tei:item">
            <tr>
               <td class="tdLinkItem">
                  <xsl:value-of select="tei:ref"/>
               </td>
               <td class="tdLinkItem">
                  <a class="aLink"><xsl:attribute name="href">
                        <xsl:value-of select="(root()//@xml:base)[1]"/><xsl:value-of select="tei:ref/@target"/></xsl:attribute>→</a>
               </td>
            </tr>
         </xsl:for-each>
      </table>
   </xsl:template>

   <xsl:template match="tei:list[@type = 'links']/tei:item"/>

   <xsl:template match="tei:p"><p><xsl:apply-templates/></p></xsl:template>

   <xsl:template match="tei:w | tei:seg | tei:pc">
      <span class="w">
         <xsl:apply-templates/>
         <xsl:if test="not(@join='right')"><span> </span></xsl:if>
      </span></xsl:template>

   <xsl:template match="tei:u[@xml:lang='ar']">
      <div class="pAr"><xsl:apply-templates/></div>
   </xsl:template>

   <xsl:template match="tei:u[not(@xml:lang='ar')]">
      <p class="pNorm"><xsl:apply-templates/></p>
   </xsl:template>

   <xsl:template match="tei:ptr[@type = 'contPointer']">
      <a class="aLink" href="{target}"><span class="spArrow">GOO →</span></a>
   </xsl:template>

   <xsl:template match="tei:ref">
      <xsl:choose>
         <xsl:when test="@target">
            <a href="{@target}">
               <xsl:apply-templates/>
            </a>
         </xsl:when>
         <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="tei:row">
      <tr><xsl:apply-templates/></tr>
   </xsl:template>

   <xsl:template match="tei:span[@type = 'step']">
      <span class="spStep">
         <xsl:apply-templates/>
      </span>
   </xsl:template>

   <xsl:template match="tei:table">
      <table><xsl:apply-templates/></table>
   </xsl:template>

   <xsl:template match="tei:note[@type='visible')]">
      <span class="note"><xsl:apply-templates/></span>
   </xsl:template>

   <xsl:template match="tei:list[@type = 'embeddedExamples']">
      <table class="embExTable">
         <xsl:for-each select="tei:item">
            <tr class="topLine">
               <td><xsl:apply-templates select="tei:u[@xml:lang='zu']"/>
                  <xsl:text> </xsl:text><i class="exampleTrans"><xsl:apply-templates select="tei:u[@xml:lang = 'en']"/></i>
                  <xsl:if test="string-length(tei:ref)&gt;0">
                     <xsl:text> </xsl:text>[<xsl:apply-templates select="tei:ref"/>]
                  </xsl:if>
               </td>
            </tr>
         </xsl:for-each>
      </table>
   </xsl:template>

   <xsl:template match="tei:list[@type = 'examples']">
      <table class="exTable">
         <xsl:for-each select="tei:item">
            <tr class="topLine">
               <td><xsl:apply-templates select="tei:u[@xml:lang='zu']"/>
                  <xsl:text> </xsl:text><i class="exampleTrans"><xsl:apply-templates select="tei:u[@xml:lang = 'en']"/></i>
                  <xsl:if test="string-length(tei:ref)&gt;0">
                     <xsl:text> </xsl:text>[<xsl:apply-templates select="tei:ref"/>]
                  </xsl:if>
               </td>
            </tr>
         </xsl:for-each>
      </table>
   </xsl:template>

   <!-- *********************************************************************-->
   <!--   FEATURE STRUCTURES ************************************************-->
   <!-- *********************************************************************-->
   <xsl:template match="tei:div[@type='description']">
   sss

      <xsl:for-each select="//node()">
         <xsl:value-of select="tei:string"/>
      </xsl:for-each>
   </xsl:template>

   <xsl:template match="tei:fs[@type='featureRealisationAssertion']">
      <div class="featureRealisation">
         <table>
            <tr>
               <td>Dialect</td>
               <td>
                  <xsl:variable name="dia_id"><xsl:value-of select="substring(tei:f[@name='dialect']/@fVal,2)"/></xsl:variable>
                  <xsl:variable name="fp"><xsl:value-of select="$basePath"/>/vicav_dialects.xml</xsl:variable>

                  <xsl:value-of select="document($fp)//tei:fs[@type='dialect'][@xml:id=$dia_id]/tei:f[@name='DialectName']/tei:string"/>
               </td>
            </tr>

            <tr>
               <td>Source</td>
               <td>
                  <xsl:variable name="id"><xsl:value-of select="substring(@source,2)"/></xsl:variable>
                  <xsl:variable name="fp"><xsl:value-of select="$basePath"/>/vicav_biblio_tei_zotero.xml</xsl:variable>
                  <xsl:value-of select="document($fp)//tei:biblStruct[@xml:id=$id]/tei:analytic/tei:title"/>
               </td>
            </tr>

            <tr>
               <td>Examples</td>
               <td>
                  <xsl:for-each select="tei:f[@name='example']">
                     <xsl:variable name="exID"><xsl:value-of select="substring(@fVal,2)"/></xsl:variable>
                     <xsl:value-of select="$exID"/>
                  </xsl:for-each>
               </td>
            </tr>
            <tr>
               <td>lexicalDomain</td>
               <td><xsl:value-of select="tei:f[@name='lexicalDomain']/tei:string"/></td>
            </tr>
         </table>
         <xsl:apply-templates/>
      </div>
   </xsl:template>

   <xsl:template match="tei:desc"/>
   <xsl:template match="tei:header"/>
   <xsl:template match="tei:note"/>
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
