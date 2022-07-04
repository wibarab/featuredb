<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0" version="1.0" xml:space="preserve">

   <xsl:output method="html"/>
   <xsl:template match="/">
      <html>
         <head>
            <style type="text/css">
               body {
                  font-size: 14pt;
               }

               table {
               border-collapse: collapse;
               }

               td {
               border: 1px solid black;
               vertical-align: top;
               padding-left: 3px;
               padding:right: 3px;
               }

               .tdHead {
               background: rgb(184, 126, 172);
               color: white;
               }
            </style>
         </head>

         <body>
            <h3>Places</h3>
            <p>Number of places: <xsl:value-of select="count(//tei:place)"/></p>

            <table>
               <tr>
                  <td class="tdHead">Placename</td>
                  <td class="tdHead">Country</td>
                  <td class="tdHead">Type</td>
                  <td class="tdHead">Coordinates</td>
                  <td class="tdHead">Geonames ID</td>
               </tr>

               <xsl:for-each select="//tei:place">
                  <xsl:sort select="@type"/>
                  <xsl:sort select="tei:location/tei:country"/>
                  <xsl:sort select="tei:placeName"/>

                  <tr>
                     <td style="background:rgb(239,239,239)">
                        <a href="goto:{@xml:id}">
                           <xsl:value-of select="tei:placeName"/>
                        </a>
                     </td>

                     <td><xsl:value-of select="tei:location/tei:country"/></td>
                     <td><xsl:value-of select="@type"/></td>
                     <td><xsl:value-of select="tei:location/tei:geo[@decls='#dd']"/></td>
                     <td><xsl:value-of select="tei:idno"/></td>
                  </tr>
               </xsl:for-each>
            </table>
         </body>
      </html>
   </xsl:template>
</xsl:stylesheet>
