*! version 0.1 16-May-2025 Akirawisnu: Stata Translate via GoogleTranslator using Python integration
version 16.0
cap prog drop stata_translate
program define stata_translate, rclass

    syntax varlist(min=1 max=1)

    local varname `varlist'

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
	
	python: trns("`varname'")
	
	* Check the results in Stata
	list `varname' scrlang translated in 1/5
    di as result "Translation complete. New variables: scrlang, translated"
end

python:
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
