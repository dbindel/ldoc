DOCS=doc/ldoc.html
.PHONY: default html pdf test clean

default: test

html: $(DOCS)
pdf:  ${DOCS:.html=.pdf}

doc/%.md: %.lua
	lua ldoc.lua -p pandoc -o $@ $^

%.pdf: %.md
	pandoc $< -o $@

%.html: %.md
	pandoc $< -s --toc -c pandoc.css \
		--highlight-style pygments -o $@

clean:
	rm -f doc/*.html doc/*.pdf doc/*.md
	rm -f *~
	rm -f test/*~
