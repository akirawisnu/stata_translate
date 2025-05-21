
{smcl}
{* *! version 1.2.0  21may2025}{...}
{cmd:stata_translate} {it:varlist}

{title:Title}

{phang}
{cmd:stata_translate} — Translate text variables in Stata using Google Translate API

{title:Syntax}

{phang}
{cmd:stata_translate} {it:varlist}

{title:Description}

{pstd}
{cmd:stata_translate} takes multiple string variable (varlist) from your dataset and uses Google Translate API:
{break}- Automatically detect the language of each row.
{break}- Translate each row's text to English.
{break}- Save the results in two new variables: 
{it: *_translated} for the English translation and 
{it: *_srclang} for the detected source language.

{pstd}
The command uses Stata’s Python integration and assumes that:
{break}- The translation service is online using Google Translate API
{break}- The model {cmd:llama3.2:latest} for local / offline usage will be develop later {cmd:ollama}

{title:Example}

{phang2}{cmd:. clear}{p_end}
{phang2}{cmd:. input str40 city_description str40 food_review}{p_end}
{phang2}{cmd: "París es una ciudad hermosa" "Le fromage est délicieux"}{p_end}
{phang2}{cmd: "Berlin ist großartig" "Ich liebe Bratwurst"}{p_end}
{phang2}{cmd: "東京はとても忙しいです" "寿司はとても新鮮です"}{p_end}
{phang2}{cmd:. end}{p_end}

{phang2}{cmd:. stata_translate city_description food_review}{p_end}

{phang2}{cmd:. list city_description food_review}{p_end}

{pstd}
This will create two new variables:
{break}- {cmd:*_translated} — English translation
{break}- {cmd:*_srclang} — Source language (e.g., 'de', 'fr', 'id')

{title:Requirements}

{pstd}
To use this command, you must:
{break}1. Have Python configured in Stata (see {cmd:python query}). The easiest way is to install Anaconda or Miniconda to your environment (https://www.anaconda.com/download)
{break}2. Install the following Python libraries: (this version of stata_translate automatically install these packages as long as you have Python environment installed)
{cmd:pip install langdetect}, {cmd:pip install deep_translator}

{title:Author}

{pstd}
Written by @akirawisnu during his PhD depression break.
Feedback or improvements welcome!

{title:Also see}

{psee}
Manual:  {help python}, {help generate}, {help string functions}

{psee}
Online:  https://ollama.com, https://pypi.org/project/langdetect, https://www.anaconda.com/download, https://pypi.org/project/deep-translator/
