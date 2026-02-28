# WIBARAB feature database

## About WIBARAB
From Iran to Mauretania, countless spoken varieties of Arabic are in use, and more than 350 million people speak Arabic in settings characterised by a high degree of diglossia. In this context, the ERC-funded WIBARAB project focusses on the language of the Bedouins that spread with the Arab expansion in the Middle East and North Africa since the 7th century. The aim is to better understand the nature of the linguistic dichotomy between sedentary and nomadic varieties. Consisting of various regional sub-projects (four PhD projects), the project establishes the first set of linguistic phenomena that characterise the Bedouin-sedentary split. In addition to phonological and morphological features, the project also studies a range of other aspects, from syntax to the influence of intra-dialect contacts and historical migrations. 

The *WIBARAB Database of Linguistic Features* will be the main point of integrating the results of all sub-projects. In this repository we collect the primary data of the database in TEI/XML.

Principal Investigator: Stephan Procházka (University of Vienna)     
National Cooperation Partner: Charly Mörth (Austrian Academy of Sciences)     

See <https://wibarab.acdh.oeaw.ac.at/> for more information

Contact us at [wibarab@oeaw.ac.at](mailto:wibarab@oeaw.ac.at) or follow us on [Twitter](https://twitter.com/wibarab).


## Status of the data 

**THIS IS PRELIMINARY DATA AND COPYRIGHTED MATERIAL!**

If you want to use any material in this repository please contact us at [wibarab@oeaw.ac.at](mailto:wibarab@oeaw.ac.at)

This will change at the end of the project.

## Deploy data changes

To deploy changes to this data please follow the [wibarab-data README](https://github.com/wibarab/wibarab-data?tab=readme-ov-file#re-deploy-wibarab-website)

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

At this point, the model of the *WIBARAB Feature Database* schema is still evolving to a certain extent while new data is being curated, existing data being curated etc. In order to make sure that transitioning from one version of the schema to the next happens in a structured manner, we set up the following rules:

* Any development of the schema is done in `802_tei_odd/featuredb.odd`. This file might also contain unpublished, unfinished, backwards-incompatible changes not reflected in any derived schema or documentation.
* **Naming conventions:** We follow the [Semantic Versioning Best Practices 2.0.0](https://semver.org/) which - applied to our case - boil down to the following principles:
    * If a change potentially makes documents invalid which were previously valid, it is a new MAJOR version (i.e. increment the first number)
    * If a change does not break validity of existing documents (e.g. in that it only adds optional elements or attributes or adds a significant portion of prose to the documentation) it is a new MINOR version (i.e. increment second number)
    * If a change in the schema is merely a bug fix (typo etc.) or a minor addition to the documentation (change in wording, added examples etc.) this constitutes a PATCH version (i.e. the third number is incremented).

### Schema release workflow
When a new version of the schema is to be released:

* In the ODD document:
	* update `@n` on `<edition>` to only contain the exact version number (e.g. `2.1.3b`).
	* change `<edition>` to include the version number. These elements are treated only as labels and can thus include human-readble additions (like e.g. `Version 2.1.3 Beta`)
	* add a `<change>` element with your editor ID and the current date, setting `@status="published"`. Ideally add a `<list>` with all the changes you did in the ODD. 
	* *Do not change the filename of the ODD document.*
* In oXygen:
	* Generate the XSD schema from the ODD by right-clicking on `802_tei_odd/featuredb.odd` and selecting `Transform > Transform with > TEI ODD to XML Schema`. The resulting files are placed into a new directory `802_tei_odd/out`. 
	* create a new subfolder named `{versionnumber}` in `804_xsd/`, e.g. `804_xsd/2.1.3b/` and move the files from `802_tei_odd/out` to that folder. 
* Generate the html documentation and place it under `850_docs/featuredb_{versionnumber}.html`
* Afterwards delete `802_tei_odd/out`. 
* Write a conversion script to transform documents from the previous schema version to the current one. 
	* Important: make sure that the conversion script updates the `@xsi:schemaLocation` in the migrated document instance.
	* Place the XSLT script under `082_scripts_xsl/migrations` and name it `migrate_to_{versionnumber}.xsl` (e.g. migrations/migrate_to_1.0.0b.xsl`).
* Run the conversion script on the `oddtest.xml` document in `802_tei_odd` and check it does produce the wanted results. 
* Apply the conversion script to the files in `010_manannot`. They should be output to `102_derived_TEI`
* Commit all changes to git and add a `tag` named after the schema version number.
* Curators have to check the converted TEI documents and move them from `102_derived_TEI` to `010_manannot` to approve the change.



## About this file

This README file has a long-wound and dark history of editing. If you dare, you can check it out [here](https://github.com/wibarab/featuredb/commits/e5d4a768a1702403e8772a0085a3ac2c66c0cf3f/README.md).


