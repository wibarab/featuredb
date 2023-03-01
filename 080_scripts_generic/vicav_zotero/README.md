# VICAV Zotero export

see [fetch_generated_tei_and_process.ipynb](fetch_generated_tei_and_process.ipynb)

Install Python 3.10.x from python.org [Windows](https://www.python.org/downloads/windows/), [MacOS](https://www.python.org/downloads/macos/) or for your Linux distribution.

```powershell
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