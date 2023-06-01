LDOC=lua ldoc.lua
PANDOC=pandoc
QUARTO=quarto
PDFLATEX=pdflatex

.PHONY: default test html pdf gh clean

default: 
	$(LDOC) ldoc.lua -o ldoc.md
	
test: doc/ldoc.html doc/luatest.md doc/cctest.md doc/cctestg.md \
	doc/mtest.md doc/textest.tex doc/pytest.qmd doc/jltest.qmd
	diff doc/luatest.md test/ref/luatest.md
	diff doc/cctest.md test/ref/cctest.md
	diff doc/cctestg.md test/ref/cctestg.md
	diff doc/mtest.md test/ref/mtest.md
	diff doc/textest.tex test/ref/textest.tex
	diff doc/pytest.qmd test/ref/pytest.qmd
	diff doc/jltest.qmd test/ref/jltest.qmd

html: doc/ldoc.html doc/luatest.html doc/cctest.html doc/mtest.html
pdf:  doc/ldoc.pdf doc/luatest.pdf doc/cctest.pdf doc/mtest.html doc/test.pdf

gh:
	$(LDOC) -p github -highlight lua ldoc.lua -o ldoc-gh.md
	echo "---" > ldoc.md
	echo "layout: default" >> ldoc.md
	echo "title: ldoc source" >> ldoc.md
	echo "---" >> ldoc.md
	awk '!/^%/ { print}' ldoc-gh.md >> ldoc.md
	rm -f ldoc-gh.md

doc/ldoc.md: ldoc.lua
	$(LDOC) -p pandoc -attribs '.lua' -o $@ $<

doc/luatest.md: test/luatest.lua
	$(LDOC) -p pandoc -attribs '.lua' -o $@ $<

doc/cctest.md: test/cctest.cc
	$(LDOC) -p pandoc -attribs '.c' -o $@ $<

doc/cctestg.md: test/cctest.cc
	$(LDOC) -p github -highlight cc -o $@ $<

doc/mtest.md: test/mtest.m
	$(LDOC) -p pandoc -attribs '.matlab' -o $@ $<

doc/textest.tex: test/textest.cc
	$(LDOC) -p latex -class article -o $@ $<

doc/pytest.qmd: test/pytest.py
	$(LDOC) -p quarto -exec python -o $@ $<

doc/jltest.qmd: test/jltest.jl
	$(LDOC) -p quarto -exec julia -o $@ $<

doc/test.pdf: doc/test.tex doc/textest.tex
	(cd doc; $(PDFLATEX) test.tex)

doc/pytest.pdf: doc/pytest.qmd
	(cd doc; $(QUARTO) render pytest.qmd)

doc/jltest.pdf: doc/jltest.qmd
	(cd doc; $(QUARTO) render jltest.qmd)

%.pdf: %.md
	$(PANDOC) $< -o $@

%.html: %.md
	$(PANDOC) $< -s --toc -c pandoc.css \
		--highlight-style pygments -o $@

clean:
	rm -f doc/*.html doc/*.pdf doc/*.md doc/*.qmd doc/textest.tex
	rm -f doc/test.log doc/test.aux doc/test.pdf 
	rm -f *~
