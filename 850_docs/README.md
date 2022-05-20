# WIBARAB Feature DB Data Model

In this repository we draft the overall data model of the WIBARAB Feature Datatbase before/next to creating an ODD implementation of it.

## How to build the html output

### locally

NB At this point, generating html is more or less experimental and is only tested on Fedora. The main processor is a quick-and-dirty sh script building upon XSLT, pandoc, graphviz and other Linux utilities. 

* `git clone https://github.com/dasch124/modeller` 
* `chmod u+x modeller/build.sh`
* install dependencies noted at <https://github.com/dasch124/modeller#depenendcies> – either manually using the package manager on your system or by running `build.sh -a setup` (should work in case you are running a fairly recent Fedora installation with dnf installed) 
* `modeller/build.sh -a generateDocs -i model.xml -o index`


### via Docker

Cf. the [Dockerfile](Dockerfile) in this directory. This uses a base image of the above mentioned transformation to html with all dependencies installed,  e.g. if you are running windows.

```
> podman image build . --tag wibarab-db-model
> podman run -dt --name wibarab-db-model localhost/wibarab-db-model:latest /bin/bash
> podman container cp wibarab-db-model:/tmp/index.html .
> podman container cp wibarab-db-model:/tmp/index.docx .
> podman container cp wibarab-db-model:/tmp/index.svg .

# clean up after yourself

> podman stop --latest 
> podman container rm --latest 
```


