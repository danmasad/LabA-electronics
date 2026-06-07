-- Figure styling + layout for the lab reports (LaTeX/PDF output).
--
-- Used with `--from markdown-implicit_figures`, so a standalone image is a
-- plain paragraph (not a floating figure). This filter then:
--   * keeps each image together with its "*Figure N: ...*" caption by wrapping
--     the pair in an unbreakable minipage, so a caption can never spill onto
--     the next page on its own,
--   * centers the image and centers + colors the caption (blue \figcap, which
--     is defined in report-style.tex),
--   * shrinks images a little so a figure + caption fits comfortably,
--   * when a heading is immediately followed by such a figure, reserves enough
--     vertical space that the heading lands on the same page as its figure.
--
-- The RawBlocks are LaTeX-only, so other output formats are unaffected.

local IMG_WIDTH   = "80%"                -- a little smaller than full width
local FIG_RESERVE = "0.5\\textheight"    -- space kept for a heading + its figure

local function raw(s) return pandoc.RawBlock("latex", s) end

local function is_image_para(b)
  return b and b.t == "Para" and #b.content == 1 and b.content[1].t == "Image"
end

local function is_caption_para(b)
  return b and b.t == "Para" and b.content[1] and b.content[1].t == "Emph"
    and pandoc.utils.stringify(b):match("^Figure")
end

-- Image + caption rendered as one unbreakable, centered unit.
local function figure_unit(img_para, cap_para)
  img_para.content[1].attributes.width = IMG_WIDTH
  return {
    raw("\\par\\medskip\\noindent\\begin{minipage}{\\linewidth}\\centering"),
    img_para,
    raw("\\par\\vspace{0.35em}\\color{figcap}"),
    cap_para,
    raw("\\end{minipage}\\par\\medskip"),
  }
end

local function append(out, items)
  for _, blk in ipairs(items) do out[#out + 1] = blk end
end

function Pandoc(doc)
  local blocks = doc.blocks
  local out = {}
  local i = 1
  while i <= #blocks do
    local b = blocks[i]
    -- A run of one or more headings immediately followed by a figure: reserve
    -- space so the heading(s) land on the same page as their figure.
    local j = i
    while blocks[j] and blocks[j].t == "Header" do j = j + 1 end
    if j > i and is_image_para(blocks[j]) and is_caption_para(blocks[j + 1]) then
      out[#out + 1] = raw("\\needspace{" .. FIG_RESERVE .. "}")
      for k = i, j - 1 do out[#out + 1] = blocks[k] end
      append(out, figure_unit(blocks[j], blocks[j + 1]))
      i = j + 2
    elseif is_image_para(b) and is_caption_para(blocks[i + 1]) then
      append(out, figure_unit(b, blocks[i + 1]))
      i = i + 2
    elseif is_image_para(b) then
      b.content[1].attributes.width = IMG_WIDTH
      append(out, { raw("\\begin{center}"), b, raw("\\end{center}") })
      i = i + 1
    elseif is_caption_para(b) then
      append(out, { raw("\\begin{center}\\color{figcap}"), b, raw("\\end{center}") })
      i = i + 1
    else
      out[#out + 1] = b
      i = i + 1
    end
  end
  doc.blocks = out
  return doc
end
