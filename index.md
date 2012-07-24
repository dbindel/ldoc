---
layout: default
title:  Literate Programming with LDoc 
---

## What it is

`ldoc` is a minimalist
[literate programming tool](http://en.wikipedia.org/wiki/Literate_programming)
written in Lua.  It interprets special block comments inside of a
piece of code as markup text, and produces a document in which this
text surrounds blocks of unadorned code.  It currently handles C
family languages and Lua on input, LaTeX and a few Markdown flavors on
output.  Adding new langauges and output formats is straightforward,
and I'll probably put in more as I need them.

The best documentation may be the [source to `ldoc` itself](ldoc.html).

## History

In the distant past, I used `noweb` for a project that I worked on,
a MEMS simulator called SUGAR.  It was a bit of a pain to install on
non-UNIX systems, so I couldn't get my collaborators to use it.
I also grew frustrated with it myself, largely because it broke many
of my tools.

But I continued think literate programming was a good idea.  So at a
point in the distant-but-slightly-less-so past, I wrote a minimalist
literate programming tool in C called
[dsbweb](http://www.cs.cornell.edu/~bindel/software.html).  It handled
documentation embedded in comments in many programming languages, but
generated only LaTeX.  I recently updated the code to handle Markdown
as well.  And then I thought, "I can do better..."
