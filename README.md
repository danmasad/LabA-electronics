# Lab A — Electronics

BSc EE lab workspace. Each experiment produces a pre-lab and post-lab report compiled into a single submission-ready Markdown file.

---

## AI Lab Assistant

An agent rule is active in this workspace (`.cursor/rules/ee-lab-agent.mdc`).  
It turns the Cursor AI into a dedicated EE lab report assistant.

### How to use

1. Start a new chat in Cursor.
2. Paste the lab guide (steps, questions, tasks) from your course handout.
3. The agent will:
   - Confirm the lab title and list all steps found
   - Work through each step sequentially
   - Ask you for simulation screenshots before analyzing them
   - Compile the final `report.md` when all steps are complete

### For simulation steps

When the agent reaches a simulation step it will output a visible prompt:

> **[SCREENSHOT NEEDED]**  
> Please run the simulation and paste a screenshot.

Upload the screenshot in the chat. The agent will explain the results and continue.

---

## Folder Structure

```
labs/
  template/
    report.md          ← copy this as a starting point for each lab
    assets/            ← put screenshots and plots here
  LAB-N-<name>/
    report.md          ← final submission
    assets/

code/                  ← Arduino / Python measurement scripts
data/                  ← raw CSV / text data from instruments
schematics/            ← circuit schematics
```

## Submitting

1. Copy `labs/template/` → `labs/LAB-N-<yourname>/`
2. Fill in `report.md` with agent-generated content
3. Place all screenshots in `assets/`
4. Commit and push
