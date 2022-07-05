<xsl:stylesheet version="1.0" xmlns="http://www.tei-c.org/ns/1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0">
    <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes" indent="no"/>
    
    <xsl:template match="node()|@*">
        <fs xml:id="{id}" type="featureRealisation" source="zot:" xml:space="preserve">                        
            <f name="dialect"><xsl:attribute name="fVal"><xsl:value-of select="//cell[1]"/></xsl:attribute></f>
            
            <xsl:if test="string-length(//cell[2])&gt;0"><f name="attestedPlace"><xsl:attribute name="fVal"><xsl:value-of select="//cell[2]"/></xsl:attribute></f></xsl:if>
            <xsl:if test="string-length(//cell[3])&gt;0"><f name="attestedPlace"><xsl:attribute name="fVal"><xsl:value-of select="//cell[2]"/></xsl:attribute></f></xsl:if>
            
            <xsl:if test="//cell[5]='yes'"><f name="realisationType" fVal="#pr_s2c_ənti"/></xsl:if>
            <xsl:if test="//cell[6]='yes'"><f name="realisationType" fVal="#pr_s2c_inti"/></xsl:if>
            <xsl:if test="//cell[7]='yes'"><f name="realisationType" fVal="#pr_s2c_inte"/></xsl:if>
            <xsl:if test="//cell[8]='yes'"><f name="realisationType" fVal="#pr_s2c_ant"/></xsl:if>
            <xsl:if test="//cell[9]='yes'"><f name="realisationType" fVal="#pr_s2c_inta"/></xsl:if>
        </fs>
        
        
    </xsl:template>
    
    <xsl:template match="tei:table"><xsl:apply-templates select="node()|@*"/></xsl:template>
    
</xsl:stylesheet>
