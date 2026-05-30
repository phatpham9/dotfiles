---
name: ai-smell-detector
description: 'Assess how AI-like a piece of writing sounds, score the smell, identify the strongest signals, and recommend whether it needs cleanup, rewriting, or humanize-writing. Use when reviewing pasted text, drafts, blog posts, docs, emails, social posts, marketing copy, or any prose for robotic tone, generic polish, formulaic phrasing, translation artifacts, and missing human specificity.'
argument-hint: 'Paste the text to scan for AI-smelling prose patterns'
---

# AI Smell Detector

## Purpose

Assess whether prose feels generic, overproduced, robotic, or AI-generated. Score the smell, name the strongest signals, and point to the smallest useful fix while preserving the author's intent and voice.

## When to Use

Use this skill when the user asks to:

- Detect AI smell, AI tells, AI slop, or chatbot-like writing
- Judge whether a draft sounds robotic, machine-made, or overpolished
- Review pasted prose before publishing
- Triage whether text needs light cleanup, a full rewrite, or `humanize-writing`
- Humanize a draft without changing its meaning when the user explicitly asks for rewriting
- Find generic, overpolished, or formulaic phrasing
- Rewrite flagged lines so they sound more natural while keeping the original meaning

## Default Stance

- Default to diagnosis, not rewriting.
- Rewrite only when the user asks for a fix, asks to humanize the text, or provides a short draft where a concise revision is clearly useful.
- Separate style issues from meaning issues. Do not treat a factual gap as a style problem.
- Flag only passages that materially affect credibility or voice. Do not nitpick every ordinary phrase.
- Do not accuse the author of using AI. Describe the prose, not the person.

## Detection Checklist

Scan for these patterns first:

- Generic openings that could fit any topic, audience, or product
- Dramatic contrast formulas: `It's not X, it's Y`, `This isn't just X; it's Y`, `Not only X, but Y`
- False drama devices: `Here's the thing`, `The uncomfortable truth`, `Let's be clear`, `In today's fast-paced world`
- Gimmicky fragments: short sentence fragments stacked for emphasis, such as `No fluff. No noise. Just results.`
- Hollow intensifiers: `incredibly`, `game-changing`, `revolutionary`, `transformative`, `seamless`, `robust`, `powerful`, `cutting-edge`, `elevate`, `unlock`
- Forced triads: neat three-item lists that sound balanced but vague, especially `X, Y, and Z` where none are concrete
- Repetition by paraphrase: the same claim restated in adjacent sentences with slightly different words
- Abstract nouns stacked on weak verbs, such as `drive innovation`, `enable transformation`, or `deliver impact`
- Machine-balanced structure: bullets or paragraphs with the same length, syntax, and emotional pitch
- Too many hedges, disclaimers, caveats, or transition phrases
- Missing human elements: no lived detail, named source, date, place, constraint, trade-off, mistake, observation, quote, or concrete example
- Generic certainty: broad claims without evidence, such as `everyone knows`, `businesses need`, `users expect`, `it is essential`
- Corporate filler: polished but low-information phrasing, such as `drive value`, `empower teams`, `streamline workflows`, `at scale`
- Over-explained transitions: `Moreover`, `Furthermore`, `Additionally`, `It is important to note that` when they add no real structure
- Translation artifacts: phrasing that sounds mechanically translated rather than written naturally in the target language

## Channel Patterns

Use the channel to decide which signals matter most:

- Email: over-politeness, ceremony, long framing before the ask, and generic gratitude
- Blog: generic intros, abstract claims, over-structured sections, and tidy but shallow conclusions
- Social: brand voice, forced optimism, punchy fragments, and too much explanation
- Marketing: hype adjectives, frictionless promises, vague benefits, and interchangeable product claims
- Docs: inflated explanations, redundant context, and transitions that hide the actual instruction

## Workflow

1. Read the whole text once for intent, audience, and desired tone.
2. Score the AI smell from `0` to `5` using the rubric below.
3. Name the strongest signals, prioritizing recurring patterns over isolated phrases.
4. For each important finding, quote the smallest useful passage.
5. Explain why it reads as AI-generated, generic, robotic, or translated in one concise sentence.
6. Suggest a natural alternative for flagged passages when useful, but do not provide a full rewrite unless asked.
7. If the text lacks human specificity, suggest what kind of detail to add rather than inventing facts.
8. Recommend whether the draft needs light cleanup, structural cleanup, a full rewrite, or `humanize-writing`.

## Smell Scale

- `0`: Sounds natural; specific, grounded, and varied.
- `1`: A few AI traces or polished phrases, but the draft is readable and mostly human.
- `2`: Noticeable generic polish, repetition, or formulaic structure; light cleanup needed.
- `3`: Clearly machine-shaped; structure, rhythm, or claims need substantial cleanup.
- `4`: Heavy AI smell; repeated formulas, vague claims, and little specificity. Rewrite likely needed.
- `5`: Unusable as-is; keep the meaning and rebuild the prose.

Use confidence qualifiers when the sample is short. A polished sentence can be human; the score should reflect patterns across the text, not a single phrase.

## Output Format

Default to this concise assessment structure:

```markdown
**AI-Smell Score:** N/5

**Summary:** One or two sentences explaining the main issue.

**Findings**

| Severity        | Pattern      | Passage       | Why It Smells       | Natural Alternative |
| --------------- | ------------ | ------------- | ------------------- | ------------------- |
| High/Medium/Low | Pattern name | "Quoted text" | Concise explanation | Suggested rewrite   |

**Missing Human Elements**

- Specific details, examples, sources, or constraints the text needs.

**Recommendation:** Light cleanup / structural cleanup / full rewrite / hand off to `humanize-writing`.
```

For short triage requests, use a shorter format:

```markdown
**AI-Smell Score:** N/5

**Diagnosis:** Brief diagnosis with the strongest signals.

**Recommendation:** Light cleanup / structural cleanup / full rewrite / hand off to `humanize-writing`.
```

When the user explicitly asks for a rewrite, add:

```markdown
**Suggested Revision**

Rewritten text that preserves meaning, removes formulaic phrasing, and keeps the user's likely voice.
```

## Rewrite Rules

- Prefer plain, concrete language over theatrical setup.
- Replace abstractions with observable details when the source text provides them.
- Vary sentence length naturally; do not make everything clipped and punchy.
- Keep good structure. Do not remove a phrase just because it appears on the checklist if it works in context.
- Do not fabricate anecdotes, quotes, sources, metrics, or personal experience.
- Avoid accusing the author of using AI. Describe the prose, not the person.

## Quick Example

Input:

```text
It's not just a productivity tool; it's a game-changing way to unlock seamless collaboration. Here's the thing: teams need faster, smarter, better workflows.
```

Output:

```markdown
**AI-Smell Score:** 4/5

**Summary:** The passage relies on contrast formulas, hype words, and a forced three-part list without concrete evidence.

**Findings**

| Severity | Pattern            | Passage                                                          | Why It Smells                                                                  | Natural Alternative                                                                         |
| -------- | ------------------ | ---------------------------------------------------------------- | ------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------- |
| High     | Dramatic contrast  | "It's not just a productivity tool; it's a game-changing way..." | The sentence uses a familiar AI contrast and hype instead of a specific claim. | "The tool helps teams assign work, discuss blockers, and see what changed since yesterday." |
| Medium   | False drama device | "Here's the thing"                                               | The phrase creates artificial urgency without adding information.              | Remove it, or replace it with the actual point.                                             |
| Medium   | Forced triad       | "faster, smarter, better workflows"                              | The list sounds balanced but does not say what improves.                       | "workflows with fewer status meetings and clearer handoffs"                                 |

**Missing Human Elements**

- Add a concrete workflow, user quote, before/after metric, or real constraint from the product context.

**Recommendation:** Full rewrite or hand off to `humanize-writing` if the user wants a publication-ready version.
```
