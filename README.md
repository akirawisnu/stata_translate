# stata_translate

**stata_translate — Translate text variables in Stata using Google Translate API**

## Syntax

```
stata_translate varlist
```

## Description

`stata_translate` takes multiple string variable (varlist) from your dataset and uses Google Translate API:
- Automatically detect the language of each row.
- Translate each row's text to English.
- Save the results in two new variables:
  - *_`translated` for the English translation
  - *_`srclang` for the detected source language

The command uses Stata’s Python integration and assumes that:
- The translation service is online Google Translate API
- The model `llama3.2:latest` for local / offline usage will be developed later using `ollama`

## Example

```

clear
input str40 city_description str40 food_review
París es una ciudad hermosa" "Le fromage est délicieux"
Berlin ist großartig" "Ich liebe Bratwurst"
東京はとても忙しいです" "寿司はとても新鮮です"
end

stata_translate city_description food_review

list city_description food_review

```

This will create two new variables:
- `*_translated` — English translation
- `*_srclang` — Source language (e.g., 'de', 'fr', 'id')

## Requirements

To use this command, you must:
1. Have Python configured in Stata (see `python query`). The easiest way is to install Anaconda or Miniconda to your environment (see `https://www.anaconda.com/download`)
2. Install the following Python libraries: (this version of stata_translate automatically install these packages as long as you have Python environment installed)
   - `langdetect` (pip install langdetect)
   - `deep_translator` (pip install deep_translator)

## Author

Written by @akirawisnu during his PhD depression break.  
Feedback or improvements welcome!

## Also see

- Manual:  `help python`, `help generate`, `help string functions`
- Online:  [https://ollama.com](https://ollama.com), [https://pypi.org/project/langdetect](https://pypi.org/project/langdetect), [https://www.anaconda.com/download](https://www.anaconda.com/download)
