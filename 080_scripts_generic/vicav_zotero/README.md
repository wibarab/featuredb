# VICAV Zotero export

see [fetch_generated_tei_and_process.ipynb](fetch_generated_tei_and_process.ipynb)

```bash
pipenv install
pipenv run jupyter-lab
# if you need a script
pipenv run jupyter nbconvert --to script fetch_generated_tei_and_process.ipynb
# run the script
pipenv run python fetch_generated_tei_and_process.py
```