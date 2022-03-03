<xsl:stylesheet xml:space="preserve" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0" exclude-result-prefixes="xsl tei">
   <xsl:output method="html" indent="no" encoding="UTF-8"/>
   <xsl:strip-space elements="tei:body tei:TEI tei:row tei:cell tei:teiHeader tei:text tei:u tei:hi tei:ref tei:p tei:fileDesc tei:titleStmt tei:publicationStmt tei:editionStmt tei:revisionDesc tei:sourceDesc tei:div"/>

   <xsl:variable name="title">
      <xsl:value-of select="//tei:titleStmt/tei:title"/>
   </xsl:variable>

   <xsl:template match="/">
      <html>
         <xsl:comment>This is a generated page, do not edit!</xsl:comment>
         <xsl:comment>XSLT: course_contents.xsl</xsl:comment>
         <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
            <link rel="stylesheet" href="../css/grammar__001.css"></link>
            <script src="jsfuncs.js"></script>
         </head>

         <body>
            <xsl:apply-templates select="@*|node()"/>
         </body>

      </html>
   </xsl:template>


   <xsl:template match="tei:ab">
      <p class="pSimple"><xsl:apply-templates/></p>
   </xsl:template>

   <xsl:template match="tei:biblStruct">
      <div class="note">
         <xsl:if test="@type='book'">
            <xsl:value-of select=".//tei:surname"/>, <xsl:value-of select=".//tei:forename"/>: <xsl:value-of select=".//tei:title"/>.
            <xsl:if test=".//tei:publisher"><xsl:value-of select=".//tei:publisher"/>. </xsl:if>
            <xsl:if test=".//tei:pubPlace"><xsl:value-of select=".//tei:pubPlace"/>. </xsl:if>
            <xsl:if test=".//tei:date"><xsl:value-of select=".//tei:date"/>. </xsl:if>
         </xsl:if>
      </div>
   </xsl:template>

   <xsl:template match="tei:cell">
      <td>
         <xsl:if test="@rows">
            <xsl:attribute name="rowspan">
               <xsl:value-of select="@rows"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:if test="@cols">
            <xsl:attribute name="colspan">
               <xsl:value-of select="@cols"/>
            </xsl:attribute>
         </xsl:if>

         <xsl:if test="@style">
            <xsl:attribute name="style"><xsl:value-of select="@style"/></xsl:attribute>
         </xsl:if>

         <xsl:choose>
            <xsl:when test="@xml:lang='zu' or @xml:lang='sw'">
               <xsl:attribute name="class">tdZulu</xsl:attribute>
            </xsl:when>
            <xsl:when test="@role = 'tableHead'">
               <xsl:attribute name="class">tdTableHead</xsl:attribute>
            </xsl:when>
            <xsl:when test="@role = 'tableHeadLeft'">
               <xsl:attribute name="class">tdTableHeadLeft</xsl:attribute>
            </xsl:when>
            <xsl:when test="@role = 'leftColumn'">
               <xsl:attribute name="class">tdTableHead</xsl:attribute>
            </xsl:when>
            <xsl:when test="@role = 'leftColumn_a'">
               <xsl:attribute name="class">tdTableHead_a</xsl:attribute>
            </xsl:when>
            <xsl:when test="@role = 'leftColumn_b'">
               <xsl:attribute name="class">tdTableHead_b</xsl:attribute>
            </xsl:when>
            <xsl:when test="@role = 'separator'">
               <xsl:attribute name="class">tdSeparator</xsl:attribute>
            </xsl:when>
            <xsl:when test="@role = 'label'">
               <xsl:attribute name="class">tdLabel</xsl:attribute>
            </xsl:when>
         </xsl:choose>
         <xsl:apply-templates select="node()"/>
      </td>
   </xsl:template>

   <xsl:template match="tei:div">
      <xsl:variable name="depth" select="count(ancestor::tei:div)"/>
      <xsl:choose>
         <xsl:when test="$depth=0"><div id="{@xml:id}" class="dv0"><xsl:apply-templates/></div></xsl:when>
         <xsl:when test="$depth=1"><div id="{@xml:id}" class="dv1"><xsl:apply-templates/></div></xsl:when>
         <xsl:when test="$depth=2"><div id="{@xml:id}" class="dv2"><xsl:apply-templates/></div></xsl:when>
         <xsl:when test="$depth=3"><div id="{@xml:id}" class="dv3"><xsl:apply-templates/></div></xsl:when>
         <xsl:when test="$depth=4"><div id="{@xml:id}" class="dv4"><xsl:apply-templates/></div></xsl:when>
         <xsl:when test="$depth=5"><div id="{@xml:id}" class="dv5"><xsl:apply-templates/></div></xsl:when>
         <xsl:otherwise><div n="{$depth}"><xsl:apply-templates/></div></xsl:otherwise>
      </xsl:choose>
   </xsl:template>

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
         <xsl:when test="$depth=0">
            <h1><xsl:apply-templates/></h1>
         </xsl:when>

         <xsl:when test="$depth=1">
            <xsl:variable name="num1"><xsl:value-of select="count(parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
            <div class="head1"><a href="goto:{$sid}"><!--<xsl:value-of select="$num1"/><xsl:text> </xsl:text>--> <xsl:apply-templates/></a></div></xsl:when>

         <xsl:when test="$depth=2">
            <xsl:variable name="num1"><xsl:value-of select="count(parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
            <xsl:variable name="num2"><xsl:value-of select="count(parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
            <div class="head2"><a href="goto:{$sid}"><!--<xsl:value-of select="concat($num1, '.', $num2)"/>
                  <xsl:text> </xsl:text>--> <xsl:apply-templates/></a></div>
         </xsl:when>

         <xsl:when test="$depth=3">
            <xsl:variable name="num1"><xsl:value-of select="count(parent::tei:div/parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
            <xsl:variable name="num2"><xsl:value-of select="count(parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
            <xsl:variable name="num3"><xsl:value-of select="count(parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
            <div class="head3"><a href="goto:{$sid}"><xsl:value-of select="concat($num1, '.', $num2, '.', $num3)"/>
                  <xsl:text> </xsl:text>
                  <xsl:apply-templates/></a></div>
         </xsl:when>

         <xsl:when test="$depth=4">
            <xsl:variable name="num1"><xsl:value-of select="count(parent::tei:div/parent::tei:div/parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
            <xsl:variable name="num2"><xsl:value-of select="count(parent::tei:div/parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
            <xsl:variable name="num3"><xsl:value-of select="count(parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
            <xsl:variable name="num4"><xsl:value-of select="count(parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
            <div class="head4"><a href="goto:{$sid}">
                  <xsl:value-of select="concat($num1, '.', $num2, '.', $num3, '.', $num4)"/>
                  <xsl:text> </xsl:text>
                  <xsl:apply-templates/></a></div>
         </xsl:when>

         <xsl:when test="$depth=5">
            <div class="head5"><a href="goto:{$sid}">
                  <xsl:variable name="num1"><xsl:value-of select="count(parent::tei:div/parent::tei:div/parent::tei:div/parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
                  <xsl:variable name="num2"><xsl:value-of select="count(parent::tei:div/parent::tei:div/parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
                  <xsl:variable name="num3"><xsl:value-of select="count(parent::tei:div/parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
                  <xsl:variable name="num4"><xsl:value-of select="count(parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
                  <xsl:variable name="num5"><xsl:value-of select="count(parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
                  <xsl:value-of select="concat($num1, '.', $num2, '.', $num3, '.', $num4, '.', $num5)"/>
                  <xsl:text> </xsl:text>
                  <xsl:apply-templates/></a></div>
         </xsl:when>

         <xsl:when test="$depth=6">
            <div class="head6"><a href="goto:{$sid}">
                  <xsl:variable name="num1"><xsl:value-of select="count(parent::tei:div/parent::tei:div/parent::tei:div/parent::tei:div/parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
                  <xsl:variable name="num2"><xsl:value-of select="count(parent::tei:div/parent::tei:div/parent::tei:div/parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
                  <xsl:variable name="num3"><xsl:value-of select="count(parent::tei:div/parent::tei:div/parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
                  <xsl:variable name="num4"><xsl:value-of select="count(parent::tei:div/parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
                  <xsl:variable name="num5"><xsl:value-of select="count(parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
                  <xsl:variable name="num6"><xsl:value-of select="count(parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
                  <xsl:value-of select="concat($num1, '.', $num2, '.', $num3, '.', $num4, '.', $num5, '.', $num6)"/>
                  <xsl:text> </xsl:text>
                  <xsl:apply-templates/></a></div>
         </xsl:when>
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
   <xsl:template match="tei:hi[@rend = 'bold_green']">
      <span style="color:rgb(255,144,33);background:white; border:0.5px solid black"><b><xsl:apply-templates/></b></span>
   </xsl:template>
   <xsl:template match="tei:hi[@rend = 'red_white']">
      <span style="color:white;background:red; border:0.5px solid black"><b><xsl:apply-templates/></b></span>
   </xsl:template>
   <xsl:template match="tei:hi[@rend = 'bold']">
      <b><xsl:apply-templates/></b>
   </xsl:template>
   <xsl:template match="tei:hi[@rend = 'italics']">
      <i><xsl:apply-templates/></i>
   </xsl:template>

   <xsl:template match="tei:item[tei:biblStruct]">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="tei:item">
      <li><xsl:apply-templates/></li>
   </xsl:template>

   <xsl:template match="tei:lb">
      <br/>
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

   <xsl:template match="tei:list[@type = 'tocItems' or @type = 'tocItems_sec' or @type='tocItems_exercises' or @type='tocItems_texts']">
      <table class="{@type}">
         <tr><td colspan="2" class="tocItemHead">
               <xsl:choose>
               <xsl:when test="@type='tocItems'">Textbook</xsl:when>
               <xsl:when test="@type='tocItems_sec'">Grammar Items</xsl:when>
               <xsl:when test="@type='tocItems_exercises'">Exercises</xsl:when>
               <xsl:when test="@type='tocItems_texts'">Texts / Reading</xsl:when>
               </xsl:choose>
            </td></tr>
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

   <xsl:template match="tei:p">
      <p><xsl:apply-templates/></p>
   </xsl:template>

   <xsl:template match="tei:ptr[@type = 'contPointer']">
      <a class="aLink">
         <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
         <span class="spArrow">GO →</span>
      </a>
   </xsl:template>

   <xsl:template match="tei:ref">
      <xsl:choose>
         <xsl:when test="@target and not(contains(@target,'(hide)'))">
            <a>
               <xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute>
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

   <xsl:template match="tei:note">
      <span class="note"><xsl:apply-templates/></span>
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

   <xsl:template match="tei:header"/>
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
