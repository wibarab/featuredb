<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0" xmlns:l="https://wibarab.acdh.oeaw.ac.at/langDesc" exclude-result-prefixes="tei">
   <xsl:output method="xml" indent="yes" encoding="UTF-8" omit-xml-declaration="no" />
   
   <xsl:template match="@* | node()">
      <xsl:copy><xsl:apply-templates select="@* | node()"/></xsl:copy>
   </xsl:template>
   
   <xsl:template match="tei:body">          
      <xsl:copy>
         <xsl:attribute name="xml:base"><xsl:value-of select="@xml:base"/></xsl:attribute>
         <div type="featureDescription">
            <head>Feature Values</head>            
            <list type="featureValues" xml:space="preserve">
               <xsl:for-each select="//tei:fvLib/tei:fs">
                  <item xml:id="{@xml:id}">
                     <label></label>
                     <p><xsl:value-of select="tei:f[@name='explanation']"/></p>
                  </item>
               </xsl:for-each>
            </list>
         </div>
         <xsl:apply-templates select="node()"/></xsl:copy>
   </xsl:template>
   
   <xsl:template match="tei:div[@type='featureRealisations']">
      <div type="featureValueObservations" xml:space="preserve">
         <xsl:for-each select="tei:fs">
            <l:featureValueObservation cert="high" status="draft"><xsl:attribute name="xml:id"><xsl:value-of select="@xml:id"/></xsl:attribute><xsl:attribute name="source"><xsl:value-of select="@source"/></xsl:attribute><xsl:attribute name="fVal"><xsl:value-of select=""/></xsl:attribute><xsl:attribute name="ana"><xsl:value-of select="tei:f[@name='dialect']/@fVal"/></xsl:attribute><xsl:attribute name="resp">dmp:???</xsl:attribute>
               <name type="featureValue"><xsl:attribute name="ref"><xsl:value-of select="tei:f[@name='realisationType']/@fVal"/></xsl:attribute></name>
               <bibl corresp="{@source}" type="personalCommunication">
                   <title></title>
                   <biblScope unit="page"></biblScope>                       
                </bibl>
               <date></date>
               <personGrp type="tribe"></personGrp>
               <personGrp type="religious"></personGrp>
               <personGrp type="agrGroup"><age>ancient</age></personGrp>
               <usg type="etym">MSA</usg>
               <usg type="time"></usg>
               <note>Exception: čān - yikūn; there is desaffrication when in contact with coronal consonants [d], [t], [ḏ], [t],̱ [t]̣ et [ḏ̣ ]</note>
               
               <xsl:for-each select="tei:f[@name='example']"></xsl:for-each>               
            </l:featureValueObservation>
         </xsl:for-each>
      </div>
   </xsl:template>          
</xsl:stylesheet>
