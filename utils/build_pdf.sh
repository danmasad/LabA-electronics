#!/usr/bin/env bash
# Build a PDF from a Markdown source using pandoc + tectonic.
#
# Usage:
#   build_pdf.sh <input.md> [output.pdf]
#
# If <output.pdf> is omitted, the output filename is derived from the input
# (e.g. "HW1_report.md" -> "HW1_report.pdf"), and is written next to the
# input file. Relative paths are resolved against the current working
# directory.
#
# Designed to be invoked from any lab folder, e.g.:
#   cd labs/LAB-5 && ../../utils/build_pdf.sh exp#5_pre_....md
# or with an absolute path:
#   /Users/dan.masad/tau_workspace/LabA-electronics/utils/build_pdf.sh labs/LAB-5/exp#5_pre_....md

set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
    echo "Usage: $(basename "$0") <input.md> [output.pdf]" >&2
    exit 1
fi

input="$1"
if [[ ! -f "$input" ]]; then
    echo "Error: input file '$input' not found" >&2
    exit 1
fi

if [[ $# -eq 2 ]]; then
    output="$2"
else
    output="${input%.md}.pdf"
fi

# Resolve relative resources (e.g. figures/foo.png) against the Markdown
# file's own directory, so the build works regardless of the current
# working directory.
input_dir="$(cd "$(dirname "$input")" && pwd)"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# The lab reports caption their figures with an italic "*Figure N: ...*" line
# right below the image (styled by the repo's Obsidian snippet). Disabling
# `implicit_figures` keeps a standalone image as an inline graphic instead of
# turning it into a floating figure that drifts onto its own page and grows a
# duplicate auto-caption from the alt text. The Lua filter then centers those
# standalone images (and centers/colors the captions), and report-style.tex
# applies the shared house style (A4, Times-like font, footer, heading rules).
pandoc "$input" \
    --from markdown-implicit_figures \
    --pdf-engine=tectonic \
    -V fontsize=11pt \
    --resource-path="${input_dir}:." \
    --lua-filter="${script_dir}/center-images.lua" \
    --include-in-header="${script_dir}/report-style.tex" \
    -o "$output"

echo "Wrote $output"
