# Domain docs

This repository uses a single-context layout:

- CONTEXT.md at the repository root: domain vocabulary.
- docs/adr/: architectural decision records.

## Before exploring

Read CONTEXT.md and ADRs relevant to the area being explored.

If these files do not exist, proceed silently. Domain-modeling creates
them lazily when terms or decisions are resolved.

## Use the glossary's vocabulary

Use terms defined in CONTEXT.md in issue titles, proposals,
hypotheses, and test names.

If a needed concept is missing, reconsider whether it belongs to the
project's vocabulary. Note genuine gaps for domain-modeling.

## Flag ADR conflicts

Explicitly identify any existing ADR that a proposal contradicts,
and explain why the decision should be reconsidered.
