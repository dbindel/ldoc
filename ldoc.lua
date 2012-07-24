--ldoc
--[[
% Lua documentation tool

The `ldoc` tool converts a Lua code file with intermixed text
documentation (in comments) into a markup language (Markdown).
A printer object provides methods to print lines of text and code,
and a main routine is responsible for deciding which is which,
and if anything should be printed at all.

## Printer base class

Each printer object is responsible for implementing `print_code` and
`print_line` routines that print code lines and ordinary text lines.
A generic printer class defines the `new` method used to actually
instantiate new printers.
--]]

Printer = {}
Printer.__index = Printer

function Printer:new(tbl)
   tbl = tbl or {}
   tbl.__index = tbl
   setmetatable(tbl, self)
   return tbl
end

--[[
## Generic Markdown printer

The default printer generates standard Markdown.  Code is indented
four spaces; everything else passes through unaltered.
--]]

local MarkdownPrinter = Printer:new()

function MarkdownPrinter:print_code(line)
   self.fp:write("    " .. line .. "\n")
end

function MarkdownPrinter:print_text(line)
   self.fp:write(line .. "\n")
end

--[[
## Pandoc Markdown printer

The Pandoc processor recognizes an extension where code regions
are demarcated by lines of tildes.  Using this convention, we can
pass through labels saying that we're processing Lua code.

We keep track of whether or not we're in a code block with the
`in_code` member variable.  If we're not in a code block, we start one
with the first non-blank code line we encounter.  We skip blank lines
to avoid completely empty code blocks.  If we are in a code block, we
exit it the next time we see a text line.
--]]

local PandocPrinter = Printer:new()

function PandocPrinter:print_code(line)
   if not self.in_code and string.find(line, "%S") then
      self.fp:write("\n~~~~~~~~~~~~~~~~~~~~~~~~~~~ {.lua}\n")
      self.in_code = true
   end
   if self.in_code then self.fp:write(line .. "\n") end
end

function PandocPrinter:print_text(line)
   if self.in_code then
      self.fp:write("~~~~~~~~~~~~~~~~~~~~~~~~~~~\n\n")
      self.in_code = false
   end
   self.fp:write(line .. "\n")
end

--[[
## Processing input files

The Lua documentation tool can be toggled on or off with a special
comment line beginning with `--ldoc`.  Comments of the form `--ldoc on`
or `--ldoc off` turn the documentation on or off; `--ldoc` with nothing
else toggles the current state.  By default, documentation is
assumed to be turned off.  When documentation is turned on, text in
block comments is sent directly to the output, while text outside of
block comments is indented by four characters (indicating a Markdown
code block).
--]]

local function ldoc(lname,printer)
   local printing, in_text
   for line in io.lines(lname) do
      if string.find(line, "%s*%-%-ldoc%s+on") == 1 then
         printing = true
      elseif string.find(line, "%s*%-%-ldoc%s+off") == 1 then
         printing = false
      elseif string.find(line, "%s*%-%-ldoc") == 1 then
         printing = not printing
      elseif string.find(line, "%s*%-%-%[%[") == 1 then
         in_text = true
      elseif string.find(line, "%s*%-%-%]%]") == 1 then
         in_text = false
      elseif printing then
         if in_text then printer:print_text(line)
         else            printer:print_code(line)
         end
      end
   end
   printer:print_text("")
end

--[[
## Main routine

The `main` routine runs a list of files through the `ldoc` processor.
If the argument list includes something of the form `-o ofname`, then
output is directed to `ofname`; otherwise, output goes to the standard
output.  We select a printer using the `-p` option; choices are
`markdown` and `pandoc`.
--]]

local printers = {
   markdown = MarkdownPrinter,
   pandoc   = PandocPrinter
}

local function main(args)

   local oname               -- Output file name
   local pname = "markdown"  -- Printer name
   local fnames = {}         -- Input file names
   local skip = 0            -- Arguments to skip

   -- Option processing
   for i=1,#args do
      local function process_flag(k)
         skip = k
         return args[i+1]
      end
      if     skip > 0        then skip = skip-1
      elseif args[i] == "-o" then oname = process_flag(1)
      elseif args[i] == "-p" then pname = process_flag(1)
      else                        table.insert(fnames, args[i])
      end
   end

   -- Check argument correctness
   assert(printers[pname], "Unknown printer: " .. pname)

   -- Set up printer and write files
   local fp = (oname and io.open(oname, "w+")) or io.stdout
   local printer = printers[pname]:new{fp=fp}
   for i,t in ipairs(fnames) do ldoc(t,printer) end
   if fp ~= io.stdout then fp:close() end

end

main {...}
