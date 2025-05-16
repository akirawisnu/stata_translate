
{smcl}
{* *! version 1.0.0  15may2025}{...}
{cmd:stata_translate} {it:varname}

{title:Title}

{phang}
{cmd:stata_translate} — Translate text variables in Stata using DeepL Free Translate API

{title:Syntax}

{phang}
{cmd:stata_translate} {it:varname}

{title:Description}

{pstd}
{cmd:stata_translate} takes a single string variable from your dataset and uses DeepL Free Translate API:
{break}- Automatically detect the language of each row.
{break}- Translate each row's text to English.
{break}- Save the results in two new variables: 
{it: translated} for the English translation and 
{it: srclang} for the detected source language.

{pstd}
The command uses Stata’s Python integration and assumes that:
{break}- The translation service is online using DeepL API
{break}- The model {cmd:llama3.2:latest} for local / offline usage will be develop later {cmd:ollama}

{title:Example}

{phang2}{cmd:. stata_translate description}{p_end}

{pstd}
This will create two new variables:
{break}- {cmd:translated} — English translation
{break}- {cmd:srclang} — Source language (e.g., 'de', 'fr', 'id')

{title:Requirements}

{pstd}
To use this command, you must:
{break}1. Have Python configured in Stata (see {cmd:python query}).
{break}2. Install the following Python libraries:
{cmd:langdetect}, {cmd:deep_translator}

{title:Author}

{pstd}
Written by @akirawisnu during his PhD depression break.
Feedback or improvements welcome!

{title:Also see}

{psee}
Manual:  {help python}, {help generate}, {help string functions}

{psee}
Online:  https://ollama.com, https://pypi.org/project/langdetect
