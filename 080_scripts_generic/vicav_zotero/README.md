# VICAV Zotero export

see [fetch_generated_tei_and_process.ipynb](fetch_generated_tei_and_process.ipynb)

Install Python 3.10.x from python.org [Windows](https://www.python.org/downloads/windows/), [MacOS](https://www.python.org/downloads/macos/) or for your Linux distribution.
Be sure to check `Add python.exe to PATH` on Windows.
 
```powershell
# in featuredb
cd .\080_scripts_generic\vicav_zotero\
python -m pip install pipenv
pipenv install
# this takes some time. Installation is finished when you see following two lines
# To activate this project's virtualenv, run pipenv shell.
# Alternatively, run a command inside the virtualenv with pipenv run.
# create a .env to set the API_TOKEN
pipenv run jupyter-lab
# if you need a script
pipenv run jupyter nbconvert --to script fetch_generated_tei_and_process.ipynb
# run the script
pipenv run python fetch_generated_tei_and_process.py
```

This generates `TEI_export.xml` in `.\080_scripts_generic\vicav_zotero\`.  
Copy `.\080_scripts_generic\vicav_zotero\TEI_export.xml` to `.\010_manannot\`.  
Delete `.\010_manannot\vicav_biblio_tei_zotero.xml` and rename `.\010_manannot\TEI_export.xml` to `.\010_manannot\vicav_biblio_tei_zotero.xml`.
Stage and commit the changes after reviewing them.