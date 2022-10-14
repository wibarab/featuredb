<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="tei">
   <xsl:output method="xml" indent="yes" encoding="UTF-8" omit-xml-declaration="no" />
   <xsl:variable name="inFile">file:/C:/Users/kmoerth/ch_data/temp/wibarab-featuredb/102_derived_tei/vicav_geodata.xml</xsl:variable>
   
   <xsl:template match="@* | node()">
      <xsl:copy><xsl:apply-templates select="@* | node()"/></xsl:copy>
   </xsl:template>
   
   <xsl:template match="tei:note[@type='tag']">
      <xsl:choose>
         <xsl:when test="(starts-with(.,'geo:'))and(contains(.,'['))">
            <note type="tag">
               <xsl:variable name="v1"><xsl:value-of select="normalize-space(substring-after(substring-before(.,'['),':'))"/></xsl:variable>
               <name type="geo"><xsl:value-of select="$v1"/></name>
               <geo><xsl:value-of select="document($inFile)//tei:place[tei:placeName=$v1]/tei:location/tei:geo[@decls='#dd']"/></geo></note></xsl:when>
         
         <xsl:when test="(starts-with(.,'geo:'))and(not(contains(.,'[')))">
            <note type="tag">
               <xsl:variable name="v1"><xsl:value-of select="normalize-space(substring-after(.,':'))"/></xsl:variable>
               <name type="geo"><xsl:value-of select="$v1"/></name>
               <geo><xsl:value-of select="document($inFile)//tei:place[tei:placeName=$v1]/tei:location/tei:geo[@decls='#dd']"/></geo></note></xsl:when>
         
         <xsl:when test="(starts-with(.,'reg:'))and(contains(.,'['))">
            <note type="tag">
               <xsl:variable name="v1"><xsl:value-of select="normalize-space(substring-after(substring-before(.,'['),':'))"/></xsl:variable>
               <name type="geo"><xsl:value-of select="$v1"/></name>
               <geo><xsl:value-of select="document($inFile)//tei:place[tei:placeName=$v1]/tei:location/tei:geo[@decls='#dd']"/></geo></note></xsl:when>
         
         <xsl:when test="(starts-with(.,'reg:'))and(not(contains(.,'[')))">
            <note type="tag">
               <xsl:variable name="v1"><xsl:value-of select="normalize-space(substring-after(.,':'))"/></xsl:variable>
               <name type="geo"><xsl:value-of select="$v1"/></name>
               <geo><xsl:value-of select="document($inFile)//tei:place[tei:placeName=$v1]/tei:location/tei:geo[@decls='#dd']"/></geo></note></xsl:when>
         
         <xsl:when test="(starts-with(.,'diaGroup:'))and(contains(.,'['))">
            <note type="tag">
               <xsl:variable name="v1"><xsl:value-of select="normalize-space(substring-after(substring-before(.,'['),':'))"/></xsl:variable>
               <name type="diaGroup"><xsl:value-of select="$v1"/></name>
               <geo><xsl:value-of select="document($inFile)//tei:place[tei:placeName=$v1]/tei:location/tei:geo[@decls='#dd']"/></geo></note></xsl:when>
         
         <xsl:when test="(starts-with(.,'diaGroup:'))and(not(contains(.,'[')))">
            <note type="tag">
               <xsl:variable name="v1"><xsl:value-of select="normalize-space(substring-after(.,':'))"/></xsl:variable>
               <name type="diaGroup"><xsl:value-of select="$v1"/></name>
               <geo><xsl:value-of select="document($inFile)//tei:place[tei:placeName=$v1]/tei:location/tei:geo[@decls='#dd']"/></geo></note></xsl:when>

         <xsl:otherwise><xsl:copy-of select="."/></xsl:otherwise>
      </xsl:choose>
   </xsl:template>
  
</xsl:stylesheet>
