# WIBARAB feature database

## About WIBARAB

WIBARAB is a very nice project in the field of Arabic dialectology. It consists of various regional sub-projects (four PhD projects) and a large database about bedouin-type dialects of Arabic.

The *Feature Database* will be the main point of integrating the results of the sub-projects. In this repository we collect the primary data of the database in TEI/XML.


Principal Investigator: Stephan Procházka (University of Vienna)     
National Cooperation Partner: Charly Mörth (Austrian Academy of Sciences)     

See <https://wibarab.acdh.oeaw.ac.at/> for more information

Contact us at [wibarab@oeaw.ac.at](mailto:wibarab@oeaw.ac.at) or follow us on [Twitter](https://twitter.com/wibarab).


## Status of the data 

**THIS IS PRELIMINARY DATA AND COPYRIGHTED MATERIAL!**

If you want to use any material in this repository please contact us at [wibarab@oeaw.ac.at](mailto:wibarab@oeaw.ac.at)

This will change at the end of the project.



## Directory Structure

| Directory             | Content                    |Remarks                                                                                                                                                                                                                     |
| --------------------- | -------------------------- | -------------- |
| `001_src`             | Original sources           | Any external source data coming to the project |
| `082_scripts_xsl`     | XSLT scripts               | various XSLT scripts to convert the data scripts |
| `102_derived_TEI`     | TEI-XML documents          | TEI documents derived from a automatized conversion process (from `001_src` or elsewhere) |
| `010_manannot`        | manually annotated TEI-XML documents | TEI documents which are manually annotated / curated / edited. *Automated processed are not expected to write into this directory.* We want to make sure that a human curator has validated the data in this directory and that nothing manually curated is overwritten by some script. |
| `802_tei_odd`         | TEI customization (ODD)    | This is the source of truth for the WIBARAB FeatureDB Schema and the HTML documentation generated from it. |
| `804_xsd`  | XML Schemas     | These are derived from the ODD in `802_tei_odd`. Each version of the schema should bear its number in the file name. |
| `850_docs`            | Documentation              | Further data documentation, encoding guidelines etc.  |



## Schema Development 

At this point, the data model of the *WIBARAB Feature Database* schema is still evolving to at certain extent while new data is being curated, existing data being curated etc. 

In order to make sure that transitioning from one version of the schema to the next is done in a structured manner, we set up the following procedure:

* Any development of the schema is done in `802_tei_odd/featuredb.odd`. This file might also contain unpublished, unfinished, backwards-incompatible changes not reflected in any derived schema.
* Version names: We follow the [Semantic Versioning Best Practices 2.0.0](https://semver.org/). 
* When a new version of the schema is to be released:
	* In the ODD document:
		* update `@n` on `<edition>` to only contain the exact version number (e.g. `1.0.0b`).
		* change `<edition>` and `<title type="desc">` in the ODD to include the version number. These elements are treated only as labels and can thus include human-readble additions (like e.g. `Version 1.0.0 Beta`)
		* add a `<change>` element with your editor ID and the current date, setting `@status="published"`.
	* In oXygen:
		* Generate the XSD schema from the ODD by right-clicking on `802_tei_odd/featuredb.odd` and selecting `Transform > Transform with > TEI ODD to XML Schema`. The resulting files are placed into a new directory ``802_tei_odd/out`. 
		 * create a new subfolder named `{versionnumber}` in `804_xsd/`, e.g. `804_xsd/1.0.0b/` and move the files from `802_tei_odd/out` to that folder. Afterwards delete `802_tei_odd/out`. *Do not change the filename of the ODD.*
	* Generate the html documentation and place it under `850_docs/featuredb_{versionnumber}.html`
	* Write a conversion script to transform documents from the previous schema version to the current one. 
		* Important: make sure that the conversion script updates the `@xsi:schemaLocation` in the migrated document instance.
		* Place the XSLT script under `082_scripts_xsl/migrations` and name it `migrate_to_{versionnumber}.xsl` (e.g. migrations/migrate_to_1.0.0b.xsl`).
	* Run the conversion script on the `oddtest.xml` document in `802_tei_odd` and check it does produce the wanted results. 
	* Apply the conversion script to the files in `010_manannot`. They should be output to `102_derived_TEI`
	* Commit all changes to git and add a `tag` named after the schema version number.
	* Curators have to check the converted TEI documents and move them from `102_derived_TEI` to `010_manannot` to approve the change.



## About this file

This README file has a long-wound and dark history of editing. If you dare, you can check it out [here](https://github.com/wibarab/featuredb/commits/e5d4a768a1702403e8772a0085a3ac2c66c0cf3f/README.md).


