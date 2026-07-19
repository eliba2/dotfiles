# Daily work journal (`~/.memory/`)

I keep a chronological, plain-English record of what was worked on each day under `~/.memory/`. This is distinct from the auto-memory system (`~/.claude/projects/.../memory/`, which holds timeless facts) — this journal is a **dated log of activity**, so I can answer questions like "what were we working on yesterday?" or "when did we last touch X?".

**Layout:** one Markdown file per day, ISO-named (`~/.memory/2026-07-19.md`).

**File format** (create the file the first time a day is written to; append to `## Worked on` on later updates the same day):

```markdown
# 2026-07-19

## Summary
One or two lines on the theme of the day.

## Worked on
- <ticket / change / investigation>: <what was done + outcome/status>

## Open threads
- <anything left unfinished, to pick up next>
```

**Reading protocol** — when asked what happened on a day / recently:
- "today" → `~/.memory/$(date +%F).md`; "yesterday" → the file for `date -v-1d +%F`.
- Vaguer questions → `ls ~/.memory/` and read/grep the relevant files (filenames sort chronologically). If a day's file doesn't exist, nothing was logged that day — say so, don't invent.

**Writing protocol** — after doing real work (a ticket, a code change, a non-trivial investigation with a conclusion), update today's file: read it first if it exists, append a terse outcome-focused bullet under `## Worked on` (don't duplicate). A `Stop` hook injects a reminder each turn; treat it as the cue. Don't announce the journal update unless asked.
