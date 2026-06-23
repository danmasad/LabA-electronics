# Lab A — Electronics

BSc EE lab workspace. Each experiment produces a pre-lab and post-lab report compiled into a single submission-ready Markdown file.

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

utils/                 ← build_pdf.sh + shared PDF style (report-style.tex, center-images.lua)
code/                  ← Arduino / Python measurement scripts
data/                  ← raw CSV / text data from instruments
schematics/            ← circuit schematics
```

## Submitting

1. Copy `labs/template/` → `labs/LAB-N-<yourname>/`
2. Fill in `report.md`
3. Place all screenshots in `assets/`
4. Commit and push
