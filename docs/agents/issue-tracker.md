# Issue tracker: GitHub

Issues and specs live in GitHub Issues for SimonLiu423/zotero.koplugin.
Use the gh CLI from this clone; it infers the repository from origin.

## Conventions

- Create: gh issue create --title "..." --body-file <file>
- Read: gh issue view <number> --comments
- Fetch structured details: gh issue view <number> --json number,title,body,labels,comments
- List: gh issue list --state open --json number,title,body,labels,comments
  Add --label or change --state as needed.
- Comment: gh issue comment <number> --body-file <file>
- Apply labels: gh issue edit <number> --add-label "..."
- Remove labels: gh issue edit <number> --remove-label "..."
- Close: gh issue close <number> --comment "..."

For multiline issue bodies and comments, write the exact text to a
temporary file and pass --body-file.

When a skill says "publish to the issue tracker", create a GitHub issue.
When it says "fetch the relevant ticket", read the issue and its comments.

## Pull requests as a triage surface

PRs as a request surface: no.

GitHub shares issue and PR numbers. If a reference is ambiguous, try
gh pr view <number> and fall back to gh issue view <number>.

## Wayfinding operations

A map is one issue labelled wayfinder:map. Its body holds Notes,
Decisions-so-far, and Fog.

- Create child tickets with labels wayfinder:research,
  wayfinder:prototype, wayfinder:grilling, or wayfinder:task.
- Link children using GitHub sub-issues. If unavailable, use a task
  list in the map and a "Part of #<map>" line in each child.
- Record blockers using native issue dependencies through gh api.
  If unavailable, put "Blocked by: #<number>" in the child body.
- Select the first open child in map order with no open blockers
  and no assignee.
- Claim with gh issue edit <number> --add-assignee @me.
- Resolve by commenting with the result, closing the child, and
  adding a brief finding and link to the map's Decisions-so-far.
