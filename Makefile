LDOC=lua ldoc.lua
PANDOC=pandoc
PDFLATEX=pdflatex

.PHONY: default test html pdf test clean

default: doc/ldoc.html
test: doc/ldoc.html doc/luatest.md doc/cctest.md doc/cctestg.md \
	doc/textest.tex
	diff doc/luatest.md test/ref/luatest.md
	diff doc/cctest.md test/ref/cctest.md
	diff doc/cctestg.md test/ref/cctestg.md
	diff doc/textest.tex test/ref/textest.tex

html: doc/ldoc.html doc/luatest.html doc/cctest.html
pdf:  doc/ldoc.pdf doc/luatest.pdf doc/cctest.pdf doc/test.pdf

doc/ldoc.md: ldoc.lua
	$(LDOC) -p pandoc -attribs '.lua' -o $@ $<

doc/luatest.md: test/luatest.lua
	$(LDOC) -p pandoc -attribs '.lua' -o $@ $<

doc/cctest.md: test/cctest.cc
	$(LDOC) -p pandoc -attribs '.c' -o $@ $<

doc/cctestg.md: test/cctest.cc
	$(LDOC) -p github -highlight cc -o $@ $<

doc/textest.tex: test/textest.cc
	lua ldoc.lua -p latex -class article -o $@ $<

doc/test.pdf: doc/test.tex doc/textest.tex
	(cd doc; $(PDFLATEX) test.tex)

%.pdf: %.md
	$(PANDOC) $< -o $@

%.html: %.md
	$(PANDOC) $< -s --toc -c pandoc.css \
		--highlight-style pygments -o $@

clean:
	rm -f doc/*.html doc/*.pdf doc/*.md doc/textest.tex
	rm -f doc/test.log doc/test.aux doc/test.pdf
	rm -f *~
