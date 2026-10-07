---
name: ste100
description: Write technical documentation using ASD-STE100 Simplified Technical English rules. Use when writing or editing procedures, runbooks, READMEs, install/setup guides, troubleshooting steps, warnings, or other technical docs. Do not use for casual chat replies or code comments unless asked.
---

# ASD-STE100 Simplified Technical English

Apply these rules to the documentation text you write. Code, commands, file paths, UI labels, and product names stay exactly as they are in the system.

## Words

- Use one word for one meaning. When you pick a term ("server", "remove"), use only that term. Do not use synonyms for variety.
- Use the most common meaning of a word ("follow" = come after, not "obey").
- Use approved technical names exactly (command names, config keys, part names).
- Do not use phrasal verbs. Use a single verb:
  - "set up" → "configure" / "install"
  - "find out" → "identify" / "find"
  - "carry out" → "do"
  - "shut down" → "stop"
  - "go through" → "examine"
- Use simple words: "use" not "utilize", "start" not "initiate", "help" not "facilitate", "about" not "approximately", "make sure" not "ensure".
- Do not use slang, idioms, or jargon that you do not define.
- Use articles ("the", "a", "an"). Do not omit them to make text shorter.
- Do not use noun clusters of more than 3 words. Break them up ("the database connection timeout value" → "the timeout value for the database connection").

## Verbs

- Use only these tenses: simple present, simple past, simple future.
- Do not use "-ing" verb forms (except in technical names). "Restarting the service clears the cache" → "When you restart the service, the cache clears."
- Use active voice. Do not use passive voice in procedures. In descriptions, use passive voice only when the agent is unknown or unimportant.
- Do not change a verb into a noun ("perform an installation of" → "install").

## Sentences

- Procedural sentences: max 20 words.
- Descriptive sentences: max 25 words.
- Write one topic per sentence.
- Use a vertical list for complex text or multiple items.
- Use connecting words ("then", "but", "because") to show logical links between sentences.

## Procedures

- Write one instruction per sentence, unless two actions occur at the same time.
- Use the imperative (command) form: "Remove the cover." "Run `make install`."
- Put a condition before the instruction: "If the build fails, examine the log."
- Give each step a number. Put the steps in the order the user does them.
- Put descriptive text (results, notes) after the step, not inside it.

## Descriptions

- Paragraphs: max 6 sentences, one topic per paragraph.
- Start with the most important information.
- Use a topic sentence that tells the reader what the paragraph is about.

## Warnings and cautions

- Start with a clear command: "Do not delete the volume while the pod runs."
- Then give the reason or the risk: "Data loss will occur."
- Write warnings (risk to people/production) and cautions (risk to equipment/data) separately from the procedure text, before the step they apply to.

## Check before you finish

1. No sentence is longer than the limit.
2. No "-ing" verb forms, no phrasal verbs, no passive voice in procedures.
3. Each term has one meaning and you used it the same way everywhere.
4. Each step has only one instruction.
