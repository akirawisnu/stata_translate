*! version 0.2 21-May-2025 Akirawisnu: Stata Translate via GoogleTranslator with varlist & pip install
version 16.0
program define stata_translate, rclass

    syntax varlist(min=1)

    foreach varname of varlist `varlist'{
        // Check if variable exists and is string
        capture confirm variable `varname'
        if _rc {
            di as error "Variable `varname' not found."
            exit 198
			}

        quietly {
            ds `varname', has(type string)
            if _rc {
                di as error "Variable `varname' must be string type."
                exit 198
				}
			}
		di "Processing: `varname'"
        python: trns("`varname'")
		qui: ren scrlang `varname'_scrlang
		qui: ren translated `varname'_translated
		}
	
    di as result "Translation complete. New variables: *_scrlang, *_translated"
end

python:
import subprocess
import importlib.util

def ensure_package(pkg):
    if importlib.util.find_spec(pkg) is None:
        subprocess.check_call(["pip", "install", pkg])

# Ensure required modules are installed
ensure_package("deep_translator")
ensure_package("langdetect")

import pandas as pd
from sfi import Data, SFIToolkit, Macro
from deep_translator import GoogleTranslator
from langdetect import detect

# Get the variable name from Stata local macro

def trns(varname):
	varix = varname
	print(f"Variable name received from Stata: '{varix}'")

	# Load Stata data into pandas DataFrame
	df = pd.DataFrame(Data.getAsDict())

	# Ensure variable exists
	if varix not in df.columns:
		print(f"Variable '{varix}' not found in dataset")
		import sys
		sys.exit(1)

	# Prepare column for translation: fill missing and convert to string
	df[varix] = df[varix].fillna("").astype(str)

	# Define translation functions
	def detect_and_translate_free(text):
		try:
			lang = detect(text)
			translation = GoogleTranslator(source=lang, target='en').translate(text)
			return lang, translation
		except Exception as e:
			print(f"Error: {e} for text: {text}")
			return "", ""

	def detect_and_translate_safe(x):
		try:
			if not x or x.strip() == "":
				return pd.Series(["", ""])
			return pd.Series(detect_and_translate_free(x))
		except Exception as e:
			print(f"Translation error: {e} for text: {x}")
			return pd.Series(["", ""])

	# Apply translation to the chosen variable
	df[['scrlang', 'translated']] = df[varix].apply(detect_and_translate_safe)

	# Update Stata data frame with new variables
	Data.setObsTotal(len(df))

	for col in ['scrlang', 'translated']:
		varname_out = SFIToolkit.makeVarName(col)
		Data.addVarStr(varname_out, 1)
		Data.store(varname_out, None, df[col].astype(str).tolist())
		print(f"Added variable: {varname_out}")

		# Optional: you can save varname_out somewhere or return via r()
	
end
