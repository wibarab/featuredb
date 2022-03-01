xquery version "3.0"; 

declare default element namespace "http://www.tei-c.org/ns/1.0";

let $v := unparsed-text("dialects.txt")
let $fs := 
    for $line in tokenize($v,'\n')
    where normalize-space($line) != '' and not(starts-with(normalize-space($line),'#'))
    let $id := translate(replace(normalize-space($line), '\P{IsBasicLatin}', ''),';-() ,','')
    order by $id ascending
    return 
    
     <fs type="dialect" xml:id="{$id}">
            <f name="name"><string>{normalize-space($line)}</string></f>
    </fs>

return
document{
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml" schematypens="http://relaxng.org/ns/structure/1.0"?>,
<?xml-model href="http://www.tei-c.org/release/xml/tei/custom/schema/relaxng/tei_all.rng" type="application/xml"
	schematypens="http://purl.oclc.org/dsdl/schematron"?>,
<TEI xmlns="http://www.tei-c.org/ns/1.0">
   <teiHeader>
      <fileDesc>
         <titleStmt>
            <title>Title</title>
         </titleStmt>
         <publicationStmt>
            <p>Publication Information</p>
         </publicationStmt>
         <sourceDesc>
            <p>Information about the source</p>
         </sourceDesc>
      </fileDesc>
   </teiHeader>
   <text>
      <body>
         <head>WIBARAB dialects lists</head>
         <p>This file contains a list of all dialects in investigated in the WIBARAB project.</p>
         <fvLib>{$fs}</fvLib>
         </body>
         </text>
         </TEI>}