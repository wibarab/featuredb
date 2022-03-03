<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="xs" version="2.0">
	<xsl:output method="html" indent="yes" encoding="UTF-8"/>
	<xsl:template match="/">
		<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
				<style>
               table {
               border: 1px dotted black;
               border-collapse: collapse;
               background: rgb(237,234,255);
               margin-left: 20px;
               font-size: 14px;
               }

               td {
               border-collapse: collapse;
               border: 1px dotted black;
               }

               .td1 { font-size: 16pt; text-indent: 5px; padding-top: 15px; }
               .td2 { font-size: 14pt; text-indent: 15px; padding-top: 15px; }
               .td3 { text-indent: 25px; }
               .td4 { text-indent: 35px; }
               .td5 { text-indent: 45px; }
               .td6 { text-indent: 55px; }
            </style>
			</head>
			<body>
				<table>
					<xsl:for-each select="//tei:head[not(@type='imgCaption')]">
						<xsl:variable name="depth" select="count(ancestor::tei:div)"/>
						<tr>
							<!-- <td><xsl:value-of select="$depth"/></td> -->
							<xsl:variable name="sid" select="ancestor::tei:div[1]/@xml:id"/>
							<xsl:attribute name="href">goto:<xsl:value-of select="$sid"/></xsl:attribute>
							<td>
								<xsl:choose>
									<xsl:when test="$depth=1">
										<xsl:attribute name="class">td1</xsl:attribute>
										<a>
											<xsl:attribute name="href">goto:<xsl:value-of select="$sid"/></xsl:attribute>
											<xsl:variable name="num1"><xsl:value-of select="count(parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
											<xsl:value-of select="$num1"/>
											<xsl:text>
											</xsl:text>
											<xsl:value-of select="."/>
										</a>
									</xsl:when>
									<xsl:when test="$depth=2">
										<xsl:attribute name="class">td2</xsl:attribute>
										<a>
											<xsl:attribute name="href">goto:<xsl:value-of select="$sid"/></xsl:attribute>
											<xsl:variable name="num1"><xsl:value-of select="count(parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
											<xsl:variable name="num2"><xsl:value-of select="count(parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
											<xsl:value-of select="concat($num1, '.', $num2)"/>
											<xsl:text>
											</xsl:text>
											<xsl:value-of select="."/>
										</a>
									</xsl:when>
									<xsl:when test="$depth=3">
										<xsl:attribute name="class">td3</xsl:attribute>
										<a>
											<xsl:attribute name="href">goto:<xsl:value-of select="$sid"/></xsl:attribute>
											<xsl:variable name="num1"><xsl:value-of select="count(parent::tei:div/parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
											<xsl:variable name="num2"><xsl:value-of select="count(parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
											<xsl:variable name="num3"><xsl:value-of select="count(parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
											<xsl:value-of select="concat($num1, '.', $num2, '.', $num3)"/>
											<xsl:text>
											</xsl:text>
											<xsl:value-of select="."/>
										</a>
									</xsl:when>
									<xsl:when test="$depth=4">
										<xsl:attribute name="class">td4</xsl:attribute>
										<a>
											<xsl:attribute name="href">goto:<xsl:value-of select="$sid"/></xsl:attribute>
											<xsl:variable name="num1"><xsl:value-of select="count(parent::tei:div/parent::tei:div/parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
											<xsl:variable name="num2"><xsl:value-of select="count(parent::tei:div/parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
											<xsl:variable name="num3"><xsl:value-of select="count(parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
											<xsl:variable name="num4"><xsl:value-of select="count(parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
											<xsl:value-of select="concat($num1, '.', $num2, '.', $num3, '.', $num4)"/>
											<xsl:text>
											</xsl:text>
											<xsl:value-of select="."/>
										</a>
									</xsl:when>
									<xsl:when test="$depth=5">
										<xsl:attribute name="class">td5</xsl:attribute>
										<a>
											<xsl:attribute name="href">goto:<xsl:value-of select="$sid"/></xsl:attribute>
											<xsl:variable name="num1"><xsl:value-of select="count(parent::tei:div/parent::tei:div/parent::tei:div/parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
											<xsl:variable name="num2"><xsl:value-of select="count(parent::tei:div/parent::tei:div/parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
											<xsl:variable name="num3"><xsl:value-of select="count(parent::tei:div/parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
											<xsl:variable name="num4"><xsl:value-of select="count(parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
											<xsl:variable name="num5"><xsl:value-of select="count(parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
											<xsl:value-of select="concat($num1, '.', $num2, '.', $num3, '.', $num4, '.', $num5)"/>
											<xsl:text>
											</xsl:text>
											<xsl:value-of select="."/>
										</a>
									</xsl:when>
									<xsl:when test="$depth=6">
										<xsl:attribute name="class">td6</xsl:attribute>
										<a>
											<xsl:attribute name="href">goto:<xsl:value-of select="$sid"/></xsl:attribute>
											<xsl:variable name="num1"><xsl:value-of select="count(parent::tei:div/parent::tei:div/parent::tei:div/parent::tei:div/parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
											<xsl:variable name="num2"><xsl:value-of select="count(parent::tei:div/parent::tei:div/parent::tei:div/parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
											<xsl:variable name="num3"><xsl:value-of select="count(parent::tei:div/parent::tei:div/parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
											<xsl:variable name="num4"><xsl:value-of select="count(parent::tei:div/parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
											<xsl:variable name="num5"><xsl:value-of select="count(parent::tei:div/parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
											<xsl:variable name="num6"><xsl:value-of select="count(parent::tei:div/preceding-sibling::tei:div)+1"/></xsl:variable>
											<xsl:value-of select="concat($num1, '.', $num2, '.', $num3, '.', $num4, '.', $num5, '.', $num6)"/>
											<xsl:text>
											</xsl:text>
											<xsl:value-of select="."/>
										</a>
									</xsl:when>
								</xsl:choose>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
