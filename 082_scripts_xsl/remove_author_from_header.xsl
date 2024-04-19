<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                exclude-result-prefixes="tei">

    <xsl:output method="xml" indent="yes"/>

    <!-- Identity transformation template: copies everything as is -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- Template that matches and removes the author element within teiHeader -->
    <xsl:template match="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author"/>


    <!-- Remove whitespace surrounding the author element -->
    <xsl:template match="tei:teiHeader/tei:fileDesc/tei:titleStmt/text()[following-sibling::tei:author][last()]">
        <!-- Do nothing -->
    </xsl:template>
    
</xsl:stylesheet>

