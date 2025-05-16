# stata_translate

**Translate text variables in Stata using DeepL Free Translate API**

## Syntax

```
stata_translate varname
```

## Description

`stata_translate` takes a single string variable from your dataset and uses DeepL Free Translate API:
- Automatically detect the language of each row.
- Translate each row's text to English.
- Save the results in two new variables:
  - `translated` for the English translation
  - `srclang` for the detected source language

The command uses Stata’s Python integration and assumes that:
- The translation service is online using DeepL API
- The model `llama3.2:latest` for local / offline usage will be developed later using `ollama`

## Example

```
. stata_translate description
```

This will create two new variables:
- `translated` — English translation
- `srclang` — Source language (e.g., 'de', 'fr', 'id')

## Requirements

To use this command, you must:
1. Have Python configured in Stata (see `python query`).
2. Install the following Python libraries:
   - `langdetect`
   - `deep_translator`

## Author

Written by @akirawisnu during his PhD depression break.  
Feedback or improvements welcome!

## Also see

- Manual:  `help python`, `help generate`, `help string functions`
- Online:  [https://ollama.com](https://ollama.com), [https://pypi.org/project/langdetect](https://pypi.org/project/langdetect)
