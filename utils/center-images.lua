-- Figure styling + layout for the lab reports (LaTeX/PDF output).
--
-- Used with `--from markdown-implicit_figures`, so a standalone image is a
-- plain paragraph (not a floating figure). This filter then:
--   * keeps each image together with its caption (\figcap{...} or *Figure N: ...*)
--     by wrapping the pair in an unbreakable minipage,
--   * centers the image and centers + colors the caption,
--   * shrinks images a little so a figure + caption fits comfortably,
--   * when a heading is immediately followed by such a figure, reserves enough
--     vertical space that the heading lands on the same page as its figure,
--   * reserves space before a table sized to the table's own height (so a whole
--     table stays on one page, yet a small table can still flow up to fill a
--     gap), and pulls an immediately-preceding lead-in paragraph along with it.
--
-- The RawBlocks are LaTeX-only, so other output formats are unaffected.

local IMG_WIDTH      = "80%"
local IMG_WIDTH_NUM  = 80                 -- default width as a number (percent)
local FIG_RESERVE_AT_FULL = 0.45          -- \textheight reserved for an 80%-wide figure
local HEADER_RESERVE = "0.18\\textheight"

local function raw(s) return pandoc.RawBlock("latex", s) end

-- Width (percent, as a number) explicitly set on the image, or nil for default.
local function image_width_percent(img_para)
  for _, inline in ipairs(img_para.content) do
    if inline.t == "Image" then
      local w = inline.attributes.width
      if w and w ~= "" then return tonumber(w:match("(%d+%.?%d*)")) end
      return nil
    end
  end
  return nil
end

-- Vertical space to reserve for a figure + caption, scaled to the image width
-- (a narrower image is shorter, so it needs less room and can flow up).
local function figure_reserve(img_para)
  local w = image_width_percent(img_para) or IMG_WIDTH_NUM
  local frac = FIG_RESERVE_AT_FULL * w / IMG_WIDTH_NUM
  return raw(string.format("\\needspace{%.3f\\textheight}", frac))
end

-- Count the rows of a pandoc Table (header + all body rows + foot).
local function count_table_rows(tbl)
  local n = 0
  if tbl.head and tbl.head.rows then n = n + #tbl.head.rows end
  for _, body in ipairs(tbl.bodies or {}) do
    if body.head then n = n + #body.head end
    if body.body then n = n + #body.body end
  end
  if tbl.foot and tbl.foot.rows then n = n + #tbl.foot.rows end
  return n
end

-- Vertical space to reserve before a table: enough to keep the whole table
-- together, but no larger than necessary (so short tables still flow up).
-- "+ extra" lines account for the booktabs rules and an optional lead-in line.
local function table_reserve(tbl, extra)
  local lines = count_table_rows(tbl) + 3 + (extra or 0)
  return raw("\\needspace{" .. lines .. "\\baselineskip}")
end

local function is_image_para(b)
  if not (b and b.t == "Para") then return false end
  for _, inline in ipairs(b.content) do
    if inline.t == "Image" then return true end
  end
  return false
end

local function image_para_only(b)
  return b and b.t == "Para" and #b.content == 1 and b.content[1].t == "Image"
end

local function is_nopagebreak_block(b)
  return b and b.t == "RawBlock" and b.format == "tex"
    and b.text:match("^\\nopagebreak")
end

local function is_figcap_block(b)
  return b and b.t == "RawBlock" and b.format == "tex"
    and (b.text:match("\\figcap{") or b.text:match("textcolor%{labteal%}"))
end

local function is_caption_para(b)
  return b and b.t == "Para" and b.content[1] and b.content[1].t == "Emph"
    and pandoc.utils.stringify(b):match("^Figure")
end

local function is_table_block(b)
  return b and b.t == "Table"
end

-- A short, plain lead-in line (e.g. "Circuit is shown in Figure 11.") that
-- should stay with the figure/table it introduces.
local function is_short_lead_in(b)
  if not (b and b.t == "Para") then return false end
  if is_image_para(b) then return false end
  return #pandoc.utils.stringify(b) <= 400
end

local function set_image_width(img_para)
  for _, inline in ipairs(img_para.content) do
    if inline.t == "Image" then
      if not inline.attributes.width or inline.attributes.width == "" then
        inline.attributes.width = IMG_WIDTH
      end
      return
    end
  end
end

-- Image + caption rendered as one unbreakable, centered unit.
local function figure_unit(img_para, caption)
  set_image_width(img_para)
  return {
    raw("\\par\\medskip\\noindent\\begin{minipage}{\\linewidth}\\centering"),
    img_para,
    raw("\\par\\vspace{0.35em}"),
    caption,
    raw("\\end{minipage}\\par\\medskip"),
  }
end

local function append(out, items)
  for _, blk in ipairs(items) do out[#out + 1] = blk end
end

-- Return caption block index and total blocks consumed after the image, or nil.
local function figure_tail(blocks, img_idx)
  local idx = img_idx + 1
  if is_nopagebreak_block(blocks[idx]) then idx = idx + 1 end
  if is_figcap_block(blocks[idx]) then
    return blocks[idx], idx - img_idx
  end
  if is_caption_para(blocks[idx]) then
    return blocks[idx], idx - img_idx
  end
  return nil, 0
end

local function emit_figure(out, img_para, caption)
  append(out, figure_unit(img_para, caption))
end

function Pandoc(doc)
  local blocks = doc.blocks
  local out = {}
  local i = 1
  while i <= #blocks do
    local b = blocks[i]

    -- Heading run followed by a figure: keep the heading on the same page.
    local j = i
    while blocks[j] and blocks[j].t == "Header" do j = j + 1 end
    if j > i and is_image_para(blocks[j]) then
      local cap, consumed = figure_tail(blocks, j)
      if cap then
        out[#out + 1] = figure_reserve(blocks[j])
        for k = i, j - 1 do out[#out + 1] = blocks[k] end
        emit_figure(out, blocks[j], cap)
        i = j + consumed + 1
      else
        out[#out + 1] = b
        i = i + 1
      end
    elseif is_short_lead_in(b) and is_image_para(blocks[i + 1])
           and figure_tail(blocks, i + 1) then
      -- Lead-in line immediately followed by a captioned figure: keep together.
      local cap, consumed = figure_tail(blocks, i + 1)
      out[#out + 1] = figure_reserve(blocks[i + 1])
      out[#out + 1] = b
      emit_figure(out, blocks[i + 1], cap)
      i = i + consumed + 2
    elseif is_image_para(b) then
      local cap, consumed = figure_tail(blocks, i)
      if cap then
        emit_figure(out, b, cap)
        i = i + consumed + 1
      else
        set_image_width(b)
        append(out, { raw("\\begin{center}"), b, raw("\\end{center}") })
        i = i + 1
      end
    elseif is_figcap_block(b) or is_nopagebreak_block(b) then
      -- Orphaned \figcap / \nopagebreak (should be rare); pass through.
      out[#out + 1] = b
      i = i + 1
    elseif is_caption_para(b) then
      append(out, { raw("\\begin{center}\\color{figcap}"), b, raw("\\end{center}") })
      i = i + 1
    elseif b.t == "Para" and is_table_block(blocks[i + 1]) then
      -- Lead-in paragraph immediately followed by a table: keep them together,
      -- reserving room for the table plus the lead-in line.
      out[#out + 1] = table_reserve(blocks[i + 1], 1)
      out[#out + 1] = b
      out[#out + 1] = blocks[i + 1]
      i = i + 2
    elseif is_table_block(b) then
      out[#out + 1] = table_reserve(b, 0)
      out[#out + 1] = b
      i = i + 1
    else
      -- Keep short blocks after a header on the same page (paragraph, list, etc.).
      if b.t == "Header" then
        out[#out + 1] = raw("\\needspace{" .. HEADER_RESERVE .. "}")
      end
      out[#out + 1] = b
      i = i + 1
    end
  end
  doc.blocks = out
  return doc
end
